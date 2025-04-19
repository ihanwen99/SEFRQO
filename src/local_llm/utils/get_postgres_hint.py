import psycopg2
import json
import os
import re

def extract_hint_block(action_sequence):
    # find the first occurrence of the assistant keyword
    assistant_match = re.search(r'\bassistant\b', action_sequence, re.IGNORECASE)
    if not assistant_match:
        return None  
    
    # extract the assistant content after the keyword
    assistant_start = assistant_match.end()
    assistant_content = action_sequence[assistant_start:].lstrip()
    
    # find the first hint block enclosed by '/*+' and '*/'
    hint_block = re.search(r'/\*\+.*?\*/', assistant_content, re.DOTALL)
    
    return hint_block.group(0).strip() if hint_block else " "

def extract_sql_hint_from_text_chunk(text):
    """
    从输入文本中提取以 /*+ 开始、以 */ 结束的 SQL hint，返回包含包围字符的匹配项。
    如果未找到匹配项，则返回 None。
    """
    pattern = r"(\/\*\+.*?\*\/)"
    match = re.search(pattern, text, re.DOTALL)
    if match:
        return match.group(1)
    return " "

def get_explain_plan_json(original_sql, connection_info,real_execution,sql_name):
    
    connection_info_cp = connection_info.copy()
    # remove the property timeout in dictionary connection_info, if exists
    if 'timeout' in connection_info_cp:
        del connection_info_cp['timeout']

    
    # 2. 拼接 EXPLAIN 语句
    # explain_sql = f"EXPLAIN (ANALYZE, FORMAT JSON) {original_sql};"
    if real_execution:
        # sql_name is like 74.sql, now weextrach the number 74
        sql_number = sql_name.split(".")[0]
        # get the stored json file 74.json in the /home/qihanzha/LLM4QO/src/tpcds_inspect/original_hints_real_execution folder
        json_file_path = f"/home/qihanzha/LLM4QO/src/tpcds_inspect/original_hints_real_execution/{sql_number}.json"
        with open(json_file_path, "r") as f:
            plan_json_str = f.read()
        return plan_json_str
        #explain_sql = f"EXPLAIN (ANALYZE, FORMAT JSON) {original_sql};"
    else:
        explain_sql = f"EXPLAIN (FORMAT JSON) {original_sql};"

        # 3. 执行拼接后的 SQL 并获取结果
        with psycopg2.connect(**connection_info_cp) as conn:
            with conn.cursor() as cur:
                cur.execute(explain_sql)
                # EXPLAIN (FORMAT JSON) 通常只返回一行一列, 形如 [(json_string, )]
                result = cur.fetchall()
                plan_json_str = result[0][0]  # 取第 0 行第 0 列
    
        # 4. 直接返回 JSON 字符串
        return json.dumps(plan_json_str[0])

def extract_join_tree(plan):
    """
    从执行计划中提取连接/扫描节点，构造成二叉树结构。
    如果节点类型是连接（Nested Loop、Hash Join、Merge Join），返回字典：
       {"type": "join", "op": 去空格后的连接类型, "left": 左子树, "right": 右子树}
    如果节点类型包含 Scan，则返回扫描节点字典：
       {"type": "scan", "alias": 别名, "scan_op": 去空格后的扫描类型}
    如果节点既非连接也非扫描，但存在子计划，则递归处理所有子计划，
    如果有多个有效子树，则将它们合并为一个左深的连接树。
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
    elif "Plans" in plan:
        # 对于非连接、非扫描节点，递归处理所有子节点
        child_trees = [extract_join_tree(child) for child in plan["Plans"]]
        # 过滤掉 None
        child_trees = [t for t in child_trees if t is not None]
        if not child_trees:
            return None
        # 如果只有一个子树，则直接返回
        if len(child_trees) == 1:
            return child_trees[0]
        # 如果有多个子树，则构造左深树（这里用 "DummyJoin" 作为连接操作）
        tree = child_trees[0]
        for child in child_trees[1:]:
            tree = {"type": "join", "op": "DummyJoin", "left": tree, "right": child}
        return tree
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
    原始版本，根据连接树的实际结构生成嵌套括号表示：
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

def build_leading_string_from_tree_modified(tree, print_dummy_join):
    """
    修改版本的 Leading 字符串生成函数：
    如果遇到 DummyJoin 且 print_dummy_join 为 False，则直接将左右子树合并（不额外添加括号）。
    """
    if tree is None:
        return ""
    if tree["type"] == "scan":
        return tree["alias"]
    elif tree["type"] == "join":
        left_str = build_leading_string_from_tree_modified(tree["left"], print_dummy_join)
        right_str = build_leading_string_from_tree_modified(tree["right"], print_dummy_join)
        if tree["op"] == "DummyJoin" and not print_dummy_join:
            return left_str + " " + right_str
        else:
            return f"({left_str} {right_str})"
    return ""

def print_plan_bracket(plan_json_str, print_dummy_join=True, only_order=False):
    """
    Main function: Convert the JSON-formatted query plan into a bracket-style hint.
    Example format:
    
    /*+ NestedLoop(site tag tag_question question)
     NestedLoop(site tag tag_question)
     NestedLoop(site tag)
     IndexScan(site)
     IndexScan(tag)
     IndexScan(tag_question)
     IndexScan(question)
     Leading((((site tag) tag_question) question)) */
    
    Only considers scan and join operations.
    
    Additional parameter print_dummy_join:
      - If True, prints all join nodes (including DummyJoin nodes);
      - If False, skips DummyJoin nodes and collapses DummyJoin levels in the Leading hint.
    
    If only_order is False, the function works as usual.
    Otherwise, it only returns the Leading hint portion.
    """
    # Parse the JSON string
    plan_data = json.loads(plan_json_str)
    # If the outer level has a "Plan" key, use its inner object as the root plan
    if "Plan" in plan_data:
        root_plan = plan_data["Plan"]
    else:
        root_plan = plan_data

    # Extract the join tree
    join_tree = extract_join_tree(root_plan)
    
    # If only_order is True, only return the Leading hint part.
    if only_order:
        if join_tree is not None:
            if print_dummy_join:
                leading_str = build_leading_string_from_tree(join_tree)
            else:
                leading_str = build_leading_string_from_tree_modified(join_tree, print_dummy_join)
        else:
            # In case there is only a scan node
            if "Scan" in root_plan.get("Node Type", ""):
                alias = root_plan.get("Alias") or root_plan.get("Relation Name") or ""
                leading_str = alias
            else:
                leading_str = ""
        output = "/*+ Leading(" + leading_str + ") */"
        return output

    # Otherwise, proceed as before
    lines = []
    if join_tree is not None:
        # Collect join node information in order from lower to higher levels
        join_nodes = collect_join_nodes(join_tree)
        for op, aliases in reversed(join_nodes):
            # Skip DummyJoin nodes if print_dummy_join is False
            if op == "DummyJoin" and not print_dummy_join:
                continue
            lines.append(f"{op}(" + " ".join(aliases) + ")")
        # Collect scan node information
        for scan_op, alias in collect_scans(join_tree):
            lines.append(f"{scan_op}({alias})")
        # Generate the Leading hint using either the original or modified version
        if print_dummy_join:
            leading_str = build_leading_string_from_tree(join_tree)
        else:
            leading_str = build_leading_string_from_tree_modified(join_tree, print_dummy_join)
        lines.append(f"Leading({leading_str})")
    else:
        # If only scan nodes are present
        if "Scan" in root_plan.get("Node Type", ""):
            alias = root_plan.get("Alias") or root_plan.get("Relation Name") or ""
            op = root_plan.get("Node Type").replace(" ", "")
            lines.append(f"{op}({alias})")
            lines.append(f"Leading({alias})")
    
    output = "/*+ " + "\n ".join(lines) + " */"
    return output


def get_postgres_hint(original_sql, connection_info, sql_name,print_dummy_join=True, real_execution = False, only_order=False):
    plan_result = get_explain_plan_json(original_sql, connection_info,real_execution,sql_name)
    bracket_hint = print_plan_bracket(plan_result, print_dummy_join, only_order)
    return bracket_hint

def get_postgres_hint_json(original_sql, connection_info,REAL_EXECUTION,sql_name):
    plan_result = get_explain_plan_json(original_sql, connection_info,REAL_EXECUTION,sql_name)

    return plan_result
# if __name__ == "__main__":
#     # 使用示例
#     database = "tpcds1load"
#     connection_info = {
#         "host": "127.0.0.1",
#         "port": 5438,
#         "database": database,
#         "user": "qihanzha",
#     }
    
#     original_sql = """SELECT i_brand_id brand_id,
#        i_brand brand,
#        t_hour,
#        t_minute,
#        sum(ext_price) ext_price
# FROM item,
#   (SELECT ws_ext_sales_price AS ext_price,
#           ws_sold_date_sk AS sold_date_sk,
#           ws_item_sk AS sold_item_sk,
#           ws_sold_time_sk AS time_sk
#    FROM web_sales,
#         date_dim
#    WHERE d_date_sk = ws_sold_date_sk
#      AND d_moy=11
#      AND d_year=1999
#    UNION ALL SELECT cs_ext_sales_price AS ext_price,
#                     cs_sold_date_sk AS sold_date_sk,
#                     cs_item_sk AS sold_item_sk,
#                     cs_sold_time_sk AS time_sk
#    FROM catalog_sales,
#         date_dim
#    WHERE d_date_sk = cs_sold_date_sk
#      AND d_moy=11
#      AND d_year=1999
#    UNION ALL SELECT ss_ext_sales_price AS ext_price,
#                     ss_sold_date_sk AS sold_date_sk,
#                     ss_item_sk AS sold_item_sk,
#                     ss_sold_time_sk AS time_sk
#    FROM store_sales,
#         date_dim
#    WHERE d_date_sk = ss_sold_date_sk
#      AND d_moy=11
#      AND d_year=1999 ) tmp,
#      time_dim
# WHERE sold_item_sk = i_item_sk
#   AND i_manager_id=1
#   AND time_sk = t_time_sk
#   AND (t_meal_time = 'breakfast'
#        OR t_meal_time = 'dinner')
# GROUP BY i_brand,
#          i_brand_id,
#          t_hour,
#          t_minute
# ORDER BY ext_price DESC NULLS FIRST,
#          i_brand_id NULLS FIRST,
#          t_hour NULLS FIRST;
# """
#     res = get_postgres_hint(original_sql, connection_info, "71.sql",print_dummy_join=False, real_execution=False)
#     print(res)
    
    
    
