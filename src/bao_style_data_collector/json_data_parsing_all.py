import json
import os
import glob

# read a json file and return the data
def read_json_file(file_path):
    with open(file_path, 'r', encoding='utf-8') as f:
        data = json.load(f)
    return data

json_directory = "/home/qihanzha/LLM4QO/execution_records/stackoverflow"

# get all the json files in the directory
json_files = glob.glob(os.path.join(json_directory, "*.txt"))

        
# get the minimum execution time for each sql file, and the corresponding arm
for json_file in json_files:
    data = read_json_file(json_file)
    min_execution_time = 600
    min_arm = -1
    for i in range(len(data['results'])):
        if data['results'][i]["execution_time"] == "timeout":
            continue
        if float(data['results'][i]["execution_time"]) < min_execution_time:
            min_execution_time = data['results'][i]["execution_time"]
            min_arm = data['results'][i]["arm"]
    # print("sql file: " + data['sql_file'] + " min execution time: " + str(min_execution_time) + " seconds, arm: " + str(min_arm))
    # write the result to a file, create one file that contains all the results
    with open("min_execution_time.txt", 'a') as f:
        f.write("sql file: " + data['sql_file'] + "\n\nsql: " +  str(data['query'])
                + "\n\ndetailed info: " + str(data['results'][min_arm]) + "\n\n\n")
    