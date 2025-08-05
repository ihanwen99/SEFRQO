import re


def extract_xml_answer(text: str) -> str:
    answer = text.split("<answer>")[-1]
    answer = answer.split("</answer>")[0]
    return answer.strip()


def check_parentheses_all_match(text: str) -> bool:
    """
    检查文本中每一行括号是否匹配。
    !!! 前提每一行都包括括号 -> 没有的话就当不匹配处理
    """
    if "(" not in text or ")" not in text:
        return False

    lines = text.split('\n')
    for idx, line in enumerate(lines, 1):
        stack = []
        for char in line:
            if char == '(':
                stack.append(char)
            elif char == ')':
                if not stack or stack.pop() != '(':
                    # print(f"[paren_match] Line-{idx}: {line[:50]}... ❌ Mismatch")
                    return False
        if stack:
            # print(f"[paren_match] Line-{idx}: {line[:50]}... ❌ Mismatch")
            return False
    # print(f"[paren_match] ✅ All parentheses matched!")
    return True


def count_parentheses_match(text: str) -> bool:
    """
    计数文本中每一行括号匹配的情况。
    """
    lines = text.split('\n')
    total_count = 0
    total_lines = len(lines)

    for idx, line in enumerate(lines, 1):
        flag = True  # Flag for each line
        stack = []
        for char in line:
            if char == '(':
                stack.append(char)
            elif char == ')':
                if not stack or stack.pop() != '(':
                    # print(f"[paren_match] Line-{idx}: {line[:50]}... ❌ Mismatch")
                    flag = False
        if stack:
            # print(f"[paren_match] Line-{idx}: {line[:50]}... ❌ Mismatch")
            flag = False

        if '(' not in line or ')' not in line:
            # No ( or ) appears
            flag = False
        total_count += flag
    return total_count, total_lines


def count_parentheses(text: str) -> tuple[int, int]:
    """
    计算文本中的左右括号数量
    """
    left_count = text.count('(')
    right_count = text.count(')')
    return left_count, right_count


def normalize_hint(text: str) -> list:
    """
    将hint文本进行规范化为操作列表，便于逐行比较。
    """
    # 移除注释符号和多余空白
    text = re.sub(r'/\*|\*/', '', text).strip()
    lines = text.split('\n')
    # 清除空行和两侧空白
    return [line.strip() for line in lines if line.strip()]


from difflib import SequenceMatcher


def compare_hint_structure(generated: list, expected: list) -> float:
    """
    结合编辑距离和关键字匹配来衡量相似度。
    返回匹配程度的得分，范围为 0 ~ 1。
    """
    if not expected:
        return 0.0
    total_score = 0.0
    total = len(expected)

    for g_line, e_line in zip(generated, expected):
        # 编辑距离相似度
        edit_similarity = SequenceMatcher(None, g_line, e_line).ratio()

        # 关键字匹配相似度
        g_tokens = set(g_line.replace("(", " ").replace(")", " ").split())
        e_tokens = set(e_line.replace("(", " ").replace(")", " ").split())
        keyword_similarity = len(g_tokens.intersection(e_tokens)) / max(len(e_tokens), 1)

        # 综合得分 (可以根据需要调整权重)
        line_similarity = 0.6 * edit_similarity + 0.4 * keyword_similarity
        total_score += line_similarity

        # print(f"[HybridCheck] Line: {g_line[:30]}... | EditSim: {edit_similarity:.2f} | KeySim: {keyword_similarity:.2f} | TotalLineSim: {line_similarity:.2f}")

    final_score = total_score / total
    print(f"[Final Hybrid Score] Average similarity: {final_score:.2f}")
    return round(final_score, 2)
