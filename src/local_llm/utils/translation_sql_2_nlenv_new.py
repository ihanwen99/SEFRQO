import re
from utils.get_postgres_hint import get_postgres_hint_json
def extract_plan_info(plan_json):
    """
    从 Postgres 查询计划的 JSON 中提取出每个表/节点的基数和对应的过滤条件基数。

    返回两个字典：
    - table_cardinality: key 为表别名（或表名/CTE名），value 为该节点的 Plan Rows（认为是基数）。
    - filter_cardinality: key 为 (表别名, filter字符串) 的元组，value 为对应节点的 Plan Rows。

    注意：
    - 若同一表在多个节点中出现，这里采用较大的 Plan Rows 作为该表的估计基数。
    - 每个带 Filter 或 Join Filter 的节点都会单独记录。
    - 对于 Join Filter，如果当前节点没有明确的 alias，会利用正则表达式从条件中提取出涉及的所有表别名进行记录。
    """
    table_cardinality = {}
    filter_cardinality = {}

    def traverse(node):
        if not isinstance(node, dict):
            return

        # 确定当前节点的标识：优先使用 Relation Name，其次使用 CTE Name，再次使用 Alias，否则为 "unknown"
        if "Relation Name" in node:
            alias = node.get("Alias", node["Relation Name"])
        elif "CTE Name" in node:
            alias = node.get("Alias", node["CTE Name"])
        else:
            alias = node.get("Alias", "unknown")
            
        plan_rows = node.get("Plan Rows")

        # 处理 Filter 字段
        if "Filter" in node:
            filter_str = node["Filter"]
            if plan_rows is not None:
                filter_cardinality[(alias, filter_str)] = plan_rows

        # 处理 Join Filter 字段
        if "Join Filter" in node:
            join_filter_str = node["Join Filter"]
            # 如果当前节点 alias 为 unknown 或 join filter 涉及多个表，则尝试用正则提取所有表别名
            aliases = re.findall(r'([a-zA-Z_]\w*)\.', join_filter_str)
            if not aliases:
                aliases = [alias]
            # 对于 join filter 涉及的每个别名，都单独记录基数
            for a in aliases:
                if plan_rows is not None:
                    filter_cardinality[(a, join_filter_str)] = plan_rows

        # 记录扫描节点的表基数（只在有 Relation Name 时记录）
        if "Relation Name" in node and plan_rows is not None:
            table_cardinality[alias] = max(plan_rows, table_cardinality.get(alias, 0))

        # 递归遍历所有子节点（包括 Plans 数组中的节点）
        for key, value in node.items():
            if isinstance(value, dict):
                traverse(value)
            elif isinstance(value, list):
                for item in value:
                    traverse(item)

    # 从顶层的 Plan 节点开始遍历
    if "Plan" in plan_json:
        traverse(plan_json["Plan"])
    else:
        traverse(plan_json)

    return table_cardinality, filter_cardinality

def analyze_sql(sql, connection_info,REAL_EXECUTION,sql_name):
    import json
    # remove the property timeout in dictionary connection_info, if exists
    connection_info_cp = connection_info.copy()
    
    if 'timeout' in connection_info_cp:
        del connection_info_cp['timeout']

    # 获取查询计划的 JSON 对象（假设 get_postgres_hint_json 已定义）
    plan_json = get_postgres_hint_json(sql, connection_info_cp,REAL_EXECUTION,sql_name)
    # change string to json
    plan_json = json.loads(plan_json)
    
    # 提取表的基数和过滤条件基数（假设 extract_plan_info 已定义）
    table_card, filter_card = extract_plan_info(plan_json)
    
    # 用列表存储各行结果，最后合并为一个字符串返回
    result_lines = []
    
    result_lines.append("Table Cardinality:")
    for table, rows in table_card.items():
        result_lines.append(f"  {table}: {rows}")
    
    result_lines.append("Filter Cardinality:")
    for (alias, filt), rows in filter_card.items():
        result_lines.append(f"  ({alias}, {filt}): {rows}")
    
    # 将所有行用换行符合并为一个字符串
    concatened_text = "\n".join(result_lines)
    
    # 可选：打印结果
    # print(concatened_text)
    
    return concatened_text

    


# # 示例使用：从文件中读取 JSON 查询计划
# if __name__ == "__main__":
#     database = "tpcds1load"
#     connection_info = {
#         "host": "127.0.0.1",
#         "port": 5438,
#         "database": database,
#         "user": "qihanzha",
#     }
#     original_sql = """SELECT  a.ca_state AS state, COUNT(*) AS cnt
# FROM customer_address a
#      ,customer c
#      ,store_sales s
#      ,date_dim d
#      ,item i
# WHERE       a.ca_address_sk = c.c_current_addr_sk
#      AND c.c_customer_sk = s.ss_customer_sk
#      AND s.ss_sold_date_sk = d.d_date_sk
#      AND s.ss_item_sk = i.i_item_sk
#      AND d.d_month_seq = 
#           (SELECT DISTINCT (d_month_seq)
#            FROM date_dim
#            WHERE d_year = 2000
#              AND d_moy = 2 )
#      AND i.i_current_price > 1.2 * 
#              (SELECT AVG(j.i_current_price) 
#               FROM item j 
#               WHERE j.i_category = i.i_category)
# GROUP BY a.ca_state
# HAVING COUNT(*) >= 10
# ORDER BY cnt, a.ca_state 
# LIMIT 100;

# """


#     analyze_sql(original_sql, connection_info)