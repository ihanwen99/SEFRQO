-- sql file: q1-002.sql
/*+ NestedLoop(site tag tag_question question)
 NestedLoop(site tag tag_question)
 NestedLoop(site tag)
 IndexScan(site)
 IndexScan(tag)
 IndexScan(tag_question)
 IndexScan(question)
 Leading((((site tag) tag_question) question)) */
select count(*) from tag, site, question, tag_question
where
site.site_name='pm' and
tag.name='delays' and
tag.site_id = site.site_id and
question.site_id = site.site_id and
tag_question.site_id = site.site_id and
tag_question.question_id = question.id and
tag_question.tag_id = tag.id

-- sql file: q2-004.sql
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
-- group theory askers
s1.site_name='stats' and
t1.name  = 'machine-learning' and
t1.site_id = s1.site_id and
q1.site_id = s1.site_id and
tq1.site_id = s1.site_id and
tq1.question_id = q1.id and
tq1.tag_id = t1.id and
q1.owner_user_id = u1.id and
q1.site_id = u1.site_id and

-- D&D askers
s2.site_name='stackoverflow' and
t2.name  = 'heroku' and
t2.site_id = s2.site_id and
q2.site_id = s2.site_id and
tq2.site_id = s2.site_id and
tq2.question_id = q2.id and
tq2.tag_id = t2.id and
q2.owner_user_id = u2.id and
q2.site_id = u2.site_id and

-- intersect
u1.account_id = u2.account_id and
account.id = u1.account_id;

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

-- sql file: q3-005.sql
/*+ NestedLoop(t1 s1 tq1 a1 u1 t2 s2 tq2 q2 u2 q1 account)
 NestedLoop(t1 s1 tq1 a1 u1 t2 s2 tq2 q2 u2 q1)
 HashJoin(t1 s1 tq1 a1 u1 t2 s2 tq2 q2 u2)
 NestedLoop(t2 s2 tq2 q2 u2)
 NestedLoop(t2 s2 tq2 q2)
 NestedLoop(t2 s2 tq2)
 HashJoin(t2 s2)
 NestedLoop(t1 s1 tq1 a1 u1)
 NestedLoop(t1 s1 tq1 a1)
 NestedLoop(t1 s1 tq1)
 HashJoin(t1 s1)
 SeqScan(t1)
 SeqScan(s1)
 IndexScan(tq1)
 IndexScan(a1)
 IndexScan(u1)
 SeqScan(t2)
 SeqScan(s2)
 IndexScan(tq2)
 IndexScan(q2)
 IndexScan(u2)
 IndexScan(q1)
 IndexScan(account)
 Leading((((((((t1 s1) tq1) a1) u1) ((((t2 s2) tq2) q2) u2)) q1) account)) */
select COUNT(distinct account.display_name)
from
tag t1, site s1, question q1, answer a1, tag_question tq1, so_user u1,
tag t2, site s2, question q2, tag_question tq2, so_user u2,
account
where
-- answerers
s1.site_name='stackoverflow' and
t1.name  = 'file-io' and
t1.site_id = s1.site_id and
q1.site_id = s1.site_id and
tq1.site_id = s1.site_id and
tq1.question_id = q1.id and
tq1.tag_id = t1.id and
a1.site_id = q1.site_id and
a1.question_id = q1.id and
a1.owner_user_id = u1.id and
a1.site_id = u1.site_id and

-- askers
s2.site_name='ru' and
t2.name  = 'javascript' and
t2.site_id = s2.site_id and
q2.site_id = s2.site_id and
tq2.site_id = s2.site_id and
tq2.question_id = q2.id and
tq2.tag_id = t2.id and
q2.owner_user_id = u2.id and
q2.site_id = u2.site_id and


-- intersect
u1.account_id = u2.account_id and
account.id = u1.account_id;

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

-- sql file: q6-002.sql
/*+ NestedLoop(s1 t1 tq1 q1 u1 c1 account)
 NestedLoop(s1 t1 tq1 q1 u1 c1)
 NestedLoop(s1 t1 tq1 q1 u1)
 NestedLoop(s1 t1 tq1 q1)
 NestedLoop(s1 t1 tq1)
 NestedLoop(s1 t1)
 IndexScan(s1)
 IndexScan(t1)
 IndexScan(tq1)
 IndexScan(q1)
 IndexScan(u1)
 IndexScan(c1)
 IndexScan(account)
 Leading(((((((s1 t1) tq1) q1) u1) c1) account)) */
select COUNT(distinct account.display_name)
from
tag t1, site s1, question q1, tag_question tq1, so_user u1, comment c1,
account
where
-- underappreciated (high votes, low views) questions with at least one comment
s1.site_name='dba' and
t1.name in ('pgadmin', 'aggregate') and
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

-- to get the display name
account.id = u1.account_id;

-- sql file: q4-004.sql
/*+ NestedLoop(s1 t1 tq1 a1 q1 u1 account)
 NestedLoop(s1 t1 tq1 a1 q1 u1)
 NestedLoop(s1 t1 tq1 a1 q1)
 NestedLoop(s1 t1 tq1 a1)
 NestedLoop(s1 t1 tq1)
 NestedLoop(s1 t1)
 IndexScan(s1)
 IndexScan(t1)
 IndexScan(tq1)
 IndexScan(a1)
 IndexScan(q1)
 IndexScan(u1)
 IndexScan(account)
 Leading(((((((s1 t1) tq1) a1) q1) u1) account)) */
select COUNT(distinct account.display_name)
from
tag t1, site s1, question q1, answer a1, tag_question tq1, so_user u1,
account
where
-- answerers posted at least 1 yr after the question was asked
s1.site_name='chemistry' and
t1.name = 'organic-chemistry' and
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

-- to get the display name
account.id = u1.account_id;

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

-- sql file: q8-005.sql
/*+ NestedLoop(site tag tq1 q1 c1 pl q2 tq2 c2)
 NestedLoop(site tag tq1 q1 c1 pl q2 tq2)
 NestedLoop(site tag tq1 q1 c1 pl q2)
 NestedLoop(site tag tq1 q1 c1 pl)
 NestedLoop(site tag tq1 q1 c1)
 NestedLoop(site tag tq1 q1)
 NestedLoop(site tag tq1)
 NestedLoop(site tag)
 IndexScan(site)
 IndexScan(tag)
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

tag.name in ('ruby-on-rails', 'javascript', 'python-3.x', 'excel') and
tag.id = tq1.tag_id and
tag.site_id = tq1.site_id and
tag.id = tq2.tag_id and
tag.site_id = tq1.site_id and

tag.site_id = pl.site_id and

tq1.site_id = q1.site_id and
tq1.question_id = q1.id and
tq2.site_id = q2.site_id and
tq2.question_id = q2.id;

-- sql file: q7-004.sql
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
b1.name = 'Custodian' and

b2.site_id = so_user.site_id and
b2.user_id = so_user.id and
b2.name = 'Commentator' and
b2.date > b1.date + '11 months'::interval

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

-- sql file: q7-003.sql
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
b1.name = 'API Evangelist' and

b2.site_id = so_user.site_id and
b2.user_id = so_user.id and
b2.name = 'Documentation Pioneer' and
b2.date > b1.date + '7 months'::interval

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

-- sql file: q5-002.sql
/*+ NestedLoop(s1 t1 tq1 q1 u1 c1 account)
 NestedLoop(s1 t1 tq1 q1 u1 c1)
 NestedLoop(s1 t1 tq1 q1 u1)
 NestedLoop(s1 t1 tq1 q1)
 NestedLoop(s1 t1 tq1)
 NestedLoop(s1 t1)
 IndexScan(s1)
 IndexScan(t1)
 IndexScan(tq1)
 IndexScan(q1)
 IndexScan(u1)
 IndexScan(c1)
 IndexScan(account)
 Leading(((((((s1 t1) tq1) q1) u1) c1) account)) */
select COUNT(distinct account.display_name)
from
tag t1, site s1, question q1, tag_question tq1, so_user u1, comment c1,
account
where
-- underappreciated (high votes, low views) questions with at least one comment
s1.site_name='ux' and
t1.name in ('design', 'security', 'user-expectation') and
t1.site_id = s1.site_id and
q1.site_id = s1.site_id and
tq1.site_id = s1.site_id and
tq1.question_id = q1.id and
tq1.tag_id = t1.id and
q1.owner_user_id = u1.id and
q1.site_id = u1.site_id and
q1.score > 11 and
q1.view_count < 1565 and
c1.site_id = q1.site_id and
c1.post_id = q1.id and

-- to get the display name
account.id = u1.account_id;

-- sql file: q4-002.sql
/*+ NestedLoop(s1 t1 tq1 a1 q1 u1 account)
 NestedLoop(s1 t1 tq1 a1 q1 u1)
 NestedLoop(s1 t1 tq1 a1 q1)
 NestedLoop(s1 t1 tq1 a1)
 NestedLoop(s1 t1 tq1)
 NestedLoop(s1 t1)
 IndexScan(s1)
 IndexScan(t1)
 IndexOnlyScan(tq1)
 IndexScan(a1)
 IndexScan(q1)
 IndexScan(u1)
 IndexScan(account)
 Leading(((((((s1 t1) tq1) a1) q1) u1) account)) */
select COUNT(distinct account.display_name)
from
tag t1, site s1, question q1, answer a1, tag_question tq1, so_user u1,
account
where
-- answerers posted at least 1 yr after the question was asked
s1.site_name='math' and
t1.name = 'optimization' and
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

-- to get the display name
account.id = u1.account_id;

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

-- sql file: q8-004.sql
/*+ NestedLoop(site tag tq1 q1 c1 pl q2 tq2 c2)
 NestedLoop(site tag tq1 q1 c1 pl q2 tq2)
 NestedLoop(site tag tq1 q1 c1 pl q2)
 NestedLoop(site tag tq1 q1 c1 pl)
 NestedLoop(site tag tq1 q1 c1)
 NestedLoop(site tag tq1 q1)
 NestedLoop(site tag tq1)
 NestedLoop(site tag)
 IndexScan(site)
 IndexScan(tag)
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

c1.date < c2.date and

tag.name in ('sql-server', 'c#', 'asp.net', 'objective-c') and
tag.id = tq1.tag_id and
tag.site_id = tq1.site_id and
tag.id = tq2.tag_id and
tag.site_id = tq1.site_id and

tag.site_id = pl.site_id and

tq1.site_id = q1.site_id and
tq1.question_id = q1.id and
tq2.site_id = q2.site_id and
tq2.question_id = q2.id;

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

-- sql file: q6-004.sql
/*+ NestedLoop(s1 t1 tq1 q1 u1 c1 account)
 NestedLoop(s1 t1 tq1 q1 u1 c1)
 NestedLoop(s1 t1 tq1 q1 u1)
 NestedLoop(s1 t1 tq1 q1)
 NestedLoop(s1 t1 tq1)
 NestedLoop(s1 t1)
 IndexScan(s1)
 IndexScan(t1)
 IndexScan(tq1)
 IndexScan(q1)
 IndexScan(u1)
 IndexScan(c1)
 IndexScan(account)
 Leading(((((((s1 t1) tq1) q1) u1) c1) account)) */
select COUNT(distinct account.display_name)
from
tag t1, site s1, question q1, tag_question tq1, so_user u1, comment c1,
account
where
-- underappreciated (high votes, low views) questions with at least one comment
s1.site_name='dba' and
t1.name in ('empty-string', 'ssis-2008', 'candidate-key', 'insert', 'performance-tuning') and
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

-- to get the display name
account.id = u1.account_id;

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

-- sql file: q1-003.sql
/*+ NestedLoop(site tag tag_question question)
 NestedLoop(site tag tag_question)
 NestedLoop(site tag)
 IndexScan(site)
 IndexScan(tag)
 IndexOnlyScan(tag_question)
 IndexOnlyScan(question)
 Leading((((site tag) tag_question) question)) */
select count(*) from tag, site, question, tag_question
where
site.site_name='diy' and
tag.name='rivets' and
tag.site_id = site.site_id and
question.site_id = site.site_id and
tag_question.site_id = site.site_id and
tag_question.question_id = question.id and
tag_question.tag_id = tag.id

-- sql file: q4-005.sql
/*+ NestedLoop(s1 t1 tq1 a1 q1 u1 account)
 NestedLoop(s1 t1 tq1 a1 q1 u1)
 NestedLoop(s1 t1 tq1 a1 q1)
 NestedLoop(s1 t1 tq1 a1)
 NestedLoop(s1 t1 tq1)
 NestedLoop(s1 t1)
 IndexScan(s1)
 IndexScan(t1)
 IndexScan(tq1)
 IndexScan(a1)
 IndexScan(q1)
 IndexScan(u1)
 IndexScan(account)
 Leading(((((((s1 t1) tq1) a1) q1) u1) account)) */
select COUNT(distinct account.display_name)
from
tag t1, site s1, question q1, answer a1, tag_question tq1, so_user u1,
account
where
-- answerers posted at least 1 yr after the question was asked
s1.site_name='math' and
t1.name = 'convergence' and
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

-- to get the display name
account.id = u1.account_id;

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

-- sql file: q3-001.sql
/*+ NestedLoop(t1 s1 tq1 a1 u1 t2 s2 tq2 q2 u2 q1 account)
 NestedLoop(t1 s1 tq1 a1 u1 t2 s2 tq2 q2 u2 q1)
 HashJoin(t1 s1 tq1 a1 u1 t2 s2 tq2 q2 u2)
 NestedLoop(t2 s2 tq2 q2 u2)
 NestedLoop(t2 s2 tq2 q2)
 NestedLoop(t2 s2 tq2)
 HashJoin(t2 s2)
 NestedLoop(t1 s1 tq1 a1 u1)
 NestedLoop(t1 s1 tq1 a1)
 NestedLoop(t1 s1 tq1)
 HashJoin(t1 s1)
 SeqScan(t1)
 SeqScan(s1)
 IndexScan(tq1)
 IndexScan(a1)
 IndexScan(u1)
 SeqScan(t2)
 SeqScan(s2)
 IndexScan(tq2)
 IndexScan(q2)
 IndexScan(u2)
 IndexScan(q1)
 IndexScan(account)
 Leading((((((((t1 s1) tq1) a1) u1) ((((t2 s2) tq2) q2) u2)) q1) account)) */
select COUNT(distinct account.display_name)
from
tag t1, site s1, question q1, answer a1, tag_question tq1, so_user u1,
tag t2, site s2, question q2, tag_question tq2, so_user u2,
account
where
-- answerers
s1.site_name='stackoverflow' and
t1.name  = 'authentication' and
t1.site_id = s1.site_id and
q1.site_id = s1.site_id and
tq1.site_id = s1.site_id and
tq1.question_id = q1.id and
tq1.tag_id = t1.id and
a1.site_id = q1.site_id and
a1.question_id = q1.id and
a1.owner_user_id = u1.id and
a1.site_id = u1.site_id and

-- askers
s2.site_name='physics' and
t2.name  = 'quantum-mechanics' and
t2.site_id = s2.site_id and
q2.site_id = s2.site_id and
tq2.site_id = s2.site_id and
tq2.question_id = q2.id and
tq2.tag_id = t2.id and
q2.owner_user_id = u2.id and
q2.site_id = u2.site_id and


-- intersect
u1.account_id = u2.account_id and
account.id = u1.account_id;

-- sql file: q8-003.sql
/*+ NestedLoop(site tag tq1 pl c1 q1 tq2 c2 q2)
 NestedLoop(site tag tq1 pl c1 q1 tq2 c2)
 NestedLoop(site tag tq1 pl c1 q1 tq2)
 NestedLoop(site tag tq1 pl c1 q1)
 NestedLoop(site tag tq1 pl c1)
 NestedLoop(site tag tq1 pl)
 NestedLoop(site tag tq1)
 NestedLoop(site tag)
 IndexScan(site)
 IndexScan(tag)
 IndexScan(tq1)
 IndexScan(pl)
 IndexScan(c1)
 IndexScan(q1)
 IndexScan(tq2)
 IndexScan(c2)
 IndexScan(q2)
 Leading(((((((((site tag) tq1) pl) c1) q1) tq2) c2) q2)) */
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

tag.name in ('python-3.x', 'html') and
tag.id = tq1.tag_id and
tag.site_id = tq1.site_id and
tag.id = tq2.tag_id and
tag.site_id = tq1.site_id and

tag.site_id = pl.site_id and

tq1.site_id = q1.site_id and
tq1.question_id = q1.id and
tq2.site_id = q2.site_id and
tq2.question_id = q2.id;

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

-- sql file: q7-001.sql
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
b1.name = 'Famous Question' and

b2.site_id = so_user.site_id and
b2.user_id = so_user.id and
b2.name = 'Constable' and
b2.date > b1.date + '7 months'::interval

-- sql file: q1-004.sql
/*+ NestedLoop(site tag tag_question question)
 NestedLoop(site tag tag_question)
 NestedLoop(site tag)
 IndexScan(site)
 IndexScan(tag)
 IndexScan(tag_question)
 IndexScan(question)
 Leading((((site tag) tag_question) question)) */
select count(*) from tag, site, question, tag_question
where
site.site_name='softwareengineering' and
tag.name='heatmap' and
tag.site_id = site.site_id and
question.site_id = site.site_id and
tag_question.site_id = site.site_id and
tag_question.question_id = question.id and
tag_question.tag_id = tag.id

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

-- sql file: q5-003.sql
/*+ NestedLoop(s1 t1 tq1 q1 u1 c1 account)
 NestedLoop(s1 t1 tq1 q1 u1 c1)
 NestedLoop(s1 t1 tq1 q1 u1)
 NestedLoop(s1 t1 tq1 q1)
 NestedLoop(s1 t1 tq1)
 NestedLoop(s1 t1)
 IndexScan(s1)
 IndexScan(t1)
 IndexScan(tq1)
 IndexScan(q1)
 IndexScan(u1)
 IndexScan(c1)
 IndexScan(account)
 Leading(((((((s1 t1) tq1) q1) u1) c1) account)) */
select COUNT(distinct account.display_name)
from
tag t1, site s1, question q1, tag_question tq1, so_user u1, comment c1,
account
where
-- underappreciated (high votes, low views) questions with at least one comment
s1.site_name='ux' and
t1.name in ('security', 'hyperlinks') and
t1.site_id = s1.site_id and
q1.site_id = s1.site_id and
tq1.site_id = s1.site_id and
tq1.question_id = q1.id and
tq1.tag_id = t1.id and
q1.owner_user_id = u1.id and
q1.site_id = u1.site_id and
q1.score > 8 and
q1.view_count < 2534 and
c1.site_id = q1.site_id and
c1.post_id = q1.id and

-- to get the display name
account.id = u1.account_id;

-- sql file: q8-002.sql
/*+ NestedLoop(site tag tq1 q1 c1 pl q2 tq2 c2)
 NestedLoop(site tag tq1 q1 c1 pl q2 tq2)
 NestedLoop(site tag tq1 q1 c1 pl q2)
 NestedLoop(site tag tq1 q1 c1 pl)
 NestedLoop(site tag tq1 q1 c1)
 NestedLoop(site tag tq1 q1)
 NestedLoop(site tag tq1)
 NestedLoop(site tag)
 IndexScan(site)
 IndexScan(tag)
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

tag.name in ('angularjs', 'excel') and
tag.id = tq1.tag_id and
tag.site_id = tq1.site_id and
tag.id = tq2.tag_id and
tag.site_id = tq1.site_id and

tag.site_id = pl.site_id and

tq1.site_id = q1.site_id and
tq1.question_id = q1.id and
tq2.site_id = q2.site_id and
tq2.question_id = q2.id;

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

-- sql file: q6-003.sql
/*+ NestedLoop(s1 t1 tq1 q1 u1 c1 account)
 NestedLoop(s1 t1 tq1 q1 u1 c1)
 NestedLoop(s1 t1 tq1 q1 u1)
 NestedLoop(s1 t1 tq1 q1)
 NestedLoop(s1 t1 tq1)
 NestedLoop(s1 t1)
 IndexScan(s1)
 IndexScan(t1)
 IndexScan(tq1)
 IndexScan(q1)
 IndexScan(u1)
 IndexScan(c1)
 IndexScan(account)
 Leading(((((((s1 t1) tq1) q1) u1) c1) account)) */
select COUNT(distinct account.display_name)
from
tag t1, site s1, question q1, tag_question tq1, so_user u1, comment c1,
account
where
-- underappreciated (high votes, low views) questions with at least one comment
s1.site_name='dba' and
t1.name in ('alias', 'case', 'mongodb-3.0', 'downgrade', 'pg-stat-activity') and
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

-- to get the display name
account.id = u1.account_id;

-- sql file: q7-002.sql
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
b1.name = 'Illuminator' and

b2.site_id = so_user.site_id and
b2.user_id = so_user.id and
b2.name = 'Nice Question' and
b2.date > b1.date + '9 months'::interval

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

-- sql file: q6-001.sql
/*+ NestedLoop(s1 t1 tq1 q1 u1 c1 account)
 NestedLoop(s1 t1 tq1 q1 u1 c1)
 NestedLoop(s1 t1 tq1 q1 u1)
 NestedLoop(s1 t1 tq1 q1)
 NestedLoop(s1 t1 tq1)
 NestedLoop(s1 t1)
 IndexScan(s1)
 IndexScan(t1)
 IndexScan(tq1)
 IndexScan(q1)
 IndexScan(u1)
 IndexScan(c1)
 IndexScan(account)
 Leading(((((((s1 t1) tq1) q1) u1) c1) account)) */
select COUNT(distinct account.display_name)
from
tag t1, site s1, question q1, tag_question tq1, so_user u1, comment c1,
account
where
-- underappreciated (high votes, low views) questions with at least one comment
s1.site_name='dba' and
t1.name in ('cloud', 'contained-database') and
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

-- to get the display name
account.id = u1.account_id;

-- sql file: q6-005.sql
/*+ NestedLoop(s1 t1 tq1 q1 u1 c1 account)
 NestedLoop(s1 t1 tq1 q1 u1 c1)
 NestedLoop(s1 t1 tq1 q1 u1)
 NestedLoop(s1 t1 tq1 q1)
 NestedLoop(s1 t1 tq1)
 NestedLoop(s1 t1)
 IndexScan(s1)
 IndexScan(t1)
 IndexScan(tq1)
 IndexScan(q1)
 IndexScan(u1)
 IndexScan(c1)
 IndexScan(account)
 Leading(((((((s1 t1) tq1) q1) u1) c1) account)) */
select COUNT(distinct account.display_name)
from
tag t1, site s1, question q1, tag_question tq1, so_user u1, comment c1,
account
where
-- underappreciated (high votes, low views) questions with at least one comment
s1.site_name='avp' and
t1.name in ('editing', 'footage', 'nikon', 'cc-2017') and
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

-- to get the display name
account.id = u1.account_id;

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

-- sql file: q5-004.sql
/*+ NestedLoop(s1 t1 tq1 q1 u1 c1 account)
 NestedLoop(s1 t1 tq1 q1 u1 c1)
 NestedLoop(s1 t1 tq1 q1 u1)
 NestedLoop(s1 t1 tq1 q1)
 NestedLoop(s1 t1 tq1)
 NestedLoop(s1 t1)
 IndexScan(s1)
 IndexScan(t1)
 IndexScan(tq1)
 IndexScan(q1)
 IndexScan(u1)
 IndexScan(c1)
 IndexScan(account)
 Leading(((((((s1 t1) tq1) q1) u1) c1) account)) */
select COUNT(distinct account.display_name)
from
tag t1, site s1, question q1, tag_question tq1, so_user u1, comment c1,
account
where
-- underappreciated (high votes, low views) questions with at least one comment
s1.site_name='ux' and
t1.name in ('design-patterns', 'user-centered-design') and
t1.site_id = s1.site_id and
q1.site_id = s1.site_id and
tq1.site_id = s1.site_id and
tq1.question_id = q1.id and
tq1.tag_id = t1.id and
q1.owner_user_id = u1.id and
q1.site_id = u1.site_id and
q1.score > 15 and
q1.view_count < 2936 and
c1.site_id = q1.site_id and
c1.post_id = q1.id and

-- to get the display name
account.id = u1.account_id;

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

-- sql file: q3-004.sql
/*+ NestedLoop(t1 s1 tq1 a1 u1 t2 s2 tq2 q2 u2 q1 account)
 NestedLoop(t1 s1 tq1 a1 u1 t2 s2 tq2 q2 u2 q1)
 HashJoin(t1 s1 tq1 a1 u1 t2 s2 tq2 q2 u2)
 NestedLoop(t2 s2 tq2 q2 u2)
 NestedLoop(t2 s2 tq2 q2)
 NestedLoop(t2 s2 tq2)
 HashJoin(t2 s2)
 NestedLoop(t1 s1 tq1 a1 u1)
 NestedLoop(t1 s1 tq1 a1)
 NestedLoop(t1 s1 tq1)
 HashJoin(t1 s1)
 SeqScan(t1)
 SeqScan(s1)
 IndexScan(tq1)
 IndexScan(a1)
 IndexScan(u1)
 SeqScan(t2)
 SeqScan(s2)
 IndexScan(tq2)
 IndexScan(q2)
 IndexScan(u2)
 IndexScan(q1)
 IndexScan(account)
 Leading((((((((t1 s1) tq1) a1) u1) ((((t2 s2) tq2) q2) u2)) q1) account)) */
select COUNT(distinct account.display_name)
from
tag t1, site s1, question q1, answer a1, tag_question tq1, so_user u1,
tag t2, site s2, question q2, tag_question tq2, so_user u2,
account
where
-- answerers
s1.site_name='stackoverflow' and
t1.name  = 'audio' and
t1.site_id = s1.site_id and
q1.site_id = s1.site_id and
tq1.site_id = s1.site_id and
tq1.question_id = q1.id and
tq1.tag_id = t1.id and
a1.site_id = q1.site_id and
a1.question_id = q1.id and
a1.owner_user_id = u1.id and
a1.site_id = u1.site_id and

-- askers
s2.site_name='superuser' and
t2.name  = 'networking' and
t2.site_id = s2.site_id and
q2.site_id = s2.site_id and
tq2.site_id = s2.site_id and
tq2.question_id = q2.id and
tq2.tag_id = t2.id and
q2.owner_user_id = u2.id and
q2.site_id = u2.site_id and


-- intersect
u1.account_id = u2.account_id and
account.id = u1.account_id;

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

-- sql file: q7-005.sql
/*+ NestedLoop(b1 b2 so_user account)
 NestedLoop(b1 b2 so_user)
 NestedLoop(b1 b2)
 SeqScan(b1)
 IndexScan(b2)
 IndexScan(so_user)
 IndexScan(account)
 Leading((((b1 b2) so_user) account)) */
select count(distinct account.display_name) from account, so_user, badge b1, badge b2 where
account.website_url != '' and
account.id = so_user.account_id and

b1.site_id = so_user.site_id and
b1.user_id = so_user.id and
b1.name = 'Constable' and

b2.site_id = so_user.site_id and
b2.user_id = so_user.id and
b2.name = 'API Evangelist' and
b2.date > b1.date + '10 months'::interval

-- sql file: q2-002.sql
/*+ NestedLoop(t1 s1 tq1 q1 u1 t2 s2 tq2 q2 u2 account)
 HashJoin(t1 s1 tq1 q1 u1 t2 s2 tq2 q2 u2)
 NestedLoop(t2 s2 tq2 q2 u2)
 NestedLoop(t2 s2 tq2 q2)
 NestedLoop(t2 s2 tq2)
 HashJoin(t2 s2)
 NestedLoop(t1 s1 tq1 q1 u1)
 NestedLoop(t1 s1 tq1 q1)
 NestedLoop(t1 s1 tq1)
 HashJoin(t1 s1)
 SeqScan(t1)
 SeqScan(s1)
 IndexScan(tq1)
 IndexScan(q1)
 IndexScan(u1)
 SeqScan(t2)
 SeqScan(s2)
 IndexScan(tq2)
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
-- group theory askers
s1.site_name='stackoverflow' and
t1.name  = 'web-scraping' and
t1.site_id = s1.site_id and
q1.site_id = s1.site_id and
tq1.site_id = s1.site_id and
tq1.question_id = q1.id and
tq1.tag_id = t1.id and
q1.owner_user_id = u1.id and
q1.site_id = u1.site_id and

-- D&D askers
s2.site_name='superuser' and
t2.name  = 'microsoft-excel' and
t2.site_id = s2.site_id and
q2.site_id = s2.site_id and
tq2.site_id = s2.site_id and
tq2.question_id = q2.id and
tq2.tag_id = t2.id and
q2.owner_user_id = u2.id and
q2.site_id = u2.site_id and

-- intersect
u1.account_id = u2.account_id and
account.id = u1.account_id;

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

-- sql file: q2-001.sql
/*+ NestedLoop(t1 s1 tq1 q1 u1 t2 s2 tq2 q2 u2 account)
 HashJoin(t1 s1 tq1 q1 u1 t2 s2 tq2 q2 u2)
 NestedLoop(t2 s2 tq2 q2 u2)
 NestedLoop(t2 s2 tq2 q2)
 NestedLoop(t2 s2 tq2)
 HashJoin(t2 s2)
 NestedLoop(t1 s1 tq1 q1 u1)
 NestedLoop(t1 s1 tq1 q1)
 NestedLoop(t1 s1 tq1)
 HashJoin(t1 s1)
 SeqScan(t1)
 SeqScan(s1)
 IndexScan(tq1)
 IndexScan(q1)
 IndexScan(u1)
 SeqScan(t2)
 SeqScan(s2)
 IndexScan(tq2)
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
-- group theory askers
s1.site_name='math' and
t1.name  = 'vector-spaces' and
t1.site_id = s1.site_id and
q1.site_id = s1.site_id and
tq1.site_id = s1.site_id and
tq1.question_id = q1.id and
tq1.tag_id = t1.id and
q1.owner_user_id = u1.id and
q1.site_id = u1.site_id and

-- D&D askers
s2.site_name='stackoverflow' and
t2.name  = 'jsf' and
t2.site_id = s2.site_id and
q2.site_id = s2.site_id and
tq2.site_id = s2.site_id and
tq2.question_id = q2.id and
tq2.tag_id = t2.id and
q2.owner_user_id = u2.id and
q2.site_id = u2.site_id and

-- intersect
u1.account_id = u2.account_id and
account.id = u1.account_id;

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

-- sql file: q1-005.sql
/*+ NestedLoop(site tag tag_question question)
 NestedLoop(site tag tag_question)
 NestedLoop(site tag)
 IndexScan(site)
 IndexScan(tag)
 IndexOnlyScan(tag_question)
 IndexOnlyScan(question)
 Leading((((site tag) tag_question) question)) */
select count(*) from tag, site, question, tag_question
where
site.site_name='sharepoint' and
tag.name='olap' and
tag.site_id = site.site_id and
question.site_id = site.site_id and
tag_question.site_id = site.site_id and
tag_question.question_id = question.id and
tag_question.tag_id = tag.id

-- sql file: q4-003.sql
/*+ NestedLoop(s1 t1 tq1 a1 q1 u1 account)
 NestedLoop(s1 t1 tq1 a1 q1 u1)
 NestedLoop(s1 t1 tq1 a1 q1)
 NestedLoop(s1 t1 tq1 a1)
 NestedLoop(s1 t1 tq1)
 NestedLoop(s1 t1)
 IndexScan(s1)
 IndexScan(t1)
 IndexOnlyScan(tq1)
 IndexScan(a1)
 IndexScan(q1)
 IndexScan(u1)
 IndexScan(account)
 Leading(((((((s1 t1) tq1) a1) q1) u1) account)) */
select COUNT(distinct account.display_name)
from
tag t1, site s1, question q1, answer a1, tag_question tq1, so_user u1,
account
where
-- answerers posted at least 1 yr after the question was asked
s1.site_name='superuser' and
t1.name = 'command-line' and
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

-- to get the display name
account.id = u1.account_id;

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

-- sql file: q3-002.sql
/*+ NestedLoop(t1 s1 tq1 a1 u1 t2 s2 tq2 q2 u2 q1 account)
 NestedLoop(t1 s1 tq1 a1 u1 t2 s2 tq2 q2 u2 q1)
 HashJoin(t1 s1 tq1 a1 u1 t2 s2 tq2 q2 u2)
 NestedLoop(t2 s2 tq2 q2 u2)
 NestedLoop(t2 s2 tq2 q2)
 NestedLoop(t2 s2 tq2)
 HashJoin(t2 s2)
 NestedLoop(t1 s1 tq1 a1 u1)
 NestedLoop(t1 s1 tq1 a1)
 NestedLoop(t1 s1 tq1)
 HashJoin(t1 s1)
 SeqScan(t1)
 SeqScan(s1)
 IndexScan(tq1)
 IndexScan(a1)
 IndexScan(u1)
 SeqScan(t2)
 SeqScan(s2)
 IndexScan(tq2)
 IndexScan(q2)
 IndexScan(u2)
 IndexScan(q1)
 IndexScan(account)
 Leading((((((((t1 s1) tq1) a1) u1) ((((t2 s2) tq2) q2) u2)) q1) account)) */
select COUNT(distinct account.display_name)
from
tag t1, site s1, question q1, answer a1, tag_question tq1, so_user u1,
tag t2, site s2, question q2, tag_question tq2, so_user u2,
account
where
-- answerers
s1.site_name='stackoverflow' and
t1.name  = 'split' and
t1.site_id = s1.site_id and
q1.site_id = s1.site_id and
tq1.site_id = s1.site_id and
tq1.question_id = q1.id and
tq1.tag_id = t1.id and
a1.site_id = q1.site_id and
a1.question_id = q1.id and
a1.owner_user_id = u1.id and
a1.site_id = u1.site_id and

-- askers
s2.site_name='math' and
t2.name  = 'geometry' and
t2.site_id = s2.site_id and
q2.site_id = s2.site_id and
tq2.site_id = s2.site_id and
tq2.question_id = q2.id and
tq2.tag_id = t2.id and
q2.owner_user_id = u2.id and
q2.site_id = u2.site_id and


-- intersect
u1.account_id = u2.account_id and
account.id = u1.account_id;

-- sql file: q5-001.sql
/*+ NestedLoop(s1 t1 tq1 q1 u1 c1 account)
 NestedLoop(s1 t1 tq1 q1 u1 c1)
 NestedLoop(s1 t1 tq1 q1 u1)
 NestedLoop(s1 t1 tq1 q1)
 NestedLoop(s1 t1 tq1)
 NestedLoop(s1 t1)
 IndexScan(s1)
 IndexScan(t1)
 IndexScan(tq1)
 IndexScan(q1)
 IndexScan(u1)
 IndexScan(c1)
 IndexScan(account)
 Leading(((((((s1 t1) tq1) q1) u1) c1) account)) */
select COUNT(distinct account.display_name)
from
tag t1, site s1, question q1, tag_question tq1, so_user u1, comment c1,
account
where
-- underappreciated (high votes, low views) questions with at least one comment
s1.site_name='ux' and
t1.name in ('readability', 'desktop-application', 'touch-screen') and
t1.site_id = s1.site_id and
q1.site_id = s1.site_id and
tq1.site_id = s1.site_id and
tq1.question_id = q1.id and
tq1.tag_id = t1.id and
q1.owner_user_id = u1.id and
q1.site_id = u1.site_id and
q1.score > 8 and
q1.view_count < 1785 and
c1.site_id = q1.site_id and
c1.post_id = q1.id and

-- to get the display name
account.id = u1.account_id;

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

-- sql file: q1-001.sql
/*+ NestedLoop(site tag tag_question question)
 NestedLoop(site tag tag_question)
 NestedLoop(site tag)
 IndexScan(site)
 IndexScan(tag)
 IndexOnlyScan(tag_question)
 IndexOnlyScan(question)
 Leading((((site tag) tag_question) question)) */
select count(*) from tag, site, question, tag_question
where
site.site_name='scifi' and
tag.name='steins-gate' and
tag.site_id = site.site_id and
question.site_id = site.site_id and
tag_question.site_id = site.site_id and
tag_question.question_id = question.id and
tag_question.tag_id = tag.id

-- sql file: q8-001.sql
/*+ NestedLoop(site tag tq1 q1 c1 pl q2 tq2 c2)
 NestedLoop(site tag tq1 q1 c1 pl q2 tq2)
 NestedLoop(site tag tq1 q1 c1 pl q2)
 NestedLoop(site tag tq1 q1 c1 pl)
 NestedLoop(site tag tq1 q1 c1)
 NestedLoop(site tag tq1 q1)
 NestedLoop(site tag tq1)
 NestedLoop(site tag)
 IndexScan(site)
 IndexScan(tag)
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

c1.date < c2.date and

tag.name in ('jquery', 'android', 'excel', 'iphone', 'sql-server') and
tag.id = tq1.tag_id and
tag.site_id = tq1.site_id and
tag.id = tq2.tag_id and
tag.site_id = tq1.site_id and

tag.site_id = pl.site_id and

tq1.site_id = q1.site_id and
tq1.question_id = q1.id and
tq2.site_id = q2.site_id and
tq2.question_id = q2.id;

-- sql file: q5-005.sql
/*+ NestedLoop(t1 s1 tq1 q1 u1 c1 account)
 NestedLoop(t1 s1 tq1 q1 u1 c1)
 NestedLoop(t1 s1 tq1 q1 u1)
 NestedLoop(t1 s1 tq1 q1)
 NestedLoop(t1 s1 tq1)
 NestedLoop(t1 s1)
 SeqScan(t1)
 IndexScan(s1)
 IndexScan(tq1)
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
-- underappreciated (high votes, low views) questions with at least one comment
s1.site_name='drupal' and
t1.name in ('emails', 'composer', 'drush', 'theming', 'tokens', 'distributions', 'rating', 'navigation', 'path-aliases', 'entities') and
t1.site_id = s1.site_id and
q1.site_id = s1.site_id and
tq1.site_id = s1.site_id and
tq1.question_id = q1.id and
tq1.tag_id = t1.id and
q1.owner_user_id = u1.id and
q1.site_id = u1.site_id and
q1.score > 7 and
q1.view_count < 1940 and
c1.site_id = q1.site_id and
c1.post_id = q1.id and

-- to get the display name
account.id = u1.account_id;

-- sql file: q2-003.sql
/*+ NestedLoop(t1 s1 tq1 q1 u1 t2 s2 tq2 q2 u2 account)
 HashJoin(t1 s1 tq1 q1 u1 t2 s2 tq2 q2 u2)
 NestedLoop(t2 s2 tq2 q2 u2)
 NestedLoop(t2 s2 tq2 q2)
 NestedLoop(t2 s2 tq2)
 HashJoin(t2 s2)
 NestedLoop(t1 s1 tq1 q1 u1)
 NestedLoop(t1 s1 tq1 q1)
 NestedLoop(t1 s1 tq1)
 HashJoin(t1 s1)
 SeqScan(t1)
 SeqScan(s1)
 IndexScan(tq1)
 IndexScan(q1)
 IndexScan(u1)
 SeqScan(t2)
 SeqScan(s2)
 IndexScan(tq2)
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
-- group theory askers
s1.site_name='drupal' and
t1.name  = 'theming' and
t1.site_id = s1.site_id and
q1.site_id = s1.site_id and
tq1.site_id = s1.site_id and
tq1.question_id = q1.id and
tq1.tag_id = t1.id and
q1.owner_user_id = u1.id and
q1.site_id = u1.site_id and

-- D&D askers
s2.site_name='ru' and
t2.name  = 'php' and
t2.site_id = s2.site_id and
q2.site_id = s2.site_id and
tq2.site_id = s2.site_id and
tq2.question_id = q2.id and
tq2.tag_id = t2.id and
q2.owner_user_id = u2.id and
q2.site_id = u2.site_id and

-- intersect
u1.account_id = u2.account_id and
account.id = u1.account_id;

-- sql file: q3-003.sql
/*+ NestedLoop(t1 s1 tq1 a1 u1 t2 s2 tq2 q2 u2 q1 account)
 NestedLoop(t1 s1 tq1 a1 u1 t2 s2 tq2 q2 u2 q1)
 HashJoin(t1 s1 tq1 a1 u1 t2 s2 tq2 q2 u2)
 NestedLoop(t2 s2 tq2 q2 u2)
 NestedLoop(t2 s2 tq2 q2)
 NestedLoop(t2 s2 tq2)
 MergeJoin(t2 s2)
 NestedLoop(t1 s1 tq1 a1 u1)
 NestedLoop(t1 s1 tq1 a1)
 NestedLoop(t1 s1 tq1)
 MergeJoin(t1 s1)
 SeqScan(t1)
 SeqScan(s1)
 IndexScan(tq1)
 IndexScan(a1)
 IndexScan(u1)
 SeqScan(t2)
 SeqScan(s2)
 IndexScan(tq2)
 IndexScan(q2)
 IndexScan(u2)
 IndexScan(q1)
 IndexScan(account)
 Leading((((((((t1 s1) tq1) a1) u1) ((((t2 s2) tq2) q2) u2)) q1) account)) */
select COUNT(distinct account.display_name)
from
tag t1, site s1, question q1, answer a1, tag_question tq1, so_user u1,
tag t2, site s2, question q2, tag_question tq2, so_user u2,
account
where
-- answerers
s1.site_name='stackoverflow' and
t1.name  = 'matrix' and
t1.site_id = s1.site_id and
q1.site_id = s1.site_id and
tq1.site_id = s1.site_id and
tq1.question_id = q1.id and
tq1.tag_id = t1.id and
a1.site_id = q1.site_id and
a1.question_id = q1.id and
a1.owner_user_id = u1.id and
a1.site_id = u1.site_id and

-- askers
s2.site_name='math' and
t2.name  = 'polynomials' and
t2.site_id = s2.site_id and
q2.site_id = s2.site_id and
tq2.site_id = s2.site_id and
tq2.question_id = q2.id and
tq2.tag_id = t2.id and
q2.owner_user_id = u2.id and
q2.site_id = u2.site_id and


-- intersect
u1.account_id = u2.account_id and
account.id = u1.account_id;

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

-- sql file: q2-005.sql
/*+ NestedLoop(t1 s1 tq1 q1 u1 t2 s2 tq2 q2 u2 account)
 HashJoin(t1 s1 tq1 q1 u1 t2 s2 tq2 q2 u2)
 NestedLoop(t2 s2 tq2 q2 u2)
 NestedLoop(t2 s2 tq2 q2)
 NestedLoop(t2 s2 tq2)
 HashJoin(t2 s2)
 NestedLoop(t1 s1 tq1 q1 u1)
 NestedLoop(t1 s1 tq1 q1)
 NestedLoop(t1 s1 tq1)
 HashJoin(t1 s1)
 SeqScan(t1)
 SeqScan(s1)
 IndexScan(tq1)
 IndexScan(q1)
 IndexScan(u1)
 SeqScan(t2)
 SeqScan(s2)
 IndexScan(tq2)
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
-- group theory askers
s1.site_name='stackoverflow' and
t1.name  = 'forms' and
t1.site_id = s1.site_id and
q1.site_id = s1.site_id and
tq1.site_id = s1.site_id and
tq1.question_id = q1.id and
tq1.tag_id = t1.id and
q1.owner_user_id = u1.id and
q1.site_id = u1.site_id and

-- D&D askers
s2.site_name='english' and
t2.name  = 'single-word-requests' and
t2.site_id = s2.site_id and
q2.site_id = s2.site_id and
tq2.site_id = s2.site_id and
tq2.question_id = q2.id and
tq2.tag_id = t2.id and
q2.owner_user_id = u2.id and
q2.site_id = u2.site_id and

-- intersect
u1.account_id = u2.account_id and
account.id = u1.account_id;

-- sql file: q4-001.sql
/*+ NestedLoop(s1 t1 tq1 a1 q1 u1 account)
 NestedLoop(s1 t1 tq1 a1 q1 u1)
 NestedLoop(s1 t1 tq1 a1 q1)
 NestedLoop(s1 t1 tq1 a1)
 NestedLoop(s1 t1 tq1)
 NestedLoop(s1 t1)
 IndexScan(s1)
 IndexScan(t1)
 IndexScan(tq1)
 IndexScan(a1)
 IndexScan(q1)
 IndexScan(u1)
 IndexScan(account)
 Leading(((((((s1 t1) tq1) a1) q1) u1) account)) */
select COUNT(distinct account.display_name)
from
tag t1, site s1, question q1, answer a1, tag_question tq1, so_user u1,
account
where
-- answerers posted at least 1 yr after the question was asked
s1.site_name='physics' and
t1.name = 'homework-and-exercises' and
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

-- to get the display name
account.id = u1.account_id;

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

