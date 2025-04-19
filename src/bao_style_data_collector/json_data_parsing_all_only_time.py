import json
import os
import glob

# read a json file and return the data
def read_json_file(file_path):
    with open(file_path, 'r', encoding='utf-8') as f:
        data = json.load(f)
    return data

json_directory = "/home/qihanzha/LLM4QO/src/bao_style_data_collector/stackoverflow_raw_exec_records"

# get all the json files in the directory
json_files = glob.glob(os.path.join(json_directory, "*.txt"))

        
# get the minimum execution time for each sql file, and the corresponding arm
for json_file in json_files:
    data = read_json_file(json_file)
    min_execution_time = 30000
    min_arm = -1
    for i in range(len(data['results'])):
        if data['results'][i]["execution_time"] == None:
            continue

        if float(data['results'][i]["execution_time"]) < min_execution_time:
            min_execution_time = data['results'][i]["execution_time"]
            min_arm = data['results'][i]["arm"]

    with open("best_plans_execution_time_stackoverflow.txt", 'a') as f:
        f.write("sql file: " + data['sql_file'] +  "\n\nBao execution time: " + str(data['results'][min_arm]['execution_time']) + "\n\n\n")
        f.write("sql file: " + data['sql_file'] +  "\n\nPostgres execution time: " + str(data['results'][0]['execution_time']) + "\n\n\n")
    