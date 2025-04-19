
def parse_join_tree(lines):
    """Parse the query plan text and extract join operations and scan methods"""
    joins = []
    scans_dict = {}
    leading_join_expression = ''
    
    for line in lines.split('\n'):
        line = line.strip()
        if not line:
            continue
                
        if line.startswith('Join'):
            # Extract join type and join expression
            # Line format:
            # 'Join [table/subtree] A [and/with] [table/subtree] B as (join_expression), with a label "JoinType".'
            parts = line.split('with a label')
            join_info = parts[0]
            join_type = parts[1].strip().strip('".')
                
            # Now extract the join expression
            # The join expression is the part after 'as', before ', with a label'
            as_index = join_info.find(' as ')
            if as_index != -1:
                join_expression_part = join_info[as_index + 4:]
                # Remove any trailing commas or periods
                join_expression = join_expression_part.strip().strip(',.')
                # Add the join hint
                joins.append(f"{join_type}{join_expression}")
                # Update the leading join expression
                leading_join_expression = join_expression.strip()
        elif line.startswith('Pick table'):
            # Extract scan type and table
            parts = line.split('with a label')
            table_part = parts[0]
            scan_type = parts[1].strip().strip('".')
            # Extract table name
            table = table_part[len('Pick table'):].strip().strip(',')
            scans_dict[table] = f"{scan_type}({table})"
    
    # Return joins, scans dictionary, and the final join expression for the Leading hint
    return joins, scans_dict, leading_join_expression

def extract_tables_from_expression(expression):
    """Extract tables from the leading join expression in order"""
    # Remove outermost parentheses
    expression = expression.strip()
    if expression.startswith('(') and expression.endswith(')'):
        expression = expression[1:-1]
    # Initialize a stack and list to store tables
    stack = []
    table_list = []
    i = 0
    while i < len(expression):
        if expression[i] == '(':
            stack.append('(')
            i += 1
        elif expression[i] == ')':
            if stack and stack[-1] == '(':
                stack.pop()
            i += 1
        elif expression[i].isspace():
            i += 1
        else:
            # Read a table name
            start = i
            while i < len(expression) and not expression[i].isspace() and expression[i] != '(' and expression[i] != ')':
                i += 1
            table = expression[start:i]
            table_list.append(table)
    return table_list

def generate_sql_hint(joins, scans_dict, leading_join_expression):
    """Generate SQL hint from parsed joins and scans"""
    hint_parts = []
    
    # Reverse the joins to match the desired output order
    joins.reverse()
    # Add all joins
    hint_parts.extend(joins)
    
    # Extract tables from the leading_join_expression
    table_list = extract_tables_from_expression(leading_join_expression)
    
    # Reorder scans according to the order of tables in table_list
    scans = [scans_dict[table] for table in table_list if table in scans_dict]
    
    # Add all scans
    hint_parts.extend(scans)
    
    # Add Leading hint with the final join structure
    if leading_join_expression:
        hint_parts.append(f"Leading{leading_join_expression}")
    
    # Combine all hints
    return "/*+ " + "\n".join(hint_parts) + " */"

def convert_plan_to_hint(plan_text):
    """Convert query plan text to SQL hints"""
    joins, scans_dict, leading_join_expression = parse_join_tree(plan_text)
    return generate_sql_hint(joins, scans_dict, leading_join_expression)


