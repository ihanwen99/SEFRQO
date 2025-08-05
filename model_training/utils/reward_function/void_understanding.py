"""
Try to understand the input and output of the reward function.
"""
from hanwen.reward_function.utils import extract_xml_answer


### Reward functions
def test_reward_function(prompts, completions, answer, **kwargs):
    # print("prompts: ", prompts)
    prompt_length = len(prompts)
    print("prompt_length: ", prompt_length)

    completion_length = len(completions)
    print("completion_length: ", completion_length)

    answers_length = len(answer)
    print("answers_length: ", answers_length)

    # print("completions: ", completions)
    # for completion in completions:
    for i in range(completion_length):
        completion = completions[i]
        # print("= completion: ", completion)
        # print("=> prompt: ", prompts[i])
        print("==> answer: ", answer[i])

        # print(completion)
        # print(len(completion))

        # print(completion[0]['content'])
        print("===> extract: ", extract_xml_answer(completion[0]['content']))
        print()
        print()

    return [1.0] * completion_length


def temp_reward_func(prompts, completions, answers, **kwargs) -> list[float]:
    rewards = []
    for completion in completions:
        rewards.append(1)
    return rewards
