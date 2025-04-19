import csv

def parse_log_file(log_file, output_csv):
    """
    解析日志文件，提取每个 SQL 文件对应的 Bao 和 Postgres 执行时间，
    并将结果写入 CSV 文件中。
    
    日志文件示例格式：
        sql file: job16a.sql
        Bao execution time: 64.423

        sql file: job16a.sql
        Postgres execution time: 64.423
        ...
    
    :param log_file: 日志文件路径
    :param output_csv: 输出 CSV 文件路径
    """
    data = {}  # 字典，key 为 sql 文件名，value 为 {'Bao': 执行时间, 'Postgres': 执行时间}
    current_file = None
    
    with open(log_file, 'r', encoding='utf-8') as f:
        lines = f.readlines()
    
    for line in lines:
        line = line.strip()
        if not line:
            continue
        if line.startswith("sql file:"):
            # 提取 sql 文件名
            current_file = line.split("sql file:")[1].strip()
            if current_file not in data:
                data[current_file] = {}
        elif line.startswith("Bao execution time:"):
            time_str = line.split("Bao execution time:")[1].strip()
            try:
                time_val = float(time_str)
            except Exception as e:
                time_val = None
            if current_file:
                data[current_file]['Bao'] = time_val
        elif line.startswith("Postgres execution time:"):
            time_str = line.split("Postgres execution time:")[1].strip()
            try:
                time_val = float(time_str)
            except Exception as e:
                time_val = None
            if current_file:
                data[current_file]['Postgres'] = time_val

    # 写入 CSV 文件
    with open(output_csv, 'w', newline='', encoding='utf-8') as csvfile:
        fieldnames = ['sql_file', 'bao_execution_time', 'postgres_execution_time']
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
        writer.writeheader()
        for file_name, times in data.items():
            writer.writerow({
                'sql_file': file_name,
                'bao_execution_time': times.get('Bao', ''),
                'postgres_execution_time': times.get('Postgres', '')
            })
    print(f"CSV 文件已生成：{output_csv}")


if __name__ == "__main__":
    # 修改下面的路径为你的实际路径
    log_file_path = "/home/qihanzha/LLM4QO/src/bao_style_data_collector/best_plans_execution_time_stackoverflow.txt"          # 包含执行时间信息的日志文件
    output_csv_path = "execution_times_stackoverflow.csv"  # 输出 CSV 文件路径

    parse_log_file(log_file_path, output_csv_path)
