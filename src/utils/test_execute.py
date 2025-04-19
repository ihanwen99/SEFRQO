
import os
import re
import time
import subprocess
import psycopg2
import json
DATABASE_HOST = "localhost"
DATABASE_PORT = 5438
DATABASE_NAME = "imdbload"
DATABASE_USER = "qihanzha"

# 300 seconds 
DATABASE_TIMEOUT = 300000

CONNECTION_INFO = {
        "host": DATABASE_HOST,
        "port": DATABASE_PORT,
        "database": DATABASE_NAME,
        "user": DATABASE_USER,
    }
import psycopg2
import time
import json


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

def print_plan_bracket(plan_json_str, print_dummy_join=True):
    """
    主函数：将 JSON 格式的查询计划转换为括号形式提示信息，格式示例：
    
    /*+ NestedLoop(site tag tag_question question)
     NestedLoop(site tag tag_question)
     NestedLoop(site tag)
     IndexScan(site)
     IndexScan(tag)
     IndexScan(tag_question)
     IndexScan(question)
     Leading((((site tag) tag_question) question)) */
    
    仅考虑扫描与连接操作。
    
    新增参数 print_dummy_join:
      - 若为 True，则打印所有连接节点（包括 DummyJoin 节点）；
      - 若为 False，则在输出中跳过 DummyJoin 节点，并在 Leading 提示中折叠掉 DummyJoin 层级。
    """
    # 解析 JSON 字符串
    plan_data = json.loads(plan_json_str)
    # 如果最外层有 "Plan" 键，则使用其内部对象作为根节点
    if "Plan" in plan_data:
        root_plan = plan_data["Plan"]
    else:
        root_plan = plan_data

    # 提取连接树
    join_tree = extract_join_tree(root_plan)
    lines = []
    if join_tree is not None:
        # 收集连接节点信息，按从低层到高层顺序输出
        join_nodes = collect_join_nodes(join_tree)
        for op, aliases in reversed(join_nodes):
            # 当不打印 DummyJoin 时，跳过此节点
            if op == "DummyJoin" and not print_dummy_join:
                continue
            lines.append(f"{op}(" + " ".join(aliases) + ")")
        # 收集扫描节点信息
        for scan_op, alias in collect_scans(join_tree):
            lines.append(f"{scan_op}({alias})")
        # 生成 Leading 提示，按标志选择使用原始或修改版本
        if print_dummy_join:
            leading_str = build_leading_string_from_tree(join_tree)
        else:
            leading_str = build_leading_string_from_tree_modified(join_tree, print_dummy_join)
        lines.append(f"Leading({leading_str})")
    else:
        # 如果仅有扫描节点
        if "Scan" in root_plan.get("Node Type", ""):
            alias = root_plan.get("Alias") or root_plan.get("Relation Name") or ""
            op = root_plan.get("Node Type").replace(" ", "")
            lines.append(f"{op}({alias})")
            lines.append(f"Leading({alias})")
    
    output = "/*+ " + "\n ".join(lines) + " */"
    print(output)
    return output

def execute_sql(sql_query, print_dummy_join=False):
    """
    Executes an SQL query that already includes EXPLAIN (ANALYZE, FORMAT JSON),
    extracts the execution time from the returned JSON, and generates a bracket-style query plan hint.
    
    Parameters:
      sql_query: The SQL statement that includes EXPLAIN (ANALYZE, FORMAT JSON)
      print_dummy_join: Whether to include DummyJoin nodes in the bracket hint

    Returns:
      (execution_time, bracket_plan)
        execution_time: Query execution time in milliseconds
        bracket_plan: Bracket-style query plan hint as a string
    """
    exec_time = None
    bracket_plan = None
    connection = None
    cursor = None
    try:
        connection = psycopg2.connect(
            host=DATABASE_HOST,      
            database=DATABASE_NAME,    
            user=DATABASE_USER,
            port=DATABASE_PORT,
        )
        connection.autocommit = True  
        cursor = connection.cursor()
        cursor.execute(f"SET statement_timeout = {DATABASE_TIMEOUT};") 
        cursor.execute("load 'pg_hint_plan';")
        cursor.execute('DISCARD ALL;')  

        # Execute the SQL query that includes EXPLAIN (ANALYZE, FORMAT JSON)
        cursor.execute(sql_query)
        result = cursor.fetchone()
        
        if result is not None:
            json_data = result[0]
            if isinstance(json_data, str):
                json_data = json.loads(json_data)
            # The EXPLAIN result is generally a list containing a single dictionary
            if isinstance(json_data, list) and len(json_data) > 0:
                exec_time = json_data[0].get("Execution Time")
                # print(f"Query execution time: {exec_time} ms")
                # Convert json_data to a string for use in print_plan_bracket
                plan_json_str = json.dumps(json_data[0])
                # Call the helper function to generate the bracket-style hint.
                # Note: This function also extracts execution time from the JSON.
                bracket_plan = print_plan_bracket(plan_json_str, print_dummy_join=print_dummy_join)
            else:
                print("Unexpected JSON structure:", json_data)
        else:
            print("No result returned from query execution")
    except Exception as error:
        print(f"Error: {error}")
    finally:
        if cursor is not None:
            cursor.close()
        if connection is not None:
            connection.close()
    return exec_time, bracket_plan



# read sql from file
def read_sql_from_file(file_path):
    with open(file_path, "r") as file:
        sql = file.read()
    return sql

execute_sql(read_sql_from_file("/home/qihanzha/LLM4QO/src/utils/test_hint2.sql"))