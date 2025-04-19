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
s1.site_name='stats' and
t1.name  = 'machine-learning' and
t1.site_id = s1.site_id and
q1.site_id = s1.site_id and
tq1.site_id = s1.site_id and
tq1.question_id = q1.id and
tq1.tag_id = t1.id and
q1.owner_user_id = u1.id and
q1.site_id = u1.site_id and
s2.site_name='stackoverflow' and
t2.name  = 'heroku' and
t2.site_id = s2.site_id and
q2.site_id = s2.site_id and
tq2.site_id = s2.site_id and
tq2.question_id = q2.id and
tq2.tag_id = t2.id and
q2.owner_user_id = u2.id and
q2.site_id = u2.site_id and
u1.account_id = u2.account_id and
account.id = u1.account_id;


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
s2.site_name='ru' and
t2.name  = 'javascript' and
t2.site_id = s2.site_id and
q2.site_id = s2.site_id and
tq2.site_id = s2.site_id and
tq2.question_id = q2.id and
tq2.tag_id = t2.id and
q2.owner_user_id = u2.id and
q2.site_id = u2.site_id and
u1.account_id = u2.account_id and
account.id = u1.account_id;


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
account.id = u1.account_id;


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
account.id = u1.account_id;


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
account.id = u1.account_id;


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
account.id = u1.account_id;


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
account.id = u1.account_id;


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
account.id = u1.account_id;


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
s2.site_name='physics' and
t2.name  = 'quantum-mechanics' and
t2.site_id = s2.site_id and
q2.site_id = s2.site_id and
tq2.site_id = s2.site_id and
tq2.question_id = q2.id and
tq2.tag_id = t2.id and
q2.owner_user_id = u2.id and
q2.site_id = u2.site_id and
u1.account_id = u2.account_id and
account.id = u1.account_id;


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
account.id = u1.account_id;


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
account.id = u1.account_id;


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
account.id = u1.account_id;


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
account.id = u1.account_id;


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
account.id = u1.account_id;


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
s2.site_name='superuser' and
t2.name  = 'networking' and
t2.site_id = s2.site_id and
q2.site_id = s2.site_id and
tq2.site_id = s2.site_id and
tq2.question_id = q2.id and
tq2.tag_id = t2.id and
q2.owner_user_id = u2.id and
q2.site_id = u2.site_id and
u1.account_id = u2.account_id and
account.id = u1.account_id;


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
s1.site_name='stackoverflow' and
t1.name  = 'web-scraping' and
t1.site_id = s1.site_id and
q1.site_id = s1.site_id and
tq1.site_id = s1.site_id and
tq1.question_id = q1.id and
tq1.tag_id = t1.id and
q1.owner_user_id = u1.id and
q1.site_id = u1.site_id and
s2.site_name='superuser' and
t2.name  = 'microsoft-excel' and
t2.site_id = s2.site_id and
q2.site_id = s2.site_id and
tq2.site_id = s2.site_id and
tq2.question_id = q2.id and
tq2.tag_id = t2.id and
q2.owner_user_id = u2.id and
q2.site_id = u2.site_id and
u1.account_id = u2.account_id and
account.id = u1.account_id;


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
s1.site_name='math' and
t1.name  = 'vector-spaces' and
t1.site_id = s1.site_id and
q1.site_id = s1.site_id and
tq1.site_id = s1.site_id and
tq1.question_id = q1.id and
tq1.tag_id = t1.id and
q1.owner_user_id = u1.id and
q1.site_id = u1.site_id and
s2.site_name='stackoverflow' and
t2.name  = 'jsf' and
t2.site_id = s2.site_id and
q2.site_id = s2.site_id and
tq2.site_id = s2.site_id and
tq2.question_id = q2.id and
tq2.tag_id = t2.id and
q2.owner_user_id = u2.id and
q2.site_id = u2.site_id and
u1.account_id = u2.account_id and
account.id = u1.account_id;


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
account.id = u1.account_id;


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
s2.site_name='math' and
t2.name  = 'geometry' and
t2.site_id = s2.site_id and
q2.site_id = s2.site_id and
tq2.site_id = s2.site_id and
tq2.question_id = q2.id and
tq2.tag_id = t2.id and
q2.owner_user_id = u2.id and
q2.site_id = u2.site_id and
u1.account_id = u2.account_id and
account.id = u1.account_id;


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
account.id = u1.account_id;


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
account.id = u1.account_id;


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
s1.site_name='drupal' and
t1.name  = 'theming' and
t1.site_id = s1.site_id and
q1.site_id = s1.site_id and
tq1.site_id = s1.site_id and
tq1.question_id = q1.id and
tq1.tag_id = t1.id and
q1.owner_user_id = u1.id and
q1.site_id = u1.site_id and
s2.site_name='ru' and
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
s2.site_name='math' and
t2.name  = 'polynomials' and
t2.site_id = s2.site_id and
q2.site_id = s2.site_id and
tq2.site_id = s2.site_id and
tq2.question_id = q2.id and
tq2.tag_id = t2.id and
q2.owner_user_id = u2.id and
q2.site_id = u2.site_id and
u1.account_id = u2.account_id and
account.id = u1.account_id;


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
s1.site_name='stackoverflow' and
t1.name  = 'forms' and
t1.site_id = s1.site_id and
q1.site_id = s1.site_id and
tq1.site_id = s1.site_id and
tq1.question_id = q1.id and
tq1.tag_id = t1.id and
q1.owner_user_id = u1.id and
q1.site_id = u1.site_id and
s2.site_name='english' and
t2.name  = 'single-word-requests' and
t2.site_id = s2.site_id and
q2.site_id = s2.site_id and
tq2.site_id = s2.site_id and
tq2.question_id = q2.id and
tq2.tag_id = t2.id and
q2.owner_user_id = u2.id and
q2.site_id = u2.site_id and
u1.account_id = u2.account_id and
account.id = u1.account_id;


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
account.id = u1.account_id;