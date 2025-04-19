import re

def convert_hint_to_plan(sql):
    # 提取提示部分：查找以 /*+ 开始、以 */ 结束的提示块
    hint_match = re.search(r'/\*\+(.*?)\*/', sql, flags=re.DOTALL)
    if hint_match:
        hint_text = hint_match.group(1)
        # 移除提示块中的 -- 注释（行内或整行）
        hint_text = re.sub(r'--.*', '', hint_text)
    else:
        # 如果没有提示块，则去掉所有 SQL 注释（包括块注释和行注释）
        hint_text = re.sub(r'/\*.*?\*/', '', sql, flags=re.DOTALL)
        hint_text = re.sub(r'--.*', '', hint_text)
    
    # 按行分割并清理掉空行
    lines = [line.strip() for line in hint_text.splitlines() if line.strip()]
    
    # 定义扫描行匹配模式（只处理 SeqScan, IndexOnlyScan, IndexScan）
    scan_pattern = re.compile(r'^(SeqScan|IndexOnlyScan|IndexScan)\(')
    
    # 找到第一条扫描语句所在的行索引
    start_idx_scan = 0
    for i, line in enumerate(lines):
        if scan_pattern.search(line):
            start_idx_scan = i
            break

    # 构建扫描字典：键为表名，值为扫描类型（直接使用原扫描类型字符串）
    scan_dict = {}
    for i in range(start_idx_scan, len(lines)):
        line = lines[i]
        if scan_pattern.search(line):
            m = re.match(r'(SeqScan|IndexOnlyScan|IndexScan)\((\w+)\)', line)
            if m:
                scan_type, table_name = m.groups()
                scan_dict[table_name] = scan_type

    # 用两个集合分别记录剩余的扫描表和子树
    remaining_tables = set(scan_dict.keys())
    remaining_subtrees = set()
    steps = []

    def parse_operands(expr):
        expr = expr.strip()
        # 去掉最外层的括号
        if expr.startswith('(') and expr.endswith(')'):
            expr = expr[1:-1].strip()
        depth = 0
        split_pos = None
        # 按照第一个顶层空格拆分为左右两个操作数
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
        # 对操作数列表中的每个元素提取所有单词（无论是否带括号）
        expanded_operands = []
        for operand in operands:
            if operand is None:
                continue
            if '(' in operand and ')' in operand:
                expanded_operands.extend(re.findall(r'\w+', operand))
            else:
                expanded_operands.extend(operand.split())
        return expanded_operands

    # 逆向处理提示块中扫描语句前的连接操作
    for i in range(start_idx_scan - 1, -1, -1):
        join_type, expr = parse_line(lines[i])
        left_operand, right_operand = parse_operands(expr)
        operands = [left_operand, right_operand]
        # 提取当前表达式中所有单个标识符（可能为扫描表或之前生成的子树标识）
        expanded_operands = expand_operands(operands)

        # 对每个 token 检查：若在 remaining_tables 中则输出 Pick 步骤并移除，
        # 若在 remaining_subtrees 中则移除（代表该子树已被“使用”）
        for token in expanded_operands:
            if token in remaining_tables:
                steps.append(f'Pick table {token}, with a label "{scan_dict[token]}".')
                remaining_tables.remove(token)
            elif token in remaining_subtrees:
                remaining_subtrees.remove(token)

        # 生成连接步骤描述：若操作数在 scan_dict 中则视为表，否则视为子树
        left_desc = f'table {left_operand}' if left_operand in scan_dict else f'subtree {left_operand}'
        right_desc = f'table {right_operand}' if right_operand in scan_dict else f'subtree {right_operand}'
        steps.append(f'Join {left_desc} and {right_desc} as {expr}, with a label "{join_type}".')
        # 将当前连接表达式作为新生成的子树加入 remaining_subtrees
        remaining_subtrees.add(expr)
        
        # 输出当前剩余项：集合为 remaining_tables ∪ remaining_subtrees
        current_remaining = sorted(list(remaining_tables | remaining_subtrees))
        remaining_str = ' '.join(current_remaining)
        steps.append(f'Check remaining tables and subtrees: {remaining_str}.')

        # 后续决策逻辑保持原有比较方式
        if i != 0:
            _, expr_next = parse_line(lines[i - 1])
            left_operand_next, right_operand_next = parse_operands(expr_next)
            expanded_operands_next = expand_operands([left_operand_next, right_operand_next])
            if (len(set(expanded_operands_next) - set(expanded_operands)) == 1) or i == 1:
                steps.append('Decide not to divide the candidate table set into two subsets and tackle each of them recursively.')
            else:
                steps.append('Decide to divide the candidate table set into two subsets and tackle each of them recursively.')

    return '\n'.join(steps)

