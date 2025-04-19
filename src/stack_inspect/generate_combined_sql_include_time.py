import os
import json

exclude_set = set()

def remove_sql_comments(sql_content):
    """
    去除 SQL 内容中的所有注释。
    对于每一行：
      - 如果整行是注释，则跳过
      - 否则，如果行内存在 '--'，则只保留其之前的部分（注意：如果 '--' 出现在字符串字面量中，此方法可能不够严谨）
    """
    cleaned_lines = []
    for line in sql_content.splitlines():
        stripped = line.strip()
        # 如果整行以--开头，则忽略该行
        if stripped.startswith('--'):
            continue
        # 如果存在行内注释，则去除注释部分
        if '--' in line:
            line = line.split('--')[0].rstrip()
        # 仅添加非空行
        if line.strip():
            cleaned_lines.append(line)
    return "\n".join(cleaned_lines)

def merge_sql_with_bracket_hints(dir_a, dir_b, output_file):
    """
    将 dir_a 下的各个 .sql 文件与 dir_b 下对应的 
    _bracket_hint.txt 文件合并为一个 output_file 文件，同时
    读取对应的 JSON 文件（如 2a10.json），获取 "Execution Time" 对应的值，
    并在 SQL 文件名注释下方添加一行新的注释（如：-- 281.262）。

    合并规则：
    - 添加SQL文件名注释（如：-- 2a10.sql）
    - 若存在对应 JSON 文件且能获取到 "Execution Time"，则添加一行注释，如：-- 281.262
    - 注释/注释 + 换行 + bracket_hint 内容 + 换行 + SQL 内容 + 换行换行
    - 若缺少对应文件则跳过该文件
    - 最后一个合并项不输出额外的换行符
    """
    
    # 收集所有 bracket_hint 文件的路径，形式为 { '2a10': 'fullpath/2a10_bracket_hint.txt', ... }
    bracket_hint_map = {}
    for filename in os.listdir(dir_b):
        if filename.endswith('_bracket_hint.txt'):
            prefix = filename[:-len('_bracket_hint.txt')]
            bracket_hint_map[prefix] = os.path.join(dir_b, filename)
    
    # 收集所有 SQL 文件的路径，形式为 { '2a10': 'fullpath/2a10.sql', ... }
    sql_map = {}
    for filename in os.listdir(dir_a):
        if filename.endswith('.sql'):
            prefix, _ = os.path.splitext(filename)
            sql_map[prefix] = os.path.join(dir_a, filename)
    
    # 获取两边都存在的 key 集合，并可选排除某些特定的 key
    valid_keys = sorted(set(sql_map.keys()) & set(bracket_hint_map.keys()))
    valid_keys = [key for key in valid_keys if key not in exclude_set]
    
    # 打开输出文件进行写入
    with open(output_file, 'w', encoding='utf-8') as out_f:
        for idx, key in enumerate(valid_keys):
            # 获取 SQL 文件名作为注释（如 -- 2a10.sql）
            sql_filename = os.path.basename(sql_map[key])
            comment_line = f"-- {sql_filename}"
            
            # 读取对应 JSON 文件，获取 "Execution Time" 的值（如果存在）
            json_file = os.path.join(dir_b, key + ".json")
            exec_time_comment = ""
            if os.path.exists(json_file):
                try:
                    with open(json_file, 'r', encoding='utf-8') as jf:
                        data = json.load(jf)
                        exec_time = data.get("Execution Time")
                        if exec_time is not None:
                            exec_time_comment = f"-- {exec_time}"
                except Exception as e:
                    print(f"读取 {json_file} 时出错: {e}")
            
            with open(bracket_hint_map[key], 'r', encoding='utf-8') as bh_f:
                bracket_hint_content = bh_f.read().strip()
            with open(sql_map[key], 'r', encoding='utf-8') as sql_f:
                sql_content = sql_f.read().strip()
            # 去除原始 SQL 中的所有注释
            sql_content = remove_sql_comments(sql_content)
            
            # 构建最终合并文本：
            # 如果存在 execution time 则插入新的注释行，否则直接使用原有注释行
            merged_lines = [comment_line]
            if exec_time_comment:
                merged_lines.append(exec_time_comment)
            merged_lines.append(bracket_hint_content)
            merged_lines.append(sql_content)
            merged_text = "\n".join(merged_lines)
            
            # 如果不是最后一项，则添加额外换行符分隔
            if idx < len(valid_keys) - 1:
                out_f.write(merged_text + '\n\n\n')
            else:
                out_f.write(merged_text)
    
    print(f"合并完成，输出文件为: {output_file}")

# 示例调用 so_assorted so_within_transfer
merge_sql_with_bracket_hints(
    '/home/qihanzha/LLM4QO/sql/so_within_transfer', 
    '/home/qihanzha/LLM4QO/src/stack_inspect/original_hints_real_execution/so_within_transfer', 
    '/home/qihanzha/LLM4QO/src/stack_inspect/so_within_transfer_original_with_time.sql'
)
