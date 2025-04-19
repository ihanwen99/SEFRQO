/*+ MergeJoin(cn mc t ci chn rt ct)
 NestLoop(cn mc t ci chn rt)
 NestLoop(cn mc t ci chn)
 NestLoop(cn mc t ci)
 NestLoop(cn mc t)
 NestLoop(cn mc)
 SeqScan(cn)
 IndexScan(mc)
 IndexScan(t)
 IndexScan(ci)
 IndexScan(chn)
 SeqScan(rt)
 SeqScan(ct)
 Leading(((((((cn mc) t) ci) chn) rt) ct)) */
SELECT MIN(chn.name) AS character,
       MIN(t.title) AS russian_mov_with_actor_producer
FROM char_name AS chn,
     cast_info AS ci,
     company_name AS cn,
     company_type AS ct,
     movie_companies AS mc,
     role_type AS rt,
     title AS t
WHERE ci.note LIKE '%(producer)%'
  AND cn.country_code = '[ru]'
  AND rt.role = 'actor'
  AND t.production_year > 2010
  AND t.id = mc.movie_id
  AND t.id = ci.movie_id
  AND ci.movie_id = mc.movie_id
  AND chn.id = ci.person_role_id
  AND rt.id = ci.role_id
  AND cn.id = mc.company_id
  AND ct.id = mc.company_type_id;


/*+ HashJoin(ci chn rt t mc cn ct)
 NestLoop(ci chn rt t mc cn)
 NestLoop(ci chn rt t mc)
 NestLoop(ci chn rt t)
 NestLoop(ci chn rt)
 NestLoop(ci chn)
 SeqScan(ci)
 IndexScan(chn)
 IndexScan(rt)
 IndexScan(t)
 IndexScan(mc)
 IndexScan(cn)
 SeqScan(ct)
 Leading(((((((ci chn) rt) t) mc) cn) ct)) */
SELECT MIN(chn.name) AS character,
       MIN(t.title) AS movie_with_american_producer
FROM char_name AS chn,
     cast_info AS ci,
     company_name AS cn,
     company_type AS ct,
     movie_companies AS mc,
     role_type AS rt,
     title AS t
WHERE ci.note LIKE '%(producer)%'
  AND cn.country_code = '[us]'
  AND t.production_year > 1990
  AND t.id = mc.movie_id
  AND t.id = ci.movie_id
  AND ci.movie_id = mc.movie_id
  AND chn.id = ci.person_role_id
  AND rt.id = ci.role_id
  AND cn.id = mc.company_id
  AND ct.id = mc.company_type_id;


/*+ NestLoop(ct ml lt t mc cn mk k)
 NestLoop(ct ml lt t mc cn mk)
 NestLoop(ct ml lt t mc cn)
 NestLoop(ct ml lt t mc)
 NestLoop(ml lt t mc)
 NestLoop(ml lt t)
 NestLoop(ml lt)
 SeqScan(ct)
 IndexScan(ml)
 SeqScan(lt)
 IndexScan(t)
 IndexScan(mc)
 IndexScan(cn)
 IndexScan(mk)
 IndexScan(k)
 Leading(((((ct (((ml lt) t) mc)) cn) mk) k)) */
SELECT MIN(cn.name) AS from_company,
       MIN(lt.link) AS movie_link_type,
       MIN(t.title) AS non_polish_sequel_movie
FROM company_name AS cn,
     company_type AS ct,
     keyword AS k,
     link_type AS lt,
     movie_companies AS mc,
     movie_keyword AS mk,
     movie_link AS ml,
     title AS t
WHERE cn.country_code !='[pl]'
  AND (cn.name LIKE '%Film%'
       OR cn.name LIKE '%Warner%')
  AND ct.kind ='production companies'
  AND k.keyword ='sequel'
  AND lt.link LIKE '%follow%'
  AND mc.note IS NULL
  AND t.production_year BETWEEN 1950 AND 2000
  AND lt.id = ml.link_type_id
  AND ml.movie_id = t.id
  AND t.id = mk.movie_id
  AND mk.keyword_id = k.id
  AND t.id = mc.movie_id
  AND mc.company_type_id = ct.id
  AND mc.company_id = cn.id
  AND ml.movie_id = mk.movie_id
  AND ml.movie_id = mc.movie_id
  AND mk.movie_id = mc.movie_id;


/*+ NestLoop(ml lt t mc cn ct mk k)
 NestLoop(ml lt t mc cn ct mk)
 HashJoin(ml lt t mc cn ct)
 NestLoop(ml lt t mc cn)
 NestLoop(ml lt t mc)
 NestLoop(ml lt t)
 NestLoop(ml lt)
 IndexScan(ml)
 SeqScan(lt)
 IndexScan(t)
 IndexScan(mc)
 IndexScan(cn)
 SeqScan(ct)
 IndexScan(mk)
 IndexScan(k)
 Leading((((((((ml lt) t) mc) cn) ct) mk) k)) */
SELECT MIN(cn.name) AS from_company,
       MIN(lt.link) AS movie_link_type,
       MIN(t.title) AS sequel_movie
FROM company_name AS cn,
     company_type AS ct,
     keyword AS k,
     link_type AS lt,
     movie_companies AS mc,
     movie_keyword AS mk,
     movie_link AS ml,
     title AS t
WHERE cn.country_code !='[pl]'
  AND (cn.name LIKE '%Film%'
       OR cn.name LIKE '%Warner%')
  AND ct.kind ='production companies'
  AND k.keyword ='sequel'
  AND lt.link LIKE '%follows%'
  AND mc.note IS NULL
  AND t.production_year = 1998
  AND t.title LIKE '%Money%'
  AND lt.id = ml.link_type_id
  AND ml.movie_id = t.id
  AND t.id = mk.movie_id
  AND mk.keyword_id = k.id
  AND t.id = mc.movie_id
  AND mc.company_type_id = ct.id
  AND mc.company_id = cn.id
  AND ml.movie_id = mk.movie_id
  AND ml.movie_id = mc.movie_id
  AND mk.movie_id = mc.movie_id;


/*+ HashJoin(lt k mk ml t mc cn ct)
 NestLoop(lt k mk ml t mc cn)
 NestLoop(lt k mk ml t mc)
 NestLoop(lt k mk ml t)
 NestLoop(lt k mk ml)
 NestLoop(k mk ml)
 NestLoop(k mk)
 SeqScan(lt)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(ml)
 IndexScan(t)
 IndexScan(mc)
 IndexScan(cn)
 SeqScan(ct)
 Leading((((((lt ((k mk) ml)) t) mc) cn) ct)) */
SELECT MIN(cn.name) AS from_company,
       MIN(mc.note) AS production_note,
       MIN(t.title) AS movie_based_on_book
FROM company_name AS cn,
     company_type AS ct,
     keyword AS k,
     link_type AS lt,
     movie_companies AS mc,
     movie_keyword AS mk,
     movie_link AS ml,
     title AS t
WHERE cn.country_code !='[pl]'
  AND (cn.name LIKE '20th Century Fox%'
       OR cn.name LIKE 'Twentieth Century Fox%')
  AND ct.kind != 'production companies'
  AND ct.kind IS NOT NULL
  AND k.keyword IN ('sequel',
                    'revenge',
                    'based-on-novel')
  AND mc.note IS NOT NULL
  AND t.production_year > 1950
  AND lt.id = ml.link_type_id
  AND ml.movie_id = t.id
  AND t.id = mk.movie_id
  AND mk.keyword_id = k.id
  AND t.id = mc.movie_id
  AND mc.company_type_id = ct.id
  AND mc.company_id = cn.id
  AND ml.movie_id = mk.movie_id
  AND ml.movie_id = mc.movie_id
  AND mk.movie_id = mc.movie_id;


/*+ HashJoin(lt k mk ml t mc cn ct)
 NestLoop(lt k mk ml t mc cn)
 NestLoop(lt k mk ml t mc)
 NestLoop(lt k mk ml t)
 NestLoop(lt k mk ml)
 NestLoop(k mk ml)
 NestLoop(k mk)
 SeqScan(lt)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(ml)
 IndexScan(t)
 IndexScan(mc)
 IndexScan(cn)
 IndexScan(ct)
 Leading((((((lt ((k mk) ml)) t) mc) cn) ct)) */
SELECT MIN(cn.name) AS from_company,
       MIN(mc.note) AS production_note,
       MIN(t.title) AS movie_based_on_book
FROM company_name AS cn,
     company_type AS ct,
     keyword AS k,
     link_type AS lt,
     movie_companies AS mc,
     movie_keyword AS mk,
     movie_link AS ml,
     title AS t
WHERE cn.country_code !='[pl]'
  AND ct.kind != 'production companies'
  AND ct.kind IS NOT NULL
  AND k.keyword IN ('sequel',
                    'revenge',
                    'based-on-novel')
  AND mc.note IS NOT NULL
  AND t.production_year > 1950
  AND lt.id = ml.link_type_id
  AND ml.movie_id = t.id
  AND t.id = mk.movie_id
  AND mk.keyword_id = k.id
  AND t.id = mc.movie_id
  AND mc.company_type_id = ct.id
  AND mc.company_id = cn.id
  AND ml.movie_id = mk.movie_id
  AND ml.movie_id = mc.movie_id
  AND mk.movie_id = mc.movie_id;


/*+ NestLoop(t kt miidx it mc ct mi it2 cn)
 MergeJoin(t kt miidx it mc ct mi it2)
 NestLoop(t kt miidx it mc ct mi)
 MergeJoin(t kt miidx it mc ct)
 NestLoop(t kt miidx it mc)
 NestLoop(t kt miidx it)
 NestLoop(t kt miidx)
 NestLoop(t kt)
 SeqScan(t)
 IndexScan(kt)
 IndexScan(miidx)
 SeqScan(it)
 IndexScan(mc)
 IndexScan(ct)
 IndexScan(mi)
 SeqScan(it2)
 IndexScan(cn)
 Leading(((((((((t kt) miidx) it) mc) ct) mi) it2) cn)) */
SELECT MIN(cn.name) AS producing_company,
       MIN(miidx.info) AS rating,
       MIN(t.title) AS movie_about_winning
FROM company_name AS cn,
     company_type AS ct,
     info_type AS it,
     info_type AS it2,
     kind_type AS kt,
     movie_companies AS mc,
     movie_info AS mi,
     movie_info_idx AS miidx,
     title AS t
WHERE cn.country_code ='[us]'
  AND ct.kind ='production companies'
  AND it.info ='rating'
  AND it2.info ='release dates'
  AND kt.kind ='movie'
  AND t.title != ''
  AND (t.title LIKE '%Champion%'
       OR t.title LIKE '%Loser%')
  AND mi.movie_id = t.id
  AND it2.id = mi.info_type_id
  AND kt.id = t.kind_id
  AND mc.movie_id = t.id
  AND cn.id = mc.company_id
  AND ct.id = mc.company_type_id
  AND miidx.movie_id = t.id
  AND it.id = miidx.info_type_id
  AND mi.movie_id = miidx.movie_id
  AND mi.movie_id = mc.movie_id
  AND miidx.movie_id = mc.movie_id;


/*+ MergeJoin(t kt miidx it mc cn mi it2 ct)
 NestLoop(t kt miidx it mc cn mi it2)
 NestLoop(t kt miidx it mc cn mi)
 NestLoop(t kt miidx it mc cn)
 NestLoop(t kt miidx it mc)
 NestLoop(t kt miidx it)
 NestLoop(t kt miidx)
 NestLoop(t kt)
 SeqScan(t)
 IndexScan(kt)
 IndexScan(miidx)
 SeqScan(it)
 IndexScan(mc)
 IndexScan(cn)
 IndexScan(mi)
 SeqScan(it2)
 SeqScan(ct)
 Leading(((((((((t kt) miidx) it) mc) cn) mi) it2) ct)) */
SELECT MIN(cn.name) AS producing_company,
       MIN(miidx.info) AS rating,
       MIN(t.title) AS movie_about_winning
FROM company_name AS cn,
     company_type AS ct,
     info_type AS it,
     info_type AS it2,
     kind_type AS kt,
     movie_companies AS mc,
     movie_info AS mi,
     movie_info_idx AS miidx,
     title AS t
WHERE cn.country_code ='[us]'
  AND ct.kind ='production companies'
  AND it.info ='rating'
  AND it2.info ='release dates'
  AND kt.kind ='movie'
  AND t.title != ''
  AND (t.title LIKE 'Champion%'
       OR t.title LIKE 'Loser%')
  AND mi.movie_id = t.id
  AND it2.id = mi.info_type_id
  AND kt.id = t.kind_id
  AND mc.movie_id = t.id
  AND cn.id = mc.company_id
  AND ct.id = mc.company_type_id
  AND miidx.movie_id = t.id
  AND it.id = miidx.info_type_id
  AND mi.movie_id = miidx.movie_id
  AND mi.movie_id = mc.movie_id
  AND miidx.movie_id = mc.movie_id;


/*+ HashJoin(t k mk kt mi_idx it2 mi it1)
 NestLoop(t k mk kt mi_idx it2 mi)
 HashJoin(t k mk kt mi_idx it2)
 NestLoop(t k mk kt mi_idx)
 HashJoin(t k mk kt)
 HashJoin(t k mk)
 NestLoop(k mk)
 SeqScan(t)
 SeqScan(k)
 IndexScan(mk)
 SeqScan(kt)
 IndexScan(mi_idx)
 SeqScan(it2)
 IndexScan(mi)
 IndexScan(it1)
 Leading(((((((t (k mk)) kt) mi_idx) it2) mi) it1)) */
SELECT MIN(mi_idx.info) AS rating,
       MIN(t.title) AS northern_dark_movie
FROM info_type AS it1,
     info_type AS it2,
     keyword AS k,
     kind_type AS kt,
     movie_info AS mi,
     movie_info_idx AS mi_idx,
     movie_keyword AS mk,
     title AS t
WHERE it1.info = 'countries'
  AND it2.info = 'rating'
  AND k.keyword IN ('murder',
                    'murder-in-title',
                    'blood',
                    'violence')
  AND kt.kind = 'movie'
  AND mi.info IN ('Sweden',
                  'Norway',
                  'Germany',
                  'Denmark',
                  'Swedish',
                  'Denish',
                  'Norwegian',
                  'German',
                  'USA',
                  'American')
  AND mi_idx.info < '8.5'
  AND t.production_year > 2010
  AND kt.id = t.kind_id
  AND t.id = mi.movie_id
  AND t.id = mk.movie_id
  AND t.id = mi_idx.movie_id
  AND mk.movie_id = mi.movie_id
  AND mk.movie_id = mi_idx.movie_id
  AND mi.movie_id = mi_idx.movie_id
  AND k.id = mk.keyword_id
  AND it1.id = mi.info_type_id
  AND it2.id = mi_idx.info_type_id;


/*+ NestLoop(t kt mi mi_idx it2 it1 mk k)
 NestLoop(t kt mi mi_idx it2 it1 mk)
 MergeJoin(t kt mi mi_idx it2 it1)
 NestLoop(t kt mi mi_idx it2)
 NestLoop(t kt mi mi_idx)
 NestLoop(t kt mi)
 NestLoop(t kt)
 SeqScan(t)
 IndexScan(kt)
 IndexScan(mi)
 IndexScan(mi_idx)
 SeqScan(it2)
 IndexScan(it1)
 IndexScan(mk)
 IndexScan(k)
 Leading((((((((t kt) mi) mi_idx) it2) it1) mk) k)) */
SELECT MIN(mi_idx.info) AS rating,
       MIN(t.title) AS western_dark_production
FROM info_type AS it1,
     info_type AS it2,
     keyword AS k,
     kind_type AS kt,
     movie_info AS mi,
     movie_info_idx AS mi_idx,
     movie_keyword AS mk,
     title AS t
WHERE it1.info = 'countries'
  AND it2.info = 'rating'
  AND k.keyword IN ('murder',
                    'murder-in-title')
  AND kt.kind = 'movie'
  AND mi.info IN ('Sweden',
                  'Norway',
                  'Germany',
                  'Denmark',
                  'Swedish',
                  'Denish',
                  'Norwegian',
                  'German',
                  'USA',
                  'American')
  AND mi_idx.info > '6.0'
  AND t.production_year > 2010
  AND (t.title LIKE '%murder%'
       OR t.title LIKE '%Murder%'
       OR t.title LIKE '%Mord%')
  AND kt.id = t.kind_id
  AND t.id = mi.movie_id
  AND t.id = mk.movie_id
  AND t.id = mi_idx.movie_id
  AND mk.movie_id = mi.movie_id
  AND mk.movie_id = mi_idx.movie_id
  AND mi.movie_id = mi_idx.movie_id
  AND k.id = mk.keyword_id
  AND it1.id = mi.info_type_id
  AND it2.id = mi_idx.info_type_id;


/*+ HashJoin(t k mk mi it1 kt mi_idx it2)
 NestLoop(t k mk mi it1 kt mi_idx)
 HashJoin(t k mk mi it1 kt)
 HashJoin(t k mk mi it1)
 NestLoop(t k mk mi)
 HashJoin(t k mk)
 NestLoop(k mk)
 SeqScan(t)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(mi)
 IndexScan(it1)
 SeqScan(kt)
 IndexScan(mi_idx)
 IndexScan(it2)
 Leading(((((((t (k mk)) mi) it1) kt) mi_idx) it2)) */
SELECT MIN(mi_idx.info) AS rating,
       MIN(t.title) AS north_european_dark_production
FROM info_type AS it1,
     info_type AS it2,
     keyword AS k,
     kind_type AS kt,
     movie_info AS mi,
     movie_info_idx AS mi_idx,
     movie_keyword AS mk,
     title AS t
WHERE it1.info = 'countries'
  AND it2.info = 'rating'
  AND k.keyword IS NOT NULL
  AND k.keyword IN ('murder',
                    'murder-in-title',
                    'blood',
                    'violence')
  AND kt.kind IN ('movie',
                  'episode')
  AND mi.info IN ('Sweden',
                  'Norway',
                  'Germany',
                  'Denmark',
                  'Swedish',
                  'Danish',
                  'Norwegian',
                  'German',
                  'USA',
                  'American')
  AND mi_idx.info < '8.5'
  AND t.production_year > 2005
  AND kt.id = t.kind_id
  AND t.id = mi.movie_id
  AND t.id = mk.movie_id
  AND t.id = mi_idx.movie_id
  AND mk.movie_id = mi.movie_id
  AND mk.movie_id = mi_idx.movie_id
  AND mi.movie_id = mi_idx.movie_id
  AND k.id = mk.keyword_id
  AND it1.id = mi.info_type_id
  AND it2.id = mi_idx.info_type_id;


/*+ NestLoop(mi t aka_t mc it1 cn ct mk k)
 NestLoop(mi t aka_t mc it1 cn ct mk)
 MergeJoin(mi t aka_t mc it1 cn ct)
 NestLoop(mi t aka_t mc it1 cn)
 MergeJoin(mi t aka_t mc it1)
 NestLoop(mi t aka_t mc)
 NestLoop(mi t aka_t)
 NestLoop(mi t)
 IndexScan(mi)
 IndexScan(t)
 IndexScan(aka_t)
 IndexScan(mc)
 SeqScan(it1)
 IndexScan(cn)
 SeqScan(ct)
 IndexScan(mk)
 IndexScan(k)
 Leading(((((((((mi t) aka_t) mc) it1) cn) ct) mk) k)) */
SELECT MIN(mi.info) AS release_date,
       MIN(t.title) AS internet_movie
FROM aka_title AS aka_t,
     company_name AS cn,
     company_type AS ct,
     info_type AS it1,
     keyword AS k,
     movie_companies AS mc,
     movie_info AS mi,
     movie_keyword AS mk,
     title AS t
WHERE cn.country_code = '[us]'
  AND it1.info = 'release dates'
  AND mc.note LIKE '%(200%)%'
  AND mc.note LIKE '%(worldwide)%'
  AND mi.note LIKE '%internet%'
  AND mi.info LIKE 'USA:% 200%'
  AND t.production_year > 2000
  AND t.id = aka_t.movie_id
  AND t.id = mi.movie_id
  AND t.id = mk.movie_id
  AND t.id = mc.movie_id
  AND mk.movie_id = mi.movie_id
  AND mk.movie_id = mc.movie_id
  AND mk.movie_id = aka_t.movie_id
  AND mi.movie_id = mc.movie_id
  AND mi.movie_id = aka_t.movie_id
  AND mc.movie_id = aka_t.movie_id
  AND k.id = mk.keyword_id
  AND it1.id = mi.info_type_id
  AND cn.id = mc.company_id
  AND ct.id = mc.company_type_id;


/*+ NestLoop(t aka_t mc ct cn mk k mi it1)
 NestLoop(t aka_t mc ct cn mk k mi)
 NestLoop(t aka_t mc ct cn mk k)
 NestLoop(t aka_t mc ct cn mk)
 HashJoin(t aka_t mc ct cn)
 NestLoop(t aka_t mc ct)
 NestLoop(t aka_t mc)
 NestLoop(t aka_t)
 SeqScan(t)
 IndexScan(aka_t)
 IndexScan(mc)
 IndexScan(ct)
 SeqScan(cn)
 IndexScan(mk)
 IndexScan(k)
 IndexScan(mi)
 SeqScan(it1)
 Leading(((((((((t aka_t) mc) ct) cn) mk) k) mi) it1)) */
SELECT MIN(mi.info) AS release_date,
       MIN(t.title) AS youtube_movie
FROM aka_title AS aka_t,
     company_name AS cn,
     company_type AS ct,
     info_type AS it1,
     keyword AS k,
     movie_companies AS mc,
     movie_info AS mi,
     movie_keyword AS mk,
     title AS t
WHERE cn.country_code = '[us]'
  AND cn.name = 'YouTube'
  AND it1.info = 'release dates'
  AND mc.note LIKE '%(200%)%'
  AND mc.note LIKE '%(worldwide)%'
  AND mi.note LIKE '%internet%'
  AND mi.info LIKE 'USA:% 200%'
  AND t.production_year BETWEEN 2005 AND 2010
  AND t.id = aka_t.movie_id
  AND t.id = mi.movie_id
  AND t.id = mk.movie_id
  AND t.id = mc.movie_id
  AND mk.movie_id = mi.movie_id
  AND mk.movie_id = mc.movie_id
  AND mk.movie_id = aka_t.movie_id
  AND mi.movie_id = mc.movie_id
  AND mi.movie_id = aka_t.movie_id
  AND mc.movie_id = aka_t.movie_id
  AND k.id = mk.keyword_id
  AND it1.id = mi.info_type_id
  AND cn.id = mc.company_id
  AND ct.id = mc.company_type_id;


/*+ NestLoop(t mk k mc cn ci an n)
 NestLoop(t mk k mc cn ci an)
 NestLoop(t mk k mc cn ci)
 NestLoop(t mk k mc cn)
 NestLoop(t mk k mc)
 NestLoop(t mk k)
 NestLoop(t mk)
 SeqScan(t)
 IndexScan(mk)
 IndexScan(k)
 IndexScan(mc)
 IndexScan(cn)
 IndexScan(ci)
 IndexScan(an)
 IndexScan(n)
 Leading((((((((t mk) k) mc) cn) ci) an) n)) */
SELECT MIN(an.name) AS cool_actor_pseudonym,
       MIN(t.title) AS series_named_after_char
FROM aka_name AS an,
     cast_info AS ci,
     company_name AS cn,
     keyword AS k,
     movie_companies AS mc,
     movie_keyword AS mk,
     name AS n,
     title AS t
WHERE cn.country_code ='[us]'
  AND k.keyword ='character-name-in-title'
  AND t.episode_nr >= 50
  AND t.episode_nr < 100
  AND an.person_id = n.id
  AND n.id = ci.person_id
  AND ci.movie_id = t.id
  AND t.id = mk.movie_id
  AND mk.keyword_id = k.id
  AND t.id = mc.movie_id
  AND mc.company_id = cn.id
  AND an.person_id = ci.person_id
  AND ci.movie_id = mc.movie_id
  AND ci.movie_id = mk.movie_id
  AND mc.movie_id = mk.movie_id;


/*+ HashJoin(t k mk mc cn ci n an)
 HashJoin(t k mk mc cn ci n)
 NestLoop(t k mk mc cn ci)
 HashJoin(t k mk mc cn)
 NestLoop(t k mk mc)
 HashJoin(t k mk)
 NestLoop(k mk)
 SeqScan(t)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(mc)
 SeqScan(cn)
 IndexScan(ci)
 IndexScan(n)
 IndexScan(an)
 Leading(((((((t (k mk)) mc) cn) ci) n) an)) */
SELECT MIN(an.name) AS cool_actor_pseudonym,
       MIN(t.title) AS series_named_after_char
FROM aka_name AS an,
     cast_info AS ci,
     company_name AS cn,
     keyword AS k,
     movie_companies AS mc,
     movie_keyword AS mk,
     name AS n,
     title AS t
WHERE cn.country_code ='[us]'
  AND k.keyword ='character-name-in-title'
  AND an.person_id = n.id
  AND n.id = ci.person_id
  AND ci.movie_id = t.id
  AND t.id = mk.movie_id
  AND mk.keyword_id = k.id
  AND t.id = mc.movie_id
  AND mc.company_id = cn.id
  AND an.person_id = ci.person_id
  AND ci.movie_id = mc.movie_id
  AND ci.movie_id = mk.movie_id
  AND mc.movie_id = mk.movie_id;


/*+ NestLoop(t k mk mc cn ci n an)
 NestLoop(t k mk mc cn ci n)
 NestLoop(t k mk mc cn ci)
 NestLoop(t k mk mc cn)
 NestLoop(t k mk mc)
 HashJoin(t k mk)
 NestLoop(k mk)
 SeqScan(t)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(mc)
 IndexScan(cn)
 IndexScan(ci)
 IndexScan(n)
 IndexScan(an)
 Leading(((((((t (k mk)) mc) cn) ci) n) an)) */
SELECT MIN(an.name) AS cool_actor_pseudonym,
       MIN(t.title) AS series_named_after_char
FROM aka_name AS an,
     cast_info AS ci,
     company_name AS cn,
     keyword AS k,
     movie_companies AS mc,
     movie_keyword AS mk,
     name AS n,
     title AS t
WHERE cn.country_code ='[us]'
  AND k.keyword ='character-name-in-title'
  AND t.episode_nr < 100
  AND an.person_id = n.id
  AND n.id = ci.person_id
  AND ci.movie_id = t.id
  AND t.id = mk.movie_id
  AND mk.keyword_id = k.id
  AND t.id = mc.movie_id
  AND mc.company_id = cn.id
  AND an.person_id = ci.person_id
  AND ci.movie_id = mc.movie_id
  AND ci.movie_id = mk.movie_id
  AND mc.movie_id = mk.movie_id;


/*+ NestLoop(t k mk mc cn ci n an)
 NestLoop(t k mk mc cn ci n)
 NestLoop(t k mk mc cn ci)
 NestLoop(t k mk mc cn)
 NestLoop(t k mk mc)
 HashJoin(t k mk)
 NestLoop(k mk)
 SeqScan(t)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(mc)
 IndexScan(cn)
 IndexScan(ci)
 IndexScan(n)
 IndexScan(an)
 Leading(((((((t (k mk)) mc) cn) ci) n) an)) */
SELECT MIN(an.name) AS cool_actor_pseudonym,
       MIN(t.title) AS series_named_after_char
FROM aka_name AS an,
     cast_info AS ci,
     company_name AS cn,
     keyword AS k,
     movie_companies AS mc,
     movie_keyword AS mk,
     name AS n,
     title AS t
WHERE cn.country_code ='[us]'
  AND k.keyword ='character-name-in-title'
  AND t.episode_nr >= 5
  AND t.episode_nr < 100
  AND an.person_id = n.id
  AND n.id = ci.person_id
  AND ci.movie_id = t.id
  AND t.id = mk.movie_id
  AND mk.keyword_id = k.id
  AND t.id = mc.movie_id
  AND mc.company_id = cn.id
  AND an.person_id = ci.person_id
  AND ci.movie_id = mc.movie_id
  AND ci.movie_id = mk.movie_id
  AND mc.movie_id = mk.movie_id;


/*+ HashJoin(t k mk mc cn ci n)
 NestLoop(t k mk mc cn ci)
 HashJoin(t k mk mc cn)
 NestLoop(t k mk mc)
 HashJoin(t k mk)
 NestLoop(k mk)
 SeqScan(t)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(mc)
 SeqScan(cn)
 IndexScan(ci)
 SeqScan(n)
 Leading((((((t (k mk)) mc) cn) ci) n)) */
SELECT MIN(n.name) AS member_in_charnamed_american_movie,
       MIN(n.name) AS a1
FROM cast_info AS ci,
     company_name AS cn,
     keyword AS k,
     movie_companies AS mc,
     movie_keyword AS mk,
     name AS n,
     title AS t
WHERE cn.country_code ='[us]'
  AND k.keyword ='character-name-in-title'
  AND n.name LIKE 'B%'
  AND n.id = ci.person_id
  AND ci.movie_id = t.id
  AND t.id = mk.movie_id
  AND mk.keyword_id = k.id
  AND t.id = mc.movie_id
  AND mc.company_id = cn.id
  AND ci.movie_id = mc.movie_id
  AND ci.movie_id = mk.movie_id
  AND mc.movie_id = mk.movie_id;


/*+ HashJoin(n ci k mk t mc cn)
 NestLoop(n ci k mk t mc)
 NestLoop(n ci k mk t)
 HashJoin(n ci k mk)
 NestLoop(k mk)
 NestLoop(n ci)
 IndexScan(n)
 IndexScan(ci)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(t)
 IndexScan(mc)
 SeqScan(cn)
 Leading((((((n ci) (k mk)) t) mc) cn)) */
SELECT MIN(n.name) AS member_in_charnamed_movie,
       MIN(n.name) AS a1
FROM cast_info AS ci,
     company_name AS cn,
     keyword AS k,
     movie_companies AS mc,
     movie_keyword AS mk,
     name AS n,
     title AS t
WHERE k.keyword ='character-name-in-title'
  AND n.name LIKE 'Z%'
  AND n.id = ci.person_id
  AND ci.movie_id = t.id
  AND t.id = mk.movie_id
  AND mk.keyword_id = k.id
  AND t.id = mc.movie_id
  AND mc.company_id = cn.id
  AND ci.movie_id = mc.movie_id
  AND ci.movie_id = mk.movie_id
  AND mc.movie_id = mk.movie_id;


/*+ NestLoop(n ci mk k mc cn t)
 HashJoin(n ci mk k mc cn)
 NestLoop(n ci mk k mc)
 HashJoin(n ci mk k)
 NestLoop(n ci mk)
 NestLoop(n ci)
 IndexScan(n)
 IndexScan(ci)
 IndexScan(mk)
 SeqScan(k)
 IndexScan(mc)
 SeqScan(cn)
 IndexScan(t)
 Leading(((((((n ci) mk) k) mc) cn) t)) */
SELECT MIN(n.name) AS member_in_charnamed_movie,
       MIN(n.name) AS a1
FROM cast_info AS ci,
     company_name AS cn,
     keyword AS k,
     movie_companies AS mc,
     movie_keyword AS mk,
     name AS n,
     title AS t
WHERE k.keyword ='character-name-in-title'
  AND n.name LIKE 'X%'
  AND n.id = ci.person_id
  AND ci.movie_id = t.id
  AND t.id = mk.movie_id
  AND mk.keyword_id = k.id
  AND t.id = mc.movie_id
  AND mc.company_id = cn.id
  AND ci.movie_id = mc.movie_id
  AND ci.movie_id = mk.movie_id
  AND mc.movie_id = mk.movie_id;


/*+ NestLoop(n ci k mk mc cn t)
 HashJoin(n ci k mk mc cn)
 NestLoop(n ci k mk mc)
 MergeJoin(n ci k mk)
 NestLoop(k mk)
 NestLoop(n ci)
 IndexScan(n)
 IndexScan(ci)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(mc)
 SeqScan(cn)
 IndexScan(t)
 Leading((((((n ci) (k mk)) mc) cn) t)) */
SELECT MIN(n.name) AS member_in_charnamed_movie
FROM cast_info AS ci,
     company_name AS cn,
     keyword AS k,
     movie_companies AS mc,
     movie_keyword AS mk,
     name AS n,
     title AS t
WHERE k.keyword ='character-name-in-title'
  AND n.name LIKE '%Bert%'
  AND n.id = ci.person_id
  AND ci.movie_id = t.id
  AND t.id = mk.movie_id
  AND mk.keyword_id = k.id
  AND t.id = mc.movie_id
  AND mc.company_id = cn.id
  AND ci.movie_id = mc.movie_id
  AND ci.movie_id = mk.movie_id
  AND mc.movie_id = mk.movie_id;


/*+ HashJoin(t k mk mc cn ci n)
 NestLoop(t k mk mc cn ci)
 HashJoin(t k mk mc cn)
 NestLoop(t k mk mc)
 HashJoin(t k mk)
 NestLoop(k mk)
 SeqScan(t)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(mc)
 SeqScan(cn)
 IndexScan(ci)
 SeqScan(n)
 Leading((((((t (k mk)) mc) cn) ci) n)) */
SELECT MIN(n.name) AS member_in_charnamed_movie
FROM cast_info AS ci,
     company_name AS cn,
     keyword AS k,
     movie_companies AS mc,
     movie_keyword AS mk,
     name AS n,
     title AS t
WHERE cn.country_code ='[us]'
  AND k.keyword ='character-name-in-title'
  AND n.id = ci.person_id
  AND ci.movie_id = t.id
  AND t.id = mk.movie_id
  AND mk.keyword_id = k.id
  AND t.id = mc.movie_id
  AND mc.company_id = cn.id
  AND ci.movie_id = mc.movie_id
  AND ci.movie_id = mk.movie_id
  AND mc.movie_id = mk.movie_id;


/*+ HashJoin(t k mk ci n mc cn)
 NestLoop(t k mk ci n mc)
 HashJoin(t k mk ci n)
 NestLoop(t k mk ci)
 HashJoin(t k mk)
 NestLoop(k mk)
 SeqScan(t)
 IndexScan(k)
 IndexScan(mk)
 IndexScan(ci)
 IndexScan(n)
 IndexScan(mc)
 SeqScan(cn)
 Leading((((((t (k mk)) ci) n) mc) cn)) */
SELECT MIN(n.name) AS member_in_charnamed_movie
FROM cast_info AS ci,
     company_name AS cn,
     keyword AS k,
     movie_companies AS mc,
     movie_keyword AS mk,
     name AS n,
     title AS t
WHERE k.keyword ='character-name-in-title'
  AND n.name LIKE '%B%'
  AND n.id = ci.person_id
  AND ci.movie_id = t.id
  AND t.id = mk.movie_id
  AND mk.keyword_id = k.id
  AND t.id = mc.movie_id
  AND mc.company_id = cn.id
  AND ci.movie_id = mc.movie_id
  AND ci.movie_id = mk.movie_id
  AND mc.movie_id = mk.movie_id;


/*+ HashJoin(n ci t mi it1 mi_idx it2)
 NestLoop(n ci t mi it1 mi_idx)
 MergeJoin(n ci t mi it1)
 NestLoop(n ci t mi)
 NestLoop(n ci t)
 NestLoop(n ci)
 IndexScan(n)
 IndexScan(ci)
 IndexScan(t)
 IndexScan(mi)
 SeqScan(it1)
 IndexScan(mi_idx)
 SeqScan(it2)
 Leading(((((((n ci) t) mi) it1) mi_idx) it2)) */
SELECT MIN(mi.info) AS movie_budget,
       MIN(mi_idx.info) AS movie_votes,
       MIN(t.title) AS movie_title
FROM cast_info AS ci,
     info_type AS it1,
     info_type AS it2,
     movie_info AS mi,
     movie_info_idx AS mi_idx,
     name AS n,
     title AS t
WHERE ci.note IN ('(producer)',
                  '(executive producer)')
  AND it1.info = 'budget'
  AND it2.info = 'votes'
  AND n.gender = 'm'
  AND n.name LIKE '%Tim%'
  AND t.id = mi.movie_id
  AND t.id = mi_idx.movie_id
  AND t.id = ci.movie_id
  AND ci.movie_id = mi.movie_id
  AND ci.movie_id = mi_idx.movie_id
  AND mi.movie_id = mi_idx.movie_id
  AND n.id = ci.person_id
  AND it1.id = mi.info_type_id
  AND it2.id = mi_idx.info_type_id;


/*+ NestLoop(mi_idx it2 t mi ci n it1)
 NestLoop(mi_idx it2 t mi ci n)
 NestLoop(mi_idx it2 t mi ci)
 NestLoop(mi_idx it2 t mi)
 NestLoop(mi_idx it2 t)
 NestLoop(mi_idx it2)
 SeqScan(mi_idx)
 IndexScan(it2)
 IndexScan(t)
 IndexScan(mi)
 IndexScan(ci)
 IndexScan(n)
 SeqScan(it1)
 Leading(((((((mi_idx it2) t) mi) ci) n) it1)) */
SELECT MIN(mi.info) AS movie_budget,
       MIN(mi_idx.info) AS movie_votes,
       MIN(t.title) AS movie_title
FROM cast_info AS ci,
     info_type AS it1,
     info_type AS it2,
     movie_info AS mi,
     movie_info_idx AS mi_idx,
     name AS n,
     title AS t
WHERE ci.note IN ('(writer)',
                  '(head writer)',
                  '(written by)',
                  '(story)',
                  '(story editor)')
  AND it1.info = 'genres'
  AND it2.info = 'rating'
  AND mi.info IN ('Horror',
                  'Thriller')
  AND mi.note IS NULL
  AND mi_idx.info > '8.0'
  AND n.gender IS NOT NULL
  AND n.gender = 'f'
  AND t.production_year BETWEEN 2008 AND 2014
  AND t.id = mi.movie_id
  AND t.id = mi_idx.movie_id
  AND t.id = ci.movie_id
  AND ci.movie_id = mi.movie_id
  AND ci.movie_id = mi_idx.movie_id
  AND mi.movie_id = mi_idx.movie_id
  AND n.id = ci.person_id
  AND it1.id = mi.info_type_id
  AND it2.id = mi_idx.info_type_id;


/*+ NestLoop(ci mi it1 n mi_idx it2 t)
 MergeJoin(ci mi it1 n mi_idx it2)
 NestLoop(ci mi it1 n mi_idx)
 NestLoop(ci mi it1 n)
 HashJoin(ci mi it1)
 NestLoop(mi it1)
 SeqScan(ci)
 IndexScan(mi)
 IndexScan(it1)
 IndexScan(n)
 IndexScan(mi_idx)
 SeqScan(it2)
 IndexScan(t)
 Leading((((((ci (mi it1)) n) mi_idx) it2) t)) */
SELECT MIN(mi.info) AS movie_budget,
       MIN(mi_idx.info) AS movie_votes,
       MIN(t.title) AS movie_title
FROM cast_info AS ci,
     info_type AS it1,
     info_type AS it2,
     movie_info AS mi,
     movie_info_idx AS mi_idx,
     name AS n,
     title AS t
WHERE ci.note IN ('(writer)',
                  '(head writer)',
                  '(written by)',
                  '(story)',
                  '(story editor)')
  AND it1.info = 'genres'
  AND it2.info = 'votes'
  AND mi.info IN ('Horror',
                  'Action',
                  'Sci-Fi',
                  'Thriller',
                  'Crime',
                  'War')
  AND n.gender = 'm'
  AND t.id = mi.movie_id
  AND t.id = mi_idx.movie_id
  AND t.id = ci.movie_id
  AND ci.movie_id = mi.movie_id
  AND ci.movie_id = mi_idx.movie_id
  AND mi.movie_id = mi_idx.movie_id
  AND n.id = ci.person_id
  AND it1.id = mi.info_type_id
  AND it2.id = mi_idx.info_type_id;


/*+ NestLoop(n an ci t chn mc mi it cn rt)
 NestLoop(n an ci t chn mc mi it cn)
 MergeJoin(n an ci t chn mc mi it)
 NestLoop(n an ci t chn mc mi)
 NestLoop(n an ci t chn mc)
 NestLoop(n an ci t chn)
 NestLoop(n an ci t)
 NestLoop(n an ci)
 NestLoop(n an)
 IndexScan(n)
 IndexScan(an)
 IndexScan(ci)
 IndexScan(t)
 IndexScan(chn)
 IndexScan(mc)
 IndexScan(mi)
 SeqScan(it)
 IndexScan(cn)
 IndexScan(rt)
 Leading((((((((((n an) ci) t) chn) mc) mi) it) cn) rt)) */
SELECT MIN(n.name) AS voicing_actress,
       MIN(t.title) AS voiced_movie
FROM aka_name AS an,
     char_name AS chn,
     cast_info AS ci,
     company_name AS cn,
     info_type AS it,
     movie_companies AS mc,
     movie_info AS mi,
     name AS n,
     role_type AS rt,
     title AS t
WHERE ci.note IN ('(voice)',
                  '(voice: Japanese version)',
                  '(voice) (uncredited)',
                  '(voice: English version)')
  AND cn.country_code ='[us]'
  AND it.info = 'release dates'
  AND mc.note IS NOT NULL
  AND (mc.note LIKE '%(USA)%'
       OR mc.note LIKE '%(worldwide)%')
  AND mi.info IS NOT NULL
  AND (mi.info LIKE 'Japan:%200%'
       OR mi.info LIKE 'USA:%200%')
  AND n.gender ='f'
  AND n.name LIKE '%Ang%'
  AND rt.role ='actress'
  AND t.production_year BETWEEN 2005 AND 2009
  AND t.id = mi.movie_id
  AND t.id = mc.movie_id
  AND t.id = ci.movie_id
  AND mc.movie_id = ci.movie_id
  AND mc.movie_id = mi.movie_id
  AND mi.movie_id = ci.movie_id
  AND cn.id = mc.company_id
  AND it.id = mi.info_type_id
  AND n.id = ci.person_id
  AND rt.id = ci.role_id
  AND n.id = an.person_id
  AND ci.person_id = an.person_id
  AND chn.id = ci.person_role_id;


/*+ NestLoop(t ci chn rt mi it mc cn an n)
 NestLoop(t ci chn rt mi it mc cn an)
 NestLoop(t ci chn rt mi it mc cn)
 NestLoop(t ci chn rt mi it mc)
 NestLoop(t ci chn rt mi it)
 NestLoop(t ci chn rt mi)
 NestLoop(t ci chn rt)
 NestLoop(t ci chn)
 NestLoop(t ci)
 SeqScan(t)
 IndexScan(ci)
 IndexScan(chn)
 SeqScan(rt)
 IndexScan(mi)
 SeqScan(it)
 IndexScan(mc)
 IndexScan(cn)
 IndexScan(an)
 IndexScan(n)
 Leading((((((((((t ci) chn) rt) mi) it) mc) cn) an) n)) */
SELECT MIN(n.name) AS voicing_actress,
       MIN(t.title) AS kung_fu_panda
FROM aka_name AS an,
     char_name AS chn,
     cast_info AS ci,
     company_name AS cn,
     info_type AS it,
     movie_companies AS mc,
     movie_info AS mi,
     name AS n,
     role_type AS rt,
     title AS t
WHERE ci.note = '(voice)'
  AND cn.country_code ='[us]'
  AND it.info = 'release dates'
  AND mc.note LIKE '%(200%)%'
  AND (mc.note LIKE '%(USA)%'
       OR mc.note LIKE '%(worldwide)%')
  AND mi.info IS NOT NULL
  AND (mi.info LIKE 'Japan:%2007%'
       OR mi.info LIKE 'USA:%2008%')
  AND n.gender ='f'
  AND n.name LIKE '%Angel%'
  AND rt.role ='actress'
  AND t.production_year BETWEEN 2007 AND 2008
  AND t.title LIKE '%Kung%Fu%Panda%'
  AND t.id = mi.movie_id
  AND t.id = mc.movie_id
  AND t.id = ci.movie_id
  AND mc.movie_id = ci.movie_id
  AND mc.movie_id = mi.movie_id
  AND mi.movie_id = ci.movie_id
  AND cn.id = mc.company_id
  AND it.id = mi.info_type_id
  AND n.id = ci.person_id
  AND rt.id = ci.role_id
  AND n.id = an.person_id
  AND ci.person_id = an.person_id
  AND chn.id = ci.person_role_id;


/*+ NestLoop(n an ci chn t mi it mc cn rt)
 NestLoop(n an ci chn t mi it mc cn)
 NestLoop(n an ci chn t mi it mc)
 HashJoin(n an ci chn t mi it)
 NestLoop(n an ci chn t mi)
 NestLoop(n an ci chn t)
 NestLoop(n an ci chn)
 NestLoop(n an ci)
 NestLoop(n an)
 IndexScan(n)
 IndexScan(an)
 IndexScan(ci)
 IndexScan(chn)
 IndexScan(t)
 IndexScan(mi)
 SeqScan(it)
 IndexScan(mc)
 IndexScan(cn)
 SeqScan(rt)
 Leading((((((((((n an) ci) chn) t) mi) it) mc) cn) rt)) */
SELECT MIN(n.name) AS voicing_actress,
       MIN(t.title) AS jap_engl_voiced_movie
FROM aka_name AS an,
     char_name AS chn,
     cast_info AS ci,
     company_name AS cn,
     info_type AS it,
     movie_companies AS mc,
     movie_info AS mi,
     name AS n,
     role_type AS rt,
     title AS t
WHERE ci.note IN ('(voice)',
                  '(voice: Japanese version)',
                  '(voice) (uncredited)',
                  '(voice: English version)')
  AND cn.country_code ='[us]'
  AND it.info = 'release dates'
  AND mi.info IS NOT NULL
  AND (mi.info LIKE 'Japan:%200%'
       OR mi.info LIKE 'USA:%200%')
  AND n.gender ='f'
  AND n.name LIKE '%An%'
  AND rt.role ='actress'
  AND t.production_year > 2000
  AND t.id = mi.movie_id
  AND t.id = mc.movie_id
  AND t.id = ci.movie_id
  AND mc.movie_id = ci.movie_id
  AND mc.movie_id = mi.movie_id
  AND mi.movie_id = ci.movie_id
  AND cn.id = mc.company_id
  AND it.id = mi.info_type_id
  AND n.id = ci.person_id
  AND rt.id = ci.role_id
  AND n.id = an.person_id
  AND ci.person_id = an.person_id
  AND chn.id = ci.person_role_id;


/*+ HashJoin(t rt ci n chn mi it an mc cn)
 NestLoop(t rt ci n chn mi it an mc)
 NestLoop(t rt ci n chn mi it an)
 NestLoop(t rt ci n chn mi it)
 NestLoop(t rt ci n chn mi)
 NestLoop(t rt ci n chn)
 NestLoop(t rt ci n)
 HashJoin(t rt ci)
 NestLoop(rt ci)
 SeqScan(t)
 IndexScan(rt)
 IndexScan(ci)
 IndexScan(n)
 IndexScan(chn)
 IndexScan(mi)
 IndexScan(it)
 IndexScan(an)
 IndexScan(mc)
 SeqScan(cn)
 Leading(((((((((t (rt ci)) n) chn) mi) it) an) mc) cn)) */
SELECT MIN(n.name) AS voicing_actress,
       MIN(t.title) AS jap_engl_voiced_movie
FROM aka_name AS an,
     char_name AS chn,
     cast_info AS ci,
     company_name AS cn,
     info_type AS it,
     movie_companies AS mc,
     movie_info AS mi,
     name AS n,
     role_type AS rt,
     title AS t
WHERE ci.note IN ('(voice)',
                  '(voice: Japanese version)',
                  '(voice) (uncredited)',
                  '(voice: English version)')
  AND cn.country_code ='[us]'
  AND it.info = 'release dates'
  AND n.gender ='f'
  AND rt.role ='actress'
  AND t.production_year > 2000
  AND t.id = mi.movie_id
  AND t.id = mc.movie_id
  AND t.id = ci.movie_id
  AND mc.movie_id = ci.movie_id
  AND mc.movie_id = mi.movie_id
  AND mi.movie_id = ci.movie_id
  AND cn.id = mc.company_id
  AND it.id = mi.info_type_id
  AND n.id = ci.person_id
  AND rt.id = ci.role_id
  AND n.id = an.person_id
  AND ci.person_id = an.person_id
  AND chn.id = ci.person_role_id;


/*+ HashJoin(it mi_idx mc t ct)
 NestLoop(it mi_idx mc t)
 NestLoop(it mi_idx mc)
 NestLoop(it mi_idx)
 IndexScan(it)
 IndexScan(mi_idx)
 IndexScan(mc)
 IndexScan(t)
 SeqScan(ct)
 Leading(((((it mi_idx) mc) t) ct)) */
SELECT MIN(mc.note) AS production_note,
       MIN(t.title) AS movie_title,
       MIN(t.production_year) AS movie_year
FROM company_type AS ct,
     info_type AS it,
     movie_companies AS mc,
     movie_info_idx AS mi_idx,
     title AS t
WHERE ct.kind = 'production companies'
  AND it.info = 'top 250 rank'
  AND mc.note NOT LIKE '%(as Metro-Goldwyn-Mayer Pictures)%'
  AND (mc.note LIKE '%(co-production)%'
       OR mc.note LIKE '%(presents)%')
  AND ct.id = mc.company_type_id
  AND t.id = mc.movie_id
  AND t.id = mi_idx.movie_id
  AND mc.movie_id = mi_idx.movie_id
  AND it.id = mi_idx.info_type_id;


/*+ MergeJoin(it mi_idx t mc ct)
 NestLoop(it mi_idx t mc)
 NestLoop(it mi_idx t)
 NestLoop(it mi_idx)
 IndexScan(it)
 IndexScan(mi_idx)
 IndexScan(t)
 IndexScan(mc)
 IndexScan(ct)
 Leading(((((it mi_idx) t) mc) ct)) */
SELECT MIN(mc.note) AS production_note,
       MIN(t.title) AS movie_title,
       MIN(t.production_year) AS movie_year
FROM company_type AS ct,
     info_type AS it,
     movie_companies AS mc,
     movie_info_idx AS mi_idx,
     title AS t
WHERE ct.kind = 'production companies'
  AND it.info = 'bottom 10 rank'
  AND mc.note NOT LIKE '%(as Metro-Goldwyn-Mayer Pictures)%'
  AND t.production_year BETWEEN 2005 AND 2010
  AND ct.id = mc.company_type_id
  AND t.id = mc.movie_id
  AND t.id = mi_idx.movie_id
  AND mc.movie_id = mi_idx.movie_id
  AND it.id = mi_idx.info_type_id;


/*+ NestLoop(it mi_idx mc ct t)
 NestLoop(it mi_idx mc ct)
 NestLoop(it mi_idx mc)
 NestLoop(it mi_idx)
 IndexScan(it)
 IndexScan(mi_idx)
 IndexScan(mc)
 IndexScan(ct)
 IndexScan(t)
 Leading(((((it mi_idx) mc) ct) t)) */
SELECT MIN(mc.note) AS production_note,
       MIN(t.title) AS movie_title,
       MIN(t.production_year) AS movie_year
FROM company_type AS ct,
     info_type AS it,
     movie_companies AS mc,
     movie_info_idx AS mi_idx,
     title AS t
WHERE ct.kind = 'production companies'
  AND it.info = 'bottom 10 rank'
  AND mc.note NOT LIKE '%(as Metro-Goldwyn-Mayer Pictures)%'
  AND t.production_year >2000
  AND ct.id = mc.company_type_id
  AND t.id = mc.movie_id
  AND t.id = mi_idx.movie_id
  AND mc.movie_id = mi_idx.movie_id
  AND it.id = mi_idx.info_type_id;


/*+ NestLoop(t k mk kt cc cct2 cct1 ci chn n)
 NestLoop(t k mk kt cc cct2 cct1 ci chn)
 NestLoop(t k mk kt cc cct2 cct1 ci)
 NestLoop(t k mk kt cc cct2 cct1)
 NestLoop(t k mk kt cc cct2)
 NestLoop(t k mk kt cc)
 HashJoin(t k mk kt)
 HashJoin(t k mk)
 NestLoop(k mk)
 SeqScan(t)
 SeqScan(k)
 IndexScan(mk)
 SeqScan(kt)
 IndexScan(cc)
 SeqScan(cct2)
 IndexScan(cct1)
 IndexScan(ci)
 IndexScan(chn)
 IndexScan(n)
 Leading(((((((((t (k mk)) kt) cc) cct2) cct1) ci) chn) n)) */
SELECT MIN(t.title) AS complete_downey_ironman_movie
FROM complete_cast AS cc,
     comp_cast_type AS cct1,
     comp_cast_type AS cct2,
     char_name AS chn,
     cast_info AS ci,
     keyword AS k,
     kind_type AS kt,
     movie_keyword AS mk,
     name AS n,
     title AS t
WHERE cct1.kind = 'cast'
  AND cct2.kind LIKE '%complete%'
  AND chn.name NOT LIKE '%Sherlock%'
  AND (chn.name LIKE '%Tony%Stark%'
       OR chn.name LIKE '%Iron%Man%')
  AND k.keyword IN ('superhero',
                    'sequel',
                    'second-part',
                    'marvel-comics',
                    'based-on-comic',
                    'tv-special',
                    'fight',
                    'violence')
  AND kt.kind = 'movie'
  AND t.production_year > 1950
  AND kt.id = t.kind_id
  AND t.id = mk.movie_id
  AND t.id = ci.movie_id
  AND t.id = cc.movie_id
  AND mk.movie_id = ci.movie_id
  AND mk.movie_id = cc.movie_id
  AND ci.movie_id = cc.movie_id
  AND chn.id = ci.person_role_id
  AND n.id = ci.person_id
  AND k.id = mk.keyword_id
  AND cct1.id = cc.subject_id
  AND cct2.id = cc.status_id;


/*+ NestLoop(t k mk cc cct1 cct2 kt ci chn n)
 NestLoop(t k mk cc cct1 cct2 kt ci chn)
 NestLoop(t k mk cc cct1 cct2 kt ci)
 NestLoop(t k mk cc cct1 cct2 kt)
 NestLoop(t k mk cc cct1 cct2)
 NestLoop(t k mk cc cct1)
 NestLoop(t k mk cc)
 HashJoin(t k mk)
 NestLoop(k mk)
 SeqScan(t)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(cc)
 IndexScan(cct1)
 IndexScan(cct2)
 SeqScan(kt)
 IndexScan(ci)
 IndexScan(chn)
 IndexScan(n)
 Leading(((((((((t (k mk)) cc) cct1) cct2) kt) ci) chn) n)) */
SELECT MIN(t.title) AS complete_downey_ironman_movie
FROM complete_cast AS cc,
     comp_cast_type AS cct1,
     comp_cast_type AS cct2,
     char_name AS chn,
     cast_info AS ci,
     keyword AS k,
     kind_type AS kt,
     movie_keyword AS mk,
     name AS n,
     title AS t
WHERE cct1.kind = 'cast'
  AND cct2.kind LIKE '%complete%'
  AND chn.name NOT LIKE '%Sherlock%'
  AND (chn.name LIKE '%Tony%Stark%'
       OR chn.name LIKE '%Iron%Man%')
  AND k.keyword IN ('superhero',
                    'sequel',
                    'second-part',
                    'marvel-comics',
                    'based-on-comic',
                    'tv-special',
                    'fight',
                    'violence')
  AND kt.kind = 'movie'
  AND n.name LIKE '%Downey%Robert%'
  AND t.production_year > 2000
  AND kt.id = t.kind_id
  AND t.id = mk.movie_id
  AND t.id = ci.movie_id
  AND t.id = cc.movie_id
  AND mk.movie_id = ci.movie_id
  AND mk.movie_id = cc.movie_id
  AND ci.movie_id = cc.movie_id
  AND chn.id = ci.person_role_id
  AND n.id = ci.person_id
  AND k.id = mk.keyword_id
  AND cct1.id = cc.subject_id
  AND cct2.id = cc.status_id;


/*+ NestLoop(t k mk kt cc cct1 cct2 ci chn n)
 NestLoop(t k mk kt cc cct1 cct2 ci chn)
 NestLoop(t k mk kt cc cct1 cct2 ci)
 NestLoop(t k mk kt cc cct1 cct2)
 NestLoop(t k mk kt cc cct1)
 NestLoop(t k mk kt cc)
 HashJoin(t k mk kt)
 HashJoin(t k mk)
 NestLoop(k mk)
 SeqScan(t)
 SeqScan(k)
 IndexScan(mk)
 SeqScan(kt)
 IndexScan(cc)
 IndexScan(cct1)
 SeqScan(cct2)
 IndexScan(ci)
 IndexScan(chn)
 IndexScan(n)
 Leading(((((((((t (k mk)) kt) cc) cct1) cct2) ci) chn) n)) */
SELECT MIN(n.name) AS cast_member,
       MIN(t.title) AS complete_dynamic_hero_movie
FROM complete_cast AS cc,
     comp_cast_type AS cct1,
     comp_cast_type AS cct2,
     char_name AS chn,
     cast_info AS ci,
     keyword AS k,
     kind_type AS kt,
     movie_keyword AS mk,
     name AS n,
     title AS t
WHERE cct1.kind = 'cast'
  AND cct2.kind LIKE '%complete%'
  AND chn.name IS NOT NULL
  AND (chn.name LIKE '%man%'
       OR chn.name LIKE '%Man%')
  AND k.keyword IN ('superhero',
                    'marvel-comics',
                    'based-on-comic',
                    'tv-special',
                    'fight',
                    'violence',
                    'magnet',
                    'web',
                    'claw',
                    'laser')
  AND kt.kind = 'movie'
  AND t.production_year > 2000
  AND kt.id = t.kind_id
  AND t.id = mk.movie_id
  AND t.id = ci.movie_id
  AND t.id = cc.movie_id
  AND mk.movie_id = ci.movie_id
  AND mk.movie_id = cc.movie_id
  AND ci.movie_id = cc.movie_id
  AND chn.id = ci.person_role_id
  AND n.id = ci.person_id
  AND k.id = mk.keyword_id
  AND cct1.id = cc.subject_id
  AND cct2.id = cc.status_id;


/*+ NestLoop(ml lt t mc cn ct mk k mi)
 NestLoop(ml lt t mc cn ct mk k)
 NestLoop(ml lt t mc cn ct mk)
 HashJoin(ml lt t mc cn ct)
 NestLoop(ml lt t mc cn)
 NestLoop(ml lt t mc)
 NestLoop(ml lt t)
 NestLoop(ml lt)
 IndexScan(ml)
 SeqScan(lt)
 IndexScan(t)
 IndexScan(mc)
 IndexScan(cn)
 SeqScan(ct)
 IndexScan(mk)
 IndexScan(k)
 IndexScan(mi)
 Leading(((((((((ml lt) t) mc) cn) ct) mk) k) mi)) */
SELECT MIN(cn.name) AS company_name,
       MIN(lt.link) AS link_type,
       MIN(t.title) AS western_follow_up
FROM company_name AS cn,
     company_type AS ct,
     keyword AS k,
     link_type AS lt,
     movie_companies AS mc,
     movie_info AS mi,
     movie_keyword AS mk,
     movie_link AS ml,
     title AS t
WHERE cn.country_code !='[pl]'
  AND (cn.name LIKE '%Film%'
       OR cn.name LIKE '%Warner%')
  AND ct.kind ='production companies'
  AND k.keyword ='sequel'
  AND lt.link LIKE '%follow%'
  AND mc.note IS NULL
  AND mi.info IN ('Sweden',
                  'Norway',
                  'Germany',
                  'Denmark',
                  'Swedish',
                  'Denish',
                  'Norwegian',
                  'German')
  AND t.production_year BETWEEN 1950 AND 2000
  AND lt.id = ml.link_type_id
  AND ml.movie_id = t.id
  AND t.id = mk.movie_id
  AND mk.keyword_id = k.id
  AND t.id = mc.movie_id
  AND mc.company_type_id = ct.id
  AND mc.company_id = cn.id
  AND mi.movie_id = t.id
  AND ml.movie_id = mk.movie_id
  AND ml.movie_id = mc.movie_id
  AND mk.movie_id = mc.movie_id
  AND ml.movie_id = mi.movie_id
  AND mk.movie_id = mi.movie_id
  AND mc.movie_id = mi.movie_id;


/*+ NestLoop(ml lt t mc cn ct mk k mi)
 NestLoop(ml lt t mc cn ct mk k)
 NestLoop(ml lt t mc cn ct mk)
 HashJoin(ml lt t mc cn ct)
 NestLoop(ml lt t mc cn)
 NestLoop(ml lt t mc)
 NestLoop(ml lt t)
 NestLoop(ml lt)
 IndexScan(ml)
 SeqScan(lt)
 IndexScan(t)
 IndexScan(mc)
 IndexScan(cn)
 SeqScan(ct)
 IndexScan(mk)
 IndexScan(k)
 IndexScan(mi)
 Leading(((((((((ml lt) t) mc) cn) ct) mk) k) mi)) */
SELECT MIN(cn.name) AS company_name,
       MIN(lt.link) AS link_type,
       MIN(t.title) AS german_follow_up
FROM company_name AS cn,
     company_type AS ct,
     keyword AS k,
     link_type AS lt,
     movie_companies AS mc,
     movie_info AS mi,
     movie_keyword AS mk,
     movie_link AS ml,
     title AS t
WHERE cn.country_code !='[pl]'
  AND (cn.name LIKE '%Film%'
       OR cn.name LIKE '%Warner%')
  AND ct.kind ='production companies'
  AND k.keyword ='sequel'
  AND lt.link LIKE '%follow%'
  AND mc.note IS NULL
  AND mi.info IN ('Germany',
                  'German')
  AND t.production_year BETWEEN 2000 AND 2010
  AND lt.id = ml.link_type_id
  AND ml.movie_id = t.id
  AND t.id = mk.movie_id
  AND mk.keyword_id = k.id
  AND t.id = mc.movie_id
  AND mc.company_type_id = ct.id
  AND mc.company_id = cn.id
  AND mi.movie_id = t.id
  AND ml.movie_id = mk.movie_id
  AND ml.movie_id = mc.movie_id
  AND mk.movie_id = mc.movie_id
  AND ml.movie_id = mi.movie_id
  AND mk.movie_id = mi.movie_id
  AND mc.movie_id = mi.movie_id;


/*+ NestLoop(t k mk mi it1 kt mi_idx it2 mc ct cn)
 HashJoin(t k mk mi it1 kt mi_idx it2 mc ct)
 NestLoop(t k mk mi it1 kt mi_idx it2 mc)
 HashJoin(t k mk mi it1 kt mi_idx it2)
 NestLoop(t k mk mi it1 kt mi_idx)
 NestLoop(t k mk mi it1 kt)
 NestLoop(t k mk mi it1)
 NestLoop(t k mk mi)
 HashJoin(t k mk)
 NestLoop(k mk)
 SeqScan(t)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(mi)
 IndexScan(it1)
 IndexScan(kt)
 IndexScan(mi_idx)
 IndexScan(it2)
 IndexScan(mc)
 SeqScan(ct)
 IndexScan(cn)
 Leading((((((((((t (k mk)) mi) it1) kt) mi_idx) it2) mc) ct) cn)) */
SELECT MIN(cn.name) AS movie_company,
       MIN(mi_idx.info) AS rating,
       MIN(t.title) AS western_violent_movie
FROM company_name AS cn,
     company_type AS ct,
     info_type AS it1,
     info_type AS it2,
     keyword AS k,
     kind_type AS kt,
     movie_companies AS mc,
     movie_info AS mi,
     movie_info_idx AS mi_idx,
     movie_keyword AS mk,
     title AS t
WHERE cn.country_code != '[us]'
  AND it1.info = 'countries'
  AND it2.info = 'rating'
  AND k.keyword IN ('murder',
                    'murder-in-title',
                    'blood',
                    'violence')
  AND kt.kind IN ('movie',
                  'episode')
  AND mc.note NOT LIKE '%(USA)%'
  AND mc.note LIKE '%(200%)%'
  AND mi.info IN ('Sweden',
                  'Norway',
                  'Germany',
                  'Denmark',
                  'Swedish',
                  'Danish',
                  'Norwegian',
                  'German',
                  'USA',
                  'American')
  AND mi_idx.info < '8.5'
  AND t.production_year > 2005
  AND kt.id = t.kind_id
  AND t.id = mi.movie_id
  AND t.id = mk.movie_id
  AND t.id = mi_idx.movie_id
  AND t.id = mc.movie_id
  AND mk.movie_id = mi.movie_id
  AND mk.movie_id = mi_idx.movie_id
  AND mk.movie_id = mc.movie_id
  AND mi.movie_id = mi_idx.movie_id
  AND mi.movie_id = mc.movie_id
  AND mc.movie_id = mi_idx.movie_id
  AND k.id = mk.keyword_id
  AND it1.id = mi.info_type_id
  AND it2.id = mi_idx.info_type_id
  AND ct.id = mc.company_type_id
  AND cn.id = mc.company_id;


/*+ HashJoin(t k mk mi it1 kt mi_idx it2 mc cn ct)
 HashJoin(t k mk mi it1 kt mi_idx it2 mc cn)
 NestLoop(t k mk mi it1 kt mi_idx it2 mc)
 MergeJoin(t k mk mi it1 kt mi_idx it2)
 NestLoop(t k mk mi it1 kt mi_idx)
 HashJoin(t k mk mi it1 kt)
 HashJoin(t k mk mi it1)
 NestLoop(t k mk mi)
 HashJoin(t k mk)
 NestLoop(k mk)
 SeqScan(t)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(mi)
 IndexScan(it1)
 SeqScan(kt)
 IndexScan(mi_idx)
 SeqScan(it2)
 IndexScan(mc)
 SeqScan(cn)
 IndexScan(ct)
 Leading((((((((((t (k mk)) mi) it1) kt) mi_idx) it2) mc) cn) ct)) */
SELECT MIN(cn.name) AS movie_company,
       MIN(mi_idx.info) AS rating,
       MIN(t.title) AS western_violent_movie
FROM company_name AS cn,
     company_type AS ct,
     info_type AS it1,
     info_type AS it2,
     keyword AS k,
     kind_type AS kt,
     movie_companies AS mc,
     movie_info AS mi,
     movie_info_idx AS mi_idx,
     movie_keyword AS mk,
     title AS t
WHERE cn.country_code != '[us]'
  AND it1.info = 'countries'
  AND it2.info = 'rating'
  AND k.keyword IN ('murder',
                    'murder-in-title',
                    'blood',
                    'violence')
  AND kt.kind IN ('movie',
                  'episode')
  AND mi.info IN ('Sweden',
                  'Norway',
                  'Germany',
                  'Denmark',
                  'Swedish',
                  'Danish',
                  'Norwegian',
                  'German',
                  'USA',
                  'American')
  AND mi_idx.info < '8.5'
  AND t.production_year > 2005
  AND kt.id = t.kind_id
  AND t.id = mi.movie_id
  AND t.id = mk.movie_id
  AND t.id = mi_idx.movie_id
  AND t.id = mc.movie_id
  AND mk.movie_id = mi.movie_id
  AND mk.movie_id = mi_idx.movie_id
  AND mk.movie_id = mc.movie_id
  AND mi.movie_id = mi_idx.movie_id
  AND mi.movie_id = mc.movie_id
  AND mc.movie_id = mi_idx.movie_id
  AND k.id = mk.keyword_id
  AND it1.id = mi.info_type_id
  AND it2.id = mi_idx.info_type_id
  AND ct.id = mc.company_type_id
  AND cn.id = mc.company_id;


/*+ NestLoop(mi t mc it1 cn cc mk k cct1 ct kt)
 MergeJoin(mi t mc it1 cn cc mk k cct1 ct)
 NestLoop(mi t mc it1 cn cc mk k cct1)
 NestLoop(mi t mc it1 cn cc mk k)
 NestLoop(mi t mc it1 cn cc mk)
 NestLoop(mi t mc it1 cn cc)
 NestLoop(mi t mc it1 cn)
 NestLoop(mi t mc it1)
 NestLoop(mi t mc)
 NestLoop(mi t)
 IndexScan(mi)
 IndexScan(t)
 IndexScan(mc)
 SeqScan(it1)
 IndexScan(cn)
 IndexScan(cc)
 IndexScan(mk)
 IndexScan(k)
 IndexScan(cct1)
 SeqScan(ct)
 IndexScan(kt)
 Leading(((((((((((mi t) mc) it1) cn) cc) mk) k) cct1) ct) kt)) */
SELECT MIN(kt.kind) AS movie_kind,
       MIN(t.title) AS complete_us_internet_movie
FROM complete_cast AS cc,
     comp_cast_type AS cct1,
     company_name AS cn,
     company_type AS ct,
     info_type AS it1,
     keyword AS k,
     kind_type AS kt,
     movie_companies AS mc,
     movie_info AS mi,
     movie_keyword AS mk,
     title AS t
WHERE cct1.kind = 'complete+verified'
  AND cn.country_code = '[us]'
  AND it1.info = 'release dates'
  AND kt.kind IN ('movie')
  AND mi.note LIKE '%internet%'
  AND mi.info IS NOT NULL
  AND (mi.info LIKE 'USA:% 199%'
       OR mi.info LIKE 'USA:% 200%')
  AND t.production_year > 2000
  AND kt.id = t.kind_id
  AND t.id = mi.movie_id
  AND t.id = mk.movie_id
  AND t.id = mc.movie_id
  AND t.id = cc.movie_id
  AND mk.movie_id = mi.movie_id
  AND mk.movie_id = mc.movie_id
  AND mk.movie_id = cc.movie_id
  AND mi.movie_id = mc.movie_id
  AND mi.movie_id = cc.movie_id
  AND mc.movie_id = cc.movie_id
  AND k.id = mk.keyword_id
  AND it1.id = mi.info_type_id
  AND cn.id = mc.company_id
  AND ct.id = mc.company_type_id
  AND cct1.id = cc.status_id;


/*+ MergeJoin(k mk cc t cct1 mc kt cn ct mi it1)
 NestLoop(k mk cc t cct1 mc kt cn ct mi)
 NestLoop(k mk cc t cct1 mc kt cn ct)
 NestLoop(k mk cc t cct1 mc kt cn)
 NestLoop(k mk cc t cct1 mc kt)
 NestLoop(k mk cc t cct1 mc)
 NestLoop(k mk cc t cct1)
 NestLoop(k mk cc t)
 NestLoop(k mk cc)
 NestLoop(k mk)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(cc)
 IndexScan(t)
 IndexScan(cct1)
 IndexScan(mc)
 SeqScan(kt)
 IndexScan(cn)
 SeqScan(ct)
 IndexScan(mi)
 IndexScan(it1)
 Leading(((((((((((k mk) cc) t) cct1) mc) kt) cn) ct) mi) it1)) */
SELECT MIN(kt.kind) AS movie_kind,
       MIN(t.title) AS complete_nerdy_internet_movie
FROM complete_cast AS cc,
     comp_cast_type AS cct1,
     company_name AS cn,
     company_type AS ct,
     info_type AS it1,
     keyword AS k,
     kind_type AS kt,
     movie_companies AS mc,
     movie_info AS mi,
     movie_keyword AS mk,
     title AS t
WHERE cct1.kind = 'complete+verified'
  AND cn.country_code = '[us]'
  AND it1.info = 'release dates'
  AND k.keyword IN ('nerd',
                    'loner',
                    'alienation',
                    'dignity')
  AND kt.kind IN ('movie')
  AND mi.note LIKE '%internet%'
  AND mi.info LIKE 'USA:% 200%'
  AND t.production_year > 2000
  AND kt.id = t.kind_id
  AND t.id = mi.movie_id
  AND t.id = mk.movie_id
  AND t.id = mc.movie_id
  AND t.id = cc.movie_id
  AND mk.movie_id = mi.movie_id
  AND mk.movie_id = mc.movie_id
  AND mk.movie_id = cc.movie_id
  AND mi.movie_id = mc.movie_id
  AND mi.movie_id = cc.movie_id
  AND mc.movie_id = cc.movie_id
  AND k.id = mk.keyword_id
  AND it1.id = mi.info_type_id
  AND cn.id = mc.company_id
  AND ct.id = mc.company_type_id
  AND cct1.id = cc.status_id;


/*+ NestLoop(mi t it1 cc cct1 kt mk k mc ct cn)
 NestLoop(mi t it1 cc cct1 kt mk k mc ct)
 NestLoop(mi t it1 cc cct1 kt mk k mc)
 NestLoop(mi t it1 cc cct1 kt mk k)
 NestLoop(mi t it1 cc cct1 kt mk)
 HashJoin(mi t it1 cc cct1 kt)
 NestLoop(mi t it1 cc cct1)
 NestLoop(mi t it1 cc)
 NestLoop(mi t it1)
 NestLoop(mi t)
 IndexScan(mi)
 IndexScan(t)
 SeqScan(it1)
 IndexScan(cc)
 IndexScan(cct1)
 SeqScan(kt)
 IndexScan(mk)
 IndexScan(k)
 IndexScan(mc)
 SeqScan(ct)
 IndexScan(cn)
 Leading(((((((((((mi t) it1) cc) cct1) kt) mk) k) mc) ct) cn)) */
SELECT MIN(kt.kind) AS movie_kind,
       MIN(t.title) AS complete_us_internet_movie
FROM complete_cast AS cc,
     comp_cast_type AS cct1,
     company_name AS cn,
     company_type AS ct,
     info_type AS it1,
     keyword AS k,
     kind_type AS kt,
     movie_companies AS mc,
     movie_info AS mi,
     movie_keyword AS mk,
     title AS t
WHERE cct1.kind = 'complete+verified'
  AND cn.country_code = '[us]'
  AND it1.info = 'release dates'
  AND kt.kind IN ('movie',
                  'tv movie',
                  'video movie',
                  'video game')
  AND mi.note LIKE '%internet%'
  AND mi.info IS NOT NULL
  AND (mi.info LIKE 'USA:% 199%'
       OR mi.info LIKE 'USA:% 200%')
  AND t.production_year > 1990
  AND kt.id = t.kind_id
  AND t.id = mi.movie_id
  AND t.id = mk.movie_id
  AND t.id = mc.movie_id
  AND t.id = cc.movie_id
  AND mk.movie_id = mi.movie_id
  AND mk.movie_id = mc.movie_id
  AND mk.movie_id = cc.movie_id
  AND mi.movie_id = mc.movie_id
  AND mi.movie_id = cc.movie_id
  AND mc.movie_id = cc.movie_id
  AND k.id = mk.keyword_id
  AND it1.id = mi.info_type_id
  AND cn.id = mc.company_id
  AND ct.id = mc.company_type_id
  AND cct1.id = cc.status_id;


/*+ NestLoop(k mk t ci n mi an it rt mc chn cn)
 NestLoop(k mk t ci n mi an it rt mc chn)
 NestLoop(k mk t ci n mi an it rt mc)
 NestLoop(k mk t ci n mi an it rt)
 NestLoop(k mk t ci n mi an it)
 NestLoop(k mk t ci n mi an)
 NestLoop(k mk t ci n mi)
 NestLoop(k mk t ci n)
 NestLoop(k mk t ci)
 NestLoop(k mk t)
 NestLoop(k mk)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(t)
 IndexScan(ci)
 IndexScan(n)
 IndexScan(mi)
 IndexScan(an)
 SeqScan(it)
 IndexScan(rt)
 IndexScan(mc)
 IndexScan(chn)
 IndexScan(cn)
 Leading((((((((((((k mk) t) ci) n) mi) an) it) rt) mc) chn) cn)) */
SELECT MIN(chn.name) AS voiced_char_name,
       MIN(n.name) AS voicing_actress_name,
       MIN(t.title) AS voiced_action_movie_jap_eng
FROM aka_name AS an,
     char_name AS chn,
     cast_info AS ci,
     company_name AS cn,
     info_type AS it,
     keyword AS k,
     movie_companies AS mc,
     movie_info AS mi,
     movie_keyword AS mk,
     name AS n,
     role_type AS rt,
     title AS t
WHERE ci.note IN ('(voice)',
                  '(voice: Japanese version)',
                  '(voice) (uncredited)',
                  '(voice: English version)')
  AND cn.country_code ='[us]'
  AND it.info = 'release dates'
  AND k.keyword IN ('hero',
                    'martial-arts',
                    'hand-to-hand-combat')
  AND mi.info IS NOT NULL
  AND (mi.info LIKE 'Japan:%201%'
       OR mi.info LIKE 'USA:%201%')
  AND n.gender ='f'
  AND n.name LIKE '%An%'
  AND rt.role ='actress'
  AND t.production_year > 2010
  AND t.id = mi.movie_id
  AND t.id = mc.movie_id
  AND t.id = ci.movie_id
  AND t.id = mk.movie_id
  AND mc.movie_id = ci.movie_id
  AND mc.movie_id = mi.movie_id
  AND mc.movie_id = mk.movie_id
  AND mi.movie_id = ci.movie_id
  AND mi.movie_id = mk.movie_id
  AND ci.movie_id = mk.movie_id
  AND cn.id = mc.company_id
  AND it.id = mi.info_type_id
  AND n.id = ci.person_id
  AND rt.id = ci.role_id
  AND n.id = an.person_id
  AND ci.person_id = an.person_id
  AND chn.id = ci.person_role_id
  AND k.id = mk.keyword_id;


/*+ NestLoop(t mk k ci rt chn mc cn n an mi it)
 NestLoop(t mk k ci rt chn mc cn n an mi)
 NestLoop(t mk k ci rt chn mc cn n an)
 NestLoop(t mk k ci rt chn mc cn n)
 NestLoop(t mk k ci rt chn mc cn)
 NestLoop(t mk k ci rt chn mc)
 NestLoop(t mk k ci rt chn)
 NestLoop(t mk k ci rt)
 NestLoop(t mk k ci)
 NestLoop(t mk k)
 NestLoop(t mk)
 SeqScan(t)
 IndexScan(mk)
 IndexScan(k)
 IndexScan(ci)
 SeqScan(rt)
 IndexScan(chn)
 IndexScan(mc)
 IndexScan(cn)
 IndexScan(n)
 IndexScan(an)
 IndexScan(mi)
 SeqScan(it)
 Leading((((((((((((t mk) k) ci) rt) chn) mc) cn) n) an) mi) it)) */
SELECT MIN(chn.name) AS voiced_char_name,
       MIN(n.name) AS voicing_actress_name,
       MIN(t.title) AS kung_fu_panda
FROM aka_name AS an,
     char_name AS chn,
     cast_info AS ci,
     company_name AS cn,
     info_type AS it,
     keyword AS k,
     movie_companies AS mc,
     movie_info AS mi,
     movie_keyword AS mk,
     name AS n,
     role_type AS rt,
     title AS t
WHERE ci.note IN ('(voice)',
                  '(voice: Japanese version)',
                  '(voice) (uncredited)',
                  '(voice: English version)')
  AND cn.country_code ='[us]'
  AND cn.name = 'DreamWorks Animation'
  AND it.info = 'release dates'
  AND k.keyword IN ('hero',
                    'martial-arts',
                    'hand-to-hand-combat',
                    'computer-animated-movie')
  AND mi.info IS NOT NULL
  AND (mi.info LIKE 'Japan:%201%'
       OR mi.info LIKE 'USA:%201%')
  AND n.gender ='f'
  AND n.name LIKE '%An%'
  AND rt.role ='actress'
  AND t.production_year > 2010
  AND t.title LIKE 'Kung Fu Panda%'
  AND t.id = mi.movie_id
  AND t.id = mc.movie_id
  AND t.id = ci.movie_id
  AND t.id = mk.movie_id
  AND mc.movie_id = ci.movie_id
  AND mc.movie_id = mi.movie_id
  AND mc.movie_id = mk.movie_id
  AND mi.movie_id = ci.movie_id
  AND mi.movie_id = mk.movie_id
  AND ci.movie_id = mk.movie_id
  AND cn.id = mc.company_id
  AND it.id = mi.info_type_id
  AND n.id = ci.person_id
  AND rt.id = ci.role_id
  AND n.id = an.person_id
  AND ci.person_id = an.person_id
  AND chn.id = ci.person_role_id
  AND k.id = mk.keyword_id;


/*+ NestLoop(t k mk mi mi_idx it2 it1 ci n)
 NestLoop(t k mk mi mi_idx it2 it1 ci)
 NestLoop(t k mk mi mi_idx it2 it1)
 NestLoop(t k mk mi mi_idx it2)
 NestLoop(t k mk mi mi_idx)
 NestLoop(t k mk mi)
 HashJoin(t k mk)
 NestLoop(k mk)
 SeqScan(t)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(mi)
 IndexScan(mi_idx)
 IndexScan(it2)
 IndexScan(it1)
 IndexScan(ci)
 IndexScan(n)
 Leading((((((((t (k mk)) mi) mi_idx) it2) it1) ci) n)) */
SELECT MIN(mi.info) AS movie_budget,
       MIN(mi_idx.info) AS movie_votes,
       MIN(n.name) AS male_writer,
       MIN(t.title) AS violent_movie_title
FROM cast_info AS ci,
     info_type AS it1,
     info_type AS it2,
     keyword AS k,
     movie_info AS mi,
     movie_info_idx AS mi_idx,
     movie_keyword AS mk,
     name AS n,
     title AS t
WHERE ci.note IN ('(writer)',
                  '(head writer)',
                  '(written by)',
                  '(story)',
                  '(story editor)')
  AND it1.info = 'genres'
  AND it2.info = 'votes'
  AND k.keyword IN ('murder',
                    'blood',
                    'gore',
                    'death',
                    'female-nudity')
  AND mi.info = 'Horror'
  AND n.gender = 'm'
  AND t.id = mi.movie_id
  AND t.id = mi_idx.movie_id
  AND t.id = ci.movie_id
  AND t.id = mk.movie_id
  AND ci.movie_id = mi.movie_id
  AND ci.movie_id = mi_idx.movie_id
  AND ci.movie_id = mk.movie_id
  AND mi.movie_id = mi_idx.movie_id
  AND mi.movie_id = mk.movie_id
  AND mi_idx.movie_id = mk.movie_id
  AND n.id = ci.person_id
  AND it1.id = mi.info_type_id
  AND it2.id = mi_idx.info_type_id
  AND k.id = mk.keyword_id;


/*+ NestLoop(t mk k mi_idx it2 mi it1 ci n)
 NestLoop(t mk k mi_idx it2 mi it1 ci)
 HashJoin(t mk k mi_idx it2 mi it1)
 NestLoop(t mk k mi_idx it2 mi)
 NestLoop(t mk k mi_idx it2)
 NestLoop(t mk k mi_idx)
 NestLoop(t mk k)
 NestLoop(t mk)
 SeqScan(t)
 IndexScan(mk)
 IndexScan(k)
 IndexScan(mi_idx)
 SeqScan(it2)
 IndexScan(mi)
 IndexScan(it1)
 IndexScan(ci)
 IndexScan(n)
 Leading(((((((((t mk) k) mi_idx) it2) mi) it1) ci) n)) */
SELECT MIN(mi.info) AS movie_budget,
       MIN(mi_idx.info) AS movie_votes,
       MIN(n.name) AS male_writer,
       MIN(t.title) AS violent_movie_title
FROM cast_info AS ci,
     info_type AS it1,
     info_type AS it2,
     keyword AS k,
     movie_info AS mi,
     movie_info_idx AS mi_idx,
     movie_keyword AS mk,
     name AS n,
     title AS t
WHERE ci.note IN ('(writer)',
                  '(head writer)',
                  '(written by)',
                  '(story)',
                  '(story editor)')
  AND it1.info = 'genres'
  AND it2.info = 'votes'
  AND k.keyword IN ('murder',
                    'blood',
                    'gore',
                    'death',
                    'female-nudity')
  AND mi.info = 'Horror'
  AND n.gender = 'm'
  AND t.production_year > 2010
  AND t.title LIKE 'Vampire%'
  AND t.id = mi.movie_id
  AND t.id = mi_idx.movie_id
  AND t.id = ci.movie_id
  AND t.id = mk.movie_id
  AND ci.movie_id = mi.movie_id
  AND ci.movie_id = mi_idx.movie_id
  AND ci.movie_id = mk.movie_id
  AND mi.movie_id = mi_idx.movie_id
  AND mi.movie_id = mk.movie_id
  AND mi_idx.movie_id = mk.movie_id
  AND n.id = ci.person_id
  AND it1.id = mi.info_type_id
  AND it2.id = mi_idx.info_type_id
  AND k.id = mk.keyword_id;


/*+ HashJoin(t k mk ci n mi_idx it2 mi it1)
 NestLoop(t k mk ci n mi_idx it2 mi)
 HashJoin(t k mk ci n mi_idx it2)
 NestLoop(t k mk ci n mi_idx)
 NestLoop(t k mk ci n)
 NestLoop(t k mk ci)
 HashJoin(t k mk)
 NestLoop(k mk)
 SeqScan(t)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(ci)
 IndexScan(n)
 IndexScan(mi_idx)
 IndexScan(it2)
 IndexScan(mi)
 SeqScan(it1)
 Leading((((((((t (k mk)) ci) n) mi_idx) it2) mi) it1)) */
SELECT MIN(mi.info) AS movie_budget,
       MIN(mi_idx.info) AS movie_votes,
       MIN(n.name) AS male_writer,
       MIN(t.title) AS violent_movie_title
FROM cast_info AS ci,
     info_type AS it1,
     info_type AS it2,
     keyword AS k,
     movie_info AS mi,
     movie_info_idx AS mi_idx,
     movie_keyword AS mk,
     name AS n,
     title AS t
WHERE ci.note IN ('(writer)',
                  '(head writer)',
                  '(written by)',
                  '(story)',
                  '(story editor)')
  AND it1.info = 'genres'
  AND it2.info = 'votes'
  AND k.keyword IN ('murder',
                    'violence',
                    'blood',
                    'gore',
                    'death',
                    'female-nudity',
                    'hospital')
  AND mi.info IN ('Horror',
                  'Action',
                  'Sci-Fi',
                  'Thriller',
                  'Crime',
                  'War')
  AND n.gender = 'm'
  AND t.id = mi.movie_id
  AND t.id = mi_idx.movie_id
  AND t.id = ci.movie_id
  AND t.id = mk.movie_id
  AND ci.movie_id = mi.movie_id
  AND ci.movie_id = mi_idx.movie_id
  AND ci.movie_id = mk.movie_id
  AND mi.movie_id = mi_idx.movie_id
  AND mi.movie_id = mk.movie_id
  AND mi_idx.movie_id = mk.movie_id
  AND n.id = ci.person_id
  AND it1.id = mi.info_type_id
  AND it2.id = mi_idx.info_type_id
  AND k.id = mk.keyword_id;


/*+ NestLoop(t k mk cc mi_idx kt cct2 it2 cct1 ci chn n)
 NestLoop(t k mk cc mi_idx kt cct2 it2 cct1 ci chn)
 NestLoop(t k mk cc mi_idx kt cct2 it2 cct1 ci)
 NestLoop(t k mk cc mi_idx kt cct2 it2 cct1)
 NestLoop(t k mk cc mi_idx kt cct2 it2)
 NestLoop(t k mk cc mi_idx kt cct2)
 NestLoop(t k mk cc mi_idx kt)
 NestLoop(t k mk cc mi_idx)
 NestLoop(t k mk cc)
 HashJoin(t k mk)
 NestLoop(k mk)
 SeqScan(t)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(cc)
 IndexScan(mi_idx)
 SeqScan(kt)
 SeqScan(cct2)
 SeqScan(it2)
 SeqScan(cct1)
 IndexScan(ci)
 IndexScan(chn)
 IndexScan(n)
 Leading(((((((((((t (k mk)) cc) mi_idx) kt) cct2) it2) cct1) ci) chn) n)) */
SELECT MIN(chn.name) AS character_name,
       MIN(mi_idx.info) AS rating,
       MIN(n.name) AS playing_actor,
       MIN(t.title) AS complete_hero_movie
FROM complete_cast AS cc,
     comp_cast_type AS cct1,
     comp_cast_type AS cct2,
     char_name AS chn,
     cast_info AS ci,
     info_type AS it2,
     keyword AS k,
     kind_type AS kt,
     movie_info_idx AS mi_idx,
     movie_keyword AS mk,
     name AS n,
     title AS t
WHERE cct1.kind = 'cast'
  AND cct2.kind LIKE '%complete%'
  AND chn.name IS NOT NULL
  AND (chn.name LIKE '%man%'
       OR chn.name LIKE '%Man%')
  AND it2.info = 'rating'
  AND k.keyword IN ('superhero',
                    'marvel-comics',
                    'based-on-comic',
                    'tv-special',
                    'fight',
                    'violence',
                    'magnet',
                    'web',
                    'claw',
                    'laser')
  AND kt.kind = 'movie'
  AND mi_idx.info > '7.0'
  AND t.production_year > 2000
  AND kt.id = t.kind_id
  AND t.id = mk.movie_id
  AND t.id = ci.movie_id
  AND t.id = cc.movie_id
  AND t.id = mi_idx.movie_id
  AND mk.movie_id = ci.movie_id
  AND mk.movie_id = cc.movie_id
  AND mk.movie_id = mi_idx.movie_id
  AND ci.movie_id = cc.movie_id
  AND ci.movie_id = mi_idx.movie_id
  AND cc.movie_id = mi_idx.movie_id
  AND chn.id = ci.person_role_id
  AND n.id = ci.person_id
  AND k.id = mk.keyword_id
  AND cct1.id = cc.subject_id
  AND cct2.id = cc.status_id
  AND it2.id = mi_idx.info_type_id;


/*+ NestLoop(t k mk cc cct1 kt mi_idx cct2 it2 ci chn n)
 NestLoop(t k mk cc cct1 kt mi_idx cct2 it2 ci chn)
 NestLoop(t k mk cc cct1 kt mi_idx cct2 it2 ci)
 NestLoop(t k mk cc cct1 kt mi_idx cct2 it2)
 NestLoop(t k mk cc cct1 kt mi_idx cct2)
 NestLoop(t k mk cc cct1 kt mi_idx)
 HashJoin(t k mk cc cct1 kt)
 NestLoop(t k mk cc cct1)
 NestLoop(t k mk cc)
 HashJoin(t k mk)
 NestLoop(k mk)
 SeqScan(t)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(cc)
 IndexScan(cct1)
 SeqScan(kt)
 IndexScan(mi_idx)
 SeqScan(cct2)
 SeqScan(it2)
 IndexScan(ci)
 IndexScan(chn)
 IndexScan(n)
 Leading(((((((((((t (k mk)) cc) cct1) kt) mi_idx) cct2) it2) ci) chn) n)) */
SELECT MIN(chn.name) AS character_name,
       MIN(mi_idx.info) AS rating,
       MIN(t.title) AS complete_hero_movie
FROM complete_cast AS cc,
     comp_cast_type AS cct1,
     comp_cast_type AS cct2,
     char_name AS chn,
     cast_info AS ci,
     info_type AS it2,
     keyword AS k,
     kind_type AS kt,
     movie_info_idx AS mi_idx,
     movie_keyword AS mk,
     name AS n,
     title AS t
WHERE cct1.kind = 'cast'
  AND cct2.kind LIKE '%complete%'
  AND chn.name IS NOT NULL
  AND (chn.name LIKE '%man%'
       OR chn.name LIKE '%Man%')
  AND it2.info = 'rating'
  AND k.keyword IN ('superhero',
                    'marvel-comics',
                    'based-on-comic',
                    'fight')
  AND kt.kind = 'movie'
  AND mi_idx.info > '8.0'
  AND t.production_year > 2005
  AND kt.id = t.kind_id
  AND t.id = mk.movie_id
  AND t.id = ci.movie_id
  AND t.id = cc.movie_id
  AND t.id = mi_idx.movie_id
  AND mk.movie_id = ci.movie_id
  AND mk.movie_id = cc.movie_id
  AND mk.movie_id = mi_idx.movie_id
  AND ci.movie_id = cc.movie_id
  AND ci.movie_id = mi_idx.movie_id
  AND cc.movie_id = mi_idx.movie_id
  AND chn.id = ci.person_role_id
  AND n.id = ci.person_id
  AND k.id = mk.keyword_id
  AND cct1.id = cc.subject_id
  AND cct2.id = cc.status_id
  AND it2.id = mi_idx.info_type_id;


/*+ HashJoin(t k mk kt cc cct1 cct2 ci chn n mi_idx it2)
 NestLoop(t k mk kt cc cct1 cct2 ci chn n mi_idx)
 NestLoop(t k mk kt cc cct1 cct2 ci chn n)
 NestLoop(t k mk kt cc cct1 cct2 ci chn)
 NestLoop(t k mk kt cc cct1 cct2 ci)
 HashJoin(t k mk kt cc cct1 cct2)
 HashJoin(t k mk kt cc cct1)
 NestLoop(t k mk kt cc)
 NestLoop(t k mk kt)
 HashJoin(t k mk)
 NestLoop(k mk)
 SeqScan(t)
 IndexScan(k)
 IndexScan(mk)
 IndexScan(kt)
 IndexScan(cc)
 IndexScan(cct1)
 SeqScan(cct2)
 IndexScan(ci)
 IndexScan(chn)
 IndexScan(n)
 IndexScan(mi_idx)
 SeqScan(it2)
 Leading(((((((((((t (k mk)) kt) cc) cct1) cct2) ci) chn) n) mi_idx) it2)) */
SELECT MIN(chn.name) AS character_name,
       MIN(mi_idx.info) AS rating,
       MIN(t.title) AS complete_hero_movie
FROM complete_cast AS cc,
     comp_cast_type AS cct1,
     comp_cast_type AS cct2,
     char_name AS chn,
     cast_info AS ci,
     info_type AS it2,
     keyword AS k,
     kind_type AS kt,
     movie_info_idx AS mi_idx,
     movie_keyword AS mk,
     name AS n,
     title AS t
WHERE cct1.kind = 'cast'
  AND cct2.kind LIKE '%complete%'
  AND chn.name IS NOT NULL
  AND (chn.name LIKE '%man%'
       OR chn.name LIKE '%Man%')
  AND it2.info = 'rating'
  AND k.keyword IN ('superhero',
                    'marvel-comics',
                    'based-on-comic',
                    'tv-special',
                    'fight',
                    'violence',
                    'magnet',
                    'web',
                    'claw',
                    'laser')
  AND kt.kind = 'movie'
  AND t.production_year > 2000
  AND kt.id = t.kind_id
  AND t.id = mk.movie_id
  AND t.id = ci.movie_id
  AND t.id = cc.movie_id
  AND t.id = mi_idx.movie_id
  AND mk.movie_id = ci.movie_id
  AND mk.movie_id = cc.movie_id
  AND mk.movie_id = mi_idx.movie_id
  AND ci.movie_id = cc.movie_id
  AND ci.movie_id = mi_idx.movie_id
  AND cc.movie_id = mi_idx.movie_id
  AND chn.id = ci.person_role_id
  AND n.id = ci.person_id
  AND k.id = mk.keyword_id
  AND cct1.id = cc.subject_id
  AND cct2.id = cc.status_id
  AND it2.id = mi_idx.info_type_id;


/*+ NestLoop(ml lt t cc cct2 cct1 mc ct cn mk k mi)
 NestLoop(ml lt t cc cct2 cct1 mc ct cn mk k)
 NestLoop(ml lt t cc cct2 cct1 mc ct cn mk)
 NestLoop(ml lt t cc cct2 cct1 mc ct cn)
 MergeJoin(ml lt t cc cct2 cct1 mc ct)
 NestLoop(ml lt t cc cct2 cct1 mc)
 NestLoop(ml lt t cc cct2 cct1)
 NestLoop(ml lt t cc cct2)
 NestLoop(ml lt t cc)
 NestLoop(ml lt t)
 NestLoop(ml lt)
 IndexScan(ml)
 SeqScan(lt)
 IndexScan(t)
 IndexScan(cc)
 SeqScan(cct2)
 SeqScan(cct1)
 IndexScan(mc)
 SeqScan(ct)
 IndexScan(cn)
 IndexScan(mk)
 IndexScan(k)
 IndexScan(mi)
 Leading((((((((((((ml lt) t) cc) cct2) cct1) mc) ct) cn) mk) k) mi)) */
SELECT MIN(cn.name) AS producing_company,
       MIN(lt.link) AS link_type,
       MIN(t.title) AS complete_western_sequel
FROM complete_cast AS cc,
     comp_cast_type AS cct1,
     comp_cast_type AS cct2,
     company_name AS cn,
     company_type AS ct,
     keyword AS k,
     link_type AS lt,
     movie_companies AS mc,
     movie_info AS mi,
     movie_keyword AS mk,
     movie_link AS ml,
     title AS t
WHERE cct1.kind IN ('cast',
                    'crew')
  AND cct2.kind = 'complete'
  AND cn.country_code !='[pl]'
  AND (cn.name LIKE '%Film%'
       OR cn.name LIKE '%Warner%')
  AND ct.kind ='production companies'
  AND k.keyword ='sequel'
  AND lt.link LIKE '%follow%'
  AND mc.note IS NULL
  AND mi.info IN ('Sweden',
                  'Germany',
                  'Swedish',
                  'German')
  AND t.production_year BETWEEN 1950 AND 2000
  AND lt.id = ml.link_type_id
  AND ml.movie_id = t.id
  AND t.id = mk.movie_id
  AND mk.keyword_id = k.id
  AND t.id = mc.movie_id
  AND mc.company_type_id = ct.id
  AND mc.company_id = cn.id
  AND mi.movie_id = t.id
  AND t.id = cc.movie_id
  AND cct1.id = cc.subject_id
  AND cct2.id = cc.status_id
  AND ml.movie_id = mk.movie_id
  AND ml.movie_id = mc.movie_id
  AND mk.movie_id = mc.movie_id
  AND ml.movie_id = mi.movie_id
  AND mk.movie_id = mi.movie_id
  AND mc.movie_id = mi.movie_id
  AND ml.movie_id = cc.movie_id
  AND mk.movie_id = cc.movie_id
  AND mc.movie_id = cc.movie_id
  AND mi.movie_id = cc.movie_id;


/*+ NestLoop(ml lt t cc cct1 cct2 mc cn ct mk k mi)
 NestLoop(ml lt t cc cct1 cct2 mc cn ct mk k)
 NestLoop(ml lt t cc cct1 cct2 mc cn ct mk)
 MergeJoin(ml lt t cc cct1 cct2 mc cn ct)
 NestLoop(ml lt t cc cct1 cct2 mc cn)
 NestLoop(ml lt t cc cct1 cct2 mc)
 NestLoop(ml lt t cc cct1 cct2)
 NestLoop(ml lt t cc cct1)
 NestLoop(ml lt t cc)
 NestLoop(ml lt t)
 NestLoop(ml lt)
 IndexScan(ml)
 SeqScan(lt)
 IndexScan(t)
 IndexScan(cc)
 IndexScan(cct1)
 SeqScan(cct2)
 IndexScan(mc)
 IndexScan(cn)
 SeqScan(ct)
 IndexScan(mk)
 IndexScan(k)
 IndexScan(mi)
 Leading((((((((((((ml lt) t) cc) cct1) cct2) mc) cn) ct) mk) k) mi)) */
SELECT MIN(cn.name) AS producing_company,
       MIN(lt.link) AS link_type,
       MIN(t.title) AS complete_western_sequel
FROM complete_cast AS cc,
     comp_cast_type AS cct1,
     comp_cast_type AS cct2,
     company_name AS cn,
     company_type AS ct,
     keyword AS k,
     link_type AS lt,
     movie_companies AS mc,
     movie_info AS mi,
     movie_keyword AS mk,
     movie_link AS ml,
     title AS t
WHERE cct1.kind IN ('cast',
                    'crew')
  AND cct2.kind = 'complete'
  AND cn.country_code !='[pl]'
  AND (cn.name LIKE '%Film%'
       OR cn.name LIKE '%Warner%')
  AND ct.kind ='production companies'
  AND k.keyword ='sequel'
  AND lt.link LIKE '%follow%'
  AND mc.note IS NULL
  AND mi.info IN ('Sweden',
                  'Germany',
                  'Swedish',
                  'German')
  AND t.production_year = 1998
  AND lt.id = ml.link_type_id
  AND ml.movie_id = t.id
  AND t.id = mk.movie_id
  AND mk.keyword_id = k.id
  AND t.id = mc.movie_id
  AND mc.company_type_id = ct.id
  AND mc.company_id = cn.id
  AND mi.movie_id = t.id
  AND t.id = cc.movie_id
  AND cct1.id = cc.subject_id
  AND cct2.id = cc.status_id
  AND ml.movie_id = mk.movie_id
  AND ml.movie_id = mc.movie_id
  AND mk.movie_id = mc.movie_id
  AND ml.movie_id = mi.movie_id
  AND mk.movie_id = mi.movie_id
  AND mc.movie_id = mi.movie_id
  AND ml.movie_id = cc.movie_id
  AND mk.movie_id = cc.movie_id
  AND mc.movie_id = cc.movie_id
  AND mi.movie_id = cc.movie_id;


/*+ NestLoop(ml lt t cc cct1 cct2 mc cn ct mk k mi)
 NestLoop(ml lt t cc cct1 cct2 mc cn ct mk k)
 NestLoop(ml lt t cc cct1 cct2 mc cn ct mk)
 MergeJoin(ml lt t cc cct1 cct2 mc cn ct)
 NestLoop(ml lt t cc cct1 cct2 mc cn)
 NestLoop(ml lt t cc cct1 cct2 mc)
 NestLoop(ml lt t cc cct1 cct2)
 NestLoop(ml lt t cc cct1)
 NestLoop(ml lt t cc)
 NestLoop(ml lt t)
 NestLoop(ml lt)
 IndexScan(ml)
 SeqScan(lt)
 IndexScan(t)
 IndexScan(cc)
 IndexScan(cct1)
 SeqScan(cct2)
 IndexScan(mc)
 IndexScan(cn)
 SeqScan(ct)
 IndexScan(mk)
 IndexScan(k)
 IndexScan(mi)
 Leading((((((((((((ml lt) t) cc) cct1) cct2) mc) cn) ct) mk) k) mi)) */
SELECT MIN(cn.name) AS producing_company,
       MIN(lt.link) AS link_type,
       MIN(t.title) AS complete_western_sequel
FROM complete_cast AS cc,
     comp_cast_type AS cct1,
     comp_cast_type AS cct2,
     company_name AS cn,
     company_type AS ct,
     keyword AS k,
     link_type AS lt,
     movie_companies AS mc,
     movie_info AS mi,
     movie_keyword AS mk,
     movie_link AS ml,
     title AS t
WHERE cct1.kind = 'cast'
  AND cct2.kind LIKE 'complete%'
  AND cn.country_code !='[pl]'
  AND (cn.name LIKE '%Film%'
       OR cn.name LIKE '%Warner%')
  AND ct.kind ='production companies'
  AND k.keyword ='sequel'
  AND lt.link LIKE '%follow%'
  AND mc.note IS NULL
  AND mi.info IN ('Sweden',
                  'Norway',
                  'Germany',
                  'Denmark',
                  'Swedish',
                  'Denish',
                  'Norwegian',
                  'German',
                  'English')
  AND t.production_year BETWEEN 1950 AND 2010
  AND lt.id = ml.link_type_id
  AND ml.movie_id = t.id
  AND t.id = mk.movie_id
  AND mk.keyword_id = k.id
  AND t.id = mc.movie_id
  AND mc.company_type_id = ct.id
  AND mc.company_id = cn.id
  AND mi.movie_id = t.id
  AND t.id = cc.movie_id
  AND cct1.id = cc.subject_id
  AND cct2.id = cc.status_id
  AND ml.movie_id = mk.movie_id
  AND ml.movie_id = mc.movie_id
  AND mk.movie_id = mc.movie_id
  AND ml.movie_id = mi.movie_id
  AND mk.movie_id = mi.movie_id
  AND mc.movie_id = mi.movie_id
  AND ml.movie_id = cc.movie_id
  AND mk.movie_id = cc.movie_id
  AND mc.movie_id = cc.movie_id
  AND mi.movie_id = cc.movie_id;


/*+ NestLoop(cct1 t k mk cc mi mi_idx it2 it1 cct2 mc kt ct cn)
 NestLoop(cct1 t k mk cc mi mi_idx it2 it1 cct2 mc kt ct)
 NestLoop(cct1 t k mk cc mi mi_idx it2 it1 cct2 mc kt)
 NestLoop(cct1 t k mk cc mi mi_idx it2 it1 cct2 mc)
 NestLoop(cct1 t k mk cc mi mi_idx it2 it1 cct2)
 NestLoop(cct1 t k mk cc mi mi_idx it2 it1)
 NestLoop(cct1 t k mk cc mi mi_idx it2)
 NestLoop(cct1 t k mk cc mi mi_idx)
 NestLoop(cct1 t k mk cc mi)
 NestLoop(cct1 t k mk cc)
 NestLoop(t k mk cc)
 HashJoin(t k mk)
 NestLoop(k mk)
 SeqScan(cct1)
 SeqScan(t)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(cc)
 IndexScan(mi)
 IndexScan(mi_idx)
 SeqScan(it2)
 SeqScan(it1)
 SeqScan(cct2)
 IndexScan(mc)
 SeqScan(kt)
 SeqScan(ct)
 IndexScan(cn)
 Leading(((((((((((cct1 ((t (k mk)) cc)) mi) mi_idx) it2) it1) cct2) mc) kt) ct) cn)) */
SELECT MIN(cn.name) AS movie_company,
       MIN(mi_idx.info) AS rating,
       MIN(t.title) AS complete_euro_dark_movie
FROM complete_cast AS cc,
     comp_cast_type AS cct1,
     comp_cast_type AS cct2,
     company_name AS cn,
     company_type AS ct,
     info_type AS it1,
     info_type AS it2,
     keyword AS k,
     kind_type AS kt,
     movie_companies AS mc,
     movie_info AS mi,
     movie_info_idx AS mi_idx,
     movie_keyword AS mk,
     title AS t
WHERE cct1.kind = 'crew'
  AND cct2.kind != 'complete+verified'
  AND cn.country_code != '[us]'
  AND it1.info = 'countries'
  AND it2.info = 'rating'
  AND k.keyword IN ('murder',
                    'murder-in-title',
                    'blood',
                    'violence')
  AND kt.kind IN ('movie',
                  'episode')
  AND mc.note NOT LIKE '%(USA)%'
  AND mc.note LIKE '%(200%)%'
  AND mi.info IN ('Sweden',
                  'Norway',
                  'Germany',
                  'Denmark',
                  'Swedish',
                  'Danish',
                  'Norwegian',
                  'German',
                  'USA',
                  'American')
  AND mi_idx.info < '8.5'
  AND t.production_year > 2000
  AND kt.id = t.kind_id
  AND t.id = mi.movie_id
  AND t.id = mk.movie_id
  AND t.id = mi_idx.movie_id
  AND t.id = mc.movie_id
  AND t.id = cc.movie_id
  AND mk.movie_id = mi.movie_id
  AND mk.movie_id = mi_idx.movie_id
  AND mk.movie_id = mc.movie_id
  AND mk.movie_id = cc.movie_id
  AND mi.movie_id = mi_idx.movie_id
  AND mi.movie_id = mc.movie_id
  AND mi.movie_id = cc.movie_id
  AND mc.movie_id = mi_idx.movie_id
  AND mc.movie_id = cc.movie_id
  AND mi_idx.movie_id = cc.movie_id
  AND k.id = mk.keyword_id
  AND it1.id = mi.info_type_id
  AND it2.id = mi_idx.info_type_id
  AND ct.id = mc.company_type_id
  AND cn.id = mc.company_id
  AND cct1.id = cc.subject_id
  AND cct2.id = cc.status_id;


/*+ NestLoop(cct2 cct1 t k mk cc kt mi mc cn it1 ct mi_idx it2)
 NestLoop(cct2 cct1 t k mk cc kt mi mc cn it1 ct mi_idx)
 NestLoop(cct2 cct1 t k mk cc kt mi mc cn it1 ct)
 MergeJoin(cct2 cct1 t k mk cc kt mi mc cn it1)
 NestLoop(cct2 cct1 t k mk cc kt mi mc cn)
 NestLoop(cct2 cct1 t k mk cc kt mi mc)
 NestLoop(cct2 cct1 t k mk cc kt mi)
 NestLoop(cct2 cct1 t k mk cc kt)
 NestLoop(cct2 cct1 t k mk cc)
 NestLoop(cct1 t k mk cc)
 NestLoop(t k mk cc)
 HashJoin(t k mk)
 NestLoop(k mk)
 SeqScan(cct2)
 SeqScan(cct1)
 SeqScan(t)
 IndexScan(k)
 IndexScan(mk)
 IndexScan(cc)
 SeqScan(kt)
 IndexScan(mi)
 IndexScan(mc)
 IndexScan(cn)
 IndexScan(it1)
 IndexScan(ct)
 IndexScan(mi_idx)
 SeqScan(it2)
 Leading((((((((((cct2 (cct1 ((t (k mk)) cc))) kt) mi) mc) cn) it1) ct) mi_idx) it2)) */
SELECT MIN(cn.name) AS movie_company,
       MIN(mi_idx.info) AS rating,
       MIN(t.title) AS complete_euro_dark_movie
FROM complete_cast AS cc,
     comp_cast_type AS cct1,
     comp_cast_type AS cct2,
     company_name AS cn,
     company_type AS ct,
     info_type AS it1,
     info_type AS it2,
     keyword AS k,
     kind_type AS kt,
     movie_companies AS mc,
     movie_info AS mi,
     movie_info_idx AS mi_idx,
     movie_keyword AS mk,
     title AS t
WHERE cct1.kind = 'crew'
  AND cct2.kind != 'complete+verified'
  AND cn.country_code != '[us]'
  AND it1.info = 'countries'
  AND it2.info = 'rating'
  AND k.keyword IN ('murder',
                    'murder-in-title',
                    'blood',
                    'violence')
  AND kt.kind IN ('movie',
                  'episode')
  AND mc.note NOT LIKE '%(USA)%'
  AND mc.note LIKE '%(200%)%'
  AND mi.info IN ('Sweden',
                  'Germany',
                  'Swedish',
                  'German')
  AND mi_idx.info > '6.5'
  AND t.production_year > 2005
  AND kt.id = t.kind_id
  AND t.id = mi.movie_id
  AND t.id = mk.movie_id
  AND t.id = mi_idx.movie_id
  AND t.id = mc.movie_id
  AND t.id = cc.movie_id
  AND mk.movie_id = mi.movie_id
  AND mk.movie_id = mi_idx.movie_id
  AND mk.movie_id = mc.movie_id
  AND mk.movie_id = cc.movie_id
  AND mi.movie_id = mi_idx.movie_id
  AND mi.movie_id = mc.movie_id
  AND mi.movie_id = cc.movie_id
  AND mc.movie_id = mi_idx.movie_id
  AND mc.movie_id = cc.movie_id
  AND mi_idx.movie_id = cc.movie_id
  AND k.id = mk.keyword_id
  AND it1.id = mi.info_type_id
  AND it2.id = mi_idx.info_type_id
  AND ct.id = mc.company_type_id
  AND cn.id = mc.company_id
  AND cct1.id = cc.subject_id
  AND cct2.id = cc.status_id;


/*+ HashJoin(cct1 t k mk mi it1 cc kt mc cn cct2 ct mi_idx it2)
 NestLoop(cct1 t k mk mi it1 cc kt mc cn cct2 ct mi_idx)
 NestLoop(cct1 t k mk mi it1 cc kt mc cn cct2 ct)
 NestLoop(cct1 t k mk mi it1 cc kt mc cn cct2)
 NestLoop(cct1 t k mk mi it1 cc kt mc cn)
 NestLoop(cct1 t k mk mi it1 cc kt mc)
 NestLoop(cct1 t k mk mi it1 cc kt)
 NestLoop(cct1 t k mk mi it1 cc)
 NestLoop(t k mk mi it1 cc)
 NestLoop(t k mk mi it1)
 NestLoop(t k mk mi)
 HashJoin(t k mk)
 NestLoop(k mk)
 SeqScan(cct1)
 SeqScan(t)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(mi)
 IndexScan(it1)
 IndexScan(cc)
 IndexScan(kt)
 IndexScan(mc)
 IndexScan(cn)
 SeqScan(cct2)
 SeqScan(ct)
 IndexScan(mi_idx)
 SeqScan(it2)
 Leading(((((((((cct1 ((((t (k mk)) mi) it1) cc)) kt) mc) cn) cct2) ct) mi_idx) it2)) */
SELECT MIN(cn.name) AS movie_company,
       MIN(mi_idx.info) AS rating,
       MIN(t.title) AS complete_euro_dark_movie
FROM complete_cast AS cc,
     comp_cast_type AS cct1,
     comp_cast_type AS cct2,
     company_name AS cn,
     company_type AS ct,
     info_type AS it1,
     info_type AS it2,
     keyword AS k,
     kind_type AS kt,
     movie_companies AS mc,
     movie_info AS mi,
     movie_info_idx AS mi_idx,
     movie_keyword AS mk,
     title AS t
WHERE cct1.kind = 'cast'
  AND cct2.kind = 'complete'
  AND cn.country_code != '[us]'
  AND it1.info = 'countries'
  AND it2.info = 'rating'
  AND k.keyword IN ('murder',
                    'murder-in-title',
                    'blood',
                    'violence')
  AND kt.kind IN ('movie',
                  'episode')
  AND mc.note NOT LIKE '%(USA)%'
  AND mc.note LIKE '%(200%)%'
  AND mi.info IN ('Sweden',
                  'Norway',
                  'Germany',
                  'Denmark',
                  'Swedish',
                  'Danish',
                  'Norwegian',
                  'German',
                  'USA',
                  'American')
  AND mi_idx.info < '8.5'
  AND t.production_year > 2005
  AND kt.id = t.kind_id
  AND t.id = mi.movie_id
  AND t.id = mk.movie_id
  AND t.id = mi_idx.movie_id
  AND t.id = mc.movie_id
  AND t.id = cc.movie_id
  AND mk.movie_id = mi.movie_id
  AND mk.movie_id = mi_idx.movie_id
  AND mk.movie_id = mc.movie_id
  AND mk.movie_id = cc.movie_id
  AND mi.movie_id = mi_idx.movie_id
  AND mi.movie_id = mc.movie_id
  AND mi.movie_id = cc.movie_id
  AND mc.movie_id = mi_idx.movie_id
  AND mc.movie_id = cc.movie_id
  AND mi_idx.movie_id = cc.movie_id
  AND k.id = mk.keyword_id
  AND it1.id = mi.info_type_id
  AND it2.id = mi_idx.info_type_id
  AND ct.id = mc.company_type_id
  AND cn.id = mc.company_id
  AND cct1.id = cc.subject_id
  AND cct2.id = cc.status_id;


/*+ HashJoin(k mk t ci pi1 n cc chn rt cct2 cct1 it3 an mi mc cn it)
 NestLoop(k mk t ci pi1 n cc chn rt cct2 cct1 it3 an mi mc cn)
 NestLoop(k mk t ci pi1 n cc chn rt cct2 cct1 it3 an mi mc)
 NestLoop(k mk t ci pi1 n cc chn rt cct2 cct1 it3 an mi)
 NestLoop(k mk t ci pi1 n cc chn rt cct2 cct1 it3 an)
 HashJoin(k mk t ci pi1 n cc chn rt cct2 cct1 it3)
 NestLoop(k mk t ci pi1 n cc chn rt cct2 cct1)
 NestLoop(k mk t ci pi1 n cc chn rt cct2)
 NestLoop(k mk t ci pi1 n cc chn rt)
 NestLoop(k mk t ci pi1 n cc chn)
 NestLoop(k mk t ci pi1 n cc)
 NestLoop(k mk t ci pi1 n)
 NestLoop(k mk t ci pi1)
 NestLoop(k mk t ci)
 NestLoop(k mk t)
 NestLoop(k mk)
 IndexScan(k)
 IndexScan(mk)
 IndexScan(t)
 IndexScan(ci)
 IndexScan(pi1)
 IndexScan(n)
 IndexScan(cc)
 IndexScan(chn)
 SeqScan(rt)
 IndexScan(cct2)
 IndexScan(cct1)
 SeqScan(it3)
 IndexScan(an)
 IndexScan(mi)
 IndexScan(mc)
 IndexScan(cn)
 IndexScan(it)
 Leading(((((((((((((((((k mk) t) ci) pi1) n) cc) chn) rt) cct2) cct1) it3) an) mi) mc) cn) it)) */
SELECT MIN(chn.name) AS voiced_char,
       MIN(n.name) AS voicing_actress,
       MIN(t.title) AS voiced_animation
FROM aka_name AS an,
     complete_cast AS cc,
     comp_cast_type AS cct1,
     comp_cast_type AS cct2,
     char_name AS chn,
     cast_info AS ci,
     company_name AS cn,
     info_type AS it,
     info_type AS it3,
     keyword AS k,
     movie_companies AS mc,
     movie_info AS mi,
     movie_keyword AS mk,
     name AS n,
     person_info AS pi1,
     role_type AS rt,
     title AS t
WHERE cct1.kind ='cast'
  AND cct2.kind ='complete+verified'
  AND chn.name = 'Queen'
  AND ci.note IN ('(voice)',
                  '(voice) (uncredited)',
                  '(voice: English version)')
  AND cn.country_code ='[us]'
  AND it.info = 'release dates'
  AND it3.info = 'trivia'
  AND k.keyword = 'computer-animation'
  AND mi.info IS NOT NULL
  AND (mi.info LIKE 'Japan:%200%'
       OR mi.info LIKE 'USA:%200%')
  AND n.gender ='f'
  AND n.name LIKE '%An%'
  AND rt.role ='actress'
  AND t.title = 'Shrek 2'
  AND t.production_year BETWEEN 2000 AND 2010
  AND t.id = mi.movie_id
  AND t.id = mc.movie_id
  AND t.id = ci.movie_id
  AND t.id = mk.movie_id
  AND t.id = cc.movie_id
  AND mc.movie_id = ci.movie_id
  AND mc.movie_id = mi.movie_id
  AND mc.movie_id = mk.movie_id
  AND mc.movie_id = cc.movie_id
  AND mi.movie_id = ci.movie_id
  AND mi.movie_id = mk.movie_id
  AND mi.movie_id = cc.movie_id
  AND ci.movie_id = mk.movie_id
  AND ci.movie_id = cc.movie_id
  AND mk.movie_id = cc.movie_id
  AND cn.id = mc.company_id
  AND it.id = mi.info_type_id
  AND n.id = ci.person_id
  AND rt.id = ci.role_id
  AND n.id = an.person_id
  AND ci.person_id = an.person_id
  AND chn.id = ci.person_role_id
  AND n.id = pi1.person_id
  AND ci.person_id = pi1.person_id
  AND it3.id = pi1.info_type_id
  AND k.id = mk.keyword_id
  AND cct1.id = cc.subject_id
  AND cct2.id = cc.status_id;


/*+ HashJoin(k mk t ci pi1 n cc chn rt cct2 cct1 it3 an mi mc cn it)
 NestLoop(k mk t ci pi1 n cc chn rt cct2 cct1 it3 an mi mc cn)
 NestLoop(k mk t ci pi1 n cc chn rt cct2 cct1 it3 an mi mc)
 NestLoop(k mk t ci pi1 n cc chn rt cct2 cct1 it3 an mi)
 NestLoop(k mk t ci pi1 n cc chn rt cct2 cct1 it3 an)
 HashJoin(k mk t ci pi1 n cc chn rt cct2 cct1 it3)
 NestLoop(k mk t ci pi1 n cc chn rt cct2 cct1)
 NestLoop(k mk t ci pi1 n cc chn rt cct2)
 NestLoop(k mk t ci pi1 n cc chn rt)
 NestLoop(k mk t ci pi1 n cc chn)
 NestLoop(k mk t ci pi1 n cc)
 NestLoop(k mk t ci pi1 n)
 NestLoop(k mk t ci pi1)
 NestLoop(k mk t ci)
 NestLoop(k mk t)
 NestLoop(k mk)
 IndexScan(k)
 IndexScan(mk)
 IndexScan(t)
 IndexScan(ci)
 IndexScan(pi1)
 IndexScan(n)
 IndexScan(cc)
 IndexScan(chn)
 SeqScan(rt)
 IndexScan(cct2)
 IndexScan(cct1)
 SeqScan(it3)
 IndexScan(an)
 IndexScan(mi)
 IndexScan(mc)
 IndexScan(cn)
 IndexScan(it)
 Leading(((((((((((((((((k mk) t) ci) pi1) n) cc) chn) rt) cct2) cct1) it3) an) mi) mc) cn) it)) */
SELECT MIN(chn.name) AS voiced_char,
       MIN(n.name) AS voicing_actress,
       MIN(t.title) AS voiced_animation
FROM aka_name AS an,
     complete_cast AS cc,
     comp_cast_type AS cct1,
     comp_cast_type AS cct2,
     char_name AS chn,
     cast_info AS ci,
     company_name AS cn,
     info_type AS it,
     info_type AS it3,
     keyword AS k,
     movie_companies AS mc,
     movie_info AS mi,
     movie_keyword AS mk,
     name AS n,
     person_info AS pi1,
     role_type AS rt,
     title AS t
WHERE cct1.kind ='cast'
  AND cct2.kind ='complete+verified'
  AND chn.name = 'Queen'
  AND ci.note IN ('(voice)',
                  '(voice) (uncredited)',
                  '(voice: English version)')
  AND cn.country_code ='[us]'
  AND it.info = 'release dates'
  AND it3.info = 'height'
  AND k.keyword = 'computer-animation'
  AND mi.info LIKE 'USA:%200%'
  AND n.gender ='f'
  AND n.name LIKE '%An%'
  AND rt.role ='actress'
  AND t.title = 'Shrek 2'
  AND t.production_year BETWEEN 2000 AND 2005
  AND t.id = mi.movie_id
  AND t.id = mc.movie_id
  AND t.id = ci.movie_id
  AND t.id = mk.movie_id
  AND t.id = cc.movie_id
  AND mc.movie_id = ci.movie_id
  AND mc.movie_id = mi.movie_id
  AND mc.movie_id = mk.movie_id
  AND mc.movie_id = cc.movie_id
  AND mi.movie_id = ci.movie_id
  AND mi.movie_id = mk.movie_id
  AND mi.movie_id = cc.movie_id
  AND ci.movie_id = mk.movie_id
  AND ci.movie_id = cc.movie_id
  AND mk.movie_id = cc.movie_id
  AND cn.id = mc.company_id
  AND it.id = mi.info_type_id
  AND n.id = ci.person_id
  AND rt.id = ci.role_id
  AND n.id = an.person_id
  AND ci.person_id = an.person_id
  AND chn.id = ci.person_role_id
  AND n.id = pi1.person_id
  AND ci.person_id = pi1.person_id
  AND it3.id = pi1.info_type_id
  AND k.id = mk.keyword_id
  AND cct1.id = cc.subject_id
  AND cct2.id = cc.status_id;


/*+ MergeJoin(t k mk cc cct2 cct1 ci chn n rt mc cn an mi pi1 it3 it)
 HashJoin(t k mk cc cct2 cct1 ci chn n rt mc cn an mi pi1 it3)
 NestLoop(t k mk cc cct2 cct1 ci chn n rt mc cn an mi pi1)
 NestLoop(t k mk cc cct2 cct1 ci chn n rt mc cn an mi)
 NestLoop(t k mk cc cct2 cct1 ci chn n rt mc cn an)
 NestLoop(t k mk cc cct2 cct1 ci chn n rt mc cn)
 NestLoop(t k mk cc cct2 cct1 ci chn n rt mc)
 NestLoop(t k mk cc cct2 cct1 ci chn n rt)
 NestLoop(t k mk cc cct2 cct1 ci chn n)
 NestLoop(t k mk cc cct2 cct1 ci chn)
 NestLoop(t k mk cc cct2 cct1 ci)
 NestLoop(t k mk cc cct2 cct1)
 NestLoop(t k mk cc cct2)
 NestLoop(t k mk cc)
 HashJoin(t k mk)
 NestLoop(k mk)
 SeqScan(t)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(cc)
 SeqScan(cct2)
 SeqScan(cct1)
 IndexScan(ci)
 IndexScan(chn)
 IndexScan(n)
 SeqScan(rt)
 IndexScan(mc)
 IndexScan(cn)
 IndexScan(an)
 IndexScan(mi)
 IndexScan(pi1)
 SeqScan(it3)
 SeqScan(it)
 Leading((((((((((((((((t (k mk)) cc) cct2) cct1) ci) chn) n) rt) mc) cn) an) mi) pi1) it3) it)) */
SELECT MIN(chn.name) AS voiced_char,
       MIN(n.name) AS voicing_actress,
       MIN(t.title) AS voiced_animation
FROM aka_name AS an,
     complete_cast AS cc,
     comp_cast_type AS cct1,
     comp_cast_type AS cct2,
     char_name AS chn,
     cast_info AS ci,
     company_name AS cn,
     info_type AS it,
     info_type AS it3,
     keyword AS k,
     movie_companies AS mc,
     movie_info AS mi,
     movie_keyword AS mk,
     name AS n,
     person_info AS pi1,
     role_type AS rt,
     title AS t
WHERE cct1.kind ='cast'
  AND cct2.kind ='complete+verified'
  AND ci.note IN ('(voice)',
                  '(voice: Japanese version)',
                  '(voice) (uncredited)',
                  '(voice: English version)')
  AND cn.country_code ='[us]'
  AND it.info = 'release dates'
  AND it3.info = 'trivia'
  AND k.keyword = 'computer-animation'
  AND mi.info IS NOT NULL
  AND (mi.info LIKE 'Japan:%200%'
       OR mi.info LIKE 'USA:%200%')
  AND n.gender ='f'
  AND n.name LIKE '%An%'
  AND rt.role ='actress'
  AND t.production_year BETWEEN 2000 AND 2010
  AND t.id = mi.movie_id
  AND t.id = mc.movie_id
  AND t.id = ci.movie_id
  AND t.id = mk.movie_id
  AND t.id = cc.movie_id
  AND mc.movie_id = ci.movie_id
  AND mc.movie_id = mi.movie_id
  AND mc.movie_id = mk.movie_id
  AND mc.movie_id = cc.movie_id
  AND mi.movie_id = ci.movie_id
  AND mi.movie_id = mk.movie_id
  AND mi.movie_id = cc.movie_id
  AND ci.movie_id = mk.movie_id
  AND ci.movie_id = cc.movie_id
  AND mk.movie_id = cc.movie_id
  AND cn.id = mc.company_id
  AND it.id = mi.info_type_id
  AND n.id = ci.person_id
  AND rt.id = ci.role_id
  AND n.id = an.person_id
  AND ci.person_id = an.person_id
  AND chn.id = ci.person_role_id
  AND n.id = pi1.person_id
  AND ci.person_id = pi1.person_id
  AND it3.id = pi1.info_type_id
  AND k.id = mk.keyword_id
  AND cct1.id = cc.subject_id
  AND cct2.id = cc.status_id;


/*+ NestLoop(cn mc k mk t)
 HashJoin(cn mc k mk)
 NestLoop(k mk)
 NestLoop(cn mc)
 IndexScan(cn)
 IndexScan(mc)
 IndexScan(k)
 IndexScan(mk)
 IndexScan(t)
 Leading((((cn mc) (k mk)) t)) */
SELECT MIN(t.title) AS movie_title
FROM company_name AS cn,
     keyword AS k,
     movie_companies AS mc,
     movie_keyword AS mk,
     title AS t
WHERE cn.country_code ='[de]'
  AND k.keyword ='character-name-in-title'
  AND cn.id = mc.company_id
  AND mc.movie_id = t.id
  AND t.id = mk.movie_id
  AND mk.keyword_id = k.id
  AND mc.movie_id = mk.movie_id;


/*+ NestLoop(cn mc k mk t)
 HashJoin(cn mc k mk)
 NestLoop(k mk)
 NestLoop(cn mc)
 IndexScan(cn)
 IndexScan(mc)
 IndexScan(k)
 IndexScan(mk)
 IndexScan(t)
 Leading((((cn mc) (k mk)) t)) */
SELECT MIN(t.title) AS movie_title
FROM company_name AS cn,
     keyword AS k,
     movie_companies AS mc,
     movie_keyword AS mk,
     title AS t
WHERE cn.country_code ='[nl]'
  AND k.keyword ='character-name-in-title'
  AND cn.id = mc.company_id
  AND mc.movie_id = t.id
  AND t.id = mk.movie_id
  AND mk.keyword_id = k.id
  AND mc.movie_id = mk.movie_id;


/*+ HashJoin(cn mc t mk k)
 NestLoop(cn mc t mk)
 NestLoop(cn mc t)
 NestLoop(cn mc)
 IndexScan(cn)
 IndexScan(mc)
 IndexScan(t)
 IndexScan(mk)
 SeqScan(k)
 Leading(((((cn mc) t) mk) k)) */
SELECT MIN(t.title) AS movie_title
FROM company_name AS cn,
     keyword AS k,
     movie_companies AS mc,
     movie_keyword AS mk,
     title AS t
WHERE cn.country_code ='[sm]'
  AND k.keyword ='character-name-in-title'
  AND cn.id = mc.company_id
  AND mc.movie_id = t.id
  AND t.id = mk.movie_id
  AND mk.keyword_id = k.id
  AND mc.movie_id = mk.movie_id;


/*+ HashJoin(t k mk mc cn)
 NestLoop(t k mk mc)
 HashJoin(t k mk)
 NestLoop(k mk)
 SeqScan(t)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(mc)
 SeqScan(cn)
 Leading((((t (k mk)) mc) cn)) */
SELECT MIN(t.title) AS movie_title
FROM company_name AS cn,
     keyword AS k,
     movie_companies AS mc,
     movie_keyword AS mk,
     title AS t
WHERE cn.country_code ='[us]'
  AND k.keyword ='character-name-in-title'
  AND cn.id = mc.company_id
  AND mc.movie_id = t.id
  AND t.id = mk.movie_id
  AND mk.keyword_id = k.id
  AND mc.movie_id = mk.movie_id;


/*+ MergeJoin(t k mk cc cct1 cct2 ci n mi it1 mi_idx it2)
 NestLoop(t k mk cc cct1 cct2 ci n mi it1 mi_idx)
 NestLoop(t k mk cc cct1 cct2 ci n mi it1)
 NestLoop(t k mk cc cct1 cct2 ci n mi)
 NestLoop(t k mk cc cct1 cct2 ci n)
 NestLoop(t k mk cc cct1 cct2 ci)
 NestLoop(t k mk cc cct1 cct2)
 NestLoop(t k mk cc cct1)
 NestLoop(t k mk cc)
 HashJoin(t k mk)
 NestLoop(k mk)
 SeqScan(t)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(cc)
 IndexScan(cct1)
 SeqScan(cct2)
 IndexScan(ci)
 IndexScan(n)
 IndexScan(mi)
 IndexScan(it1)
 IndexScan(mi_idx)
 SeqScan(it2)
 Leading(((((((((((t (k mk)) cc) cct1) cct2) ci) n) mi) it1) mi_idx) it2)) */
SELECT MIN(mi.info) AS movie_budget,
       MIN(mi_idx.info) AS movie_votes,
       MIN(n.name) AS writer,
       MIN(t.title) AS complete_violent_movie
FROM complete_cast AS cc,
     comp_cast_type AS cct1,
     comp_cast_type AS cct2,
     cast_info AS ci,
     info_type AS it1,
     info_type AS it2,
     keyword AS k,
     movie_info AS mi,
     movie_info_idx AS mi_idx,
     movie_keyword AS mk,
     name AS n,
     title AS t
WHERE cct1.kind IN ('cast',
                    'crew')
  AND cct2.kind ='complete+verified'
  AND ci.note IN ('(writer)',
                  '(head writer)',
                  '(written by)',
                  '(story)',
                  '(story editor)')
  AND it1.info = 'genres'
  AND it2.info = 'votes'
  AND k.keyword IN ('murder',
                    'violence',
                    'blood',
                    'gore',
                    'death',
                    'female-nudity',
                    'hospital')
  AND mi.info IN ('Horror',
                  'Thriller')
  AND n.gender = 'm'
  AND t.production_year > 2000
  AND t.id = mi.movie_id
  AND t.id = mi_idx.movie_id
  AND t.id = ci.movie_id
  AND t.id = mk.movie_id
  AND t.id = cc.movie_id
  AND ci.movie_id = mi.movie_id
  AND ci.movie_id = mi_idx.movie_id
  AND ci.movie_id = mk.movie_id
  AND ci.movie_id = cc.movie_id
  AND mi.movie_id = mi_idx.movie_id
  AND mi.movie_id = mk.movie_id
  AND mi.movie_id = cc.movie_id
  AND mi_idx.movie_id = mk.movie_id
  AND mi_idx.movie_id = cc.movie_id
  AND mk.movie_id = cc.movie_id
  AND n.id = ci.person_id
  AND it1.id = mi.info_type_id
  AND it2.id = mi_idx.info_type_id
  AND k.id = mk.keyword_id
  AND cct1.id = cc.subject_id
  AND cct2.id = cc.status_id;


/*+ NestLoop(t cc cct2 mi_idx it2 cct1 mk k mi it1 ci n)
 NestLoop(t cc cct2 mi_idx it2 cct1 mk k mi it1 ci)
 MergeJoin(t cc cct2 mi_idx it2 cct1 mk k mi it1)
 NestLoop(t cc cct2 mi_idx it2 cct1 mk k mi)
 NestLoop(t cc cct2 mi_idx it2 cct1 mk k)
 NestLoop(t cc cct2 mi_idx it2 cct1 mk)
 NestLoop(t cc cct2 mi_idx it2 cct1)
 NestLoop(t cc cct2 mi_idx it2)
 NestLoop(t cc cct2 mi_idx)
 NestLoop(t cc cct2)
 NestLoop(t cc)
 SeqScan(t)
 IndexScan(cc)
 SeqScan(cct2)
 IndexScan(mi_idx)
 SeqScan(it2)
 IndexScan(cct1)
 IndexScan(mk)
 IndexScan(k)
 IndexScan(mi)
 IndexScan(it1)
 IndexScan(ci)
 IndexScan(n)
 Leading((((((((((((t cc) cct2) mi_idx) it2) cct1) mk) k) mi) it1) ci) n)) */
SELECT MIN(mi.info) AS movie_budget,
       MIN(mi_idx.info) AS movie_votes,
       MIN(n.name) AS writer,
       MIN(t.title) AS complete_gore_movie
FROM complete_cast AS cc,
     comp_cast_type AS cct1,
     comp_cast_type AS cct2,
     cast_info AS ci,
     info_type AS it1,
     info_type AS it2,
     keyword AS k,
     movie_info AS mi,
     movie_info_idx AS mi_idx,
     movie_keyword AS mk,
     name AS n,
     title AS t
WHERE cct1.kind IN ('cast',
                    'crew')
  AND cct2.kind ='complete+verified'
  AND ci.note IN ('(writer)',
                  '(head writer)',
                  '(written by)',
                  '(story)',
                  '(story editor)')
  AND it1.info = 'genres'
  AND it2.info = 'votes'
  AND k.keyword IN ('murder',
                    'violence',
                    'blood',
                    'gore',
                    'death',
                    'female-nudity',
                    'hospital')
  AND mi.info IN ('Horror',
                  'Thriller')
  AND n.gender = 'm'
  AND t.production_year > 2000
  AND (t.title LIKE '%Freddy%'
       OR t.title LIKE '%Jason%'
       OR t.title LIKE 'Saw%')
  AND t.id = mi.movie_id
  AND t.id = mi_idx.movie_id
  AND t.id = ci.movie_id
  AND t.id = mk.movie_id
  AND t.id = cc.movie_id
  AND ci.movie_id = mi.movie_id
  AND ci.movie_id = mi_idx.movie_id
  AND ci.movie_id = mk.movie_id
  AND ci.movie_id = cc.movie_id
  AND mi.movie_id = mi_idx.movie_id
  AND mi.movie_id = mk.movie_id
  AND mi.movie_id = cc.movie_id
  AND mi_idx.movie_id = mk.movie_id
  AND mi_idx.movie_id = cc.movie_id
  AND mk.movie_id = cc.movie_id
  AND n.id = ci.person_id
  AND it1.id = mi.info_type_id
  AND it2.id = mi_idx.info_type_id
  AND k.id = mk.keyword_id
  AND cct1.id = cc.subject_id
  AND cct2.id = cc.status_id;


/*+ HashJoin(t k mk cc cct1 cct2 mi ci it1 mi_idx n it2)
 NestLoop(t k mk cc cct1 cct2 mi ci it1 mi_idx n)
 NestLoop(t k mk cc cct1 cct2 mi ci it1 mi_idx)
 NestLoop(t k mk cc cct1 cct2 mi ci it1)
 NestLoop(t k mk cc cct1 cct2 mi ci)
 NestLoop(t k mk cc cct1 cct2 mi)
 NestLoop(t k mk cc cct1 cct2)
 NestLoop(t k mk cc cct1)
 NestLoop(t k mk cc)
 HashJoin(t k mk)
 NestLoop(k mk)
 SeqScan(t)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(cc)
 IndexScan(cct1)
 SeqScan(cct2)
 IndexScan(mi)
 IndexScan(ci)
 IndexScan(it1)
 IndexScan(mi_idx)
 IndexScan(n)
 SeqScan(it2)
 Leading(((((((((((t (k mk)) cc) cct1) cct2) mi) ci) it1) mi_idx) n) it2)) */
SELECT MIN(mi.info) AS movie_budget,
       MIN(mi_idx.info) AS movie_votes,
       MIN(n.name) AS writer,
       MIN(t.title) AS complete_violent_movie
FROM complete_cast AS cc,
     comp_cast_type AS cct1,
     comp_cast_type AS cct2,
     cast_info AS ci,
     info_type AS it1,
     info_type AS it2,
     keyword AS k,
     movie_info AS mi,
     movie_info_idx AS mi_idx,
     movie_keyword AS mk,
     name AS n,
     title AS t
WHERE cct1.kind = 'cast'
  AND cct2.kind ='complete+verified'
  AND ci.note IN ('(writer)',
                  '(head writer)',
                  '(written by)',
                  '(story)',
                  '(story editor)')
  AND it1.info = 'genres'
  AND it2.info = 'votes'
  AND k.keyword IN ('murder',
                    'violence',
                    'blood',
                    'gore',
                    'death',
                    'female-nudity',
                    'hospital')
  AND mi.info IN ('Horror',
                  'Action',
                  'Sci-Fi',
                  'Thriller',
                  'Crime',
                  'War')
  AND n.gender = 'm'
  AND t.id = mi.movie_id
  AND t.id = mi_idx.movie_id
  AND t.id = ci.movie_id
  AND t.id = mk.movie_id
  AND t.id = cc.movie_id
  AND ci.movie_id = mi.movie_id
  AND ci.movie_id = mi_idx.movie_id
  AND ci.movie_id = mk.movie_id
  AND ci.movie_id = cc.movie_id
  AND mi.movie_id = mi_idx.movie_id
  AND mi.movie_id = mk.movie_id
  AND mi.movie_id = cc.movie_id
  AND mi_idx.movie_id = mk.movie_id
  AND mi_idx.movie_id = cc.movie_id
  AND mk.movie_id = cc.movie_id
  AND n.id = ci.person_id
  AND it1.id = mi.info_type_id
  AND it2.id = mi_idx.info_type_id
  AND k.id = mk.keyword_id
  AND cct1.id = cc.subject_id
  AND cct2.id = cc.status_id;


/*+ NestLoop(t k mk mc cn mi_idx it2 mi it1 ci n)
 NestLoop(t k mk mc cn mi_idx it2 mi it1 ci)
 HashJoin(t k mk mc cn mi_idx it2 mi it1)
 NestLoop(t k mk mc cn mi_idx it2 mi)
 HashJoin(t k mk mc cn mi_idx it2)
 NestLoop(t k mk mc cn mi_idx)
 HashJoin(t k mk mc cn)
 NestLoop(t k mk mc)
 HashJoin(t k mk)
 NestLoop(k mk)
 SeqScan(t)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(mc)
 SeqScan(cn)
 IndexScan(mi_idx)
 SeqScan(it2)
 IndexScan(mi)
 SeqScan(it1)
 IndexScan(ci)
 IndexScan(n)
 Leading((((((((((t (k mk)) mc) cn) mi_idx) it2) mi) it1) ci) n)) */
SELECT MIN(mi.info) AS movie_budget,
       MIN(mi_idx.info) AS movie_votes,
       MIN(n.name) AS writer,
       MIN(t.title) AS violent_liongate_movie
FROM cast_info AS ci,
     company_name AS cn,
     info_type AS it1,
     info_type AS it2,
     keyword AS k,
     movie_companies AS mc,
     movie_info AS mi,
     movie_info_idx AS mi_idx,
     movie_keyword AS mk,
     name AS n,
     title AS t
WHERE ci.note IN ('(writer)',
                  '(head writer)',
                  '(written by)',
                  '(story)',
                  '(story editor)')
  AND cn.name LIKE 'Lionsgate%'
  AND it1.info = 'genres'
  AND it2.info = 'votes'
  AND k.keyword IN ('murder',
                    'violence',
                    'blood',
                    'gore',
                    'death',
                    'female-nudity',
                    'hospital')
  AND mi.info IN ('Horror',
                  'Thriller')
  AND n.gender = 'm'
  AND t.id = mi.movie_id
  AND t.id = mi_idx.movie_id
  AND t.id = ci.movie_id
  AND t.id = mk.movie_id
  AND t.id = mc.movie_id
  AND ci.movie_id = mi.movie_id
  AND ci.movie_id = mi_idx.movie_id
  AND ci.movie_id = mk.movie_id
  AND ci.movie_id = mc.movie_id
  AND mi.movie_id = mi_idx.movie_id
  AND mi.movie_id = mk.movie_id
  AND mi.movie_id = mc.movie_id
  AND mi_idx.movie_id = mk.movie_id
  AND mi_idx.movie_id = mc.movie_id
  AND mk.movie_id = mc.movie_id
  AND n.id = ci.person_id
  AND it1.id = mi.info_type_id
  AND it2.id = mi_idx.info_type_id
  AND k.id = mk.keyword_id
  AND cn.id = mc.company_id;


/*+ NestLoop(t mk k mi_idx it2 mi it1 mc cn ci n)
 NestLoop(t mk k mi_idx it2 mi it1 mc cn ci)
 NestLoop(t mk k mi_idx it2 mi it1 mc cn)
 NestLoop(t mk k mi_idx it2 mi it1 mc)
 NestLoop(t mk k mi_idx it2 mi it1)
 NestLoop(t mk k mi_idx it2 mi)
 HashJoin(t mk k mi_idx it2)
 NestLoop(t mk k mi_idx)
 NestLoop(t mk k)
 NestLoop(t mk)
 SeqScan(t)
 IndexScan(mk)
 IndexScan(k)
 IndexScan(mi_idx)
 SeqScan(it2)
 IndexScan(mi)
 IndexScan(it1)
 IndexScan(mc)
 IndexScan(cn)
 IndexScan(ci)
 IndexScan(n)
 Leading(((((((((((t mk) k) mi_idx) it2) mi) it1) mc) cn) ci) n)) */
SELECT MIN(mi.info) AS movie_budget,
       MIN(mi_idx.info) AS movie_votes,
       MIN(n.name) AS writer,
       MIN(t.title) AS violent_liongate_movie
FROM cast_info AS ci,
     company_name AS cn,
     info_type AS it1,
     info_type AS it2,
     keyword AS k,
     movie_companies AS mc,
     movie_info AS mi,
     movie_info_idx AS mi_idx,
     movie_keyword AS mk,
     name AS n,
     title AS t
WHERE ci.note IN ('(writer)',
                  '(head writer)',
                  '(written by)',
                  '(story)',
                  '(story editor)')
  AND cn.name LIKE 'Lionsgate%'
  AND it1.info = 'genres'
  AND it2.info = 'votes'
  AND k.keyword IN ('murder',
                    'violence',
                    'blood',
                    'gore',
                    'death',
                    'female-nudity',
                    'hospital')
  AND mc.note LIKE '%(Blu-ray)%'
  AND mi.info IN ('Horror',
                  'Thriller')
  AND n.gender = 'm'
  AND t.production_year > 2000
  AND (t.title LIKE '%Freddy%'
       OR t.title LIKE '%Jason%'
       OR t.title LIKE 'Saw%')
  AND t.id = mi.movie_id
  AND t.id = mi_idx.movie_id
  AND t.id = ci.movie_id
  AND t.id = mk.movie_id
  AND t.id = mc.movie_id
  AND ci.movie_id = mi.movie_id
  AND ci.movie_id = mi_idx.movie_id
  AND ci.movie_id = mk.movie_id
  AND ci.movie_id = mc.movie_id
  AND mi.movie_id = mi_idx.movie_id
  AND mi.movie_id = mk.movie_id
  AND mi.movie_id = mc.movie_id
  AND mi_idx.movie_id = mk.movie_id
  AND mi_idx.movie_id = mc.movie_id
  AND mk.movie_id = mc.movie_id
  AND n.id = ci.person_id
  AND it1.id = mi.info_type_id
  AND it2.id = mi_idx.info_type_id
  AND k.id = mk.keyword_id
  AND cn.id = mc.company_id;


/*+ MergeJoin(t k mk mc cn ci n mi_idx it2 mi it1)
 NestLoop(t k mk mc cn ci n mi_idx it2 mi)
 HashJoin(t k mk mc cn ci n mi_idx it2)
 NestLoop(t k mk mc cn ci n mi_idx)
 NestLoop(t k mk mc cn ci n)
 NestLoop(t k mk mc cn ci)
 HashJoin(t k mk mc cn)
 NestLoop(t k mk mc)
 HashJoin(t k mk)
 NestLoop(k mk)
 SeqScan(t)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(mc)
 SeqScan(cn)
 IndexScan(ci)
 IndexScan(n)
 IndexScan(mi_idx)
 SeqScan(it2)
 IndexScan(mi)
 IndexScan(it1)
 Leading((((((((((t (k mk)) mc) cn) ci) n) mi_idx) it2) mi) it1)) */
SELECT MIN(mi.info) AS movie_budget,
       MIN(mi_idx.info) AS movie_votes,
       MIN(n.name) AS writer,
       MIN(t.title) AS violent_liongate_movie
FROM cast_info AS ci,
     company_name AS cn,
     info_type AS it1,
     info_type AS it2,
     keyword AS k,
     movie_companies AS mc,
     movie_info AS mi,
     movie_info_idx AS mi_idx,
     movie_keyword AS mk,
     name AS n,
     title AS t
WHERE ci.note IN ('(writer)',
                  '(head writer)',
                  '(written by)',
                  '(story)',
                  '(story editor)')
  AND cn.name LIKE 'Lionsgate%'
  AND it1.info = 'genres'
  AND it2.info = 'votes'
  AND k.keyword IN ('murder',
                    'violence',
                    'blood',
                    'gore',
                    'death',
                    'female-nudity',
                    'hospital')
  AND mi.info IN ('Horror',
                  'Action',
                  'Sci-Fi',
                  'Thriller',
                  'Crime',
                  'War')
  AND t.id = mi.movie_id
  AND t.id = mi_idx.movie_id
  AND t.id = ci.movie_id
  AND t.id = mk.movie_id
  AND t.id = mc.movie_id
  AND ci.movie_id = mi.movie_id
  AND ci.movie_id = mi_idx.movie_id
  AND ci.movie_id = mk.movie_id
  AND ci.movie_id = mc.movie_id
  AND mi.movie_id = mi_idx.movie_id
  AND mi.movie_id = mk.movie_id
  AND mi.movie_id = mc.movie_id
  AND mi_idx.movie_id = mk.movie_id
  AND mi_idx.movie_id = mc.movie_id
  AND mk.movie_id = mc.movie_id
  AND n.id = ci.person_id
  AND it1.id = mi.info_type_id
  AND it2.id = mi_idx.info_type_id
  AND k.id = mk.keyword_id
  AND cn.id = mc.company_id;


/*+ NestLoop(k mk t1 ml t2 lt)
 NestLoop(k mk t1 ml t2)
 NestLoop(k mk t1 ml)
 NestLoop(k mk t1)
 NestLoop(k mk)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(t1)
 IndexScan(ml)
 IndexScan(t2)
 SeqScan(lt)
 Leading((((((k mk) t1) ml) t2) lt)) */
SELECT MIN(lt.link) AS link_type,
       MIN(t1.title) AS first_movie,
       MIN(t2.title) AS second_movie
FROM keyword AS k,
     link_type AS lt,
     movie_keyword AS mk,
     movie_link AS ml,
     title AS t1,
     title AS t2
WHERE k.keyword ='10,000-mile-club'
  AND mk.keyword_id = k.id
  AND t1.id = mk.movie_id
  AND ml.movie_id = t1.id
  AND ml.linked_movie_id = t2.id
  AND lt.id = ml.link_type_id
  AND mk.movie_id = t1.id;


/*+ HashJoin(k mk t1 ml t2 lt)
 NestLoop(k mk t1 ml t2)
 NestLoop(k mk t1 ml)
 NestLoop(k mk t1)
 NestLoop(k mk)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(t1)
 IndexScan(ml)
 IndexScan(t2)
 SeqScan(lt)
 Leading((((((k mk) t1) ml) t2) lt)) */
SELECT MIN(lt.link) AS link_type,
       MIN(t1.title) AS first_movie,
       MIN(t2.title) AS second_movie
FROM keyword AS k,
     link_type AS lt,
     movie_keyword AS mk,
     movie_link AS ml,
     title AS t1,
     title AS t2
WHERE k.keyword ='character-name-in-title'
  AND mk.keyword_id = k.id
  AND t1.id = mk.movie_id
  AND ml.movie_id = t1.id
  AND ml.linked_movie_id = t2.id
  AND lt.id = ml.link_type_id
  AND mk.movie_id = t1.id;


/*+ NestLoop(ml t1 lt kt1 mii2 it2 mii1 it1 mc1 cn1 mc2 t2 kt2 cn2)
 NestLoop(ml t1 lt kt1 mii2 it2 mii1 it1 mc1 cn1 mc2 t2 kt2)
 NestLoop(ml t1 lt kt1 mii2 it2 mii1 it1 mc1 cn1 mc2 t2)
 NestLoop(ml t1 lt kt1 mii2 it2 mii1 it1 mc1 cn1 mc2)
 MergeJoin(ml t1 lt kt1 mii2 it2 mii1 it1 mc1 cn1)
 NestLoop(ml t1 lt kt1 mii2 it2 mii1 it1 mc1)
 NestLoop(ml t1 lt kt1 mii2 it2 mii1 it1)
 NestLoop(ml t1 lt kt1 mii2 it2 mii1)
 NestLoop(ml t1 lt kt1 mii2 it2)
 NestLoop(ml t1 lt kt1 mii2)
 NestLoop(ml t1 lt kt1)
 NestLoop(ml t1 lt)
 NestLoop(ml t1)
 SeqScan(ml)
 IndexScan(t1)
 IndexScan(lt)
 IndexScan(kt1)
 IndexScan(mii2)
 SeqScan(it2)
 IndexScan(mii1)
 IndexScan(it1)
 IndexScan(mc1)
 SeqScan(cn1)
 IndexScan(mc2)
 IndexScan(t2)
 IndexScan(kt2)
 IndexScan(cn2)
 Leading((((((((((((((ml t1) lt) kt1) mii2) it2) mii1) it1) mc1) cn1) mc2) t2) kt2) cn2)) */
SELECT MIN(cn1.name) AS first_company,
       MIN(cn2.name) AS second_company,
       MIN(mii1.info) AS first_rating,
       MIN(mii2.info) AS second_rating,
       MIN(t1.title) AS first_movie,
       MIN(t2.title) AS second_movie
FROM company_name AS cn1,
     company_name AS cn2,
     info_type AS it1,
     info_type AS it2,
     kind_type AS kt1,
     kind_type AS kt2,
     link_type AS lt,
     movie_companies AS mc1,
     movie_companies AS mc2,
     movie_info_idx AS mii1,
     movie_info_idx AS mii2,
     movie_link AS ml,
     title AS t1,
     title AS t2
WHERE cn1.country_code = '[nl]'
  AND it1.info = 'rating'
  AND it2.info = 'rating'
  AND kt1.kind IN ('tv series')
  AND kt2.kind IN ('tv series')
  AND lt.link LIKE '%follow%'
  AND mii2.info < '3.0'
  AND t2.production_year = 2007
  AND lt.id = ml.link_type_id
  AND t1.id = ml.movie_id
  AND t2.id = ml.linked_movie_id
  AND it1.id = mii1.info_type_id
  AND t1.id = mii1.movie_id
  AND kt1.id = t1.kind_id
  AND cn1.id = mc1.company_id
  AND t1.id = mc1.movie_id
  AND ml.movie_id = mii1.movie_id
  AND ml.movie_id = mc1.movie_id
  AND mii1.movie_id = mc1.movie_id
  AND it2.id = mii2.info_type_id
  AND t2.id = mii2.movie_id
  AND kt2.id = t2.kind_id
  AND cn2.id = mc2.company_id
  AND t2.id = mc2.movie_id
  AND ml.linked_movie_id = mii2.movie_id
  AND ml.linked_movie_id = mc2.movie_id
  AND mii2.movie_id = mc2.movie_id;


/*+ NestLoop(t k mk mi)
 HashJoin(t k mk)
 NestLoop(k mk)
 SeqScan(t)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(mi)
 Leading(((t (k mk)) mi)) */
SELECT MIN(t.title) AS movie_title
FROM keyword AS k,
     movie_info AS mi,
     movie_keyword AS mk,
     title AS t
WHERE k.keyword LIKE '%sequel%'
  AND mi.info IN ('Sweden',
                  'Norway',
                  'Germany',
                  'Denmark',
                  'Swedish',
                  'Denish',
                  'Norwegian',
                  'German',
                  'USA',
                  'American')
  AND t.production_year > 1990
  AND t.id = mi.movie_id
  AND t.id = mk.movie_id
  AND mk.movie_id = mi.movie_id
  AND k.id = mk.keyword_id;


/*+ HashJoin(k mk t mi_idx it)
 NestLoop(k mk t mi_idx)
 NestLoop(k mk t)
 NestLoop(k mk)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(t)
 IndexScan(mi_idx)
 IndexScan(it)
 Leading(((((k mk) t) mi_idx) it)) */
SELECT MIN(mi_idx.info) AS rating,
       MIN(t.title) AS movie_title
FROM info_type AS it,
     keyword AS k,
     movie_info_idx AS mi_idx,
     movie_keyword AS mk,
     title AS t
WHERE it.info ='rating'
  AND k.keyword LIKE '%sequel%'
  AND mi_idx.info > '5.0'
  AND t.production_year > 2005
  AND t.id = mi_idx.movie_id
  AND t.id = mk.movie_id
  AND mk.movie_id = mi_idx.movie_id
  AND k.id = mk.keyword_id
  AND it.id = mi_idx.info_type_id;


/*+ MergeJoin(k mk t mi_idx it)
 NestLoop(k mk t mi_idx)
 NestLoop(k mk t)
 NestLoop(k mk)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(t)
 IndexScan(mi_idx)
 IndexScan(it)
 Leading(((((k mk) t) mi_idx) it)) */
SELECT MIN(mi_idx.info) AS rating,
       MIN(t.title) AS movie_title
FROM info_type AS it,
     keyword AS k,
     movie_info_idx AS mi_idx,
     movie_keyword AS mk,
     title AS t
WHERE it.info ='rating'
  AND k.keyword LIKE '%sequel%'
  AND mi_idx.info > '9.0'
  AND t.production_year > 2010
  AND t.id = mi_idx.movie_id
  AND t.id = mk.movie_id
  AND mk.movie_id = mi_idx.movie_id
  AND k.id = mk.keyword_id
  AND it.id = mi_idx.info_type_id;


/*+ HashJoin(k mk t mi_idx it)
 NestLoop(k mk t mi_idx)
 NestLoop(k mk t)
 NestLoop(k mk)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(t)
 IndexScan(mi_idx)
 SeqScan(it)
 Leading(((((k mk) t) mi_idx) it)) */
SELECT MIN(mi_idx.info) AS rating,
       MIN(t.title) AS movie_title
FROM info_type AS it,
     keyword AS k,
     movie_info_idx AS mi_idx,
     movie_keyword AS mk,
     title AS t
WHERE it.info ='rating'
  AND k.keyword LIKE '%sequel%'
  AND mi_idx.info > '2.0'
  AND t.production_year > 1990
  AND t.id = mi_idx.movie_id
  AND t.id = mk.movie_id
  AND mk.movie_id = mi_idx.movie_id
  AND k.id = mk.keyword_id
  AND it.id = mi_idx.info_type_id;


/*+ HashJoin(mc ct t mi it)
 NestLoop(mc ct t mi)
 NestLoop(mc ct t)
 NestLoop(mc ct)
 IndexScan(mc)
 IndexScan(ct)
 IndexScan(t)
 IndexScan(mi)
 SeqScan(it)
 Leading(((((mc ct) t) mi) it)) */
SELECT MIN(t.title) AS typical_european_movie
FROM company_type AS ct,
     info_type AS it,
     movie_companies AS mc,
     movie_info AS mi,
     title AS t
WHERE ct.kind = 'production companies'
  AND mc.note LIKE '%(theatrical)%'
  AND mc.note LIKE '%(France)%'
  AND mi.info IN ('Sweden',
                  'Norway',
                  'Germany',
                  'Denmark',
                  'Swedish',
                  'Denish',
                  'Norwegian',
                  'German')
  AND t.production_year > 2005
  AND t.id = mi.movie_id
  AND t.id = mc.movie_id
  AND mc.movie_id = mi.movie_id
  AND ct.id = mc.company_type_id
  AND it.id = mi.info_type_id;


/*+ MergeJoin(mc ct mi t it)
 NestLoop(mc ct mi t)
 NestLoop(mc ct mi)
 NestLoop(mc ct)
 IndexScan(mc)
 IndexScan(ct)
 IndexScan(mi)
 IndexScan(t)
 IndexScan(it)
 Leading(((((mc ct) mi) t) it)) */
SELECT MIN(t.title) AS american_vhs_movie
FROM company_type AS ct,
     info_type AS it,
     movie_companies AS mc,
     movie_info AS mi,
     title AS t
WHERE ct.kind = 'production companies'
  AND mc.note LIKE '%(VHS)%'
  AND mc.note LIKE '%(USA)%'
  AND mc.note LIKE '%(1994)%'
  AND mi.info IN ('USA',
                  'America')
  AND t.production_year > 2010
  AND t.id = mi.movie_id
  AND t.id = mc.movie_id
  AND mc.movie_id = mi.movie_id
  AND ct.id = mc.company_type_id
  AND it.id = mi.info_type_id;


/*+ MergeJoin(mc ct t mi it)
 NestLoop(mc ct t mi)
 NestLoop(mc ct t)
 NestLoop(mc ct)
 IndexScan(mc)
 SeqScan(ct)
 IndexScan(t)
 IndexScan(mi)
 IndexScan(it)
 Leading(((((mc ct) t) mi) it)) */
SELECT MIN(t.title) AS american_movie
FROM company_type AS ct,
     info_type AS it,
     movie_companies AS mc,
     movie_info AS mi,
     title AS t
WHERE ct.kind = 'production companies'
  AND mc.note NOT LIKE '%(TV)%'
  AND mc.note LIKE '%(USA)%'
  AND mi.info IN ('Sweden',
                  'Norway',
                  'Germany',
                  'Denmark',
                  'Swedish',
                  'Denish',
                  'Norwegian',
                  'German',
                  'USA',
                  'American')
  AND t.production_year > 1990
  AND t.id = mi.movie_id
  AND t.id = mc.movie_id
  AND mc.movie_id = mi.movie_id
  AND ct.id = mc.company_type_id
  AND it.id = mi.info_type_id;


/*+ NestLoop(k mk ci n t)
 NestLoop(k mk ci n)
 NestLoop(k mk ci)
 NestLoop(k mk)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(ci)
 IndexScan(n)
 IndexScan(t)
 Leading(((((k mk) ci) n) t)) */
SELECT MIN(k.keyword) AS movie_keyword,
       MIN(n.name) AS actor_name,
       MIN(t.title) AS marvel_movie
FROM cast_info AS ci,
     keyword AS k,
     movie_keyword AS mk,
     name AS n,
     title AS t
WHERE k.keyword = 'marvel-cinematic-universe'
  AND n.name LIKE '%Downey%Robert%'
  AND t.production_year > 2010
  AND k.id = mk.keyword_id
  AND t.id = mk.movie_id
  AND t.id = ci.movie_id
  AND ci.movie_id = mk.movie_id
  AND n.id = ci.person_id;


/*+ NestLoop(t mk k ci n)
 NestLoop(t mk k ci)
 NestLoop(t mk k)
 NestLoop(t mk)
 SeqScan(t)
 IndexScan(mk)
 IndexScan(k)
 IndexScan(ci)
 IndexScan(n)
 Leading(((((t mk) k) ci) n)) */
SELECT MIN(k.keyword) AS movie_keyword,
       MIN(n.name) AS actor_name,
       MIN(t.title) AS hero_movie
FROM cast_info AS ci,
     keyword AS k,
     movie_keyword AS mk,
     name AS n,
     title AS t
WHERE k.keyword IN ('superhero',
                    'sequel',
                    'second-part',
                    'marvel-comics',
                    'based-on-comic',
                    'tv-special',
                    'fight',
                    'violence')
  AND n.name LIKE '%Downey%Robert%'
  AND t.production_year > 2014
  AND k.id = mk.keyword_id
  AND t.id = mk.movie_id
  AND t.id = ci.movie_id
  AND ci.movie_id = mk.movie_id
  AND n.id = ci.person_id;


/*+ NestLoop(n ci t mk k)
 NestLoop(n ci t mk)
 NestLoop(n ci t)
 NestLoop(n ci)
 IndexScan(n)
 IndexScan(ci)
 IndexScan(t)
 IndexScan(mk)
 IndexScan(k)
 Leading(((((n ci) t) mk) k)) */
SELECT MIN(k.keyword) AS movie_keyword,
       MIN(n.name) AS actor_name,
       MIN(t.title) AS hero_movie
FROM cast_info AS ci,
     keyword AS k,
     movie_keyword AS mk,
     name AS n,
     title AS t
WHERE k.keyword IN ('superhero',
                    'sequel',
                    'second-part',
                    'marvel-comics',
                    'based-on-comic',
                    'tv-special',
                    'fight',
                    'violence')
  AND n.name LIKE '%Downey%Robert%'
  AND t.production_year > 2000
  AND k.id = mk.keyword_id
  AND t.id = mk.movie_id
  AND t.id = ci.movie_id
  AND ci.movie_id = mk.movie_id
  AND n.id = ci.person_id;


/*+ NestLoop(k mk t ci n)
 NestLoop(k mk t ci)
 NestLoop(k mk t)
 NestLoop(k mk)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(t)
 IndexScan(ci)
 IndexScan(n)
 Leading(((((k mk) t) ci) n)) */
SELECT MIN(k.keyword) AS movie_keyword,
       MIN(n.name) AS actor_name,
       MIN(t.title) AS marvel_movie
FROM cast_info AS ci,
     keyword AS k,
     movie_keyword AS mk,
     name AS n,
     title AS t
WHERE k.keyword = 'marvel-cinematic-universe'
  AND n.name LIKE '%Downey%Robert%'
  AND t.production_year > 2000
  AND k.id = mk.keyword_id
  AND t.id = mk.movie_id
  AND t.id = ci.movie_id
  AND ci.movie_id = mk.movie_id
  AND n.id = ci.person_id;


/*+ NestLoop(t k mk ci n)
 NestLoop(t k mk ci)
 HashJoin(t k mk)
 NestLoop(k mk)
 SeqScan(t)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(ci)
 IndexScan(n)
 Leading((((t (k mk)) ci) n)) */
SELECT MIN(k.keyword) AS movie_keyword,
       MIN(n.name) AS actor_name,
       MIN(t.title) AS hero_movie
FROM cast_info AS ci,
     keyword AS k,
     movie_keyword AS mk,
     name AS n,
     title AS t
WHERE k.keyword IN ('superhero',
                    'sequel',
                    'second-part',
                    'marvel-comics',
                    'based-on-comic',
                    'tv-special',
                    'fight',
                    'violence')
  AND t.production_year > 2000
  AND k.id = mk.keyword_id
  AND t.id = mk.movie_id
  AND t.id = ci.movie_id
  AND ci.movie_id = mk.movie_id
  AND n.id = ci.person_id;


/*+ HashJoin(t ml lt ci n pi1 an it)
 NestLoop(t ml lt ci n pi1 an)
 NestLoop(t ml lt ci n pi1)
 NestLoop(t ml lt ci n)
 NestLoop(t ml lt ci)
 NestLoop(t ml lt)
 NestLoop(t ml)
 SeqScan(t)
 IndexScan(ml)
 IndexScan(lt)
 IndexScan(ci)
 IndexScan(n)
 IndexScan(pi1)
 IndexScan(an)
 SeqScan(it)
 Leading((((((((t ml) lt) ci) n) pi1) an) it)) */
SELECT MIN(n.name) AS of_person,
       MIN(t.title) AS biography_movie
FROM aka_name AS an,
     cast_info AS ci,
     info_type AS it,
     link_type AS lt,
     movie_link AS ml,
     name AS n,
     person_info AS pi1,
     title AS t
WHERE an.name LIKE '%a%'
  AND it.info ='mini biography'
  AND lt.link ='features'
  AND n.name_pcode_cf BETWEEN 'A' AND 'F'
  AND (n.gender='m'
       OR (n.gender = 'f'
           AND n.name LIKE 'B%'))
  AND pi1.note ='Volker Boehm'
  AND t.production_year BETWEEN 1980 AND 1995
  AND n.id = an.person_id
  AND n.id = pi1.person_id
  AND ci.person_id = n.id
  AND t.id = ci.movie_id
  AND ml.linked_movie_id = t.id
  AND lt.id = ml.link_type_id
  AND it.id = pi1.info_type_id
  AND pi1.person_id = an.person_id
  AND pi1.person_id = ci.person_id
  AND an.person_id = ci.person_id
  AND ci.movie_id = ml.linked_movie_id;


/*+ NestLoop(t ml lt ci n pi1 an it)
 NestLoop(t ml lt ci n pi1 an)
 NestLoop(t ml lt ci n pi1)
 NestLoop(t ml lt ci n)
 NestLoop(t ml lt ci)
 NestLoop(t ml lt)
 NestLoop(t ml)
 SeqScan(t)
 IndexScan(ml)
 IndexScan(lt)
 IndexScan(ci)
 IndexScan(n)
 IndexScan(pi1)
 IndexScan(an)
 IndexScan(it)
 Leading((((((((t ml) lt) ci) n) pi1) an) it)) */
SELECT MIN(n.name) AS of_person,
       MIN(t.title) AS biography_movie
FROM aka_name AS an,
     cast_info AS ci,
     info_type AS it,
     link_type AS lt,
     movie_link AS ml,
     name AS n,
     person_info AS pi1,
     title AS t
WHERE an.name LIKE '%a%'
  AND it.info ='mini biography'
  AND lt.link ='features'
  AND n.name_pcode_cf LIKE 'D%'
  AND n.gender='m'
  AND pi1.note ='Volker Boehm'
  AND t.production_year BETWEEN 1980 AND 1984
  AND n.id = an.person_id
  AND n.id = pi1.person_id
  AND ci.person_id = n.id
  AND t.id = ci.movie_id
  AND ml.linked_movie_id = t.id
  AND lt.id = ml.link_type_id
  AND it.id = pi1.info_type_id
  AND pi1.person_id = an.person_id
  AND pi1.person_id = ci.person_id
  AND an.person_id = ci.person_id
  AND ci.movie_id = ml.linked_movie_id;


/*+ NestLoop(n it pi1 ci ml t lt an)
 HashJoin(n it pi1 ci ml t lt)
 NestLoop(n it pi1 ci ml t)
 HashJoin(n it pi1 ci ml)
 NestLoop(n it pi1 ci)
 HashJoin(n it pi1)
 NestLoop(it pi1)
 IndexScan(n)
 IndexScan(it)
 IndexScan(pi1)
 IndexScan(ci)
 IndexScan(ml)
 IndexScan(t)
 IndexScan(lt)
 IndexScan(an)
 Leading(((((((n (it pi1)) ci) ml) t) lt) an)) */
SELECT MIN(n.name) AS cast_member_name,
       MIN(pi1.info) AS cast_member_info
FROM aka_name AS an,
     cast_info AS ci,
     info_type AS it,
     link_type AS lt,
     movie_link AS ml,
     name AS n,
     person_info AS pi1,
     title AS t
WHERE an.name IS NOT NULL
  AND (an.name LIKE '%a%'
       OR an.name LIKE 'A%')
  AND it.info ='mini biography'
  AND lt.link IN ('references',
                  'referenced in',
                  'features',
                  'featured in')
  AND n.name_pcode_cf BETWEEN 'A' AND 'F'
  AND (n.gender='m'
       OR (n.gender = 'f'
           AND n.name LIKE 'A%'))
  AND pi1.note IS NOT NULL
  AND t.production_year BETWEEN 1980 AND 2010
  AND n.id = an.person_id
  AND n.id = pi1.person_id
  AND ci.person_id = n.id
  AND t.id = ci.movie_id
  AND ml.linked_movie_id = t.id
  AND lt.id = ml.link_type_id
  AND it.id = pi1.info_type_id
  AND pi1.person_id = an.person_id
  AND pi1.person_id = ci.person_id
  AND an.person_id = ci.person_id
  AND ci.movie_id = ml.linked_movie_id;


/*+ NestLoop(n ci rt mc an t cn)
 NestLoop(n ci rt mc an t)
 NestLoop(n ci rt mc an)
 NestLoop(n ci rt mc)
 NestLoop(n ci rt)
 NestLoop(n ci)
 IndexScan(n)
 IndexScan(ci)
 IndexScan(rt)
 IndexScan(mc)
 IndexScan(an)
 IndexScan(t)
 IndexScan(cn)
 Leading(((((((n ci) rt) mc) an) t) cn)) */
SELECT MIN(an.name) AS actress_pseudonym,
       MIN(t.title) AS japanese_movie_dubbed
FROM aka_name AS an,
     cast_info AS ci,
     company_name AS cn,
     movie_companies AS mc,
     name AS n,
     role_type AS rt,
     title AS t
WHERE ci.note ='(voice: English version)'
  AND cn.country_code ='[jp]'
  AND mc.note LIKE '%(Japan)%'
  AND mc.note NOT LIKE '%(USA)%'
  AND n.name LIKE '%Yo%'
  AND n.name NOT LIKE '%Yu%'
  AND rt.role ='actress'
  AND an.person_id = n.id
  AND n.id = ci.person_id
  AND ci.movie_id = t.id
  AND t.id = mc.movie_id
  AND mc.company_id = cn.id
  AND ci.role_id = rt.id
  AND an.person_id = ci.person_id
  AND ci.movie_id = mc.movie_id;


/*+ HashJoin(t rt ci n an mc cn)
 NestLoop(t rt ci n an mc)
 HashJoin(t rt ci n an)
 NestLoop(t rt ci n)
 HashJoin(t rt ci)
 NestLoop(rt ci)
 IndexScan(t)
 IndexScan(rt)
 IndexScan(ci)
 IndexScan(n)
 IndexScan(an)
 IndexScan(mc)
 IndexScan(cn)
 Leading((((((t (rt ci)) n) an) mc) cn)) */
SELECT MIN(an.name) AS writer_pseudo_name,
       MIN(t.title) AS movie_title
FROM aka_name AS an,
     cast_info AS ci,
     company_name AS cn,
     movie_companies AS mc,
     name AS n,
     role_type AS rt,
     title AS t
WHERE cn.country_code ='[us]'
  AND rt.role ='writer'
  AND an.person_id = n.id
  AND n.id = ci.person_id
  AND ci.movie_id = t.id
  AND t.id = mc.movie_id
  AND mc.company_id = cn.id
  AND ci.role_id = rt.id
  AND an.person_id = ci.person_id
  AND ci.movie_id = mc.movie_id;


/*+ HashJoin(t rt ci an n mc cn)
 NestLoop(t rt ci an n mc)
 NestLoop(t rt ci an n)
 NestLoop(t rt ci an)
 HashJoin(t rt ci)
 NestLoop(rt ci)
 SeqScan(t)
 IndexScan(rt)
 IndexScan(ci)
 IndexScan(an)
 IndexScan(n)
 IndexScan(mc)
 SeqScan(cn)
 Leading((((((t (rt ci)) an) n) mc) cn)) */
SELECT MIN(an.name) AS costume_designer_pseudo,
       MIN(t.title) AS movie_with_costumes
FROM aka_name AS an,
     cast_info AS ci,
     company_name AS cn,
     movie_companies AS mc,
     name AS n,
     role_type AS rt,
     title AS t
WHERE cn.country_code ='[us]'
  AND rt.role ='costume designer'
  AND an.person_id = n.id
  AND n.id = ci.person_id
  AND ci.movie_id = t.id
  AND t.id = mc.movie_id
  AND mc.company_id = cn.id
  AND ci.role_id = rt.id
  AND an.person_id = ci.person_id
  AND ci.movie_id = mc.movie_id;


/*+ NestLoop(n an ci chn rt mc cn t)
 NestLoop(n an ci chn rt mc cn)
 NestLoop(n an ci chn rt mc)
 NestLoop(n an ci chn rt)
 NestLoop(n an ci chn)
 NestLoop(n an ci)
 NestLoop(n an)
 IndexScan(n)
 IndexScan(an)
 IndexScan(ci)
 IndexScan(chn)
 SeqScan(rt)
 IndexScan(mc)
 IndexScan(cn)
 IndexScan(t)
 Leading((((((((n an) ci) chn) rt) mc) cn) t)) */
SELECT MIN(an.name) AS alternative_name,
       MIN(chn.name) AS character_name,
       MIN(t.title) AS movie
FROM aka_name AS an,
     char_name AS chn,
     cast_info AS ci,
     company_name AS cn,
     movie_companies AS mc,
     name AS n,
     role_type AS rt,
     title AS t
WHERE ci.note IN ('(voice)',
                  '(voice: Japanese version)',
                  '(voice) (uncredited)',
                  '(voice: English version)')
  AND cn.country_code ='[us]'
  AND mc.note IS NOT NULL
  AND (mc.note LIKE '%(USA)%'
       OR mc.note LIKE '%(worldwide)%')
  AND n.gender ='f'
  AND n.name LIKE '%Ang%'
  AND rt.role ='actress'
  AND t.production_year BETWEEN 2005 AND 2015
  AND ci.movie_id = t.id
  AND t.id = mc.movie_id
  AND ci.movie_id = mc.movie_id
  AND mc.company_id = cn.id
  AND ci.role_id = rt.id
  AND n.id = ci.person_id
  AND chn.id = ci.person_role_id
  AND an.person_id = n.id
  AND an.person_id = ci.person_id;


/*+ NestLoop(n an ci t chn mc rt cn)
 HashJoin(n an ci t chn mc rt)
 NestLoop(n an ci t chn mc)
 NestLoop(n an ci t chn)
 NestLoop(n an ci t)
 NestLoop(n an ci)
 NestLoop(n an)
 IndexScan(n)
 IndexScan(an)
 IndexScan(ci)
 IndexScan(t)
 IndexScan(chn)
 IndexScan(mc)
 IndexScan(rt)
 IndexScan(cn)
 Leading((((((((n an) ci) t) chn) mc) rt) cn)) */
SELECT MIN(an.name) AS alternative_name,
       MIN(chn.name) AS voiced_character,
       MIN(n.name) AS voicing_actress,
       MIN(t.title) AS american_movie
FROM aka_name AS an,
     char_name AS chn,
     cast_info AS ci,
     company_name AS cn,
     movie_companies AS mc,
     name AS n,
     role_type AS rt,
     title AS t
WHERE ci.note = '(voice)'
  AND cn.country_code ='[us]'
  AND mc.note LIKE '%(200%)%'
  AND (mc.note LIKE '%(USA)%'
       OR mc.note LIKE '%(worldwide)%')
  AND n.gender ='f'
  AND n.name LIKE '%Angel%'
  AND rt.role ='actress'
  AND t.production_year BETWEEN 2007 AND 2010
  AND ci.movie_id = t.id
  AND t.id = mc.movie_id
  AND ci.movie_id = mc.movie_id
  AND mc.company_id = cn.id
  AND ci.role_id = rt.id
  AND n.id = ci.person_id
  AND chn.id = ci.person_role_id
  AND an.person_id = n.id
  AND an.person_id = ci.person_id;