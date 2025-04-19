#!/bin/bash
source ~/anaconda3/bin/activate  llmdb



pg_ctl -D /home/qihanzha/databases/ restart -l logfile
python /home/qihanzha/LLM4QO/src/local_llm/local_version_general_online_record_llama3_2_3B.py \
    > /home/qihanzha/LLM4QO/src/local_llm/formal_imdb_50_1ref_prompt_FullPlan_NoExec_llama3_2_3B_updaterag.log 2>&1

pg_ctl -D /home/qihanzha/databases/ restart -l logfile
    python /home/qihanzha/LLM4QO/src/local_llm/local_version_general_online_record_llama3_2_dynamic_3B.py \
    > /home/qihanzha/LLM4QO/src/local_llm/formal_imdb_imdb_50_1ref_prompt_FullPlan_NoExec_llama3_2_dynamic_3B_updaterag.log 2>&1

pg_ctl -D /home/qihanzha/databases/ restart -l logfile
python /home/qihanzha/LLM4QO/src/local_llm/local_version_general_online_record_llama3_2_SO_3B.py \
    > /home/qihanzha/LLM4QO/src/local_llm/formal_so_50_1ref_prompt_FullPlan_NoExec_llama3_2_SO_3B_updaterag.log 2>&1








