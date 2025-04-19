-- soload_q1-096.sql
-- 1459.013
/*+ NestedLoop(site tag tag_question question)
 NestedLoop(site tag tag_question)
 NestedLoop(site tag)
 SeqScan(site)
 SeqScan(tag)
 IndexOnlyScan(tag_question)
 IndexOnlyScan(question)
 Leading((((site tag) tag_question) question)) */
select count(*) from tag, site, question, tag_question
where
site.site_name='stackoverflow' and
tag.name='jquery' and
tag.site_id = site.site_id and
question.site_id = site.site_id and
tag_question.site_id = site.site_id and
tag_question.question_id = question.id and
tag_question.tag_id = tag.id


-- soload_q1-097.sql
-- 800.563
/*+ NestedLoop(site tag tag_question question)
 NestedLoop(site tag tag_question)
 NestedLoop(site tag)
 SeqScan(site)
 SeqScan(tag)
 IndexOnlyScan(tag_question)
 IndexOnlyScan(question)
 Leading((((site tag) tag_question) question)) */
select count(*) from tag, site, question, tag_question
where
site.site_name='stackoverflow' and
tag.name='android' and
tag.site_id = site.site_id and
question.site_id = site.site_id and
tag_question.site_id = site.site_id and
tag_question.question_id = question.id and
tag_question.tag_id = tag.id


-- soload_q1-098.sql
-- 938.889
/*+ NestedLoop(site tag tag_question question)
 NestedLoop(site tag tag_question)
 NestedLoop(site tag)
 SeqScan(site)
 SeqScan(tag)
 IndexOnlyScan(tag_question)
 IndexOnlyScan(question)
 Leading((((site tag) tag_question) question)) */
select count(*) from tag, site, question, tag_question
where
site.site_name='stackoverflow' and
tag.name='java' and
tag.site_id = site.site_id and
question.site_id = site.site_id and
tag_question.site_id = site.site_id and
tag_question.question_id = question.id and
tag_question.tag_id = tag.id


-- soload_q1-099.sql
-- 709.407
/*+ NestedLoop(site tag tag_question question)
 NestedLoop(site tag tag_question)
 NestedLoop(site tag)
 SeqScan(site)
 SeqScan(tag)
 IndexOnlyScan(tag_question)
 IndexOnlyScan(question)
 Leading((((site tag) tag_question) question)) */
select count(*) from tag, site, question, tag_question
where
site.site_name='stackoverflow' and
tag.name='python' and
tag.site_id = site.site_id and
question.site_id = site.site_id and
tag_question.site_id = site.site_id and
tag_question.question_id = question.id and
tag_question.tag_id = tag.id


-- soload_q1-100.sql
-- 811.927
/*+ NestedLoop(site tag tag_question question)
 NestedLoop(site tag tag_question)
 NestedLoop(site tag)
 SeqScan(site)
 SeqScan(tag)
 IndexOnlyScan(tag_question)
 IndexOnlyScan(question)
 Leading((((site tag) tag_question) question)) */
select count(*) from tag, site, question, tag_question
where
site.site_name='stackoverflow' and
tag.name='c#' and
tag.site_id = site.site_id and
question.site_id = site.site_id and
tag_question.site_id = site.site_id and
tag_question.question_id = question.id and
tag_question.tag_id = tag.id


-- soload_q10-096.sql
-- 190.125
/*+ NestedLoop(pl1 pl2 site q1 q3 q2 comment comment_1 comment_2)
 NestedLoop(pl1 pl2 site q1 q3 q2 comment comment_1)
 NestedLoop(pl1 pl2 site q1 q3 q2 comment)
 NestedLoop(pl1 pl2 site q1 q3 q2)
 NestedLoop(pl1 pl2 site q1 q3)
 NestedLoop(pl1 pl2 site q1)
 HashJoin(pl1 pl2 site)
 HashJoin(pl2 site)
 SeqScan(pl1)
 SeqScan(pl2)
 SeqScan(site)
 IndexScan(q1)
 IndexScan(q3)
 IndexOnlyScan(q2)
 IndexOnlyScan(comment)
 IndexOnlyScan(comment_1)
 IndexOnlyScan(comment_2)
 Leading((((((((pl1 (pl2 site)) q1) q3) q2) comment) comment_1) comment_2)) */
select count(distinct q1.id) from
site, post_link pl1, post_link pl2, question q1, question q2, question q3 where
site.site_name = 'bioinformatics' and
q1.site_id = site.site_id and
q1.site_id = q2.site_id and
q2.site_id = q3.site_id and
pl1.site_id = q1.site_id and
pl1.post_id_from = q1.id and
pl1.post_id_to = q2.id and
pl2.site_id = q1.site_id and
pl2.post_id_from = q2.id and
pl2.post_id_to = q3.id and
exists ( select * from comment where comment.site_id = q3.site_id and comment.post_id = q3.id ) and
exists ( select * from comment where comment.site_id = q2.site_id and comment.post_id = q2.id ) and
exists ( select * from comment where comment.site_id = q1.site_id and comment.post_id = q1.id ) and
q1.score > q3.score;


-- soload_q10-097.sql
-- 102.748
/*+ NestedLoop(pl1 pl2 site q1 q3 q2 comment comment_1 comment_2)
 NestedLoop(pl1 pl2 site q1 q3 q2 comment comment_1)
 NestedLoop(pl1 pl2 site q1 q3 q2 comment)
 NestedLoop(pl1 pl2 site q1 q3 q2)
 NestedLoop(pl1 pl2 site q1 q3)
 NestedLoop(pl1 pl2 site q1)
 HashJoin(pl1 pl2 site)
 HashJoin(pl2 site)
 SeqScan(pl1)
 SeqScan(pl2)
 SeqScan(site)
 IndexScan(q1)
 IndexScan(q3)
 IndexOnlyScan(q2)
 IndexOnlyScan(comment)
 IndexOnlyScan(comment_1)
 IndexOnlyScan(comment_2)
 Leading((((((((pl1 (pl2 site)) q1) q3) q2) comment) comment_1) comment_2)) */
select count(distinct q1.id) from
site, post_link pl1, post_link pl2, question q1, question q2, question q3 where
site.site_name = 'graphicdesign' and
q1.site_id = site.site_id and
q1.site_id = q2.site_id and
q2.site_id = q3.site_id and
pl1.site_id = q1.site_id and
pl1.post_id_from = q1.id and
pl1.post_id_to = q2.id and
pl2.site_id = q1.site_id and
pl2.post_id_from = q2.id and
pl2.post_id_to = q3.id and
exists ( select * from comment where comment.site_id = q3.site_id and comment.post_id = q3.id ) and
exists ( select * from comment where comment.site_id = q2.site_id and comment.post_id = q2.id ) and
exists ( select * from comment where comment.site_id = q1.site_id and comment.post_id = q1.id ) and
q1.score > q3.score;


-- soload_q10-098.sql
-- 106.005
/*+ NestedLoop(pl1 pl2 site q1 q3 q2 comment comment_1 comment_2)
 NestedLoop(pl1 pl2 site q1 q3 q2 comment comment_1)
 NestedLoop(pl1 pl2 site q1 q3 q2 comment)
 NestedLoop(pl1 pl2 site q1 q3 q2)
 NestedLoop(pl1 pl2 site q1 q3)
 NestedLoop(pl1 pl2 site q1)
 HashJoin(pl1 pl2 site)
 HashJoin(pl2 site)
 SeqScan(pl1)
 SeqScan(pl2)
 SeqScan(site)
 IndexScan(q1)
 IndexScan(q3)
 IndexOnlyScan(q2)
 IndexOnlyScan(comment)
 IndexOnlyScan(comment_1)
 IndexOnlyScan(comment_2)
 Leading((((((((pl1 (pl2 site)) q1) q3) q2) comment) comment_1) comment_2)) */
select count(distinct q1.id) from
site, post_link pl1, post_link pl2, question q1, question q2, question q3 where
site.site_name = 'es' and
q1.site_id = site.site_id and
q1.site_id = q2.site_id and
q2.site_id = q3.site_id and
pl1.site_id = q1.site_id and
pl1.post_id_from = q1.id and
pl1.post_id_to = q2.id and
pl2.site_id = q1.site_id and
pl2.post_id_from = q2.id and
pl2.post_id_to = q3.id and
exists ( select * from comment where comment.site_id = q3.site_id and comment.post_id = q3.id ) and
exists ( select * from comment where comment.site_id = q2.site_id and comment.post_id = q2.id ) and
exists ( select * from comment where comment.site_id = q1.site_id and comment.post_id = q1.id ) and
q1.score > q3.score;


-- soload_q10-099.sql
-- 87.409
/*+ NestedLoop(pl1 pl2 site q1 q3 q2 comment comment_1 comment_2)
 NestedLoop(pl1 pl2 site q1 q3 q2 comment comment_1)
 NestedLoop(pl1 pl2 site q1 q3 q2 comment)
 NestedLoop(pl1 pl2 site q1 q3 q2)
 NestedLoop(pl1 pl2 site q1 q3)
 NestedLoop(pl1 pl2 site q1)
 HashJoin(pl1 pl2 site)
 HashJoin(pl2 site)
 SeqScan(pl1)
 SeqScan(pl2)
 SeqScan(site)
 IndexScan(q1)
 IndexScan(q3)
 IndexOnlyScan(q2)
 IndexOnlyScan(comment)
 IndexOnlyScan(comment_1)
 IndexOnlyScan(comment_2)
 Leading((((((((pl1 (pl2 site)) q1) q3) q2) comment) comment_1) comment_2)) */
select count(distinct q1.id) from
site, post_link pl1, post_link pl2, question q1, question q2, question q3 where
site.site_name = 'pets' and
q1.site_id = site.site_id and
q1.site_id = q2.site_id and
q2.site_id = q3.site_id and
pl1.site_id = q1.site_id and
pl1.post_id_from = q1.id and
pl1.post_id_to = q2.id and
pl2.site_id = q1.site_id and
pl2.post_id_from = q2.id and
pl2.post_id_to = q3.id and
exists ( select * from comment where comment.site_id = q3.site_id and comment.post_id = q3.id ) and
exists ( select * from comment where comment.site_id = q2.site_id and comment.post_id = q2.id ) and
exists ( select * from comment where comment.site_id = q1.site_id and comment.post_id = q1.id ) and
q1.score > q3.score;


-- soload_q10-100.sql
-- 99.925
/*+ NestedLoop(pl1 pl2 site q1 q3 q2 comment comment_1 comment_2)
 NestedLoop(pl1 pl2 site q1 q3 q2 comment comment_1)
 NestedLoop(pl1 pl2 site q1 q3 q2 comment)
 NestedLoop(pl1 pl2 site q1 q3 q2)
 NestedLoop(pl1 pl2 site q1 q3)
 NestedLoop(pl1 pl2 site q1)
 HashJoin(pl1 pl2 site)
 HashJoin(pl2 site)
 SeqScan(pl1)
 SeqScan(pl2)
 SeqScan(site)
 IndexScan(q1)
 IndexScan(q3)
 IndexOnlyScan(q2)
 IndexOnlyScan(comment)
 IndexOnlyScan(comment_1)
 IndexOnlyScan(comment_2)
 Leading((((((((pl1 (pl2 site)) q1) q3) q2) comment) comment_1) comment_2)) */
select count(distinct q1.id) from
site, post_link pl1, post_link pl2, question q1, question q2, question q3 where
site.site_name = 'ux' and
q1.site_id = site.site_id and
q1.site_id = q2.site_id and
q2.site_id = q3.site_id and
pl1.site_id = q1.site_id and
pl1.post_id_from = q1.id and
pl1.post_id_to = q2.id and
pl2.site_id = q1.site_id and
pl2.post_id_from = q2.id and
pl2.post_id_to = q3.id and
exists ( select * from comment where comment.site_id = q3.site_id and comment.post_id = q3.id ) and
exists ( select * from comment where comment.site_id = q2.site_id and comment.post_id = q2.id ) and
exists ( select * from comment where comment.site_id = q1.site_id and comment.post_id = q1.id ) and
q1.score > q3.score;


-- soload_q11-096.sql
-- 711.338
/*+ NestedLoop(t s tq q)
 NestedLoop(t s tq)
 MergeJoin(t s)
 SeqScan(t)
 SeqScan(s)
 IndexOnlyScan(tq)
 IndexScan(q)
 Leading((((t s) tq) q)) */
SELECT COUNT(*)
FROM
tag as t,
site as s,
question as q,
tag_question as tq
WHERE
t.site_id = s.site_id
AND q.site_id = s.site_id
AND tq.site_id = s.site_id
AND tq.question_id = q.id
AND tq.tag_id = t.id
AND (s.site_name in ('stackoverflow'))
AND (t.name in ('android-scrollview','associative-array','dropwizard','drupal-8','footer','fwrite','grid-layout','interpreter','path-finding','x86-16'))
AND (q.view_count >= 100)
AND (q.view_count <= 100000)


-- soload_q11-097.sql
-- 15154.157
/*+ NestedLoop(s t tq q)
 NestedLoop(s t tq)
 NestedLoop(s t)
 SeqScan(s)
 SeqScan(t)
 IndexOnlyScan(tq)
 IndexScan(q)
 Leading((((s t) tq) q)) */
SELECT COUNT(*)
FROM
tag as t,
site as s,
question as q,
tag_question as tq
WHERE
t.site_id = s.site_id
AND q.site_id = s.site_id
AND tq.site_id = s.site_id
AND tq.question_id = q.id
AND tq.tag_id = t.id
AND (s.site_name in ('stackoverflow'))
AND (t.name in ('android','single-page-application'))
AND (q.view_count >= 100)
AND (q.view_count <= 100000)


-- soload_q11-098.sql
-- 1481.262
/*+ NestedLoop(t s tq q)
 NestedLoop(t s tq)
 MergeJoin(t s)
 SeqScan(t)
 SeqScan(s)
 IndexOnlyScan(tq)
 IndexScan(q)
 Leading((((t s) tq) q)) */
SELECT COUNT(*)
FROM
tag as t,
site as s,
question as q,
tag_question as tq
WHERE
t.site_id = s.site_id
AND q.site_id = s.site_id
AND tq.site_id = s.site_id
AND tq.question_id = q.id
AND tq.tag_id = t.id
AND (s.site_name in ('stackoverflow'))
AND (t.name in ('emacs','npm','terminal','utf-8','visual-studio-code'))
AND (q.score >= 10)
AND (q.score <= 1000)


-- soload_q11-099.sql
-- 3478.11
/*+ NestedLoop(t s tq q)
 NestedLoop(t s tq)
 MergeJoin(t s)
 SeqScan(t)
 SeqScan(s)
 IndexOnlyScan(tq)
 IndexScan(q)
 Leading((((t s) tq) q)) */
SELECT COUNT(*)
FROM
tag as t,
site as s,
question as q,
tag_question as tq
WHERE
t.site_id = s.site_id
AND q.site_id = s.site_id
AND tq.site_id = s.site_id
AND tq.question_id = q.id
AND tq.tag_id = t.id
AND (s.site_name in ('stackoverflow'))
AND (t.name in ('apache','azure','csv','floating-point','fortran','gcc','if-statement','joomla','lambda','pdf','pdo'))
AND (q.view_count >= 0)
AND (q.view_count <= 100)


-- soload_q11-100.sql
-- 205.786
/*+ NestedLoop(t s tq q)
 NestedLoop(t s tq)
 MergeJoin(t s)
 SeqScan(t)
 SeqScan(s)
 IndexOnlyScan(tq)
 IndexScan(q)
 Leading((((t s) tq) q)) */
SELECT COUNT(*)
FROM
tag as t,
site as s,
question as q,
tag_question as tq
WHERE
t.site_id = s.site_id
AND q.site_id = s.site_id
AND tq.site_id = s.site_id
AND tq.question_id = q.id
AND tq.tag_id = t.id
AND (s.site_name in ('stackoverflow'))
AND (t.name in ('dask','docusignapi','dto','filenotfoundexception','flowtype','fwrite','hierarchical-data','igraph','infragistics','ioc-container','itertools','photo','placeholder','spatial','unmarshalling'))
AND (q.view_count >= 100)
AND (q.view_count <= 100000)


-- soload_q12-096.sql
-- 374.722
/*+ NestedLoop(t1 s tq1 a1 u1 q1)
 NestedLoop(t1 s tq1 a1 u1)
 NestedLoop(t1 s tq1 a1)
 NestedLoop(t1 s tq1)
 MergeJoin(t1 s)
 SeqScan(t1)
 SeqScan(s)
 IndexOnlyScan(tq1)
 IndexScan(a1)
 IndexScan(u1)
 IndexScan(q1)
 Leading((((((t1 s) tq1) a1) u1) q1)) */
SELECT t1.name, count(*)
FROM
site as s,
so_user as u1,
question as q1,
answer as a1,
tag as t1,
tag_question as tq1
WHERE
q1.owner_user_id = u1.id
AND a1.question_id = q1.id
AND a1.owner_user_id = u1.id
AND s.site_id = q1.site_id
AND s.site_id = a1.site_id
AND s.site_id = u1.site_id
AND s.site_id = tq1.site_id
AND s.site_id = t1.site_id
AND q1.id = tq1.question_id
AND t1.id = tq1.tag_id
AND (s.site_name in ('ell','gamedev'))
AND (t1.name in ('3d','android','architecture','articles','difference','grammaticality','idioms','libgdx','mathematics','past-tense','phrase-request','phrase-usage','sentence-meaning','verbs'))
AND (q1.score >= 1)
AND (q1.score <= 10)
AND (u1.reputation >= 10)
AND (u1.reputation <= 100000)
GROUP BY t1.name


-- soload_q12-097.sql
-- 1085.564
/*+ NestedLoop(t1 s tq1 a1 u1 q1)
 NestedLoop(t1 s tq1 a1 u1)
 NestedLoop(t1 s tq1 a1)
 NestedLoop(t1 s tq1)
 MergeJoin(t1 s)
 SeqScan(t1)
 SeqScan(s)
 IndexOnlyScan(tq1)
 IndexScan(a1)
 IndexScan(u1)
 IndexScan(q1)
 Leading((((((t1 s) tq1) a1) u1) q1)) */
SELECT t1.name, count(*)
FROM
site as s,
so_user as u1,
question as q1,
answer as a1,
tag as t1,
tag_question as tq1
WHERE
q1.owner_user_id = u1.id
AND a1.question_id = q1.id
AND a1.owner_user_id = u1.id
AND s.site_id = q1.site_id
AND s.site_id = a1.site_id
AND s.site_id = u1.site_id
AND s.site_id = tq1.site_id
AND s.site_id = t1.site_id
AND q1.id = tq1.question_id
AND t1.id = tq1.tag_id
AND (s.site_name in ('askubuntu','math'))
AND (t1.name in ('12.04','equivalence-relations','examples-counterexamples','homological-algebra','limits-without-lhopital','manifolds','matrix-equations','package-management'))
AND (q1.view_count >= 0)
AND (q1.view_count <= 100)
AND (u1.upvotes >= 10)
AND (u1.upvotes <= 100000)
GROUP BY t1.name


-- soload_q12-098.sql
-- 1543.645
/*+ NestedLoop(t1 s tq1 a1 u1 q1)
 NestedLoop(t1 s tq1 a1 u1)
 NestedLoop(t1 s tq1 a1)
 NestedLoop(t1 s tq1)
 MergeJoin(t1 s)
 SeqScan(t1)
 SeqScan(s)
 IndexOnlyScan(tq1)
 IndexScan(a1)
 IndexScan(u1)
 IndexScan(q1)
 Leading((((((t1 s) tq1) a1) u1) q1)) */
SELECT t1.name, count(*)
FROM
site as s,
so_user as u1,
question as q1,
answer as a1,
tag as t1,
tag_question as tq1
WHERE
q1.owner_user_id = u1.id
AND a1.question_id = q1.id
AND a1.owner_user_id = u1.id
AND s.site_id = q1.site_id
AND s.site_id = a1.site_id
AND s.site_id = u1.site_id
AND s.site_id = tq1.site_id
AND s.site_id = t1.site_id
AND q1.id = tq1.question_id
AND t1.id = tq1.tag_id
AND (s.site_name in ('math'))
AND (t1.name in ('algorithms','continuity','euclidean-geometry','improper-integrals','induction','integration','modular-arithmetic','ordinary-differential-equations','sequences-and-series','special-functions'))
AND (q1.favorite_count >= 0)
AND (q1.favorite_count <= 10000)
AND (u1.upvotes >= 0)
AND (u1.upvotes <= 1)
GROUP BY t1.name


-- soload_q12-099.sql
-- 1215.887
/*+ NestedLoop(t1 s tq1 a1 q1 u1)
 NestedLoop(t1 s tq1 a1 q1)
 NestedLoop(t1 s tq1 a1)
 NestedLoop(t1 s tq1)
 MergeJoin(t1 s)
 SeqScan(t1)
 SeqScan(s)
 IndexOnlyScan(tq1)
 IndexScan(a1)
 IndexScan(q1)
 IndexScan(u1)
 Leading((((((t1 s) tq1) a1) q1) u1)) */
SELECT t1.name, count(*)
FROM
site as s,
so_user as u1,
question as q1,
answer as a1,
tag as t1,
tag_question as tq1
WHERE
q1.owner_user_id = u1.id
AND a1.question_id = q1.id
AND a1.owner_user_id = u1.id
AND s.site_id = q1.site_id
AND s.site_id = a1.site_id
AND s.site_id = u1.site_id
AND s.site_id = tq1.site_id
AND s.site_id = t1.site_id
AND q1.id = tq1.question_id
AND t1.id = tq1.tag_id
AND (s.site_name in ('apple','askubuntu','dba','electronics','physics'))
AND (t1.name in ('arduino','capacitor','command-line','energy','login','macbook','operators','oracle','resource-recommendations','sql-server-2012'))
AND (q1.view_count >= 10)
AND (q1.view_count <= 1000)
AND (u1.downvotes >= 0)
AND (u1.downvotes <= 10)
GROUP BY t1.name


-- soload_q12-100.sql
-- 164.801
/*+ NestedLoop(t1 s tq1 a1 u1 q1)
 NestedLoop(t1 s tq1 a1 u1)
 NestedLoop(t1 s tq1 a1)
 NestedLoop(t1 s tq1)
 MergeJoin(t1 s)
 SeqScan(t1)
 SeqScan(s)
 IndexOnlyScan(tq1)
 IndexScan(a1)
 IndexScan(u1)
 IndexScan(q1)
 Leading((((((t1 s) tq1) a1) u1) q1)) */
SELECT t1.name, count(*)
FROM
site as s,
so_user as u1,
question as q1,
answer as a1,
tag as t1,
tag_question as tq1
WHERE
q1.owner_user_id = u1.id
AND a1.question_id = q1.id
AND a1.owner_user_id = u1.id
AND s.site_id = q1.site_id
AND s.site_id = a1.site_id
AND s.site_id = u1.site_id
AND s.site_id = tq1.site_id
AND s.site_id = t1.site_id
AND q1.id = tq1.question_id
AND t1.id = tq1.tag_id
AND (s.site_name in ('gaming'))
AND (t1.name in ('achievements','diablo-3','pokemon-go','starcraft-2','xbox-360'))
AND (q1.score >= 1)
AND (q1.score <= 10)
AND (u1.downvotes >= 0)
AND (u1.downvotes <= 10)
GROUP BY t1.name


-- soload_q13-096.sql
-- 208.363
/*+ NestedLoop(t1 s tq1 a1 u1 q1 b acc)
 NestedLoop(t1 s tq1 a1 u1 q1 b)
 NestedLoop(t1 s tq1 a1 u1 q1)
 NestedLoop(t1 s tq1 a1 u1)
 NestedLoop(t1 s tq1 a1)
 NestedLoop(t1 s tq1)
 MergeJoin(t1 s)
 SeqScan(t1)
 SeqScan(s)
 IndexOnlyScan(tq1)
 IndexScan(a1)
 IndexScan(u1)
 IndexScan(q1)
 IndexOnlyScan(b)
 IndexScan(acc)
 Leading((((((((t1 s) tq1) a1) u1) q1) b) acc)) */
SELECT acc.location, count(*)
FROM
site as s,
so_user as u1,
question as q1,
answer as a1,
tag as t1,
tag_question as tq1,
badge as b,
account as acc
WHERE
s.site_id = q1.site_id
AND s.site_id = u1.site_id
AND s.site_id = a1.site_id
AND s.site_id = t1.site_id
AND s.site_id = tq1.site_id
AND s.site_id = b.site_id
AND q1.id = tq1.question_id
AND q1.id = a1.question_id
AND a1.owner_user_id = u1.id
AND t1.id = tq1.tag_id
AND b.user_id = u1.id
AND acc.id = u1.account_id
AND (s.site_name in ('askubuntu'))
AND (t1.name in ('application-development','cron','mouse','power-management','printing','security','software-recommendation'))
AND (q1.view_count >= 10)
AND (q1.view_count <= 1000)
AND (u1.reputation >= 0)
AND (u1.reputation <= 10)
AND (b.name in ('Commentator','Famous Question','Notable Question','Scholar','Teacher'))
GROUP BY acc.location
ORDER BY COUNT(*)
DESC
LIMIT 100


-- soload_q13-097.sql
-- 3129.437
/*+ NestedLoop(t1 s tq1 a1 u1 q1 b acc)
 NestedLoop(t1 s tq1 a1 u1 q1 b)
 NestedLoop(t1 s tq1 a1 u1 q1)
 NestedLoop(t1 s tq1 a1 u1)
 NestedLoop(t1 s tq1 a1)
 NestedLoop(t1 s tq1)
 MergeJoin(t1 s)
 SeqScan(t1)
 SeqScan(s)
 IndexOnlyScan(tq1)
 IndexScan(a1)
 IndexScan(u1)
 IndexScan(q1)
 IndexOnlyScan(b)
 IndexScan(acc)
 Leading((((((((t1 s) tq1) a1) u1) q1) b) acc)) */
SELECT acc.location, count(*)
FROM
site as s,
so_user as u1,
question as q1,
answer as a1,
tag as t1,
tag_question as tq1,
badge as b,
account as acc
WHERE
s.site_id = q1.site_id
AND s.site_id = u1.site_id
AND s.site_id = a1.site_id
AND s.site_id = t1.site_id
AND s.site_id = tq1.site_id
AND s.site_id = b.site_id
AND q1.id = tq1.question_id
AND q1.id = a1.question_id
AND a1.owner_user_id = u1.id
AND t1.id = tq1.tag_id
AND b.user_id = u1.id
AND acc.id = u1.account_id
AND (s.site_name in ('stackoverflow'))
AND (t1.name in ('apache','datagrid','editor','facebook-javascript-sdk','google-oauth','initialization','processing','r-markdown','react-navigation','teradata','uiview','winrt-xaml'))
AND (q1.view_count >= 10)
AND (q1.view_count <= 1000)
AND (u1.downvotes >= 0)
AND (u1.downvotes <= 1)
AND (b.name in ('Analytical','Benefactor','Organizer','Tenacious'))
GROUP BY acc.location
ORDER BY COUNT(*)
DESC
LIMIT 100


-- soload_q13-098.sql
-- 1048.19
/*+ NestedLoop(t1 s tq1 a1 u1 q1 b acc)
 NestedLoop(t1 s tq1 a1 u1 q1 b)
 NestedLoop(t1 s tq1 a1 u1 q1)
 NestedLoop(t1 s tq1 a1 u1)
 NestedLoop(t1 s tq1 a1)
 NestedLoop(t1 s tq1)
 MergeJoin(t1 s)
 SeqScan(t1)
 SeqScan(s)
 IndexOnlyScan(tq1)
 IndexScan(a1)
 IndexScan(u1)
 IndexScan(q1)
 IndexOnlyScan(b)
 IndexScan(acc)
 Leading((((((((t1 s) tq1) a1) u1) q1) b) acc)) */
SELECT acc.location, count(*)
FROM
site as s,
so_user as u1,
question as q1,
answer as a1,
tag as t1,
tag_question as tq1,
badge as b,
account as acc
WHERE
s.site_id = q1.site_id
AND s.site_id = u1.site_id
AND s.site_id = a1.site_id
AND s.site_id = t1.site_id
AND s.site_id = tq1.site_id
AND s.site_id = b.site_id
AND q1.id = tq1.question_id
AND q1.id = a1.question_id
AND a1.owner_user_id = u1.id
AND t1.id = tq1.tag_id
AND b.user_id = u1.id
AND acc.id = u1.account_id
AND (s.site_name in ('stackoverflow'))
AND (t1.name in ('jersey','uiview','visual-studio-2010','visual-studio-2012','windows-8'))
AND (q1.favorite_count >= 1)
AND (q1.favorite_count <= 10)
AND (u1.reputation >= 0)
AND (u1.reputation <= 10)
AND (b.name in ('Announcer','Necromancer'))
GROUP BY acc.location
ORDER BY COUNT(*)
DESC
LIMIT 100


-- soload_q13-099.sql
-- 440.427
/*+ NestedLoop(t1 s tq1 a1 u1 q1 b acc)
 NestedLoop(t1 s tq1 a1 u1 q1 b)
 NestedLoop(t1 s tq1 a1 u1 q1)
 NestedLoop(t1 s tq1 a1 u1)
 NestedLoop(t1 s tq1 a1)
 NestedLoop(t1 s tq1)
 MergeJoin(t1 s)
 SeqScan(t1)
 SeqScan(s)
 IndexOnlyScan(tq1)
 IndexScan(a1)
 IndexScan(u1)
 IndexScan(q1)
 IndexOnlyScan(b)
 IndexScan(acc)
 Leading((((((((t1 s) tq1) a1) u1) q1) b) acc)) */
SELECT acc.location, count(*)
FROM
site as s,
so_user as u1,
question as q1,
answer as a1,
tag as t1,
tag_question as tq1,
badge as b,
account as acc
WHERE
s.site_id = q1.site_id
AND s.site_id = u1.site_id
AND s.site_id = a1.site_id
AND s.site_id = t1.site_id
AND s.site_id = tq1.site_id
AND s.site_id = b.site_id
AND q1.id = tq1.question_id
AND q1.id = a1.question_id
AND a1.owner_user_id = u1.id
AND t1.id = tq1.tag_id
AND b.user_id = u1.id
AND acc.id = u1.account_id
AND (s.site_name in ('stackoverflow','tex'))
AND (t1.name in ('core-plot','draggable','elm','getelementbyid','httpd.conf','joomla3.0','multilingual','openpyxl','parent','service-worker','stringr','travis-ci','urlencode'))
AND (q1.view_count >= 10)
AND (q1.view_count <= 1000)
AND (u1.downvotes >= 0)
AND (u1.downvotes <= 1)
AND (b.name in ('Autobiographer','Curious','Informed','Nice Answer','Nice Question','Yearling'))
GROUP BY acc.location
ORDER BY COUNT(*)
DESC
LIMIT 100


-- soload_q13-100.sql
-- 566.676
/*+ NestedLoop(t1 s tq1 a1 u1 q1 b acc)
 NestedLoop(t1 s tq1 a1 u1 q1 b)
 NestedLoop(t1 s tq1 a1 u1 q1)
 NestedLoop(t1 s tq1 a1 u1)
 NestedLoop(t1 s tq1 a1)
 NestedLoop(t1 s tq1)
 MergeJoin(t1 s)
 SeqScan(t1)
 SeqScan(s)
 IndexOnlyScan(tq1)
 IndexScan(a1)
 IndexScan(u1)
 IndexScan(q1)
 IndexOnlyScan(b)
 IndexScan(acc)
 Leading((((((((t1 s) tq1) a1) u1) q1) b) acc)) */
SELECT acc.location, count(*)
FROM
site as s,
so_user as u1,
question as q1,
answer as a1,
tag as t1,
tag_question as tq1,
badge as b,
account as acc
WHERE
s.site_id = q1.site_id
AND s.site_id = u1.site_id
AND s.site_id = a1.site_id
AND s.site_id = t1.site_id
AND s.site_id = tq1.site_id
AND s.site_id = b.site_id
AND q1.id = tq1.question_id
AND q1.id = a1.question_id
AND a1.owner_user_id = u1.id
AND t1.id = tq1.tag_id
AND b.user_id = u1.id
AND acc.id = u1.account_id
AND (s.site_name in ('english','es','gis','mathoverflow','physics'))
AND (t1.name in ('adjectives','american-english','complex-geometry','ds.dynamical-systems','mp.mathematical-physics','operators','polynomials','rotational-dynamics'))
AND (q1.favorite_count >= 1)
AND (q1.favorite_count <= 10)
AND (u1.upvotes >= 0)
AND (u1.upvotes <= 100)
AND (b.name in ('Critic','Nice Question','Notable Question','Scholar','Yearling'))
GROUP BY acc.location
ORDER BY COUNT(*)
DESC
LIMIT 100


-- soload_q14-096.sql
-- 208.554
/*+ NestedLoop(t1 s tq1 a1 u1 q1 b acc)
 NestedLoop(t1 s tq1 a1 u1 q1 b)
 NestedLoop(t1 s tq1 a1 u1 q1)
 NestedLoop(t1 s tq1 a1 u1)
 NestedLoop(t1 s tq1 a1)
 NestedLoop(t1 s tq1)
 MergeJoin(t1 s)
 SeqScan(t1)
 SeqScan(s)
 IndexOnlyScan(tq1)
 IndexScan(a1)
 IndexScan(u1)
 IndexScan(q1)
 IndexOnlyScan(b)
 IndexOnlyScan(acc)
 Leading((((((((t1 s) tq1) a1) u1) q1) b) acc)) */
SELECT COUNT(*)
FROM
site as s,
so_user as u1,
question as q1,
answer as a1,
tag as t1,
tag_question as tq1,
badge as b,
account as acc
WHERE
s.site_id = q1.site_id
AND s.site_id = u1.site_id
AND s.site_id = a1.site_id
AND s.site_id = t1.site_id
AND s.site_id = tq1.site_id
AND s.site_id = b.site_id
AND q1.id = tq1.question_id
AND q1.id = a1.question_id
AND a1.owner_user_id = u1.id
AND t1.id = tq1.tag_id
AND b.user_id = u1.id
AND acc.id = u1.account_id
AND (s.site_name in ('mathoverflow'))
AND (t1.name in ('analytic-number-theory','ap.analysis-of-pdes','ca.classical-analysis-and-odes','cv.complex-variables','dg.differential-geometry','fa.functional-analysis','gn.general-topology','gt.geometric-topology','linear-algebra','nt.number-theory','reference-request'))
AND (q1.view_count >= 100)
AND (q1.view_count <= 100000)
AND (u1.reputation >= 0)
AND (u1.reputation <= 10)
AND (b.name ILIKE '%stude%')


-- soload_q14-097.sql
-- 4407.356
/*+ NestedLoop(t1 s tq1 a1 u1 q1 b acc)
 NestedLoop(t1 s tq1 a1 u1 q1 b)
 NestedLoop(t1 s tq1 a1 u1 q1)
 NestedLoop(t1 s tq1 a1 u1)
 NestedLoop(t1 s tq1 a1)
 NestedLoop(t1 s tq1)
 MergeJoin(t1 s)
 SeqScan(t1)
 SeqScan(s)
 IndexOnlyScan(tq1)
 IndexScan(a1)
 IndexScan(u1)
 IndexScan(q1)
 IndexOnlyScan(b)
 IndexOnlyScan(acc)
 Leading((((((((t1 s) tq1) a1) u1) q1) b) acc)) */
SELECT COUNT(*)
FROM
site as s,
so_user as u1,
question as q1,
answer as a1,
tag as t1,
tag_question as tq1,
badge as b,
account as acc
WHERE
s.site_id = q1.site_id
AND s.site_id = u1.site_id
AND s.site_id = a1.site_id
AND s.site_id = t1.site_id
AND s.site_id = tq1.site_id
AND s.site_id = b.site_id
AND q1.id = tq1.question_id
AND q1.id = a1.question_id
AND a1.owner_user_id = u1.id
AND t1.id = tq1.tag_id
AND b.user_id = u1.id
AND acc.id = u1.account_id
AND (s.site_name in ('stackoverflow'))
AND (t1.name in ('android-recyclerview','angular-ui-router','api','casting','express','hadoop','numbers','position','push-notification','triggers'))
AND (q1.view_count >= 0)
AND (q1.view_count <= 100)
AND (u1.downvotes >= 10)
AND (u1.downvotes <= 100000)
AND (b.name ILIKE '%refi%')


-- soload_q14-098.sql
-- 418.659
/*+ NestedLoop(t1 s tq1 a1 u1 q1 b acc)
 NestedLoop(t1 s tq1 a1 u1 q1 b)
 NestedLoop(t1 s tq1 a1 u1 q1)
 NestedLoop(t1 s tq1 a1 u1)
 NestedLoop(t1 s tq1 a1)
 NestedLoop(t1 s tq1)
 MergeJoin(t1 s)
 SeqScan(t1)
 SeqScan(s)
 IndexOnlyScan(tq1)
 IndexScan(a1)
 IndexScan(u1)
 IndexScan(q1)
 IndexOnlyScan(b)
 IndexOnlyScan(acc)
 Leading((((((((t1 s) tq1) a1) u1) q1) b) acc)) */
SELECT COUNT(*)
FROM
site as s,
so_user as u1,
question as q1,
answer as a1,
tag as t1,
tag_question as tq1,
badge as b,
account as acc
WHERE
s.site_id = q1.site_id
AND s.site_id = u1.site_id
AND s.site_id = a1.site_id
AND s.site_id = t1.site_id
AND s.site_id = tq1.site_id
AND s.site_id = b.site_id
AND q1.id = tq1.question_id
AND q1.id = a1.question_id
AND a1.owner_user_id = u1.id
AND t1.id = tq1.tag_id
AND b.user_id = u1.id
AND acc.id = u1.account_id
AND (s.site_name in ('apple','superuser'))
AND (t1.name in ('backup','microsoft-outlook','partitioning'))
AND (q1.view_count >= 10)
AND (q1.view_count <= 1000)
AND (u1.reputation >= 10)
AND (u1.reputation <= 100000)
AND (b.name ILIKE '%edi%')


-- soload_q14-099.sql
-- 212.989
/*+ NestedLoop(t1 s tq1 a1 u1 q1 b acc)
 NestedLoop(t1 s tq1 a1 u1 q1 b)
 NestedLoop(t1 s tq1 a1 u1 q1)
 NestedLoop(t1 s tq1 a1 u1)
 NestedLoop(t1 s tq1 a1)
 NestedLoop(t1 s tq1)
 MergeJoin(t1 s)
 SeqScan(t1)
 SeqScan(s)
 IndexOnlyScan(tq1)
 IndexScan(a1)
 IndexScan(u1)
 IndexScan(q1)
 IndexOnlyScan(b)
 IndexOnlyScan(acc)
 Leading((((((((t1 s) tq1) a1) u1) q1) b) acc)) */
SELECT COUNT(*)
FROM
site as s,
so_user as u1,
question as q1,
answer as a1,
tag as t1,
tag_question as tq1,
badge as b,
account as acc
WHERE
s.site_id = q1.site_id
AND s.site_id = u1.site_id
AND s.site_id = a1.site_id
AND s.site_id = t1.site_id
AND s.site_id = tq1.site_id
AND s.site_id = b.site_id
AND q1.id = tq1.question_id
AND q1.id = a1.question_id
AND a1.owner_user_id = u1.id
AND t1.id = tq1.tag_id
AND b.user_id = u1.id
AND acc.id = u1.account_id
AND (s.site_name in ('blender','gaming','money','webmasters'))
AND (t1.name in ('blender-render','domains','loans','mortgage','xbox-360'))
AND (q1.view_count >= 100)
AND (q1.view_count <= 100000)
AND (u1.upvotes >= 0)
AND (u1.upvotes <= 100)
AND (b.name in ('Autobiographer','Citizen Patrol','Commentator','Editor','Famous Question','Informed','Nice Answer','Notable Question','Popular Question','Scholar','Teacher','Tumbleweed'))


-- soload_q14-100.sql
-- 527.917
/*+ NestedLoop(t1 s tq1 a1 u1 q1 b acc)
 NestedLoop(t1 s tq1 a1 u1 q1 b)
 NestedLoop(t1 s tq1 a1 u1 q1)
 NestedLoop(t1 s tq1 a1 u1)
 NestedLoop(t1 s tq1 a1)
 NestedLoop(t1 s tq1)
 MergeJoin(t1 s)
 SeqScan(t1)
 SeqScan(s)
 IndexOnlyScan(tq1)
 IndexScan(a1)
 IndexScan(u1)
 IndexScan(q1)
 IndexOnlyScan(b)
 IndexOnlyScan(acc)
 Leading((((((((t1 s) tq1) a1) u1) q1) b) acc)) */
SELECT COUNT(*)
FROM
site as s,
so_user as u1,
question as q1,
answer as a1,
tag as t1,
tag_question as tq1,
badge as b,
account as acc
WHERE
s.site_id = q1.site_id
AND s.site_id = u1.site_id
AND s.site_id = a1.site_id
AND s.site_id = t1.site_id
AND s.site_id = tq1.site_id
AND s.site_id = b.site_id
AND q1.id = tq1.question_id
AND q1.id = a1.question_id
AND a1.owner_user_id = u1.id
AND t1.id = tq1.tag_id
AND b.user_id = u1.id
AND acc.id = u1.account_id
AND (s.site_name in ('superuser'))
AND (t1.name in ('display','firefox','networking','wireless-networking'))
AND (q1.view_count >= 10)
AND (q1.view_count <= 1000)
AND (u1.downvotes >= 0)
AND (u1.downvotes <= 10)
AND (b.name ILIKE '%civ%')


-- soload_q15-096.sql
-- 1918.646
/*+ NestedLoop(t1 s tq1 q1 b1 u1 acc)
 NestedLoop(t1 s tq1 q1 b1 u1)
 NestedLoop(t1 s tq1 q1 b1)
 NestedLoop(t1 s tq1 q1)
 NestedLoop(t1 s tq1)
 MergeJoin(t1 s)
 SeqScan(t1)
 SeqScan(s)
 IndexOnlyScan(tq1)
 IndexScan(q1)
 IndexOnlyScan(b1)
 IndexScan(u1)
 IndexScan(acc)
 Leading(((((((t1 s) tq1) q1) b1) u1) acc)) */
SELECT b1.name, count(*)
FROM
site as s,
so_user as u1,
tag as t1,
tag_question as tq1,
question as q1,
badge as b1,
account as acc
WHERE
s.site_id = u1.site_id
AND s.site_id = b1.site_id
AND s.site_id = t1.site_id
AND s.site_id = tq1.site_id
AND s.site_id = q1.site_id
AND t1.id = tq1.tag_id
AND q1.id = tq1.question_id
AND q1.owner_user_id = u1.id
AND acc.id = u1.account_id
AND b1.user_id = u1.id
AND (q1.favorite_count >= 5)
AND (q1.favorite_count <= 5000)
AND (s.site_name in ('askubuntu','math'))
AND (t1.name in ('algebraic-geometry','complex-analysis','integration','limits'))
AND (acc.website_url ILIKE ('%code%'))
GROUP BY b1.name
ORDER BY COUNT(*)
DESC
LIMIT 100


-- soload_q15-097.sql
-- 486.755
/*+ NestedLoop(t1 s tq1 q1 u1 b1 acc)
 NestedLoop(t1 s tq1 q1 u1 b1)
 NestedLoop(t1 s tq1 q1 u1)
 NestedLoop(t1 s tq1 q1)
 NestedLoop(t1 s tq1)
 MergeJoin(t1 s)
 SeqScan(t1)
 SeqScan(s)
 IndexOnlyScan(tq1)
 IndexScan(q1)
 IndexScan(u1)
 IndexOnlyScan(b1)
 IndexScan(acc)
 Leading(((((((t1 s) tq1) q1) u1) b1) acc)) */
SELECT b1.name, count(*)
FROM
site as s,
so_user as u1,
tag as t1,
tag_question as tq1,
question as q1,
badge as b1,
account as acc
WHERE
s.site_id = u1.site_id
AND s.site_id = b1.site_id
AND s.site_id = t1.site_id
AND s.site_id = tq1.site_id
AND s.site_id = q1.site_id
AND t1.id = tq1.tag_id
AND q1.id = tq1.question_id
AND q1.owner_user_id = u1.id
AND acc.id = u1.account_id
AND b1.user_id = u1.id
AND (q1.score >= 1)
AND (q1.score <= 10)
AND (s.site_name in ('math'))
AND (t1.name in ('change-of-variable','duality-theorems','elliptic-functions','estimation-theory','functional-inequalities','hypothesis-testing','localization','perfect-powers','rational-functions','sums-of-squares','svd','symplectic-geometry','tetration','wave-equation','zeta-functions'))
AND (acc.website_url ILIKE ('%en'))
GROUP BY b1.name
ORDER BY COUNT(*)
DESC
LIMIT 100


-- soload_q15-098.sql
-- 503.037
/*+ NestedLoop(t1 s tq1 q1 u1 b1 acc)
 NestedLoop(t1 s tq1 q1 u1 b1)
 NestedLoop(t1 s tq1 q1 u1)
 NestedLoop(t1 s tq1 q1)
 NestedLoop(t1 s tq1)
 MergeJoin(t1 s)
 SeqScan(t1)
 SeqScan(s)
 IndexOnlyScan(tq1)
 IndexScan(q1)
 IndexScan(u1)
 IndexOnlyScan(b1)
 IndexScan(acc)
 Leading(((((((t1 s) tq1) q1) u1) b1) acc)) */
SELECT b1.name, count(*)
FROM
site as s,
so_user as u1,
tag as t1,
tag_question as tq1,
question as q1,
badge as b1,
account as acc
WHERE
s.site_id = u1.site_id
AND s.site_id = b1.site_id
AND s.site_id = t1.site_id
AND s.site_id = tq1.site_id
AND s.site_id = q1.site_id
AND t1.id = tq1.tag_id
AND q1.id = tq1.question_id
AND q1.owner_user_id = u1.id
AND acc.id = u1.account_id
AND b1.user_id = u1.id
AND (q1.view_count >= 100)
AND (q1.view_count <= 100000)
AND (s.site_name in ('apple','ru','stats','unix'))
AND (t1.name in ('div','g++','init','kalman-filter','kohana','latent-variable','netbeans','parallels-desktop','scheduling','system-prefs','utilities','нейронные-сети','оптимизация'))
AND (acc.website_url ILIKE ('%com'))
GROUP BY b1.name
ORDER BY COUNT(*)
DESC
LIMIT 100


-- soload_q15-099.sql
-- 617.808
/*+ NestedLoop(t1 s tq1 q1 u1 b1 acc)
 NestedLoop(t1 s tq1 q1 u1 b1)
 NestedLoop(t1 s tq1 q1 u1)
 NestedLoop(t1 s tq1 q1)
 NestedLoop(t1 s tq1)
 MergeJoin(t1 s)
 SeqScan(t1)
 SeqScan(s)
 IndexOnlyScan(tq1)
 IndexScan(q1)
 IndexScan(u1)
 IndexOnlyScan(b1)
 IndexScan(acc)
 Leading(((((((t1 s) tq1) q1) u1) b1) acc)) */
SELECT b1.name, count(*)
FROM
site as s,
so_user as u1,
tag as t1,
tag_question as tq1,
question as q1,
badge as b1,
account as acc
WHERE
s.site_id = u1.site_id
AND s.site_id = b1.site_id
AND s.site_id = t1.site_id
AND s.site_id = tq1.site_id
AND s.site_id = q1.site_id
AND t1.id = tq1.tag_id
AND q1.id = tq1.question_id
AND q1.owner_user_id = u1.id
AND acc.id = u1.account_id
AND b1.user_id = u1.id
AND (q1.score >= 0)
AND (q1.score <= 0)
AND (s.site_name in ('askubuntu','math'))
AND (t1.name in ('cubic-equations','cyclic-groups','downloads','email','freeze','function-and-relation-composition','holomorphic-functions','intel-graphics','lattice-orders','make','reboot','services','spectral-theory','text-processing','vlc'))
AND (acc.website_url ILIKE ('%in'))
GROUP BY b1.name
ORDER BY COUNT(*)
DESC
LIMIT 100


-- soload_q15-100.sql
-- 101.547
/*+ NestedLoop(t1 s tq1 q1 u1 b1 acc)
 NestedLoop(t1 s tq1 q1 u1 b1)
 NestedLoop(t1 s tq1 q1 u1)
 NestedLoop(t1 s tq1 q1)
 NestedLoop(t1 s tq1)
 MergeJoin(t1 s)
 SeqScan(t1)
 SeqScan(s)
 IndexOnlyScan(tq1)
 IndexScan(q1)
 IndexScan(u1)
 IndexOnlyScan(b1)
 IndexScan(acc)
 Leading(((((((t1 s) tq1) q1) u1) b1) acc)) */
SELECT b1.name, count(*)
FROM
site as s,
so_user as u1,
tag as t1,
tag_question as tq1,
question as q1,
badge as b1,
account as acc
WHERE
s.site_id = u1.site_id
AND s.site_id = b1.site_id
AND s.site_id = t1.site_id
AND s.site_id = tq1.site_id
AND s.site_id = q1.site_id
AND t1.id = tq1.tag_id
AND q1.id = tq1.question_id
AND q1.owner_user_id = u1.id
AND acc.id = u1.account_id
AND b1.user_id = u1.id
AND (q1.view_count >= 0)
AND (q1.view_count <= 100)
AND (s.site_name in ('gamedev','scifi','softwareengineering','webapps'))
AND (t1.name in ('2d','libgdx','twitter'))
AND (acc.website_url ILIKE ('%com'))
GROUP BY b1.name
ORDER BY COUNT(*)
DESC
LIMIT 100


-- soload_q16-096.sql
-- 3805.925
/*+ NestedLoop(t1 s tq1 q1 u1 b1 acc)
 NestedLoop(t1 s tq1 q1 u1 b1)
 NestedLoop(t1 s tq1 q1 u1)
 NestedLoop(t1 s tq1 q1)
 NestedLoop(t1 s tq1)
 MergeJoin(t1 s)
 SeqScan(t1)
 SeqScan(s)
 IndexOnlyScan(tq1)
 IndexScan(q1)
 IndexScan(u1)
 IndexOnlyScan(b1)
 IndexScan(acc)
 Leading(((((((t1 s) tq1) q1) u1) b1) acc)) */
SELECT COUNT(*)
FROM
site as s,
so_user as u1,
tag as t1,
tag_question as tq1,
question as q1,
badge as b1,
account as acc
WHERE
s.site_id = u1.site_id
AND s.site_id = b1.site_id
AND s.site_id = t1.site_id
AND s.site_id = tq1.site_id
AND s.site_id = q1.site_id
AND t1.id = tq1.tag_id
AND q1.id = tq1.question_id
AND q1.owner_user_id = u1.id
AND acc.id = u1.account_id
AND b1.user_id = u1.id
AND (q1.view_count >= 0)
AND (q1.view_count <= 100)
AND s.site_name = 'stackoverflow'
AND (t1.name in ('android-layout','code-coverage','full-text-search','linked-list','raspberry-pi','type-conversion'))
AND (acc.website_url ILIKE ('%en'))


-- soload_q16-097.sql
-- 1199.914
/*+ NestedLoop(t1 s tq1 q1 u1 b1 acc)
 NestedLoop(t1 s tq1 q1 u1 b1)
 NestedLoop(t1 s tq1 q1 u1)
 NestedLoop(t1 s tq1 q1)
 NestedLoop(t1 s tq1)
 MergeJoin(t1 s)
 SeqScan(t1)
 SeqScan(s)
 IndexOnlyScan(tq1)
 IndexScan(q1)
 IndexScan(u1)
 IndexOnlyScan(b1)
 IndexScan(acc)
 Leading(((((((t1 s) tq1) q1) u1) b1) acc)) */
SELECT COUNT(*)
FROM
site as s,
so_user as u1,
tag as t1,
tag_question as tq1,
question as q1,
badge as b1,
account as acc
WHERE
s.site_id = u1.site_id
AND s.site_id = b1.site_id
AND s.site_id = t1.site_id
AND s.site_id = tq1.site_id
AND s.site_id = q1.site_id
AND t1.id = tq1.tag_id
AND q1.id = tq1.question_id
AND q1.owner_user_id = u1.id
AND acc.id = u1.account_id
AND b1.user_id = u1.id
AND (q1.view_count >= 100)
AND (q1.view_count <= 100000)
AND s.site_name = 'stackoverflow'
AND (t1.name in ('latex','sum'))
AND (acc.website_url ILIKE ('%'))


-- soload_q16-098.sql
-- 1919.454
/*+ NestedLoop(t1 s tq1 q1 u1 b1 acc)
 NestedLoop(t1 s tq1 q1 u1 b1)
 NestedLoop(t1 s tq1 q1 u1)
 NestedLoop(t1 s tq1 q1)
 NestedLoop(t1 s tq1)
 MergeJoin(t1 s)
 SeqScan(t1)
 SeqScan(s)
 IndexOnlyScan(tq1)
 IndexScan(q1)
 IndexScan(u1)
 IndexOnlyScan(b1)
 IndexScan(acc)
 Leading(((((((t1 s) tq1) q1) u1) b1) acc)) */
SELECT COUNT(*)
FROM
site as s,
so_user as u1,
tag as t1,
tag_question as tq1,
question as q1,
badge as b1,
account as acc
WHERE
s.site_id = u1.site_id
AND s.site_id = b1.site_id
AND s.site_id = t1.site_id
AND s.site_id = tq1.site_id
AND s.site_id = q1.site_id
AND t1.id = tq1.tag_id
AND q1.id = tq1.question_id
AND q1.owner_user_id = u1.id
AND acc.id = u1.account_id
AND b1.user_id = u1.id
AND (q1.score >= 0)
AND (q1.score <= 0)
AND s.site_name = 'stackoverflow'
AND (t1.name in ('buffer','number-formatting','razor'))
AND (acc.website_url ILIKE ('%'))


-- soload_q16-099.sql
-- 210.791
/*+ NestedLoop(t1 s tq1 q1 b1 u1 acc)
 NestedLoop(t1 s tq1 q1 b1 u1)
 NestedLoop(t1 s tq1 q1 b1)
 NestedLoop(t1 s tq1 q1)
 NestedLoop(t1 s tq1)
 MergeJoin(t1 s)
 SeqScan(t1)
 SeqScan(s)
 IndexOnlyScan(tq1)
 IndexScan(q1)
 IndexOnlyScan(b1)
 IndexScan(u1)
 IndexScan(acc)
 Leading(((((((t1 s) tq1) q1) b1) u1) acc)) */
SELECT COUNT(*)
FROM
site as s,
so_user as u1,
tag as t1,
tag_question as tq1,
question as q1,
badge as b1,
account as acc
WHERE
s.site_id = u1.site_id
AND s.site_id = b1.site_id
AND s.site_id = t1.site_id
AND s.site_id = tq1.site_id
AND s.site_id = q1.site_id
AND t1.id = tq1.tag_id
AND q1.id = tq1.question_id
AND q1.owner_user_id = u1.id
AND acc.id = u1.account_id
AND b1.user_id = u1.id
AND (q1.favorite_count >= 0)
AND (q1.favorite_count <= 10000)
AND s.site_name = 'stackoverflow'
AND (t1.name in ('calling-convention','linechart','ng-grid','package.json'))
AND (acc.website_url ILIKE ('%de'))


-- soload_q16-100.sql
-- 3110.107
/*+ NestedLoop(t1 s tq1 q1 u1 b1 acc)
 NestedLoop(t1 s tq1 q1 u1 b1)
 NestedLoop(t1 s tq1 q1 u1)
 NestedLoop(t1 s tq1 q1)
 NestedLoop(t1 s tq1)
 MergeJoin(t1 s)
 SeqScan(t1)
 SeqScan(s)
 IndexOnlyScan(tq1)
 IndexScan(q1)
 IndexScan(u1)
 IndexOnlyScan(b1)
 IndexScan(acc)
 Leading(((((((t1 s) tq1) q1) u1) b1) acc)) */
SELECT COUNT(*)
FROM
site as s,
so_user as u1,
tag as t1,
tag_question as tq1,
question as q1,
badge as b1,
account as acc
WHERE
s.site_id = u1.site_id
AND s.site_id = b1.site_id
AND s.site_id = t1.site_id
AND s.site_id = tq1.site_id
AND s.site_id = q1.site_id
AND t1.id = tq1.tag_id
AND q1.id = tq1.question_id
AND q1.owner_user_id = u1.id
AND acc.id = u1.account_id
AND b1.user_id = u1.id
AND (q1.score >= 0)
AND (q1.score <= 0)
AND s.site_name = 'stackoverflow'
AND (t1.name in ('action','bootstrapping','chat','dom','driver','mamp','race-condition','web','windows-phone-7.1','wso2-am','x86'))
AND (acc.website_url ILIKE ('%in'))


-- soload_q2-096.sql
-- 1604.032
/*+ NestedLoop(t1 s1 tq1 q1 u1 t2 s2 tq2 q2 u2 account)
 HashJoin(t1 s1 tq1 q1 u1 t2 s2 tq2 q2 u2)
 NestedLoop(t2 s2 tq2 q2 u2)
 NestedLoop(t2 s2 tq2 q2)
 NestedLoop(t2 s2 tq2)
 MergeJoin(t2 s2)
 NestedLoop(t1 s1 tq1 q1 u1)
 NestedLoop(t1 s1 tq1 q1)
 NestedLoop(t1 s1 tq1)
 MergeJoin(t1 s1)
 SeqScan(t1)
 SeqScan(s1)
 IndexOnlyScan(tq1)
 IndexScan(q1)
 IndexScan(u1)
 SeqScan(t2)
 SeqScan(s2)
 IndexOnlyScan(tq2)
 IndexScan(q2)
 IndexScan(u2)
 IndexScan(account)
 Leading(((((((t1 s1) tq1) q1) u1) ((((t2 s2) tq2) q2) u2)) account)) */
select distinct account.display_name
from
tag t1, site s1, question q1, tag_question tq1, so_user u1,
tag t2, site s2, question q2, tag_question tq2, so_user u2,
account
where
s1.site_name='stackoverflow' and
t1.name  = 'forms' and
t1.site_id = s1.site_id and
q1.site_id = s1.site_id and
tq1.site_id = s1.site_id and
tq1.question_id = q1.id and
tq1.tag_id = t1.id and
q1.owner_user_id = u1.id and
q1.site_id = u1.site_id and
s2.site_name='apple' and
t2.name  = 'ios' and
t2.site_id = s2.site_id and
q2.site_id = s2.site_id and
tq2.site_id = s2.site_id and
tq2.question_id = q2.id and
tq2.tag_id = t2.id and
q2.owner_user_id = u2.id and
q2.site_id = u2.site_id and
u1.account_id = u2.account_id and
account.id = u1.account_id;


-- soload_q2-097.sql
-- 463.951
/*+ NestedLoop(t1 s1 tq1 q1 u1 t2 s2 tq2 q2 u2 account)
 HashJoin(t1 s1 tq1 q1 u1 t2 s2 tq2 q2 u2)
 NestedLoop(t2 s2 tq2 q2 u2)
 NestedLoop(t2 s2 tq2 q2)
 NestedLoop(t2 s2 tq2)
 MergeJoin(t2 s2)
 NestedLoop(t1 s1 tq1 q1 u1)
 NestedLoop(t1 s1 tq1 q1)
 NestedLoop(t1 s1 tq1)
 HashJoin(t1 s1)
 SeqScan(t1)
 SeqScan(s1)
 IndexOnlyScan(tq1)
 IndexScan(q1)
 IndexScan(u1)
 SeqScan(t2)
 SeqScan(s2)
 IndexOnlyScan(tq2)
 IndexScan(q2)
 IndexScan(u2)
 IndexScan(account)
 Leading(((((((t1 s1) tq1) q1) u1) ((((t2 s2) tq2) q2) u2)) account)) */
select distinct account.display_name
from
tag t1, site s1, question q1, tag_question tq1, so_user u1,
tag t2, site s2, question q2, tag_question tq2, so_user u2,
account
where
s1.site_name='mathoverflow' and
t1.name LIKE 'gr%' and
t1.site_id = s1.site_id and
q1.site_id = s1.site_id and
tq1.site_id = s1.site_id and
tq1.question_id = q1.id and
tq1.tag_id = t1.id and
q1.owner_user_id = u1.id and
q1.site_id = u1.site_id and
s2.site_name='stackoverflow' and
t2.name = 'rust' and
t2.site_id = s2.site_id and
q2.site_id = s2.site_id and
tq2.site_id = s2.site_id and
tq2.question_id = q2.id and
tq2.tag_id = t2.id and
q2.owner_user_id = u2.id and
q2.site_id = u2.site_id and
u1.account_id = u2.account_id and
account.id = u1.account_id;


-- soload_q2-098.sql
-- 7993.334
/*+ NestedLoop(t1 s1 tq1 q1 u1 t2 s2 tq2 q2 u2 account)
 HashJoin(t1 s1 tq1 q1 u1 t2 s2 tq2 q2 u2)
 NestedLoop(t2 s2 tq2 q2 u2)
 NestedLoop(t2 s2 tq2 q2)
 NestedLoop(t2 s2 tq2)
 MergeJoin(t2 s2)
 NestedLoop(t1 s1 tq1 q1 u1)
 NestedLoop(t1 s1 tq1 q1)
 NestedLoop(t1 s1 tq1)
 HashJoin(t1 s1)
 SeqScan(t1)
 SeqScan(s1)
 IndexOnlyScan(tq1)
 IndexScan(q1)
 IndexScan(u1)
 SeqScan(t2)
 SeqScan(s2)
 IndexOnlyScan(tq2)
 IndexScan(q2)
 IndexScan(u2)
 IndexScan(account)
 Leading(((((((t1 s1) tq1) q1) u1) ((((t2 s2) tq2) q2) u2)) account)) */
select distinct account.display_name
from
tag t1, site s1, question q1, tag_question tq1, so_user u1,
tag t2, site s2, question q2, tag_question tq2, so_user u2,
account
where
s1.site_name='mathoverflow' and
t1.name LIKE 'gr%' and
t1.site_id = s1.site_id and
q1.site_id = s1.site_id and
tq1.site_id = s1.site_id and
tq1.question_id = q1.id and
tq1.tag_id = t1.id and
q1.owner_user_id = u1.id and
q1.site_id = u1.site_id and
s2.site_name='stackoverflow' and
t2.name = 'java' and
t2.site_id = s2.site_id and
q2.site_id = s2.site_id and
tq2.site_id = s2.site_id and
tq2.question_id = q2.id and
tq2.tag_id = t2.id and
q2.owner_user_id = u2.id and
q2.site_id = u2.site_id and
u1.account_id = u2.account_id and
account.id = u1.account_id;


-- soload_q2-099.sql
-- 374.145
/*+ NestedLoop(t1 s1 tq1 q1 u1 t2 s2 tq2 q2 u2 account)
 HashJoin(t1 s1 tq1 q1 u1 t2 s2 tq2 q2 u2)
 NestedLoop(t2 s2 tq2 q2 u2)
 NestedLoop(t2 s2 tq2 q2)
 NestedLoop(t2 s2 tq2)
 MergeJoin(t2 s2)
 NestedLoop(t1 s1 tq1 q1 u1)
 NestedLoop(t1 s1 tq1 q1)
 NestedLoop(t1 s1 tq1)
 HashJoin(t1 s1)
 SeqScan(t1)
 SeqScan(s1)
 IndexOnlyScan(tq1)
 IndexScan(q1)
 IndexScan(u1)
 SeqScan(t2)
 SeqScan(s2)
 IndexOnlyScan(tq2)
 IndexScan(q2)
 IndexScan(u2)
 IndexScan(account)
 Leading(((((((t1 s1) tq1) q1) u1) ((((t2 s2) tq2) q2) u2)) account)) */
select distinct account.display_name
from
tag t1, site s1, question q1, tag_question tq1, so_user u1,
tag t2, site s2, question q2, tag_question tq2, so_user u2,
account
where
s1.site_name='mathoverflow' and
t1.name LIKE 'gr%' and
t1.site_id = s1.site_id and
q1.site_id = s1.site_id and
tq1.site_id = s1.site_id and
tq1.question_id = q1.id and
tq1.tag_id = t1.id and
q1.owner_user_id = u1.id and
q1.site_id = u1.site_id and
s2.site_name='serverfault' and
t2.name = 'nginx' and
t2.site_id = s2.site_id and
q2.site_id = s2.site_id and
tq2.site_id = s2.site_id and
tq2.question_id = q2.id and
tq2.tag_id = t2.id and
q2.owner_user_id = u2.id and
q2.site_id = u2.site_id and
u1.account_id = u2.account_id and
account.id = u1.account_id;


-- soload_q2-100.sql
-- 128.86
/*+ NestedLoop(t1 s1 tq1 q1 u1 t2 s2 tq2 q2 u2 account)
 HashJoin(t1 s1 tq1 q1 u1 t2 s2 tq2 q2 u2)
 NestedLoop(t2 s2 tq2 q2 u2)
 NestedLoop(t2 s2 tq2 q2)
 NestedLoop(t2 s2 tq2)
 MergeJoin(t2 s2)
 NestedLoop(t1 s1 tq1 q1 u1)
 NestedLoop(t1 s1 tq1 q1)
 NestedLoop(t1 s1 tq1)
 HashJoin(t1 s1)
 SeqScan(t1)
 SeqScan(s1)
 IndexOnlyScan(tq1)
 IndexScan(q1)
 IndexScan(u1)
 SeqScan(t2)
 SeqScan(s2)
 IndexOnlyScan(tq2)
 IndexScan(q2)
 IndexScan(u2)
 IndexScan(account)
 Leading(((((((t1 s1) tq1) q1) u1) ((((t2 s2) tq2) q2) u2)) account)) */
select distinct account.display_name
from
tag t1, site s1, question q1, tag_question tq1, so_user u1,
tag t2, site s2, question q2, tag_question tq2, so_user u2,
account
where
s1.site_name='mathoverflow' and
t1.name LIKE 'gr%' and
t1.site_id = s1.site_id and
q1.site_id = s1.site_id and
tq1.site_id = s1.site_id and
tq1.question_id = q1.id and
tq1.tag_id = t1.id and
q1.owner_user_id = u1.id and
q1.site_id = u1.site_id and
s2.site_name='rpg' and
t2.name LIKE '%dnd%' and
t2.site_id = s2.site_id and
q2.site_id = s2.site_id and
tq2.site_id = s2.site_id and
tq2.question_id = q2.id and
tq2.tag_id = t2.id and
q2.owner_user_id = u2.id and
q2.site_id = u2.site_id and
u1.account_id = u2.account_id and
account.id = u1.account_id;


-- soload_q3-096.sql
-- 1003.913
/*+ NestedLoop(t2 s2 tq2 q2 u2 t1 s1 tq1 q1 a1 u1 account)
 HashJoin(t2 s2 tq2 q2 u2 t1 s1 tq1 q1 a1 u1)
 NestedLoop(t1 s1 tq1 q1 a1 u1)
 NestedLoop(t1 s1 tq1 q1 a1)
 NestedLoop(t1 s1 tq1 q1)
 NestedLoop(t1 s1 tq1)
 MergeJoin(t1 s1)
 NestedLoop(t2 s2 tq2 q2 u2)
 NestedLoop(t2 s2 tq2 q2)
 NestedLoop(t2 s2 tq2)
 MergeJoin(t2 s2)
 SeqScan(t2)
 SeqScan(s2)
 IndexOnlyScan(tq2)
 IndexScan(q2)
 IndexScan(u2)
 SeqScan(t1)
 SeqScan(s1)
 IndexOnlyScan(tq1)
 IndexOnlyScan(q1)
 IndexScan(a1)
 IndexScan(u1)
 IndexScan(account)
 Leading(((((((t2 s2) tq2) q2) u2) (((((t1 s1) tq1) q1) a1) u1)) account)) */
select COUNT(distinct account.display_name)
from
tag t1, site s1, question q1, answer a1, tag_question tq1, so_user u1,
tag t2, site s2, question q2, tag_question tq2, so_user u2,
account
where
s1.site_name='stackoverflow' and
t1.name  = 'optimization' and
t1.site_id = s1.site_id and
q1.site_id = s1.site_id and
tq1.site_id = s1.site_id and
tq1.question_id = q1.id and
tq1.tag_id = t1.id and
a1.site_id = q1.site_id and
a1.question_id = q1.id and
a1.owner_user_id = u1.id and
a1.site_id = u1.site_id and
s2.site_name='pt' and
t2.name  = 'php' and
t2.site_id = s2.site_id and
q2.site_id = s2.site_id and
tq2.site_id = s2.site_id and
tq2.question_id = q2.id and
tq2.tag_id = t2.id and
q2.owner_user_id = u2.id and
q2.site_id = u2.site_id and
u1.account_id = u2.account_id and
account.id = u1.account_id;


-- soload_q3-097.sql
-- 133.545
/*+ NestedLoop(t2 s2 tq2 q2 u2 t1 s1 tq1 q1 a1 u1 account)
 HashJoin(t2 s2 tq2 q2 u2 t1 s1 tq1 q1 a1 u1)
 NestedLoop(t1 s1 tq1 q1 a1 u1)
 NestedLoop(t1 s1 tq1 q1 a1)
 NestedLoop(t1 s1 tq1 q1)
 NestedLoop(t1 s1 tq1)
 HashJoin(t1 s1)
 NestedLoop(t2 s2 tq2 q2 u2)
 NestedLoop(t2 s2 tq2 q2)
 NestedLoop(t2 s2 tq2)
 MergeJoin(t2 s2)
 SeqScan(t2)
 SeqScan(s2)
 IndexOnlyScan(tq2)
 IndexScan(q2)
 IndexScan(u2)
 SeqScan(t1)
 SeqScan(s1)
 IndexOnlyScan(tq1)
 IndexOnlyScan(q1)
 IndexScan(a1)
 IndexScan(u1)
 IndexScan(account)
 Leading(((((((t2 s2) tq2) q2) u2) (((((t1 s1) tq1) q1) a1) u1)) account)) */
select COUNT(distinct account.display_name)
from
tag t1, site s1, question q1, answer a1, tag_question tq1, so_user u1,
tag t2, site s2, question q2, tag_question tq2, so_user u2,
account
where
s1.site_name='mathoverflow' and
t1.name LIKE 'gr%' and
t1.site_id = s1.site_id and
q1.site_id = s1.site_id and
tq1.site_id = s1.site_id and
tq1.question_id = q1.id and
tq1.tag_id = t1.id and
a1.site_id = q1.site_id and
a1.question_id = q1.id and
a1.owner_user_id = u1.id and
a1.site_id = u1.site_id and
s2.site_name='stackoverflow' and
t2.name = 'rust' and
t2.site_id = s2.site_id and
q2.site_id = s2.site_id and
tq2.site_id = s2.site_id and
tq2.question_id = q2.id and
tq2.tag_id = t2.id and
q2.owner_user_id = u2.id and
q2.site_id = u2.site_id and
u1.account_id = u2.account_id and
account.id = u1.account_id;


-- soload_q3-098.sql
-- 3743.173
/*+ NestedLoop(t2 s2 tq2 q2 u2 t1 s1 tq1 q1 a1 u1 account)
 HashJoin(t2 s2 tq2 q2 u2 t1 s1 tq1 q1 a1 u1)
 NestedLoop(t1 s1 tq1 q1 a1 u1)
 NestedLoop(t1 s1 tq1 q1 a1)
 NestedLoop(t1 s1 tq1 q1)
 NestedLoop(t1 s1 tq1)
 HashJoin(t1 s1)
 NestedLoop(t2 s2 tq2 q2 u2)
 NestedLoop(t2 s2 tq2 q2)
 NestedLoop(t2 s2 tq2)
 MergeJoin(t2 s2)
 SeqScan(t2)
 SeqScan(s2)
 IndexOnlyScan(tq2)
 IndexScan(q2)
 IndexScan(u2)
 SeqScan(t1)
 SeqScan(s1)
 IndexOnlyScan(tq1)
 IndexOnlyScan(q1)
 IndexScan(a1)
 IndexScan(u1)
 IndexScan(account)
 Leading(((((((t2 s2) tq2) q2) u2) (((((t1 s1) tq1) q1) a1) u1)) account)) */
select COUNT(distinct account.display_name)
from
tag t1, site s1, question q1, answer a1, tag_question tq1, so_user u1,
tag t2, site s2, question q2, tag_question tq2, so_user u2,
account
where
s1.site_name='mathoverflow' and
t1.name LIKE 'gr%' and
t1.site_id = s1.site_id and
q1.site_id = s1.site_id and
tq1.site_id = s1.site_id and
tq1.question_id = q1.id and
tq1.tag_id = t1.id and
a1.site_id = q1.site_id and
a1.question_id = q1.id and
a1.owner_user_id = u1.id and
a1.site_id = u1.site_id and
s2.site_name='stackoverflow' and
t2.name = 'java' and
t2.site_id = s2.site_id and
q2.site_id = s2.site_id and
tq2.site_id = s2.site_id and
tq2.question_id = q2.id and
tq2.tag_id = t2.id and
q2.owner_user_id = u2.id and
q2.site_id = u2.site_id and
u1.account_id = u2.account_id and
account.id = u1.account_id;


-- soload_q3-099.sql
-- 80.472
/*+ NestedLoop(t2 s2 tq2 q2 u2 t1 s1 tq1 q1 a1 u1 account)
 HashJoin(t2 s2 tq2 q2 u2 t1 s1 tq1 q1 a1 u1)
 NestedLoop(t1 s1 tq1 q1 a1 u1)
 NestedLoop(t1 s1 tq1 q1 a1)
 NestedLoop(t1 s1 tq1 q1)
 NestedLoop(t1 s1 tq1)
 HashJoin(t1 s1)
 NestedLoop(t2 s2 tq2 q2 u2)
 NestedLoop(t2 s2 tq2 q2)
 NestedLoop(t2 s2 tq2)
 MergeJoin(t2 s2)
 SeqScan(t2)
 SeqScan(s2)
 IndexOnlyScan(tq2)
 IndexScan(q2)
 IndexScan(u2)
 SeqScan(t1)
 SeqScan(s1)
 IndexOnlyScan(tq1)
 IndexOnlyScan(q1)
 IndexScan(a1)
 IndexScan(u1)
 IndexScan(account)
 Leading(((((((t2 s2) tq2) q2) u2) (((((t1 s1) tq1) q1) a1) u1)) account)) */
select COUNT(distinct account.display_name)
from
tag t1, site s1, question q1, answer a1, tag_question tq1, so_user u1,
tag t2, site s2, question q2, tag_question tq2, so_user u2,
account
where
s1.site_name='mathoverflow' and
t1.name LIKE 'gr%' and
t1.site_id = s1.site_id and
q1.site_id = s1.site_id and
tq1.site_id = s1.site_id and
tq1.question_id = q1.id and
tq1.tag_id = t1.id and
a1.site_id = q1.site_id and
a1.question_id = q1.id and
a1.owner_user_id = u1.id and
a1.site_id = u1.site_id and
s2.site_name='serverfault' and
t2.name = 'nginx' and
t2.site_id = s2.site_id and
q2.site_id = s2.site_id and
tq2.site_id = s2.site_id and
tq2.question_id = q2.id and
tq2.tag_id = t2.id and
q2.owner_user_id = u2.id and
q2.site_id = u2.site_id and
u1.account_id = u2.account_id and
account.id = u1.account_id;


-- soload_q3-100.sql
-- 70.246
/*+ NestedLoop(t2 s2 tq2 q2 u2 t1 s1 tq1 q1 a1 u1 account)
 HashJoin(t2 s2 tq2 q2 u2 t1 s1 tq1 q1 a1 u1)
 NestedLoop(t1 s1 tq1 q1 a1 u1)
 NestedLoop(t1 s1 tq1 q1 a1)
 NestedLoop(t1 s1 tq1 q1)
 NestedLoop(t1 s1 tq1)
 HashJoin(t1 s1)
 NestedLoop(t2 s2 tq2 q2 u2)
 NestedLoop(t2 s2 tq2 q2)
 NestedLoop(t2 s2 tq2)
 MergeJoin(t2 s2)
 SeqScan(t2)
 SeqScan(s2)
 IndexOnlyScan(tq2)
 IndexScan(q2)
 IndexScan(u2)
 SeqScan(t1)
 SeqScan(s1)
 IndexOnlyScan(tq1)
 IndexOnlyScan(q1)
 IndexScan(a1)
 IndexScan(u1)
 IndexScan(account)
 Leading(((((((t2 s2) tq2) q2) u2) (((((t1 s1) tq1) q1) a1) u1)) account)) */
select COUNT(distinct account.display_name)
from
tag t1, site s1, question q1, answer a1, tag_question tq1, so_user u1,
tag t2, site s2, question q2, tag_question tq2, so_user u2,
account
where
s1.site_name='mathoverflow' and
t1.name LIKE 'gr%' and
t1.site_id = s1.site_id and
q1.site_id = s1.site_id and
tq1.site_id = s1.site_id and
tq1.question_id = q1.id and
tq1.tag_id = t1.id and
a1.site_id = q1.site_id and
a1.question_id = q1.id and
a1.owner_user_id = u1.id and
a1.site_id = u1.site_id and
s2.site_name='rpg' and
t2.name LIKE '%dnd%' and
t2.site_id = s2.site_id and
q2.site_id = s2.site_id and
tq2.site_id = s2.site_id and
tq2.question_id = q2.id and
tq2.tag_id = t2.id and
q2.owner_user_id = u2.id and
q2.site_id = u2.site_id and
u1.account_id = u2.account_id and
account.id = u1.account_id;


-- soload_q4-096.sql
-- 237.165
/*+ NestedLoop(t1 s1 tq1 a1 u1 account q1)
 NestedLoop(t1 s1 tq1 a1 u1 account)
 NestedLoop(t1 s1 tq1 a1 u1)
 NestedLoop(t1 s1 tq1 a1)
 NestedLoop(t1 s1 tq1)
 MergeJoin(t1 s1)
 SeqScan(t1)
 SeqScan(s1)
 IndexOnlyScan(tq1)
 IndexScan(a1)
 IndexScan(u1)
 IndexScan(account)
 IndexScan(q1)
 Leading(((((((t1 s1) tq1) a1) u1) account) q1)) */
select COUNT(distinct account.display_name)
from
tag t1, site s1, question q1, answer a1, tag_question tq1, so_user u1,
account
where
s1.site_name='stackoverflow' and
t1.name = 'notifications' and
t1.site_id = s1.site_id and
q1.site_id = s1.site_id and
tq1.site_id = s1.site_id and
tq1.question_id = q1.id and
tq1.tag_id = t1.id and
a1.site_id = q1.site_id and
a1.question_id = q1.id and
a1.owner_user_id = u1.id and
a1.site_id = u1.site_id and
a1.creation_date >= q1.creation_date + '1 year'::interval and
account.id = u1.account_id;


-- soload_q4-097.sql
-- 1748.012
/*+ NestedLoop(t1 s1 tq1 a1 u1 account q1)
 NestedLoop(t1 s1 tq1 a1 u1 account)
 NestedLoop(t1 s1 tq1 a1 u1)
 NestedLoop(t1 s1 tq1 a1)
 NestedLoop(t1 s1 tq1)
 MergeJoin(t1 s1)
 SeqScan(t1)
 SeqScan(s1)
 IndexOnlyScan(tq1)
 IndexScan(a1)
 IndexScan(u1)
 IndexScan(account)
 IndexScan(q1)
 Leading(((((((t1 s1) tq1) a1) u1) account) q1)) */
select COUNT(distinct account.display_name)
from
tag t1, site s1, question q1, answer a1, tag_question tq1, so_user u1,
account
where
s1.site_name='stackoverflow' and
t1.name = 'powershell' and
t1.site_id = s1.site_id and
q1.site_id = s1.site_id and
tq1.site_id = s1.site_id and
tq1.question_id = q1.id and
tq1.tag_id = t1.id and
a1.site_id = q1.site_id and
a1.question_id = q1.id and
a1.owner_user_id = u1.id and
a1.site_id = u1.site_id and
a1.creation_date >= q1.creation_date + '1 year'::interval and
account.id = u1.account_id;


-- soload_q4-098.sql
-- 253.933
/*+ NestedLoop(t1 s1 tq1 a1 u1 account q1)
 NestedLoop(t1 s1 tq1 a1 u1 account)
 NestedLoop(t1 s1 tq1 a1 u1)
 NestedLoop(t1 s1 tq1 a1)
 NestedLoop(t1 s1 tq1)
 MergeJoin(t1 s1)
 SeqScan(t1)
 SeqScan(s1)
 IndexOnlyScan(tq1)
 IndexScan(a1)
 IndexScan(u1)
 IndexScan(account)
 IndexScan(q1)
 Leading(((((((t1 s1) tq1) a1) u1) account) q1)) */
select COUNT(distinct account.display_name)
from
tag t1, site s1, question q1, answer a1, tag_question tq1, so_user u1,
account
where
s1.site_name='stackoverflow' and
t1.name = 'linux-kernel' and
t1.site_id = s1.site_id and
q1.site_id = s1.site_id and
tq1.site_id = s1.site_id and
tq1.question_id = q1.id and
tq1.tag_id = t1.id and
a1.site_id = q1.site_id and
a1.question_id = q1.id and
a1.owner_user_id = u1.id and
a1.site_id = u1.site_id and
a1.creation_date >= q1.creation_date + '1 year'::interval and
account.id = u1.account_id;


-- soload_q4-099.sql
-- 925.225
/*+ NestedLoop(t1 s1 tq1 a1 u1 account q1)
 NestedLoop(t1 s1 tq1 a1 u1 account)
 NestedLoop(t1 s1 tq1 a1 u1)
 NestedLoop(t1 s1 tq1 a1)
 NestedLoop(t1 s1 tq1)
 MergeJoin(t1 s1)
 SeqScan(t1)
 SeqScan(s1)
 IndexOnlyScan(tq1)
 IndexScan(a1)
 IndexScan(u1)
 IndexScan(account)
 IndexScan(q1)
 Leading(((((((t1 s1) tq1) a1) u1) account) q1)) */
select COUNT(distinct account.display_name)
from
tag t1, site s1, question q1, answer a1, tag_question tq1, so_user u1,
account
where
s1.site_name='stackoverflow' and
t1.name = 'exception' and
t1.site_id = s1.site_id and
q1.site_id = s1.site_id and
tq1.site_id = s1.site_id and
tq1.question_id = q1.id and
tq1.tag_id = t1.id and
a1.site_id = q1.site_id and
a1.question_id = q1.id and
a1.owner_user_id = u1.id and
a1.site_id = u1.site_id and
a1.creation_date >= q1.creation_date + '1 year'::interval and
account.id = u1.account_id;


-- soload_q4-100.sql
-- 373.749
/*+ NestedLoop(t1 s1 tq1 a1 u1 account q1)
 NestedLoop(t1 s1 tq1 a1 u1 account)
 NestedLoop(t1 s1 tq1 a1 u1)
 NestedLoop(t1 s1 tq1 a1)
 NestedLoop(t1 s1 tq1)
 MergeJoin(t1 s1)
 SeqScan(t1)
 SeqScan(s1)
 IndexOnlyScan(tq1)
 IndexScan(a1)
 IndexScan(u1)
 IndexScan(account)
 IndexScan(q1)
 Leading(((((((t1 s1) tq1) a1) u1) account) q1)) */
select COUNT(distinct account.display_name)
from
tag t1, site s1, question q1, answer a1, tag_question tq1, so_user u1,
account
where
s1.site_name='stackoverflow' and
t1.name = 'prolog' and
t1.site_id = s1.site_id and
q1.site_id = s1.site_id and
tq1.site_id = s1.site_id and
tq1.question_id = q1.id and
tq1.tag_id = t1.id and
a1.site_id = q1.site_id and
a1.question_id = q1.id and
a1.owner_user_id = u1.id and
a1.site_id = u1.site_id and
a1.creation_date >= q1.creation_date + '1 year'::interval and
account.id = u1.account_id;


-- soload_q5-096.sql
-- 10.24
/*+ NestedLoop(t1 s1 tq1 c1 q1 u1 account)
 NestedLoop(t1 s1 tq1 c1 q1 u1)
 NestedLoop(t1 s1 tq1 c1 q1)
 NestedLoop(t1 s1 tq1 c1)
 NestedLoop(t1 s1 tq1)
 MergeJoin(t1 s1)
 SeqScan(t1)
 SeqScan(s1)
 IndexOnlyScan(tq1)
 IndexOnlyScan(c1)
 IndexScan(q1)
 IndexScan(u1)
 IndexScan(account)
 Leading(((((((t1 s1) tq1) c1) q1) u1) account)) */
select COUNT(distinct account.display_name)
from
tag t1, site s1, question q1, tag_question tq1, so_user u1, comment c1,
account
where
s1.site_name='computergraphics' and
t1.name in ('raytracing', 'opengl') and
t1.site_id = s1.site_id and
q1.site_id = s1.site_id and
tq1.site_id = s1.site_id and
tq1.question_id = q1.id and
tq1.tag_id = t1.id and
q1.owner_user_id = u1.id and
q1.site_id = u1.site_id and
q1.score > 10 and
q1.view_count < 1558 and
c1.site_id = q1.site_id and
c1.post_id = q1.id and
account.id = u1.account_id;


-- soload_q5-097.sql
-- 7.71
/*+ NestedLoop(t1 s1 tq1 c1 q1 u1 account)
 NestedLoop(t1 s1 tq1 c1 q1 u1)
 NestedLoop(t1 s1 tq1 c1 q1)
 NestedLoop(t1 s1 tq1 c1)
 NestedLoop(t1 s1 tq1)
 MergeJoin(t1 s1)
 SeqScan(t1)
 SeqScan(s1)
 IndexOnlyScan(tq1)
 IndexOnlyScan(c1)
 IndexScan(q1)
 IndexScan(u1)
 IndexScan(account)
 Leading(((((((t1 s1) tq1) c1) q1) u1) account)) */
select COUNT(distinct account.display_name)
from
tag t1, site s1, question q1, tag_question tq1, so_user u1, comment c1,
account
where
s1.site_name='esperanto' and
t1.name in ('single-word-requests', 'translation') and
t1.site_id = s1.site_id and
q1.site_id = s1.site_id and
tq1.site_id = s1.site_id and
tq1.question_id = q1.id and
tq1.tag_id = t1.id and
q1.owner_user_id = u1.id and
q1.site_id = u1.site_id and
q1.score > 12 and
q1.view_count < 1934 and
c1.site_id = q1.site_id and
c1.post_id = q1.id and
account.id = u1.account_id;


-- soload_q5-098.sql
-- 6.623
/*+ NestedLoop(t1 s1 tq1 c1 q1 u1 account)
 NestedLoop(t1 s1 tq1 c1 q1 u1)
 NestedLoop(t1 s1 tq1 c1 q1)
 NestedLoop(t1 s1 tq1 c1)
 NestedLoop(t1 s1 tq1)
 MergeJoin(t1 s1)
 SeqScan(t1)
 SeqScan(s1)
 IndexOnlyScan(tq1)
 IndexOnlyScan(c1)
 IndexScan(q1)
 IndexScan(u1)
 IndexScan(account)
 Leading(((((((t1 s1) tq1) c1) q1) u1) account)) */
select COUNT(distinct account.display_name)
from
tag t1, site s1, question q1, tag_question tq1, so_user u1, comment c1,
account
where
s1.site_name='esperanto' and
t1.name in ('single-word-requests', 'translation') and
t1.site_id = s1.site_id and
q1.site_id = s1.site_id and
tq1.site_id = s1.site_id and
tq1.question_id = q1.id and
tq1.tag_id = t1.id and
q1.owner_user_id = u1.id and
q1.site_id = u1.site_id and
q1.score > 9 and
q1.view_count < 2720 and
c1.site_id = q1.site_id and
c1.post_id = q1.id and
account.id = u1.account_id;


-- soload_q5-099.sql
-- 6.534
/*+ NestedLoop(t1 s1 tq1 c1 q1 u1 account)
 NestedLoop(t1 s1 tq1 c1 q1 u1)
 NestedLoop(t1 s1 tq1 c1 q1)
 NestedLoop(t1 s1 tq1 c1)
 NestedLoop(t1 s1 tq1)
 MergeJoin(t1 s1)
 SeqScan(t1)
 SeqScan(s1)
 IndexOnlyScan(tq1)
 IndexOnlyScan(c1)
 IndexScan(q1)
 IndexScan(u1)
 IndexScan(account)
 Leading(((((((t1 s1) tq1) c1) q1) u1) account)) */
select COUNT(distinct account.display_name)
from
tag t1, site s1, question q1, tag_question tq1, so_user u1, comment c1,
account
where
s1.site_name='esperanto' and
t1.name in ('translation', 'single-word-requests') and
t1.site_id = s1.site_id and
q1.site_id = s1.site_id and
tq1.site_id = s1.site_id and
tq1.question_id = q1.id and
tq1.tag_id = t1.id and
q1.owner_user_id = u1.id and
q1.site_id = u1.site_id and
q1.score > 6 and
q1.view_count < 1994 and
c1.site_id = q1.site_id and
c1.post_id = q1.id and
account.id = u1.account_id;


-- soload_q5-100.sql
-- 5.888
/*+ NestedLoop(t1 s1 tq1 c1 q1 u1 account)
 NestedLoop(t1 s1 tq1 c1 q1 u1)
 NestedLoop(t1 s1 tq1 c1 q1)
 NestedLoop(t1 s1 tq1 c1)
 NestedLoop(t1 s1 tq1)
 MergeJoin(t1 s1)
 SeqScan(t1)
 SeqScan(s1)
 IndexOnlyScan(tq1)
 IndexOnlyScan(c1)
 IndexScan(q1)
 IndexScan(u1)
 IndexScan(account)
 Leading(((((((t1 s1) tq1) c1) q1) u1) account)) */
select COUNT(distinct account.display_name)
from
tag t1, site s1, question q1, tag_question tq1, so_user u1, comment c1,
account
where
s1.site_name='esperanto' and
t1.name in ('single-word-requests', 'translation') and
t1.site_id = s1.site_id and
q1.site_id = s1.site_id and
tq1.site_id = s1.site_id and
tq1.question_id = q1.id and
tq1.tag_id = t1.id and
q1.owner_user_id = u1.id and
q1.site_id = u1.site_id and
q1.score > 12 and
q1.view_count < 2822 and
c1.site_id = q1.site_id and
c1.post_id = q1.id and
account.id = u1.account_id;


-- soload_q6-096.sql
-- 14.122
/*+ NestedLoop(t1 s1 tq1 q1 u1 c1 account)
 NestedLoop(t1 s1 tq1 q1 u1 c1)
 NestedLoop(t1 s1 tq1 q1 u1)
 NestedLoop(t1 s1 tq1 q1)
 NestedLoop(t1 s1 tq1)
 MergeJoin(t1 s1)
 SeqScan(t1)
 SeqScan(s1)
 IndexOnlyScan(tq1)
 IndexScan(q1)
 IndexScan(u1)
 IndexScan(c1)
 IndexScan(account)
 Leading(((((((t1 s1) tq1) q1) u1) c1) account)) */
select COUNT(distinct account.display_name)
from
tag t1, site s1, question q1, tag_question tq1, so_user u1, comment c1,
account
where
s1.site_name='philosophy' and
t1.name in ('inconsistency', 'turing', 'miracles', 'value-theory', 'platonism') and
t1.site_id = s1.site_id and
q1.site_id = s1.site_id and
tq1.site_id = s1.site_id and
tq1.question_id = q1.id and
tq1.tag_id = t1.id and
q1.owner_user_id = u1.id and
q1.site_id = u1.site_id and
c1.site_id = q1.site_id and
c1.post_id = q1.id and
c1.score > q1.score and
account.id = u1.account_id;


-- soload_q6-097.sql
-- 26.862
/*+ NestedLoop(t1 s1 tq1 q1 u1 c1 account)
 NestedLoop(t1 s1 tq1 q1 u1 c1)
 NestedLoop(t1 s1 tq1 q1 u1)
 NestedLoop(t1 s1 tq1 q1)
 NestedLoop(t1 s1 tq1)
 MergeJoin(t1 s1)
 SeqScan(t1)
 SeqScan(s1)
 IndexOnlyScan(tq1)
 IndexScan(q1)
 IndexScan(u1)
 IndexScan(c1)
 IndexScan(account)
 Leading(((((((t1 s1) tq1) q1) u1) c1) account)) */
select COUNT(distinct account.display_name)
from
tag t1, site s1, question q1, tag_question tq1, so_user u1, comment c1,
account
where
s1.site_name='german' and
t1.name in ('dictionary', 'curiosities', 'onomatopoeia', 'word-formation', 'possessive') and
t1.site_id = s1.site_id and
q1.site_id = s1.site_id and
tq1.site_id = s1.site_id and
tq1.question_id = q1.id and
tq1.tag_id = t1.id and
q1.owner_user_id = u1.id and
q1.site_id = u1.site_id and
c1.site_id = q1.site_id and
c1.post_id = q1.id and
c1.score > q1.score and
account.id = u1.account_id;


-- soload_q6-098.sql
-- 44.386
/*+ NestedLoop(t1 s1 tq1 q1 u1 c1 account)
 NestedLoop(t1 s1 tq1 q1 u1 c1)
 NestedLoop(t1 s1 tq1 q1 u1)
 NestedLoop(t1 s1 tq1 q1)
 NestedLoop(t1 s1 tq1)
 MergeJoin(t1 s1)
 SeqScan(t1)
 SeqScan(s1)
 IndexOnlyScan(tq1)
 IndexScan(q1)
 IndexScan(u1)
 IndexScan(c1)
 IndexScan(account)
 Leading(((((((t1 s1) tq1) q1) u1) c1) account)) */
select COUNT(distinct account.display_name)
from
tag t1, site s1, question q1, tag_question tq1, so_user u1, comment c1,
account
where
s1.site_name='german' and
t1.name in ('etiquette', 'phrase-request', 'clarification', 'terminology') and
t1.site_id = s1.site_id and
q1.site_id = s1.site_id and
tq1.site_id = s1.site_id and
tq1.question_id = q1.id and
tq1.tag_id = t1.id and
q1.owner_user_id = u1.id and
q1.site_id = u1.site_id and
c1.site_id = q1.site_id and
c1.post_id = q1.id and
c1.score > q1.score and
account.id = u1.account_id;


-- soload_q6-099.sql
-- 20.837
/*+ NestedLoop(t1 s1 tq1 q1 u1 c1 account)
 NestedLoop(t1 s1 tq1 q1 u1 c1)
 NestedLoop(t1 s1 tq1 q1 u1)
 NestedLoop(t1 s1 tq1 q1)
 NestedLoop(t1 s1 tq1)
 MergeJoin(t1 s1)
 SeqScan(t1)
 SeqScan(s1)
 IndexOnlyScan(tq1)
 IndexScan(q1)
 IndexScan(u1)
 IndexScan(c1)
 IndexScan(account)
 Leading(((((((t1 s1) tq1) q1) u1) c1) account)) */
select COUNT(distinct account.display_name)
from
tag t1, site s1, question q1, tag_question tq1, so_user u1, comment c1,
account
where
s1.site_name='german' and
t1.name in ('indefinite-pronouns', 'pronominal-adverbs', 'genitive') and
t1.site_id = s1.site_id and
q1.site_id = s1.site_id and
tq1.site_id = s1.site_id and
tq1.question_id = q1.id and
tq1.tag_id = t1.id and
q1.owner_user_id = u1.id and
q1.site_id = u1.site_id and
c1.site_id = q1.site_id and
c1.post_id = q1.id and
c1.score > q1.score and
account.id = u1.account_id;


-- soload_q6-100.sql
-- 41.798
/*+ NestedLoop(t1 s1 tq1 q1 u1 c1 account)
 NestedLoop(t1 s1 tq1 q1 u1 c1)
 NestedLoop(t1 s1 tq1 q1 u1)
 NestedLoop(t1 s1 tq1 q1)
 NestedLoop(t1 s1 tq1)
 MergeJoin(t1 s1)
 SeqScan(t1)
 SeqScan(s1)
 IndexOnlyScan(tq1)
 IndexScan(q1)
 IndexScan(u1)
 IndexScan(c1)
 IndexScan(account)
 Leading(((((((t1 s1) tq1) q1) u1) c1) account)) */
select COUNT(distinct account.display_name)
from
tag t1, site s1, question q1, tag_question tq1, so_user u1, comment c1,
account
where
s1.site_name='german' and
t1.name in ('possessive-pronouns', 'hyphen', 'gender-neutrality', 'particles', 'prepositions') and
t1.site_id = s1.site_id and
q1.site_id = s1.site_id and
tq1.site_id = s1.site_id and
tq1.question_id = q1.id and
tq1.tag_id = t1.id and
q1.owner_user_id = u1.id and
q1.site_id = u1.site_id and
c1.site_id = q1.site_id and
c1.post_id = q1.id and
c1.score > q1.score and
account.id = u1.account_id;


-- soload_q7-096.sql
-- 624.837
/*+ NestedLoop(b2 b1 so_user account)
 NestedLoop(b2 b1 so_user)
 NestedLoop(b2 b1)
 SeqScan(b2)
 IndexOnlyScan(b1)
 IndexScan(so_user)
 IndexScan(account)
 Leading((((b2 b1) so_user) account)) */
select count(distinct account.display_name) from account, so_user, badge b1, badge b2 where
account.website_url != '' and
account.id = so_user.account_id and
b1.site_id = so_user.site_id and
b1.user_id = so_user.id and
b1.name = 'Commentator' and
b2.site_id = so_user.site_id and
b2.user_id = so_user.id and
b2.name = 'Documentation Beta' and
b2.date > b1.date + '12 months'::interval


-- soload_q7-097.sql
-- 232.95
/*+ NestedLoop(b1 b2 so_user account)
 NestedLoop(b1 b2 so_user)
 NestedLoop(b1 b2)
 SeqScan(b1)
 IndexOnlyScan(b2)
 IndexScan(so_user)
 IndexScan(account)
 Leading((((b1 b2) so_user) account)) */
select count(distinct account.display_name) from account, so_user, badge b1, badge b2 where
account.website_url != '' and
account.id = so_user.account_id and
b1.site_id = so_user.site_id and
b1.user_id = so_user.id and
b1.name = 'Research Assistant' and
b2.site_id = so_user.site_id and
b2.user_id = so_user.id and
b2.name = 'API Beta' and
b2.date > b1.date + '7 months'::interval


-- soload_q7-098.sql
-- 232.45
/*+ NestedLoop(b1 b2 so_user account)
 NestedLoop(b1 b2 so_user)
 NestedLoop(b1 b2)
 SeqScan(b1)
 IndexOnlyScan(b2)
 IndexScan(so_user)
 IndexScan(account)
 Leading((((b1 b2) so_user) account)) */
select count(distinct account.display_name) from account, so_user, badge b1, badge b2 where
account.website_url != '' and
account.id = so_user.account_id and
b1.site_id = so_user.site_id and
b1.user_id = so_user.id and
b1.name = 'Not a Robot' and
b2.site_id = so_user.site_id and
b2.user_id = so_user.id and
b2.name = 'Sheriff' and
b2.date > b1.date + '7 months'::interval


-- soload_q7-099.sql
-- 238.355
/*+ NestedLoop(b1 b2 so_user account)
 NestedLoop(b1 b2 so_user)
 NestedLoop(b1 b2)
 SeqScan(b1)
 IndexOnlyScan(b2)
 IndexScan(so_user)
 IndexScan(account)
 Leading((((b1 b2) so_user) account)) */
select count(distinct account.display_name) from account, so_user, badge b1, badge b2 where
account.website_url != '' and
account.id = so_user.account_id and
b1.site_id = so_user.site_id and
b1.user_id = so_user.id and
b1.name = 'Reversal' and
b2.site_id = so_user.site_id and
b2.user_id = so_user.id and
b2.name = 'Nice Question' and
b2.date > b1.date + '4 months'::interval


-- soload_q7-100.sql
-- 222.855
/*+ NestedLoop(b1 b2 so_user account)
 NestedLoop(b1 b2 so_user)
 NestedLoop(b1 b2)
 SeqScan(b1)
 IndexOnlyScan(b2)
 IndexScan(so_user)
 IndexScan(account)
 Leading((((b1 b2) so_user) account)) */
select count(distinct account.display_name) from account, so_user, badge b1, badge b2 where
account.website_url != '' and
account.id = so_user.account_id and
b1.site_id = so_user.site_id and
b1.user_id = so_user.id and
b1.name = 'API Beta' and
b2.site_id = so_user.site_id and
b2.user_id = so_user.id and
b2.name = 'Publicist' and
b2.date > b1.date + '5 months'::interval


-- soload_q8-096.sql
-- 8.181
/*+ NestedLoop(site tag tq1 q1 c1 pl q2 tq2 c2)
 NestedLoop(site tag tq1 q1 c1 pl q2 tq2)
 NestedLoop(site tag tq1 q1 c1 pl q2)
 NestedLoop(site tag tq1 q1 c1 pl)
 NestedLoop(site tag tq1 q1 c1)
 NestedLoop(site tag tq1 q1)
 NestedLoop(site tag tq1)
 NestedLoop(site tag)
 SeqScan(site)
 SeqScan(tag)
 IndexOnlyScan(tq1)
 IndexOnlyScan(q1)
 IndexScan(c1)
 IndexOnlyScan(pl)
 IndexOnlyScan(q2)
 IndexOnlyScan(tq2)
 IndexScan(c2)
 Leading(((((((((site tag) tq1) q1) c1) pl) q2) tq2) c2)) */
select count(distinct q1.id) from
site, post_link pl, question q1, question q2, comment c1, comment c2,
tag, tag_question tq1, tag_question tq2
where
site.site_name = 'german' and
pl.site_id = site.site_id and
pl.site_id = q1.site_id and
pl.post_id_from = q1.id and
pl.site_id = q2.site_id and
pl.post_id_to = q2.id and
c1.site_id = q1.site_id and
c1.post_id = q1.id and
c2.site_id = q2.site_id and
c2.post_id = q2.id and
c1.date > c2.date and
tag.name in ('ajax', 'angular') and
tag.id = tq1.tag_id and
tag.site_id = tq1.site_id and
tag.id = tq2.tag_id and
tag.site_id = tq1.site_id and
tag.site_id = pl.site_id and
tq1.site_id = q1.site_id and
tq1.question_id = q1.id and
tq2.site_id = q2.site_id and
tq2.question_id = q2.id;


-- soload_q8-097.sql
-- 8.052
/*+ NestedLoop(site tag tq1 q1 c1 pl q2 tq2 c2)
 NestedLoop(site tag tq1 q1 c1 pl q2 tq2)
 NestedLoop(site tag tq1 q1 c1 pl q2)
 NestedLoop(site tag tq1 q1 c1 pl)
 NestedLoop(site tag tq1 q1 c1)
 NestedLoop(site tag tq1 q1)
 NestedLoop(site tag tq1)
 NestedLoop(site tag)
 SeqScan(site)
 SeqScan(tag)
 IndexOnlyScan(tq1)
 IndexOnlyScan(q1)
 IndexScan(c1)
 IndexOnlyScan(pl)
 IndexOnlyScan(q2)
 IndexOnlyScan(tq2)
 IndexScan(c2)
 Leading(((((((((site tag) tq1) q1) c1) pl) q2) tq2) c2)) */
select count(distinct q1.id) from
site, post_link pl, question q1, question q2, comment c1, comment c2,
tag, tag_question tq1, tag_question tq2
where
site.site_name = 'german' and
pl.site_id = site.site_id and
pl.site_id = q1.site_id and
pl.post_id_from = q1.id and
pl.site_id = q2.site_id and
pl.post_id_to = q2.id and
c1.site_id = q1.site_id and
c1.post_id = q1.id and
c2.site_id = q2.site_id and
c2.post_id = q2.id and
c1.date > c2.date and
tag.name in ('ios', 'ruby-on-rails') and
tag.id = tq1.tag_id and
tag.site_id = tq1.site_id and
tag.id = tq2.tag_id and
tag.site_id = tq1.site_id and
tag.site_id = pl.site_id and
tq1.site_id = q1.site_id and
tq1.question_id = q1.id and
tq2.site_id = q2.site_id and
tq2.question_id = q2.id;


-- soload_q8-098.sql
-- 8.422
/*+ NestedLoop(tag site tq1 q1 c1 pl q2 tq2 c2)
 NestedLoop(tag site tq1 q1 c1 pl q2 tq2)
 NestedLoop(tag site tq1 q1 c1 pl q2)
 NestedLoop(tag site tq1 q1 c1 pl)
 NestedLoop(tag site tq1 q1 c1)
 NestedLoop(tag site tq1 q1)
 NestedLoop(tag site tq1)
 MergeJoin(tag site)
 SeqScan(tag)
 SeqScan(site)
 IndexOnlyScan(tq1)
 IndexOnlyScan(q1)
 IndexScan(c1)
 IndexOnlyScan(pl)
 IndexOnlyScan(q2)
 IndexOnlyScan(tq2)
 IndexScan(c2)
 Leading(((((((((tag site) tq1) q1) c1) pl) q2) tq2) c2)) */
select count(distinct q1.id) from
site, post_link pl, question q1, question q2, comment c1, comment c2,
tag, tag_question tq1, tag_question tq2
where
site.site_name = 'german' and
pl.site_id = site.site_id and
pl.site_id = q1.site_id and
pl.post_id_from = q1.id and
pl.site_id = q2.site_id and
pl.post_id_to = q2.id and
c1.site_id = q1.site_id and
c1.post_id = q1.id and
c2.site_id = q2.site_id and
c2.post_id = q2.id and
c1.date > c2.date and
tag.name in ('database', 'asp.net', 'xml', 'django', 'css') and
tag.id = tq1.tag_id and
tag.site_id = tq1.site_id and
tag.id = tq2.tag_id and
tag.site_id = tq1.site_id and
tag.site_id = pl.site_id and
tq1.site_id = q1.site_id and
tq1.question_id = q1.id and
tq2.site_id = q2.site_id and
tq2.question_id = q2.id;


-- soload_q8-099.sql
-- 7.093
/*+ NestedLoop(tag site tq1 q1 c1 pl q2 tq2 c2)
 NestedLoop(tag site tq1 q1 c1 pl q2 tq2)
 NestedLoop(tag site tq1 q1 c1 pl q2)
 NestedLoop(tag site tq1 q1 c1 pl)
 NestedLoop(tag site tq1 q1 c1)
 NestedLoop(tag site tq1 q1)
 NestedLoop(tag site tq1)
 MergeJoin(tag site)
 SeqScan(tag)
 SeqScan(site)
 IndexOnlyScan(tq1)
 IndexOnlyScan(q1)
 IndexScan(c1)
 IndexOnlyScan(pl)
 IndexOnlyScan(q2)
 IndexOnlyScan(tq2)
 IndexScan(c2)
 Leading(((((((((tag site) tq1) q1) c1) pl) q2) tq2) c2)) */
select count(distinct q1.id) from
site, post_link pl, question q1, question q2, comment c1, comment c2,
tag, tag_question tq1, tag_question tq2
where
site.site_name = 'german' and
pl.site_id = site.site_id and
pl.site_id = q1.site_id and
pl.post_id_from = q1.id and
pl.site_id = q2.site_id and
pl.post_id_to = q2.id and
c1.site_id = q1.site_id and
c1.post_id = q1.id and
c2.site_id = q2.site_id and
c2.post_id = q2.id and
c1.date > c2.date and
tag.name in ('database', 'python', 'django') and
tag.id = tq1.tag_id and
tag.site_id = tq1.site_id and
tag.id = tq2.tag_id and
tag.site_id = tq1.site_id and
tag.site_id = pl.site_id and
tq1.site_id = q1.site_id and
tq1.question_id = q1.id and
tq2.site_id = q2.site_id and
tq2.question_id = q2.id;


-- soload_q8-100.sql
-- 6.934
/*+ NestedLoop(tag site tq1 q1 c1 pl q2 tq2 c2)
 NestedLoop(tag site tq1 q1 c1 pl q2 tq2)
 NestedLoop(tag site tq1 q1 c1 pl q2)
 NestedLoop(tag site tq1 q1 c1 pl)
 NestedLoop(tag site tq1 q1 c1)
 NestedLoop(tag site tq1 q1)
 NestedLoop(tag site tq1)
 MergeJoin(tag site)
 SeqScan(tag)
 SeqScan(site)
 IndexOnlyScan(tq1)
 IndexOnlyScan(q1)
 IndexScan(c1)
 IndexOnlyScan(pl)
 IndexOnlyScan(q2)
 IndexOnlyScan(tq2)
 IndexScan(c2)
 Leading(((((((((tag site) tq1) q1) c1) pl) q2) tq2) c2)) */
select count(distinct q1.id) from
site, post_link pl, question q1, question q2, comment c1, comment c2,
tag, tag_question tq1, tag_question tq2
where
site.site_name = 'german' and
pl.site_id = site.site_id and
pl.site_id = q1.site_id and
pl.post_id_from = q1.id and
pl.site_id = q2.site_id and
pl.post_id_to = q2.id and
c1.site_id = q1.site_id and
c1.post_id = q1.id and
c2.site_id = q2.site_id and
c2.post_id = q2.id and
c1.date > c2.date and
tag.name in ('arrays', 'linux', 'java') and
tag.id = tq1.tag_id and
tag.site_id = tq1.site_id and
tag.id = tq2.tag_id and
tag.site_id = tq1.site_id and
tag.site_id = pl.site_id and
tq1.site_id = q1.site_id and
tq1.question_id = q1.id and
tq2.site_id = q2.site_id and
tq2.question_id = q2.id;


-- soload_q9-096.sql
-- 190.946
/*+ NestedLoop(tag site tq q so_user account pl a)
 NestedLoop(tag site tq q so_user account pl)
 NestedLoop(tag site tq q so_user account)
 NestedLoop(tag site tq q so_user)
 NestedLoop(tag site tq q)
 NestedLoop(tag site tq)
 MergeJoin(tag site)
 SeqScan(tag)
 SeqScan(site)
 IndexOnlyScan(tq)
 IndexScan(q)
 IndexScan(so_user)
 IndexScan(account)
 IndexOnlyScan(pl)
 IndexOnlyScan(a)
 Leading((((((((tag site) tq) q) so_user) account) pl) a)) */
select count(distinct account.id) from
account, site, so_user, question q, post_link pl, tag, tag_question tq where
not exists (select * from answer a where a.site_id = q.site_id and a.question_id = q.id) and
site.site_name = 'stackoverflow' and
site.site_id = q.site_id and
pl.site_id = q.site_id and
pl.post_id_to = q.id and
tag.name = 'simulation' and
tag.site_id = q.site_id and
q.creation_date > '2018-01-01'::date and
tq.site_id = tag.site_id and
tq.tag_id = tag.id and
tq.question_id = q.id and
q.owner_user_id = so_user.id and
q.site_id = so_user.site_id and
so_user.reputation > 134 and
account.id = so_user.account_id and
account.website_url != '';


-- soload_q9-097.sql
-- 52.123
/*+ NestedLoop(tag site tq q so_user account pl a)
 NestedLoop(tag site tq q so_user account pl)
 NestedLoop(tag site tq q so_user account)
 NestedLoop(tag site tq q so_user)
 NestedLoop(tag site tq q)
 NestedLoop(tag site tq)
 MergeJoin(tag site)
 SeqScan(tag)
 SeqScan(site)
 IndexOnlyScan(tq)
 IndexScan(q)
 IndexScan(so_user)
 IndexScan(account)
 IndexOnlyScan(pl)
 IndexOnlyScan(a)
 Leading((((((((tag site) tq) q) so_user) account) pl) a)) */
select count(distinct account.id) from
account, site, so_user, question q, post_link pl, tag, tag_question tq where
not exists (select * from answer a where a.site_id = q.site_id and a.question_id = q.id) and
site.site_name = 'stackoverflow' and
site.site_id = q.site_id and
pl.site_id = q.site_id and
pl.post_id_to = q.id and
tag.name = 'ios5' and
tag.site_id = q.site_id and
q.creation_date > '2017-01-01'::date and
tq.site_id = tag.site_id and
tq.tag_id = tag.id and
tq.question_id = q.id and
q.owner_user_id = so_user.id and
q.site_id = so_user.site_id and
so_user.reputation > 69 and
account.id = so_user.account_id and
account.website_url != '';


-- soload_q9-098.sql
-- 4340.362
/*+ NestedLoop(tag site tq q so_user account pl a)
 NestedLoop(tag site tq q so_user account pl)
 NestedLoop(tag site tq q so_user account)
 NestedLoop(tag site tq q so_user)
 NestedLoop(tag site tq q)
 NestedLoop(tag site tq)
 MergeJoin(tag site)
 SeqScan(tag)
 SeqScan(site)
 IndexOnlyScan(tq)
 IndexScan(q)
 IndexScan(so_user)
 IndexScan(account)
 IndexOnlyScan(pl)
 IndexOnlyScan(a)
 Leading((((((((tag site) tq) q) so_user) account) pl) a)) */
select count(distinct account.id) from
account, site, so_user, question q, post_link pl, tag, tag_question tq where
not exists (select * from answer a where a.site_id = q.site_id and a.question_id = q.id) and
site.site_name = 'stackoverflow' and
site.site_id = q.site_id and
pl.site_id = q.site_id and
pl.post_id_to = q.id and
tag.name = 'aes' and
tag.site_id = q.site_id and
q.creation_date > '2013-01-01'::date and
tq.site_id = tag.site_id and
tq.tag_id = tag.id and
tq.question_id = q.id and
q.owner_user_id = so_user.id and
q.site_id = so_user.site_id and
so_user.reputation > 87 and
account.id = so_user.account_id and
account.website_url != '';


-- soload_q9-099.sql
-- 5735.255
/*+ NestedLoop(tag site tq q so_user account pl a)
 NestedLoop(tag site tq q so_user account pl)
 NestedLoop(tag site tq q so_user account)
 NestedLoop(tag site tq q so_user)
 NestedLoop(tag site tq q)
 NestedLoop(tag site tq)
 MergeJoin(tag site)
 SeqScan(tag)
 SeqScan(site)
 IndexOnlyScan(tq)
 IndexScan(q)
 IndexScan(so_user)
 IndexScan(account)
 IndexOnlyScan(pl)
 IndexOnlyScan(a)
 Leading((((((((tag site) tq) q) so_user) account) pl) a)) */
select count(distinct account.id) from
account, site, so_user, question q, post_link pl, tag, tag_question tq where
not exists (select * from answer a where a.site_id = q.site_id and a.question_id = q.id) and
site.site_name = 'stackoverflow' and
site.site_id = q.site_id and
pl.site_id = q.site_id and
pl.post_id_to = q.id and
tag.name = 'queue' and
tag.site_id = q.site_id and
q.creation_date > '2013-01-01'::date and
tq.site_id = tag.site_id and
tq.tag_id = tag.id and
tq.question_id = q.id and
q.owner_user_id = so_user.id and
q.site_id = so_user.site_id and
so_user.reputation > 57 and
account.id = so_user.account_id and
account.website_url != '';


-- soload_q9-100.sql
-- 113.476
/*+ NestedLoop(tag site tq q so_user account pl a)
 NestedLoop(tag site tq q so_user account pl)
 NestedLoop(tag site tq q so_user account)
 NestedLoop(tag site tq q so_user)
 NestedLoop(tag site tq q)
 NestedLoop(tag site tq)
 MergeJoin(tag site)
 SeqScan(tag)
 SeqScan(site)
 IndexOnlyScan(tq)
 IndexScan(q)
 IndexScan(so_user)
 IndexScan(account)
 IndexOnlyScan(pl)
 IndexOnlyScan(a)
 Leading((((((((tag site) tq) q) so_user) account) pl) a)) */
select count(distinct account.id) from
account, site, so_user, question q, post_link pl, tag, tag_question tq where
not exists (select * from answer a where a.site_id = q.site_id and a.question_id = q.id) and
site.site_name = 'stackoverflow' and
site.site_id = q.site_id and
pl.site_id = q.site_id and
pl.post_id_to = q.id and
tag.name = 'picturebox' and
tag.site_id = q.site_id and
q.creation_date > '2018-01-01'::date and
tq.site_id = tag.site_id and
tq.tag_id = tag.id and
tq.question_id = q.id and
q.owner_user_id = so_user.id and
q.site_id = so_user.site_id and
so_user.reputation > 57 and
account.id = so_user.account_id and
account.website_url != '';