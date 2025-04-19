import json
import ast  # 新增导入ast模块来处理Python字典字符串

def format_plan_node(node):
    """
    根据 Node Type 与 Join Type 拼接出简单描述。
    例如: 
      Nested Loop + Inner => "Nested Loop (Inner Join)"
      Index Scan + table_name => "Index Scan on table_name"
    """
    node_type = node.get("Node Type", "")
    
    # 如果是连接操作，拼接 (Join Type)
    if node_type in ("Nested Loop", "Hash Join", "Merge Join"):
        join_type = node.get("Join Type", "")
        if join_type:
            return f"{node_type} ({join_type} Join)"
        else:
            return node_type  # 没有 Join Type 就只显示 Node Type
    
    # 如果是表扫描操作，拼接表名（Relation Name）
    if "Scan" in node_type:  # 包含 Index Scan, Seq Scan, Bitmap Scan 等
        relation_name = node.get("Relation Name", "")
        if relation_name:
            return f"{node_type} on {relation_name}"
        else:
            return node_type
    
    # 如果不是我们关心的节点类型，则返回空
    return ""

def extract_relevant_nodes(plan):
    """
    从执行计划节点中提取“连接”与“扫描”节点，并递归处理子节点。
    返回: (node_description, [child_nodes])
      - node_description: 当前节点的字符串描述(如果是连接或扫描，否则空)
      - child_nodes: 递归处理后的子节点列表
    """
    node_description = format_plan_node(plan)
    
    # 获取子节点（Plans）
    subplans = plan.get("Plans", [])
    
    children = []
    for subplan in subplans:
        child_description, child_children = extract_relevant_nodes(subplan)
        # 如果子节点本身是我们关心的(非空描述)，或者它的子节点里有我们关心的节点
        if child_description or child_children:
            children.append((child_description, child_children))
    
    return node_description, children

def build_tree_lines(node_tuple, prefix="", is_last=True):
    """
    将节点递归转换为多行字符串，带有树状格式。
    node_tuple: (node_description, [child_node_tuples])
    prefix: 用于绘制树结构的前缀，例如 "├─ "、"│  " 等
    is_last: 标记当前节点是否为同级节点中的最后一个，用以控制绘制线条
    """
    node_description, children = node_tuple
    
    lines = []
    
    # 如果没有描述并且没有子节点，直接返回空
    if not node_description and not children:
        return lines
    
    # 确定当前节点前缀符号
    branch_symbol = "└─ " if is_last else "├─ "
    lines.append(prefix + branch_symbol + (node_description if node_description else ""))
    
    # 如果有子节点，需要在前缀后面加上继续符号(│)或空格来维持树状结构
    if children:
        child_prefix = prefix + ("   " if is_last else "│  ")
        for i, child in enumerate(children):
            # 判断是否是最后一个子节点
            child_is_last = (i == len(children) - 1)
            lines.extend(build_tree_lines(child, prefix=child_prefix, is_last=child_is_last))
    
    return lines

def print_plan_tree(plan_json_str):
    """
    主函数：解析 JSON 字符串，提取并打印出树状结构（仅包含连接和扫描节点）。
    """
    # 使用ast.literal_eval代替json.loads以处理单引号字符串
    plan_data = ast.literal_eval(plan_json_str)
    
    # 1. 从根节点开始提取连接/扫描节点及其子节点
    #    如果根节点是Aggregate，直接取其子节点作为起点
    if plan_data.get("Node Type") == "Aggregate" and "Plans" in plan_data:
        root_plan = plan_data["Plans"][0]
    else:
        root_plan = plan_data
    
    # 2. 递归提取节点
    root_node_tuple = extract_relevant_nodes(root_plan)
    
    # 3. 生成树状文本行
    lines = build_tree_lines(root_node_tuple, prefix="", is_last=True)
    
    # 4. 打印输出
    for line in lines:
        print(line)

# -------------------- 以下为测试示例 --------------------
if __name__ == "__main__":
    # 注意：测试字符串已保持原始单引号格式
    plan_json = r'''
{'Node Type': 'Unique', 'Parallel Aware': False, 'Async Capable': False, 'Startup Cost': 6510.53, 'Total Cost': 6510.54, 'Plan Rows': 1, 'Plan Width': 11, 'Actual Startup Time': 93.036, 'Actual Total Time': 93.156, 'Actual Rows': 61, 'Actual Loops': 1, 'Plans': [{'Node Type': 'Sort', 'Parent Relationship': 'Outer', 'Parallel Aware': False, 'Async Capable': False, 'Startup Cost': 6510.53, 'Total Cost': 6510.54, 'Plan Rows': 1, 'Plan Width': 11, 'Actual Startup Time': 93.035, 'Actual Total Time': 93.147, 'Actual Rows': 191, 'Actual Loops': 1, 'Sort Key': ['account.display_name'], 'Sort Method': 'quicksort', 'Sort Space Used': 28, 'Sort Space Type': 'Memory', 'Plans': [{'Node Type': 'Nested Loop', 'Parent Relationship': 'Outer', 'Parallel Aware': False, 'Async Capable': False, 'Join Type': 'Inner', 'Startup Cost': 6329.82, 'Total Cost': 6510.52, 'Plan Rows': 1, 'Plan Width': 11, 'Actual Startup Time': 67.931, 'Actual Total Time': 93.103, 'Actual Rows': 191, 'Actual Loops': 1, 'Inner Unique': True, 'Plans': [{'Node Type': 'Gather', 'Parent Relationship': 'Outer', 'Parallel Aware': False, 'Async Capable': False, 'Startup Cost': 6329.38, 'Total Cost': 6503.01, 'Plan Rows': 1, 'Plan Width': 8, 'Actual Startup Time': 67.926, 'Actual Total Time': 92.822, 'Actual Rows': 191, 'Actual Loops': 1, 'Workers Planned': 1, 'Workers Launched': 1, 'Single Copy': False, 'Plans': [{'Node Type': 'Hash Join', 'Parent Relationship': 'Outer', 'Parallel Aware': True, 'Async Capable': False, 'Join Type': 'Inner', 'Startup Cost': 5329.38, 'Total Cost': 5502.91, 'Plan Rows': 1, 'Plan Width': 8, 'Actual Startup Time': 66.256, 'Actual Total Time': 78.648, 'Actual Rows': 96, 'Actual Loops': 2, 'Inner Unique': False, 'Hash Cond': '(u1.account_id = u2.account_id)', 'Workers': [], 'Plans': [{'Node Type': 'Nested Loop', 'Parent Relationship': 'Outer', 'Parallel Aware': False, 'Async Capable': False, 'Join Type': 'Inner', 'Startup Cost': 2577.93, 'Total Cost': 2751.44, 'Plan Rows': 1, 'Plan Width': 4, 'Actual Startup Time': 3.003, 'Actual Total Time': 15.541, 'Actual Rows': 3289, 'Actual Loops': 2, 'Inner Unique': True, 'Join Filter': '(t1.site_id = u1.site_id)', 'Rows Removed by Join Filter': 0, 'Workers': [], 'Plans': [{'Node Type': 'Nested Loop', 'Parent Relationship': 'Outer', 'Parallel Aware': False, 'Async Capable': False, 'Join Type': 'Inner', 'Startup Cost': 2577.49, 'Total Cost': 2743.91, 'Plan Rows': 1, 'Plan Width': 20, 'Actual Startup Time': 3.0, 'Actual Total Time': 9.999, 'Actual Rows': 3289, 'Actual Loops': 2, 'Inner Unique': True, 'Join Filter': '(t1.site_id = q1.site_id)', 'Rows Removed by Join Filter': 0, 'Workers': [], 'Plans': [{'Node Type': 'Nested Loop', 'Parent Relationship': 'Outer', 'Parallel Aware': False, 'Async Capable': False, 'Join Type': 'Inner', 'Startup Cost': 2577.06, 'Total Cost': 2638.51, 'Plan Rows': 14, 'Plan Width': 16, 'Actual Startup Time': 2.997, 'Actual Total Time': 4.134, 'Actual Rows': 3289, 'Actual Loops': 2, 'Inner Unique': False, 'Workers': [], 'Plans': [{'Node Type': 'Merge Join', 'Parent Relationship': 'Outer', 'Parallel Aware': False, 'Async Capable': False, 'Join Type': 'Inner', 'Startup Cost': 2576.49, 'Total Cost': 2576.52, 'Plan Rows': 1, 'Plan Width': 12, 'Actual Startup Time': 2.991, 'Actual Total Time': 2.992, 'Actual Rows': 0, 'Actual Loops': 2, 'Inner Unique': True, 'Merge Cond': '(t1.site_id = s1.site_id)', 'Workers': [], 'Plans': [{'Node Type': 'Sort', 'Parent Relationship': 'Outer', 'Parallel Aware': False, 'Async Capable': False, 'Startup Cost': 2573.32, 'Total Cost': 2573.32, 'Plan Rows': 2, 'Plan Width': 8, 'Actual Startup Time': 2.98, 'Actual Total Time': 2.981, 'Actual Rows': 16, 'Actual Loops': 2, 'Sort Key': ['t1.site_id'], 'Sort Method': 'quicksort', 'Sort Space Used': 25, 'Sort Space Type': 'Memory', 'Workers': [{'Worker Number': 0, 'Sort Method': 'quicksort', 'Sort Space Used': 25, 'Sort Space Type': 'Memory'}], 'Plans': [{'Node Type': 'Seq Scan', 'Parent Relationship': 'Outer', 'Parallel Aware': True, 'Async Capable': False, 'Relation Name': 'tag', 'Alias': 't1', 'Startup Cost': 0.0, 'Total Cost': 2573.31, 'Plan Rows': 2, 'Plan Width': 8, 'Actual Startup Time': 0.18, 'Actual Total Time': 2.974, 'Actual Rows': 16, 'Actual Loops': 2, 'Filter': "((name)::text = 'machine-learning'::text)", 'Rows Removed by Filter': 93368, 'Workers': []}]}, {'Node Type': 'Sort', 'Parent Relationship': 'Inner', 'Parallel Aware': False, 'Async Capable': False, 'Startup Cost': 3.17, 'Total Cost': 3.18, 'Plan Rows': 1, 'Plan Width': 4, 'Actual Startup Time': 0.01, 'Actual Total Time': 0.01, 'Actual Rows': 1, 'Actual Loops': 2, 'Sort Key': ['s1.site_id'], 'Sort Method': 'quicksort', 'Sort Space Used': 25, 'Sort Space Type': 'Memory', 'Workers': [{'Worker Number': 0, 'Sort Method': 'quicksort', 'Sort Space Used': 25, 'Sort Space Type': 'Memory'}], 'Plans': [{'Node Type': 'Seq Scan', 'Parent Relationship': 'Outer', 'Parallel Aware': False, 'Async Capable': False, 'Relation Name': 'site', 'Alias': 's1', 'Startup Cost': 0.0, 'Total Cost': 3.16, 'Plan Rows': 1, 'Plan Width': 4, 'Actual Startup Time': 0.005, 'Actual Total Time': 0.006, 'Actual Rows': 1, 'Actual Loops': 2, 'Filter': "((site_name)::text = 'stats'::text)", 'Rows Removed by Filter': 172, 'Workers': []}]}]}, {'Node Type': 'Index Only Scan', 'Parent Relationship': 'Inner', 'Parallel Aware': False, 'Async Capable': False, 'Scan Direction': 'Forward', 'Index Name': 'tag_question_site_id_tag_id_question_id_idx', 'Relation Name': 'tag_question', 'Alias': 'tq1', 'Startup Cost': 0.56, 'Total Cost': 61.69, 'Plan Rows': 31, 'Plan Width': 12, 'Actual Startup Time': 0.009, 'Actual Total Time': 2.013, 'Actual Rows': 6578, 'Actual Loops': 1, 'Index Cond': '((site_id = t1.site_id) AND (tag_id = t1.id))', 'Rows Removed by Index Recheck': 0, 'Heap Fetches': 6578, 'Workers': []}]}, {'Node Type': 'Index Scan', 'Parent Relationship': 'Inner', 'Parallel Aware': False, 'Async Capable': False, 'Scan Direction': 'Forward', 'Index Name': 'question_pkey', 'Relation Name': 'question', 'Alias': 'q1', 'Startup Cost': 0.43, 'Total Cost': 7.52, 'Plan Rows': 1, 'Plan Width': 12, 'Actual Startup Time': 0.002, 'Actual Total Time': 0.002, 'Actual Rows': 1, 'Actual Loops': 6578, 'Index Cond': '((id = tq1.question_id) AND (site_id = tq1.site_id))', 'Rows Removed by Index Recheck': 0, 'Workers': []}]}, {'Node Type': 'Index Scan', 'Parent Relationship': 'Inner', 'Parallel Aware': False, 'Async Capable': False, 'Scan Direction': 'Forward', 'Index Name': 'so_user_pkey', 'Relation Name': 'so_user', 'Alias': 'u1', 'Startup Cost': 0.44, 'Total Cost': 7.52, 'Plan Rows': 1, 'Plan Width': 12, 'Actual Startup Time': 0.002, 'Actual Total Time': 0.002, 'Actual Rows': 1, 'Actual Loops': 6578, 'Index Cond': '((id = q1.owner_user_id) AND (site_id = q1.site_id))', 'Rows Removed by Index Recheck': 0, 'Workers': []}]}, {'Node Type': 'Hash', 'Parent Relationship': 'Inner', 'Parallel Aware': True, 'Async Capable': False, 'Startup Cost': 2751.44, 'Total Cost': 2751.44, 'Plan Rows': 1, 'Plan Width': 4, 'Actual Startup Time': 62.721, 'Actual Total Time': 62.722, 'Actual Rows': 6398, 'Actual Loops': 2, 'Hash Buckets': 16384, 'Original Hash Buckets': 1024, 'Hash Batches': 1, 'Original Hash Batches': 1, 'Peak Memory Usage': 760, 'Workers': [], 'Plans': [{'Node Type': 'Nested Loop', 'Parent Relationship': 'Outer', 'Parallel Aware': False, 'Async Capable': False, 'Join Type': 'Inner', 'Startup Cost': 2577.93, 'Total Cost': 2751.44, 'Plan Rows': 1, 'Plan Width': 4, 'Actual Startup Time': 3.246, 'Actual Total Time': 32.485, 'Actual Rows': 6398, 'Actual Loops': 2, 'Inner Unique': True, 'Join Filter': '(t2.site_id = u2.site_id)', 'Rows Removed by Join Filter': 0, 'Workers': [], 'Plans': [{'Node Type': 'Nested Loop', 'Parent Relationship': 'Outer', 'Parallel Aware': False, 'Async Capable': False, 'Join Type': 'Inner', 'Startup Cost': 2577.49, 'Total Cost': 2743.91, 'Plan Rows': 1, 'Plan Width': 20, 'Actual Startup Time': 3.243, 'Actual Total Time': 20.398, 'Actual Rows': 6398, 'Actual Loops': 2, 'Inner Unique': True, 'Join Filter': '(t2.site_id = q2.site_id)', 'Rows Removed by Join Filter': 0, 'Workers': [], 'Plans': [{'Node Type': 'Nested Loop', 'Parent Relationship': 'Outer', 'Parallel Aware': False, 'Async Capable': False, 'Join Type': 'Inner', 'Startup Cost': 2577.06, 'Total Cost': 2638.51, 'Plan Rows': 14, 'Plan Width': 16, 'Actual Startup Time': 3.239, 'Actual Total Time': 7.557, 'Actual Rows': 6398, 'Actual Loops': 2, 'Inner Unique': False, 'Workers': [], 'Plans': [{'Node Type': 'Merge Join', 'Parent Relationship': 'Outer', 'Parallel Aware': False, 'Async Capable': False, 'Join Type': 'Inner', 'Startup Cost': 2576.49, 'Total Cost': 2576.52, 'Plan Rows': 1, 'Plan Width': 12, 'Actual Startup Time': 3.23, 'Actual Total Time': 3.231, 'Actual Rows': 0, 'Actual Loops': 2, 'Inner Unique': True, 'Merge Cond': '(t2.site_id = s2.site_id)', 'Workers': [], 'Plans': [{'Node Type': 'Sort', 'Parent Relationship': 'Outer', 'Parallel Aware': False, 'Async Capable': False, 'Startup Cost': 2573.32, 'Total Cost': 2573.32, 'Plan Rows': 2, 'Plan Width': 8, 'Actual Startup Time': 3.213, 'Actual Total Time': 3.214, 'Actual Rows': 7, 'Actual Loops': 2, 'Sort Key': ['t2.site_id'], 'Sort Method': 'quicksort', 'Sort Space Used': 25, 'Sort Space Type': 'Memory', 'Workers': [{'Worker Number': 0, 'Sort Method': 'quicksort', 'Sort Space Used': 25, 'Sort Space Type': 'Memory'}], 'Plans': [{'Node Type': 'Seq Scan', 'Parent Relationship': 'Outer', 'Parallel Aware': True, 'Async Capable': False, 'Relation Name': 'tag', 'Alias': 't2', 'Startup Cost': 0.0, 'Total Cost': 2573.31, 'Plan Rows': 2, 'Plan Width': 8, 'Actual Startup Time': 0.492, 'Actual Total Time': 3.203, 'Actual Rows': 8, 'Actual Loops': 2, 'Filter': "((name)::text = 'heroku'::text)", 'Rows Removed by Filter': 93377, 'Workers': []}]}, {'Node Type': 'Sort', 'Parent Relationship': 'Inner', 'Parallel Aware': False, 'Async Capable': False, 'Startup Cost': 3.17, 'Total Cost': 3.18, 'Plan Rows': 1, 'Plan Width': 4, 'Actual Startup Time': 0.014, 'Actual Total Time': 0.014, 'Actual Rows': 1, 'Actual Loops': 2, 'Sort Key': ['s2.site_id'], 'Sort Method': 'quicksort', 'Sort Space Used': 25, 'Sort Space Type': 'Memory', 'Workers': [{'Worker Number': 0, 'Sort Method': 'quicksort', 'Sort Space Used': 25, 'Sort Space Type': 'Memory'}], 'Plans': [{'Node Type': 'Seq Scan', 'Parent Relationship': 'Outer', 'Parallel Aware': False, 'Async Capable': False, 'Relation Name': 'site', 'Alias': 's2', 'Startup Cost': 0.0, 'Total Cost': 3.16, 'Plan Rows': 1, 'Plan Width': 4, 'Actual Startup Time': 0.01, 'Actual Total Time': 0.011, 'Actual Rows': 1, 'Actual Loops': 2, 'Filter': "((site_name)::text = 'stackoverflow'::text)", 'Rows Removed by Filter': 172, 'Workers': []}]}]}, {'Node Type': 'Index Only Scan', 'Parent Relationship': 'Inner', 'Parallel Aware': False, 'Async Capable': False, 'Scan Direction': 'Forward', 'Index Name': 'tag_question_site_id_tag_id_question_id_idx', 'Relation Name': 'tag_question', 'Alias': 'tq2', 'Startup Cost': 0.56, 'Total Cost': 61.69, 'Plan Rows': 31, 'Plan Width': 12, 'Actual Startup Time': 0.017, 'Actual Total Time': 8.12, 'Actual Rows': 12797, 'Actual Loops': 1, 'Index Cond': '((site_id = t2.site_id) AND (tag_id = t2.id))', 'Rows Removed by Index Recheck': 0, 'Heap Fetches': 12797, 'Workers': []}]}, {'Node Type': 'Index Scan', 'Parent Relationship': 'Inner', 'Parallel Aware': False, 'Async Capable': False, 'Scan Direction': 'Forward', 'Index Name': 'question_pkey', 'Relation Name': 'question', 'Alias': 'q2', 'Startup Cost': 0.43, 'Total Cost': 7.52, 'Plan Rows': 1, 'Plan Width': 12, 'Actual Startup Time': 0.002, 'Actual Total Time': 0.002, 'Actual Rows': 1, 'Actual Loops': 12797, 'Index Cond': '((id = tq2.question_id) AND (site_id = tq2.site_id))', 'Rows Removed by Index Recheck': 0, 'Workers': []}]}, {'Node Type': 'Index Scan', 'Parent Relationship': 'Inner', 'Parallel Aware': False, 'Async Capable': False, 'Scan Direction': 'Forward', 'Index Name': 'so_user_pkey', 'Relation Name': 'so_user', 'Alias': 'u2', 'Startup Cost': 0.44, 'Total Cost': 7.52, 'Plan Rows': 1, 'Plan Width': 12, 'Actual Startup Time': 0.002, 'Actual Total Time': 0.002, 'Actual Rows': 1, 'Actual Loops': 12797, 'Index Cond': '((id = q2.owner_user_id) AND (site_id = q2.site_id))', 'Rows Removed by Index Recheck': 0, 'Workers': []}]}]}]}]}, {'Node Type': 'Index Scan', 'Parent Relationship': 'Inner', 'Parallel Aware': False, 'Async Capable': False, 'Scan Direction': 'Forward', 'Index Name': 'account_pkey', 'Relation Name': 'account', 'Alias': 'account', 'Startup Cost': 0.43, 'Total Cost': 7.51, 'Plan Rows': 1, 'Plan Width': 15, 'Actual Startup Time': 0.001, 'Actual Total Time': 0.001, 'Actual Rows': 1, 'Actual Loops': 191, 'Index Cond': '(id = u1.account_id)', 'Rows Removed by Index Recheck': 0}]}]}]}
'''
    print_plan_tree(plan_json)