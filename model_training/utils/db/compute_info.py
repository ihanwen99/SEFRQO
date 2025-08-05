"""
Compute Query Statistics Information: From Database Perspective
"""
import re
from collections import defaultdict

import psycopg2
import sqlparse
from sqlparse.sql import Identifier, Where, Comparison, Parenthesis, TokenList
from sqlparse.tokens import Keyword


class SQLFilterAnalyzer:
    def __init__(self):
        self.alias_to_table = {}
        self.filter_conditions = defaultdict(list)
        self.table_cardinalities = {}
        self.output_lines = []

    def extract_tables_and_aliases(self, sql_query):
        """
        Parse a SQL query to extract table aliases from the FROM clause.

        :param sql_query: The full SQL query as a string.
        :return: A dictionary {alias: table_name}.
        """

        # Use a case-insensitive search for FROM ... (next major clause)
        # We look for FROM, then try to cut off at WHERE, or end of string if no WHERE.
        from_match = re.search(r"\bFROM\b", sql_query, flags=re.IGNORECASE)
        if not from_match:
            return {}

        # Starting position (right after "FROM")
        start_idx = from_match.end()

        # Attempt to find the next major clause (e.g. WHERE, GROUP BY, ORDER BY, etc.)
        # For simplicity, we look for WHERE. You could extend this to find other clauses too.
        subsequent_clause_match = re.search(r"\bWHERE\b", sql_query, flags=re.IGNORECASE)
        if subsequent_clause_match:
            end_idx = subsequent_clause_match.start()
        else:
            # If there's no WHERE, consider everything to the end
            end_idx = len(sql_query)

        # Extract the FROM clause text
        from_clause = sql_query[start_idx:end_idx].strip()

        # Split by commas to get each "table AS alias" part
        parts = [p.strip() for p in from_clause.split(',') if p.strip()]

        # Regex to capture the table name and optional alias
        # Examples it should match:
        #   site AS s
        #   so_user as u1
        #   question q1
        #   account
        pattern = re.compile(r"""
            ^\s*                # leading whitespace
            ([\w\.]+)           # table name (including possible underscores or dots)
            (?:\s+AS\s+|\s+)    # "AS" or just whitespace
            ([\w\.]+)           # alias
            \s*$                # trailing whitespace
        """, re.IGNORECASE | re.VERBOSE)

        # Parse each segment
        for part in parts:
            match = pattern.search(part)
            if match:
                table_name, alias = match.groups()
                self.alias_to_table[alias] = table_name
            else:
                # If there's no explicit alias, treat the single token as table name
                # and use the same token as the alias (or skip, depending on your needs).
                single_pattern = re.compile(r"^\s*([\w\.]+)\s*$", re.IGNORECASE)
                single_match = single_pattern.match(part)
                if single_match:
                    table_name = single_match.group(1)
                    self.alias_to_table[table_name] = table_name

        return self.alias_to_table

    def extract_conditions(self, sql):
        """Extract and classify conditions from WHERE clause into filters."""
        parsed = sqlparse.parse(sql)[0]
        where_clause = None

        # Find WHERE clause
        for token in parsed.tokens:
            if isinstance(token, Where):
                where_clause = token
                break

        if not where_clause:
            return

        def process_token(token, parent_aliases=set()):
            if isinstance(token, Comparison):
                condition_str = str(token).strip()
                aliases = self.extract_aliases_from_token(token)
                if len(aliases) == 1:
                    alias = aliases.pop()
                    self.filter_conditions[alias].append(condition_str)
                else:
                    # Handle join conditions or conditions involving multiple tables
                    pass  # You can choose to store these separately if needed
            elif isinstance(token, Parenthesis):
                # Check for conditions inside parentheses
                inner_aliases = set()
                for t in token.tokens:
                    inner_aliases.update(self.extract_aliases_from_token(t))
                # If only one alias involved, add the whole condition
                if len(inner_aliases) == 1:
                    condition_str = str(token).strip()
                    alias = inner_aliases.pop()
                    self.filter_conditions[alias].append(condition_str)
                else:
                    # Process tokens inside parentheses
                    for t in token.tokens:
                        process_token(t)
            elif isinstance(token, TokenList):
                for t in token.tokens:
                    process_token(t)
            elif token.ttype is Keyword and token.value.upper() in ('AND', 'OR'):
                pass  # Logical operators can be ignored here
            else:
                pass  # Other tokens can be ignored

        process_token(where_clause)

    def extract_aliases_from_token(self, token):
        """Recursively extract table aliases from a token."""
        aliases = set()
        if isinstance(token, Identifier):
            names = token.value.split('.')
            if len(names) == 2:
                alias = names[0]
                aliases.add(alias)
        elif isinstance(token, TokenList):
            for t in token.tokens:
                aliases.update(self.extract_aliases_from_token(t))
        return aliases

    def get_table_cardinalities(self):
        """Retrieve cardinalities of each table."""
        conn = psycopg2.connect(
            host="localhost",
            database="imdbload",
            user="hanwenliu",
            port=5438,
        )
        cursor = conn.cursor()

        for alias, table_name in self.alias_to_table.items():
            cursor.execute(f"SELECT reltuples::BIGINT AS estimate FROM pg_class WHERE relname='{table_name}'")
            result = cursor.fetchone()
            if result:
                self.table_cardinalities[table_name] = int(result[0])

        cursor.close()
        conn.close()

    def estimate_filter_rows(self):
        """Estimate rows after applying combined filters."""
        estimates = {}
        conn = psycopg2.connect(
            host="localhost",
            database="imdbload",
            user="hanwenliu",
            port=5438,
        )
        conn.autocommit = True
        cursor = conn.cursor()

        for alias in self.filter_conditions:
            filters = self.filter_conditions[alias]
            if filters:
                table_name = self.alias_to_table.get(alias, alias)
                combined_filters = ' AND '.join(f'({f})' for f in filters)
                sql = f"EXPLAIN (FORMAT JSON) SELECT * FROM {table_name} AS {alias} WHERE {combined_filters};"
                try:
                    cursor.execute(sql)
                    result = cursor.fetchone()
                    if result:
                        plan = result[0][0]['Plan']
                        num_rows = plan.get('Plan Rows', 0)
                        estimates[(f"{table_name} AS {alias}", combined_filters)] = num_rows
                except Exception as e:
                    self.output_lines.append(f"Error executing SQL: {sql}")
                    self.output_lines.append(f"Exception: {e}")
                    conn.rollback()

        cursor.close()
        conn.close()
        return estimates


def analyze_sql(sql):
    """
    Return 1) Table Alias; 2) Cardinality; 3) Filter;
    """
    analyzer = SQLFilterAnalyzer()
    output_lines = analyzer.output_lines

    # Extract tables and aliases
    analyzer.extract_tables_and_aliases(sql)
    output_lines.append("# You have these tables:")
    for alias, table in analyzer.alias_to_table.items():
        output_lines.append(f"{table} AS {alias}")
    output_lines.append("")

    # Get table cardinalities
    analyzer.get_table_cardinalities()
    # output_lines.append("Table cardinalities:")
    output_lines.append("# table cardinality = {")
    for table, cardinality in analyzer.table_cardinalities.items():
        output_lines.append(f"    '{table}': {cardinality},")
    output_lines.append("}\n")

    # Extract and classify conditions
    analyzer.extract_conditions(sql)

    # output_lines.append("Filter conditions by table:")
    # for alias, filters in analyzer.filter_conditions.items():
    #     output_lines.append(f"{alias}: {filters}")
    # output_lines.append("")

    # Estimate cardinalities
    estimates = analyzer.estimate_filter_rows()

    output_lines.append("# filter cardinality = {")
    for (table_info, filter_expr), cardinality in estimates.items():
        output_lines.append(f"    ('{table_info}', '{filter_expr}'): {cardinality},")
    output_lines.append("}")

    return '\n'.join(output_lines)


def analyze_sql_and_stores(sql):
    analyzer = SQLFilterAnalyzer()
    tables_info, table_cardinality_info, filter_cardinality_info = [], [], []

    # Extract tables and aliases
    analyzer.extract_tables_and_aliases(sql)
    tables_info.append("# You have these tables:")
    for alias, table in analyzer.alias_to_table.items():
        tables_info.append(f"{table} AS {alias}")
    tables_info.append("")

    # Get table cardinalities
    analyzer.get_table_cardinalities()
    table_cardinality_info.append("# table cardinality = {")
    for table, cardinality in analyzer.table_cardinalities.items():
        table_cardinality_info.append(f"    '{table}': {cardinality},")
    table_cardinality_info.append("}\n")

    # Extract and classify conditions
    analyzer.extract_conditions(sql)

    # Estimate cardinalities
    estimates = analyzer.estimate_filter_rows()

    filter_cardinality_info.append("# filter cardinality = {")
    for (table_info, filter_expr), cardinality in estimates.items():
        filter_cardinality_info.append(f"    ('{table_info}', '{filter_expr}'): {cardinality},")
    filter_cardinality_info.append("}")

    return '\n'.join(tables_info), '\n'.join(table_cardinality_info), '\n'.join(filter_cardinality_info)


if __name__ == '__main__':
    input = """ select count(distinct q1.id) from
    site, post_link pl1, post_link pl2, question q1, question q2, question q3 where
    
    site.site_name = 'cseducators' and
    q1.site_id = site.site_id and
    q1.site_id = q2.site_id and
    q2.site_id = q3.site_id and
    
    pl1.site_id = q1.site_id and
    pl1.post_id_from = q1.id and
    pl1.post_id_to = q2.id and
    
    pl2.site_id = q1.site_id and
    pl2.post_id_from = q2.id and
    pl2.post_id_to = q3.id and
    
    exists ( select * from comment where comment.site_id = q3.site_id and comment.post_id = q3.id ) and
    exists ( select * from comment where comment.site_id = q2.site_id and comment.post_id = q2.id ) and
    exists ( select * from comment where comment.site_id = q1.site_id and comment.post_id = q1.id ) and
    
    q1.score > q3.score;"""

    input = """
    SELECT MIN(an.name) AS alternative_name,
       MIN(chn.name) AS voiced_character,
       MIN(n.name) AS voicing_actress,
       MIN(t.title) AS american_movie
FROM aka_name AS an,
     char_name AS chn,
     cast_info AS ci,
     company_name AS cn,
     movie_companies AS mc,
     name AS n,
     role_type AS rt,
     title AS t
WHERE ci.note = '(voice)'
  AND cn.country_code ='[us]'
  AND mc.note LIKE '%(200%)%'
  AND (mc.note LIKE '%(USA)%'
       OR mc.note LIKE '%(worldwide)%')
  AND n.gender ='f'
  AND n.name LIKE '%Angel%'
  AND rt.role ='actress'
  AND t.production_year BETWEEN 2007 AND 2010
  AND ci.movie_id = t.id
  AND t.id = mc.movie_id
  AND ci.movie_id = mc.movie_id
  AND mc.company_id = cn.id
  AND ci.role_id = rt.id
  AND n.id = ci.person_id
  AND chn.id = ci.person_role_id
  AND an.person_id = n.id
  AND an.person_id = ci.person_id;"""
    res = analyze_sql(input)
    print(res)

    # table_info, table_cardinality_info, filter_cardinality_info = analyze_sql_and_stores(input)
    # print(table_info)
    # print(table_cardinality_info)
    # print(filter_cardinality_info)
