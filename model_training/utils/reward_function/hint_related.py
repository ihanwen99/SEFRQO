from dask.array import left_shift

from hanwen.reward_function.utils import extract_xml_answer, count_parentheses_match, \
    check_parentheses_all_match, count_parentheses, normalize_hint, compare_hint_structure


def basic_hint_format_reward_func(completions, **kwargs) -> list[float]:
    """
    检查生成的文本是否包含 '/*+' 和 '*/' 标志。
    score = (has_start + has_end) * 0.5
    """
    scores = []
    for i, completion in enumerate(completions):
        response = extract_xml_answer(completion[0]['content'])  # Only focus on the answer
        has_start, has_end = '/*+' in response, '*/' in response
        score = (has_start + has_end) * 0.5
        if not has_start and not has_end: score = 0
        scores.append(score)
        print(f"[basic_hint] Sample-{i} | '/*+': {has_start} | '*/': {has_end} | Score: {score:.2f}")
    return scores


def parentheses_matching_complete_reward_func(completions, **kwargs) -> list[float]:
    """
    检查生成内容的括号匹配情况。
    全匹配返回 1.0，否则返回 0.0，单行展示每个样本状态。
    """
    scores = []
    for i, completion in enumerate(completions):
        response = extract_xml_answer(completion[0]['content'])  # Only focus on the answer
        score = 1.0 if check_parentheses_all_match(response) else 0.0
        scores.append(score)
        print(f"[总体括号匹配情况] Sample-{i} | parentheses_matching_complete: {score:.2f}")
    return scores


def parentheses_matching_line_wise_reward_func(completions, **kwargs) -> list[float]:
    """
    逐行检查生成内容的括号匹配情况。
    score = total_count / total_lines * 10
    """
    scores = []
    for i, completion in enumerate(completions):
        response = extract_xml_answer(completion[0]['content'])  # Only focus on the answer
        total_count, total_lines = count_parentheses_match(response)
        score = total_count / total_lines * 10
        scores.append(score)
        print(f"[逐行括号匹配情况] Sample-{i} | parentheses_matching_line_wise: {score:.2f}")
    return scores


def parentheses_left_right_match_reward_func(completions, **kwargs) -> list[float]:
    """
    检查生成内容的左右括号匹配情况。
    """
    scores = []
    for i, completion in enumerate(completions):
        response = extract_xml_answer(completion[0]['content'])  # Only focus on the answer
        left_count, right_count = count_parentheses(response)
        score = 1.0 if left_count == right_count else -abs(left_count - right_count)
        scores.append(score)
        print(f"[左括号==右括号] Sample-{i} | parentheses_left_right_match: {score:.2f}")
    return scores


def parentheses_response_vs_answer_reward_func(prompts, completions, answer, **kwargs) -> list[float]:
    """
    检查回答vs答案里面的括号数量。
    """
    scores = []
    for i, completion in enumerate(completions):
        response = extract_xml_answer(completion[0]['content'])
        left_response_count, right_response_count = count_parentheses(response)
        gold_answer = answer[i]
        left_gold_answer_count, right_gold_answer_count = count_parentheses(gold_answer)
        score = -(abs(left_response_count - left_gold_answer_count) + abs(
            right_response_count - right_gold_answer_count))
        scores.append(score)
        print(f"[和答案的括号差距] Sample-{i} | parentheses_response_vs_answer: {score:.2f}")
    return scores


# def parentheses_matching_reward_func(completions, **kwargs) -> list[float]:
#     """
#     检查每一行的括号是否成对匹配，匹配得分按比例计算。
#     """
#
#     def check_line_parentheses(line: str) -> bool:
#         stack = []
#         for char in line:
#             if char == '(':
#                 stack.append(char)
#             elif char == ')':
#                 if not stack or stack.pop() != '(':
#                     return False
#         return not stack
#
#     scores = []
#     for completion in completions:
#         content = completion[0]["content"]
#         lines = content.split('\n')
#         line_scores = [0.05 if check_line_parentheses(line) else -0.1 for line in lines]
#         total_score = max(0.0, sum(line_scores))  # 保证不为负
#         print(f"[ParenthesesCheck] Score: {total_score} | Lines: {len(lines)}")
#         scores.append(total_score)
#     return scores


############### 语义匹配程度 ################
def hint_format_reward_func(prompts, completions, answer, **kwargs) -> list[float]:
    """
    检查生成的hint格式是否与对应的answer格式匹配。
    假设completions和answer一一对应。
    """
    scores = []
    for i, completion in enumerate(completions):
        response = extract_xml_answer(completion[0]['content'])  # Only focus on the answer
        expected_hint = normalize_hint(answer[i])  # ✅ 使用索引来匹配
        generated_hint = normalize_hint(response)

        # 计算匹配得分
        match_score = compare_hint_structure(generated_hint, expected_hint) * 10
        scores.append(match_score)

        # 打印调试信息
        # print(f"=== Prompt {i} ===\n{prompts[i][-1]['content']}\n")
        # print(f"=== Expected {i} ===\n{expected_hint}\n")
        # print(f"=== Generated {i} ===\n{generated_hint}\n")
        # print(f"=== Score {i} === {final_score}\n{'=' * 40}")

        print(f"=== Generated {i} === Score: {match_score}\n{response}\n{'=' * 40}")

    return scores


def leading_line_reward_func(completions, **kwargs) -> list[float]:
    """
    最后一行必须以 'Leading' 开头。
    """
    scores = []
    for completion in completions:
        lines = completion[0]["content"].strip().split('\n')
        last_line = lines[-1].strip() if lines else ""
        score = 0.5 if last_line.startswith("Leading") else 0.0
        print(f"[LeadingLine] Last line starts with 'Leading': {score} | Last line: {last_line}")
        scores.append(score)
    return scores
