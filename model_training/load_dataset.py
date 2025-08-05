import json
from datasets import Dataset
import re

def remove_sql_comments(sql):
    # Remove single-line comments
    sql = re.sub(r'--.*', '', sql)
    # Remove multi-line comments
    sql = re.sub(r'/\*.*?\*/', '', sql, flags=re.DOTALL)
    sql = re.sub(r'\n+', '\n', sql, flags=re.DOTALL)
    return sql.strip()

def hanwen_prepare_pg_execution_time(data):
    return data['pg_exectime']

def hanwen_prepare_grpo_prompt(data):
    data['sql'] = remove_sql_comments(data['sql'])
    seq = "*** sql ***\n{}\n".format(data['sql'])
    seq += f"*** table information *** :\n{data['card']}\n"
    return seq

def hanwen_generate_grpo_dataset(sql2hints_data_dir):
    with open(sql2hints_data_dir, 'r') as fin:
            raw_data = json.load(fin)
            length = len(raw_data)

    #  Initialization
    data_set = {'prompt': [], 'answer': []}

    for i in range(length):
        data = raw_data[i]
        constructed_prompt = hanwen_prepare_grpo_prompt(data)
        prompt = [{"role": "user", "content": constructed_prompt}]
        data_set["prompt"].append(prompt)
        # data_set["answer"].append(data["best_hints"])
        data_set["answer"].append(hanwen_prepare_pg_execution_time(data))
    
    final_dataset = Dataset.from_dict(data_set)
    return final_dataset

if __name__ == '__main__':
    sql2hints_data_dir = "your_path/job_grpo.json"
    hanwen_generate_grpo_dataset(sql2hints_data_dir)