import re

from hanwen.db.normal_execution import execute_query


def compute_latency_reward(llm_query_latency, baseline_latency):
    """Less llm_query_latency is encouraged."""
    reward = (baseline_latency - llm_query_latency) / baseline_latency
    return reward


def latency_reward_func(prompts, completions, answer, **kwargs) -> list[float]:
    """
    Assigns rewards based on the latency of each generated SQL query.
    Lower latency results in a higher reward.
    Returns:
        list[float]: A list of rewards corresponding to each completion.
    """
    rewards = []
    completion_length = len(completions)
    print("completion_length: ", completion_length)
    for i in range(completion_length):
        completion = completions[i]
        prompt = prompts[i]
        # Step 1: Extract the query information
        pattern = r'\*\*\*\s*sql\s*\*\*\*\s*([\s\S]*?);'
        match = re.search(pattern, prompt[0]['content'])
        sql = match.group(1).strip()
        print("sql[{}]: ".format(i), sql)

        # Step 2: Fetch the hint and construct the query
        llm_output = completion[0]['content']
        hint = "/*+ {} */".format(llm_output)
        print("hint[{}]: ".format(i), hint)
        query_with_hint = hint + sql

        # Step 3: Execute the query
        _, _, current_execution_time, _ = execute_query(query_with_hint)
        if current_execution_time is None:
            rewards.append(-3)
            continue

        # Step 4:
        baseline_exectime = int(answer[i])
        reward = compute_latency_reward(current_execution_time, baseline_exectime)
        if reward < -3: reward = -3
        print("reward[{}]: ".format(i), reward)
        rewards.append(reward)
    return rewards


def test():
    i = 0
    sql_input = "SELECT MIN ( an . name ) AS acress_pseudonym , MIN ( t . title ) AS japanese_anime_movie FROM aka_name AS an , cast_info AS ci , company_name AS cn , movie_companies AS mc , name AS n , role_type AS rt , title AS t WHERE ci . note =' ( voice : English version ) ' AND cn . country_code =' [ jp ] ' AND mc . note LIKE '% ( Japan ) %' AND mc . note NOT LIKE '% ( USA ) %' AND ( mc . note LIKE '% ( 2006 ) %' OR mc . note LIKE '% ( 2007 ) %' ) AND n . name LIKE '%Yo%' AND n . name NOT LIKE '%Yu%' AND rt . role ='actress' AND t . production_year BETWEEN 2006 AND 2007 AND ( t . title LIKE 'One Piece%' OR t . title LIKE 'Dragon Ball Z%' ) AND an . person_id = n . id AND n . id = ci . person_id AND ci . movie_id = t . id AND t . id = mc . movie_id AND mc . company_id = cn . id AND ci . role_id = rt . id AND an . person_id = ci . person_id AND ci . movie_id = mc . movie_id;"
    # prompt = "*** sql ***\n{}\n".format(sql_input)
    prompt = [{'content': "*** sql ***\nSELECT MIN ( mi . info ) AS movie_budget , MIN ( mi_idx . info ) AS movie_votes , MIN ( n . name ) AS male_writer , MIN ( t . title ) AS violent_movie_title FROM cast_info AS ci , info_type AS it1 , info_type AS it2 , keyword AS k , movie_info AS mi , movie_info_idx AS mi_idx , movie_keyword AS mk , name AS n , title AS t WHERE ci . note IN ( ' ( writer ) ' , ' ( head writer ) ' , ' ( written by ) ' , ' ( story ) ' , ' ( story editor ) ' ) AND it1 . info = 'genres' AND it2 . info = 'votes' AND k . keyword IN ( 'murder' , 'violence' , 'blood' , 'gore' , 'death' , 'female-nudity' , 'hospital' ) AND mi . info IN ( 'Horror' , 'Action' , 'Sci-Fi' , 'Thriller' , 'Crime' , 'War' ) AND n . gender = 'm' AND t . id = mi . movie_id AND t . id = mi_idx . movie_id AND t . id = ci . movie_id AND t . id = mk . movie_id AND ci . movie_id = mi . movie_id AND ci . movie_id = mi_idx . movie_id AND ci . movie_id = mk . movie_id AND mi . movie_id = mi_idx . movie_id AND mi . movie_id = mk . movie_id AND mi_idx . movie_id = mk . movie_id AND n . id = ci . person_id AND it1 . id = mi . info_type_id AND it2 . id = mi_idx . info_type_id AND k . id = mk . keyword_id;\n*** table information *** :\nit2 : 1 (113)\nk : 7 (134170)\nmk : 301 (4523930)\nmi_idx : 3 (1380035)\nci : 1 (36244344)\nmi : 1 (14835720)\nit1 : 1 (113)\nn : 1 (4167491)\nt : 1 (2528312)\n\n", 'role': 'user'}]


    # Step 1: Extract the query information
    pattern = r'\*\*\*\s*sql\s*\*\*\*\s*([\s\S]*?);'
    match = re.search(pattern, prompt[0]['content'])
    sql = match.group(1).strip()
    print("sql[{}]: ".format(i), sql)

    # Step 2: Fetch the hint and construct the query
    llm_output = """SeqScan(k)
BitmapScan(mk)
IndexScan(t)
SeqScan(kt)
IndexScan(cc)
SeqScan(cct1)
SeqScan(cct2)
IndexScan(ci)
IndexScan(chn)
IndexScan(n)
NestLoop(k mk)
NestLoop(k mk t)
NestLoop(k mk t kt)
NestLoop(k mk t kt cc)
NestLoop(k mk t kt cc cct1)
NestLoop(k mk t kt cc cct1 cct2)
NestLoop(k mk t kt cc cct1 cct2 ci)
NestLoop(k mk t kt cc cct1 cct2 ci chn)
NestLoop(k mk t kt cc cct1 cct2 ci chn n)
Leading((((((((((k mk) t) kt) cc) cct1) cct2) ci) chn) n))"""
    hint = "/*+ {} */".format(llm_output)
    print("hint[{}]: ".format(i), hint)
    query_with_hint = hint + sql

    # Step 3: Execute the query
    _, _, current_execution_time, _ = execute_query(sql)

    # Step 4:
    baseline_exectime = int(11)
    reward = compute_latency_reward(current_execution_time, baseline_exectime)
    print("reward[{}]: ".format(i), reward)

if __name__ == '__main__':
    test()