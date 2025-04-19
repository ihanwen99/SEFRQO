import re

def is_left_deep_hint_reasonable(hint, sql_query):
    # Extract table aliases from the FROM clause
    from_clause_match = re.search(r'FROM\s+(.+?)(?:\s+WHERE|\s*$)', sql_query, re.IGNORECASE | re.DOTALL)
    if not from_clause_match:
        return False
    from_clause = from_clause_match.group(1)

    # Split the FROM clause by commas
    tables = re.split(r',\s*', from_clause.strip())

    tables_in_sql = []
    for table_def in tables:
        # Extract table name and alias
        table_def = table_def.strip()
        match = re.match(r'([a-zA-Z_][a-zA-Z0-9_]*)\s+(?:AS\s+)?([a-zA-Z_][a-zA-Z0-9_]*)', table_def, re.IGNORECASE)
        if match:
            table_name = match.group(1)
            alias = match.group(2)
            tables_in_sql.append(alias)
        else:
            # No alias
            table_name = table_def
            alias = table_name
            tables_in_sql.append(alias)

    tables_in_sql = set(tables_in_sql)

    # Parse the hint
    scans = re.findall(r'(SeqScan|IndexScan)\((\w+)\)', hint)
    joins = re.findall(r'(HashJoin|MergeJoin|NestLoop)\(([\w\s]+)\)', hint)
    leading = re.findall(r'Leading\((.+)\)', hint, re.DOTALL)

    # Check scan operators and ensure they use allowed scan types
    scan_tables = []
    allowed_scan_types = ['SeqScan', 'IndexScan']
    for scan_op, table in scans:
        if scan_op not in allowed_scan_types:
            return False
        scan_tables.append(table.strip())

    # Check for duplicate tables in scans
    if len(scan_tables) != len(set(scan_tables)):
        # Duplicate tables in scans
        return False

    if set(scan_tables) != tables_in_sql:
        return False

    # Check join operators and ensure they use allowed join types
    join_sequences = []
    allowed_join_types = ['HashJoin', 'MergeJoin', 'NestLoop']
    for join_op, tables_str in joins:
        if join_op not in allowed_join_types:
            return False
        join_tables = tables_str.strip().split()
        join_sequences.append(join_tables)

    # Reverse the join sequences to start from the smallest join
    join_sequences.reverse()

    # The number of join operations should be number of scans minus one
    if len(joins) != len(scans) - 1:
        return False

    # Check that each join adds exactly one new table to the previous set
    previous_tables = []
    for idx, join_tables in enumerate(join_sequences):
        # Check for duplicates within the join sequence
        if len(join_tables) != len(set(join_tables)):
            return False
        if idx == 0:
            # First join must join two tables
            if len(join_tables) != 2:
                return False
            previous_tables = join_tables
        else:
            # Subsequent joins should add one new table to previous_tables
            if len(join_tables) != len(previous_tables) + 1:
                return False
            # The new table should be added either at the beginning or the end
            if join_tables[1:] == previous_tables:
                # New table added at the front
                previous_tables = join_tables
            elif join_tables[:-1] == previous_tables:
                # New table added at the end
                previous_tables = join_tables
            else:
                return False

    # All tables in joins should be from tables_in_sql
    all_join_tables = set(table for seq in join_sequences for table in seq)
    if not all_join_tables.issubset(tables_in_sql):
        return False

    # Check Leading hint structure
    if leading:
        leading_hint = leading[0].strip()

        # Parse the Leading hint to check the join sequence
        def parse_leading(s):
            tokens = re.findall(r'\(|\)|\w+', s)
            idx = 0

            def parse_group():
                nonlocal idx
                group = []
                while idx < len(tokens):
                    token = tokens[idx]
                    idx += 1
                    if token == '(':
                        subgroup = parse_group()
                        if subgroup is None:
                            return None
                        group.append(subgroup)
                    elif token == ')':
                        break
                    else:
                        group.append(token)
                return group

            leading_structure = parse_group()
            if idx != len(tokens):
                return None
            return leading_structure

        leading_structure = parse_leading(leading_hint)
        if not leading_structure:
            return False

        # Function to extract join sequences from the leading structure
        def extract_join_sequences(structure):
            sequences = []
            def helper(node):
                if isinstance(node, list):
                    # If node has more than one element, it's a join
                    if len(node) > 1:
                        # Flatten left and right sides
                        left_tables = get_tables(node[0])
                        right_tables = get_tables(node[1])
                        sequences.append(left_tables + right_tables)
                    # Recurse into each child
                    for child in node:
                        helper(child)
            def get_tables(node):
                if isinstance(node, list):
                    tables = []
                    for child in node:
                        tables.extend(get_tables(child))
                    return tables
                else:
                    return [node]
            helper(leading_structure)
            return sequences

        leading_join_sequences = extract_join_sequences(leading_structure)
        leading_join_sequences.reverse()

        # Compare the extracted join sequences with the ones from the other hints
        if leading_join_sequences != join_sequences:
            return False

    return True


def is_bushy_hint_reasonable(hint, sql_query):
    class Node:
        def __init__(self, tables, join_type=None, left=None, right=None):
            self.tables = tables  # Set of table names
            self.join_type = join_type  # 'HashJoin', 'NestLoop', etc.
            self.left = left  # Left child node
            self.right = right  # Right child node

        def __eq__(self, other):
            if not isinstance(other, Node):
                return False
            return (self.tables == other.tables and
                    self.left == other.left and
                    self.right == other.right)

        def __repr__(self):
            if self.left and self.right:
                return f"({self.left} {self.join_type} {self.right})"
            else:
                return f"{self.tables}"

    # Extract table aliases from the FROM clause
    from_clause_match = re.search(
        r'FROM\s+(.+?)(?:\s+WHERE|\s*$)',
        sql_query,
        re.IGNORECASE | re.DOTALL
    )
    if not from_clause_match:
        return False
    from_clause = from_clause_match.group(1)

    # Split the FROM clause by commas
    tables = re.split(r',\s*', from_clause.strip())

    tables_in_sql = set()
    for table_def in tables:
        # Extract table name and alias
        table_def = table_def.strip()
        match = re.match(
            r'([a-zA-Z_][a-zA-Z0-9_]*)\s+(?:AS\s+)?([a-zA-Z_][a-zA-Z0-9_]*)',
            table_def,
            re.IGNORECASE
        )
        if match:
            alias = match.group(2)
        else:
            alias = table_def
        tables_in_sql.add(alias)

    # Parse the hint
    scans = re.findall(r'(SeqScan|IndexScan)\((\w+)\)', hint)
    joins = re.findall(r'(HashJoin|MergeJoin|NestLoop)\(([\w\s]+)\)', hint)
    leading_match = re.search(r'Leading\((.+)\)', hint, re.DOTALL)
    if not leading_match:
        return False
    leading_hint = leading_match.group(1).strip()

    # Collect all tables used in the hint
    tables_in_hint = set()
    for _, table in scans:
        tables_in_hint.add(table.strip())

    for join_op, tables_str in joins:
        join_tables = tables_str.strip().split()
        for table in join_tables:
            tables_in_hint.add(table.strip())

    # Now, we need to check if tables_in_sql matches tables_in_hint
    if tables_in_sql != tables_in_hint:
        return False

    # Build the tree from the Leading hint
    def parse_leading(s):
        tokens = re.findall(r'\(|\)|\w+', s)
        idx = 0

        def parse_group():
            nonlocal idx
            group = []
            while idx < len(tokens):
                token = tokens[idx]
                idx += 1
                if token == '(':
                    subgroup = parse_group()
                    if subgroup is None:
                        return None
                    group.append(subgroup)
                elif token == ')':
                    break
                else:
                    group.append(token)
            return group

        leading_structure = parse_group()
        if idx != len(tokens):
            return None
        return leading_structure

    leading_structure = parse_leading(leading_hint)
    if not leading_structure:
        return False

    # Build tree from Leading hint
    def build_tree_from_leading(structure):
        if isinstance(structure, str):
            return Node(tables={structure})
        elif isinstance(structure, list):
            if len(structure) == 1:
                return build_tree_from_leading(structure[0])
            elif len(structure) >= 2:
                left_node = build_tree_from_leading(structure[0])
                right_node = build_tree_from_leading(structure[1])
                combined_tables = left_node.tables.union(right_node.tables)
                return Node(
                    tables=combined_tables,
                    left=left_node,
                    right=right_node
                )
            else:
                return None
        else:
            return None

    leading_tree = build_tree_from_leading(leading_structure)
    if not leading_tree:
        return False

    # Parse the join operators and build the tree
    join_ops = []
    for join_op, tables_str in joins:
        join_tables = tables_str.strip().split()
        join_ops.append({
            'join_type': join_op,
            'tables': join_tables
        })

    # Build the tree from join operators
    def build_tree_from_joins(join_ops, scan_tables):
        # Create initial nodes for scan tables
        nodes = [Node(tables={table}) for table in scan_tables]

        # Process join operations in reverse order (from leaves to root)
        for join in reversed(join_ops):
            join_type = join['join_type']
            join_tables = set(join['tables'])

            # Find nodes that together cover the join_tables
            involved_nodes = []
            remaining_tables = set(join_tables)
            for node in nodes:
                if node.tables & join_tables:
                    involved_nodes.append(node)
                    remaining_tables -= node.tables

            if remaining_tables:
                # Some tables in join_tables are not accounted for
                return None

            if len(involved_nodes) < 2:
                # Need at least two nodes to perform a join
                return None

            # Merge all involved nodes into one node
            combined_tables = set()
            for node in involved_nodes:
                combined_tables.update(node.tables)
                nodes.remove(node)

            # Create new node
            new_node = Node(
                tables=combined_tables,
                join_type=join_type,
                left=involved_nodes[0],
                right=involved_nodes[1] if len(involved_nodes) > 1 else None
            )

            # Add the new node to the list of nodes
            nodes.append(new_node)

        # After processing all joins, there should be one node left
        if len(nodes) != 1:
            return False
        return nodes[0]

    # Extract scan tables
    scan_tables = [table for _, table in scans]

    # Ensure that the scan tables match the tables from the SQL
    if set(scan_tables) != tables_in_sql:
        return False

    # Build the tree from join operators
    join_tree = build_tree_from_joins(join_ops, scan_tables)
    if not join_tree:
        return False

    # Compare the two trees
    def compare_trees(node1, node2):
        if node1 is None and node2 is None:
            return True
        if (node1 is None) != (node2 is None):
            return False
        if node1.tables != node2.tables:
            return False
        # We allow any join type as long as the structure is the same
        return ((compare_trees(node1.left, node2.left) and compare_trees(node1.right, node2.right)) or
                (compare_trees(node1.left, node2.right) and compare_trees(node1.right, node2.left)))

    return compare_trees(leading_tree, join_tree)
