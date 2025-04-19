import ast

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
    # 当前连接节点下的所有扫描别名
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
    对于扫描节点，直接返回其别名；对于连接节点，返回形如：(左子树右子树) 的字符串。
    这样即便查询计划不是左深树，也能真实反映连接的层次结构。
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

def print_plan_bracket(plan_json_str):
    """
    主函数：解析 JSON 字符串，提取连接树后生成括号表示的提示信息。
    输出内容示例（可能与左深树的格式不同）：
    
    /*+ NestLoop(q1 tq1 s t1 u1 acc b1)
     HashJoin(q1 tq1 s t1)
     ...
     SeqScan(q1)
     IndexScan(tq1)
     ...
     Leading((q1 (tq1 (s t1))) (u1 (acc b1))) */
    """
    plan_data = ast.literal_eval(plan_json_str)
    
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
        # 根据实际连接树生成 leading 提示，不再假设左深结构
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
    print(output)

# -------------------- 以下为测试示例 --------------------
if __name__ == "__main__":
    plan_json = r'''
{'Node Type': 'Unique', 'Parallel Aware': False, 'Async Capable': False, 'Startup Cost': 6510.53, 'Total Cost': 6510.54, 'Plan Rows': 1, 'Plan Width': 11, 'Actual Startup Time': 93.036, 'Actual Total Time': 93.156, 'Actual Rows': 61, 'Actual Loops': 1, 'Plans': [{'Node Type': 'Sort', 'Parent Relationship': 'Outer', 'Parallel Aware': False, 'Async Capable': False, 'Startup Cost': 6510.53, 'Total Cost': 6510.54, 'Plan Rows': 1, 'Plan Width': 11, 'Actual Startup Time': 93.035, 'Actual Total Time': 93.147, 'Actual Rows': 191, 'Actual Loops': 1, 'Sort Key': ['account.display_name'], 'Sort Method': 'quicksort', 'Sort Space Used': 28, 'Sort Space Type': 'Memory', 'Plans': [{'Node Type': 'Nested Loop', 'Parent Relationship': 'Outer', 'Parallel Aware': False, 'Async Capable': False, 'Join Type': 'Inner', 'Startup Cost': 6329.82, 'Total Cost': 6510.52, 'Plan Rows': 1, 'Plan Width': 11, 'Actual Startup Time': 67.931, 'Actual Total Time': 93.103, 'Actual Rows': 191, 'Actual Loops': 1, 'Inner Unique': True, 'Plans': [{'Node Type': 'Gather', 'Parent Relationship': 'Outer', 'Parallel Aware': False, 'Async Capable': False, 'Startup Cost': 6329.38, 'Total Cost': 6503.01, 'Plan Rows': 1, 'Plan Width': 8, 'Actual Startup Time': 67.926, 'Actual Total Time': 92.822, 'Actual Rows': 191, 'Actual Loops': 1, 'Workers Planned': 1, 'Workers Launched': 1, 'Single Copy': False, 'Plans': [{'Node Type': 'Hash Join', 'Parent Relationship': 'Outer', 'Parallel Aware': True, 'Async Capable': False, 'Join Type': 'Inner', 'Startup Cost': 5329.38, 'Total Cost': 5502.91, 'Plan Rows': 1, 'Plan Width': 8, 'Actual Startup Time': 66.256, 'Actual Total Time': 78.648, 'Actual Rows': 96, 'Actual Loops': 2, 'Inner Unique': False, 'Hash Cond': '(u1.account_id = u2.account_id)', 'Workers': [], 'Plans': [{'Node Type': 'Nested Loop', 'Parent Relationship': 'Outer', 'Parallel Aware': False, 'Async Capable': False, 'Join Type': 'Inner', 'Startup Cost': 2577.93, 'Total Cost': 2751.44, 'Plan Rows': 1, 'Plan Width': 4, 'Actual Startup Time': 3.003, 'Actual Total Time': 15.541, 'Actual Rows': 3289, 'Actual Loops': 2, 'Inner Unique': True, 'Join Filter': '(t1.site_id = u1.site_id)', 'Rows Removed by Join Filter': 0, 'Workers': [], 'Plans': [{'Node Type': 'Nested Loop', 'Parent Relationship': 'Outer', 'Parallel Aware': False, 'Async Capable': False, 'Join Type': 'Inner', 'Startup Cost': 2577.49, 'Total Cost': 2743.91, 'Plan Rows': 1, 'Plan Width': 20, 'Actual Startup Time': 3.0, 'Actual Total Time': 9.999, 'Actual Rows': 3289, 'Actual Loops': 2, 'Inner Unique': True, 'Join Filter': '(t1.site_id = q1.site_id)', 'Rows Removed by Join Filter': 0, 'Workers': [], 'Plans': [{'Node Type': 'Nested Loop', 'Parent Relationship': 'Outer', 'Parallel Aware': False, 'Async Capable': False, 'Join Type': 'Inner', 'Startup Cost': 2577.06, 'Total Cost': 2638.51, 'Plan Rows': 14, 'Plan Width': 16, 'Actual Startup Time': 2.997, 'Actual Total Time': 4.134, 'Actual Rows': 3289, 'Actual Loops': 2, 'Inner Unique': False, 'Workers': [], 'Plans': [{'Node Type': 'Merge Join', 'Parent Relationship': 'Outer', 'Parallel Aware': False, 'Async Capable': False, 'Join Type': 'Inner', 'Startup Cost': 2576.49, 'Total Cost': 2576.52, 'Plan Rows': 1, 'Plan Width': 12, 'Actual Startup Time': 2.991, 'Actual Total Time': 2.992, 'Actual Rows': 0, 'Actual Loops': 2, 'Inner Unique': True, 'Merge Cond': '(t1.site_id = s1.site_id)', 'Workers': [], 'Plans': [{'Node Type': 'Sort', 'Parent Relationship': 'Outer', 'Parallel Aware': False, 'Async Capable': False, 'Startup Cost': 2573.32, 'Total Cost': 2573.32, 'Plan Rows': 2, 'Plan Width': 8, 'Actual Startup Time': 2.98, 'Actual Total Time': 2.981, 'Actual Rows': 16, 'Actual Loops': 2, 'Sort Key': ['t1.site_id'], 'Sort Method': 'quicksort', 'Sort Space Used': 25, 'Sort Space Type': 'Memory', 'Workers': [{'Worker Number': 0, 'Sort Method': 'quicksort', 'Sort Space Used': 25, 'Sort Space Type': 'Memory'}], 'Plans': [{'Node Type': 'Seq Scan', 'Parent Relationship': 'Outer', 'Parallel Aware': True, 'Async Capable': False, 'Relation Name': 'tag', 'Alias': 't1', 'Startup Cost': 0.0, 'Total Cost': 2573.31, 'Plan Rows': 2, 'Plan Width': 8, 'Actual Startup Time': 0.18, 'Actual Total Time': 2.974, 'Actual Rows': 16, 'Actual Loops': 2, 'Filter': "((name)::text = 'machine-learning'::text)", 'Rows Removed by Filter': 93368, 'Workers': []}]}, {'Node Type': 'Sort', 'Parent Relationship': 'Inner', 'Parallel Aware': False, 'Async Capable': False, 'Startup Cost': 3.17, 'Total Cost': 3.18, 'Plan Rows': 1, 'Plan Width': 4, 'Actual Startup Time': 0.01, 'Actual Total Time': 0.01, 'Actual Rows': 1, 'Actual Loops': 2, 'Sort Key': ['s1.site_id'], 'Sort Method': 'quicksort', 'Sort Space Used': 25, 'Sort Space Type': 'Memory', 'Workers': [{'Worker Number': 0, 'Sort Method': 'quicksort', 'Sort Space Used': 25, 'Sort Space Type': 'Memory'}], 'Plans': [{'Node Type': 'Seq Scan', 'Parent Relationship': 'Outer', 'Parallel Aware': False, 'Async Capable': False, 'Relation Name': 'site', 'Alias': 's1', 'Startup Cost': 0.0, 'Total Cost': 3.16, 'Plan Rows': 1, 'Plan Width': 4, 'Actual Startup Time': 0.005, 'Actual Total Time': 0.006, 'Actual Rows': 1, 'Actual Loops': 2, 'Filter': "((site_name)::text = 'stats'::text)", 'Rows Removed by Filter': 172, 'Workers': []}]}]}, {'Node Type': 'Index Only Scan', 'Parent Relationship': 'Inner', 'Parallel Aware': False, 'Async Capable': False, 'Scan Direction': 'Forward', 'Index Name': 'tag_question_site_id_tag_id_question_id_idx', 'Relation Name': 'tag_question', 'Alias': 'tq1', 'Startup Cost': 0.56, 'Total Cost': 61.69, 'Plan Rows': 31, 'Plan Width': 12, 'Actual Startup Time': 0.009, 'Actual Total Time': 2.013, 'Actual Rows': 6578, 'Actual Loops': 1, 'Index Cond': '((site_id = t1.site_id) AND (tag_id = t1.id))', 'Rows Removed by Index Recheck': 0, 'Heap Fetches': 6578, 'Workers': []}]}, {'Node Type': 'Index Scan', 'Parent Relationship': 'Inner', 'Parallel Aware': False, 'Async Capable': False, 'Scan Direction': 'Forward', 'Index Name': 'question_pkey', 'Relation Name': 'question', 'Alias': 'q1', 'Startup Cost': 0.43, 'Total Cost': 7.52, 'Plan Rows': 1, 'Plan Width': 12, 'Actual Startup Time': 0.002, 'Actual Total Time': 0.002, 'Actual Rows': 1, 'Actual Loops': 6578, 'Index Cond': '((id = tq1.question_id) AND (site_id = tq1.site_id))', 'Rows Removed by Index Recheck': 0, 'Workers': []}]}, {'Node Type': 'Index Scan', 'Parent Relationship': 'Inner', 'Parallel Aware': False, 'Async Capable': False, 'Scan Direction': 'Forward', 'Index Name': 'so_user_pkey', 'Relation Name': 'so_user', 'Alias': 'u1', 'Startup Cost': 0.44, 'Total Cost': 7.52, 'Plan Rows': 1, 'Plan Width': 12, 'Actual Startup Time': 0.002, 'Actual Total Time': 0.002, 'Actual Rows': 1, 'Actual Loops': 6578, 'Index Cond': '((id = q1.owner_user_id) AND (site_id = q1.site_id))', 'Rows Removed by Index Recheck': 0, 'Workers': []}]}, {'Node Type': 'Hash', 'Parent Relationship': 'Inner', 'Parallel Aware': True, 'Async Capable': False, 'Startup Cost': 2751.44, 'Total Cost': 2751.44, 'Plan Rows': 1, 'Plan Width': 4, 'Actual Startup Time': 62.721, 'Actual Total Time': 62.722, 'Actual Rows': 6398, 'Actual Loops': 2, 'Hash Buckets': 16384, 'Original Hash Buckets': 1024, 'Hash Batches': 1, 'Original Hash Batches': 1, 'Peak Memory Usage': 760, 'Workers': [], 'Plans': [{'Node Type': 'Nested Loop', 'Parent Relationship': 'Outer', 'Parallel Aware': False, 'Async Capable': False, 'Join Type': 'Inner', 'Startup Cost': 2577.93, 'Total Cost': 2751.44, 'Plan Rows': 1, 'Plan Width': 4, 'Actual Startup Time': 3.246, 'Actual Total Time': 32.485, 'Actual Rows': 6398, 'Actual Loops': 2, 'Inner Unique': True, 'Join Filter': '(t2.site_id = u2.site_id)', 'Rows Removed by Join Filter': 0, 'Workers': [], 'Plans': [{'Node Type': 'Nested Loop', 'Parent Relationship': 'Outer', 'Parallel Aware': False, 'Async Capable': False, 'Join Type': 'Inner', 'Startup Cost': 2577.49, 'Total Cost': 2743.91, 'Plan Rows': 1, 'Plan Width': 20, 'Actual Startup Time': 3.243, 'Actual Total Time': 20.398, 'Actual Rows': 6398, 'Actual Loops': 2, 'Inner Unique': True, 'Join Filter': '(t2.site_id = q2.site_id)', 'Rows Removed by Join Filter': 0, 'Workers': [], 'Plans': [{'Node Type': 'Nested Loop', 'Parent Relationship': 'Outer', 'Parallel Aware': False, 'Async Capable': False, 'Join Type': 'Inner', 'Startup Cost': 2577.06, 'Total Cost': 2638.51, 'Plan Rows': 14, 'Plan Width': 16, 'Actual Startup Time': 3.239, 'Actual Total Time': 7.557, 'Actual Rows': 6398, 'Actual Loops': 2, 'Inner Unique': False, 'Workers': [], 'Plans': [{'Node Type': 'Merge Join', 'Parent Relationship': 'Outer', 'Parallel Aware': False, 'Async Capable': False, 'Join Type': 'Inner', 'Startup Cost': 2576.49, 'Total Cost': 2576.52, 'Plan Rows': 1, 'Plan Width': 12, 'Actual Startup Time': 3.23, 'Actual Total Time': 3.231, 'Actual Rows': 0, 'Actual Loops': 2, 'Inner Unique': True, 'Merge Cond': '(t2.site_id = s2.site_id)', 'Workers': [], 'Plans': [{'Node Type': 'Sort', 'Parent Relationship': 'Outer', 'Parallel Aware': False, 'Async Capable': False, 'Startup Cost': 2573.32, 'Total Cost': 2573.32, 'Plan Rows': 2, 'Plan Width': 8, 'Actual Startup Time': 3.213, 'Actual Total Time': 3.214, 'Actual Rows': 7, 'Actual Loops': 2, 'Sort Key': ['t2.site_id'], 'Sort Method': 'quicksort', 'Sort Space Used': 25, 'Sort Space Type': 'Memory', 'Workers': [{'Worker Number': 0, 'Sort Method': 'quicksort', 'Sort Space Used': 25, 'Sort Space Type': 'Memory'}], 'Plans': [{'Node Type': 'Seq Scan', 'Parent Relationship': 'Outer', 'Parallel Aware': True, 'Async Capable': False, 'Relation Name': 'tag', 'Alias': 't2', 'Startup Cost': 0.0, 'Total Cost': 2573.31, 'Plan Rows': 2, 'Plan Width': 8, 'Actual Startup Time': 0.492, 'Actual Total Time': 3.203, 'Actual Rows': 8, 'Actual Loops': 2, 'Filter': "((name)::text = 'heroku'::text)", 'Rows Removed by Filter': 93377, 'Workers': []}]}, {'Node Type': 'Sort', 'Parent Relationship': 'Inner', 'Parallel Aware': False, 'Async Capable': False, 'Startup Cost': 3.17, 'Total Cost': 3.18, 'Plan Rows': 1, 'Plan Width': 4, 'Actual Startup Time': 0.014, 'Actual Total Time': 0.014, 'Actual Rows': 1, 'Actual Loops': 2, 'Sort Key': ['s2.site_id'], 'Sort Method': 'quicksort', 'Sort Space Used': 25, 'Sort Space Type': 'Memory', 'Workers': [{'Worker Number': 0, 'Sort Method': 'quicksort', 'Sort Space Used': 25, 'Sort Space Type': 'Memory'}], 'Plans': [{'Node Type': 'Seq Scan', 'Parent Relationship': 'Outer', 'Parallel Aware': False, 'Async Capable': False, 'Relation Name': 'site', 'Alias': 's2', 'Startup Cost': 0.0, 'Total Cost': 3.16, 'Plan Rows': 1, 'Plan Width': 4, 'Actual Startup Time': 0.01, 'Actual Total Time': 0.011, 'Actual Rows': 1, 'Actual Loops': 2, 'Filter': "((site_name)::text = 'stackoverflow'::text)", 'Rows Removed by Filter': 172, 'Workers': []}]}]}, {'Node Type': 'Index Only Scan', 'Parent Relationship': 'Inner', 'Parallel Aware': False, 'Async Capable': False, 'Scan Direction': 'Forward', 'Index Name': 'tag_question_site_id_tag_id_question_id_idx', 'Relation Name': 'tag_question', 'Alias': 'tq2', 'Startup Cost': 0.56, 'Total Cost': 61.69, 'Plan Rows': 31, 'Plan Width': 12, 'Actual Startup Time': 0.017, 'Actual Total Time': 8.12, 'Actual Rows': 12797, 'Actual Loops': 1, 'Index Cond': '((site_id = t2.site_id) AND (tag_id = t2.id))', 'Rows Removed by Index Recheck': 0, 'Heap Fetches': 12797, 'Workers': []}]}, {'Node Type': 'Index Scan', 'Parent Relationship': 'Inner', 'Parallel Aware': False, 'Async Capable': False, 'Scan Direction': 'Forward', 'Index Name': 'question_pkey', 'Relation Name': 'question', 'Alias': 'q2', 'Startup Cost': 0.43, 'Total Cost': 7.52, 'Plan Rows': 1, 'Plan Width': 12, 'Actual Startup Time': 0.002, 'Actual Total Time': 0.002, 'Actual Rows': 1, 'Actual Loops': 12797, 'Index Cond': '((id = tq2.question_id) AND (site_id = tq2.site_id))', 'Rows Removed by Index Recheck': 0, 'Workers': []}]}, {'Node Type': 'Index Scan', 'Parent Relationship': 'Inner', 'Parallel Aware': False, 'Async Capable': False, 'Scan Direction': 'Forward', 'Index Name': 'so_user_pkey', 'Relation Name': 'so_user', 'Alias': 'u2', 'Startup Cost': 0.44, 'Total Cost': 7.52, 'Plan Rows': 1, 'Plan Width': 12, 'Actual Startup Time': 0.002, 'Actual Total Time': 0.002, 'Actual Rows': 1, 'Actual Loops': 12797, 'Index Cond': '((id = q2.owner_user_id) AND (site_id = q2.site_id))', 'Rows Removed by Index Recheck': 0, 'Workers': []}]}]}]}]}, {'Node Type': 'Index Scan', 'Parent Relationship': 'Inner', 'Parallel Aware': False, 'Async Capable': False, 'Scan Direction': 'Forward', 'Index Name': 'account_pkey', 'Relation Name': 'account', 'Alias': 'account', 'Startup Cost': 0.43, 'Total Cost': 7.51, 'Plan Rows': 1, 'Plan Width': 15, 'Actual Startup Time': 0.001, 'Actual Total Time': 0.001, 'Actual Rows': 1, 'Actual Loops': 191, 'Index Cond': '(id = u1.account_id)', 'Rows Removed by Index Recheck': 0}]}]}]}
'''
    print_plan_bracket(plan_json)
