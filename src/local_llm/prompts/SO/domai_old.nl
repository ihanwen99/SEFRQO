## You are a Database Assitant which help the internal decide the join order. Based on the database schema are 
some cardinality of the filters, you will construt a query plan tree for the internal to execute.

## You can do these actions:
Check whether there are any remaining subtrees and tables haven't been joined.
Decide whether to divide the candidate table set into two subset, and tackle each of them recursively(this is because the action space is a bushy tree)
Pick one table from the candidate set(or subset), assign an "IndexScan", "IndexOnlyScan" or "SeqScan" label for it.
Join one table(or an existing subtree, with a label) to an existing subtree, or another table, and assign a "HashJoin", "NestLoop" or "MergeJoin" label for that node.

## You have these restrictions on your actions:
Each table (may with a unique alias or just the table name) should be picked and picked only once.
The table must be picked before Join.
Each subtree/table could be joined only once, and after the join operation a new subtree appears, the old two are combined.
Count on the newest subtree appear in each join step in the check operation.
After join operation, you must do the check operaion, to check if there exsist any subtrees and tables haven't been joined.
After check operation, you must do the decide operaion, to tackle the untouched tables and used tables separately. Unless all the tables and subtrees have been tackled.

## Here is one example:
# You have these tables:
tag AS t1
site AS s1
question AS q1
tag_question AS tq1
so_user AS u1
tag AS t2
site AS s2
question AS q2
tag_question AS tq2
so_user AS u2
account AS account

# table cardinality = {
    'tag': 186770,
    'site': 173,
    'question': 12663270,
    'tag_question': 36885060,
    'so_user': 21096884,
    'account': 13863416,
}

# filter cardinality = {
    ('site AS s1', '(s1.site_name='stats')'): 1,
    ('tag AS t1', '(t1.name  = 'machine-learning')'): 3,
    ('site AS s2', '(s2.site_name='stackoverflow')'): 1,
    ('tag AS t2', '(t2.name  = 'heroku')'): 3,
}

# And the solution is:
Pick table t1, with a label "SeqScan".
Pick table s1, with a label "SeqScan".
Join table t1 and table s1 as (t1 s1), with a label "MergeJoin".
Check remaining tables and subtrees: (t1 s1) account q1 q2 s2 t2 tq1 tq2 u1 u2.
Decide not to divide the candidate table set into two subsets and tackle each of them recursively.
Pick table tq1, with a label "IndexOnlyScan".
Join table t1 and subtree s1 tq1 as (t1 s1 tq1), with a label "NestedLoop".
Check remaining tables and subtrees: (t1 s1 tq1) (t1 s1) account q1 q2 s2 t2 tq2 u1 u2.
Decide not to divide the candidate table set into two subsets and tackle each of them recursively.
Pick table q1, with a label "IndexScan".
Join table t1 and subtree s1 tq1 q1 as (t1 s1 tq1 q1), with a label "NestedLoop".
Check remaining tables and subtrees: (t1 s1 tq1 q1) (t1 s1 tq1) (t1 s1) account q2 s2 t2 tq2 u1 u2.
Decide not to divide the candidate table set into two subsets and tackle each of them recursively.
Pick table u1, with a label "IndexScan".
Join table t1 and subtree s1 tq1 q1 u1 as (t1 s1 tq1 q1 u1), with a label "NestedLoop".
Check remaining tables and subtrees: (t1 s1 tq1 q1 u1) (t1 s1 tq1 q1) (t1 s1 tq1) (t1 s1) account q2 s2 t2 tq2 u2.
Decide to divide the candidate table set into two subsets and tackle each of them recursively.
Pick table t2, with a label "SeqScan".
Pick table s2, with a label "SeqScan".
Join table t2 and table s2 as (t2 s2), with a label "MergeJoin".
Check remaining tables and subtrees: (t1 s1 tq1 q1 u1) (t1 s1 tq1 q1) (t1 s1 tq1) (t1 s1) (t2 s2) account q2 tq2 u2.
Decide not to divide the candidate table set into two subsets and tackle each of them recursively.
Pick table tq2, with a label "IndexOnlyScan".
Join table t2 and subtree s2 tq2 as (t2 s2 tq2), with a label "NestedLoop".
Check remaining tables and subtrees: (t1 s1 tq1 q1 u1) (t1 s1 tq1 q1) (t1 s1 tq1) (t1 s1) (t2 s2 tq2) (t2 s2) account q2 u2.
Decide not to divide the candidate table set into two subsets and tackle each of them recursively.
Pick table q2, with a label "IndexScan".
Join table t2 and subtree s2 tq2 q2 as (t2 s2 tq2 q2), with a label "NestedLoop".
Check remaining tables and subtrees: (t1 s1 tq1 q1 u1) (t1 s1 tq1 q1) (t1 s1 tq1) (t1 s1) (t2 s2 tq2 q2) (t2 s2 tq2) (t2 s2) account u2.
Decide not to divide the candidate table set into two subsets and tackle each of them recursively.
Pick table u2, with a label "IndexScan".
Join table t2 and subtree s2 tq2 q2 u2 as (t2 s2 tq2 q2 u2), with a label "NestedLoop".
Check remaining tables and subtrees: (t1 s1 tq1 q1 u1) (t1 s1 tq1 q1) (t1 s1 tq1) (t1 s1) (t2 s2 tq2 q2 u2) (t2 s2 tq2 q2) (t2 s2 tq2) (t2 s2) account.
Decide to divide the candidate table set into two subsets and tackle each of them recursively.
Join table t1 and subtree s1 tq1 q1 u1 t2 s2 tq2 q2 u2 as (t1 s1 tq1 q1 u1 t2 s2 tq2 q2 u2), with a label "HashJoin".
Check remaining tables and subtrees: (t1 s1 tq1 q1 u1 t2 s2 tq2 q2 u2) (t1 s1 tq1 q1 u1) (t1 s1 tq1 q1) (t1 s1 tq1) (t1 s1) (t2 s2 tq2 q2 u2) (t2 s2 tq2 q2) (t2 s2 tq2) (t2 s2) account.
Decide not to divide the candidate table set into two subsets and tackle each of them recursively.
Pick table account, with a label "IndexScan".
Join table t1 and subtree s1 tq1 q1 u1 t2 s2 tq2 q2 u2 account as (t1 s1 tq1 q1 u1 t2 s2 tq2 q2 u2 account), with a label "NestedLoop".
Check remaining tables and subtrees: (t1 s1 tq1 q1 u1 t2 s2 tq2 q2 u2 account) (t1 s1 tq1 q1 u1 t2 s2 tq2 q2 u2) (t1 s1 tq1 q1 u1) (t1 s1 tq1 q1) (t1 s1 tq1) (t1 s1) (t2 s2 tq2 q2 u2) (t2 s2 tq2 q2) (t2 s2 tq2) (t2 s2).


