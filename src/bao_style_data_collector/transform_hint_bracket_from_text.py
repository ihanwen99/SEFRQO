import ast
import re

def extract_join_tree(plan):
    """
    从执行计划中提取出连接/扫描节点，构造成二叉树结构。
    如果节点类型是连接(Nested Loop、Hash Join、Merge Join)，返回字典：
       {"type": "join", "op": 去空格后的连接类型, "left": 左子树, "right": 右子树}
    如果节点类型包含Scan，则返回扫描节点字典：
       {"type": "scan", "alias": 别名, "scan_op": 去空格后的扫描类型}
    如果节点既不是我们关心的连接，也不是扫描，但有唯一子节点，则递归处理其子节点。
    """
    node_type = plan.get("Node Type", "")
    if node_type in ("Nested Loop", "Hash Join", "Merge Join"):
        plans = plan.get("Plans", [])
        if len(plans) >= 2:
            left_tree = extract_join_tree(plans[0])
            right_tree = extract_join_tree(plans[1])
            op = node_type.replace(" ", "")
            return {"type": "join", "op": op, "left": left_tree, "right": right_tree}
        elif "Plans" in plan and plan["Plans"]:
            return extract_join_tree(plan["Plans"][0])
        else:
            return None
    elif "Scan" in node_type:
        alias = plan.get("Alias") or plan.get("Relation Name") or ""
        op = node_type.replace(" ", "")
        return {"type": "scan", "alias": alias, "scan_op": op}
    else:
        if "Plans" in plan and len(plan["Plans"]) == 1:
            return extract_join_tree(plan["Plans"][0])
        return None

def flatten_join_tree(tree):
    """
    递归遍历 join 树，返回左到右的扫描节点别名列表。
    """
    if tree is None:
        return []
    if tree["type"] == "scan":
        return [tree["alias"]]
    elif tree["type"] == "join":
        return flatten_join_tree(tree["left"]) + flatten_join_tree(tree["right"])
    return []

def collect_join_nodes(tree):
    """
    递归收集所有连接节点的信息，每个节点返回 (连接操作, 此子树内所有扫描节点别名列表)。
    """
    if tree is None or tree["type"] == "scan":
        return []
    aliases = flatten_join_tree(tree)
    nodes = []
    nodes.extend(collect_join_nodes(tree["left"]))
    nodes.extend(collect_join_nodes(tree["right"]))
    nodes.append((tree["op"], aliases))
    return nodes

def collect_scans(tree):
    """
    递归收集所有扫描节点的信息，返回 (扫描操作, 别名) 的列表。
    """
    if tree is None:
        return []
    if tree["type"] == "scan":
        return [(tree["scan_op"], tree["alias"])]
    elif tree["type"] == "join":
        return collect_scans(tree["left"]) + collect_scans(tree["right"])
    return []

def build_leading_string_from_tree(tree):
    """
    根据连接树的实际结构生成嵌套的括号表示。
    对于扫描节点，直接返回其别名；对于连接节点，返回形如：(左子树 右子树) 的字符串。
    """
    if tree is None:
        return ""
    if tree["type"] == "scan":
        return tree["alias"]
    elif tree["type"] == "join":
        left_str = build_leading_string_from_tree(tree["left"])
        right_str = build_leading_string_from_tree(tree["right"])
        return f"({left_str} {right_str})"
    return ""

def generate_plan_bracket(plan_json_str):
    """
    解析 JSON 字符串，提取连接树后生成括号表示的提示信息，并返回完整的提示内容。
    输出内容示例：
    
    /*+ NestLoop(q1 tq1 s t1 u1 acc b1)
     HashJoin(q1 tq1 s t1)
     ...
     SeqScan(q1)
     IndexScan(tq1)
     ...
     Leading((q1 (tq1 (s t1))) (u1 (acc b1))) */
    """
    try:
        plan_data = ast.literal_eval(plan_json_str)
    except Exception as e:
        return f"/*+ 解析计划失败：{e} */"
    
    # 如果根节点是 Aggregate，取其子节点作为起点
    if plan_data.get("Node Type") == "Aggregate" and "Plans" in plan_data:
        root_plan = plan_data["Plans"][0]
    else:
        root_plan = plan_data

    join_tree = extract_join_tree(root_plan)
    lines = []
    if join_tree is not None:
        # 生成各连接节点的提示行（按子树扫描别名列表，按从低层到高层顺序打印）
        join_nodes = collect_join_nodes(join_tree)
        for op, aliases in reversed(join_nodes):
            lines.append(f"{op}(" + " ".join(aliases) + ")")
        # 生成各扫描节点的提示行
        for scan_op, alias in collect_scans(join_tree):
            lines.append(f"{scan_op}({alias})")
        # 根据实际连接树生成 leading 提示
        leading_str = build_leading_string_from_tree(join_tree)
        lines.append(f"Leading({leading_str})")
    else:
        # 如果仅有扫描节点
        if "Scan" in root_plan.get("Node Type", ""):
            alias = root_plan.get("Alias") or root_plan.get("Relation Name") or ""
            op = root_plan.get("Node Type").replace(" ", "")
            lines.append(f"{op}({alias})")
            lines.append(f"Leading({alias})")
    
    output = "/*+ " + "\n ".join(lines) + " */"
    return output

def process_plan_file(input_path, output_path):
    """
    从指定的txt文本中读取多个查询计划块，
    每个块包括:
      - sql file: 文件名
      - sql: 原始SQL语句（可能多行）
      - detailed info: 执行计划（Python字典格式）
    解析后生成提示信息，并将提示信息与原始SQL一起写入一个combined SQL文件中，
    其中提示信息位于原始SQL之前。
    """
    with open(input_path, "r", encoding="utf-8") as f:
        content = f.read()
    
    # 按照每个"sql file:"分割（注意正则中使用多行模式）
    blocks = re.split(r"(?m)^sql file:", content)
    
    combined_output = ""
    for block in blocks:
        block = block.strip()
        if not block:
            continue
        # 第一行为文件名
        lines = block.splitlines()
        filename = lines[0].strip()
        sql_lines = []
        detailed_info_lines = []
        mode = None  # 当前读取状态：None, "sql", "detailed"
        for line in lines[1:]:
            if line.startswith("sql:"):
                mode = "sql"
                # 去掉前缀后余下部分加入sql_lines
                sql_lines.append(line[len("sql:"):].strip())
            elif line.startswith("detailed info:"):
                mode = "detailed"
                detailed_info_lines.append(line[len("detailed info:"):].strip())
            else:
                # 如果当前处于 sql 或 detailed 状态，则继续追加
                if mode == "sql":
                    sql_lines.append(line)
                elif mode == "detailed":
                    detailed_info_lines.append(line)
        sql_query = "\n".join(sql_lines).strip()
        detailed_info_str = " ".join(detailed_info_lines).strip()
        
        # 生成括号形式的提示信息
        hint_comment = generate_plan_bracket(detailed_info_str)
        
        # 将提示信息与原始SQL的顺序交换：提示信息在前，原始SQL在后
        block_output = f"-- sql file: {filename}\n" \
                       f"{hint_comment}\n" \
                       f"{sql_query}\n\n"
        combined_output += block_output

    with open(output_path, "w", encoding="utf-8") as f_out:
        f_out.write(combined_output)
    print(f"生成合并的SQL文件：{output_path}")

# -------------------- 示例入口 --------------------
if __name__ == "__main__":
    # 如果你有一个包含多个查询计划块的文本文件，比如 'best_plans.txt'
    input_txt = "best_plans.txt"        # 输入文件，需自行准备
    output_sql = "SO_SQL_best.sql"         # 输出文件
    process_plan_file(input_txt, output_sql)
