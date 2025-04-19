import os

exclude_set = set()

def merge_sql_with_bracket_hints(dir_a, dir_b, output_file):
    """
    将 dir_a 下的各个 .sql 文件与 dir_b 下对应的 
    _bracket_hint.txt 文件合并为一个 output_file 文件。

    合并规则：
    - 添加SQL文件名注释（如：-- 2a10.sql）
    - 注释 + 换行 + bracket_hint 内容 + 换行 + SQL 内容 + 换行换行
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
            
            with open(bracket_hint_map[key], 'r', encoding='utf-8') as bh_f:
                bracket_hint_content = bh_f.read().strip()
            with open(sql_map[key], 'r', encoding='utf-8') as sql_f:
                sql_content = sql_f.read().strip()
            
            # 拼接注释、bracket_hint 内容和 SQL 内容
            merged_text = comment_line + '\n' + bracket_hint_content + '\n' + sql_content
            
            # 如果不是最后一项，则添加额外换行符分隔
            if idx < len(valid_keys) - 1:
                out_f.write(merged_text + '\n\n\n')
            else:
                out_f.write(merged_text)
    
    print(f"合并完成，输出文件为: {output_file}")

# 示例调用
merge_sql_with_bracket_hints(
    '/home/qihanzha/LLM4QO/sql/so_within_transfer', 
    '/home/qihanzha/LLM4QO/src/stack_inspect/original_hints_real_execution/so_within_transfer', 
    '/home/qihanzha/LLM4QO/src/stack_inspect/so_within_transfe_original_with_time.sql'
)
