-- imdbload_job10a.sql
-- 151.226
/*+ NestedLoop(mc cn t ci rt chn ct)
 NestedLoop(mc cn t ci rt chn)
 HashJoin(mc cn t ci rt)
 NestedLoop(mc cn t ci)
 NestedLoop(mc cn t)
 HashJoin(mc cn)
 SeqScan(mc)
 SeqScan(cn)
 IndexScan(t)
 IndexScan(ci)
 SeqScan(rt)
 IndexScan(chn)
 IndexOnlyScan(ct)
 Leading(((((((mc cn) t) ci) rt) chn) ct)) */
SELECT MIN(chn.name) AS uncredited_voiced_character, MIN(t.title) AS russian_movie FROM char_name AS chn, cast_info AS ci, company_name AS cn, company_type AS ct, movie_companies AS mc, role_type AS rt, title AS t WHERE ci.note  like '%(voice)%' and ci.note like '%(uncredited)%' AND cn.country_code  = '[ru]' AND rt.role  = 'actor' AND t.production_year > 2005 AND t.id = mc.movie_id AND t.id = ci.movie_id AND ci.movie_id = mc.movie_id AND chn.id = ci.person_role_id AND rt.id = ci.role_id AND cn.id = mc.company_id AND ct.id = mc.company_type_id;


-- imdbload_job10b.sql
-- 79.522
/*+ HashJoin(mc cn t ci rt chn ct)
 NestedLoop(mc cn t ci rt chn)
 HashJoin(mc cn t ci rt)
 NestedLoop(mc cn t ci)
 NestedLoop(mc cn t)
 HashJoin(mc cn)
 SeqScan(mc)
 SeqScan(cn)
 IndexScan(t)
 IndexScan(ci)
 SeqScan(rt)
 IndexScan(chn)
 SeqScan(ct)
 Leading(((((((mc cn) t) ci) rt) chn) ct)) */
SELECT MIN(chn.name) AS character, MIN(t.title) AS russian_mov_with_actor_producer FROM char_name AS chn, cast_info AS ci, company_name AS cn, company_type AS ct, movie_companies AS mc, role_type AS rt, title AS t WHERE ci.note  like '%(producer)%' AND cn.country_code  = '[ru]' AND rt.role  = 'actor' AND t.production_year > 2010 AND t.id = mc.movie_id AND t.id = ci.movie_id AND ci.movie_id = mc.movie_id AND chn.id = ci.person_role_id AND rt.id = ci.role_id AND cn.id = mc.company_id AND ct.id = mc.company_type_id;


-- imdbload_job10c.sql
-- 1491.687
/*+ HashJoin(t mc cn ct ci chn rt)
 NestedLoop(t mc cn ct ci chn)
 NestedLoop(t mc cn ct ci)
 HashJoin(t mc cn ct)
 HashJoin(t mc cn)
 HashJoin(mc cn)
 SeqScan(t)
 SeqScan(mc)
 SeqScan(cn)
 SeqScan(ct)
 IndexScan(ci)
 IndexScan(chn)
 SeqScan(rt)
 Leading((((((t (mc cn)) ct) ci) chn) rt)) */
SELECT MIN(chn.name) AS character, MIN(t.title) AS movie_with_american_producer FROM char_name AS chn, cast_info AS ci, company_name AS cn, company_type AS ct, movie_companies AS mc, role_type AS rt, title AS t WHERE ci.note  like '%(producer)%' AND cn.country_code  = '[us]' AND t.production_year > 1990 AND t.id = mc.movie_id AND t.id = ci.movie_id AND ci.movie_id = mc.movie_id AND chn.id = ci.person_role_id AND rt.id = ci.role_id AND cn.id = mc.company_id AND ct.id = mc.company_type_id;


-- imdbload_job11a.sql
-- 38.463
/*+ NestedLoop(lt k mk ml t mc cn ct)
 NestedLoop(lt k mk ml t mc cn)
 NestedLoop(lt k mk ml t mc)
 NestedLoop(lt k mk ml t)
 NestedLoop(lt k mk ml)
 NestedLoop(k mk ml)
 NestedLoop(k mk)
 SeqScan(lt)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(ml)
 IndexScan(t)
 IndexScan(mc)
 IndexScan(cn)
 SeqScan(ct)
 Leading((((((lt ((k mk) ml)) t) mc) cn) ct)) */
SELECT MIN(cn.name) AS from_company, MIN(lt.link) AS movie_link_type, MIN(t.title) AS non_polish_sequel_movie FROM company_name AS cn, company_type AS ct, keyword AS k, link_type AS lt, movie_companies AS mc, movie_keyword AS mk, movie_link AS ml, title AS t WHERE cn.country_code !='[pl]' AND (cn.name LIKE '%Film%' OR cn.name LIKE '%Warner%') AND ct.kind ='production companies' AND k.keyword ='sequel' AND lt.link LIKE '%follow%' AND mc.note IS NULL AND t.production_year BETWEEN 1950 AND 2000 AND lt.id = ml.link_type_id AND ml.movie_id = t.id AND t.id = mk.movie_id AND mk.keyword_id = k.id AND t.id = mc.movie_id AND mc.company_type_id = ct.id AND mc.company_id = cn.id AND ml.movie_id = mk.movie_id AND ml.movie_id = mc.movie_id AND mk.movie_id = mc.movie_id;


-- imdbload_job11b.sql
-- 17.815
/*+ NestedLoop(lt k mk ml t mc cn ct)
 NestedLoop(lt k mk ml t mc cn)
 NestedLoop(lt k mk ml t mc)
 NestedLoop(lt k mk ml t)
 NestedLoop(lt k mk ml)
 NestedLoop(k mk ml)
 NestedLoop(k mk)
 SeqScan(lt)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(ml)
 IndexScan(t)
 IndexScan(mc)
 IndexScan(cn)
 SeqScan(ct)
 Leading((((((lt ((k mk) ml)) t) mc) cn) ct)) */
SELECT MIN(cn.name) AS from_company, MIN(lt.link) AS movie_link_type, MIN(t.title) AS sequel_movie FROM company_name AS cn, company_type AS ct, keyword AS k, link_type AS lt, movie_companies AS mc, movie_keyword AS mk, movie_link AS ml, title AS t WHERE cn.country_code !='[pl]' AND (cn.name LIKE '%Film%' OR cn.name LIKE '%Warner%') AND ct.kind ='production companies' AND k.keyword ='sequel' AND lt.link LIKE '%follows%' AND mc.note IS NULL AND t.production_year  = 1998 and t.title like '%Money%' AND lt.id = ml.link_type_id AND ml.movie_id = t.id AND t.id = mk.movie_id AND mk.keyword_id = k.id AND t.id = mc.movie_id AND mc.company_type_id = ct.id AND mc.company_id = cn.id AND ml.movie_id = mk.movie_id AND ml.movie_id = mc.movie_id AND mk.movie_id = mc.movie_id;


-- imdbload_job11c.sql
-- 457.287
/*+ NestedLoop(mc cn ct mk ml k t lt)
 NestedLoop(mc cn ct mk ml k t)
 NestedLoop(mc cn ct mk ml k)
 MergeJoin(mc cn ct mk ml)
 NestedLoop(mc cn ct mk)
 NestedLoop(mc cn ct)
 NestedLoop(mc cn)
 IndexScan(mc)
 IndexScan(cn)
 IndexScan(ct)
 IndexScan(mk)
 IndexScan(ml)
 IndexScan(k)
 IndexScan(t)
 IndexOnlyScan(lt)
 Leading((((((((mc cn) ct) mk) ml) k) t) lt)) */
SELECT MIN(cn.name) AS from_company, MIN(mc.note) AS production_note, MIN(t.title) AS movie_based_on_book FROM company_name AS cn, company_type AS ct, keyword AS k, link_type AS lt, movie_companies AS mc, movie_keyword AS mk, movie_link AS ml, title AS t WHERE cn.country_code  !='[pl]' and (cn.name like '20th Century Fox%' or cn.name like 'Twentieth Century Fox%') AND ct.kind  != 'production companies' and ct.kind is not NULL AND k.keyword  in ('sequel', 'revenge', 'based-on-novel') AND mc.note  is not NULL AND t.production_year  > 1950 AND lt.id = ml.link_type_id AND ml.movie_id = t.id AND t.id = mk.movie_id AND mk.keyword_id = k.id AND t.id = mc.movie_id AND mc.company_type_id = ct.id AND mc.company_id = cn.id AND ml.movie_id = mk.movie_id AND ml.movie_id = mc.movie_id AND mk.movie_id = mc.movie_id;


-- imdbload_job11d.sql
-- 70.112
/*+ HashJoin(mk k ml t mc ct cn lt)
 NestedLoop(mk k ml t mc ct cn)
 HashJoin(mk k ml t mc ct)
 NestedLoop(mk k ml t mc)
 NestedLoop(mk k ml t)
 MergeJoin(mk k ml)
 NestedLoop(mk k)
 IndexScan(mk)
 IndexScan(k)
 IndexScan(ml)
 IndexScan(t)
 IndexScan(mc)
 SeqScan(ct)
 IndexScan(cn)
 SeqScan(lt)
 Leading((((((((mk k) ml) t) mc) ct) cn) lt)) */
SELECT MIN(cn.name) AS from_company, MIN(mc.note) AS production_note, MIN(t.title) AS movie_based_on_book FROM company_name AS cn, company_type AS ct, keyword AS k, link_type AS lt, movie_companies AS mc, movie_keyword AS mk, movie_link AS ml, title AS t WHERE cn.country_code  != '[pl]' AND ct.kind  != 'production companies' and ct.kind is not NULL AND k.keyword  in ('sequel', 'revenge', 'based-on-novel') AND mc.note  is not NULL AND t.production_year  > 1950 AND lt.id = ml.link_type_id AND ml.movie_id = t.id AND t.id = mk.movie_id AND mk.keyword_id = k.id AND t.id = mc.movie_id AND mc.company_type_id = ct.id AND mc.company_id = cn.id AND ml.movie_id = mk.movie_id AND ml.movie_id = mc.movie_id AND mk.movie_id = mc.movie_id;


-- imdbload_job12a.sql
-- 84.222
/*+ NestedLoop(mi_idx it2 mc ct t cn mi it1)
 NestedLoop(mi_idx it2 mc ct t cn mi)
 NestedLoop(mi_idx it2 mc ct t cn)
 NestedLoop(mi_idx it2 mc ct t)
 HashJoin(mi_idx it2 mc ct)
 NestedLoop(mi_idx it2 mc)
 HashJoin(mi_idx it2)
 SeqScan(mi_idx)
 SeqScan(it2)
 IndexScan(mc)
 SeqScan(ct)
 IndexScan(t)
 IndexScan(cn)
 IndexScan(mi)
 IndexScan(it1)
 Leading((((((((mi_idx it2) mc) ct) t) cn) mi) it1)) */
SELECT MIN(cn.name) AS movie_company, MIN(mi_idx.info) AS rating, MIN(t.title) AS drama_horror_movie FROM company_name AS cn, company_type AS ct, info_type AS it1, info_type AS it2, movie_companies AS mc, movie_info AS mi, movie_info_idx AS mi_idx, title AS t WHERE cn.country_code  = '[us]' AND ct.kind  = 'production companies' AND it1.info = 'genres' AND it2.info = 'rating' AND mi.info  in ('Drama', 'Horror') AND mi_idx.info  > '8.0' AND t.production_year  between 2005 and 2008 AND t.id = mi.movie_id AND t.id = mi_idx.movie_id AND mi.info_type_id = it1.id AND mi_idx.info_type_id = it2.id AND t.id = mc.movie_id AND ct.id = mc.company_type_id AND cn.id = mc.company_id AND mc.movie_id = mi.movie_id AND mc.movie_id = mi_idx.movie_id AND mi.movie_id = mi_idx.movie_id;


-- imdbload_job12b.sql
-- 36.743
/*+ NestedLoop(mi_idx it2 t mi it1 mc cn ct)
 NestedLoop(mi_idx it2 t mi it1 mc cn)
 NestedLoop(mi_idx it2 t mi it1 mc)
 HashJoin(mi_idx it2 t mi it1)
 NestedLoop(mi_idx it2 t mi)
 NestedLoop(mi_idx it2 t)
 HashJoin(mi_idx it2)
 SeqScan(mi_idx)
 SeqScan(it2)
 IndexScan(t)
 IndexScan(mi)
 SeqScan(it1)
 IndexScan(mc)
 IndexScan(cn)
 IndexScan(ct)
 Leading((((((((mi_idx it2) t) mi) it1) mc) cn) ct)) */
SELECT MIN(mi.info) AS budget, MIN(t.title) AS unsuccsessful_movie FROM company_name AS cn, company_type AS ct, info_type AS it1, info_type AS it2, movie_companies AS mc, movie_info AS mi, movie_info_idx AS mi_idx, title AS t WHERE cn.country_code ='[us]' AND ct.kind  is not NULL and (ct.kind ='production companies' or ct.kind = 'distributors') AND it1.info ='budget' AND it2.info ='bottom 10 rank' AND t.production_year >2000 AND (t.title LIKE 'Birdemic%' OR t.title LIKE '%Movie%') AND t.id = mi.movie_id AND t.id = mi_idx.movie_id AND mi.info_type_id = it1.id AND mi_idx.info_type_id = it2.id AND t.id = mc.movie_id AND ct.id = mc.company_type_id AND cn.id = mc.company_id AND mc.movie_id = mi.movie_id AND mc.movie_id = mi_idx.movie_id AND mi.movie_id = mi_idx.movie_id;


-- imdbload_job12c.sql
-- 270.706
/*+ HashJoin(mi_idx it2 t mc ct cn mi it1)
 NestedLoop(mi_idx it2 t mc ct cn mi)
 NestedLoop(mi_idx it2 t mc ct cn)
 HashJoin(mi_idx it2 t mc ct)
 NestedLoop(mi_idx it2 t mc)
 NestedLoop(mi_idx it2 t)
 HashJoin(mi_idx it2)
 SeqScan(mi_idx)
 SeqScan(it2)
 IndexScan(t)
 IndexScan(mc)
 SeqScan(ct)
 IndexScan(cn)
 IndexScan(mi)
 SeqScan(it1)
 Leading((((((((mi_idx it2) t) mc) ct) cn) mi) it1)) */
SELECT MIN(cn.name) AS movie_company, MIN(mi_idx.info) AS rating, MIN(t.title) AS mainstream_movie FROM company_name AS cn, company_type AS ct, info_type AS it1, info_type AS it2, movie_companies AS mc, movie_info AS mi, movie_info_idx AS mi_idx, title AS t WHERE cn.country_code  = '[us]' AND ct.kind  = 'production companies' AND it1.info = 'genres' AND it2.info = 'rating' AND mi.info  in ('Drama', 'Horror', 'Western', 'Family') AND mi_idx.info  > '7.0' AND t.production_year  between 2000 and 2010 AND t.id = mi.movie_id AND t.id = mi_idx.movie_id AND mi.info_type_id = it1.id AND mi_idx.info_type_id = it2.id AND t.id = mc.movie_id AND ct.id = mc.company_type_id AND cn.id = mc.company_id AND mc.movie_id = mi.movie_id AND mc.movie_id = mi_idx.movie_id AND mi.movie_id = mi_idx.movie_id;


-- imdbload_job13a.sql
-- 466.24
/*+ HashJoin(miidx it t kt mc ct cn mi it2)
 NestedLoop(miidx it t kt mc ct cn mi)
 NestedLoop(miidx it t kt mc ct cn)
 HashJoin(miidx it t kt mc ct)
 NestedLoop(miidx it t kt mc)
 HashJoin(miidx it t kt)
 NestedLoop(miidx it t)
 HashJoin(miidx it)
 SeqScan(miidx)
 SeqScan(it)
 IndexScan(t)
 SeqScan(kt)
 IndexScan(mc)
 SeqScan(ct)
 IndexScan(cn)
 IndexScan(mi)
 SeqScan(it2)
 Leading(((((((((miidx it) t) kt) mc) ct) cn) mi) it2)) */
SELECT MIN(mi.info) AS release_date, MIN(miidx.info) AS rating, MIN(t.title) AS german_movie FROM company_name AS cn, company_type AS ct, info_type AS it, info_type AS it2, kind_type AS kt, movie_companies AS mc, movie_info AS mi, movie_info_idx AS miidx, title AS t WHERE cn.country_code ='[de]' AND ct.kind ='production companies' AND it.info ='rating' AND it2.info ='release dates' AND kt.kind ='movie' AND mi.movie_id = t.id AND it2.id = mi.info_type_id AND kt.id = t.kind_id AND mc.movie_id = t.id AND cn.id = mc.company_id AND ct.id = mc.company_type_id AND miidx.movie_id = t.id AND it.id = miidx.info_type_id AND mi.movie_id = miidx.movie_id AND mi.movie_id = mc.movie_id AND miidx.movie_id = mc.movie_id;


-- imdbload_job13b.sql
-- 215.294
/*+ NestedLoop(miidx it t kt mc ct cn mi it2)
 NestedLoop(miidx it t kt mc ct cn mi)
 NestedLoop(miidx it t kt mc ct cn)
 NestedLoop(miidx it t kt mc ct)
 NestedLoop(miidx it t kt mc)
 NestedLoop(miidx it t kt)
 NestedLoop(miidx it t)
 HashJoin(miidx it)
 SeqScan(miidx)
 SeqScan(it)
 IndexScan(t)
 IndexScan(kt)
 IndexScan(mc)
 IndexScan(ct)
 IndexScan(cn)
 IndexScan(mi)
 IndexScan(it2)
 Leading(((((((((miidx it) t) kt) mc) ct) cn) mi) it2)) */
SELECT MIN(cn.name) AS producing_company, MIN(miidx.info) AS rating, MIN(t.title) AS movie_about_winning FROM company_name AS cn, company_type AS ct, info_type AS it, info_type AS it2, kind_type AS kt, movie_companies AS mc, movie_info AS mi, movie_info_idx AS miidx, title AS t WHERE cn.country_code ='[us]' AND ct.kind ='production companies' AND it.info ='rating' AND it2.info ='release dates' AND kt.kind ='movie' AND t.title  != '' AND (t.title LIKE '%Champion%' OR t.title LIKE '%Loser%') AND mi.movie_id = t.id AND it2.id = mi.info_type_id AND kt.id = t.kind_id AND mc.movie_id = t.id AND cn.id = mc.company_id AND ct.id = mc.company_type_id AND miidx.movie_id = t.id AND it.id = miidx.info_type_id AND mi.movie_id = miidx.movie_id AND mi.movie_id = mc.movie_id AND miidx.movie_id = mc.movie_id;


-- imdbload_job13c.sql
-- 206.874
/*+ NestedLoop(miidx it t kt mc ct cn mi it2)
 NestedLoop(miidx it t kt mc ct cn mi)
 NestedLoop(miidx it t kt mc ct cn)
 NestedLoop(miidx it t kt mc ct)
 NestedLoop(miidx it t kt mc)
 NestedLoop(miidx it t kt)
 NestedLoop(miidx it t)
 HashJoin(miidx it)
 SeqScan(miidx)
 SeqScan(it)
 IndexScan(t)
 IndexScan(kt)
 IndexScan(mc)
 IndexScan(ct)
 IndexScan(cn)
 IndexScan(mi)
 IndexScan(it2)
 Leading(((((((((miidx it) t) kt) mc) ct) cn) mi) it2)) */
SELECT MIN(cn.name) AS producing_company, MIN(miidx.info) AS rating, MIN(t.title) AS movie_about_winning FROM company_name AS cn, company_type AS ct, info_type AS it, info_type AS it2, kind_type AS kt, movie_companies AS mc, movie_info AS mi, movie_info_idx AS miidx, title AS t WHERE cn.country_code ='[us]' AND ct.kind ='production companies' AND it.info ='rating' AND it2.info ='release dates' AND kt.kind ='movie' AND t.title  != '' AND (t.title LIKE 'Champion%' OR t.title LIKE 'Loser%') AND mi.movie_id = t.id AND it2.id = mi.info_type_id AND kt.id = t.kind_id AND mc.movie_id = t.id AND cn.id = mc.company_id AND ct.id = mc.company_type_id AND miidx.movie_id = t.id AND it.id = miidx.info_type_id AND mi.movie_id = miidx.movie_id AND mi.movie_id = mc.movie_id AND miidx.movie_id = mc.movie_id;


-- imdbload_job13d.sql
-- 712.201
/*+ HashJoin(miidx it t kt mc ct cn mi it2)
 NestedLoop(miidx it t kt mc ct cn mi)
 NestedLoop(miidx it t kt mc ct cn)
 HashJoin(miidx it t kt mc ct)
 NestedLoop(miidx it t kt mc)
 HashJoin(miidx it t kt)
 NestedLoop(miidx it t)
 HashJoin(miidx it)
 SeqScan(miidx)
 SeqScan(it)
 IndexScan(t)
 SeqScan(kt)
 IndexScan(mc)
 SeqScan(ct)
 IndexScan(cn)
 IndexScan(mi)
 SeqScan(it2)
 Leading(((((((((miidx it) t) kt) mc) ct) cn) mi) it2)) */
SELECT MIN(cn.name) AS producing_company, MIN(miidx.info) AS rating, MIN(t.title) AS movie FROM company_name AS cn, company_type AS ct, info_type AS it, info_type AS it2, kind_type AS kt, movie_companies AS mc, movie_info AS mi, movie_info_idx AS miidx, title AS t WHERE cn.country_code ='[us]' AND ct.kind ='production companies' AND it.info ='rating' AND it2.info ='release dates' AND kt.kind ='movie' AND mi.movie_id = t.id AND it2.id = mi.info_type_id AND kt.id = t.kind_id AND mc.movie_id = t.id AND cn.id = mc.company_id AND ct.id = mc.company_type_id AND miidx.movie_id = t.id AND it.id = miidx.info_type_id AND mi.movie_id = miidx.movie_id AND mi.movie_id = mc.movie_id AND miidx.movie_id = mc.movie_id;


-- imdbload_job14a.sql
-- 153.639
/*+ NestedLoop(it2 kt k mk t mi_idx mi it1)
 NestedLoop(it2 kt k mk t mi_idx mi)
 NestedLoop(it2 kt k mk t mi_idx)
 NestedLoop(kt k mk t mi_idx)
 NestedLoop(kt k mk t)
 NestedLoop(k mk t)
 NestedLoop(k mk)
 SeqScan(it2)
 SeqScan(kt)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(t)
 IndexScan(mi_idx)
 IndexScan(mi)
 SeqScan(it1)
 Leading((((it2 ((kt ((k mk) t)) mi_idx)) mi) it1)) */
SELECT MIN(mi_idx.info) AS rating, MIN(t.title) AS northern_dark_movie FROM info_type AS it1, info_type AS it2, keyword AS k, kind_type AS kt, movie_info AS mi, movie_info_idx AS mi_idx, movie_keyword AS mk, title AS t WHERE it1.info  = 'countries' AND it2.info  = 'rating' AND k.keyword  in ('murder', 'murder-in-title', 'blood', 'violence') AND kt.kind  = 'movie' AND mi.info IN ('Sweden', 'Norway', 'Germany', 'Denmark', 'Swedish', 'Denish', 'Norwegian', 'German', 'USA', 'American') AND mi_idx.info  < '8.5' AND t.production_year  > 2010 AND kt.id = t.kind_id AND t.id = mi.movie_id AND t.id = mk.movie_id AND t.id = mi_idx.movie_id AND mk.movie_id = mi.movie_id AND mk.movie_id = mi_idx.movie_id AND mi.movie_id = mi_idx.movie_id AND k.id = mk.keyword_id AND it1.id = mi.info_type_id AND it2.id = mi_idx.info_type_id;


-- imdbload_job14b.sql
-- 59.949
/*+ NestedLoop(k mk t mi it1 mi_idx it2 kt)
 NestedLoop(k mk t mi it1 mi_idx it2)
 NestedLoop(k mk t mi it1 mi_idx)
 NestedLoop(k mk t mi it1)
 NestedLoop(k mk t mi)
 NestedLoop(k mk t)
 NestedLoop(k mk)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(t)
 IndexScan(mi)
 SeqScan(it1)
 IndexScan(mi_idx)
 SeqScan(it2)
 SeqScan(kt)
 Leading((((((((k mk) t) mi) it1) mi_idx) it2) kt)) */
SELECT MIN(mi_idx.info) AS rating, MIN(t.title) AS western_dark_production FROM info_type AS it1, info_type AS it2, keyword AS k, kind_type AS kt, movie_info AS mi, movie_info_idx AS mi_idx, movie_keyword AS mk, title AS t WHERE it1.info  = 'countries' AND it2.info  = 'rating' AND k.keyword  in ('murder', 'murder-in-title') AND kt.kind  = 'movie' AND mi.info IN ('Sweden', 'Norway', 'Germany', 'Denmark', 'Swedish', 'Denish', 'Norwegian', 'German', 'USA', 'American') AND mi_idx.info  > '6.0' AND t.production_year  > 2010 and (t.title like '%murder%' or t.title like '%Murder%' or t.title like '%Mord%') AND kt.id = t.kind_id AND t.id = mi.movie_id AND t.id = mk.movie_id AND t.id = mi_idx.movie_id AND mk.movie_id = mi.movie_id AND mk.movie_id = mi_idx.movie_id AND mi.movie_id = mi_idx.movie_id AND k.id = mk.keyword_id AND it1.id = mi.info_type_id AND it2.id = mi_idx.info_type_id;


-- imdbload_job14c.sql
-- 234.536
/*+ NestedLoop(it2 k mk t kt mi_idx mi it1)
 NestedLoop(it2 k mk t kt mi_idx mi)
 NestedLoop(it2 k mk t kt mi_idx)
 NestedLoop(k mk t kt mi_idx)
 NestedLoop(k mk t kt)
 NestedLoop(k mk t)
 NestedLoop(k mk)
 SeqScan(it2)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(t)
 SeqScan(kt)
 IndexScan(mi_idx)
 IndexScan(mi)
 SeqScan(it1)
 Leading((((it2 ((((k mk) t) kt) mi_idx)) mi) it1)) */
SELECT MIN(mi_idx.info) AS rating, MIN(t.title) AS north_european_dark_production FROM info_type AS it1, info_type AS it2, keyword AS k, kind_type AS kt, movie_info AS mi, movie_info_idx AS mi_idx, movie_keyword AS mk, title AS t WHERE it1.info  = 'countries' AND it2.info  = 'rating' AND k.keyword  is not null and k.keyword in ('murder', 'murder-in-title', 'blood', 'violence') AND kt.kind  in ('movie', 'episode') AND mi.info IN ('Sweden', 'Norway', 'Germany', 'Denmark', 'Swedish', 'Danish', 'Norwegian', 'German', 'USA', 'American') AND mi_idx.info  < '8.5' AND t.production_year  > 2005 AND kt.id = t.kind_id AND t.id = mi.movie_id AND t.id = mk.movie_id AND t.id = mi_idx.movie_id AND mk.movie_id = mi.movie_id AND mk.movie_id = mi_idx.movie_id AND mi.movie_id = mi_idx.movie_id AND k.id = mk.keyword_id AND it1.id = mi.info_type_id AND it2.id = mi_idx.info_type_id;


-- imdbload_job15a.sql
-- 84.566
/*+ NestedLoop(mc cn at t mi ct it1 mk k)
 NestedLoop(mc cn at t mi ct it1 mk)
 NestedLoop(mc cn at t mi ct it1)
 NestedLoop(mc cn at t mi ct)
 NestedLoop(mc cn at t mi)
 NestedLoop(mc cn at t)
 NestedLoop(mc cn at)
 HashJoin(mc cn)
 SeqScan(mc)
 SeqScan(cn)
 IndexOnlyScan(at)
 IndexScan(t)
 IndexScan(mi)
 IndexOnlyScan(ct)
 IndexScan(it1)
 IndexScan(mk)
 IndexOnlyScan(k)
 Leading(((((((((mc cn) at) t) mi) ct) it1) mk) k)) */
SELECT MIN(mi.info) AS release_date, MIN(t.title) AS internet_movie FROM aka_title AS at, company_name AS cn, company_type AS ct, info_type AS it1, keyword AS k, movie_companies AS mc, movie_info AS mi, movie_keyword AS mk, title AS t WHERE cn.country_code  = '[us]' AND it1.info  = 'release dates' AND mc.note  like '%(200%)%' and mc.note like '%(worldwide)%' AND mi.note  like '%internet%' AND mi.info  like 'USA:% 200%' AND t.production_year  > 2000 AND t.id = at.movie_id AND t.id = mi.movie_id AND t.id = mk.movie_id AND t.id = mc.movie_id AND mk.movie_id = mi.movie_id AND mk.movie_id = mc.movie_id AND mk.movie_id = at.movie_id AND mi.movie_id = mc.movie_id AND mi.movie_id = at.movie_id AND mc.movie_id = at.movie_id AND k.id = mk.keyword_id AND it1.id = mi.info_type_id AND cn.id = mc.company_id AND ct.id = mc.company_type_id;


-- imdbload_job15b.sql
-- 11.974
/*+ NestedLoop(cn mc at ct t mi it1 mk k)
 NestedLoop(cn mc at ct t mi it1 mk)
 NestedLoop(cn mc at ct t mi it1)
 NestedLoop(cn mc at ct t mi)
 NestedLoop(cn mc at ct t)
 NestedLoop(cn mc at ct)
 NestedLoop(cn mc at)
 NestedLoop(cn mc)
 SeqScan(cn)
 IndexScan(mc)
 IndexOnlyScan(at)
 IndexOnlyScan(ct)
 IndexScan(t)
 IndexScan(mi)
 IndexScan(it1)
 IndexScan(mk)
 IndexOnlyScan(k)
 Leading(((((((((cn mc) at) ct) t) mi) it1) mk) k)) */
SELECT MIN(mi.info) AS release_date, MIN(t.title) AS youtube_movie FROM aka_title AS at, company_name AS cn, company_type AS ct, info_type AS it1, keyword AS k, movie_companies AS mc, movie_info AS mi, movie_keyword AS mk, title AS t WHERE cn.country_code  = '[us]' and cn.name = 'YouTube' AND it1.info  = 'release dates' AND mc.note  like '%(200%)%' and mc.note like '%(worldwide)%' AND mi.note  like '%internet%' AND mi.info  like 'USA:% 200%' AND t.production_year  between 2005 and 2010 AND t.id = at.movie_id AND t.id = mi.movie_id AND t.id = mk.movie_id AND t.id = mc.movie_id AND mk.movie_id = mi.movie_id AND mk.movie_id = mc.movie_id AND mk.movie_id = at.movie_id AND mi.movie_id = mc.movie_id AND mi.movie_id = at.movie_id AND mc.movie_id = at.movie_id AND k.id = mk.keyword_id AND it1.id = mi.info_type_id AND cn.id = mc.company_id AND ct.id = mc.company_type_id;


-- imdbload_job15c.sql
-- 131.639
/*+ NestedLoop(mi it1 t mc cn ct mk k at)
 NestedLoop(mi it1 t mc cn ct mk k)
 NestedLoop(mi it1 t mc cn ct mk)
 NestedLoop(mi it1 t mc cn ct)
 NestedLoop(mi it1 t mc cn)
 NestedLoop(mi it1 t mc)
 NestedLoop(mi it1 t)
 HashJoin(mi it1)
 SeqScan(mi)
 SeqScan(it1)
 IndexScan(t)
 IndexScan(mc)
 IndexScan(cn)
 IndexOnlyScan(ct)
 IndexScan(mk)
 IndexOnlyScan(k)
 IndexOnlyScan(at)
 Leading(((((((((mi it1) t) mc) cn) ct) mk) k) at)) */
SELECT MIN(mi.info) AS release_date, MIN(t.title) AS modern_american_internet_movie FROM aka_title AS at, company_name AS cn, company_type AS ct, info_type AS it1, keyword AS k, movie_companies AS mc, movie_info AS mi, movie_keyword AS mk, title AS t WHERE cn.country_code  = '[us]' AND it1.info  = 'release dates' AND mi.note  like '%internet%' AND mi.info  is not NULL and (mi.info like 'USA:% 199%' or mi.info like 'USA:% 200%') AND t.production_year  > 1990 AND t.id = at.movie_id AND t.id = mi.movie_id AND t.id = mk.movie_id AND t.id = mc.movie_id AND mk.movie_id = mi.movie_id AND mk.movie_id = mc.movie_id AND mk.movie_id = at.movie_id AND mi.movie_id = mc.movie_id AND mi.movie_id = at.movie_id AND mc.movie_id = at.movie_id AND k.id = mk.keyword_id AND it1.id = mi.info_type_id AND cn.id = mc.company_id AND ct.id = mc.company_type_id;


-- imdbload_job15d.sql
-- 147.103
/*+ NestedLoop(mi it1 t mc cn ct mk k at)
 NestedLoop(mi it1 t mc cn ct mk k)
 NestedLoop(mi it1 t mc cn ct mk)
 NestedLoop(mi it1 t mc cn ct)
 NestedLoop(mi it1 t mc cn)
 NestedLoop(mi it1 t mc)
 NestedLoop(mi it1 t)
 HashJoin(mi it1)
 SeqScan(mi)
 SeqScan(it1)
 IndexScan(t)
 IndexScan(mc)
 IndexScan(cn)
 IndexOnlyScan(ct)
 IndexScan(mk)
 IndexOnlyScan(k)
 IndexScan(at)
 Leading(((((((((mi it1) t) mc) cn) ct) mk) k) at)) */
SELECT MIN(at.title) AS aka_title, MIN(t.title) AS internet_movie_title FROM aka_title AS at, company_name AS cn, company_type AS ct, info_type AS it1, keyword AS k, movie_companies AS mc, movie_info AS mi, movie_keyword AS mk, title AS t WHERE cn.country_code  = '[us]' AND it1.info  = 'release dates' AND mi.note  like '%internet%' AND t.production_year  > 1990 AND t.id = at.movie_id AND t.id = mi.movie_id AND t.id = mk.movie_id AND t.id = mc.movie_id AND mk.movie_id = mi.movie_id AND mk.movie_id = mc.movie_id AND mk.movie_id = at.movie_id AND mi.movie_id = mc.movie_id AND mi.movie_id = at.movie_id AND mc.movie_id = at.movie_id AND k.id = mk.keyword_id AND it1.id = mi.info_type_id AND cn.id = mc.company_id AND ct.id = mc.company_type_id;


-- imdbload_job16a.sql
-- 98.959
/*+ NestedLoop(k mk t mc cn ci n an)
 NestedLoop(k mk t mc cn ci n)
 NestedLoop(k mk t mc cn ci)
 NestedLoop(k mk t mc cn)
 NestedLoop(k mk t mc)
 NestedLoop(k mk t)
 NestedLoop(k mk)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(t)
 IndexScan(mc)
 IndexScan(cn)
 IndexScan(ci)
 IndexOnlyScan(n)
 IndexScan(an)
 Leading((((((((k mk) t) mc) cn) ci) n) an)) */
SELECT MIN(an.name) AS cool_actor_pseudonym, MIN(t.title) AS series_named_after_char FROM aka_name AS an, cast_info AS ci, company_name AS cn, keyword AS k, movie_companies AS mc, movie_keyword AS mk, name AS n, title AS t WHERE cn.country_code ='[us]' AND k.keyword ='character-name-in-title' AND t.episode_nr >= 50 AND t.episode_nr < 100 AND an.person_id = n.id AND n.id = ci.person_id AND ci.movie_id = t.id AND t.id = mk.movie_id AND mk.keyword_id = k.id AND t.id = mc.movie_id AND mc.company_id = cn.id AND an.person_id = ci.person_id AND ci.movie_id = mc.movie_id AND ci.movie_id = mk.movie_id AND mc.movie_id = mk.movie_id;


-- imdbload_job16b.sql
-- 6766.65
/*+ NestedLoop(k mk t mc cn ci n an)
 NestedLoop(k mk t mc cn ci n)
 NestedLoop(k mk t mc cn ci)
 NestedLoop(k mk t mc cn)
 NestedLoop(k mk t mc)
 NestedLoop(k mk t)
 NestedLoop(k mk)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(t)
 IndexScan(mc)
 IndexScan(cn)
 IndexScan(ci)
 IndexOnlyScan(n)
 IndexScan(an)
 Leading((((((((k mk) t) mc) cn) ci) n) an)) */
SELECT MIN(an.name) AS cool_actor_pseudonym, MIN(t.title) AS series_named_after_char FROM aka_name AS an, cast_info AS ci, company_name AS cn, keyword AS k, movie_companies AS mc, movie_keyword AS mk, name AS n, title AS t WHERE cn.country_code ='[us]' AND k.keyword ='character-name-in-title' AND an.person_id = n.id AND n.id = ci.person_id AND ci.movie_id = t.id AND t.id = mk.movie_id AND mk.keyword_id = k.id AND t.id = mc.movie_id AND mc.company_id = cn.id AND an.person_id = ci.person_id AND ci.movie_id = mc.movie_id AND ci.movie_id = mk.movie_id AND mc.movie_id = mk.movie_id;


-- imdbload_job16c.sql
-- 609.047
/*+ NestedLoop(k mk t mc cn ci n an)
 NestedLoop(k mk t mc cn ci n)
 NestedLoop(k mk t mc cn ci)
 NestedLoop(k mk t mc cn)
 NestedLoop(k mk t mc)
 NestedLoop(k mk t)
 NestedLoop(k mk)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(t)
 IndexScan(mc)
 IndexScan(cn)
 IndexScan(ci)
 IndexOnlyScan(n)
 IndexScan(an)
 Leading((((((((k mk) t) mc) cn) ci) n) an)) */
SELECT MIN(an.name) AS cool_actor_pseudonym, MIN(t.title) AS series_named_after_char FROM aka_name AS an, cast_info AS ci, company_name AS cn, keyword AS k, movie_companies AS mc, movie_keyword AS mk, name AS n, title AS t WHERE cn.country_code ='[us]' AND k.keyword ='character-name-in-title' AND t.episode_nr < 100 AND an.person_id = n.id AND n.id = ci.person_id AND ci.movie_id = t.id AND t.id = mk.movie_id AND mk.keyword_id = k.id AND t.id = mc.movie_id AND mc.company_id = cn.id AND an.person_id = ci.person_id AND ci.movie_id = mc.movie_id AND ci.movie_id = mk.movie_id AND mc.movie_id = mk.movie_id;


-- imdbload_job16d.sql
-- 461.696
/*+ NestedLoop(k mk t mc cn ci n an)
 NestedLoop(k mk t mc cn ci n)
 NestedLoop(k mk t mc cn ci)
 NestedLoop(k mk t mc cn)
 NestedLoop(k mk t mc)
 NestedLoop(k mk t)
 NestedLoop(k mk)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(t)
 IndexScan(mc)
 IndexScan(cn)
 IndexScan(ci)
 IndexOnlyScan(n)
 IndexScan(an)
 Leading((((((((k mk) t) mc) cn) ci) n) an)) */
SELECT MIN(an.name) AS cool_actor_pseudonym, MIN(t.title) AS series_named_after_char FROM aka_name AS an, cast_info AS ci, company_name AS cn, keyword AS k, movie_companies AS mc, movie_keyword AS mk, name AS n, title AS t WHERE cn.country_code ='[us]' AND k.keyword ='character-name-in-title' AND t.episode_nr >= 5 AND t.episode_nr < 100 AND an.person_id = n.id AND n.id = ci.person_id AND ci.movie_id = t.id AND t.id = mk.movie_id AND mk.keyword_id = k.id AND t.id = mc.movie_id AND mc.company_id = cn.id AND an.person_id = ci.person_id AND ci.movie_id = mc.movie_id AND ci.movie_id = mk.movie_id AND mc.movie_id = mk.movie_id;


-- imdbload_job17a.sql
-- 4086.91
/*+ NestedLoop(k mk t mc cn ci n)
 NestedLoop(k mk t mc cn ci)
 NestedLoop(k mk t mc cn)
 NestedLoop(k mk t mc)
 NestedLoop(k mk t)
 NestedLoop(k mk)
 SeqScan(k)
 IndexScan(mk)
 IndexOnlyScan(t)
 IndexScan(mc)
 IndexScan(cn)
 IndexScan(ci)
 IndexScan(n)
 Leading(((((((k mk) t) mc) cn) ci) n)) */
SELECT MIN(n.name) AS member_in_charnamed_american_movie, MIN(n.name) AS a1 FROM cast_info AS ci, company_name AS cn, keyword AS k, movie_companies AS mc, movie_keyword AS mk, name AS n, title AS t WHERE cn.country_code ='[us]' AND k.keyword ='character-name-in-title' AND n.name  LIKE 'B%' AND n.id = ci.person_id AND ci.movie_id = t.id AND t.id = mk.movie_id AND mk.keyword_id = k.id AND t.id = mc.movie_id AND mc.company_id = cn.id AND ci.movie_id = mc.movie_id AND ci.movie_id = mk.movie_id AND mc.movie_id = mk.movie_id;


-- imdbload_job17b.sql
-- 2506.905
/*+ NestedLoop(k mk ci n t mc cn)
 NestedLoop(k mk ci n t mc)
 NestedLoop(k mk ci n t)
 NestedLoop(k mk ci n)
 NestedLoop(k mk ci)
 NestedLoop(k mk)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(ci)
 IndexScan(n)
 IndexOnlyScan(t)
 IndexScan(mc)
 IndexOnlyScan(cn)
 Leading(((((((k mk) ci) n) t) mc) cn)) */
SELECT MIN(n.name) AS member_in_charnamed_movie, MIN(n.name) AS a1 FROM cast_info AS ci, company_name AS cn, keyword AS k, movie_companies AS mc, movie_keyword AS mk, name AS n, title AS t WHERE k.keyword ='character-name-in-title' AND n.name  LIKE 'Z%' AND n.id = ci.person_id AND ci.movie_id = t.id AND t.id = mk.movie_id AND mk.keyword_id = k.id AND t.id = mc.movie_id AND mc.company_id = cn.id AND ci.movie_id = mc.movie_id AND ci.movie_id = mk.movie_id AND mc.movie_id = mk.movie_id;


-- imdbload_job17c.sql
-- 2417.463
/*+ NestedLoop(k mk ci n mc cn t)
 NestedLoop(k mk ci n mc cn)
 NestedLoop(k mk ci n mc)
 NestedLoop(k mk ci n)
 NestedLoop(k mk ci)
 NestedLoop(k mk)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(ci)
 IndexScan(n)
 IndexScan(mc)
 IndexOnlyScan(cn)
 IndexOnlyScan(t)
 Leading(((((((k mk) ci) n) mc) cn) t)) */
SELECT MIN(n.name) AS member_in_charnamed_movie, MIN(n.name) AS a1 FROM cast_info AS ci, company_name AS cn, keyword AS k, movie_companies AS mc, movie_keyword AS mk, name AS n, title AS t WHERE k.keyword ='character-name-in-title' AND n.name  LIKE 'X%' AND n.id = ci.person_id AND ci.movie_id = t.id AND t.id = mk.movie_id AND mk.keyword_id = k.id AND t.id = mc.movie_id AND mc.company_id = cn.id AND ci.movie_id = mc.movie_id AND ci.movie_id = mk.movie_id AND mc.movie_id = mk.movie_id;


-- imdbload_job17d.sql
-- 2430.795
/*+ NestedLoop(k mk ci n mc cn t)
 NestedLoop(k mk ci n mc cn)
 NestedLoop(k mk ci n mc)
 NestedLoop(k mk ci n)
 NestedLoop(k mk ci)
 NestedLoop(k mk)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(ci)
 IndexScan(n)
 IndexScan(mc)
 IndexOnlyScan(cn)
 IndexOnlyScan(t)
 Leading(((((((k mk) ci) n) mc) cn) t)) */
SELECT MIN(n.name) AS member_in_charnamed_movie FROM cast_info AS ci, company_name AS cn, keyword AS k, movie_companies AS mc, movie_keyword AS mk, name AS n, title AS t WHERE k.keyword ='character-name-in-title' AND n.name  LIKE '%Bert%' AND n.id = ci.person_id AND ci.movie_id = t.id AND t.id = mk.movie_id AND mk.keyword_id = k.id AND t.id = mc.movie_id AND mc.company_id = cn.id AND ci.movie_id = mc.movie_id AND ci.movie_id = mk.movie_id AND mc.movie_id = mk.movie_id;


-- imdbload_job17e.sql
-- 3885.902
/*+ NestedLoop(k mk t mc cn ci n)
 NestedLoop(k mk t mc cn ci)
 NestedLoop(k mk t mc cn)
 NestedLoop(k mk t mc)
 NestedLoop(k mk t)
 NestedLoop(k mk)
 SeqScan(k)
 IndexScan(mk)
 IndexOnlyScan(t)
 IndexScan(mc)
 IndexScan(cn)
 IndexScan(ci)
 IndexScan(n)
 Leading(((((((k mk) t) mc) cn) ci) n)) */
SELECT MIN(n.name) AS member_in_charnamed_movie FROM cast_info AS ci, company_name AS cn, keyword AS k, movie_companies AS mc, movie_keyword AS mk, name AS n, title AS t WHERE cn.country_code ='[us]' AND k.keyword ='character-name-in-title' AND n.id = ci.person_id AND ci.movie_id = t.id AND t.id = mk.movie_id AND mk.keyword_id = k.id AND t.id = mc.movie_id AND mc.company_id = cn.id AND ci.movie_id = mc.movie_id AND ci.movie_id = mk.movie_id AND mc.movie_id = mk.movie_id;


-- imdbload_job17f.sql
-- 3514.855
/*+ NestedLoop(k mk t ci n mc cn)
 NestedLoop(k mk t ci n mc)
 NestedLoop(k mk t ci n)
 NestedLoop(k mk t ci)
 NestedLoop(k mk t)
 NestedLoop(k mk)
 SeqScan(k)
 IndexScan(mk)
 IndexOnlyScan(t)
 IndexScan(ci)
 IndexScan(n)
 IndexScan(mc)
 IndexOnlyScan(cn)
 Leading(((((((k mk) t) ci) n) mc) cn)) */
SELECT MIN(n.name) AS member_in_charnamed_movie FROM cast_info AS ci, company_name AS cn, keyword AS k, movie_companies AS mc, movie_keyword AS mk, name AS n, title AS t WHERE k.keyword ='character-name-in-title' AND n.name  LIKE '%B%' AND n.id = ci.person_id AND ci.movie_id = t.id AND t.id = mk.movie_id AND mk.keyword_id = k.id AND t.id = mc.movie_id AND mc.company_id = cn.id AND ci.movie_id = mc.movie_id AND ci.movie_id = mk.movie_id AND mc.movie_id = mk.movie_id;


-- imdbload_job18a.sql
-- 1385.876
/*+ NestedLoop(mi_idx it2 mi it1 ci n t)
 NestedLoop(mi_idx it2 mi it1 ci n)
 NestedLoop(mi_idx it2 mi it1 ci)
 HashJoin(mi_idx it2 mi it1)
 NestedLoop(mi_idx it2 mi)
 HashJoin(mi_idx it2)
 SeqScan(mi_idx)
 SeqScan(it2)
 IndexScan(mi)
 SeqScan(it1)
 IndexScan(ci)
 IndexScan(n)
 IndexScan(t)
 Leading(((((((mi_idx it2) mi) it1) ci) n) t)) */
SELECT MIN(mi.info) AS movie_budget, MIN(mi_idx.info) AS movie_votes, MIN(t.title) AS movie_title FROM cast_info AS ci, info_type AS it1, info_type AS it2, movie_info AS mi, movie_info_idx AS mi_idx, name AS n, title AS t WHERE ci.note  in ('(producer)', '(executive producer)') AND it1.info  = 'budget' AND it2.info  = 'votes' AND n.gender  = 'm' and n.name like '%Tim%' AND t.id = mi.movie_id AND t.id = mi_idx.movie_id AND t.id = ci.movie_id AND ci.movie_id = mi.movie_id AND ci.movie_id = mi_idx.movie_id AND mi.movie_id = mi_idx.movie_id AND n.id = ci.person_id AND it1.id = mi.info_type_id AND it2.id = mi_idx.info_type_id;


-- imdbload_job18b.sql
-- 83.828
/*+ NestedLoop(mi_idx it2 t mi it1 ci n)
 NestedLoop(mi_idx it2 t mi it1 ci)
 NestedLoop(mi_idx it2 t mi it1)
 NestedLoop(mi_idx it2 t mi)
 NestedLoop(mi_idx it2 t)
 HashJoin(mi_idx it2)
 SeqScan(mi_idx)
 SeqScan(it2)
 IndexScan(t)
 IndexScan(mi)
 IndexScan(it1)
 IndexScan(ci)
 IndexScan(n)
 Leading(((((((mi_idx it2) t) mi) it1) ci) n)) */
SELECT MIN(mi.info) AS movie_budget, MIN(mi_idx.info) AS movie_votes, MIN(t.title) AS movie_title FROM cast_info AS ci, info_type AS it1, info_type AS it2, movie_info AS mi, movie_info_idx AS mi_idx, name AS n, title AS t WHERE ci.note  in ('(writer)', '(head writer)', '(written by)', '(story)', '(story editor)') AND it1.info  = 'genres' AND it2.info  = 'rating' AND mi.info  in ('Horror', 'Thriller') and mi.note is NULL AND mi_idx.info  > '8.0' AND n.gender  is not null and n.gender = 'f' AND t.production_year  between 2008 and 2014 AND t.id = mi.movie_id AND t.id = mi_idx.movie_id AND t.id = ci.movie_id AND ci.movie_id = mi.movie_id AND ci.movie_id = mi_idx.movie_id AND mi.movie_id = mi_idx.movie_id AND n.id = ci.person_id AND it1.id = mi.info_type_id AND it2.id = mi_idx.info_type_id;


-- imdbload_job18c.sql
-- 1522.145
/*+ NestedLoop(mi_idx it2 mi it1 t ci n)
 NestedLoop(mi_idx it2 mi it1 t ci)
 NestedLoop(mi_idx it2 mi it1 t)
 HashJoin(mi_idx it2 mi it1)
 NestedLoop(mi_idx it2 mi)
 HashJoin(mi_idx it2)
 SeqScan(mi_idx)
 SeqScan(it2)
 IndexScan(mi)
 SeqScan(it1)
 IndexScan(t)
 IndexScan(ci)
 IndexScan(n)
 Leading(((((((mi_idx it2) mi) it1) t) ci) n)) */
SELECT MIN(mi.info) AS movie_budget, MIN(mi_idx.info) AS movie_votes, MIN(t.title) AS movie_title FROM cast_info AS ci, info_type AS it1, info_type AS it2, movie_info AS mi, movie_info_idx AS mi_idx, name AS n, title AS t WHERE ci.note  in ('(writer)', '(head writer)', '(written by)', '(story)', '(story editor)') AND it1.info  = 'genres' AND it2.info  = 'votes' AND mi.info  in ('Horror', 'Action', 'Sci-Fi', 'Thriller', 'Crime', 'War') AND n.gender  = 'm' AND t.id = mi.movie_id AND t.id = mi_idx.movie_id AND t.id = ci.movie_id AND ci.movie_id = mi.movie_id AND ci.movie_id = mi_idx.movie_id AND mi.movie_id = mi_idx.movie_id AND n.id = ci.person_id AND it1.id = mi.info_type_id AND it2.id = mi_idx.info_type_id;


-- imdbload_job19a.sql
-- 80.395
/*+ NestedLoop(n an ci rt t chn mc cn mi it)
 NestedLoop(n an ci rt t chn mc cn mi)
 NestedLoop(n an ci rt t chn mc cn)
 NestedLoop(n an ci rt t chn mc)
 NestedLoop(n an ci rt t chn)
 NestedLoop(n an ci rt t)
 HashJoin(n an ci rt)
 NestedLoop(n an ci)
 NestedLoop(n an)
 SeqScan(n)
 IndexOnlyScan(an)
 IndexScan(ci)
 SeqScan(rt)
 IndexScan(t)
 IndexOnlyScan(chn)
 IndexScan(mc)
 IndexScan(cn)
 IndexScan(mi)
 IndexScan(it)
 Leading((((((((((n an) ci) rt) t) chn) mc) cn) mi) it)) */
SELECT MIN(n.name) AS voicing_actress, MIN(t.title) AS voiced_movie FROM aka_name AS an, char_name AS chn, cast_info AS ci, company_name AS cn, info_type AS it, movie_companies AS mc, movie_info AS mi, name AS n, role_type AS rt, title AS t WHERE ci.note  in ('(voice)', '(voice: Japanese version)', '(voice) (uncredited)', '(voice: English version)') AND cn.country_code ='[us]' AND it.info  = 'release dates' AND mc.note  is not NULL and (mc.note like '%(USA)%' or mc.note like '%(worldwide)%') AND mi.info  is not null and (mi.info like 'Japan:%200%' or mi.info like 'USA:%200%') AND n.gender ='f' and n.name like '%Ang%' AND rt.role ='actress' AND t.production_year  between 2005 and 2009 AND t.id = mi.movie_id AND t.id = mc.movie_id AND t.id = ci.movie_id AND mc.movie_id = ci.movie_id AND mc.movie_id = mi.movie_id AND mi.movie_id = ci.movie_id AND cn.id = mc.company_id AND it.id = mi.info_type_id AND n.id = ci.person_id AND rt.id = ci.role_id AND n.id = an.person_id AND ci.person_id = an.person_id AND chn.id = ci.person_role_id;


-- imdbload_job19b.sql
-- 42.107
/*+ NestedLoop(t mc ci an chn cn mi it n rt)
 NestedLoop(t mc ci an chn cn mi it n)
 NestedLoop(t mc ci an chn cn mi it)
 NestedLoop(t mc ci an chn cn mi)
 NestedLoop(t mc ci an chn cn)
 NestedLoop(t mc ci an chn)
 NestedLoop(t mc ci an)
 NestedLoop(t mc ci)
 NestedLoop(t mc)
 SeqScan(t)
 IndexScan(mc)
 IndexScan(ci)
 IndexOnlyScan(an)
 IndexOnlyScan(chn)
 IndexScan(cn)
 IndexScan(mi)
 IndexScan(it)
 IndexScan(n)
 IndexScan(rt)
 Leading((((((((((t mc) ci) an) chn) cn) mi) it) n) rt)) */
SELECT MIN(n.name) AS voicing_actress, MIN(t.title) AS kung_fu_panda FROM aka_name AS an, char_name AS chn, cast_info AS ci, company_name AS cn, info_type AS it, movie_companies AS mc, movie_info AS mi, name AS n, role_type AS rt, title AS t WHERE ci.note  = '(voice)' AND cn.country_code ='[us]' AND it.info  = 'release dates' AND mc.note  like '%(200%)%' and (mc.note like '%(USA)%' or mc.note like '%(worldwide)%') AND mi.info  is not null and (mi.info like 'Japan:%2007%' or mi.info like 'USA:%2008%') AND n.gender ='f' and n.name like '%Angel%' AND rt.role ='actress' AND t.production_year  between 2007 and 2008 and t.title like '%Kung%Fu%Panda%' AND t.id = mi.movie_id AND t.id = mc.movie_id AND t.id = ci.movie_id AND mc.movie_id = ci.movie_id AND mc.movie_id = mi.movie_id AND mi.movie_id = ci.movie_id AND cn.id = mc.company_id AND it.id = mi.info_type_id AND n.id = ci.person_id AND rt.id = ci.role_id AND n.id = an.person_id AND ci.person_id = an.person_id AND chn.id = ci.person_role_id;


-- imdbload_job19c.sql
-- 634.551
/*+ NestedLoop(t rt ci n mi it mc cn an chn)
 NestedLoop(t rt ci n mi it mc cn an)
 NestedLoop(t rt ci n mi it mc cn)
 NestedLoop(t rt ci n mi it mc)
 HashJoin(t rt ci n mi it)
 NestedLoop(t rt ci n mi)
 NestedLoop(t rt ci n)
 HashJoin(t rt ci)
 NestedLoop(rt ci)
 SeqScan(t)
 SeqScan(rt)
 IndexScan(ci)
 IndexScan(n)
 IndexScan(mi)
 SeqScan(it)
 IndexScan(mc)
 IndexScan(cn)
 IndexOnlyScan(an)
 IndexOnlyScan(chn)
 Leading(((((((((t (rt ci)) n) mi) it) mc) cn) an) chn)) */
SELECT MIN(n.name) AS voicing_actress, MIN(t.title) AS jap_engl_voiced_movie FROM aka_name AS an, char_name AS chn, cast_info AS ci, company_name AS cn, info_type AS it, movie_companies AS mc, movie_info AS mi, name AS n, role_type AS rt, title AS t WHERE ci.note  in ('(voice)', '(voice: Japanese version)', '(voice) (uncredited)', '(voice: English version)') AND cn.country_code ='[us]' AND it.info  = 'release dates' AND mi.info  is not null and (mi.info like 'Japan:%200%' or mi.info like 'USA:%200%') AND n.gender ='f' and n.name like '%An%' AND rt.role ='actress' AND t.production_year  > 2000 AND t.id = mi.movie_id AND t.id = mc.movie_id AND t.id = ci.movie_id AND mc.movie_id = ci.movie_id AND mc.movie_id = mi.movie_id AND mi.movie_id = ci.movie_id AND cn.id = mc.company_id AND it.id = mi.info_type_id AND n.id = ci.person_id AND rt.id = ci.role_id AND n.id = an.person_id AND ci.person_id = an.person_id AND chn.id = ci.person_role_id;


-- imdbload_job19d.sql
-- 1636.623
/*+ NestedLoop(t rt ci n mi it chn mc cn an)
 NestedLoop(t rt ci n mi it chn mc cn)
 NestedLoop(t rt ci n mi it chn mc)
 NestedLoop(t rt ci n mi it chn)
 HashJoin(t rt ci n mi it)
 NestedLoop(t rt ci n mi)
 NestedLoop(t rt ci n)
 HashJoin(t rt ci)
 NestedLoop(rt ci)
 SeqScan(t)
 SeqScan(rt)
 IndexScan(ci)
 IndexScan(n)
 IndexScan(mi)
 SeqScan(it)
 IndexOnlyScan(chn)
 IndexScan(mc)
 IndexScan(cn)
 IndexOnlyScan(an)
 Leading(((((((((t (rt ci)) n) mi) it) chn) mc) cn) an)) */
SELECT MIN(n.name) AS voicing_actress, MIN(t.title) AS jap_engl_voiced_movie FROM aka_name AS an, char_name AS chn, cast_info AS ci, company_name AS cn, info_type AS it, movie_companies AS mc, movie_info AS mi, name AS n, role_type AS rt, title AS t WHERE ci.note  in ('(voice)', '(voice: Japanese version)', '(voice) (uncredited)', '(voice: English version)') AND cn.country_code ='[us]' AND it.info  = 'release dates' AND n.gender ='f' AND rt.role ='actress' AND t.production_year  > 2000 AND t.id = mi.movie_id AND t.id = mc.movie_id AND t.id = ci.movie_id AND mc.movie_id = ci.movie_id AND mc.movie_id = mi.movie_id AND mi.movie_id = ci.movie_id AND cn.id = mc.company_id AND it.id = mi.info_type_id AND n.id = ci.person_id AND rt.id = ci.role_id AND n.id = an.person_id AND ci.person_id = an.person_id AND chn.id = ci.person_role_id;


-- imdbload_job1a.sql
-- 36.169
/*+ NestedLoop(mi_idx it mc ct t)
 HashJoin(mi_idx it mc ct)
 NestedLoop(mi_idx it mc)
 HashJoin(mi_idx it)
 SeqScan(mi_idx)
 SeqScan(it)
 IndexScan(mc)
 SeqScan(ct)
 IndexScan(t)
 Leading(((((mi_idx it) mc) ct) t)) */
SELECT MIN(mc.note) AS production_note, MIN(t.title) AS movie_title, MIN(t.production_year) AS movie_year FROM company_type AS ct, info_type AS it, movie_companies AS mc, movie_info_idx AS mi_idx, title AS t WHERE ct.kind = 'production companies' AND it.info = 'top 250 rank' AND mc.note  not like '%(as Metro-Goldwyn-Mayer Pictures)%' AND (mc.note like '%(co-production)%' or mc.note like '%(presents)%') AND ct.id = mc.company_type_id AND t.id = mc.movie_id AND t.id = mi_idx.movie_id AND mc.movie_id = mi_idx.movie_id AND it.id = mi_idx.info_type_id;


-- imdbload_job1b.sql
-- 32.982
/*+ HashJoin(mi_idx it t mc ct)
 NestedLoop(mi_idx it t mc)
 NestedLoop(mi_idx it t)
 HashJoin(mi_idx it)
 SeqScan(mi_idx)
 SeqScan(it)
 IndexScan(t)
 IndexScan(mc)
 SeqScan(ct)
 Leading(((((mi_idx it) t) mc) ct)) */
SELECT MIN(mc.note) AS production_note, MIN(t.title) AS movie_title, MIN(t.production_year) AS movie_year FROM company_type AS ct, info_type AS it, movie_companies AS mc, movie_info_idx AS mi_idx, title AS t WHERE ct.kind = 'production companies' AND it.info = 'bottom 10 rank' AND mc.note  not like '%(as Metro-Goldwyn-Mayer Pictures)%' AND t.production_year between 2005 and 2010 AND ct.id = mc.company_type_id AND t.id = mc.movie_id AND t.id = mi_idx.movie_id AND mc.movie_id = mi_idx.movie_id AND it.id = mi_idx.info_type_id;


-- imdbload_job1c.sql
-- 34.998
/*+ NestedLoop(mi_idx it mc ct t)
 HashJoin(mi_idx it mc ct)
 NestedLoop(mi_idx it mc)
 HashJoin(mi_idx it)
 SeqScan(mi_idx)
 SeqScan(it)
 IndexScan(mc)
 SeqScan(ct)
 IndexScan(t)
 Leading(((((mi_idx it) mc) ct) t)) */
SELECT MIN(mc.note) AS production_note, MIN(t.title) AS movie_title, MIN(t.production_year) AS movie_year FROM company_type AS ct, info_type AS it, movie_companies AS mc, movie_info_idx AS mi_idx, title AS t WHERE ct.kind = 'production companies' AND it.info = 'top 250 rank' AND mc.note  not like '%(as Metro-Goldwyn-Mayer Pictures)%' and (mc.note like '%(co-production)%') AND t.production_year >2010 AND ct.id = mc.company_type_id AND t.id = mc.movie_id AND t.id = mi_idx.movie_id AND mc.movie_id = mi_idx.movie_id AND it.id = mi_idx.info_type_id;


-- imdbload_job1d.sql
-- 33.166
/*+ HashJoin(mi_idx it t mc ct)
 NestedLoop(mi_idx it t mc)
 NestedLoop(mi_idx it t)
 HashJoin(mi_idx it)
 SeqScan(mi_idx)
 SeqScan(it)
 IndexScan(t)
 IndexScan(mc)
 SeqScan(ct)
 Leading(((((mi_idx it) t) mc) ct)) */
SELECT MIN(mc.note) AS production_note, MIN(t.title) AS movie_title, MIN(t.production_year) AS movie_year FROM company_type AS ct, info_type AS it, movie_companies AS mc, movie_info_idx AS mi_idx, title AS t WHERE ct.kind = 'production companies' AND it.info = 'bottom 10 rank' AND mc.note  not like '%(as Metro-Goldwyn-Mayer Pictures)%' AND t.production_year >2000 AND ct.id = mc.company_type_id AND t.id = mc.movie_id AND t.id = mi_idx.movie_id AND mc.movie_id = mi_idx.movie_id AND it.id = mi_idx.info_type_id;


-- imdbload_job20a.sql
-- 1114.381
/*+ NestedLoop(kt cct2 cct1 k mk cc t ci chn n)
 NestedLoop(kt cct2 cct1 k mk cc t ci chn)
 NestedLoop(kt cct2 cct1 k mk cc t ci)
 NestedLoop(kt cct2 cct1 k mk cc t)
 NestedLoop(cct2 cct1 k mk cc t)
 NestedLoop(cct2 cct1 k mk cc)
 NestedLoop(cct1 k mk cc)
 NestedLoop(k mk cc)
 NestedLoop(k mk)
 SeqScan(kt)
 SeqScan(cct2)
 SeqScan(cct1)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(cc)
 IndexScan(t)
 IndexScan(ci)
 IndexScan(chn)
 IndexOnlyScan(n)
 Leading(((((kt ((cct2 (cct1 ((k mk) cc))) t)) ci) chn) n)) */
SELECT MIN(t.title) AS complete_downey_ironman_movie FROM complete_cast AS cc, comp_cast_type AS cct1, comp_cast_type AS cct2, char_name AS chn, cast_info AS ci, keyword AS k, kind_type AS kt, movie_keyword AS mk, name AS n, title AS t WHERE cct1.kind  = 'cast' AND cct2.kind  like '%complete%' AND chn.name  not like '%Sherlock%' and (chn.name like '%Tony%Stark%' or chn.name like '%Iron%Man%') AND k.keyword  in ('superhero', 'sequel', 'second-part', 'marvel-comics', 'based-on-comic', 'tv-special', 'fight', 'violence') AND kt.kind  = 'movie' AND t.production_year  > 1950 AND kt.id = t.kind_id AND t.id = mk.movie_id AND t.id = ci.movie_id AND t.id = cc.movie_id AND mk.movie_id = ci.movie_id AND mk.movie_id = cc.movie_id AND ci.movie_id = cc.movie_id AND chn.id = ci.person_role_id AND n.id = ci.person_id AND k.id = mk.keyword_id AND cct1.id = cc.subject_id AND cct2.id = cc.status_id;


-- imdbload_job20b.sql
-- 829.947
/*+ NestedLoop(cct2 cct1 kt k mk t cc ci n chn)
 NestedLoop(cct2 cct1 kt k mk t cc ci n)
 NestedLoop(cct2 cct1 kt k mk t cc ci)
 NestedLoop(cct2 cct1 kt k mk t cc)
 NestedLoop(cct1 kt k mk t cc)
 NestedLoop(kt k mk t cc)
 NestedLoop(kt k mk t)
 NestedLoop(k mk t)
 NestedLoop(k mk)
 SeqScan(cct2)
 SeqScan(cct1)
 SeqScan(kt)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(t)
 IndexScan(cc)
 IndexScan(ci)
 IndexScan(n)
 IndexScan(chn)
 Leading(((((cct2 (cct1 ((kt ((k mk) t)) cc))) ci) n) chn)) */
SELECT MIN(t.title) AS complete_downey_ironman_movie FROM complete_cast AS cc, comp_cast_type AS cct1, comp_cast_type AS cct2, char_name AS chn, cast_info AS ci, keyword AS k, kind_type AS kt, movie_keyword AS mk, name AS n, title AS t WHERE cct1.kind  = 'cast' AND cct2.kind  like '%complete%' AND chn.name  not like '%Sherlock%' and (chn.name like '%Tony%Stark%' or chn.name like '%Iron%Man%') AND k.keyword  in ('superhero', 'sequel', 'second-part', 'marvel-comics', 'based-on-comic', 'tv-special', 'fight', 'violence') AND kt.kind  = 'movie' AND n.name  LIKE '%Downey%Robert%' AND t.production_year  > 2000 AND kt.id = t.kind_id AND t.id = mk.movie_id AND t.id = ci.movie_id AND t.id = cc.movie_id AND mk.movie_id = ci.movie_id AND mk.movie_id = cc.movie_id AND ci.movie_id = cc.movie_id AND chn.id = ci.person_role_id AND n.id = ci.person_id AND k.id = mk.keyword_id AND cct1.id = cc.subject_id AND cct2.id = cc.status_id;


-- imdbload_job20c.sql
-- 413.017
/*+ NestedLoop(cct2 cct1 kt k mk t cc ci chn n)
 NestedLoop(cct2 cct1 kt k mk t cc ci chn)
 NestedLoop(cct2 cct1 kt k mk t cc ci)
 NestedLoop(cct2 cct1 kt k mk t cc)
 NestedLoop(cct1 kt k mk t cc)
 NestedLoop(kt k mk t cc)
 NestedLoop(kt k mk t)
 NestedLoop(k mk t)
 NestedLoop(k mk)
 SeqScan(cct2)
 SeqScan(cct1)
 SeqScan(kt)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(t)
 IndexScan(cc)
 IndexScan(ci)
 IndexScan(chn)
 IndexScan(n)
 Leading(((((cct2 (cct1 ((kt ((k mk) t)) cc))) ci) chn) n)) */
SELECT MIN(n.name) AS cast_member, MIN(t.title) AS complete_dynamic_hero_movie FROM complete_cast AS cc, comp_cast_type AS cct1, comp_cast_type AS cct2, char_name AS chn, cast_info AS ci, keyword AS k, kind_type AS kt, movie_keyword AS mk, name AS n, title AS t WHERE cct1.kind  = 'cast' AND cct2.kind  like '%complete%' AND chn.name  is not NULL and (chn.name like '%man%' or chn.name like '%Man%') AND k.keyword  in ('superhero', 'marvel-comics', 'based-on-comic', 'tv-special', 'fight', 'violence', 'magnet', 'web', 'claw', 'laser') AND kt.kind  = 'movie' AND t.production_year  > 2000 AND kt.id = t.kind_id AND t.id = mk.movie_id AND t.id = ci.movie_id AND t.id = cc.movie_id AND mk.movie_id = ci.movie_id AND mk.movie_id = cc.movie_id AND ci.movie_id = cc.movie_id AND chn.id = ci.person_role_id AND n.id = ci.person_id AND k.id = mk.keyword_id AND cct1.id = cc.subject_id AND cct2.id = cc.status_id;


-- imdbload_job21a.sql
-- 35.985
/*+ NestedLoop(lt k mk ml mi mc cn ct t)
 NestedLoop(lt k mk ml mi mc cn ct)
 NestedLoop(lt k mk ml mi mc cn)
 NestedLoop(lt k mk ml mi mc)
 NestedLoop(lt k mk ml mi)
 NestedLoop(lt k mk ml)
 NestedLoop(k mk ml)
 NestedLoop(k mk)
 SeqScan(lt)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(ml)
 IndexScan(mi)
 IndexScan(mc)
 IndexScan(cn)
 SeqScan(ct)
 IndexScan(t)
 Leading(((((((lt ((k mk) ml)) mi) mc) cn) ct) t)) */
SELECT MIN(cn.name) AS company_name, MIN(lt.link) AS link_type, MIN(t.title) AS western_follow_up FROM company_name AS cn, company_type AS ct, keyword AS k, link_type AS lt, movie_companies AS mc, movie_info AS mi, movie_keyword AS mk, movie_link AS ml, title AS t WHERE cn.country_code !='[pl]' AND (cn.name LIKE '%Film%' OR cn.name LIKE '%Warner%') AND ct.kind ='production companies' AND k.keyword ='sequel' AND lt.link LIKE '%follow%' AND mc.note IS NULL AND mi.info IN ('Sweden', 'Norway', 'Germany', 'Denmark', 'Swedish', 'Denish', 'Norwegian', 'German') AND t.production_year BETWEEN 1950 AND 2000 AND lt.id = ml.link_type_id AND ml.movie_id = t.id AND t.id = mk.movie_id AND mk.keyword_id = k.id AND t.id = mc.movie_id AND mc.company_type_id = ct.id AND mc.company_id = cn.id AND mi.movie_id = t.id AND ml.movie_id = mk.movie_id AND ml.movie_id = mc.movie_id AND mk.movie_id = mc.movie_id AND ml.movie_id = mi.movie_id AND mk.movie_id = mi.movie_id AND mc.movie_id = mi.movie_id;


-- imdbload_job21b.sql
-- 29.166
/*+ NestedLoop(lt k mk ml mi mc cn ct t)
 NestedLoop(lt k mk ml mi mc cn ct)
 NestedLoop(lt k mk ml mi mc cn)
 NestedLoop(lt k mk ml mi mc)
 NestedLoop(lt k mk ml mi)
 NestedLoop(lt k mk ml)
 NestedLoop(k mk ml)
 NestedLoop(k mk)
 SeqScan(lt)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(ml)
 IndexScan(mi)
 IndexScan(mc)
 IndexScan(cn)
 SeqScan(ct)
 IndexScan(t)
 Leading(((((((lt ((k mk) ml)) mi) mc) cn) ct) t)) */
SELECT MIN(cn.name) AS company_name, MIN(lt.link) AS link_type, MIN(t.title) AS german_follow_up FROM company_name AS cn, company_type AS ct, keyword AS k, link_type AS lt, movie_companies AS mc, movie_info AS mi, movie_keyword AS mk, movie_link AS ml, title AS t WHERE cn.country_code !='[pl]' AND (cn.name LIKE '%Film%' OR cn.name LIKE '%Warner%') AND ct.kind ='production companies' AND k.keyword ='sequel' AND lt.link LIKE '%follow%' AND mc.note IS NULL AND mi.info IN ('Germany', 'German') AND t.production_year BETWEEN 2000 AND 2010 AND lt.id = ml.link_type_id AND ml.movie_id = t.id AND t.id = mk.movie_id AND mk.keyword_id = k.id AND t.id = mc.movie_id AND mc.company_type_id = ct.id AND mc.company_id = cn.id AND mi.movie_id = t.id AND ml.movie_id = mk.movie_id AND ml.movie_id = mc.movie_id AND mk.movie_id = mc.movie_id AND ml.movie_id = mi.movie_id AND mk.movie_id = mi.movie_id AND mc.movie_id = mi.movie_id;


-- imdbload_job21c.sql
-- 31.385
/*+ NestedLoop(ct lt k mk ml mc cn mi t)
 NestedLoop(ct lt k mk ml mc cn mi)
 NestedLoop(ct lt k mk ml mc cn)
 NestedLoop(ct lt k mk ml mc)
 NestedLoop(lt k mk ml mc)
 NestedLoop(lt k mk ml)
 NestedLoop(k mk ml)
 NestedLoop(k mk)
 SeqScan(ct)
 SeqScan(lt)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(ml)
 IndexScan(mc)
 IndexScan(cn)
 IndexScan(mi)
 IndexScan(t)
 Leading(((((ct ((lt ((k mk) ml)) mc)) cn) mi) t)) */
SELECT MIN(cn.name) AS company_name, MIN(lt.link) AS link_type, MIN(t.title) AS western_follow_up FROM company_name AS cn, company_type AS ct, keyword AS k, link_type AS lt, movie_companies AS mc, movie_info AS mi, movie_keyword AS mk, movie_link AS ml, title AS t WHERE cn.country_code !='[pl]' AND (cn.name LIKE '%Film%' OR cn.name LIKE '%Warner%') AND ct.kind ='production companies' AND k.keyword ='sequel' AND lt.link LIKE '%follow%' AND mc.note IS NULL AND mi.info IN ('Sweden', 'Norway', 'Germany', 'Denmark', 'Swedish', 'Denish', 'Norwegian', 'German', 'English') AND t.production_year BETWEEN 1950 AND 2010 AND lt.id = ml.link_type_id AND ml.movie_id = t.id AND t.id = mk.movie_id AND mk.keyword_id = k.id AND t.id = mc.movie_id AND mc.company_type_id = ct.id AND mc.company_id = cn.id AND mi.movie_id = t.id AND ml.movie_id = mk.movie_id AND ml.movie_id = mc.movie_id AND mk.movie_id = mc.movie_id AND ml.movie_id = mi.movie_id AND mk.movie_id = mi.movie_id AND mc.movie_id = mi.movie_id;


-- imdbload_job22a.sql
-- 190.965
/*+ NestedLoop(it2 k mk t kt mi_idx mc cn ct mi it1)
 NestedLoop(it2 k mk t kt mi_idx mc cn ct mi)
 NestedLoop(it2 k mk t kt mi_idx mc cn ct)
 NestedLoop(it2 k mk t kt mi_idx mc cn)
 NestedLoop(it2 k mk t kt mi_idx mc)
 NestedLoop(it2 k mk t kt mi_idx)
 NestedLoop(k mk t kt mi_idx)
 NestedLoop(k mk t kt)
 NestedLoop(k mk t)
 NestedLoop(k mk)
 SeqScan(it2)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(t)
 SeqScan(kt)
 IndexScan(mi_idx)
 IndexScan(mc)
 IndexScan(cn)
 SeqScan(ct)
 IndexScan(mi)
 SeqScan(it1)
 Leading(((((((it2 ((((k mk) t) kt) mi_idx)) mc) cn) ct) mi) it1)) */
SELECT MIN(cn.name) AS movie_company, MIN(mi_idx.info) AS rating, MIN(t.title) AS western_violent_movie FROM company_name AS cn, company_type AS ct, info_type AS it1, info_type AS it2, keyword AS k, kind_type AS kt, movie_companies AS mc, movie_info AS mi, movie_info_idx AS mi_idx, movie_keyword AS mk, title AS t WHERE cn.country_code  != '[us]' AND it1.info  = 'countries' AND it2.info  = 'rating' AND k.keyword  in ('murder', 'murder-in-title', 'blood', 'violence') AND kt.kind  in ('movie', 'episode') AND mc.note  not like '%(USA)%' and mc.note like '%(200%)%' AND mi.info IN ('Germany', 'German', 'USA', 'American') AND mi_idx.info  < '7.0' AND t.production_year  > 2008 AND kt.id = t.kind_id AND t.id = mi.movie_id AND t.id = mk.movie_id AND t.id = mi_idx.movie_id AND t.id = mc.movie_id AND mk.movie_id = mi.movie_id AND mk.movie_id = mi_idx.movie_id AND mk.movie_id = mc.movie_id AND mi.movie_id = mi_idx.movie_id AND mi.movie_id = mc.movie_id AND mc.movie_id = mi_idx.movie_id AND k.id = mk.keyword_id AND it1.id = mi.info_type_id AND it2.id = mi_idx.info_type_id AND ct.id = mc.company_type_id AND cn.id = mc.company_id;


-- imdbload_job22b.sql
-- 113.189
/*+ NestedLoop(it2 k mk t kt mi_idx mc cn ct mi it1)
 NestedLoop(it2 k mk t kt mi_idx mc cn ct mi)
 NestedLoop(it2 k mk t kt mi_idx mc cn ct)
 NestedLoop(it2 k mk t kt mi_idx mc cn)
 NestedLoop(it2 k mk t kt mi_idx mc)
 NestedLoop(it2 k mk t kt mi_idx)
 NestedLoop(k mk t kt mi_idx)
 NestedLoop(k mk t kt)
 NestedLoop(k mk t)
 NestedLoop(k mk)
 SeqScan(it2)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(t)
 SeqScan(kt)
 IndexScan(mi_idx)
 IndexScan(mc)
 IndexScan(cn)
 SeqScan(ct)
 IndexScan(mi)
 SeqScan(it1)
 Leading(((((((it2 ((((k mk) t) kt) mi_idx)) mc) cn) ct) mi) it1)) */
SELECT MIN(cn.name) AS movie_company, MIN(mi_idx.info) AS rating, MIN(t.title) AS western_violent_movie FROM company_name AS cn, company_type AS ct, info_type AS it1, info_type AS it2, keyword AS k, kind_type AS kt, movie_companies AS mc, movie_info AS mi, movie_info_idx AS mi_idx, movie_keyword AS mk, title AS t WHERE cn.country_code  != '[us]' AND it1.info  = 'countries' AND it2.info  = 'rating' AND k.keyword  in ('murder', 'murder-in-title', 'blood', 'violence') AND kt.kind  in ('movie', 'episode') AND mc.note  not like '%(USA)%' and mc.note like '%(200%)%' AND mi.info IN ('Germany', 'German', 'USA', 'American') AND mi_idx.info  < '7.0' AND t.production_year  > 2009 AND kt.id = t.kind_id AND t.id = mi.movie_id AND t.id = mk.movie_id AND t.id = mi_idx.movie_id AND t.id = mc.movie_id AND mk.movie_id = mi.movie_id AND mk.movie_id = mi_idx.movie_id AND mk.movie_id = mc.movie_id AND mi.movie_id = mi_idx.movie_id AND mi.movie_id = mc.movie_id AND mc.movie_id = mi_idx.movie_id AND k.id = mk.keyword_id AND it1.id = mi.info_type_id AND it2.id = mi_idx.info_type_id AND ct.id = mc.company_type_id AND cn.id = mc.company_id;


-- imdbload_job22c.sql
-- 711.367
/*+ NestedLoop(it2 k mk t kt mi_idx mc cn ct mi it1)
 NestedLoop(it2 k mk t kt mi_idx mc cn ct mi)
 NestedLoop(it2 k mk t kt mi_idx mc cn ct)
 NestedLoop(it2 k mk t kt mi_idx mc cn)
 NestedLoop(it2 k mk t kt mi_idx mc)
 NestedLoop(it2 k mk t kt mi_idx)
 NestedLoop(k mk t kt mi_idx)
 NestedLoop(k mk t kt)
 NestedLoop(k mk t)
 NestedLoop(k mk)
 SeqScan(it2)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(t)
 SeqScan(kt)
 IndexScan(mi_idx)
 IndexScan(mc)
 IndexScan(cn)
 SeqScan(ct)
 IndexScan(mi)
 SeqScan(it1)
 Leading(((((((it2 ((((k mk) t) kt) mi_idx)) mc) cn) ct) mi) it1)) */
SELECT MIN(cn.name) AS movie_company, MIN(mi_idx.info) AS rating, MIN(t.title) AS western_violent_movie FROM company_name AS cn, company_type AS ct, info_type AS it1, info_type AS it2, keyword AS k, kind_type AS kt, movie_companies AS mc, movie_info AS mi, movie_info_idx AS mi_idx, movie_keyword AS mk, title AS t WHERE cn.country_code  != '[us]' AND it1.info  = 'countries' AND it2.info  = 'rating' AND k.keyword  in ('murder', 'murder-in-title', 'blood', 'violence') AND kt.kind  in ('movie', 'episode') AND mc.note  not like '%(USA)%' and mc.note like '%(200%)%' AND mi.info IN ('Sweden', 'Norway', 'Germany', 'Denmark', 'Swedish', 'Danish', 'Norwegian', 'German', 'USA', 'American') AND mi_idx.info  < '8.5' AND t.production_year  > 2005 AND kt.id = t.kind_id AND t.id = mi.movie_id AND t.id = mk.movie_id AND t.id = mi_idx.movie_id AND t.id = mc.movie_id AND mk.movie_id = mi.movie_id AND mk.movie_id = mi_idx.movie_id AND mk.movie_id = mc.movie_id AND mi.movie_id = mi_idx.movie_id AND mi.movie_id = mc.movie_id AND mc.movie_id = mi_idx.movie_id AND k.id = mk.keyword_id AND it1.id = mi.info_type_id AND it2.id = mi_idx.info_type_id AND ct.id = mc.company_type_id AND cn.id = mc.company_id;


-- imdbload_job22d.sql
-- 349.322
/*+ NestedLoop(it2 k mk t kt mi_idx mi it1 mc cn ct)
 NestedLoop(it2 k mk t kt mi_idx mi it1 mc cn)
 NestedLoop(it2 k mk t kt mi_idx mi it1 mc)
 NestedLoop(it2 k mk t kt mi_idx mi it1)
 NestedLoop(it2 k mk t kt mi_idx mi)
 NestedLoop(it2 k mk t kt mi_idx)
 NestedLoop(k mk t kt mi_idx)
 NestedLoop(k mk t kt)
 NestedLoop(k mk t)
 NestedLoop(k mk)
 SeqScan(it2)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(t)
 SeqScan(kt)
 IndexScan(mi_idx)
 IndexScan(mi)
 SeqScan(it1)
 IndexScan(mc)
 IndexScan(cn)
 SeqScan(ct)
 Leading(((((((it2 ((((k mk) t) kt) mi_idx)) mi) it1) mc) cn) ct)) */
SELECT MIN(cn.name) AS movie_company, MIN(mi_idx.info) AS rating, MIN(t.title) AS western_violent_movie FROM company_name AS cn, company_type AS ct, info_type AS it1, info_type AS it2, keyword AS k, kind_type AS kt, movie_companies AS mc, movie_info AS mi, movie_info_idx AS mi_idx, movie_keyword AS mk, title AS t WHERE cn.country_code  != '[us]' AND it1.info  = 'countries' AND it2.info  = 'rating' AND k.keyword  in ('murder', 'murder-in-title', 'blood', 'violence') AND kt.kind  in ('movie', 'episode') AND mi.info IN ('Sweden', 'Norway', 'Germany', 'Denmark', 'Swedish', 'Danish', 'Norwegian', 'German', 'USA', 'American') AND mi_idx.info  < '8.5' AND t.production_year  > 2005 AND kt.id = t.kind_id AND t.id = mi.movie_id AND t.id = mk.movie_id AND t.id = mi_idx.movie_id AND t.id = mc.movie_id AND mk.movie_id = mi.movie_id AND mk.movie_id = mi_idx.movie_id AND mk.movie_id = mc.movie_id AND mi.movie_id = mi_idx.movie_id AND mi.movie_id = mc.movie_id AND mc.movie_id = mi_idx.movie_id AND k.id = mk.keyword_id AND it1.id = mi.info_type_id AND it2.id = mi_idx.info_type_id AND ct.id = mc.company_type_id AND cn.id = mc.company_id;


-- imdbload_job23a.sql
-- 83.407
/*+ NestedLoop(t cc cct1 kt mi mc it1 cn ct mk k)
 NestedLoop(t cc cct1 kt mi mc it1 cn ct mk)
 NestedLoop(t cc cct1 kt mi mc it1 cn ct)
 NestedLoop(t cc cct1 kt mi mc it1 cn)
 NestedLoop(t cc cct1 kt mi mc it1)
 NestedLoop(t cc cct1 kt mi mc)
 NestedLoop(t cc cct1 kt mi)
 HashJoin(t cc cct1 kt)
 HashJoin(t cc cct1)
 HashJoin(cc cct1)
 SeqScan(t)
 SeqScan(cc)
 SeqScan(cct1)
 SeqScan(kt)
 IndexScan(mi)
 IndexScan(mc)
 IndexScan(it1)
 IndexScan(cn)
 IndexOnlyScan(ct)
 IndexScan(mk)
 IndexOnlyScan(k)
 Leading((((((((((t (cc cct1)) kt) mi) mc) it1) cn) ct) mk) k)) */
SELECT MIN(kt.kind) AS movie_kind, MIN(t.title) AS complete_us_internet_movie FROM complete_cast AS cc, comp_cast_type AS cct1, company_name AS cn, company_type AS ct, info_type AS it1, keyword AS k, kind_type AS kt, movie_companies AS mc, movie_info AS mi, movie_keyword AS mk, title AS t WHERE cct1.kind  = 'complete+verified' AND cn.country_code  = '[us]' AND it1.info  = 'release dates' AND kt.kind  in ('movie') AND mi.note  like '%internet%' AND mi.info  is not NULL and (mi.info like 'USA:% 199%' or mi.info like 'USA:% 200%') AND t.production_year  > 2000 AND kt.id = t.kind_id AND t.id = mi.movie_id AND t.id = mk.movie_id AND t.id = mc.movie_id AND t.id = cc.movie_id AND mk.movie_id = mi.movie_id AND mk.movie_id = mc.movie_id AND mk.movie_id = cc.movie_id AND mi.movie_id = mc.movie_id AND mi.movie_id = cc.movie_id AND mc.movie_id = cc.movie_id AND k.id = mk.keyword_id AND it1.id = mi.info_type_id AND cn.id = mc.company_id AND ct.id = mc.company_type_id AND cct1.id = cc.status_id;


-- imdbload_job23b.sql
-- 24.936
/*+ NestedLoop(cct1 kt k mk t cc mc cn ct mi it1)
 NestedLoop(cct1 kt k mk t cc mc cn ct mi)
 NestedLoop(cct1 kt k mk t cc mc cn ct)
 NestedLoop(cct1 kt k mk t cc mc cn)
 NestedLoop(cct1 kt k mk t cc mc)
 NestedLoop(cct1 kt k mk t cc)
 NestedLoop(kt k mk t cc)
 NestedLoop(kt k mk t)
 NestedLoop(k mk t)
 NestedLoop(k mk)
 SeqScan(cct1)
 SeqScan(kt)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(t)
 IndexScan(cc)
 IndexScan(mc)
 IndexScan(cn)
 SeqScan(ct)
 IndexScan(mi)
 SeqScan(it1)
 Leading(((((((cct1 ((kt ((k mk) t)) cc)) mc) cn) ct) mi) it1)) */
SELECT MIN(kt.kind) AS movie_kind, MIN(t.title) AS complete_nerdy_internet_movie FROM complete_cast AS cc, comp_cast_type AS cct1, company_name AS cn, company_type AS ct, info_type AS it1, keyword AS k, kind_type AS kt, movie_companies AS mc, movie_info AS mi, movie_keyword AS mk, title AS t WHERE cct1.kind  = 'complete+verified' AND cn.country_code  = '[us]' AND it1.info  = 'release dates' AND k.keyword  in ('nerd', 'loner', 'alienation', 'dignity') AND kt.kind  in ('movie') AND mi.note  like '%internet%' AND mi.info  like 'USA:% 200%' AND t.production_year  > 2000 AND kt.id = t.kind_id AND t.id = mi.movie_id AND t.id = mk.movie_id AND t.id = mc.movie_id AND t.id = cc.movie_id AND mk.movie_id = mi.movie_id AND mk.movie_id = mc.movie_id AND mk.movie_id = cc.movie_id AND mi.movie_id = mc.movie_id AND mi.movie_id = cc.movie_id AND mc.movie_id = cc.movie_id AND k.id = mk.keyword_id AND it1.id = mi.info_type_id AND cn.id = mc.company_id AND ct.id = mc.company_type_id AND cct1.id = cc.status_id;


-- imdbload_job23c.sql
-- 110.102
/*+ NestedLoop(t cc cct1 kt mi it1 mk mc cn ct k)
 NestedLoop(t cc cct1 kt mi it1 mk mc cn ct)
 NestedLoop(t cc cct1 kt mi it1 mk mc cn)
 NestedLoop(t cc cct1 kt mi it1 mk mc)
 NestedLoop(t cc cct1 kt mi it1 mk)
 NestedLoop(t cc cct1 kt mi it1)
 NestedLoop(t cc cct1 kt mi)
 HashJoin(t cc cct1 kt)
 HashJoin(t cc cct1)
 HashJoin(cc cct1)
 SeqScan(t)
 SeqScan(cc)
 SeqScan(cct1)
 SeqScan(kt)
 IndexScan(mi)
 IndexScan(it1)
 IndexScan(mk)
 IndexScan(mc)
 IndexScan(cn)
 IndexOnlyScan(ct)
 IndexOnlyScan(k)
 Leading((((((((((t (cc cct1)) kt) mi) it1) mk) mc) cn) ct) k)) */
SELECT MIN(kt.kind) AS movie_kind, MIN(t.title) AS complete_us_internet_movie FROM complete_cast AS cc, comp_cast_type AS cct1, company_name AS cn, company_type AS ct, info_type AS it1, keyword AS k, kind_type AS kt, movie_companies AS mc, movie_info AS mi, movie_keyword AS mk, title AS t WHERE cct1.kind  = 'complete+verified' AND cn.country_code  = '[us]' AND it1.info  = 'release dates' AND kt.kind  in ('movie', 'tv movie', 'video movie', 'video game') AND mi.note  like '%internet%' AND mi.info  is not NULL and (mi.info like 'USA:% 199%' or mi.info like 'USA:% 200%') AND t.production_year  > 1990 AND kt.id = t.kind_id AND t.id = mi.movie_id AND t.id = mk.movie_id AND t.id = mc.movie_id AND t.id = cc.movie_id AND mk.movie_id = mi.movie_id AND mk.movie_id = mc.movie_id AND mk.movie_id = cc.movie_id AND mi.movie_id = mc.movie_id AND mi.movie_id = cc.movie_id AND mc.movie_id = cc.movie_id AND k.id = mk.keyword_id AND it1.id = mi.info_type_id AND cn.id = mc.company_id AND ct.id = mc.company_type_id AND cct1.id = cc.status_id;


-- imdbload_job24a.sql
-- 200.587
/*+ NestedLoop(it k mk t mi ci mc cn an chn n rt)
 NestedLoop(it k mk t mi ci mc cn an chn n)
 NestedLoop(it k mk t mi ci mc cn an chn)
 NestedLoop(it k mk t mi ci mc cn an)
 NestedLoop(it k mk t mi ci mc cn)
 NestedLoop(it k mk t mi ci mc)
 NestedLoop(it k mk t mi ci)
 NestedLoop(it k mk t mi)
 NestedLoop(k mk t mi)
 NestedLoop(k mk t)
 NestedLoop(k mk)
 SeqScan(it)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(t)
 IndexScan(mi)
 IndexScan(ci)
 IndexScan(mc)
 IndexScan(cn)
 IndexOnlyScan(an)
 IndexScan(chn)
 IndexScan(n)
 SeqScan(rt)
 Leading(((((((((it (((k mk) t) mi)) ci) mc) cn) an) chn) n) rt)) */
SELECT MIN(chn.name) AS voiced_char_name, MIN(n.name) AS voicing_actress_name, MIN(t.title) AS voiced_action_movie_jap_eng FROM aka_name AS an, char_name AS chn, cast_info AS ci, company_name AS cn, info_type AS it, keyword AS k, movie_companies AS mc, movie_info AS mi, movie_keyword AS mk, name AS n, role_type AS rt, title AS t WHERE ci.note  in ('(voice)', '(voice: Japanese version)', '(voice) (uncredited)', '(voice: English version)') AND cn.country_code ='[us]' AND it.info  = 'release dates' AND k.keyword  in ('hero', 'martial-arts', 'hand-to-hand-combat') AND mi.info  is not null and (mi.info like 'Japan:%201%' or mi.info like 'USA:%201%') AND n.gender ='f' and n.name like '%An%' AND rt.role ='actress' AND t.production_year  > 2010 AND t.id = mi.movie_id AND t.id = mc.movie_id AND t.id = ci.movie_id AND t.id = mk.movie_id AND mc.movie_id = ci.movie_id AND mc.movie_id = mi.movie_id AND mc.movie_id = mk.movie_id AND mi.movie_id = ci.movie_id AND mi.movie_id = mk.movie_id AND ci.movie_id = mk.movie_id AND cn.id = mc.company_id AND it.id = mi.info_type_id AND n.id = ci.person_id AND rt.id = ci.role_id AND n.id = an.person_id AND ci.person_id = an.person_id AND chn.id = ci.person_role_id AND k.id = mk.keyword_id;


-- imdbload_job24b.sql
-- 93.464
/*+ NestedLoop(cn mc t mk ci an chn mi it k n rt)
 NestedLoop(cn mc t mk ci an chn mi it k n)
 NestedLoop(cn mc t mk ci an chn mi it k)
 NestedLoop(cn mc t mk ci an chn mi it)
 NestedLoop(cn mc t mk ci an chn mi)
 NestedLoop(cn mc t mk ci an chn)
 NestedLoop(cn mc t mk ci an)
 NestedLoop(cn mc t mk ci)
 NestedLoop(cn mc t mk)
 NestedLoop(cn mc t)
 NestedLoop(cn mc)
 SeqScan(cn)
 IndexScan(mc)
 IndexScan(t)
 IndexScan(mk)
 IndexScan(ci)
 IndexOnlyScan(an)
 IndexScan(chn)
 IndexScan(mi)
 IndexScan(it)
 IndexScan(k)
 IndexScan(n)
 IndexScan(rt)
 Leading((((((((((((cn mc) t) mk) ci) an) chn) mi) it) k) n) rt)) */
SELECT MIN(chn.name) AS voiced_char_name, MIN(n.name) AS voicing_actress_name, MIN(t.title) AS kung_fu_panda FROM aka_name AS an, char_name AS chn, cast_info AS ci, company_name AS cn, info_type AS it, keyword AS k, movie_companies AS mc, movie_info AS mi, movie_keyword AS mk, name AS n, role_type AS rt, title AS t WHERE ci.note  in ('(voice)', '(voice: Japanese version)', '(voice) (uncredited)', '(voice: English version)') AND cn.country_code ='[us]' AND cn.name  = 'DreamWorks Animation' AND it.info  = 'release dates' AND k.keyword  in ('hero', 'martial-arts', 'hand-to-hand-combat', 'computer-animated-movie') AND mi.info  is not null and (mi.info like 'Japan:%201%' or mi.info like 'USA:%201%') AND n.gender ='f' and n.name like '%An%' AND rt.role ='actress' AND t.production_year  > 2010 AND t.title like 'Kung Fu Panda%' AND t.id = mi.movie_id AND t.id = mc.movie_id AND t.id = ci.movie_id AND t.id = mk.movie_id AND mc.movie_id = ci.movie_id AND mc.movie_id = mi.movie_id AND mc.movie_id = mk.movie_id AND mi.movie_id = ci.movie_id AND mi.movie_id = mk.movie_id AND ci.movie_id = mk.movie_id AND cn.id = mc.company_id AND it.id = mi.info_type_id AND n.id = ci.person_id AND rt.id = ci.role_id AND n.id = an.person_id AND ci.person_id = an.person_id AND chn.id = ci.person_role_id AND k.id = mk.keyword_id;


-- imdbload_job25a.sql
-- 801.743
/*+ NestedLoop(k mk mi_idx it2 mi ci it1 n t)
 NestedLoop(k mk mi_idx it2 mi ci it1 n)
 NestedLoop(k mk mi_idx it2 mi ci it1)
 NestedLoop(k mk mi_idx it2 mi ci)
 NestedLoop(k mk mi_idx it2 mi)
 HashJoin(k mk mi_idx it2)
 NestedLoop(k mk mi_idx)
 NestedLoop(k mk)
 IndexScan(k)
 IndexScan(mk)
 IndexScan(mi_idx)
 SeqScan(it2)
 IndexScan(mi)
 IndexScan(ci)
 IndexScan(it1)
 IndexScan(n)
 IndexScan(t)
 Leading(((((((((k mk) mi_idx) it2) mi) ci) it1) n) t)) */
SELECT MIN(mi.info) AS movie_budget, MIN(mi_idx.info) AS movie_votes, MIN(n.name) AS male_writer, MIN(t.title) AS violent_movie_title FROM cast_info AS ci, info_type AS it1, info_type AS it2, keyword AS k, movie_info AS mi, movie_info_idx AS mi_idx, movie_keyword AS mk, name AS n, title AS t WHERE ci.note  in ('(writer)', '(head writer)', '(written by)', '(story)', '(story editor)') AND it1.info  = 'genres' AND it2.info  = 'votes' AND k.keyword  in ('murder', 'blood', 'gore', 'death', 'female-nudity') AND mi.info  = 'Horror' AND n.gender  = 'm' AND t.id = mi.movie_id AND t.id = mi_idx.movie_id AND t.id = ci.movie_id AND t.id = mk.movie_id AND ci.movie_id = mi.movie_id AND ci.movie_id = mi_idx.movie_id AND ci.movie_id = mk.movie_id AND mi.movie_id = mi_idx.movie_id AND mi.movie_id = mk.movie_id AND mi_idx.movie_id = mk.movie_id AND n.id = ci.person_id AND it1.id = mi.info_type_id AND it2.id = mi_idx.info_type_id AND k.id = mk.keyword_id;


-- imdbload_job25b.sql
-- 83.031
/*+ NestedLoop(k mk t ci mi it1 mi_idx it2 n)
 NestedLoop(k mk t ci mi it1 mi_idx it2)
 NestedLoop(k mk t ci mi it1 mi_idx)
 NestedLoop(k mk t ci mi it1)
 NestedLoop(k mk t ci mi)
 NestedLoop(k mk t ci)
 NestedLoop(k mk t)
 NestedLoop(k mk)
 IndexScan(k)
 IndexScan(mk)
 IndexScan(t)
 IndexScan(ci)
 IndexScan(mi)
 IndexScan(it1)
 IndexScan(mi_idx)
 IndexScan(it2)
 IndexScan(n)
 Leading(((((((((k mk) t) ci) mi) it1) mi_idx) it2) n)) */
SELECT MIN(mi.info) AS movie_budget, MIN(mi_idx.info) AS movie_votes, MIN(n.name) AS male_writer, MIN(t.title) AS violent_movie_title FROM cast_info AS ci, info_type AS it1, info_type AS it2, keyword AS k, movie_info AS mi, movie_info_idx AS mi_idx, movie_keyword AS mk, name AS n, title AS t WHERE ci.note  in ('(writer)', '(head writer)', '(written by)', '(story)', '(story editor)') AND it1.info  = 'genres' AND it2.info  = 'votes' AND k.keyword  in ('murder', 'blood', 'gore', 'death', 'female-nudity') AND mi.info  = 'Horror' AND n.gender   = 'm' AND t.production_year  > 2010 AND t.title  like 'Vampire%' AND t.id = mi.movie_id AND t.id = mi_idx.movie_id AND t.id = ci.movie_id AND t.id = mk.movie_id AND ci.movie_id = mi.movie_id AND ci.movie_id = mi_idx.movie_id AND ci.movie_id = mk.movie_id AND mi.movie_id = mi_idx.movie_id AND mi.movie_id = mk.movie_id AND mi_idx.movie_id = mk.movie_id AND n.id = ci.person_id AND it1.id = mi.info_type_id AND it2.id = mi_idx.info_type_id AND k.id = mk.keyword_id;


-- imdbload_job25c.sql
-- 2307.976
/*+ NestedLoop(k mk mi_idx it2 mi it1 ci n t)
 NestedLoop(k mk mi_idx it2 mi it1 ci n)
 NestedLoop(k mk mi_idx it2 mi it1 ci)
 NestedLoop(k mk mi_idx it2 mi it1)
 NestedLoop(k mk mi_idx it2 mi)
 HashJoin(k mk mi_idx it2)
 NestedLoop(k mk mi_idx)
 NestedLoop(k mk)
 IndexScan(k)
 IndexScan(mk)
 IndexScan(mi_idx)
 SeqScan(it2)
 IndexScan(mi)
 IndexScan(it1)
 IndexScan(ci)
 IndexScan(n)
 IndexScan(t)
 Leading(((((((((k mk) mi_idx) it2) mi) it1) ci) n) t)) */
SELECT MIN(mi.info) AS movie_budget, MIN(mi_idx.info) AS movie_votes, MIN(n.name) AS male_writer, MIN(t.title) AS violent_movie_title FROM cast_info AS ci, info_type AS it1, info_type AS it2, keyword AS k, movie_info AS mi, movie_info_idx AS mi_idx, movie_keyword AS mk, name AS n, title AS t WHERE ci.note  in ('(writer)', '(head writer)', '(written by)', '(story)', '(story editor)') AND it1.info  = 'genres' AND it2.info  = 'votes' AND k.keyword  in ('murder', 'violence', 'blood', 'gore', 'death', 'female-nudity', 'hospital') AND mi.info  in ('Horror', 'Action', 'Sci-Fi', 'Thriller', 'Crime', 'War') AND n.gender   = 'm' AND t.id = mi.movie_id AND t.id = mi_idx.movie_id AND t.id = ci.movie_id AND t.id = mk.movie_id AND ci.movie_id = mi.movie_id AND ci.movie_id = mi_idx.movie_id AND ci.movie_id = mk.movie_id AND mi.movie_id = mi_idx.movie_id AND mi.movie_id = mk.movie_id AND mi_idx.movie_id = mk.movie_id AND n.id = ci.person_id AND it1.id = mi.info_type_id AND it2.id = mi_idx.info_type_id AND k.id = mk.keyword_id;


-- imdbload_job26a.sql
-- 597.449
/*+ NestedLoop(kt it2 cct1 cc cct2 mi_idx t ci chn mk k n)
 NestedLoop(kt it2 cct1 cc cct2 mi_idx t ci chn mk k)
 NestedLoop(kt it2 cct1 cc cct2 mi_idx t ci chn mk)
 NestedLoop(kt it2 cct1 cc cct2 mi_idx t ci chn)
 NestedLoop(kt it2 cct1 cc cct2 mi_idx t ci)
 NestedLoop(kt it2 cct1 cc cct2 mi_idx t)
 NestedLoop(it2 cct1 cc cct2 mi_idx t)
 NestedLoop(it2 cct1 cc cct2 mi_idx)
 NestedLoop(cct1 cc cct2 mi_idx)
 HashJoin(cct1 cc cct2)
 NestedLoop(cct1 cc)
 SeqScan(kt)
 SeqScan(it2)
 SeqScan(cct1)
 IndexScan(cc)
 SeqScan(cct2)
 IndexScan(mi_idx)
 IndexScan(t)
 IndexScan(ci)
 IndexScan(chn)
 IndexScan(mk)
 IndexScan(k)
 IndexScan(n)
 Leading(((((((kt ((it2 (((cct1 cc) cct2) mi_idx)) t)) ci) chn) mk) k) n)) */
SELECT MIN(chn.name) AS character_name, MIN(mi_idx.info) AS rating, MIN(n.name) AS playing_actor, MIN(t.title) AS complete_hero_movie FROM complete_cast AS cc, comp_cast_type AS cct1, comp_cast_type AS cct2, char_name AS chn, cast_info AS ci, info_type AS it2, keyword AS k, kind_type AS kt, movie_info_idx AS mi_idx, movie_keyword AS mk, name AS n, title AS t WHERE cct1.kind  = 'cast' AND cct2.kind  like '%complete%' AND chn.name  is not NULL and (chn.name like '%man%' or chn.name like '%Man%') AND it2.info  = 'rating' AND k.keyword  in ('superhero', 'marvel-comics', 'based-on-comic', 'tv-special', 'fight', 'violence', 'magnet', 'web', 'claw', 'laser') AND kt.kind  = 'movie' AND mi_idx.info  > '7.0' AND t.production_year  > 2000 AND kt.id = t.kind_id AND t.id = mk.movie_id AND t.id = ci.movie_id AND t.id = cc.movie_id AND t.id = mi_idx.movie_id AND mk.movie_id = ci.movie_id AND mk.movie_id = cc.movie_id AND mk.movie_id = mi_idx.movie_id AND ci.movie_id = cc.movie_id AND ci.movie_id = mi_idx.movie_id AND cc.movie_id = mi_idx.movie_id AND chn.id = ci.person_role_id AND n.id = ci.person_id AND k.id = mk.keyword_id AND cct1.id = cc.subject_id AND cct2.id = cc.status_id AND it2.id = mi_idx.info_type_id;


-- imdbload_job26b.sql
-- 75.03
/*+ NestedLoop(it2 k mk mi_idx cc cct1 cct2 ci chn n t kt)
 NestedLoop(it2 k mk mi_idx cc cct1 cct2 ci chn n t)
 NestedLoop(it2 k mk mi_idx cc cct1 cct2 ci chn n)
 NestedLoop(it2 k mk mi_idx cc cct1 cct2 ci chn)
 NestedLoop(it2 k mk mi_idx cc cct1 cct2 ci)
 NestedLoop(it2 k mk mi_idx cc cct1 cct2)
 NestedLoop(it2 k mk mi_idx cc cct1)
 NestedLoop(it2 k mk mi_idx cc)
 NestedLoop(it2 k mk mi_idx)
 NestedLoop(k mk mi_idx)
 NestedLoop(k mk)
 SeqScan(it2)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(mi_idx)
 IndexScan(cc)
 SeqScan(cct1)
 SeqScan(cct2)
 IndexScan(ci)
 IndexScan(chn)
 IndexOnlyScan(n)
 IndexScan(t)
 SeqScan(kt)
 Leading((((((((((it2 ((k mk) mi_idx)) cc) cct1) cct2) ci) chn) n) t) kt)) */
SELECT MIN(chn.name) AS character_name, MIN(mi_idx.info) AS rating, MIN(t.title) AS complete_hero_movie FROM complete_cast AS cc, comp_cast_type AS cct1, comp_cast_type AS cct2, char_name AS chn, cast_info AS ci, info_type AS it2, keyword AS k, kind_type AS kt, movie_info_idx AS mi_idx, movie_keyword AS mk, name AS n, title AS t WHERE cct1.kind  = 'cast' AND cct2.kind  like '%complete%' AND chn.name  is not NULL and (chn.name like '%man%' or chn.name like '%Man%') AND it2.info  = 'rating' AND k.keyword  in ('superhero', 'marvel-comics', 'based-on-comic', 'fight') AND kt.kind  = 'movie' AND mi_idx.info  > '8.0' AND t.production_year  > 2005 AND kt.id = t.kind_id AND t.id = mk.movie_id AND t.id = ci.movie_id AND t.id = cc.movie_id AND t.id = mi_idx.movie_id AND mk.movie_id = ci.movie_id AND mk.movie_id = cc.movie_id AND mk.movie_id = mi_idx.movie_id AND ci.movie_id = cc.movie_id AND ci.movie_id = mi_idx.movie_id AND cc.movie_id = mi_idx.movie_id AND chn.id = ci.person_role_id AND n.id = ci.person_id AND k.id = mk.keyword_id AND cct1.id = cc.subject_id AND cct2.id = cc.status_id AND it2.id = mi_idx.info_type_id;


-- imdbload_job26c.sql
-- 1722.15
/*+ NestedLoop(kt cct1 cc cct2 mi_idx it2 t ci chn mk k n)
 NestedLoop(kt cct1 cc cct2 mi_idx it2 t ci chn mk k)
 NestedLoop(kt cct1 cc cct2 mi_idx it2 t ci chn mk)
 NestedLoop(kt cct1 cc cct2 mi_idx it2 t ci chn)
 NestedLoop(kt cct1 cc cct2 mi_idx it2 t ci)
 NestedLoop(kt cct1 cc cct2 mi_idx it2 t)
 NestedLoop(cct1 cc cct2 mi_idx it2 t)
 HashJoin(cct1 cc cct2 mi_idx it2)
 NestedLoop(cct1 cc cct2 mi_idx)
 HashJoin(cct1 cc cct2)
 NestedLoop(cct1 cc)
 SeqScan(kt)
 SeqScan(cct1)
 IndexScan(cc)
 SeqScan(cct2)
 IndexScan(mi_idx)
 SeqScan(it2)
 IndexScan(t)
 IndexScan(ci)
 IndexScan(chn)
 IndexScan(mk)
 IndexScan(k)
 IndexOnlyScan(n)
 Leading(((((((kt (((((cct1 cc) cct2) mi_idx) it2) t)) ci) chn) mk) k) n)) */
SELECT MIN(chn.name) AS character_name, MIN(mi_idx.info) AS rating, MIN(t.title) AS complete_hero_movie FROM complete_cast AS cc, comp_cast_type AS cct1, comp_cast_type AS cct2, char_name AS chn, cast_info AS ci, info_type AS it2, keyword AS k, kind_type AS kt, movie_info_idx AS mi_idx, movie_keyword AS mk, name AS n, title AS t WHERE cct1.kind  = 'cast' AND cct2.kind  like '%complete%' AND chn.name  is not NULL and (chn.name like '%man%' or chn.name like '%Man%') AND it2.info  = 'rating' AND k.keyword  in ('superhero', 'marvel-comics', 'based-on-comic', 'tv-special', 'fight', 'violence', 'magnet', 'web', 'claw', 'laser') AND kt.kind  = 'movie' AND t.production_year  > 2000 AND kt.id = t.kind_id AND t.id = mk.movie_id AND t.id = ci.movie_id AND t.id = cc.movie_id AND t.id = mi_idx.movie_id AND mk.movie_id = ci.movie_id AND mk.movie_id = cc.movie_id AND mk.movie_id = mi_idx.movie_id AND ci.movie_id = cc.movie_id AND ci.movie_id = mi_idx.movie_id AND cc.movie_id = mi_idx.movie_id AND chn.id = ci.person_role_id AND n.id = ci.person_id AND k.id = mk.keyword_id AND cct1.id = cc.subject_id AND cct2.id = cc.status_id AND it2.id = mi_idx.info_type_id;


-- imdbload_job27a.sql
-- 10.683
/*+ NestedLoop(cc ml lt cct2 cct1 mc ct cn t mi mk k)
 NestedLoop(cc ml lt cct2 cct1 mc ct cn t mi mk)
 NestedLoop(cc ml lt cct2 cct1 mc ct cn t mi)
 NestedLoop(cc ml lt cct2 cct1 mc ct cn t)
 NestedLoop(cc ml lt cct2 cct1 mc ct cn)
 HashJoin(cc ml lt cct2 cct1 mc ct)
 NestedLoop(cc ml lt cct2 cct1 mc)
 HashJoin(cc ml lt cct2 cct1)
 HashJoin(cc ml lt cct2)
 MergeJoin(cc ml lt)
 HashJoin(ml lt)
 IndexScan(cc)
 SeqScan(ml)
 SeqScan(lt)
 SeqScan(cct2)
 SeqScan(cct1)
 IndexScan(mc)
 SeqScan(ct)
 IndexScan(cn)
 IndexScan(t)
 IndexScan(mi)
 IndexScan(mk)
 IndexScan(k)
 Leading(((((((((((cc (ml lt)) cct2) cct1) mc) ct) cn) t) mi) mk) k)) */
SELECT MIN(cn.name) AS producing_company, MIN(lt.link) AS link_type, MIN(t.title) AS complete_western_sequel FROM complete_cast AS cc, comp_cast_type AS cct1, comp_cast_type AS cct2, company_name AS cn, company_type AS ct, keyword AS k, link_type AS lt, movie_companies AS mc, movie_info AS mi, movie_keyword AS mk, movie_link AS ml, title AS t WHERE cct1.kind  in ('cast', 'crew') AND cct2.kind  = 'complete' AND cn.country_code !='[pl]' AND (cn.name LIKE '%Film%' OR cn.name LIKE '%Warner%') AND ct.kind ='production companies' AND k.keyword ='sequel' AND lt.link LIKE '%follow%' AND mc.note IS NULL AND mi.info IN ('Sweden', 'Germany','Swedish', 'German') AND t.production_year BETWEEN 1950 AND 2000 AND lt.id = ml.link_type_id AND ml.movie_id = t.id AND t.id = mk.movie_id AND mk.keyword_id = k.id AND t.id = mc.movie_id AND mc.company_type_id = ct.id AND mc.company_id = cn.id AND mi.movie_id = t.id AND t.id = cc.movie_id AND cct1.id = cc.subject_id AND cct2.id = cc.status_id AND ml.movie_id = mk.movie_id AND ml.movie_id = mc.movie_id AND mk.movie_id = mc.movie_id AND ml.movie_id = mi.movie_id AND mk.movie_id = mi.movie_id AND mc.movie_id = mi.movie_id AND ml.movie_id = cc.movie_id AND mk.movie_id = cc.movie_id AND mc.movie_id = cc.movie_id AND mi.movie_id = cc.movie_id;


-- imdbload_job27b.sql
-- 6.532
/*+ NestedLoop(cc ml lt cct2 cct1 mc ct t cn mi mk k)
 NestedLoop(cc ml lt cct2 cct1 mc ct t cn mi mk)
 NestedLoop(cc ml lt cct2 cct1 mc ct t cn mi)
 NestedLoop(cc ml lt cct2 cct1 mc ct t cn)
 NestedLoop(cc ml lt cct2 cct1 mc ct t)
 HashJoin(cc ml lt cct2 cct1 mc ct)
 NestedLoop(cc ml lt cct2 cct1 mc)
 HashJoin(cc ml lt cct2 cct1)
 HashJoin(cc ml lt cct2)
 MergeJoin(cc ml lt)
 HashJoin(ml lt)
 IndexScan(cc)
 SeqScan(ml)
 SeqScan(lt)
 SeqScan(cct2)
 SeqScan(cct1)
 IndexScan(mc)
 SeqScan(ct)
 IndexScan(t)
 IndexScan(cn)
 IndexScan(mi)
 IndexScan(mk)
 IndexScan(k)
 Leading(((((((((((cc (ml lt)) cct2) cct1) mc) ct) t) cn) mi) mk) k)) */
SELECT MIN(cn.name) AS producing_company, MIN(lt.link) AS link_type, MIN(t.title) AS complete_western_sequel FROM complete_cast AS cc, comp_cast_type AS cct1, comp_cast_type AS cct2, company_name AS cn, company_type AS ct, keyword AS k, link_type AS lt, movie_companies AS mc, movie_info AS mi, movie_keyword AS mk, movie_link AS ml, title AS t WHERE cct1.kind  in ('cast', 'crew') AND cct2.kind  = 'complete' AND cn.country_code !='[pl]' AND (cn.name LIKE '%Film%' OR cn.name LIKE '%Warner%') AND ct.kind ='production companies' AND k.keyword ='sequel' AND lt.link LIKE '%follow%' AND mc.note IS NULL AND mi.info IN ('Sweden', 'Germany','Swedish', 'German') AND t.production_year  = 1998 AND lt.id = ml.link_type_id AND ml.movie_id = t.id AND t.id = mk.movie_id AND mk.keyword_id = k.id AND t.id = mc.movie_id AND mc.company_type_id = ct.id AND mc.company_id = cn.id AND mi.movie_id = t.id AND t.id = cc.movie_id AND cct1.id = cc.subject_id AND cct2.id = cc.status_id AND ml.movie_id = mk.movie_id AND ml.movie_id = mc.movie_id AND mk.movie_id = mc.movie_id AND ml.movie_id = mi.movie_id AND mk.movie_id = mi.movie_id AND mc.movie_id = mi.movie_id AND ml.movie_id = cc.movie_id AND mk.movie_id = cc.movie_id AND mc.movie_id = cc.movie_id AND mi.movie_id = cc.movie_id;


-- imdbload_job27c.sql
-- 16.073
/*+ NestedLoop(cc cct1 cct2 mc ct cn mk ml lt k mi t)
 NestedLoop(cc cct1 cct2 mc ct cn mk ml lt k mi)
 NestedLoop(cc cct1 cct2 mc ct cn mk ml lt k)
 MergeJoin(cc cct1 cct2 mc ct cn mk ml lt)
 HashJoin(ml lt)
 NestedLoop(cc cct1 cct2 mc ct cn mk)
 NestedLoop(cc cct1 cct2 mc ct cn)
 NestedLoop(cc cct1 cct2 mc ct)
 NestedLoop(cc cct1 cct2 mc)
 NestedLoop(cc cct1 cct2)
 NestedLoop(cc cct1)
 IndexScan(cc)
 SeqScan(cct1)
 SeqScan(cct2)
 IndexScan(mc)
 SeqScan(ct)
 IndexScan(cn)
 IndexScan(mk)
 SeqScan(ml)
 SeqScan(lt)
 IndexScan(k)
 IndexScan(mi)
 IndexScan(t)
 Leading(((((((((((cc cct1) cct2) mc) ct) cn) mk) (ml lt)) k) mi) t)) */
SELECT MIN(cn.name) AS producing_company, MIN(lt.link) AS link_type, MIN(t.title) AS complete_western_sequel FROM complete_cast AS cc, comp_cast_type AS cct1, comp_cast_type AS cct2, company_name AS cn, company_type AS ct, keyword AS k, link_type AS lt, movie_companies AS mc, movie_info AS mi, movie_keyword AS mk, movie_link AS ml, title AS t WHERE cct1.kind  = 'cast' AND cct2.kind  like 'complete%' AND cn.country_code !='[pl]' AND (cn.name LIKE '%Film%' OR cn.name LIKE '%Warner%') AND ct.kind ='production companies' AND k.keyword ='sequel' AND lt.link LIKE '%follow%' AND mc.note IS NULL AND mi.info IN ('Sweden', 'Norway', 'Germany', 'Denmark', 'Swedish', 'Denish', 'Norwegian', 'German', 'English') AND t.production_year BETWEEN 1950 AND 2010 AND lt.id = ml.link_type_id AND ml.movie_id = t.id AND t.id = mk.movie_id AND mk.keyword_id = k.id AND t.id = mc.movie_id AND mc.company_type_id = ct.id AND mc.company_id = cn.id AND mi.movie_id = t.id AND t.id = cc.movie_id AND cct1.id = cc.subject_id AND cct2.id = cc.status_id AND ml.movie_id = mk.movie_id AND ml.movie_id = mc.movie_id AND mk.movie_id = mc.movie_id AND ml.movie_id = mi.movie_id AND mk.movie_id = mi.movie_id AND mc.movie_id = mi.movie_id AND ml.movie_id = cc.movie_id AND mk.movie_id = cc.movie_id AND mc.movie_id = cc.movie_id AND mi.movie_id = cc.movie_id;


-- imdbload_job28a.sql
-- 333.002
/*+ NestedLoop(it2 k mk mi_idx cc cct1 cct2 mc cn ct t mi it1 kt)
 NestedLoop(it2 k mk mi_idx cc cct1 cct2 mc cn ct t mi it1)
 NestedLoop(it2 k mk mi_idx cc cct1 cct2 mc cn ct t mi)
 NestedLoop(it2 k mk mi_idx cc cct1 cct2 mc cn ct t)
 NestedLoop(it2 k mk mi_idx cc cct1 cct2 mc cn ct)
 NestedLoop(it2 k mk mi_idx cc cct1 cct2 mc cn)
 NestedLoop(it2 k mk mi_idx cc cct1 cct2 mc)
 NestedLoop(it2 k mk mi_idx cc cct1 cct2)
 NestedLoop(it2 k mk mi_idx cc cct1)
 NestedLoop(it2 k mk mi_idx cc)
 NestedLoop(it2 k mk mi_idx)
 NestedLoop(k mk mi_idx)
 NestedLoop(k mk)
 SeqScan(it2)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(mi_idx)
 IndexScan(cc)
 SeqScan(cct1)
 SeqScan(cct2)
 IndexScan(mc)
 IndexScan(cn)
 SeqScan(ct)
 IndexScan(t)
 IndexScan(mi)
 SeqScan(it1)
 SeqScan(kt)
 Leading((((((((((((it2 ((k mk) mi_idx)) cc) cct1) cct2) mc) cn) ct) t) mi) it1) kt)) */
SELECT MIN(cn.name) AS movie_company, MIN(mi_idx.info) AS rating, MIN(t.title) AS complete_euro_dark_movie FROM complete_cast AS cc, comp_cast_type AS cct1, comp_cast_type AS cct2, company_name AS cn, company_type AS ct, info_type AS it1, info_type AS it2, keyword AS k, kind_type AS kt, movie_companies AS mc, movie_info AS mi, movie_info_idx AS mi_idx, movie_keyword AS mk, title AS t WHERE cct1.kind  = 'crew' AND cct2.kind  != 'complete+verified' AND cn.country_code  != '[us]' AND it1.info  = 'countries' AND it2.info  = 'rating' AND k.keyword  in ('murder', 'murder-in-title', 'blood', 'violence') AND kt.kind  in ('movie', 'episode') AND mc.note  not like '%(USA)%' and mc.note like '%(200%)%' AND mi.info IN ('Sweden', 'Norway', 'Germany', 'Denmark', 'Swedish', 'Danish', 'Norwegian', 'German', 'USA', 'American') AND mi_idx.info  < '8.5' AND t.production_year  > 2000 AND kt.id = t.kind_id AND t.id = mi.movie_id AND t.id = mk.movie_id AND t.id = mi_idx.movie_id AND t.id = mc.movie_id AND t.id = cc.movie_id AND mk.movie_id = mi.movie_id AND mk.movie_id = mi_idx.movie_id AND mk.movie_id = mc.movie_id AND mk.movie_id = cc.movie_id AND mi.movie_id = mi_idx.movie_id AND mi.movie_id = mc.movie_id AND mi.movie_id = cc.movie_id AND mc.movie_id = mi_idx.movie_id AND mc.movie_id = cc.movie_id AND mi_idx.movie_id = cc.movie_id AND k.id = mk.keyword_id AND it1.id = mi.info_type_id AND it2.id = mi_idx.info_type_id AND ct.id = mc.company_type_id AND cn.id = mc.company_id AND cct1.id = cc.subject_id AND cct2.id = cc.status_id;


-- imdbload_job28b.sql
-- 168.433
/*+ NestedLoop(it2 k mk mi_idx cc cct1 cct2 mc cn ct t mi it1 kt)
 NestedLoop(it2 k mk mi_idx cc cct1 cct2 mc cn ct t mi it1)
 NestedLoop(it2 k mk mi_idx cc cct1 cct2 mc cn ct t mi)
 NestedLoop(it2 k mk mi_idx cc cct1 cct2 mc cn ct t)
 NestedLoop(it2 k mk mi_idx cc cct1 cct2 mc cn ct)
 NestedLoop(it2 k mk mi_idx cc cct1 cct2 mc cn)
 NestedLoop(it2 k mk mi_idx cc cct1 cct2 mc)
 NestedLoop(it2 k mk mi_idx cc cct1 cct2)
 NestedLoop(it2 k mk mi_idx cc cct1)
 NestedLoop(it2 k mk mi_idx cc)
 NestedLoop(it2 k mk mi_idx)
 NestedLoop(k mk mi_idx)
 NestedLoop(k mk)
 SeqScan(it2)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(mi_idx)
 IndexScan(cc)
 SeqScan(cct1)
 SeqScan(cct2)
 IndexScan(mc)
 IndexScan(cn)
 SeqScan(ct)
 IndexScan(t)
 IndexScan(mi)
 SeqScan(it1)
 SeqScan(kt)
 Leading((((((((((((it2 ((k mk) mi_idx)) cc) cct1) cct2) mc) cn) ct) t) mi) it1) kt)) */
SELECT MIN(cn.name) AS movie_company, MIN(mi_idx.info) AS rating, MIN(t.title) AS complete_euro_dark_movie FROM complete_cast AS cc, comp_cast_type AS cct1, comp_cast_type AS cct2, company_name AS cn, company_type AS ct, info_type AS it1, info_type AS it2, keyword AS k, kind_type AS kt, movie_companies AS mc, movie_info AS mi, movie_info_idx AS mi_idx, movie_keyword AS mk, title AS t WHERE cct1.kind  = 'crew' AND cct2.kind  != 'complete+verified' AND cn.country_code  != '[us]' AND it1.info  = 'countries' AND it2.info  = 'rating' AND k.keyword  in ('murder', 'murder-in-title', 'blood', 'violence') AND kt.kind  in ('movie', 'episode') AND mc.note  not like '%(USA)%' and mc.note like '%(200%)%' AND mi.info  IN ('Sweden', 'Germany', 'Swedish', 'German') AND mi_idx.info  > '6.5' AND t.production_year  > 2005 AND kt.id = t.kind_id AND t.id = mi.movie_id AND t.id = mk.movie_id AND t.id = mi_idx.movie_id AND t.id = mc.movie_id AND t.id = cc.movie_id AND mk.movie_id = mi.movie_id AND mk.movie_id = mi_idx.movie_id AND mk.movie_id = mc.movie_id AND mk.movie_id = cc.movie_id AND mi.movie_id = mi_idx.movie_id AND mi.movie_id = mc.movie_id AND mi.movie_id = cc.movie_id AND mc.movie_id = mi_idx.movie_id AND mc.movie_id = cc.movie_id AND mi_idx.movie_id = cc.movie_id AND k.id = mk.keyword_id AND it1.id = mi.info_type_id AND it2.id = mi_idx.info_type_id AND ct.id = mc.company_type_id AND cn.id = mc.company_id AND cct1.id = cc.subject_id AND cct2.id = cc.status_id;


-- imdbload_job28c.sql
-- 393.678
/*+ NestedLoop(cct2 cct1 k mk cc t kt mc cn ct mi it1 mi_idx it2)
 NestedLoop(cct2 cct1 k mk cc t kt mc cn ct mi it1 mi_idx)
 NestedLoop(cct2 cct1 k mk cc t kt mc cn ct mi it1)
 NestedLoop(cct2 cct1 k mk cc t kt mc cn ct mi)
 NestedLoop(cct2 cct1 k mk cc t kt mc cn ct)
 NestedLoop(cct2 cct1 k mk cc t kt mc cn)
 NestedLoop(cct2 cct1 k mk cc t kt mc)
 NestedLoop(cct2 cct1 k mk cc t kt)
 NestedLoop(cct2 cct1 k mk cc t)
 NestedLoop(cct2 cct1 k mk cc)
 NestedLoop(cct1 k mk cc)
 NestedLoop(k mk cc)
 NestedLoop(k mk)
 SeqScan(cct2)
 SeqScan(cct1)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(cc)
 IndexScan(t)
 SeqScan(kt)
 IndexScan(mc)
 IndexScan(cn)
 SeqScan(ct)
 IndexScan(mi)
 SeqScan(it1)
 IndexScan(mi_idx)
 SeqScan(it2)
 Leading(((((((((((cct2 (cct1 ((k mk) cc))) t) kt) mc) cn) ct) mi) it1) mi_idx) it2)) */
SELECT MIN(cn.name) AS movie_company, MIN(mi_idx.info) AS rating, MIN(t.title) AS complete_euro_dark_movie FROM complete_cast AS cc, comp_cast_type AS cct1, comp_cast_type AS cct2, company_name AS cn, company_type AS ct, info_type AS it1, info_type AS it2, keyword AS k, kind_type AS kt, movie_companies AS mc, movie_info AS mi, movie_info_idx AS mi_idx, movie_keyword AS mk, title AS t WHERE cct1.kind  = 'cast' AND cct2.kind  = 'complete' AND cn.country_code  != '[us]' AND it1.info  = 'countries' AND it2.info  = 'rating' AND k.keyword  in ('murder', 'murder-in-title', 'blood', 'violence') AND kt.kind  in ('movie', 'episode') AND mc.note  not like '%(USA)%' and mc.note like '%(200%)%' AND mi.info IN ('Sweden', 'Norway', 'Germany', 'Denmark', 'Swedish', 'Danish', 'Norwegian', 'German', 'USA', 'American') AND mi_idx.info  < '8.5' AND t.production_year  > 2005 AND kt.id = t.kind_id AND t.id = mi.movie_id AND t.id = mk.movie_id AND t.id = mi_idx.movie_id AND t.id = mc.movie_id AND t.id = cc.movie_id AND mk.movie_id = mi.movie_id AND mk.movie_id = mi_idx.movie_id AND mk.movie_id = mc.movie_id AND mk.movie_id = cc.movie_id AND mi.movie_id = mi_idx.movie_id AND mi.movie_id = mc.movie_id AND mi.movie_id = cc.movie_id AND mc.movie_id = mi_idx.movie_id AND mc.movie_id = cc.movie_id AND mi_idx.movie_id = cc.movie_id AND k.id = mk.keyword_id AND it1.id = mi.info_type_id AND it2.id = mi_idx.info_type_id AND ct.id = mc.company_type_id AND cn.id = mc.company_id AND cct1.id = cc.subject_id AND cct2.id = cc.status_id;


-- imdbload_job29a.sql
-- 120.853
/*+ NestedLoop(k mk t ci pi an cc cct1 cct2 chn mc cn mi it n it3 rt)
 NestedLoop(k mk t ci pi an cc cct1 cct2 chn mc cn mi it n it3)
 NestedLoop(k mk t ci pi an cc cct1 cct2 chn mc cn mi it n)
 NestedLoop(k mk t ci pi an cc cct1 cct2 chn mc cn mi it)
 NestedLoop(k mk t ci pi an cc cct1 cct2 chn mc cn mi)
 NestedLoop(k mk t ci pi an cc cct1 cct2 chn mc cn)
 NestedLoop(k mk t ci pi an cc cct1 cct2 chn mc)
 NestedLoop(k mk t ci pi an cc cct1 cct2 chn)
 NestedLoop(k mk t ci pi an cc cct1 cct2)
 NestedLoop(k mk t ci pi an cc cct1)
 NestedLoop(k mk t ci pi an cc)
 NestedLoop(k mk t ci pi an)
 NestedLoop(k mk t ci pi)
 NestedLoop(k mk t ci)
 NestedLoop(k mk t)
 NestedLoop(k mk)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(t)
 IndexScan(ci)
 IndexScan(pi)
 IndexOnlyScan(an)
 IndexScan(cc)
 SeqScan(cct1)
 SeqScan(cct2)
 IndexScan(chn)
 IndexScan(mc)
 IndexScan(cn)
 IndexScan(mi)
 SeqScan(it)
 IndexScan(n)
 SeqScan(it3)
 SeqScan(rt)
 Leading(((((((((((((((((k mk) t) ci) pi) an) cc) cct1) cct2) chn) mc) cn) mi) it) n) it3) rt)) */
SELECT MIN(chn.name) AS voiced_char, MIN(n.name) AS voicing_actress, MIN(t.title) AS voiced_animation FROM aka_name AS an, complete_cast AS cc, comp_cast_type AS cct1, comp_cast_type AS cct2, char_name AS chn, cast_info AS ci, company_name AS cn, info_type AS it, info_type AS it3, keyword AS k, movie_companies AS mc, movie_info AS mi, movie_keyword AS mk, name AS n, person_info AS pi, role_type AS rt, title AS t WHERE cct1.kind  ='cast' AND cct2.kind  ='complete+verified' AND chn.name  = 'Queen' AND ci.note  in ('(voice)', '(voice) (uncredited)', '(voice: English version)') AND cn.country_code ='[us]' AND it.info  = 'release dates' AND it3.info  = 'trivia' AND k.keyword  = 'computer-animation' AND mi.info  is not null and (mi.info like 'Japan:%200%' or mi.info like 'USA:%200%') AND n.gender ='f' and n.name like '%An%' AND rt.role ='actress' AND t.title  = 'Shrek 2' AND t.production_year  between 2000 and 2010 AND t.id = mi.movie_id AND t.id = mc.movie_id AND t.id = ci.movie_id AND t.id = mk.movie_id AND t.id = cc.movie_id AND mc.movie_id = ci.movie_id AND mc.movie_id = mi.movie_id AND mc.movie_id = mk.movie_id AND mc.movie_id = cc.movie_id AND mi.movie_id = ci.movie_id AND mi.movie_id = mk.movie_id AND mi.movie_id = cc.movie_id AND ci.movie_id = mk.movie_id AND ci.movie_id = cc.movie_id AND mk.movie_id = cc.movie_id AND cn.id = mc.company_id AND it.id = mi.info_type_id AND n.id = ci.person_id AND rt.id = ci.role_id AND n.id = an.person_id AND ci.person_id = an.person_id AND chn.id = ci.person_role_id AND n.id = pi.person_id AND ci.person_id = pi.person_id AND it3.id = pi.info_type_id AND k.id = mk.keyword_id AND cct1.id = cc.subject_id AND cct2.id = cc.status_id;


-- imdbload_job29b.sql
-- 97.264
/*+ NestedLoop(k mk t ci pi an cc cct1 cct2 chn mc cn mi it n it3 rt)
 NestedLoop(k mk t ci pi an cc cct1 cct2 chn mc cn mi it n it3)
 NestedLoop(k mk t ci pi an cc cct1 cct2 chn mc cn mi it n)
 NestedLoop(k mk t ci pi an cc cct1 cct2 chn mc cn mi it)
 NestedLoop(k mk t ci pi an cc cct1 cct2 chn mc cn mi)
 NestedLoop(k mk t ci pi an cc cct1 cct2 chn mc cn)
 NestedLoop(k mk t ci pi an cc cct1 cct2 chn mc)
 NestedLoop(k mk t ci pi an cc cct1 cct2 chn)
 NestedLoop(k mk t ci pi an cc cct1 cct2)
 NestedLoop(k mk t ci pi an cc cct1)
 NestedLoop(k mk t ci pi an cc)
 NestedLoop(k mk t ci pi an)
 NestedLoop(k mk t ci pi)
 NestedLoop(k mk t ci)
 NestedLoop(k mk t)
 NestedLoop(k mk)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(t)
 IndexScan(ci)
 IndexScan(pi)
 IndexOnlyScan(an)
 IndexScan(cc)
 SeqScan(cct1)
 SeqScan(cct2)
 IndexScan(chn)
 IndexScan(mc)
 IndexScan(cn)
 IndexScan(mi)
 SeqScan(it)
 IndexScan(n)
 SeqScan(it3)
 SeqScan(rt)
 Leading(((((((((((((((((k mk) t) ci) pi) an) cc) cct1) cct2) chn) mc) cn) mi) it) n) it3) rt)) */
SELECT MIN(chn.name) AS voiced_char, MIN(n.name) AS voicing_actress, MIN(t.title) AS voiced_animation FROM aka_name AS an, complete_cast AS cc, comp_cast_type AS cct1, comp_cast_type AS cct2, char_name AS chn, cast_info AS ci, company_name AS cn, info_type AS it, info_type AS it3, keyword AS k, movie_companies AS mc, movie_info AS mi, movie_keyword AS mk, name AS n, person_info AS pi, role_type AS rt, title AS t WHERE cct1.kind  ='cast' AND cct2.kind  ='complete+verified' AND chn.name  = 'Queen' AND ci.note  in ('(voice)', '(voice) (uncredited)', '(voice: English version)') AND cn.country_code ='[us]' AND it.info  = 'release dates' AND it3.info  = 'height' AND k.keyword  = 'computer-animation' AND mi.info  like 'USA:%200%' AND n.gender ='f' and n.name like '%An%' AND rt.role ='actress' AND t.title  = 'Shrek 2' AND t.production_year  between 2000 and 2005 AND t.id = mi.movie_id AND t.id = mc.movie_id AND t.id = ci.movie_id AND t.id = mk.movie_id AND t.id = cc.movie_id AND mc.movie_id = ci.movie_id AND mc.movie_id = mi.movie_id AND mc.movie_id = mk.movie_id AND mc.movie_id = cc.movie_id AND mi.movie_id = ci.movie_id AND mi.movie_id = mk.movie_id AND mi.movie_id = cc.movie_id AND ci.movie_id = mk.movie_id AND ci.movie_id = cc.movie_id AND mk.movie_id = cc.movie_id AND cn.id = mc.company_id AND it.id = mi.info_type_id AND n.id = ci.person_id AND rt.id = ci.role_id AND n.id = an.person_id AND ci.person_id = an.person_id AND chn.id = ci.person_role_id AND n.id = pi.person_id AND ci.person_id = pi.person_id AND it3.id = pi.info_type_id AND k.id = mk.keyword_id AND cct1.id = cc.subject_id AND cct2.id = cc.status_id;


-- imdbload_job29c.sql
-- 2471.631
/*+ NestedLoop(cct2 cct1 k mk cc t ci mc cn rt pi an chn mi it n it3)
 NestedLoop(cct2 cct1 k mk cc t ci mc cn rt pi an chn mi it n)
 NestedLoop(cct2 cct1 k mk cc t ci mc cn rt pi an chn mi it)
 NestedLoop(cct2 cct1 k mk cc t ci mc cn rt pi an chn mi)
 NestedLoop(cct2 cct1 k mk cc t ci mc cn rt pi an chn)
 NestedLoop(cct2 cct1 k mk cc t ci mc cn rt pi an)
 NestedLoop(cct2 cct1 k mk cc t ci mc cn rt pi)
 NestedLoop(cct2 cct1 k mk cc t ci mc cn rt)
 NestedLoop(cct2 cct1 k mk cc t ci mc cn)
 NestedLoop(cct2 cct1 k mk cc t ci mc)
 NestedLoop(cct2 cct1 k mk cc t ci)
 NestedLoop(cct2 cct1 k mk cc t)
 NestedLoop(cct2 cct1 k mk cc)
 NestedLoop(cct1 k mk cc)
 NestedLoop(k mk cc)
 NestedLoop(k mk)
 SeqScan(cct2)
 SeqScan(cct1)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(cc)
 IndexScan(t)
 IndexScan(ci)
 IndexScan(mc)
 IndexScan(cn)
 SeqScan(rt)
 IndexScan(pi)
 IndexOnlyScan(an)
 IndexScan(chn)
 IndexScan(mi)
 SeqScan(it)
 IndexScan(n)
 SeqScan(it3)
 Leading((((((((((((((cct2 (cct1 ((k mk) cc))) t) ci) mc) cn) rt) pi) an) chn) mi) it) n) it3)) */
SELECT MIN(chn.name) AS voiced_char, MIN(n.name) AS voicing_actress, MIN(t.title) AS voiced_animation FROM aka_name AS an, complete_cast AS cc, comp_cast_type AS cct1, comp_cast_type AS cct2, char_name AS chn, cast_info AS ci, company_name AS cn, info_type AS it, info_type AS it3, keyword AS k, movie_companies AS mc, movie_info AS mi, movie_keyword AS mk, name AS n, person_info AS pi, role_type AS rt, title AS t WHERE cct1.kind  ='cast' AND cct2.kind  ='complete+verified' AND ci.note  in ('(voice)', '(voice: Japanese version)', '(voice) (uncredited)', '(voice: English version)') AND cn.country_code ='[us]' AND it.info  = 'release dates' AND it3.info  = 'trivia' AND k.keyword  = 'computer-animation' AND mi.info  is not null and (mi.info like 'Japan:%200%' or mi.info like 'USA:%200%') AND n.gender ='f' and n.name like '%An%' AND rt.role ='actress' AND t.production_year  between 2000 and 2010 AND t.id = mi.movie_id AND t.id = mc.movie_id AND t.id = ci.movie_id AND t.id = mk.movie_id AND t.id = cc.movie_id AND mc.movie_id = ci.movie_id AND mc.movie_id = mi.movie_id AND mc.movie_id = mk.movie_id AND mc.movie_id = cc.movie_id AND mi.movie_id = ci.movie_id AND mi.movie_id = mk.movie_id AND mi.movie_id = cc.movie_id AND ci.movie_id = mk.movie_id AND ci.movie_id = cc.movie_id AND mk.movie_id = cc.movie_id AND cn.id = mc.company_id AND it.id = mi.info_type_id AND n.id = ci.person_id AND rt.id = ci.role_id AND n.id = an.person_id AND ci.person_id = an.person_id AND chn.id = ci.person_role_id AND n.id = pi.person_id AND ci.person_id = pi.person_id AND it3.id = pi.info_type_id AND k.id = mk.keyword_id AND cct1.id = cc.subject_id AND cct2.id = cc.status_id;


-- imdbload_job2a.sql
-- 234.502
/*+ NestedLoop(k mk mc cn t)
 NestedLoop(k mk mc cn)
 NestedLoop(k mk mc)
 NestedLoop(k mk)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(mc)
 IndexScan(cn)
 IndexScan(t)
 Leading(((((k mk) mc) cn) t)) */
SELECT MIN(t.title) AS movie_title FROM company_name AS cn, keyword AS k, movie_companies AS mc, movie_keyword AS mk, title AS t WHERE cn.country_code ='[de]' AND k.keyword ='character-name-in-title' AND cn.id = mc.company_id AND mc.movie_id = t.id AND t.id = mk.movie_id AND mk.keyword_id = k.id AND mc.movie_id = mk.movie_id;


-- imdbload_job2b.sql
-- 212.86
/*+ NestedLoop(k mk mc cn t)
 NestedLoop(k mk mc cn)
 NestedLoop(k mk mc)
 NestedLoop(k mk)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(mc)
 IndexScan(cn)
 IndexScan(t)
 Leading(((((k mk) mc) cn) t)) */
SELECT MIN(t.title) AS movie_title FROM company_name AS cn, keyword AS k, movie_companies AS mc, movie_keyword AS mk, title AS t WHERE cn.country_code ='[nl]' AND k.keyword ='character-name-in-title' AND cn.id = mc.company_id AND mc.movie_id = t.id AND t.id = mk.movie_id AND mk.keyword_id = k.id AND mc.movie_id = mk.movie_id;


-- imdbload_job2c.sql
-- 205.99
/*+ NestedLoop(k mk mc cn t)
 NestedLoop(k mk mc cn)
 NestedLoop(k mk mc)
 NestedLoop(k mk)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(mc)
 IndexScan(cn)
 IndexScan(t)
 Leading(((((k mk) mc) cn) t)) */
SELECT MIN(t.title) AS movie_title FROM company_name AS cn, keyword AS k, movie_companies AS mc, movie_keyword AS mk, title AS t WHERE cn.country_code ='[sm]' AND k.keyword ='character-name-in-title' AND cn.id = mc.company_id AND mc.movie_id = t.id AND t.id = mk.movie_id AND mk.keyword_id = k.id AND mc.movie_id = mk.movie_id;


-- imdbload_job2d.sql
-- 289.055
/*+ NestedLoop(k mk t mc cn)
 NestedLoop(k mk t mc)
 NestedLoop(k mk t)
 NestedLoop(k mk)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(t)
 IndexScan(mc)
 IndexScan(cn)
 Leading(((((k mk) t) mc) cn)) */
SELECT MIN(t.title) AS movie_title FROM company_name AS cn, keyword AS k, movie_companies AS mc, movie_keyword AS mk, title AS t WHERE cn.country_code ='[us]' AND k.keyword ='character-name-in-title' AND cn.id = mc.company_id AND mc.movie_id = t.id AND t.id = mk.movie_id AND mk.keyword_id = k.id AND mc.movie_id = mk.movie_id;


-- imdbload_job30a.sql
-- 1024.608
/*+ NestedLoop(k mk mi_idx it2 cc cct2 cct1 ci mi it1 n t)
 NestedLoop(k mk mi_idx it2 cc cct2 cct1 ci mi it1 n)
 NestedLoop(k mk mi_idx it2 cc cct2 cct1 ci mi it1)
 NestedLoop(k mk mi_idx it2 cc cct2 cct1 ci mi)
 NestedLoop(k mk mi_idx it2 cc cct2 cct1 ci)
 NestedLoop(k mk mi_idx it2 cc cct2 cct1)
 NestedLoop(k mk mi_idx it2 cc cct2)
 NestedLoop(k mk mi_idx it2 cc)
 HashJoin(k mk mi_idx it2)
 NestedLoop(k mk mi_idx)
 NestedLoop(k mk)
 IndexScan(k)
 IndexScan(mk)
 IndexScan(mi_idx)
 SeqScan(it2)
 IndexScan(cc)
 IndexScan(cct2)
 IndexScan(cct1)
 IndexScan(ci)
 IndexScan(mi)
 IndexScan(it1)
 IndexScan(n)
 IndexScan(t)
 Leading((((((((((((k mk) mi_idx) it2) cc) cct2) cct1) ci) mi) it1) n) t)) */
SELECT MIN(mi.info) AS movie_budget, MIN(mi_idx.info) AS movie_votes, MIN(n.name) AS writer, MIN(t.title) AS complete_violent_movie FROM complete_cast AS cc, comp_cast_type AS cct1, comp_cast_type AS cct2, cast_info AS ci, info_type AS it1, info_type AS it2, keyword AS k, movie_info AS mi, movie_info_idx AS mi_idx, movie_keyword AS mk, name AS n, title AS t WHERE cct1.kind  in ('cast', 'crew') AND cct2.kind  ='complete+verified' AND ci.note  in ('(writer)', '(head writer)', '(written by)', '(story)', '(story editor)') AND it1.info  = 'genres' AND it2.info  = 'votes' AND k.keyword  in ('murder', 'violence', 'blood', 'gore', 'death', 'female-nudity', 'hospital') AND mi.info  in ('Horror', 'Thriller') AND n.gender  = 'm' AND t.production_year  > 2000 AND t.id = mi.movie_id AND t.id = mi_idx.movie_id AND t.id = ci.movie_id AND t.id = mk.movie_id AND t.id = cc.movie_id AND ci.movie_id = mi.movie_id AND ci.movie_id = mi_idx.movie_id AND ci.movie_id = mk.movie_id AND ci.movie_id = cc.movie_id AND mi.movie_id = mi_idx.movie_id AND mi.movie_id = mk.movie_id AND mi.movie_id = cc.movie_id AND mi_idx.movie_id = mk.movie_id AND mi_idx.movie_id = cc.movie_id AND mk.movie_id = cc.movie_id AND n.id = ci.person_id AND it1.id = mi.info_type_id AND it2.id = mi_idx.info_type_id AND k.id = mk.keyword_id AND cct1.id = cc.subject_id AND cct2.id = cc.status_id;


-- imdbload_job30b.sql
-- 100.967
/*+ NestedLoop(k mk t cc cct1 cct2 ci mi it1 mi_idx it2 n)
 NestedLoop(k mk t cc cct1 cct2 ci mi it1 mi_idx it2)
 NestedLoop(k mk t cc cct1 cct2 ci mi it1 mi_idx)
 NestedLoop(k mk t cc cct1 cct2 ci mi it1)
 NestedLoop(k mk t cc cct1 cct2 ci mi)
 NestedLoop(k mk t cc cct1 cct2 ci)
 NestedLoop(k mk t cc cct1 cct2)
 NestedLoop(k mk t cc cct1)
 NestedLoop(k mk t cc)
 NestedLoop(k mk t)
 NestedLoop(k mk)
 IndexScan(k)
 IndexScan(mk)
 IndexScan(t)
 IndexScan(cc)
 IndexScan(cct1)
 IndexScan(cct2)
 IndexScan(ci)
 IndexScan(mi)
 IndexScan(it1)
 IndexScan(mi_idx)
 IndexScan(it2)
 IndexScan(n)
 Leading((((((((((((k mk) t) cc) cct1) cct2) ci) mi) it1) mi_idx) it2) n)) */
SELECT MIN(mi.info) AS movie_budget, MIN(mi_idx.info) AS movie_votes, MIN(n.name) AS writer, MIN(t.title) AS complete_gore_movie FROM complete_cast AS cc, comp_cast_type AS cct1, comp_cast_type AS cct2, cast_info AS ci, info_type AS it1, info_type AS it2, keyword AS k, movie_info AS mi, movie_info_idx AS mi_idx, movie_keyword AS mk, name AS n, title AS t WHERE cct1.kind  in ('cast', 'crew') AND cct2.kind  ='complete+verified' AND ci.note  in ('(writer)', '(head writer)', '(written by)', '(story)', '(story editor)') AND it1.info  = 'genres' AND it2.info  = 'votes' AND k.keyword  in ('murder', 'violence', 'blood', 'gore', 'death', 'female-nudity', 'hospital') AND mi.info  in ('Horror', 'Thriller') AND n.gender  = 'm' AND t.production_year  > 2000 and (t.title like '%Freddy%' or t.title like '%Jason%' or t.title like 'Saw%') AND t.id = mi.movie_id AND t.id = mi_idx.movie_id AND t.id = ci.movie_id AND t.id = mk.movie_id AND t.id = cc.movie_id AND ci.movie_id = mi.movie_id AND ci.movie_id = mi_idx.movie_id AND ci.movie_id = mk.movie_id AND ci.movie_id = cc.movie_id AND mi.movie_id = mi_idx.movie_id AND mi.movie_id = mk.movie_id AND mi.movie_id = cc.movie_id AND mi_idx.movie_id = mk.movie_id AND mi_idx.movie_id = cc.movie_id AND mk.movie_id = cc.movie_id AND n.id = ci.person_id AND it1.id = mi.info_type_id AND it2.id = mi_idx.info_type_id AND k.id = mk.keyword_id AND cct1.id = cc.subject_id AND cct2.id = cc.status_id;


-- imdbload_job30c.sql
-- 881.453
/*+ NestedLoop(k mk mi_idx it2 cc cct1 cct2 ci mi it1 n t)
 NestedLoop(k mk mi_idx it2 cc cct1 cct2 ci mi it1 n)
 NestedLoop(k mk mi_idx it2 cc cct1 cct2 ci mi it1)
 NestedLoop(k mk mi_idx it2 cc cct1 cct2 ci mi)
 NestedLoop(k mk mi_idx it2 cc cct1 cct2 ci)
 NestedLoop(k mk mi_idx it2 cc cct1 cct2)
 NestedLoop(k mk mi_idx it2 cc cct1)
 NestedLoop(k mk mi_idx it2 cc)
 HashJoin(k mk mi_idx it2)
 NestedLoop(k mk mi_idx)
 NestedLoop(k mk)
 IndexScan(k)
 IndexScan(mk)
 IndexScan(mi_idx)
 SeqScan(it2)
 IndexScan(cc)
 IndexScan(cct1)
 IndexScan(cct2)
 IndexScan(ci)
 IndexScan(mi)
 IndexScan(it1)
 IndexScan(n)
 IndexScan(t)
 Leading((((((((((((k mk) mi_idx) it2) cc) cct1) cct2) ci) mi) it1) n) t)) */
SELECT MIN(mi.info) AS movie_budget, MIN(mi_idx.info) AS movie_votes, MIN(n.name) AS writer, MIN(t.title) AS complete_violent_movie FROM complete_cast AS cc, comp_cast_type AS cct1, comp_cast_type AS cct2, cast_info AS ci, info_type AS it1, info_type AS it2, keyword AS k, movie_info AS mi, movie_info_idx AS mi_idx, movie_keyword AS mk, name AS n, title AS t WHERE cct1.kind  = 'cast' AND cct2.kind  ='complete+verified' AND ci.note  in ('(writer)', '(head writer)', '(written by)', '(story)', '(story editor)') AND it1.info  = 'genres' AND it2.info  = 'votes' AND k.keyword  in ('murder', 'violence', 'blood', 'gore', 'death', 'female-nudity', 'hospital') AND mi.info  in ('Horror', 'Action', 'Sci-Fi', 'Thriller', 'Crime', 'War') AND n.gender  = 'm' AND t.id = mi.movie_id AND t.id = mi_idx.movie_id AND t.id = ci.movie_id AND t.id = mk.movie_id AND t.id = cc.movie_id AND ci.movie_id = mi.movie_id AND ci.movie_id = mi_idx.movie_id AND ci.movie_id = mk.movie_id AND ci.movie_id = cc.movie_id AND mi.movie_id = mi_idx.movie_id AND mi.movie_id = mk.movie_id AND mi.movie_id = cc.movie_id AND mi_idx.movie_id = mk.movie_id AND mi_idx.movie_id = cc.movie_id AND mk.movie_id = cc.movie_id AND n.id = ci.person_id AND it1.id = mi.info_type_id AND it2.id = mi_idx.info_type_id AND k.id = mk.keyword_id AND cct1.id = cc.subject_id AND cct2.id = cc.status_id;


-- imdbload_job31a.sql
-- 429.195
/*+ NestedLoop(k mk mi_idx it2 mc cn ci mi it1 n t)
 NestedLoop(k mk mi_idx it2 mc cn ci mi it1 n)
 NestedLoop(k mk mi_idx it2 mc cn ci mi it1)
 NestedLoop(k mk mi_idx it2 mc cn ci mi)
 NestedLoop(k mk mi_idx it2 mc cn ci)
 NestedLoop(k mk mi_idx it2 mc cn)
 NestedLoop(k mk mi_idx it2 mc)
 HashJoin(k mk mi_idx it2)
 NestedLoop(k mk mi_idx)
 NestedLoop(k mk)
 IndexScan(k)
 IndexScan(mk)
 IndexScan(mi_idx)
 SeqScan(it2)
 IndexScan(mc)
 IndexScan(cn)
 IndexScan(ci)
 IndexScan(mi)
 IndexScan(it1)
 IndexScan(n)
 IndexScan(t)
 Leading(((((((((((k mk) mi_idx) it2) mc) cn) ci) mi) it1) n) t)) */
SELECT MIN(mi.info) AS movie_budget, MIN(mi_idx.info) AS movie_votes, MIN(n.name) AS writer, MIN(t.title) AS violent_liongate_movie FROM cast_info AS ci, company_name AS cn, info_type AS it1, info_type AS it2, keyword AS k, movie_companies AS mc, movie_info AS mi, movie_info_idx AS mi_idx, movie_keyword AS mk, name AS n, title AS t WHERE ci.note  in ('(writer)', '(head writer)', '(written by)', '(story)', '(story editor)') AND cn.name  like 'Lionsgate%' AND it1.info  = 'genres' AND it2.info  = 'votes' AND k.keyword  in ('murder', 'violence', 'blood', 'gore', 'death', 'female-nudity', 'hospital') AND mi.info  in ('Horror', 'Thriller') AND n.gender   = 'm' AND t.id = mi.movie_id AND t.id = mi_idx.movie_id AND t.id = ci.movie_id AND t.id = mk.movie_id AND t.id = mc.movie_id AND ci.movie_id = mi.movie_id AND ci.movie_id = mi_idx.movie_id AND ci.movie_id = mk.movie_id AND ci.movie_id = mc.movie_id AND mi.movie_id = mi_idx.movie_id AND mi.movie_id = mk.movie_id AND mi.movie_id = mc.movie_id AND mi_idx.movie_id = mk.movie_id AND mi_idx.movie_id = mc.movie_id AND mk.movie_id = mc.movie_id AND n.id = ci.person_id AND it1.id = mi.info_type_id AND it2.id = mi_idx.info_type_id AND k.id = mk.keyword_id AND cn.id = mc.company_id;


-- imdbload_job31b.sql
-- 95.455
/*+ NestedLoop(k mk t ci mc cn mi it1 mi_idx it2 n)
 NestedLoop(k mk t ci mc cn mi it1 mi_idx it2)
 NestedLoop(k mk t ci mc cn mi it1 mi_idx)
 NestedLoop(k mk t ci mc cn mi it1)
 NestedLoop(k mk t ci mc cn mi)
 NestedLoop(k mk t ci mc cn)
 NestedLoop(k mk t ci mc)
 NestedLoop(k mk t ci)
 NestedLoop(k mk t)
 NestedLoop(k mk)
 IndexScan(k)
 IndexScan(mk)
 IndexScan(t)
 IndexScan(ci)
 IndexScan(mc)
 IndexScan(cn)
 IndexScan(mi)
 IndexScan(it1)
 IndexScan(mi_idx)
 IndexScan(it2)
 IndexScan(n)
 Leading(((((((((((k mk) t) ci) mc) cn) mi) it1) mi_idx) it2) n)) */
SELECT MIN(mi.info) AS movie_budget, MIN(mi_idx.info) AS movie_votes, MIN(n.name) AS writer, MIN(t.title) AS violent_liongate_movie FROM cast_info AS ci, company_name AS cn, info_type AS it1, info_type AS it2, keyword AS k, movie_companies AS mc, movie_info AS mi, movie_info_idx AS mi_idx, movie_keyword AS mk, name AS n, title AS t WHERE ci.note  in ('(writer)', '(head writer)', '(written by)', '(story)', '(story editor)') AND cn.name  like 'Lionsgate%' AND it1.info  = 'genres' AND it2.info  = 'votes' AND k.keyword  in ('murder', 'violence', 'blood', 'gore', 'death', 'female-nudity', 'hospital') AND mc.note  like '%(Blu-ray)%' AND mi.info  in ('Horror', 'Thriller') AND n.gender  = 'm' AND t.production_year  > 2000 and (t.title like '%Freddy%' or t.title like '%Jason%' or t.title like 'Saw%') AND t.id = mi.movie_id AND t.id = mi_idx.movie_id AND t.id = ci.movie_id AND t.id = mk.movie_id AND t.id = mc.movie_id AND ci.movie_id = mi.movie_id AND ci.movie_id = mi_idx.movie_id AND ci.movie_id = mk.movie_id AND ci.movie_id = mc.movie_id AND mi.movie_id = mi_idx.movie_id AND mi.movie_id = mk.movie_id AND mi.movie_id = mc.movie_id AND mi_idx.movie_id = mk.movie_id AND mi_idx.movie_id = mc.movie_id AND mk.movie_id = mc.movie_id AND n.id = ci.person_id AND it1.id = mi.info_type_id AND it2.id = mi_idx.info_type_id AND k.id = mk.keyword_id AND cn.id = mc.company_id;


-- imdbload_job31c.sql
-- 427.432
/*+ NestedLoop(k mk mi_idx it2 mc cn ci mi it1 n t)
 NestedLoop(k mk mi_idx it2 mc cn ci mi it1 n)
 NestedLoop(k mk mi_idx it2 mc cn ci mi it1)
 NestedLoop(k mk mi_idx it2 mc cn ci mi)
 NestedLoop(k mk mi_idx it2 mc cn ci)
 NestedLoop(k mk mi_idx it2 mc cn)
 NestedLoop(k mk mi_idx it2 mc)
 HashJoin(k mk mi_idx it2)
 NestedLoop(k mk mi_idx)
 NestedLoop(k mk)
 IndexScan(k)
 IndexScan(mk)
 IndexScan(mi_idx)
 SeqScan(it2)
 IndexScan(mc)
 IndexScan(cn)
 IndexScan(ci)
 IndexScan(mi)
 IndexScan(it1)
 IndexScan(n)
 IndexScan(t)
 Leading(((((((((((k mk) mi_idx) it2) mc) cn) ci) mi) it1) n) t)) */
SELECT MIN(mi.info) AS movie_budget, MIN(mi_idx.info) AS movie_votes, MIN(n.name) AS writer, MIN(t.title) AS violent_liongate_movie FROM cast_info AS ci, company_name AS cn, info_type AS it1, info_type AS it2, keyword AS k, movie_companies AS mc, movie_info AS mi, movie_info_idx AS mi_idx, movie_keyword AS mk, name AS n, title AS t WHERE ci.note  in ('(writer)', '(head writer)', '(written by)', '(story)', '(story editor)') AND cn.name  like 'Lionsgate%' AND it1.info  = 'genres' AND it2.info  = 'votes' AND k.keyword  in ('murder', 'violence', 'blood', 'gore', 'death', 'female-nudity', 'hospital') AND mi.info  in ('Horror', 'Action', 'Sci-Fi', 'Thriller', 'Crime', 'War') AND t.id = mi.movie_id AND t.id = mi_idx.movie_id AND t.id = ci.movie_id AND t.id = mk.movie_id AND t.id = mc.movie_id AND ci.movie_id = mi.movie_id AND ci.movie_id = mi_idx.movie_id AND ci.movie_id = mk.movie_id AND ci.movie_id = mc.movie_id AND mi.movie_id = mi_idx.movie_id AND mi.movie_id = mk.movie_id AND mi.movie_id = mc.movie_id AND mi_idx.movie_id = mk.movie_id AND mi_idx.movie_id = mc.movie_id AND mk.movie_id = mc.movie_id AND n.id = ci.person_id AND it1.id = mi.info_type_id AND it2.id = mi_idx.info_type_id AND k.id = mk.keyword_id AND cn.id = mc.company_id;


-- imdbload_job32a.sql
-- 5.469
/*+ NestedLoop(k mk ml lt t1 t2)
 NestedLoop(k mk ml lt t1)
 NestedLoop(k mk ml lt)
 NestedLoop(k mk ml)
 NestedLoop(k mk)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(ml)
 SeqScan(lt)
 IndexScan(t1)
 IndexScan(t2)
 Leading((((((k mk) ml) lt) t1) t2)) */
SELECT MIN(lt.link) AS link_type, MIN(t1.title) AS first_movie, MIN(t2.title) AS second_movie FROM keyword AS k, link_type AS lt, movie_keyword AS mk, movie_link AS ml, title AS t1, title AS t2 WHERE k.keyword ='10,000-mile-club' AND mk.keyword_id = k.id AND t1.id = mk.movie_id AND ml.movie_id = t1.id AND ml.linked_movie_id = t2.id AND lt.id = ml.link_type_id AND mk.movie_id = t1.id;


-- imdbload_job32b.sql
-- 63.353
/*+ NestedLoop(k mk ml lt t1 t2)
 NestedLoop(k mk ml lt t1)
 NestedLoop(k mk ml lt)
 NestedLoop(k mk ml)
 NestedLoop(k mk)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(ml)
 SeqScan(lt)
 IndexScan(t1)
 IndexScan(t2)
 Leading((((((k mk) ml) lt) t1) t2)) */
SELECT MIN(lt.link) AS link_type, MIN(t1.title) AS first_movie, MIN(t2.title) AS second_movie FROM keyword AS k, link_type AS lt, movie_keyword AS mk, movie_link AS ml, title AS t1, title AS t2 WHERE k.keyword ='character-name-in-title' AND mk.keyword_id = k.id AND t1.id = mk.movie_id AND ml.movie_id = t1.id AND ml.linked_movie_id = t2.id AND lt.id = ml.link_type_id AND mk.movie_id = t1.id;


-- imdbload_job33a.sql
-- 15.651
/*+ NestedLoop(mi_idx1 ml lt it1 t1 kt1 mi_idx2 it2 mc2 t2 mc1 cn1 cn2 kt2)
 NestedLoop(mi_idx1 ml lt it1 t1 kt1 mi_idx2 it2 mc2 t2 mc1 cn1 cn2)
 NestedLoop(mi_idx1 ml lt it1 t1 kt1 mi_idx2 it2 mc2 t2 mc1 cn1)
 NestedLoop(mi_idx1 ml lt it1 t1 kt1 mi_idx2 it2 mc2 t2 mc1)
 NestedLoop(mi_idx1 ml lt it1 t1 kt1 mi_idx2 it2 mc2 t2)
 NestedLoop(mi_idx1 ml lt it1 t1 kt1 mi_idx2 it2 mc2)
 NestedLoop(mi_idx1 ml lt it1 t1 kt1 mi_idx2 it2)
 NestedLoop(mi_idx1 ml lt it1 t1 kt1 mi_idx2)
 HashJoin(mi_idx1 ml lt it1 t1 kt1)
 NestedLoop(mi_idx1 ml lt it1 t1)
 HashJoin(mi_idx1 ml lt it1)
 MergeJoin(mi_idx1 ml lt)
 HashJoin(ml lt)
 IndexScan(mi_idx1)
 SeqScan(ml)
 SeqScan(lt)
 SeqScan(it1)
 IndexScan(t1)
 SeqScan(kt1)
 IndexScan(mi_idx2)
 IndexScan(it2)
 IndexScan(mc2)
 IndexScan(t2)
 IndexScan(mc1)
 IndexScan(cn1)
 IndexScan(cn2)
 IndexScan(kt2)
 Leading(((((((((((((mi_idx1 (ml lt)) it1) t1) kt1) mi_idx2) it2) mc2) t2) mc1) cn1) cn2) kt2)) */
SELECT MIN(cn1.name) AS first_company, MIN(cn2.name) AS second_company, MIN(mi_idx1.info) AS first_rating, MIN(mi_idx2.info) AS second_rating, MIN(t1.title) AS first_movie, MIN(t2.title) AS second_movie FROM company_name AS cn1, company_name AS cn2, info_type AS it1, info_type AS it2, kind_type AS kt1, kind_type AS kt2, link_type AS lt, movie_companies AS mc1, movie_companies AS mc2, movie_info_idx AS mi_idx1, movie_info_idx AS mi_idx2, movie_link AS ml, title AS t1, title AS t2 WHERE cn1.country_code  = '[us]' AND it1.info  = 'rating' AND it2.info  = 'rating' AND kt1.kind  in ('tv series') AND kt2.kind  in ('tv series') AND lt.link  in ('sequel', 'follows', 'followed by') AND mi_idx2.info  < '3.0' AND t2.production_year  between 2005 and 2008 AND lt.id = ml.link_type_id AND t1.id = ml.movie_id AND t2.id = ml.linked_movie_id AND it1.id = mi_idx1.info_type_id AND t1.id = mi_idx1.movie_id AND kt1.id = t1.kind_id AND cn1.id = mc1.company_id AND t1.id = mc1.movie_id AND ml.movie_id = mi_idx1.movie_id AND ml.movie_id = mc1.movie_id AND mi_idx1.movie_id = mc1.movie_id AND it2.id = mi_idx2.info_type_id AND t2.id = mi_idx2.movie_id AND kt2.id = t2.kind_id AND cn2.id = mc2.company_id AND t2.id = mc2.movie_id AND ml.linked_movie_id = mi_idx2.movie_id AND ml.linked_movie_id = mc2.movie_id AND mi_idx2.movie_id = mc2.movie_id;


-- imdbload_job33b.sql
-- 14.627
/*+ NestedLoop(mi_idx1 ml lt it1 t1 kt1 mi_idx2 it2 mc1 cn1 mc2 cn2 t2 kt2)
 NestedLoop(mi_idx1 ml lt it1 t1 kt1 mi_idx2 it2 mc1 cn1 mc2 cn2 t2)
 NestedLoop(mi_idx1 ml lt it1 t1 kt1 mi_idx2 it2 mc1 cn1 mc2 cn2)
 NestedLoop(mi_idx1 ml lt it1 t1 kt1 mi_idx2 it2 mc1 cn1 mc2)
 NestedLoop(mi_idx1 ml lt it1 t1 kt1 mi_idx2 it2 mc1 cn1)
 NestedLoop(mi_idx1 ml lt it1 t1 kt1 mi_idx2 it2 mc1)
 NestedLoop(mi_idx1 ml lt it1 t1 kt1 mi_idx2 it2)
 NestedLoop(mi_idx1 ml lt it1 t1 kt1 mi_idx2)
 HashJoin(mi_idx1 ml lt it1 t1 kt1)
 NestedLoop(mi_idx1 ml lt it1 t1)
 HashJoin(mi_idx1 ml lt it1)
 MergeJoin(mi_idx1 ml lt)
 HashJoin(ml lt)
 IndexScan(mi_idx1)
 SeqScan(ml)
 SeqScan(lt)
 SeqScan(it1)
 IndexScan(t1)
 SeqScan(kt1)
 IndexScan(mi_idx2)
 IndexScan(it2)
 IndexScan(mc1)
 IndexScan(cn1)
 IndexScan(mc2)
 IndexScan(cn2)
 IndexScan(t2)
 IndexScan(kt2)
 Leading(((((((((((((mi_idx1 (ml lt)) it1) t1) kt1) mi_idx2) it2) mc1) cn1) mc2) cn2) t2) kt2)) */
SELECT MIN(cn1.name) AS first_company, MIN(cn2.name) AS second_company, MIN(mi_idx1.info) AS first_rating, MIN(mi_idx2.info) AS second_rating, MIN(t1.title) AS first_movie, MIN(t2.title) AS second_movie FROM company_name AS cn1, company_name AS cn2, info_type AS it1, info_type AS it2, kind_type AS kt1, kind_type AS kt2, link_type AS lt, movie_companies AS mc1, movie_companies AS mc2, movie_info_idx AS mi_idx1, movie_info_idx AS mi_idx2, movie_link AS ml, title AS t1, title AS t2 WHERE cn1.country_code  = '[nl]' AND it1.info  = 'rating' AND it2.info  = 'rating' AND kt1.kind  in ('tv series') AND kt2.kind  in ('tv series') AND lt.link  LIKE '%follow%' AND mi_idx2.info  < '3.0' AND t2.production_year  = 2007 AND lt.id = ml.link_type_id AND t1.id = ml.movie_id AND t2.id = ml.linked_movie_id AND it1.id = mi_idx1.info_type_id AND t1.id = mi_idx1.movie_id AND kt1.id = t1.kind_id AND cn1.id = mc1.company_id AND t1.id = mc1.movie_id AND ml.movie_id = mi_idx1.movie_id AND ml.movie_id = mc1.movie_id AND mi_idx1.movie_id = mc1.movie_id AND it2.id = mi_idx2.info_type_id AND t2.id = mi_idx2.movie_id AND kt2.id = t2.kind_id AND cn2.id = mc2.company_id AND t2.id = mc2.movie_id AND ml.linked_movie_id = mi_idx2.movie_id AND ml.linked_movie_id = mc2.movie_id AND mi_idx2.movie_id = mc2.movie_id;


-- imdbload_job33c.sql
-- 15.93
/*+ NestedLoop(mi_idx1 ml lt it1 t1 kt1 mi_idx2 it2 t2 mc1 cn1 kt2 mc2 cn2)
 NestedLoop(mi_idx1 ml lt it1 t1 kt1 mi_idx2 it2 t2 mc1 cn1 kt2 mc2)
 NestedLoop(mi_idx1 ml lt it1 t1 kt1 mi_idx2 it2 t2 mc1 cn1 kt2)
 NestedLoop(mi_idx1 ml lt it1 t1 kt1 mi_idx2 it2 t2 mc1 cn1)
 NestedLoop(mi_idx1 ml lt it1 t1 kt1 mi_idx2 it2 t2 mc1)
 NestedLoop(mi_idx1 ml lt it1 t1 kt1 mi_idx2 it2 t2)
 NestedLoop(mi_idx1 ml lt it1 t1 kt1 mi_idx2 it2)
 NestedLoop(mi_idx1 ml lt it1 t1 kt1 mi_idx2)
 HashJoin(mi_idx1 ml lt it1 t1 kt1)
 NestedLoop(mi_idx1 ml lt it1 t1)
 HashJoin(mi_idx1 ml lt it1)
 MergeJoin(mi_idx1 ml lt)
 HashJoin(ml lt)
 IndexScan(mi_idx1)
 SeqScan(ml)
 SeqScan(lt)
 SeqScan(it1)
 IndexScan(t1)
 SeqScan(kt1)
 IndexScan(mi_idx2)
 IndexScan(it2)
 IndexScan(t2)
 IndexScan(mc1)
 IndexScan(cn1)
 IndexScan(kt2)
 IndexScan(mc2)
 IndexScan(cn2)
 Leading(((((((((((((mi_idx1 (ml lt)) it1) t1) kt1) mi_idx2) it2) t2) mc1) cn1) kt2) mc2) cn2)) */
SELECT MIN(cn1.name) AS first_company, MIN(cn2.name) AS second_company, MIN(mi_idx1.info) AS first_rating, MIN(mi_idx2.info) AS second_rating, MIN(t1.title) AS first_movie, MIN(t2.title) AS second_movie FROM company_name AS cn1, company_name AS cn2, info_type AS it1, info_type AS it2, kind_type AS kt1, kind_type AS kt2, link_type AS lt, movie_companies AS mc1, movie_companies AS mc2, movie_info_idx AS mi_idx1, movie_info_idx AS mi_idx2, movie_link AS ml, title AS t1, title AS t2 WHERE cn1.country_code  != '[us]' AND it1.info  = 'rating' AND it2.info  = 'rating' AND kt1.kind  in ('tv series', 'episode') AND kt2.kind  in ('tv series', 'episode') AND lt.link  in ('sequel', 'follows', 'followed by') AND mi_idx2.info  < '3.5' AND t2.production_year  between 2000 and 2010 AND lt.id = ml.link_type_id AND t1.id = ml.movie_id AND t2.id = ml.linked_movie_id AND it1.id = mi_idx1.info_type_id AND t1.id = mi_idx1.movie_id AND kt1.id = t1.kind_id AND cn1.id = mc1.company_id AND t1.id = mc1.movie_id AND ml.movie_id = mi_idx1.movie_id AND ml.movie_id = mc1.movie_id AND mi_idx1.movie_id = mc1.movie_id AND it2.id = mi_idx2.info_type_id AND t2.id = mi_idx2.movie_id AND kt2.id = t2.kind_id AND cn2.id = mc2.company_id AND t2.id = mc2.movie_id AND ml.linked_movie_id = mi_idx2.movie_id AND ml.linked_movie_id = mc2.movie_id AND mi_idx2.movie_id = mc2.movie_id;


-- imdbload_job3a.sql
-- 85.936
/*+ NestedLoop(k mk t mi)
 NestedLoop(k mk t)
 NestedLoop(k mk)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(t)
 IndexScan(mi)
 Leading((((k mk) t) mi)) */
SELECT MIN(t.title) AS movie_title FROM keyword AS k, movie_info AS mi, movie_keyword AS mk, title AS t WHERE k.keyword  like '%sequel%' AND mi.info  IN ('Sweden', 'Norway', 'Germany', 'Denmark', 'Swedish', 'Denish', 'Norwegian', 'German') AND t.production_year > 2005 AND t.id = mi.movie_id AND t.id = mk.movie_id AND mk.movie_id = mi.movie_id AND k.id = mk.keyword_id;


-- imdbload_job3b.sql
-- 53.199
/*+ NestedLoop(k mk t mi)
 NestedLoop(k mk t)
 NestedLoop(k mk)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(t)
 IndexScan(mi)
 Leading((((k mk) t) mi)) */
SELECT MIN(t.title) AS movie_title FROM keyword AS k, movie_info AS mi, movie_keyword AS mk, title AS t WHERE k.keyword  like '%sequel%' AND mi.info  IN ('Bulgaria') AND t.production_year > 2010 AND t.id = mi.movie_id AND t.id = mk.movie_id AND mk.movie_id = mi.movie_id AND k.id = mk.keyword_id;


-- imdbload_job3c.sql
-- 147.407
/*+ NestedLoop(k mk t mi)
 NestedLoop(k mk t)
 NestedLoop(k mk)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(t)
 IndexScan(mi)
 Leading((((k mk) t) mi)) */
SELECT MIN(t.title) AS movie_title FROM keyword AS k, movie_info AS mi, movie_keyword AS mk, title AS t WHERE k.keyword  like '%sequel%' AND mi.info  IN ('Sweden', 'Norway', 'Germany', 'Denmark', 'Swedish', 'Denish', 'Norwegian', 'German', 'USA', 'American') AND t.production_year > 1990 AND t.id = mi.movie_id AND t.id = mk.movie_id AND mk.movie_id = mi.movie_id AND k.id = mk.keyword_id;


-- imdbload_job4a.sql
-- 55.487
/*+ NestedLoop(it k mk mi_idx t)
 NestedLoop(it k mk mi_idx)
 NestedLoop(k mk mi_idx)
 NestedLoop(k mk)
 SeqScan(it)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(mi_idx)
 IndexScan(t)
 Leading(((it ((k mk) mi_idx)) t)) */
SELECT MIN(mi_idx.info) AS rating, MIN(t.title) AS movie_title FROM info_type AS it, keyword AS k, movie_info_idx AS mi_idx, movie_keyword AS mk, title AS t WHERE it.info ='rating' AND k.keyword  like '%sequel%' AND mi_idx.info  > '5.0' AND t.production_year > 2005 AND t.id = mi_idx.movie_id AND t.id = mk.movie_id AND mk.movie_id = mi_idx.movie_id AND k.id = mk.keyword_id AND it.id = mi_idx.info_type_id;


-- imdbload_job4b.sql
-- 25.581
/*+ NestedLoop(mi_idx it t mk k)
 NestedLoop(mi_idx it t mk)
 NestedLoop(mi_idx it t)
 HashJoin(mi_idx it)
 SeqScan(mi_idx)
 SeqScan(it)
 IndexScan(t)
 IndexScan(mk)
 IndexScan(k)
 Leading(((((mi_idx it) t) mk) k)) */
SELECT MIN(mi_idx.info) AS rating, MIN(t.title) AS movie_title FROM info_type AS it, keyword AS k, movie_info_idx AS mi_idx, movie_keyword AS mk, title AS t WHERE it.info ='rating' AND k.keyword  like '%sequel%' AND mi_idx.info  > '9.0' AND t.production_year > 2010 AND t.id = mi_idx.movie_id AND t.id = mk.movie_id AND mk.movie_id = mi_idx.movie_id AND k.id = mk.keyword_id AND it.id = mi_idx.info_type_id;


-- imdbload_job4c.sql
-- 59.953
/*+ NestedLoop(it k mk mi_idx t)
 NestedLoop(it k mk mi_idx)
 NestedLoop(k mk mi_idx)
 NestedLoop(k mk)
 SeqScan(it)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(mi_idx)
 IndexScan(t)
 Leading(((it ((k mk) mi_idx)) t)) */
SELECT MIN(mi_idx.info) AS rating, MIN(t.title) AS movie_title FROM info_type AS it, keyword AS k, movie_info_idx AS mi_idx, movie_keyword AS mk, title AS t WHERE it.info ='rating' AND k.keyword  like '%sequel%' AND mi_idx.info  > '2.0' AND t.production_year > 1990 AND t.id = mi_idx.movie_id AND t.id = mk.movie_id AND mk.movie_id = mi_idx.movie_id AND k.id = mk.keyword_id AND it.id = mi_idx.info_type_id;


-- imdbload_job5a.sql
-- 42.25
/*+ HashJoin(mc ct t mi it)
 NestedLoop(mc ct t mi)
 NestedLoop(mc ct t)
 HashJoin(mc ct)
 SeqScan(mc)
 SeqScan(ct)
 IndexScan(t)
 IndexScan(mi)
 SeqScan(it)
 Leading(((((mc ct) t) mi) it)) */
SELECT MIN(t.title) AS typical_european_movie FROM company_type AS ct, info_type AS it, movie_companies AS mc, movie_info AS mi, title AS t WHERE ct.kind  = 'production companies' AND mc.note  like '%(theatrical)%' and mc.note like '%(France)%' AND mi.info  IN ('Sweden', 'Norway', 'Germany', 'Denmark', 'Swedish', 'Denish', 'Norwegian', 'German') AND t.production_year > 2005 AND t.id = mi.movie_id AND t.id = mc.movie_id AND mc.movie_id = mi.movie_id AND ct.id = mc.company_type_id AND it.id = mi.info_type_id;


-- imdbload_job5b.sql
-- 39.761
/*+ NestedLoop(mc ct t mi it)
 NestedLoop(mc ct t mi)
 NestedLoop(mc ct t)
 HashJoin(mc ct)
 SeqScan(mc)
 SeqScan(ct)
 IndexScan(t)
 IndexScan(mi)
 IndexOnlyScan(it)
 Leading(((((mc ct) t) mi) it)) */
SELECT MIN(t.title) AS american_vhs_movie FROM company_type AS ct, info_type AS it, movie_companies AS mc, movie_info AS mi, title AS t WHERE ct.kind  = 'production companies' AND mc.note  like '%(VHS)%' and mc.note like '%(USA)%' and mc.note like '%(1994)%' AND mi.info  IN ('USA', 'America') AND t.production_year > 2010 AND t.id = mi.movie_id AND t.id = mc.movie_id AND mc.movie_id = mi.movie_id AND ct.id = mc.company_type_id AND it.id = mi.info_type_id;


-- imdbload_job5c.sql
-- 54.18
/*+ HashJoin(mc ct t mi it)
 NestedLoop(mc ct t mi)
 NestedLoop(mc ct t)
 HashJoin(mc ct)
 SeqScan(mc)
 SeqScan(ct)
 IndexScan(t)
 IndexScan(mi)
 SeqScan(it)
 Leading(((((mc ct) t) mi) it)) */
SELECT MIN(t.title) AS american_movie FROM company_type AS ct, info_type AS it, movie_companies AS mc, movie_info AS mi, title AS t WHERE ct.kind  = 'production companies' AND mc.note  not like '%(TV)%' and mc.note like '%(USA)%' AND mi.info  IN ('Sweden', 'Norway', 'Germany', 'Denmark', 'Swedish', 'Denish', 'Norwegian', 'German', 'USA', 'American') AND t.production_year > 1990 AND t.id = mi.movie_id AND t.id = mc.movie_id AND mc.movie_id = mi.movie_id AND ct.id = mc.company_type_id AND it.id = mi.info_type_id;


-- imdbload_job6a.sql
-- 14.123
/*+ NestedLoop(k mk t ci n)
 NestedLoop(k mk t ci)
 NestedLoop(k mk t)
 NestedLoop(k mk)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(t)
 IndexScan(ci)
 IndexScan(n)
 Leading(((((k mk) t) ci) n)) */
SELECT MIN(k.keyword) AS movie_keyword, MIN(n.name) AS actor_name, MIN(t.title) AS marvel_movie FROM cast_info AS ci, keyword AS k, movie_keyword AS mk, name AS n, title AS t WHERE k.keyword = 'marvel-cinematic-universe' AND n.name LIKE '%Downey%Robert%' AND t.production_year > 2010 AND k.id = mk.keyword_id AND t.id = mk.movie_id AND t.id = ci.movie_id AND ci.movie_id = mk.movie_id AND n.id = ci.person_id;


-- imdbload_job6b.sql
-- 109.443
/*+ NestedLoop(k mk t ci n)
 NestedLoop(k mk t ci)
 NestedLoop(k mk t)
 NestedLoop(k mk)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(t)
 IndexScan(ci)
 IndexScan(n)
 Leading(((((k mk) t) ci) n)) */
SELECT MIN(k.keyword) AS movie_keyword, MIN(n.name) AS actor_name, MIN(t.title) AS hero_movie FROM cast_info AS ci, keyword AS k, movie_keyword AS mk, name AS n, title AS t WHERE k.keyword in ('superhero', 'sequel', 'second-part', 'marvel-comics', 'based-on-comic', 'tv-special', 'fight', 'violence') AND n.name LIKE '%Downey%Robert%' AND t.production_year > 2014 AND k.id = mk.keyword_id AND t.id = mk.movie_id AND t.id = ci.movie_id AND ci.movie_id = mk.movie_id AND n.id = ci.person_id;


-- imdbload_job6c.sql
-- 5.768
/*+ NestedLoop(k mk t ci n)
 NestedLoop(k mk t ci)
 NestedLoop(k mk t)
 NestedLoop(k mk)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(t)
 IndexScan(ci)
 IndexScan(n)
 Leading(((((k mk) t) ci) n)) */
SELECT MIN(k.keyword) AS movie_keyword, MIN(n.name) AS actor_name, MIN(t.title) AS marvel_movie FROM cast_info AS ci, keyword AS k, movie_keyword AS mk, name AS n, title AS t WHERE k.keyword = 'marvel-cinematic-universe' AND n.name LIKE '%Downey%Robert%' AND t.production_year > 2014 AND k.id = mk.keyword_id AND t.id = mk.movie_id AND t.id = ci.movie_id AND ci.movie_id = mk.movie_id AND n.id = ci.person_id;


-- imdbload_job6d.sql
-- 2058.993
/*+ NestedLoop(k mk t ci n)
 NestedLoop(k mk t ci)
 NestedLoop(k mk t)
 NestedLoop(k mk)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(t)
 IndexScan(ci)
 IndexScan(n)
 Leading(((((k mk) t) ci) n)) */
SELECT MIN(k.keyword) AS movie_keyword, MIN(n.name) AS actor_name, MIN(t.title) AS hero_movie FROM cast_info AS ci, keyword AS k, movie_keyword AS mk, name AS n, title AS t WHERE k.keyword in ('superhero', 'sequel', 'second-part', 'marvel-comics', 'based-on-comic', 'tv-special', 'fight', 'violence') AND n.name LIKE '%Downey%Robert%' AND t.production_year > 2000 AND k.id = mk.keyword_id AND t.id = mk.movie_id AND t.id = ci.movie_id AND ci.movie_id = mk.movie_id AND n.id = ci.person_id;


-- imdbload_job6e.sql
-- 10.48
/*+ NestedLoop(k mk t ci n)
 NestedLoop(k mk t ci)
 NestedLoop(k mk t)
 NestedLoop(k mk)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(t)
 IndexScan(ci)
 IndexScan(n)
 Leading(((((k mk) t) ci) n)) */
SELECT MIN(k.keyword) AS movie_keyword, MIN(n.name) AS actor_name, MIN(t.title) AS marvel_movie FROM cast_info AS ci, keyword AS k, movie_keyword AS mk, name AS n, title AS t WHERE k.keyword = 'marvel-cinematic-universe' AND n.name LIKE '%Downey%Robert%' AND t.production_year > 2000 AND k.id = mk.keyword_id AND t.id = mk.movie_id AND t.id = ci.movie_id AND ci.movie_id = mk.movie_id AND n.id = ci.person_id;


-- imdbload_job6f.sql
-- 1798.141
/*+ NestedLoop(k mk t ci n)
 NestedLoop(k mk t ci)
 NestedLoop(k mk t)
 NestedLoop(k mk)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(t)
 IndexScan(ci)
 IndexScan(n)
 Leading(((((k mk) t) ci) n)) */
SELECT MIN(k.keyword) AS movie_keyword, MIN(n.name) AS actor_name, MIN(t.title) AS hero_movie FROM cast_info AS ci, keyword AS k, movie_keyword AS mk, name AS n, title AS t WHERE k.keyword in ('superhero', 'sequel', 'second-part', 'marvel-comics', 'based-on-comic', 'tv-special', 'fight', 'violence') AND t.production_year > 2000 AND k.id = mk.keyword_id AND t.id = mk.movie_id AND t.id = ci.movie_id AND ci.movie_id = mk.movie_id AND n.id = ci.person_id;


-- imdbload_job7a.sql
-- 363.418
/*+ NestedLoop(ml lt t ci n pi an it)
 NestedLoop(ml lt t ci n pi an)
 NestedLoop(ml lt t ci n pi)
 NestedLoop(ml lt t ci n)
 NestedLoop(ml lt t ci)
 NestedLoop(ml lt t)
 HashJoin(ml lt)
 SeqScan(ml)
 SeqScan(lt)
 IndexScan(t)
 IndexScan(ci)
 IndexScan(n)
 IndexScan(pi)
 IndexScan(an)
 SeqScan(it)
 Leading((((((((ml lt) t) ci) n) pi) an) it)) */
SELECT MIN(n.name) AS of_person, MIN(t.title) AS biography_movie FROM aka_name AS an, cast_info AS ci, info_type AS it, link_type AS lt, movie_link AS ml, name AS n, person_info AS pi, title AS t WHERE an.name LIKE '%a%' AND it.info ='mini biography' AND lt.link ='features' AND n.name_pcode_cf BETWEEN 'A' AND 'F' AND (n.gender = 'm' OR (n.gender = 'f' AND n.name LIKE 'B%')) AND pi.note ='Volker Boehm' AND t.production_year BETWEEN 1980 AND 1995 AND n.id = an.person_id AND n.id = pi.person_id AND ci.person_id = n.id AND t.id = ci.movie_id AND ml.linked_movie_id = t.id AND lt.id = ml.link_type_id AND it.id = pi.info_type_id AND pi.person_id = an.person_id AND pi.person_id = ci.person_id AND an.person_id = ci.person_id AND ci.movie_id = ml.linked_movie_id;


-- imdbload_job7b.sql
-- 110.046
/*+ NestedLoop(ml lt t ci n pi an it)
 NestedLoop(ml lt t ci n pi an)
 NestedLoop(ml lt t ci n pi)
 NestedLoop(ml lt t ci n)
 NestedLoop(ml lt t ci)
 NestedLoop(ml lt t)
 HashJoin(ml lt)
 SeqScan(ml)
 SeqScan(lt)
 IndexScan(t)
 IndexScan(ci)
 IndexScan(n)
 IndexScan(pi)
 IndexScan(an)
 SeqScan(it)
 Leading((((((((ml lt) t) ci) n) pi) an) it)) */
SELECT MIN(n.name) AS of_person, MIN(t.title) AS biography_movie FROM aka_name AS an, cast_info AS ci, info_type AS it, link_type AS lt, movie_link AS ml, name AS n, person_info AS pi, title AS t WHERE an.name LIKE '%a%' AND it.info ='mini biography' AND lt.link ='features' AND n.name_pcode_cf LIKE 'D%' AND n.gender = 'm' AND pi.note ='Volker Boehm' AND t.production_year BETWEEN 1980 AND 1984 AND n.id = an.person_id AND n.id = pi.person_id AND ci.person_id = n.id AND t.id = ci.movie_id AND ml.linked_movie_id = t.id AND lt.id = ml.link_type_id AND it.id = pi.info_type_id AND pi.person_id = an.person_id AND pi.person_id = ci.person_id AND an.person_id = ci.person_id AND ci.movie_id = ml.linked_movie_id;


-- imdbload_job7c.sql
-- 327.767
/*+ NestedLoop(pi it an n ci ml lt t)
 HashJoin(pi it an n ci ml lt)
 NestedLoop(pi it an n ci ml)
 NestedLoop(pi it an n ci)
 NestedLoop(pi it an n)
 NestedLoop(pi it an)
 HashJoin(pi it)
 SeqScan(pi)
 SeqScan(it)
 IndexScan(an)
 IndexScan(n)
 IndexScan(ci)
 IndexScan(ml)
 SeqScan(lt)
 IndexScan(t)
 Leading((((((((pi it) an) n) ci) ml) lt) t)) */
SELECT MIN(n.name) AS cast_member_name, MIN(pi.info) AS cast_member_info FROM aka_name AS an, cast_info AS ci, info_type AS it, link_type AS lt, movie_link AS ml, name AS n, person_info AS pi, title AS t WHERE an.name  is not NULL and (an.name LIKE '%a%' or an.name LIKE 'A%') AND it.info ='mini biography' AND lt.link  in ('references', 'referenced in', 'features', 'featured in') AND n.name_pcode_cf BETWEEN 'A' AND 'F' AND (n.gender = 'm' OR (n.gender = 'f' AND n.name LIKE 'A%')) AND pi.note  is not NULL AND t.production_year BETWEEN 1980 AND 2010 AND n.id = an.person_id AND n.id = pi.person_id AND ci.person_id = n.id AND t.id = ci.movie_id AND ml.linked_movie_id = t.id AND lt.id = ml.link_type_id AND it.id = pi.info_type_id AND pi.person_id = an.person_id AND pi.person_id = ci.person_id AND an.person_id = ci.person_id AND ci.movie_id = ml.linked_movie_id;


-- imdbload_job8a.sql
-- 333.45
/*+ NestedLoop(mc cn t ci rt an1 n1)
 NestedLoop(mc cn t ci rt an1)
 HashJoin(mc cn t ci rt)
 NestedLoop(mc cn t ci)
 NestedLoop(mc cn t)
 HashJoin(mc cn)
 SeqScan(mc)
 SeqScan(cn)
 IndexScan(t)
 IndexScan(ci)
 SeqScan(rt)
 IndexScan(an1)
 IndexScan(n1)
 Leading(((((((mc cn) t) ci) rt) an1) n1)) */
SELECT MIN(an1.name) AS actress_pseudonym, MIN(t.title) AS japanese_movie_dubbed FROM aka_name AS an1, cast_info AS ci, company_name AS cn, movie_companies AS mc, name AS n1, role_type AS rt, title AS t WHERE ci.note ='(voice: English version)' AND cn.country_code ='[jp]' AND mc.note like '%(Japan)%' and mc.note not like '%(USA)%' AND n1.name like '%Yo%' and n1.name not like '%Yu%' AND rt.role ='actress' AND an1.person_id = n1.id AND n1.id = ci.person_id AND ci.movie_id = t.id AND t.id = mc.movie_id AND mc.company_id = cn.id AND ci.role_id = rt.id AND an1.person_id = ci.person_id AND ci.movie_id = mc.movie_id;


-- imdbload_job8b.sql
-- 50.71
/*+ NestedLoop(mc cn t ci an n rt)
 NestedLoop(mc cn t ci an n)
 NestedLoop(mc cn t ci an)
 NestedLoop(mc cn t ci)
 NestedLoop(mc cn t)
 NestedLoop(mc cn)
 SeqScan(mc)
 IndexScan(cn)
 IndexScan(t)
 IndexScan(ci)
 IndexScan(an)
 IndexScan(n)
 IndexScan(rt)
 Leading(((((((mc cn) t) ci) an) n) rt)) */
SELECT MIN(an.name) AS acress_pseudonym, MIN(t.title) AS japanese_anime_movie FROM aka_name AS an, cast_info AS ci, company_name AS cn, movie_companies AS mc, name AS n, role_type AS rt, title AS t WHERE ci.note ='(voice: English version)' AND cn.country_code ='[jp]' AND mc.note like '%(Japan)%' and mc.note not like '%(USA)%' and (mc.note like '%(2006)%' or mc.note like '%(2007)%') AND n.name like '%Yo%' and n.name not like '%Yu%' AND rt.role ='actress' AND t.production_year between 2006 and 2007 and (t.title like 'One Piece%' or t.title like 'Dragon Ball Z%') AND an.person_id = n.id AND n.id = ci.person_id AND ci.movie_id = t.id AND t.id = mc.movie_id AND mc.company_id = cn.id AND ci.role_id = rt.id AND an.person_id = ci.person_id AND ci.movie_id = mc.movie_id;


-- imdbload_job8c.sql
-- 1302.278
/*+ HashJoin(a1 t mc cn rt ci n1)
 NestedLoop(t mc cn rt ci n1)
 HashJoin(t mc cn rt ci)
 NestedLoop(rt ci)
 HashJoin(t mc cn)
 HashJoin(mc cn)
 SeqScan(a1)
 SeqScan(t)
 SeqScan(mc)
 SeqScan(cn)
 SeqScan(rt)
 IndexScan(ci)
 IndexOnlyScan(n1)
 Leading((a1 (((t (mc cn)) (rt ci)) n1))) */
SELECT MIN(a1.name) AS writer_pseudo_name, MIN(t.title) AS movie_title FROM aka_name AS a1, cast_info AS ci, company_name AS cn, movie_companies AS mc, name AS n1, role_type AS rt, title AS t WHERE cn.country_code ='[us]' AND rt.role ='writer' AND a1.person_id = n1.id AND n1.id = ci.person_id AND ci.movie_id = t.id AND t.id = mc.movie_id AND mc.company_id = cn.id AND ci.role_id = rt.id AND a1.person_id = ci.person_id AND ci.movie_id = mc.movie_id;


-- imdbload_job8d.sql
-- 458.808
/*+ HashJoin(an1 t mc cn rt ci n1)
 NestedLoop(t mc cn rt ci n1)
 HashJoin(t mc cn rt ci)
 NestedLoop(rt ci)
 HashJoin(t mc cn)
 HashJoin(mc cn)
 SeqScan(an1)
 SeqScan(t)
 SeqScan(mc)
 SeqScan(cn)
 SeqScan(rt)
 IndexScan(ci)
 IndexOnlyScan(n1)
 Leading((an1 (((t (mc cn)) (rt ci)) n1))) */
SELECT MIN(an1.name) AS costume_designer_pseudo, MIN(t.title) AS movie_with_costumes FROM aka_name AS an1, cast_info AS ci, company_name AS cn, movie_companies AS mc, name AS n1, role_type AS rt, title AS t WHERE cn.country_code ='[us]' AND rt.role ='costume designer' AND an1.person_id = n1.id AND n1.id = ci.person_id AND ci.movie_id = t.id AND t.id = mc.movie_id AND mc.company_id = cn.id AND ci.role_id = rt.id AND an1.person_id = ci.person_id AND ci.movie_id = mc.movie_id;


-- imdbload_job9a.sql
-- 79.745
/*+ NestedLoop(n an ci rt t mc chn cn)
 NestedLoop(n an ci rt t mc chn)
 NestedLoop(n an ci rt t mc)
 NestedLoop(n an ci rt t)
 HashJoin(n an ci rt)
 NestedLoop(n an ci)
 NestedLoop(n an)
 SeqScan(n)
 IndexScan(an)
 IndexScan(ci)
 SeqScan(rt)
 IndexScan(t)
 IndexScan(mc)
 IndexScan(chn)
 IndexScan(cn)
 Leading((((((((n an) ci) rt) t) mc) chn) cn)) */
SELECT MIN(an.name) AS alternative_name, MIN(chn.name) AS character_name, MIN(t.title) AS movie FROM aka_name AS an, char_name AS chn, cast_info AS ci, company_name AS cn, movie_companies AS mc, name AS n, role_type AS rt, title AS t WHERE ci.note  in ('(voice)', '(voice: Japanese version)', '(voice) (uncredited)', '(voice: English version)') AND cn.country_code ='[us]' AND mc.note  is not NULL and (mc.note like '%(USA)%' or mc.note like '%(worldwide)%') AND n.gender ='f' and n.name like '%Ang%' AND rt.role ='actress' AND t.production_year  between 2005 and 2015 AND ci.movie_id = t.id AND t.id = mc.movie_id AND ci.movie_id = mc.movie_id AND mc.company_id = cn.id AND ci.role_id = rt.id AND n.id = ci.person_id AND chn.id = ci.person_role_id AND an.person_id = n.id AND an.person_id = ci.person_id;


-- imdbload_job9b.sql
-- 67.564
/*+ NestedLoop(n an ci rt mc chn cn t)
 NestedLoop(n an ci rt mc chn cn)
 NestedLoop(n an ci rt mc chn)
 NestedLoop(n an ci rt mc)
 HashJoin(n an ci rt)
 NestedLoop(n an ci)
 NestedLoop(n an)
 SeqScan(n)
 IndexScan(an)
 IndexScan(ci)
 SeqScan(rt)
 IndexScan(mc)
 IndexScan(chn)
 IndexScan(cn)
 IndexScan(t)
 Leading((((((((n an) ci) rt) mc) chn) cn) t)) */
SELECT MIN(an.name) AS alternative_name, MIN(chn.name) AS voiced_character, MIN(n.name) AS voicing_actress, MIN(t.title) AS american_movie FROM aka_name AS an, char_name AS chn, cast_info AS ci, company_name AS cn, movie_companies AS mc, name AS n, role_type AS rt, title AS t WHERE ci.note  = '(voice)' AND cn.country_code ='[us]' AND mc.note  like '%(200%)%' and (mc.note like '%(USA)%' or mc.note like '%(worldwide)%') AND n.gender ='f' and n.name like '%Angel%' AND rt.role ='actress' AND t.production_year  between 2007 and 2010 AND ci.movie_id = t.id AND t.id = mc.movie_id AND ci.movie_id = mc.movie_id AND mc.company_id = cn.id AND ci.role_id = rt.id AND n.id = ci.person_id AND chn.id = ci.person_role_id AND an.person_id = n.id AND an.person_id = ci.person_id;


-- imdbload_job9c.sql
-- 135.281
/*+ NestedLoop(an n ci rt mc cn chn t)
 NestedLoop(an n ci rt mc cn chn)
 NestedLoop(an n ci rt mc cn)
 NestedLoop(an n ci rt mc)
 HashJoin(an n ci rt)
 NestedLoop(an n ci)
 HashJoin(an n)
 SeqScan(an)
 SeqScan(n)
 IndexScan(ci)
 SeqScan(rt)
 IndexScan(mc)
 IndexScan(cn)
 IndexScan(chn)
 IndexScan(t)
 Leading((((((((an n) ci) rt) mc) cn) chn) t)) */
SELECT MIN(an.name) AS alternative_name, MIN(chn.name) AS voiced_character_name, MIN(n.name) AS voicing_actress, MIN(t.title) AS american_movie FROM aka_name AS an, char_name AS chn, cast_info AS ci, company_name AS cn, movie_companies AS mc, name AS n, role_type AS rt, title AS t WHERE ci.note  in ('(voice)', '(voice: Japanese version)', '(voice) (uncredited)', '(voice: English version)') AND cn.country_code ='[us]' AND n.gender ='f' and n.name like '%An%' AND rt.role ='actress' AND ci.movie_id = t.id AND t.id = mc.movie_id AND ci.movie_id = mc.movie_id AND mc.company_id = cn.id AND ci.role_id = rt.id AND n.id = ci.person_id AND chn.id = ci.person_role_id AND an.person_id = n.id AND an.person_id = ci.person_id;


-- imdbload_job9d.sql
-- 904.974
/*+ NestedLoop(mc cn rt ci n chn t an)
 NestedLoop(mc cn rt ci n chn t)
 NestedLoop(mc cn rt ci n chn)
 NestedLoop(mc cn rt ci n)
 HashJoin(mc cn rt ci)
 NestedLoop(rt ci)
 HashJoin(mc cn)
 SeqScan(mc)
 SeqScan(cn)
 SeqScan(rt)
 IndexScan(ci)
 IndexScan(n)
 IndexScan(chn)
 IndexScan(t)
 IndexScan(an)
 Leading(((((((mc cn) (rt ci)) n) chn) t) an)) */
SELECT MIN(an.name) AS alternative_name, MIN(chn.name) AS voiced_char_name, MIN(n.name) AS voicing_actress, MIN(t.title) AS american_movie FROM aka_name AS an, char_name AS chn, cast_info AS ci, company_name AS cn, movie_companies AS mc, name AS n, role_type AS rt, title AS t WHERE ci.note  in ('(voice)', '(voice: Japanese version)', '(voice) (uncredited)', '(voice: English version)') AND cn.country_code ='[us]' AND n.gender ='f' AND rt.role ='actress' AND ci.movie_id = t.id AND t.id = mc.movie_id AND ci.movie_id = mc.movie_id AND mc.company_id = cn.id AND ci.role_id = rt.id AND n.id = ci.person_id AND chn.id = ci.person_role_id AND an.person_id = n.id AND an.person_id = ci.person_id;