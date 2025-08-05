import re
from utils.get_postgres_hint import get_postgres_hint_json
def extract_plan_info(plan_json):
    """
    Extract the cardinality of each table/node and the corresponding filter cardinality from the JSON of the Postgres query plan.

    Returns two dictionaries:
    - table_cardinality: key is the table alias (or table name/CTE name), value is the Plan Rows of the node (considered as the cardinality).
    - filter_cardinality: key is the tuple of (table alias, filter string), value is the Plan Rows of the corresponding node.

    Note:
    - If the same table appears in multiple nodes, the larger Plan Rows is used as the estimated cardinality of that table.
    - Each node with Filter or Join Filter will be recorded separately.
    - For Join Filter, if the current node does not have a clear alias, all table aliases involved in the condition will be extracted using a regular expression.
    """
    table_cardinality = {}
    filter_cardinality = {}

    def traverse(node):
        if not isinstance(node, dict):
            return

        # determine the identifier of the current node: use Relation Name first, then CTE Name, then Alias, otherwise "unknown"
        if "Relation Name" in node:
            alias = node.get("Alias", node["Relation Name"])
        elif "CTE Name" in node:
            alias = node.get("Alias", node["CTE Name"])
        else:
            alias = node.get("Alias", "unknown")
            
        plan_rows = node.get("Plan Rows")

        # process the Filter field
        if "Filter" in node:
            filter_str = node["Filter"]
            if plan_rows is not None:
                filter_cardinality[(alias, filter_str)] = plan_rows

        # process the Join Filter field
        if "Join Filter" in node:
            join_filter_str = node["Join Filter"]
            # if the current node alias is unknown or the join filter involves multiple tables, try to extract all table aliases using a regular expression
            aliases = re.findall(r'([a-zA-Z_]\w*)\.', join_filter_str)
            if not aliases:
                aliases = [alias]
            # for each alias involved in the join filter, record the cardinality separately
            for a in aliases:
                if plan_rows is not None:
                    filter_cardinality[(a, join_filter_str)] = plan_rows

        # record the table cardinality of the scan node (only record when there is Relation Name)
        if "Relation Name" in node and plan_rows is not None:
            table_cardinality[alias] = max(plan_rows, table_cardinality.get(alias, 0))

        # recursively traverse all child nodes (including nodes in the Plans array)
        for key, value in node.items():
            if isinstance(value, dict):
                traverse(value)
            elif isinstance(value, list):
                for item in value:
                    traverse(item)

    # start traversing from the top-level Plan node
    if "Plan" in plan_json:
        traverse(plan_json["Plan"])
    else:
        traverse(plan_json)

    return table_cardinality, filter_cardinality

def analyze_sql(sql, connection_info, REAL_EXECUTION, sql_name, introduce_errors=False):
    import json
    import random
    
    # set a random seed
    random.seed(42)

    # Make a shallow copy of connection_info and remove 'timeout' if present
    connection_info_cp = connection_info.copy()
    connection_info_cp.pop('timeout', None)

    # Retrieve the query plan as a JSON string (assumes get_postgres_hint_json is defined)
    plan_str = get_postgres_hint_json(sql, connection_info_cp, REAL_EXECUTION, sql_name)
    plan_json = json.loads(plan_str)

    # Extract table cardinalities and filter cardinalities
    # (assumes extract_plan_info returns (dict(table→rows), dict((alias, filter)→rows)))
    table_card, filter_card = extract_plan_info(plan_json)

    # If error injection is enabled, apply multiplicative perturbation to each cardinality
    if introduce_errors:
        def perturb(rows: int) -> int:
            """
            Introduce a random multiplicative error in log-space:
            - If rows >= 10: factor = 10^power, power ∈ [-1, 1] → scales [0.1×, 10×]
            - If rows < 10:  factor = 10^power, power ∈ [0, 1]   → scales [1×, 10×]
            Ensures perturbed value is at least 1.
            """
            if rows >= 10:
                power = random.uniform(-1, 1)
            else:
                power = random.uniform(0, 1)
            factor = 10 ** power
            return max(1, int(rows * factor))

        # Apply perturbation to each table’s cardinality
        table_card = {tbl: perturb(cnt) for tbl, cnt in table_card.items()}
        # Apply perturbation to each filter’s cardinality
        filter_card = {key: perturb(cnt) for key, cnt in filter_card.items()}

    # Build the output lines
    result_lines = ["Table Cardinality:"]
    for table, rows in table_card.items():
        result_lines.append(f"  {table}: {rows}")

    result_lines.append("Filter Cardinality:")
    for (alias, filt), rows in filter_card.items():
        result_lines.append(f"  ({alias}, {filt}): {rows}")

    # Return all lines joined by newlines
    return "\n".join(result_lines)

    


# # example: read the JSON query plan from a file
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