
import os
import re
import time
import subprocess
import psycopg2
import json
DATABASE_HOST = "localhost"
DATABASE_PORT = 5432
DATABASE_NAME = "your_database_name"
DATABASE_USER = "your_username"

# 300 seconds  or your_timeout
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
# Extract join/scan nodes from the execution plan and construct a binary tree structure.
# If the node type is a join (e.g., Nested Loop, Hash Join, Merge Join), return a dictionary:
# {"type": "join", "op": join type with whitespace removed, "left": left subtree, "right": right subtree}
# If the node type contains "Scan", return a scan node dictionary:
# {"type": "scan", "alias": alias name, "scan_op": scan type with whitespace removed}
# If the node is neither a join nor a scan but contains subplans, recursively process all subplans.
# If there are multiple valid subtrees, merge them into a left-deep join tree.

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
        # for non-join, non-scan nodes, recursively process all child nodes
        child_trees = [extract_join_tree(child) for child in plan["Plans"]]
        # filter out None
        child_trees = [t for t in child_trees if t is not None]
        if not child_trees:
            return None
        # if there is only one child tree, return it directly
        if len(child_trees) == 1:
            return child_trees[0]
        # if there are multiple child trees, construct a left-deep join tree (use "DummyJoin" as the join operation)
        tree = child_trees[0]
        for child in child_trees[1:]:
            tree = {"type": "join", "op": "DummyJoin", "left": tree, "right": child}
        return tree
    return None

def flatten_join_tree(tree):
    """
    Recursively traverse the join tree, returning a list of alias names from left to right.
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
    Recursively collect information about all join nodes, returning a list of tuples (join operation, list of alias names for all scan nodes in this subtree).
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
    Recursively collect information about all scan nodes, returning a list of tuples (scan operation, alias name).
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
    Original version, generate nested parentheses representation based on the actual structure of the join tree:
    For scan nodes, return their alias names directly; for join nodes, return a string like: (left subtree right subtree).
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
    Modified version of the Leading string generation function:
    If a DummyJoin is encountered and print_dummy_join is False, merge the left and right subtrees directly (without adding additional parentheses).
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
    Main function: Convert the JSON format query plan into a bracket format hint, example format:
    
    /*+ NestedLoop(site tag tag_question question)
     NestedLoop(site tag tag_question)
     NestedLoop(site tag)
     IndexScan(site)
     IndexScan(tag)
     IndexScan(tag_question)
     IndexScan(question)
     Leading((((site tag) tag_question) question)) */
    
    Only consider scan and join operations.
    
    New parameter print_dummy_join:
      - If True, print all join nodes (including DummyJoin nodes);
      - If False, skip DummyJoin nodes in the output and fold the DummyJoin level in the Leading hint.
    """
    # Parse the JSON string
    plan_data = json.loads(plan_json_str)
    # If the outermost layer has a "Plan" key, use its internal object as the root node
    if "Plan" in plan_data:
        root_plan = plan_data["Plan"]
    else:
        root_plan = plan_data

    # Extract join tree
    join_tree = extract_join_tree(root_plan)
    lines = []
    if join_tree is not None:
        # Collect join node information, output in order from low level to high level
        join_nodes = collect_join_nodes(join_tree)
        for op, aliases in reversed(join_nodes):
            # When not printing DummyJoin, skip this node
            if op == "DummyJoin" and not print_dummy_join:
                continue
            lines.append(f"{op}(" + " ".join(aliases) + ")")
        # Collect scan node information
        for scan_op, alias in collect_scans(join_tree):
            lines.append(f"{scan_op}({alias})")
        # Generate Leading hint, select using original or modified version
        if print_dummy_join:
            leading_str = build_leading_string_from_tree(join_tree)
        else:
            leading_str = build_leading_string_from_tree_modified(join_tree, print_dummy_join)
        lines.append(f"Leading({leading_str})")
    else:
        # If there is only a scan node
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