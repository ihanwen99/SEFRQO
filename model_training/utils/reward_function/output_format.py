import re
from hanwen.reward_function.utils import extract_xml_answer


# 大体准确，继续沿用
def output_size_reward_func(completions, **kwargs) -> list[float]:
    """
    检查输出的情况：避免输出为空或者太长
    - 如果长度太小，得分为 -1
    - 如果长度太大，得分为 -1
    - 正常输出为 1
    """
    scores = []
    for i, completion in enumerate(completions):
        response = extract_xml_answer(completion[0]['content'])  # Only focus on the answer
        print("len(response): ", len(response))
        if len(response) < 10:
            score = -1
        elif len(response) > 1000:
            score = -1
        else:
            score = 1
        scores.append(score)
    return scores


# 不够精确，弃用
def output_lines_reward_func(completions, **kwargs) -> list[float]:
    """
    检查输出的行数：
    - 如果行数 < 3，得分为 -1（输出太少）
    - 如果行数 > 20，得分为 -1（输出太多）
    - 正常输出为 1
    """
    scores = []
    for i, completion in enumerate(completions):
        response = extract_xml_answer(completion[0]['content'])  # Only focus on <answer></answer>
        line_count = len(response.splitlines())

        if line_count < 3:
            score = -1
            print(f"[Sample {i}] ❌ 行数太少 ({line_count} 行) => Score: {score}")
        elif line_count > 20:
            score = -1
            print(f"[Sample {i}] ❌ 行数太多 ({line_count} 行) => Score: {score}")
        else:
            score = 1
            print(f"[Sample {i}] ✅ 行数正常 ({line_count} 行) => Score: {score}")

        scores.append(score)
    return scores


def output_lines_size_response_vs_answer_reward_func(prompts, completions, answer, **kwargs) -> list[float]:
    """
    检查行数是不是匹配的
    """
    scores = []
    for i, completion in enumerate(completions):
        response = extract_xml_answer(completion[0]['content'])
        response_lines = len(response.split('\n')) - 2  # 删掉 <answer></answer>
        gold_answer = answer[i]
        gold_answer_valid_lines = len(gold_answer.split('\n')) - 1  # 因为最后面有空行
        score = -abs(response_lines - gold_answer_valid_lines)
        print(f"[和答案的行数差距] Sample-{i} | parentheses_response_vs_answer: {score:.2f}")
        scores.append(score)
    return scores

def unique_line_reward_func(completions, **kwargs) -> list[float]:
    """
    检查 response 的每一行是否唯一。
    如果所有行都不重复，则返回 1.0，否则返回 0.0。
    """
    scores = []
    for i, completion in enumerate(completions):
        response = extract_xml_answer(completion[0]['content'])  # 提取模型的输出内容
        lines = response.split("\n")  # 按行拆分

        unique_lines = set(lines)  # 使用集合去重
        score = 1.0 if len(unique_lines) == len(lines) else -100.0  # 计算唯一性得分

        scores.append(score)
        print(f"[唯一性检查] Sample-{i} | unique_lines: {score:.2f}")
    
    return scores

# def compare_hint_structure(generated: list, expected: list) -> float:
#     """
#     对生成的hint和期望的hint进行结构比较。
#     返回匹配程度的得分。
#     """
#     if not expected:
#         return 0.0
#     total = len(expected)
#     matches = sum(1 for g, e in zip(generated, expected) if g == e)
# return matches / total


def strict_format_reward_func(completions, **kwargs) -> list[float]:
    """检查生成的文本是否严格匹配给定的XML格式。"""
    # 定义严格的正则表达式模式
    pattern = r"^<answer>\n.*?\n</answer>\n$"
    # 提取每个生成文本内容
    responses = [completion[0]["content"] for completion in completions]
    # 检查每个响应是否匹配正则表达式
    matches = [re.match(pattern, r) for r in responses]
    return [1 if match else 0.0 for match in matches]


def soft_format_reward_func(completions, **kwargs) -> list[float]:
    """检查生成的文本是否宽松匹配给定的XML格式。"""
    # 定义宽松的正则表达式模式
    pattern = r"<answer>.*?</answer>"
    # 提取每个生成文本内容
    responses = [completion[0]["content"] for completion in completions]
    # 检查每个响应是否匹配正则表达式
    matches = [re.match(pattern, r) for r in responses]
    return [1 if match else 0.0 for match in matches]


def count_xml(text) -> float:
    count = 0.0
    # 检查是否有 <answer> 标签
    if text.count("\n<answer>\n") == 1:
        count += 0.5
        # 根据 </answer> 后的文本长度进行惩罚
        count -= len(text.split("\n</answer>\n")[-1]) * 0.001
    # 检查是否有 </answer> 标签
    if text.count("\n</answer>") == 1:
        count += 0.5
        # 根据 </answer> 后的文本长度进行惩罚
        count -= (len(text.split("\n</answer>")[-1]) - 1) * 0.001
    return count * 1


def output_xmlcount_reward_func(completions, **kwargs) -> list[float]:
    contents = [completion[0]["content"] for completion in completions]
    return [count_xml(c) for c in contents]
