-- sql file: q10-003.sql
/*+ NestedLoop(site pl1 pl2 q1 q3 q2 comment comment_1 comment_2)
 NestedLoop(site pl1 pl2 q1 q3 q2 comment comment_1)
 NestedLoop(site pl1 pl2 q1 q3 q2 comment)
 NestedLoop(site pl1 pl2 q1 q3 q2)
 NestedLoop(site pl1 pl2 q1 q3)
 NestedLoop(site pl1 pl2 q1)
 NestedLoop(site pl1 pl2)
 NestedLoop(site pl1)
 IndexScan(site)
 IndexOnlyScan(pl1)
 IndexOnlyScan(pl2)
 IndexScan(q1)
 IndexScan(q3)
 IndexOnlyScan(q2)
 IndexOnlyScan(comment)
 IndexOnlyScan(comment_1)
 IndexOnlyScan(comment_2)
 Leading(((((((((site pl1) pl2) q1) q3) q2) comment) comment_1) comment_2)) */
select count(distinct q1.id) from
site, post_link pl1, post_link pl2, question q1, question q2, question q3 where

site.site_name = 'cseducators' and
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

-- sql file: q9-013.sql
/*+ HashJoin(a pl account so_user q tq site tag)
 HashJoin(pl account so_user q tq site tag)
 HashJoin(account so_user q tq site tag)
 HashJoin(so_user q tq site tag)
 HashJoin(q tq site tag)
 HashJoin(tq site tag)
 HashJoin(tq site)
 SeqScan(a)
 SeqScan(pl)
 SeqScan(account)
 SeqScan(so_user)
 SeqScan(q)
 SeqScan(tq)
 SeqScan(site)
 SeqScan(tag)
 Leading((a (pl (account (so_user (q ((tq site) tag))))))) */
select count(distinct account.id) from
account, site, so_user, question q, post_link pl, tag, tag_question tq where
not exists (select * from answer a where a.site_id = q.site_id and a.question_id = q.id) and
site.site_name = 'stackoverflow' and
site.site_id = q.site_id and
pl.site_id = q.site_id and
pl.post_id_to = q.id and

tag.name = 'codeigniter' and
tag.site_id = q.site_id and

q.creation_date > '2016-01-01'::date and

tq.site_id = tag.site_id and
tq.tag_id = tag.id and
tq.question_id = q.id and

q.owner_user_id = so_user.id and
q.site_id = so_user.site_id and
so_user.reputation > 126 and

account.id = so_user.account_id and
account.website_url != '';

-- sql file: q10-004.sql
/*+ NestedLoop(site pl1 pl2 q1 q3 q2 comment comment_1 comment_2)
 NestedLoop(site pl1 pl2 q1 q3 q2 comment comment_1)
 NestedLoop(site pl1 pl2 q1 q3 q2 comment)
 NestedLoop(site pl1 pl2 q1 q3 q2)
 NestedLoop(site pl1 pl2 q1 q3)
 NestedLoop(site pl1 pl2 q1)
 NestedLoop(site pl1 pl2)
 NestedLoop(site pl1)
 IndexScan(site)
 IndexOnlyScan(pl1)
 IndexOnlyScan(pl2)
 IndexScan(q1)
 IndexScan(q3)
 IndexOnlyScan(q2)
 IndexOnlyScan(comment)
 IndexOnlyScan(comment_1)
 IndexOnlyScan(comment_2)
 Leading(((((((((site pl1) pl2) q1) q3) q2) comment) comment_1) comment_2)) */
select count(distinct q1.id) from
site, post_link pl1, post_link pl2, question q1, question q2, question q3 where

site.site_name = 'pm' and
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

-- sql file: q15-003.sql
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
AND (q1.view_count >= 10)
AND (q1.view_count <= 1000)
AND (s.site_name in ('stackoverflow'))
AND (t1.name in ('avr','chromium','clang++','comparator','nginx','paypal','sqoop'))
AND (acc.website_url ILIKE ('%en'))
GROUP BY b1.name
ORDER BY COUNT(*)
DESC
LIMIT 100

-- sql file: q15-002.sql
/*+ NestedLoop(t1 s tq1 q1 u1 b1 acc)
 NestedLoop(t1 s tq1 q1 u1 b1)
 NestedLoop(t1 s tq1 q1 u1)
 NestedLoop(t1 s tq1 q1)
 NestedLoop(t1 s tq1)
 NestedLoop(t1 s)
 SeqScan(t1)
 SeqScan(s)
 IndexScan(tq1)
 IndexScan(q1)
 IndexScan(u1)
 IndexScan(b1)
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
AND (q1.score >= 10)
AND (q1.score <= 1000)
AND (s.site_name in ('stackoverflow','superuser'))
AND (t1.name in ('binding','makefile','replace'))
AND (acc.website_url ILIKE ('%'))
GROUP BY b1.name
ORDER BY COUNT(*)
DESC
LIMIT 100

-- sql file: q10-005.sql
/*+ NestedLoop(site pl1 pl2 q1 q3 q2 comment comment_1 comment_2)
 NestedLoop(site pl1 pl2 q1 q3 q2 comment comment_1)
 NestedLoop(site pl1 pl2 q1 q3 q2 comment)
 NestedLoop(site pl1 pl2 q1 q3 q2)
 NestedLoop(site pl1 pl2 q1 q3)
 NestedLoop(site pl1 pl2 q1)
 NestedLoop(site pl1 pl2)
 NestedLoop(site pl1)
 IndexScan(site)
 IndexScan(pl1)
 IndexScan(pl2)
 IndexScan(q1)
 IndexScan(q3)
 IndexScan(q2)
 IndexScan(comment)
 IndexScan(comment_1)
 IndexScan(comment_2)
 Leading(((((((((site pl1) pl2) q1) q3) q2) comment) comment_1) comment_2)) */
select count(distinct q1.id) from
site, post_link pl1, post_link pl2, question q1, question q2, question q3 where

site.site_name = 'martialarts' and
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

-- sql file: q13-003.sql
/*+ NestedLoop(t1 s tq1 a1 u1 q1 b acc)
 NestedLoop(t1 s tq1 a1 u1 q1 b)
 NestedLoop(t1 s tq1 a1 u1 q1)
 NestedLoop(t1 s tq1 a1 u1)
 NestedLoop(t1 s tq1 a1)
 NestedLoop(t1 s tq1)
 NestedLoop(t1 s)
 SeqScan(t1)
 IndexScan(s)
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
AND (s.site_name in ('money','scifi','security','webapps'))
AND (t1.name in ('aliens','canada','certificates','cryptography','dc','india','network','passwords','privacy','windows'))
AND (q1.view_count >= 10)
AND (q1.view_count <= 1000)
AND (u1.downvotes >= 10)
AND (u1.downvotes <= 100000)
AND (b.name in ('Citizen Patrol','Excavator','Informed'))
GROUP BY acc.location
ORDER BY COUNT(*)
DESC
LIMIT 100

-- sql file: q12-004.sql
/*+ NestedLoop(t1 s tq1 a1 u1 q1)
 NestedLoop(t1 s tq1 a1 u1)
 NestedLoop(t1 s tq1 a1)
 NestedLoop(t1 s tq1)
 HashJoin(t1 s)
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
AND (s.site_name in ('stackoverflow'))
AND (t1.name in ('c-preprocessor','cursor','iteration','left-join','multiprocessing','phpstorm','polymorphism','printf','pyqt5','sdk','tabs','uibutton','uinavigationcontroller','vb6'))
AND (q1.favorite_count >= 0)
AND (q1.favorite_count <= 1)
AND (u1.downvotes >= 10)
AND (u1.downvotes <= 100000)
GROUP BY t1.name

-- sql file: q11-001.sql
/*+ NestedLoop(t s tq q)
 NestedLoop(t s tq)
 HashJoin(t s)
 SeqScan(t)
 SeqScan(s)
 IndexScan(tq)
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
AND (t.name in ('api','audio','events','file-io','forms','functional-programming','java-ee','serialization','sqlite','ubuntu','unicode'))
AND (q.favorite_count >= 5)
AND (q.favorite_count <= 5000)

-- sql file: q12-005.sql
/*+ NestedLoop(s t1 tq1 a1 q1 u1)
 NestedLoop(s t1 tq1 a1 q1)
 NestedLoop(s t1 tq1 a1)
 NestedLoop(s t1 tq1)
 NestedLoop(s t1)
 IndexScan(s)
 IndexScan(t1)
 IndexScan(tq1)
 IndexScan(a1)
 IndexScan(q1)
 IndexScan(u1)
 Leading((((((s t1) tq1) a1) q1) u1)) */
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
AND (t1.name in ('congruences','sheaf-theory'))
AND (q1.view_count >= 10)
AND (q1.view_count <= 1000)
AND (u1.reputation >= 10)
AND (u1.reputation <= 100000)
GROUP BY t1.name

-- sql file: q11-003.sql
/*+ NestedLoop(t s tq q)
 NestedLoop(t s tq)
 NestedLoop(t s)
 SeqScan(t)
 IndexScan(s)
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
AND (s.site_name in ('scifi'))
AND (t.name in ('harry-potter','short-stories','star-trek','star-wars'))
AND (q.view_count >= 10)
AND (q.view_count <= 1000)

-- sql file: q9-003.sql
/*+ HashJoin(a pl account so_user q tq site tag)
 HashJoin(pl account so_user q tq site tag)
 HashJoin(account so_user q tq site tag)
 HashJoin(so_user q tq site tag)
 HashJoin(q tq site tag)
 HashJoin(tq site tag)
 HashJoin(tq site)
 SeqScan(a)
 SeqScan(pl)
 SeqScan(account)
 SeqScan(so_user)
 SeqScan(q)
 SeqScan(tq)
 SeqScan(site)
 SeqScan(tag)
 Leading((a (pl (account (so_user (q ((tq site) tag))))))) */
select count(distinct account.id) from
account, site, so_user, question q, post_link pl, tag, tag_question tq where
not exists (select * from answer a where a.site_id = q.site_id and a.question_id = q.id) and
site.site_name = 'stackoverflow' and
site.site_id = q.site_id and
pl.site_id = q.site_id and
pl.post_id_to = q.id and

tag.name = 'debugging' and
tag.site_id = q.site_id and

q.creation_date > '2018-01-01'::date and

tq.site_id = tag.site_id and
tq.tag_id = tag.id and
tq.question_id = q.id and

q.owner_user_id = so_user.id and
q.site_id = so_user.site_id and
so_user.reputation > 118 and

account.id = so_user.account_id and
account.website_url != '';

-- sql file: q16-005.sql
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
AND (t1.name in ('android-custom-view','export-to-excel','filenames'))
AND (acc.website_url ILIKE ('%'))

-- sql file: q16-001.sql
/*+ NestedLoop(t1 s tq1 q1 u1 b1 acc)
 NestedLoop(t1 s tq1 q1 u1 b1)
 NestedLoop(t1 s tq1 q1 u1)
 NestedLoop(t1 s tq1 q1)
 NestedLoop(t1 s tq1)
 NestedLoop(t1 s)
 SeqScan(t1)
 IndexScan(s)
 IndexScan(tq1)
 IndexScan(q1)
 IndexScan(u1)
 IndexScan(b1)
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
AND (q1.score >= 10)
AND (q1.score <= 1000)
AND s.site_name = 'stackoverflow'
AND (t1.name in ('binary-tree','commit','google-cloud-platform','hudson','jetty'))
AND (acc.website_url ILIKE ('%com'))

-- sql file: q13-005.sql
/*+ NestedLoop(t1 s tq1 a1 u1 q1 b acc)
 NestedLoop(t1 s tq1 a1 u1 q1 b)
 NestedLoop(t1 s tq1 a1 u1 q1)
 NestedLoop(t1 s tq1 a1 u1)
 NestedLoop(t1 s tq1 a1)
 NestedLoop(t1 s tq1)
 HashJoin(t1 s)
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
AND (s.site_name in ('stackoverflow','superuser'))
AND (t1.name in ('apache-poi','branch','csrf','focus','glassfish','grand-central-dispatch','interpolation','osgi','pyqt4','return-value','textarea','uilabel','window'))
AND (q1.favorite_count >= 0)
AND (q1.favorite_count <= 10000)
AND (u1.downvotes >= 0)
AND (u1.downvotes <= 10)
AND (b.name in ('Commentator','Curious','Good Question','Organizer','Revival','Scholar','Self-Learner','Student','Supporter','Tumbleweed'))
GROUP BY acc.location
ORDER BY COUNT(*)
DESC
LIMIT 100

-- sql file: q13-001.sql
/*+ NestedLoop(s t1 tq1 a1 u1 q1 b acc)
 NestedLoop(s t1 tq1 a1 u1 q1 b)
 NestedLoop(s t1 tq1 a1 u1 q1)
 NestedLoop(s t1 tq1 a1 u1)
 NestedLoop(s t1 tq1 a1)
 NestedLoop(s t1 tq1)
 NestedLoop(s t1)
 IndexScan(s)
 IndexScan(t1)
 IndexOnlyScan(tq1)
 IndexScan(a1)
 IndexScan(u1)
 IndexScan(q1)
 IndexOnlyScan(b)
 IndexScan(acc)
 Leading((((((((s t1) tq1) a1) u1) q1) b) acc)) */
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
AND (s.site_name in ('softwareengineering','webapps'))
AND (t1.name in ('architecture','design','design-patterns','gmail','google-sheets','java','object-oriented'))
AND (q1.score >= 1)
AND (q1.score <= 10)
AND (u1.upvotes >= 1)
AND (u1.upvotes <= 100)
AND (b.name in ('Autobiographer','Caucus','Citizen Patrol','Critic','Editor','Famous Question','Informed','Nice Answer','Notable Question','Popular Question','Scholar','Student','Supporter','Teacher'))
GROUP BY acc.location
ORDER BY COUNT(*)
DESC
LIMIT 100

-- sql file: q12-003.sql
/*+ NestedLoop(t1 s tq1 a1 u1 q1)
 NestedLoop(t1 s tq1 a1 u1)
 NestedLoop(t1 s tq1 a1)
 NestedLoop(t1 s tq1)
 NestedLoop(t1 s)
 SeqScan(t1)
 SeqScan(s)
 IndexScan(tq1)
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
AND (s.site_name in ('drupal','physics'))
AND (t1.name in ('forces','nodes','views'))
AND (q1.favorite_count >= 0)
AND (q1.favorite_count <= 10000)
AND (u1.upvotes >= 10)
AND (u1.upvotes <= 1000000)
GROUP BY t1.name

-- sql file: q9-008.sql
/*+ HashJoin(a pl so_user account q tq site tag)
 HashJoin(pl so_user account q tq site tag)
 HashJoin(so_user account q tq site tag)
 HashJoin(q tq site tag)
 HashJoin(tq site tag)
 HashJoin(tq site)
 HashJoin(so_user account)
 IndexOnlyScan(a)
 SeqScan(pl)
 SeqScan(so_user)
 SeqScan(account)
 SeqScan(q)
 SeqScan(tq)
 SeqScan(site)
 SeqScan(tag)
 Leading((a (pl ((so_user account) (q ((tq site) tag)))))) */
select count(distinct account.id) from
account, site, so_user, question q, post_link pl, tag, tag_question tq where
not exists (select * from answer a where a.site_id = q.site_id and a.question_id = q.id) and
site.site_name = 'stackoverflow' and
site.site_id = q.site_id and
pl.site_id = q.site_id and
pl.post_id_to = q.id and

tag.name = 'tensorflow' and
tag.site_id = q.site_id and

q.creation_date > '2018-01-01'::date and

tq.site_id = tag.site_id and
tq.tag_id = tag.id and
tq.question_id = q.id and

q.owner_user_id = so_user.id and
q.site_id = so_user.site_id and
so_user.reputation > 113 and

account.id = so_user.account_id and
account.website_url != '';

-- sql file: q15-005.sql
/*+ NestedLoop(t1 s tq1 q1 u1 b1 acc)
 NestedLoop(t1 s tq1 q1 u1 b1)
 NestedLoop(t1 s tq1 q1 u1)
 NestedLoop(t1 s tq1 q1)
 NestedLoop(t1 s tq1)
 NestedLoop(t1 s)
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
AND (s.site_name in ('stackoverflow','superuser'))
AND (t1.name in ('corpus','httplistener','modx-revolution'))
AND (acc.website_url ILIKE ('%'))
GROUP BY b1.name
ORDER BY COUNT(*)
DESC
LIMIT 100

-- sql file: q13-002.sql
/*+ NestedLoop(t1 s tq1 a1 u1 acc q1 b)
 NestedLoop(t1 s tq1 a1 u1 acc q1)
 NestedLoop(t1 s tq1 a1 u1 acc)
 NestedLoop(t1 s tq1 a1 u1)
 NestedLoop(t1 s tq1 a1)
 NestedLoop(t1 s tq1)
 NestedLoop(t1 s)
 SeqScan(t1)
 IndexScan(s)
 IndexOnlyScan(tq1)
 IndexScan(a1)
 IndexScan(u1)
 IndexScan(acc)
 IndexScan(q1)
 IndexOnlyScan(b)
 Leading((((((((t1 s) tq1) a1) u1) acc) q1) b)) */
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
AND (s.site_name in ('stats'))
AND (t1.name in ('model-selection','optimization','p-value','poisson-distribution'))
AND (q1.view_count >= 100)
AND (q1.view_count <= 100000)
AND (u1.downvotes >= 10)
AND (u1.downvotes <= 100000)
AND (b.name in ('Announcer','Custodian','Necromancer','Nice Question'))
GROUP BY acc.location
ORDER BY COUNT(*)
DESC
LIMIT 100

-- sql file: q15-004.sql
/*+ NestedLoop(t1 s tq1 q1 u1 b1 acc)
 NestedLoop(t1 s tq1 q1 u1 b1)
 NestedLoop(t1 s tq1 q1 u1)
 NestedLoop(t1 s tq1 q1)
 NestedLoop(t1 s tq1)
 HashJoin(t1 s)
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
AND (q1.view_count >= 10)
AND (q1.view_count <= 1000)
AND (s.site_name in ('apple','ru','stats'))
AND (t1.name in ('1с','categorical-encoding','estimators','filter','ftp','iframe','kohana','kolmogorov-smirnov','marginal','path','websocket','криптография','шаблоны-проектирования'))
AND (acc.website_url ILIKE ('%'))
GROUP BY b1.name
ORDER BY COUNT(*)
DESC
LIMIT 100

-- sql file: q14-005.sql
/*+ NestedLoop(s t1 tq1 a1 u1 q1 b acc)
 NestedLoop(s t1 tq1 a1 u1 q1 b)
 NestedLoop(s t1 tq1 a1 u1 q1)
 NestedLoop(s t1 tq1 a1 u1)
 NestedLoop(s t1 tq1 a1)
 NestedLoop(s t1 tq1)
 NestedLoop(s t1)
 IndexScan(s)
 IndexScan(t1)
 IndexOnlyScan(tq1)
 IndexScan(a1)
 IndexScan(u1)
 IndexScan(q1)
 IndexOnlyScan(b)
 IndexOnlyScan(acc)
 Leading((((((((s t1) tq1) a1) u1) q1) b) acc)) */
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
AND (s.site_name in ('mathoverflow','ru'))
AND (t1.name in ('homotopy-theory','функции'))
AND (q1.view_count >= 10)
AND (q1.view_count <= 1000)
AND (u1.reputation >= 0)
AND (u1.reputation <= 100)
AND (b.name in ('Autobiographer','Scholar','Student'))

-- sql file: q14-002.sql
/*+ NestedLoop(t1 s tq1 a1 u1 q1 b acc)
 NestedLoop(t1 s tq1 a1 u1 q1 b)
 NestedLoop(t1 s tq1 a1 u1 q1)
 NestedLoop(t1 s tq1 a1 u1)
 NestedLoop(t1 s tq1 a1)
 NestedLoop(t1 s tq1)
 HashJoin(t1 s)
 SeqScan(t1)
 SeqScan(s)
 IndexScan(tq1)
 IndexScan(a1)
 IndexScan(u1)
 IndexScan(q1)
 IndexScan(b)
 IndexScan(acc)
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
AND (t1.name in ('bash','boot','command-line','google-chrome','laptop','microsoft-excel-2010','microsoft-word','partitioning','router','windows-8'))
AND (q1.view_count >= 0)
AND (q1.view_count <= 100)
AND (u1.downvotes >= 0)
AND (u1.downvotes <= 1)
AND (b.name ILIKE '%su%')

-- sql file: q16-003.sql
/*+ NestedLoop(t1 s tq1 q1 u1 b1 acc)
 NestedLoop(t1 s tq1 q1 u1 b1)
 NestedLoop(t1 s tq1 q1 u1)
 NestedLoop(t1 s tq1 q1)
 NestedLoop(t1 s tq1)
 HashJoin(t1 s)
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
AND (q1.favorite_count >= 0)
AND (q1.favorite_count <= 1)
AND s.site_name = 'stackoverflow'
AND (t1.name in ('avaudiosession','bayesian','eclipse-cdt','es6-modules','functor','guzzle','has-and-belongs-to-many','keychain','nib','nsurlrequest','qa','simple-form'))
AND (acc.website_url ILIKE ('%de'))

-- sql file: q9-005.sql
/*+ HashJoin(a pl account so_user q tq site tag)
 HashJoin(pl account so_user q tq site tag)
 HashJoin(account so_user q tq site tag)
 HashJoin(so_user q tq site tag)
 HashJoin(q tq site tag)
 HashJoin(tq site tag)
 HashJoin(tq site)
 SeqScan(a)
 SeqScan(pl)
 SeqScan(account)
 SeqScan(so_user)
 SeqScan(q)
 SeqScan(tq)
 SeqScan(site)
 SeqScan(tag)
 Leading((a (pl (account (so_user (q ((tq site) tag))))))) */
select count(distinct account.id) from
account, site, so_user, question q, post_link pl, tag, tag_question tq where
not exists (select * from answer a where a.site_id = q.site_id and a.question_id = q.id) and
site.site_name = 'stackoverflow' and
site.site_id = q.site_id and
pl.site_id = q.site_id and
pl.post_id_to = q.id and

tag.name = 'opencv' and
tag.site_id = q.site_id and

q.creation_date > '2016-01-01'::date and

tq.site_id = tag.site_id and
tq.tag_id = tag.id and
tq.question_id = q.id and

q.owner_user_id = so_user.id and
q.site_id = so_user.site_id and
so_user.reputation > 124 and

account.id = so_user.account_id and
account.website_url != '';

-- sql file: q11-004.sql
/*+ NestedLoop(t s tq q)
 NestedLoop(t s tq)
 NestedLoop(t s)
 SeqScan(t)
 IndexScan(s)
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
AND (t.name in ('browser','data-binding','json','unix'))
AND (q.favorite_count >= 1)
AND (q.favorite_count <= 10)

-- sql file: q14-001.sql
/*+ NestedLoop(t1 s tq1 a1 u1 q1 b acc)
 NestedLoop(t1 s tq1 a1 u1 q1 b)
 NestedLoop(t1 s tq1 a1 u1 q1)
 NestedLoop(t1 s tq1 a1 u1)
 NestedLoop(t1 s tq1 a1)
 NestedLoop(t1 s tq1)
 HashJoin(t1 s)
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
AND (s.site_name in ('stackoverflow','superuser'))
AND (t1.name in ('android-asynctask','asp.net-mvc-4','css3','entity-framework-4','inner-join','jquery','sublimetext3'))
AND (q1.view_count >= 10)
AND (q1.view_count <= 1000)
AND (u1.downvotes >= 0)
AND (u1.downvotes <= 10)
AND (b.name in ('Analytical','Beta','Deputy','Fanatic','Great Question','Not a Robot','Unsung Hero'))

-- sql file: q11-005.sql
/*+ NestedLoop(t s tq q)
 NestedLoop(t s tq)
 HashJoin(t s)
 SeqScan(t)
 SeqScan(s)
 IndexScan(tq)
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
AND (s.site_name in ('cs'))
AND (t.name in ('algorithm-analysis','complexity-theory','computability','data-structures','formal-languages','graphs'))
AND (q.view_count >= 100)
AND (q.view_count <= 100000)

-- sql file: q12-002.sql
/*+ NestedLoop(s t1 tq1 a1 u1 q1)
 NestedLoop(s t1 tq1 a1 u1)
 NestedLoop(s t1 tq1 a1)
 NestedLoop(s t1 tq1)
 NestedLoop(s t1)
 SeqScan(s)
 SeqScan(t1)
 IndexScan(tq1)
 IndexScan(a1)
 IndexScan(u1)
 IndexScan(q1)
 Leading((((((s t1) tq1) a1) u1) q1)) */
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
AND (s.site_name in ('english'))
AND (t1.name in ('meaning'))
AND (q1.view_count >= 0)
AND (q1.view_count <= 100)
AND (u1.reputation >= 10)
AND (u1.reputation <= 100000)
GROUP BY t1.name

-- sql file: q15-001.sql
/*+ NestedLoop(t1 s tq1 q1 u1 b1 acc)
 NestedLoop(t1 s tq1 q1 u1 b1)
 NestedLoop(t1 s tq1 q1 u1)
 NestedLoop(t1 s tq1 q1)
 NestedLoop(t1 s tq1)
 HashJoin(t1 s)
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
AND (q1.favorite_count >= 1)
AND (q1.favorite_count <= 10)
AND (s.site_name in ('askubuntu'))
AND (t1.name in ('14.04','drivers','python','virtualization'))
AND (acc.website_url ILIKE ('%io'))
GROUP BY b1.name
ORDER BY COUNT(*)
DESC
LIMIT 100

-- sql file: q11-002.sql
/*+ NestedLoop(s t tq q)
 NestedLoop(s t tq)
 NestedLoop(s t)
 IndexScan(s)
 IndexScan(t)
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
AND (s.site_name in ('softwareengineering'))
AND (t.name in ('architecture','design','design-patterns'))
AND (q.score >= 0)
AND (q.score <= 5)

-- sql file: q12-001.sql
/*+ NestedLoop(t1 s tq1 a1 q1 u1)
 NestedLoop(t1 s tq1 a1 q1)
 NestedLoop(t1 s tq1 a1)
 NestedLoop(t1 s tq1)
 NestedLoop(t1 s)
 SeqScan(t1)
 IndexScan(s)
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
AND (s.site_name in ('android','gamedev','judaism','sharepoint'))
AND (t1.name in ('java','opengl','powershell','sharepoint-enterprise','sharepoint-foundation','sharepoint-online','sources-mekorot','web-part','xna'))
AND (q1.view_count >= 10)
AND (q1.view_count <= 1000)
AND (u1.reputation >= 10)
AND (u1.reputation <= 100000)
GROUP BY t1.name

-- sql file: q14-003.sql
/*+ NestedLoop(t1 s tq1 a1 u1 q1 b acc)
 NestedLoop(t1 s tq1 a1 u1 q1 b)
 NestedLoop(t1 s tq1 a1 u1 q1)
 NestedLoop(t1 s tq1 a1 u1)
 NestedLoop(t1 s tq1 a1)
 NestedLoop(t1 s tq1)
 HashJoin(t1 s)
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
AND (s.site_name in ('stackoverflow','superuser'))
AND (t1.name in ('aes','bios','build','decorator','foreach','html-table','prototype','tags','ubuntu-16.04'))
AND (q1.view_count >= 100)
AND (q1.view_count <= 100000)
AND (u1.downvotes >= 0)
AND (u1.downvotes <= 10)
AND (b.name in ('Cleanup','Fanatic','Inquisitive','Mortarboard','Tag Editor','Talkative'))

-- sql file: q14-004.sql
/*+ NestedLoop(t1 s tq1 a1 u1 q1 b acc)
 NestedLoop(t1 s tq1 a1 u1 q1 b)
 NestedLoop(t1 s tq1 a1 u1 q1)
 NestedLoop(t1 s tq1 a1 u1)
 NestedLoop(t1 s tq1 a1)
 NestedLoop(t1 s tq1)
 MergeJoin(t1 s)
 SeqScan(t1)
 SeqScan(s)
 IndexScan(tq1)
 IndexScan(a1)
 IndexScan(u1)
 IndexScan(q1)
 IndexScan(b)
 IndexScan(acc)
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
AND (s.site_name in ('askubuntu','math'))
AND (t1.name in ('discrete-mathematics','elementary-number-theory','ordinary-differential-equations','statistics','systems-of-equations','vectors'))
AND (q1.view_count >= 0)
AND (q1.view_count <= 100)
AND (u1.downvotes >= 0)
AND (u1.downvotes <= 1)
AND (b.name ILIKE '%ste%')

-- sql file: q9-006.sql
/*+ HashJoin(a pl so_user account q tq site tag)
 HashJoin(pl so_user account q tq site tag)
 HashJoin(so_user account q tq site tag)
 HashJoin(q tq site tag)
 HashJoin(tq site tag)
 HashJoin(tq site)
 HashJoin(so_user account)
 SeqScan(a)
 SeqScan(pl)
 SeqScan(so_user)
 SeqScan(account)
 SeqScan(q)
 SeqScan(tq)
 SeqScan(site)
 SeqScan(tag)
 Leading((a (pl ((so_user account) (q ((tq site) tag)))))) */
select count(distinct account.id) from
account, site, so_user, question q, post_link pl, tag, tag_question tq where
not exists (select * from answer a where a.site_id = q.site_id and a.question_id = q.id) and
site.site_name = 'stackoverflow' and
site.site_id = q.site_id and
pl.site_id = q.site_id and
pl.post_id_to = q.id and

tag.name = 'unity3d' and
tag.site_id = q.site_id and

q.creation_date > '2016-01-01'::date and

tq.site_id = tag.site_id and
tq.tag_id = tag.id and
tq.question_id = q.id and

q.owner_user_id = so_user.id and
q.site_id = so_user.site_id and
so_user.reputation > 96 and

account.id = so_user.account_id and
account.website_url != '';

-- sql file: q16-004.sql
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
AND (q1.favorite_count >= 0)
AND (q1.favorite_count <= 1)
AND s.site_name = 'stackoverflow'
AND (t1.name in ('excel','google-cloud-storage','javafx-2','listview','mobile-safari','npgsql','out-of-memory','system.reactive','word-wrap','wxpython'))
AND (acc.website_url ILIKE ('%de'))

-- sql file: q13-004.sql
/*+ NestedLoop(t1 s tq1 a1 u1 q1 b acc)
 NestedLoop(t1 s tq1 a1 u1 q1 b)
 NestedLoop(t1 s tq1 a1 u1 q1)
 NestedLoop(t1 s tq1 a1 u1)
 NestedLoop(t1 s tq1 a1)
 NestedLoop(t1 s tq1)
 NestedLoop(t1 s)
 SeqScan(t1)
 IndexScan(s)
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
AND (s.site_name in ('physics','pt','ru','salesforce','serverfault'))
AND (t1.name in ('ajax','banco-de-dados','c#','electromagnetism','electrostatics','jquery','json','laravel','linux','quantum-field-theory','thermodynamics','база-данных','регулярные-выражения'))
AND (q1.view_count >= 0)
AND (q1.view_count <= 100)
AND (u1.reputation >= 10)
AND (u1.reputation <= 100000)
AND (b.name in ('Suffrage','Talkative'))
GROUP BY acc.location
ORDER BY COUNT(*)
DESC
LIMIT 100

-- sql file: q16-002.sql
/*+ NestedLoop(t1 s tq1 q1 u1 b1 acc)
 NestedLoop(t1 s tq1 q1 u1 b1)
 NestedLoop(t1 s tq1 q1 u1)
 NestedLoop(t1 s tq1 q1)
 NestedLoop(t1 s tq1)
 MergeJoin(t1 s)
 SeqScan(t1)
 SeqScan(s)
 IndexScan(tq1)
 IndexScan(q1)
 IndexScan(u1)
 IndexScan(b1)
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
AND (q1.score >= 10)
AND (q1.score <= 1000)
AND s.site_name = 'stackoverflow'
AND (t1.name in ('apple-push-notifications','argparse','automation','charts','clickonce','deprecated','git-merge','lodash','new-operator','project-management'))
AND (acc.website_url ILIKE ('%de'))

-- sql file: q10-002.sql
/*+ NestedLoop(site pl1 pl2 q1 q3 q2 comment comment_1 comment_2)
 NestedLoop(site pl1 pl2 q1 q3 q2 comment comment_1)
 NestedLoop(site pl1 pl2 q1 q3 q2 comment)
 NestedLoop(site pl1 pl2 q1 q3 q2)
 NestedLoop(site pl1 pl2 q1 q3)
 NestedLoop(site pl1 pl2 q1)
 NestedLoop(site pl1 pl2)
 NestedLoop(site pl1)
 IndexScan(site)
 IndexScan(pl1)
 IndexScan(pl2)
 IndexScan(q1)
 IndexScan(q3)
 IndexScan(q2)
 IndexScan(comment)
 IndexScan(comment_1)
 IndexScan(comment_2)
 Leading(((((((((site pl1) pl2) q1) q3) q2) comment) comment_1) comment_2)) */
select count(distinct q1.id) from
site, post_link pl1, post_link pl2, question q1, question q2, question q3 where

site.site_name = 'hinduism' and
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

-- sql file: q10-001.sql
/*+ NestedLoop(site pl1 pl2 q1 q3 q2 comment comment_1 comment_2)
 NestedLoop(site pl1 pl2 q1 q3 q2 comment comment_1)
 NestedLoop(site pl1 pl2 q1 q3 q2 comment)
 NestedLoop(site pl1 pl2 q1 q3 q2)
 NestedLoop(site pl1 pl2 q1 q3)
 NestedLoop(site pl1 pl2 q1)
 NestedLoop(site pl1 pl2)
 NestedLoop(site pl1)
 IndexScan(site)
 IndexOnlyScan(pl1)
 IndexOnlyScan(pl2)
 IndexScan(q1)
 IndexScan(q3)
 IndexOnlyScan(q2)
 IndexOnlyScan(comment)
 IndexOnlyScan(comment_1)
 IndexOnlyScan(comment_2)
 Leading(((((((((site pl1) pl2) q1) q3) q2) comment) comment_1) comment_2)) */
select count(distinct q1.id) from
site, post_link pl1, post_link pl2, question q1, question q2, question q3 where

site.site_name = 'aviation' and
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
