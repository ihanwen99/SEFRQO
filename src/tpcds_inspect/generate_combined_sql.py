import os
# exclude_set = set()
exclude_set = set([4, 6, 11, 54, 74, 95])

def merge_sql_with_bracket_hints(dir_a, dir_b, output_file):
    """
    将 dir_a 下的 01.sql, 02.sql, ... 99.sql 与 dir_b 下对应的 
    01_bracket_hint.txt, 02_bracket_hint.txt, ... 99_bracket_hint.txt
    合并为一个 output_file 文件。

    合并规则：
    - 添加SQL文件名注释（如：-- 01.sql）
    - 注释 + 换行 + bracket_hint 内容 + 换行 + SQL 内容 + 换行换行
    - 若缺少对应文件则跳过该编号
    - 最后一个合并项不输出额外的换行符
    """
    
    # 收集所有 bracket_hint 文件的路径，形式为 { '01': 'fullpath/01_bracket_hint.txt', ... }
    bracket_hint_map = {}
    for filename in os.listdir(dir_b):
        if filename.endswith('_bracket_hint.txt'):
            prefix = filename.split('_bracket_hint.txt')[0]
            bracket_hint_map[prefix] = os.path.join(dir_b, filename)
    
    # 收集所有 SQL 文件的路径，形式为 { '01': 'fullpath/01.sql', ... }
    sql_map = {}
    for filename in os.listdir(dir_a):
        if filename.endswith('.sql'):
            prefix, _ = os.path.splitext(filename)
            sql_map[prefix] = os.path.join(dir_a, filename)
    
    # 先收集所有有效的编号，保证后续写入时可以判断最后一个文件
    valid_prefixes = []
    for i in range(1, 100):
        if i in exclude_set:
            continue
        prefix = str(i).zfill(2)
        if prefix in bracket_hint_map and prefix in sql_map:
            valid_prefixes.append(prefix)
    
    # 打开输出文件进行写入
    with open(output_file, 'w', encoding='utf-8') as out_f:
        for idx, prefix in enumerate(valid_prefixes):
            # 获取 SQL 文件名作为注释
            sql_filename = os.path.basename(sql_map[prefix])
            comment_line = f"-- {sql_filename}"
            
            with open(bracket_hint_map[prefix], 'r', encoding='utf-8') as bh_f:
                bracket_hint_content = bh_f.read().strip()  # 去除前后空白和换行
            with open(sql_map[prefix], 'r', encoding='utf-8') as sql_f:
                sql_content = sql_f.read().strip()  # 去除前后空白和换行
            
            # 拼接注释、bracket_hint 和 SQL 内容
            merged_text = comment_line + '\n' + bracket_hint_content + '\n' + sql_content
            
            # 如果不是最后一项，则添加两个换行作为分隔；否则不添加
            if idx < len(valid_prefixes) - 1:
                out_f.write(merged_text + '\n\n\n')
            else:
                out_f.write(merged_text)
    
    print(f"合并完成，输出文件为: {output_file}")

# 示例调用
merge_sql_with_bracket_hints(
    '/home/qihanzha/LLM4QO/sql/tpcds', 
    '/home/qihanzha/LLM4QO/src/tpcds_inspect/original_hints', 
    '/home/qihanzha/LLM4QO/src/tpcds_inspect/TPCDS_original_no_slow.sql'
)
