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
EXPLAIN (ANALYZE, FORMAT JSON) SELECT MIN(chn.name) AS character,
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