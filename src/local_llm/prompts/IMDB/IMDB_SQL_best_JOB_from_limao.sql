/*+ NestLoop(mi it1 mk k mi_idx mc cn ci it2 t n)
 HashJoin(mi it1 mk k mi_idx mc cn ci it2 t)
 NestLoop(mi it1 mk k mi_idx mc cn ci it2)
 NestLoop(mi it1 mk k mi_idx mc cn ci)
 HashJoin(mi it1 mk k mi_idx mc cn)
 HashJoin(mi it1 mk k mi_idx mc)
 HashJoin(mi it1 mk k mi_idx)
 HashJoin(mi it1 mk k)
 HashJoin(mi it1 mk)
 NestLoop(mi it1)
 IndexScan(mi)
 IndexScan(it1)
 SeqScan(mk)
 SeqScan(k)
 SeqScan(mi_idx)
 SeqScan(mc)
 IndexScan(cn)
 IndexScan(ci)
 IndexScan(it2)
 SeqScan(t)
 IndexScan(n)
 Leading(((((((((((mi it1) mk) k) mi_idx) mc) cn) ci) it2) t) n)) */
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


/*+ MergeJoin(mk k mi_idx mc cn t ci mi it1 n it2)
 NestLoop(mk k mi_idx mc cn t ci mi it1 n)
 MergeJoin(mk k mi_idx mc cn t ci mi it1)
 MergeJoin(mk k mi_idx mc cn t ci mi)
 NestLoop(mk k mi_idx mc cn t ci)
 HashJoin(mk k mi_idx mc cn t)
 NestLoop(mk k mi_idx mc cn)
 HashJoin(mk k mi_idx mc)
 HashJoin(mk k mi_idx)
 HashJoin(mk k)
 SeqScan(mk)
 SeqScan(k)
 SeqScan(mi_idx)
 SeqScan(mc)
 IndexScan(cn)
 SeqScan(t)
 IndexScan(ci)
 SeqScan(mi)
 SeqScan(it1)
 IndexScan(n)
 SeqScan(it2)
 Leading(((((((((((mk k) mi_idx) mc) cn) t) ci) mi) it1) n) it2)) */
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


/*+ NestLoop(mk k mi it1 mc cn mi_idx it2 t ci n)
 NestLoop(mk k mi it1 mc cn mi_idx it2 t ci)
 NestLoop(mk k mi it1 mc cn mi_idx it2 t)
 NestLoop(mk k mi it1 mc cn mi_idx it2)
 NestLoop(mk k mi it1 mc cn mi_idx)
 NestLoop(mk k mi it1 mc cn)
 HashJoin(mk k mi it1 mc)
 NestLoop(mk k mi it1)
 NestLoop(mk k mi)
 HashJoin(mk k)
 SeqScan(mk)
 SeqScan(k)
 IndexScan(mi)
 IndexScan(it1)
 SeqScan(mc)
 IndexScan(cn)
 IndexScan(mi_idx)
 IndexScan(it2)
 IndexScan(t)
 IndexScan(ci)
 IndexScan(n)
 Leading(((((((((((mk k) mi) it1) mc) cn) mi_idx) it2) t) ci) n)) */
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


/*+ HashJoin(t1 lt ml mk t2 k)
 NestLoop(t1 lt ml mk t2)
 NestLoop(t1 lt ml mk)
 HashJoin(t1 lt ml)
 HashJoin(lt ml)
 SeqScan(t1)
 IndexScan(lt)
 SeqScan(ml)
 IndexScan(mk)
 IndexScan(t2)
 SeqScan(k)
 Leading(((((t1 (lt ml)) mk) t2) k)) */
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


/*+ HashJoin(t1 lt ml mk t2 k)
 NestLoop(t1 lt ml mk t2)
 NestLoop(t1 lt ml mk)
 HashJoin(t1 lt ml)
 HashJoin(lt ml)
 SeqScan(t1)
 IndexScan(lt)
 SeqScan(ml)
 IndexScan(mk)
 IndexScan(t2)
 SeqScan(k)
 Leading(((((t1 (lt ml)) mk) t2) k)) */
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


/*+ MergeJoin(t1 ml t2 mc1 cn1 lt mii1 kt1 it1 kt2 mc2 mii2 cn2 it2)
 NestLoop(mc2 mii2 cn2 it2)
 NestLoop(mc2 mii2 cn2)
 MergeJoin(mc2 mii2)
 NestLoop(t1 ml t2 mc1 cn1 lt mii1 kt1 it1 kt2)
 NestLoop(t1 ml t2 mc1 cn1 lt mii1 kt1 it1)
 NestLoop(t1 ml t2 mc1 cn1 lt mii1 kt1)
 NestLoop(t1 ml t2 mc1 cn1 lt mii1)
 HashJoin(t1 ml t2 mc1 cn1 lt)
 NestLoop(t1 ml t2 mc1 cn1)
 NestLoop(t1 ml t2 mc1)
 HashJoin(t1 ml t2)
 HashJoin(t1 ml)
 SeqScan(t1)
 SeqScan(ml)
 SeqScan(t2)
 IndexScan(mc1)
 IndexScan(cn1)
 SeqScan(lt)
 IndexScan(mii1)
 IndexScan(kt1)
 IndexScan(it1)
 SeqScan(kt2)
 IndexScan(mc2)
 IndexScan(mii2)
 IndexScan(cn2)
 IndexScan(it2)
 Leading(((((((((((t1 ml) t2) mc1) cn1) lt) mii1) kt1) it1) kt2) (((mc2 mii2) cn2) it2))) */
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


/*+ MergeJoin(kt1 kt2 t2 lt ml mc1 mc2 mii1 cn2 it1 cn1 t1 mii2 it2)
 MergeJoin(kt1 kt2 t2 lt ml mc1 mc2 mii1 cn2 it1 cn1 t1 mii2)
 NestLoop(kt1 kt2 t2 lt ml mc1 mc2 mii1 cn2 it1 cn1 t1)
 NestLoop(kt2 t2 lt ml mc1 mc2 mii1 cn2 it1 cn1 t1)
 NestLoop(kt2 t2 lt ml mc1 mc2 mii1 cn2 it1 cn1)
 NestLoop(kt2 t2 lt ml mc1 mc2 mii1 cn2 it1)
 NestLoop(kt2 t2 lt ml mc1 mc2 mii1 cn2)
 NestLoop(kt2 t2 lt ml mc1 mc2 mii1)
 NestLoop(kt2 t2 lt ml mc1 mc2)
 HashJoin(kt2 t2 lt ml mc1)
 NestLoop(t2 lt ml mc1)
 HashJoin(t2 lt ml)
 HashJoin(lt ml)
 SeqScan(kt1)
 SeqScan(kt2)
 SeqScan(t2)
 SeqScan(lt)
 SeqScan(ml)
 IndexScan(mc1)
 IndexScan(mc2)
 IndexScan(mii1)
 IndexScan(cn2)
 IndexScan(it1)
 IndexScan(cn1)
 IndexScan(t1)
 IndexScan(mii2)
 IndexScan(it2)
 Leading((((kt1 (((((((kt2 ((t2 (lt ml)) mc1)) mc2) mii1) cn2) it1) cn1) t1)) mii2) it2)) */
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
WHERE cn1.country_code != '[us]'
  AND it1.info = 'rating'
  AND it2.info = 'rating'
  AND kt1.kind IN ('tv series',
                   'episode')
  AND kt2.kind IN ('tv series',
                   'episode')
  AND lt.link IN ('sequel',
                  'follows',
                  'followed by')
  AND mii2.info < '3.5'
  AND t2.production_year BETWEEN 2000 AND 2010
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


/*+ NestLoop(mk k t mi)
 NestLoop(mk k t)
 HashJoin(mk k)
 SeqScan(mk)
 SeqScan(k)
 IndexScan(t)
 IndexScan(mi)
 Leading((((mk k) t) mi)) */
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


/*+ HashJoin(t mi_idx it mk k)
 NestLoop(t mi_idx it mk)
 MergeJoin(t mi_idx it)
 HashJoin(t mi_idx)
 SeqScan(t)
 SeqScan(mi_idx)
 SeqScan(it)
 IndexScan(mk)
 SeqScan(k)
 Leading(((((t mi_idx) it) mk) k)) */
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


/*+ NestLoop(k mk mi_idx it t)
 MergeJoin(k mk mi_idx it)
 NestLoop(k mk mi_idx)
 NestLoop(k mk)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(mi_idx)
 SeqScan(it)
 IndexScan(t)
 Leading(((((k mk) mi_idx) it) t)) */
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


/*+ NestLoop(mi_idx mk k it t)
 MergeJoin(mi_idx mk k it)
 HashJoin(mi_idx mk k)
 HashJoin(mk k)
 SeqScan(mi_idx)
 SeqScan(mk)
 SeqScan(k)
 SeqScan(it)
 IndexScan(t)
 Leading((((mi_idx (mk k)) it) t)) */
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


/*+ MergeJoin(ct mc mi it t)
 MergeJoin(ct mc mi it)
 MergeJoin(mi it)
 MergeJoin(ct mc)
 SeqScan(ct)
 SeqScan(mc)
 SeqScan(mi)
 SeqScan(it)
 SeqScan(t)
 Leading((((ct mc) (mi it)) t)) */
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


/*+ MergeJoin(ct mc mi it t)
 NestLoop(ct mc mi it)
 NestLoop(ct mc mi)
 HashJoin(ct mc)
 SeqScan(ct)
 SeqScan(mc)
 IndexScan(mi)
 SeqScan(it)
 SeqScan(t)
 Leading(((((ct mc) mi) it) t)) */
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


/*+ MergeJoin(ct t mc mi it)
 NestLoop(ct t mc mi)
 HashJoin(ct t mc)
 HashJoin(t mc)
 SeqScan(ct)
 SeqScan(t)
 SeqScan(mc)
 IndexScan(mi)
 SeqScan(it)
 Leading((((ct (t mc)) mi) it)) */
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


/*+ HashJoin(mk k mc cn t ci an n)
 HashJoin(mk k mc cn t ci an)
 NestLoop(mk k mc cn t ci)
 NestLoop(mk k mc cn t)
 NestLoop(mk k mc cn)
 HashJoin(mk k mc)
 HashJoin(mk k)
 SeqScan(mk)
 SeqScan(k)
 SeqScan(mc)
 IndexScan(cn)
 IndexScan(t)
 IndexScan(ci)
 IndexScan(an)
 IndexScan(n)
 Leading((((((((mk k) mc) cn) t) ci) an) n)) */
SELECT MIN(an.name) AS cool_actor_pseudonym, MIN(t.title) AS series_named_after_char FROM aka_name AS an, cast_info AS ci, company_name AS cn, keyword AS k, movie_companies AS mc, movie_keyword AS mk, name AS n, title AS t WHERE cn.country_code ='[us]' AND k.keyword ='character-name-in-title' AND an.person_id = n.id AND n.id = ci.person_id AND ci.movie_id = t.id AND t.id = mk.movie_id AND mk.keyword_id = k.id AND t.id = mc.movie_id AND mc.company_id = cn.id AND an.person_id = ci.person_id AND ci.movie_id = mc.movie_id AND ci.movie_id = mk.movie_id AND mc.movie_id = mk.movie_id;


/*+ HashJoin(t mk k ci n)
 NestLoop(mk k ci n)
 NestLoop(mk k ci)
 HashJoin(mk k)
 SeqScan(t)
 SeqScan(mk)
 SeqScan(k)
 IndexScan(ci)
 IndexScan(n)
 Leading((t (((mk k) ci) n))) */
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


/*+ MergeJoin(an ci t mk cn mc k n)
 MergeJoin(an ci t mk cn mc k)
 HashJoin(ci t mk cn mc k)
 HashJoin(t mk cn mc k)
 MergeJoin(mk cn mc k)
 HashJoin(mk cn mc)
 NestLoop(cn mc)
 IndexScan(an)
 SeqScan(ci)
 SeqScan(t)
 IndexScan(mk)
 IndexScan(cn)
 IndexScan(mc)
 IndexScan(k)
 IndexScan(n)
 Leading(((an (ci (t ((mk (cn mc)) k)))) n)) */
SELECT MIN(an.name) AS cool_actor_pseudonym, MIN(t.title) AS series_named_after_char FROM aka_name AS an, cast_info AS ci, company_name AS cn, keyword AS k, movie_companies AS mc, movie_keyword AS mk, name AS n, title AS t WHERE cn.country_code ='[uk]' AND k.keyword ='character-name-in-title' AND an.person_id = n.id AND n.id = ci.person_id AND ci.movie_id = t.id AND t.id = mk.movie_id AND mk.keyword_id = k.id AND t.id = mc.movie_id AND mc.company_id = cn.id AND an.person_id = ci.person_id AND ci.movie_id = mc.movie_id AND ci.movie_id = mk.movie_id AND mc.movie_id = mk.movie_id;


/*+ HashJoin(n t mk k ci)
 NestLoop(t mk k ci)
 HashJoin(t mk k)
 NestLoop(t mk)
 SeqScan(n)
 SeqScan(t)
 IndexScan(mk)
 IndexScan(k)
 IndexScan(ci)
 Leading((n (((t mk) k) ci))) */
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


/*+ HashJoin(mk k mc cn t ci an n)
 HashJoin(mk k mc cn t ci an)
 NestLoop(mk k mc cn t ci)
 NestLoop(mk k mc cn t)
 NestLoop(mk k mc cn)
 HashJoin(mk k mc)
 HashJoin(mk k)
 SeqScan(mk)
 SeqScan(k)
 SeqScan(mc)
 IndexScan(cn)
 IndexScan(t)
 IndexScan(ci)
 IndexScan(an)
 IndexScan(n)
 Leading((((((((mk k) mc) cn) t) ci) an) n)) */
SELECT MAX(an.name) AS cool_actor_pseudonym, MAX(t.title) AS series_named_after_char FROM aka_name AS an, cast_info AS ci, company_name AS cn, keyword AS k, movie_companies AS mc, movie_keyword AS mk, name AS n, title AS t WHERE cn.country_code ='[us]' AND k.keyword ='character-name-in-title' AND an.person_id = n.id AND n.id = ci.person_id AND ci.movie_id = t.id AND t.id = mk.movie_id AND mk.keyword_id = k.id AND t.id = mc.movie_id AND mc.company_id = cn.id AND an.person_id = ci.person_id AND ci.movie_id = mc.movie_id AND ci.movie_id = mk.movie_id AND mc.movie_id = mk.movie_id;


/*+ NestLoop(t n ci mk k)
 NestLoop(t n ci mk)
 HashJoin(t n ci)
 NestLoop(n ci)
 SeqScan(t)
 SeqScan(n)
 IndexScan(ci)
 IndexScan(mk)
 IndexScan(k)
 Leading((((t (n ci)) mk) k)) */
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


/*+ NestLoop(t n ci mk k)
 NestLoop(t n ci mk)
 HashJoin(t n ci)
 NestLoop(n ci)
 SeqScan(t)
 SeqScan(n)
 IndexScan(ci)
 IndexScan(mk)
 IndexScan(k)
 Leading((((t (n ci)) mk) k)) */
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


/*+ HashJoin(n t mk k ci)
 NestLoop(t mk k ci)
 HashJoin(t mk k)
 HashJoin(mk k)
 SeqScan(n)
 SeqScan(t)
 SeqScan(mk)
 IndexScan(k)
 IndexScan(ci)
 Leading((n ((t (mk k)) ci))) */
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


/*+ NestLoop(pi1 it an ci n t ml lt)
 MergeJoin(pi1 it an ci n t ml)
 NestLoop(pi1 it an ci n t)
 NestLoop(pi1 it an ci n)
 NestLoop(pi1 it an ci)
 NestLoop(pi1 it an)
 HashJoin(pi1 it)
 SeqScan(pi1)
 SeqScan(it)
 IndexScan(an)
 IndexScan(ci)
 IndexScan(n)
 IndexScan(t)
 SeqScan(ml)
 IndexScan(lt)
 Leading((((((((pi1 it) an) ci) n) t) ml) lt)) */
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


/*+ NestLoop(pi1 it an ci n t ml lt)
 MergeJoin(pi1 it an ci n t ml)
 NestLoop(pi1 it an ci n t)
 NestLoop(pi1 it an ci n)
 NestLoop(pi1 it an ci)
 NestLoop(pi1 it an)
 HashJoin(pi1 it)
 SeqScan(pi1)
 SeqScan(it)
 IndexScan(an)
 IndexScan(ci)
 IndexScan(n)
 IndexScan(t)
 SeqScan(ml)
 IndexScan(lt)
 Leading((((((((pi1 it) an) ci) n) t) ml) lt)) */
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


/*+ NestLoop(t ml lt ci n pi1 it an)
 HashJoin(t ml lt ci n pi1 it)
 MergeJoin(t ml lt ci n pi1)
 HashJoin(t ml lt ci n)
 NestLoop(t ml lt ci)
 HashJoin(t ml lt)
 HashJoin(t ml)
 SeqScan(t)
 SeqScan(ml)
 SeqScan(lt)
 IndexScan(ci)
 SeqScan(n)
 SeqScan(pi1)
 SeqScan(it)
 IndexScan(an)
 Leading((((((((t ml) lt) ci) n) pi1) it) an)) */
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


/*+ HashJoin(rt n ci an mc t cn)
 NestLoop(rt n ci an mc t)
 HashJoin(rt n ci an mc)
 NestLoop(rt n ci an)
 HashJoin(rt n ci)
 NestLoop(n ci)
 IndexScan(rt)
 SeqScan(n)
 IndexScan(ci)
 IndexScan(an)
 SeqScan(mc)
 IndexScan(t)
 SeqScan(cn)
 Leading((((((rt (n ci)) an) mc) t) cn)) */
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


/*+ HashJoin(ci rt n an mc cn t)
 HashJoin(ci rt n an mc cn)
 HashJoin(ci rt n an mc)
 NestLoop(ci rt n an)
 HashJoin(ci rt n)
 HashJoin(ci rt)
 SeqScan(ci)
 IndexScan(rt)
 IndexScan(n)
 IndexScan(an)
 IndexScan(mc)
 SeqScan(cn)
 SeqScan(t)
 Leading(((((((ci rt) n) an) mc) cn) t)) */
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


/*+ HashJoin(ci rt n an mc cn t)
 HashJoin(ci rt n an mc cn)
 HashJoin(ci rt n an mc)
 NestLoop(ci rt n an)
 HashJoin(ci rt n)
 HashJoin(ci rt)
 SeqScan(ci)
 IndexScan(rt)
 IndexScan(n)
 IndexScan(an)
 IndexScan(mc)
 SeqScan(cn)
 SeqScan(t)
 Leading(((((((ci rt) n) an) mc) cn) t)) */
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


/*+ HashJoin(n an ci mc chn rt cn t)
 MergeJoin(n an ci mc chn rt cn)
 MergeJoin(n an ci mc chn rt)
 HashJoin(n an ci mc chn)
 HashJoin(n an ci mc)
 NestLoop(n an ci)
 NestLoop(n an)
 SeqScan(n)
 IndexScan(an)
 IndexScan(ci)
 SeqScan(mc)
 SeqScan(chn)
 SeqScan(rt)
 IndexScan(cn)
 SeqScan(t)
 Leading((((((((n an) ci) mc) chn) rt) cn) t)) */
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


/*+ HashJoin(an n ci chn rt mc cn t)
 HashJoin(an n ci chn rt mc cn)
 HashJoin(an n ci chn rt mc)
 NestLoop(an n ci chn rt)
 NestLoop(an n ci chn)
 NestLoop(an n ci)
 HashJoin(an n)
 SeqScan(an)
 SeqScan(n)
 IndexScan(ci)
 IndexScan(chn)
 SeqScan(rt)
 SeqScan(mc)
 IndexScan(cn)
 SeqScan(t)
 Leading((((((((an n) ci) chn) rt) mc) cn) t)) */
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