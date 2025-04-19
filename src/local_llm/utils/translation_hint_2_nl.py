import re

def convert_hint_to_plan(sql):
    # extract the hint part: find the hint block that starts with /*+ and ends with */
    hint_match = re.search(r'/\*\+(.*?)\*/', sql, flags=re.DOTALL)
    if hint_match:
        hint_text = hint_match.group(1)
        # remove the -- comments (inline or whole line) in the hint block
        hint_text = re.sub(r'--.*', '', hint_text)
    else:
        # if there is no hint block, remove all SQL comments (including block comments and line comments)
        hint_text = re.sub(r'/\*.*?\*/', '', sql, flags=re.DOTALL)
        hint_text = re.sub(r'--.*', '', hint_text)
    
    # split by line and clean empty lines
    lines = [line.strip() for line in hint_text.splitlines() if line.strip()]
    
    # define the scan line matching pattern (only process SeqScan, IndexOnlyScan, IndexScan)
    scan_pattern = re.compile(r'^(SeqScan|IndexOnlyScan|IndexScan)\(')
    
    # find the index of the first scan line
    start_idx_scan = 0
    for i, line in enumerate(lines):
        if scan_pattern.search(line):
            start_idx_scan = i
            break

    # build the scan dictionary: key is the table name, value is the scan type (use the original scan type string directly)
    scan_dict = {}
    for i in range(start_idx_scan, len(lines)):
        line = lines[i]
        if scan_pattern.search(line):
            m = re.match(r'(SeqScan|IndexOnlyScan|IndexScan)\((\w+)\)', line)
            if m:
                scan_type, table_name = m.groups()
                scan_dict[table_name] = scan_type

    # use two sets to record the remaining scan tables and subtrees
    remaining_tables = set(scan_dict.keys())
    remaining_subtrees = set()
    steps = []

    def parse_operands(expr):
        expr = expr.strip()
        # remove the outermost parentheses
        if expr.startswith('(') and expr.endswith(')'):
            expr = expr[1:-1].strip()
        depth = 0
        split_pos = None
        # split by the first top-level space into two operands
        for i, c in enumerate(expr):
            if c == '(':
                depth += 1
            elif c == ')':
                depth -= 1
            elif c == ' ' and depth == 0:
                split_pos = i
                break
        if split_pos is not None:
            left = expr[:split_pos].strip()
            right = expr[split_pos+1:].strip()
            return left, right
        else:
            return expr, None

    def parse_line(line):
        line = line.strip()
        if not line:
            return None, None
        idx = line.find('(')
        if idx == -1:
            return None, None
        join_type = line[:idx].strip()
        expr = line[idx:].strip()
        return join_type, expr

    def expand_operands(operands):
        # extract all words (whether with parentheses or not) from the list of operands
        expanded_operands = []
        for operand in operands:
            if operand is None:
                continue
            if '(' in operand and ')' in operand:
                expanded_operands.extend(re.findall(r'\w+', operand))
            else:
                expanded_operands.extend(operand.split())
        return expanded_operands

    # reverse process the join operations before the scan statements in the hint block
    for i in range(start_idx_scan - 1, -1, -1):
        join_type, expr = parse_line(lines[i])
        left_operand, right_operand = parse_operands(expr)
        operands = [left_operand, right_operand]
        # extract all single identifiers (possibly scan tables or previously generated subtree identifiers)
        expanded_operands = expand_operands(operands)

        # check each token: if it is in remaining_tables, output the Pick step and remove it,
        # if it is in remaining_subtrees, remove it (representing that the subtree has been "used")
        for token in expanded_operands:
            if token in remaining_tables:
                steps.append(f'Pick table {token}, with a label "{scan_dict[token]}".')
                remaining_tables.remove(token)
            elif token in remaining_subtrees:
                remaining_subtrees.remove(token)

        # generate the join step description: if the operand is in scan_dict, it is regarded as a table, otherwise it is regarded as a subtree
        left_desc = f'table {left_operand}' if left_operand in scan_dict else f'subtree {left_operand}'
        right_desc = f'table {right_operand}' if right_operand in scan_dict else f'subtree {right_operand}'
        steps.append(f'Join {left_desc} and {right_desc} as {expr}, with a label "{join_type}".')
        # add the current join expression as a newly generated subtree to remaining_subtrees
        remaining_subtrees.add(expr)
        
        # output the current remaining items: the union of remaining_tables and remaining_subtrees
        current_remaining = sorted(list(remaining_tables | remaining_subtrees))
        remaining_str = ' '.join(current_remaining)
        steps.append(f'Check remaining tables and subtrees: {remaining_str}.')

        # the subsequent decision logic remains the same comparison method
        if i != 0:
            _, expr_next = parse_line(lines[i - 1])
            left_operand_next, right_operand_next = parse_operands(expr_next)
            expanded_operands_next = expand_operands([left_operand_next, right_operand_next])
            if (len(set(expanded_operands_next) - set(expanded_operands)) == 1) or i == 1:
                steps.append('Decide not to divide the candidate table set into two subsets and tackle each of them recursively.')
            else:
                steps.append('Decide to divide the candidate table set into two subsets and tackle each of them recursively.')

    return '\n'.join(steps)

