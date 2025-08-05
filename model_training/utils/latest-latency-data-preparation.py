import json

from hanwen.db.normal_execution import execute_query
from hanwen.db.remote_db_connection import get_remote_connection
from hanwen.db.remote_db_connection2 import execute_query_remote_with_states


def hanwen_generate_grpo_dataset(input_data_dir, output_data_dir):
    """Local Version"""
    with open(input_data_dir, 'r') as fin:
        raw_data = json.load(fin)
        length = len(raw_data)

    dataset = []
    counter = 0
    for data in raw_data:
        sql = data["sql"]
        best_hint = data["best_hints"]
        card_tb = data["card_tb"]

        _, _, execution_time1, _ = execute_query(sql)
        _, _, execution_time2, _ = execute_query(sql)
        _, _, execution_time3, _ = execute_query(sql)
        _, _, execution_time4, _ = execute_query(sql)
        _, _, execution_time5, _ = execute_query(sql)
        execution_time = (execution_time1 + execution_time2 + execution_time3 + execution_time4 + execution_time5) / 5

        data = {"sql": sql, "hints": best_hint, "card": card_tb, "pg_exectime": execution_time}
        print(counter, data)
        counter += 1

        dataset.append(data)

    with open(output_data_dir, 'w') as fout:
        json.dump(dataset, fout, indent=4)


def hanwen_generate_grpo_dataset_remote(input_data_dir, output_data_dir):
    tunnel, conn = get_remote_connection()
    with open(input_data_dir, 'r') as fin:
        raw_data = json.load(fin)
        length = len(raw_data)

    dataset = []
    counter = 0
    for data in raw_data:
        sql = data["sql"]
        best_hint = data["best_hints"]
        card_tb = data["card_tb"]

        _, _, execution_time1, _ = execute_query_remote_with_states(sql, conn)
        _, _, execution_time2, _ = execute_query_remote_with_states(sql, conn)

        execution_time = (execution_time1 + execution_time2) / 2

        data = {"sql": sql, "hints": best_hint, "card": card_tb, "pg_exectime": execution_time}
        print(counter, data)
        counter += 1

        dataset.append(data)

    with open(output_data_dir, 'w') as fout:
        json.dump(dataset, fout, indent=4)


if __name__ == '__main__':
    input_data_dir = "../test_job.json"
    output_data_dir = "../job_grpo_remote.json"
    hanwen_generate_grpo_dataset_remote(input_data_dir, output_data_dir)
