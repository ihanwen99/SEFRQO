-- 10a13.sql
/*+ NestedLoop(mi1 it1 t kt ci rt n)
 HashJoin(mi1 it1 t kt ci rt)
 NestedLoop(mi1 it1 t kt ci)
 HashJoin(mi1 it1 t kt)
 NestedLoop(mi1 it1 t)
 HashJoin(mi1 it1)
 SeqScan(mi1)
 SeqScan(it1)
 IndexScan(t)
 SeqScan(kt)
 IndexScan(ci)
 SeqScan(rt)
 IndexScan(n)
 Leading(((((((mi1 it1) t) kt) ci) rt) n)) */
SELECT n.name, mi1.info, MIN(t.production_year), MAX(t.production_year)
FROM title as t,
kind_type as kt,
movie_info as mi1,
info_type as it1,
cast_info as ci,
role_type as rt,
name as n
WHERE
t.id = ci.movie_id
AND t.id = mi1.movie_id
AND mi1.info_type_id = it1.id
AND t.kind_id = kt.id
AND ci.person_id = n.id
AND ci.movie_id = mi1.movie_id
AND ci.role_id = rt.id
AND (it1.id IN ('3','5'))
AND (mi1.info IN ('Belgium:KNT','Brazil:16','Canada:PA','Chile:Y7','Finland:K-14','France:12','India:U','Ireland:16','Japan:U','Malaysia:18SG','Mexico:A','New Zealand:G','Norway:10','Portugal:M/18','Singapore:(Banned)','Spain:7','Taiwan:R-12','UK:A','UK:AA'))
AND (n.name ILIKE '%joe%')
AND (kt.kind IN ('episode','movie','tv movie'))
AND (rt.role IN ('editor','miscellaneous crew','producer'))
GROUP BY mi1.info, n.name


-- 10a14.sql
/*+ HashJoin(n ci rt t kt mi1 it1)
 NestedLoop(n ci rt t kt mi1)
 HashJoin(n ci rt t kt)
 NestedLoop(n ci rt t)
 HashJoin(n ci rt)
 NestedLoop(n ci)
 SeqScan(n)
 IndexScan(ci)
 SeqScan(rt)
 IndexScan(t)
 SeqScan(kt)
 IndexScan(mi1)
 SeqScan(it1)
 Leading(((((((n ci) rt) t) kt) mi1) it1)) */
SELECT n.name, mi1.info, MIN(t.production_year), MAX(t.production_year)
FROM title as t,
kind_type as kt,
movie_info as mi1,
info_type as it1,
cast_info as ci,
role_type as rt,
name as n
WHERE
t.id = ci.movie_id
AND t.id = mi1.movie_id
AND mi1.info_type_id = it1.id
AND t.kind_id = kt.id
AND ci.person_id = n.id
AND ci.movie_id = mi1.movie_id
AND ci.role_id = rt.id
AND (it1.id IN ('3','4'))
AND (mi1.info IN ('Biography','Crime','Dutch','English','Fantasy','French','German','Musical','Mystery','Portuguese','Romance'))
AND (n.name ILIKE '%rie%')
AND (kt.kind IN ('episode','tv movie'))
AND (rt.role IN ('director','editor','miscellaneous crew','producer'))
GROUP BY mi1.info, n.name


-- 10a15.sql
/*+ NestedLoop(mi1 it1 t kt ci rt n)
 HashJoin(mi1 it1 t kt ci rt)
 NestedLoop(mi1 it1 t kt ci)
 HashJoin(mi1 it1 t kt)
 NestedLoop(mi1 it1 t)
 HashJoin(mi1 it1)
 SeqScan(mi1)
 SeqScan(it1)
 IndexScan(t)
 SeqScan(kt)
 IndexScan(ci)
 SeqScan(rt)
 IndexScan(n)
 Leading(((((((mi1 it1) t) kt) ci) rt) n)) */
SELECT n.name, mi1.info, MIN(t.production_year), MAX(t.production_year)
FROM title as t,
kind_type as kt,
movie_info as mi1,
info_type as it1,
cast_info as ci,
role_type as rt,
name as n
WHERE
t.id = ci.movie_id
AND t.id = mi1.movie_id
AND mi1.info_type_id = it1.id
AND t.kind_id = kt.id
AND ci.person_id = n.id
AND ci.movie_id = mi1.movie_id
AND ci.role_id = rt.id
AND (it1.id IN ('6','8'))
AND (mi1.info IN ('4-Track Stereo','70 mm 6-Track','Austria','Brazil','China','Colombia','Cuba','DTS-Stereo','Datasat','Denmark','Greece','Puerto Rico','South Africa','Switzerland','Taiwan','West Germany'))
AND (n.name ILIKE '%jim%')
AND (kt.kind IN ('episode','movie','tv movie'))
AND (rt.role IN ('actor','actress','composer'))
GROUP BY mi1.info, n.name


-- 10a19.sql
/*+ NestedLoop(n ci rt t kt mi1 it1)
 NestedLoop(n ci rt t kt mi1)
 HashJoin(n ci rt t kt)
 NestedLoop(n ci rt t)
 HashJoin(n ci rt)
 NestedLoop(n ci)
 SeqScan(n)
 IndexScan(ci)
 SeqScan(rt)
 IndexScan(t)
 SeqScan(kt)
 IndexScan(mi1)
 IndexOnlyScan(it1)
 Leading(((((((n ci) rt) t) kt) mi1) it1)) */
SELECT n.name, mi1.info, MIN(t.production_year), MAX(t.production_year)
FROM title as t,
kind_type as kt,
movie_info as mi1,
info_type as it1,
cast_info as ci,
role_type as rt,
name as n
WHERE
t.id = ci.movie_id
AND t.id = mi1.movie_id
AND mi1.info_type_id = it1.id
AND t.kind_id = kt.id
AND ci.person_id = n.id
AND ci.movie_id = mi1.movie_id
AND ci.role_id = rt.id
AND (it1.id IN ('3','5'))
AND (mi1.info IN ('Denmark:15','Denmark:7','France:X','Hong Kong:III','Iceland:14','Ireland:12A','Japan:PG12','Netherlands:14','Netherlands:18','New Zealand:G','New Zealand:R13','Portugal:M/4','South Africa:PG','Switzerland:0','West Germany:18'))
AND (n.name ILIKE '%alla%')
AND (kt.kind IN ('episode','movie','tv series'))
AND (rt.role IN ('actress','director','miscellaneous crew','producer'))
GROUP BY mi1.info, n.name


-- 10a8.sql
/*+ NestedLoop(mi1 t kt ci rt n it1)
 NestedLoop(mi1 t kt ci rt n)
 HashJoin(mi1 t kt ci rt)
 NestedLoop(mi1 t kt ci)
 HashJoin(mi1 t kt)
 NestedLoop(mi1 t)
 SeqScan(mi1)
 IndexScan(t)
 SeqScan(kt)
 IndexScan(ci)
 SeqScan(rt)
 IndexScan(n)
 SeqScan(it1)
 Leading(((((((mi1 t) kt) ci) rt) n) it1)) */
SELECT n.name, mi1.info, MIN(t.production_year), MAX(t.production_year)
FROM title as t,
kind_type as kt,
movie_info as mi1,
info_type as it1,
cast_info as ci,
role_type as rt,
name as n
WHERE
t.id = ci.movie_id
AND t.id = mi1.movie_id
AND mi1.info_type_id = it1.id
AND t.kind_id = kt.id
AND ci.person_id = n.id
AND ci.movie_id = mi1.movie_id
AND ci.role_id = rt.id
AND (it1.id IN ('4'))
AND (mi1.info IN ('Arabic','Czech','Danish','Dutch','English','Filipino','German','Greek','Italian','Spanish','Swedish','Tagalog'))
AND (n.name ILIKE '%lou%')
AND (kt.kind IN ('episode','movie','tv movie'))
AND (rt.role IN ('actress','composer','costume designer'))
GROUP BY mi1.info, n.name


-- 11a16.sql
/*+ NestedLoop(it mi1 t mc cn ct kt ci rt n)
 NestedLoop(mi1 t mc cn ct kt ci rt n)
 HashJoin(mi1 t mc cn ct kt ci rt)
 NestedLoop(mi1 t mc cn ct kt ci)
 HashJoin(mi1 t mc cn ct kt)
 HashJoin(mi1 t mc cn ct)
 NestedLoop(mi1 t mc cn)
 NestedLoop(mi1 t mc)
 NestedLoop(mi1 t)
 SeqScan(it)
 SeqScan(mi1)
 IndexScan(t)
 IndexScan(mc)
 IndexScan(cn)
 SeqScan(ct)
 SeqScan(kt)
 IndexScan(ci)
 SeqScan(rt)
 IndexScan(n)
 Leading((it ((((((((mi1 t) mc) cn) ct) kt) ci) rt) n))) */
SELECT n.gender, rt.role, cn.name, COUNT(*)
FROM title as t,
movie_companies as mc,
company_name as cn,
company_type as ct,
kind_type as kt,
cast_info as ci,
name as n,
role_type as rt,
movie_info as mi1,
info_type as it
WHERE t.id = mc.movie_id
AND t.id = ci.movie_id
AND t.id = mi1.movie_id
AND mi1.movie_id = ci.movie_id
AND ci.movie_id = mc.movie_id
AND cn.id = mc.company_id
AND ct.id = mc.company_type_id
AND kt.id = t.kind_id
AND ci.person_id = n.id
AND ci.role_id = rt.id
AND mi1.info_type_id = it.id
AND (kt.kind ILIKE '%m%')
AND (rt.role IN ('actor','costume designer','director','editor','guest','miscellaneous crew','production designer','writer'))
AND (t.production_year <= 2015)
AND (t.production_year >= 1875)
AND (it.id IN ('6'))
AND (mi1.info ILIKE '%di%')
AND (cn.name ILIKE '%fil%')
GROUP BY n.gender, rt.role, cn.name
ORDER BY COUNT(*) DESC


-- 11a5.sql
/*+ NestedLoop(mc cn t mi1 ct kt ci rt n it)
 NestedLoop(mc cn t mi1 ct kt ci rt n)
 HashJoin(mc cn t mi1 ct kt ci rt)
 NestedLoop(mc cn t mi1 ct kt ci)
 HashJoin(mc cn t mi1 ct kt)
 HashJoin(mc cn t mi1 ct)
 NestedLoop(mc cn t mi1)
 NestedLoop(mc cn t)
 NestedLoop(mc cn)
 IndexScan(mc)
 IndexScan(cn)
 IndexScan(t)
 IndexScan(mi1)
 SeqScan(ct)
 SeqScan(kt)
 IndexScan(ci)
 SeqScan(rt)
 IndexScan(n)
 SeqScan(it)
 Leading((((((((((mc cn) t) mi1) ct) kt) ci) rt) n) it)) */
SELECT n.gender, rt.role, cn.name, COUNT(*)
FROM title as t,
movie_companies as mc,
company_name as cn,
company_type as ct,
kind_type as kt,
cast_info as ci,
name as n,
role_type as rt,
movie_info as mi1,
info_type as it
WHERE t.id = mc.movie_id
AND t.id = ci.movie_id
AND t.id = mi1.movie_id
AND mi1.movie_id = ci.movie_id
AND ci.movie_id = mc.movie_id
AND cn.id = mc.company_id
AND ct.id = mc.company_type_id
AND kt.id = t.kind_id
AND ci.person_id = n.id
AND ci.role_id = rt.id
AND mi1.info_type_id = it.id
AND (kt.kind ILIKE '%m%')
AND (rt.role IN ('actress','composer','editor'))
AND (t.production_year <= 2015)
AND (t.production_year >= 1990)
AND (it.id IN ('6'))
AND (mi1.info ILIKE '%d%')
AND (cn.name ILIKE '%ve%')
GROUP BY n.gender, rt.role, cn.name
ORDER BY COUNT(*) DESC


-- 11a6.sql
/*+ NestedLoop(it cn mc mi1 t ct kt ci rt n)
 NestedLoop(cn mc mi1 t ct kt ci rt n)
 HashJoin(cn mc mi1 t ct kt ci rt)
 NestedLoop(cn mc mi1 t ct kt ci)
 NestedLoop(cn mc mi1 t ct kt)
 NestedLoop(cn mc mi1 t ct)
 NestedLoop(cn mc mi1 t)
 NestedLoop(cn mc mi1)
 NestedLoop(cn mc)
 SeqScan(it)
 SeqScan(cn)
 IndexScan(mc)
 IndexScan(mi1)
 IndexScan(t)
 IndexOnlyScan(ct)
 IndexScan(kt)
 IndexScan(ci)
 SeqScan(rt)
 IndexScan(n)
 Leading((it ((((((((cn mc) mi1) t) ct) kt) ci) rt) n))) */
SELECT n.gender, rt.role, cn.name, COUNT(*)
FROM title as t,
movie_companies as mc,
company_name as cn,
company_type as ct,
kind_type as kt,
cast_info as ci,
name as n,
role_type as rt,
movie_info as mi1,
info_type as it
WHERE t.id = mc.movie_id
AND t.id = ci.movie_id
AND t.id = mi1.movie_id
AND mi1.movie_id = ci.movie_id
AND ci.movie_id = mc.movie_id
AND cn.id = mc.company_id
AND ct.id = mc.company_type_id
AND kt.id = t.kind_id
AND ci.person_id = n.id
AND ci.role_id = rt.id
AND mi1.info_type_id = it.id
AND (kt.kind ILIKE '%m%')
AND (rt.role IN ('actress','cinematographer','composer','costume designer','director','editor','guest','production designer'))
AND (t.production_year <= 2015)
AND (t.production_year >= 1875)
AND (it.id IN ('6'))
AND (mi1.info ILIKE '%mon%')
AND (cn.name ILIKE '%warn%')
GROUP BY n.gender, rt.role, cn.name
ORDER BY COUNT(*) DESC


-- 11a7.sql
/*+ NestedLoop(mi1 t kt mc cn ct ci rt n it)
 NestedLoop(mi1 t kt mc cn ct ci rt n)
 HashJoin(mi1 t kt mc cn ct ci rt)
 NestedLoop(mi1 t kt mc cn ct ci)
 HashJoin(mi1 t kt mc cn ct)
 NestedLoop(mi1 t kt mc cn)
 NestedLoop(mi1 t kt mc)
 HashJoin(mi1 t kt)
 NestedLoop(mi1 t)
 SeqScan(mi1)
 IndexScan(t)
 SeqScan(kt)
 IndexScan(mc)
 IndexScan(cn)
 SeqScan(ct)
 IndexScan(ci)
 SeqScan(rt)
 IndexScan(n)
 SeqScan(it)
 Leading((((((((((mi1 t) kt) mc) cn) ct) ci) rt) n) it)) */
SELECT n.gender, rt.role, cn.name, COUNT(*)
FROM title as t,
movie_companies as mc,
company_name as cn,
company_type as ct,
kind_type as kt,
cast_info as ci,
name as n,
role_type as rt,
movie_info as mi1,
info_type as it
WHERE t.id = mc.movie_id
AND t.id = ci.movie_id
AND t.id = mi1.movie_id
AND mi1.movie_id = ci.movie_id
AND ci.movie_id = mc.movie_id
AND cn.id = mc.company_id
AND ct.id = mc.company_type_id
AND kt.id = t.kind_id
AND ci.person_id = n.id
AND ci.role_id = rt.id
AND mi1.info_type_id = it.id
AND (kt.kind ILIKE '%vi%')
AND (rt.role IN ('actor','actress','cinematographer','composer','costume designer','director','editor','producer','production designer','writer'))
AND (t.production_year <= 2015)
AND (t.production_year >= 1990)
AND (it.id IN ('2'))
AND (mi1.info ILIKE '%bl%')
AND (cn.name ILIKE '%fi%')
GROUP BY n.gender, rt.role, cn.name
ORDER BY COUNT(*) DESC


-- 11a8.sql
/*+ NestedLoop(mc cn t mi1 ct kt ci rt n it)
 NestedLoop(mc cn t mi1 ct kt ci rt n)
 HashJoin(mc cn t mi1 ct kt ci rt)
 NestedLoop(mc cn t mi1 ct kt ci)
 HashJoin(mc cn t mi1 ct kt)
 HashJoin(mc cn t mi1 ct)
 NestedLoop(mc cn t mi1)
 NestedLoop(mc cn t)
 HashJoin(mc cn)
 SeqScan(mc)
 SeqScan(cn)
 IndexScan(t)
 IndexScan(mi1)
 SeqScan(ct)
 SeqScan(kt)
 IndexScan(ci)
 SeqScan(rt)
 IndexScan(n)
 SeqScan(it)
 Leading((((((((((mc cn) t) mi1) ct) kt) ci) rt) n) it)) */
SELECT n.gender, rt.role, cn.name, COUNT(*)
FROM title as t,
movie_companies as mc,
company_name as cn,
company_type as ct,
kind_type as kt,
cast_info as ci,
name as n,
role_type as rt,
movie_info as mi1,
info_type as it
WHERE t.id = mc.movie_id
AND t.id = ci.movie_id
AND t.id = mi1.movie_id
AND mi1.movie_id = ci.movie_id
AND ci.movie_id = mc.movie_id
AND cn.id = mc.company_id
AND ct.id = mc.company_type_id
AND kt.id = t.kind_id
AND ci.person_id = n.id
AND ci.role_id = rt.id
AND mi1.info_type_id = it.id
AND (kt.kind ILIKE '%m%')
AND (rt.role IN ('actor','actress','cinematographer','composer','costume designer','miscellaneous crew','production designer','writer'))
AND (t.production_year <= 1945)
AND (t.production_year >= 1875)
AND (it.id IN ('6'))
AND (mi1.info ILIKE '%m%')
AND (cn.name ILIKE '%co%')
GROUP BY n.gender, rt.role, cn.name
ORDER BY COUNT(*) DESC


-- 11b11.sql
/*+ NestedLoop(ci pi n rt t kt mi1 mc cn ct it1 it2)
 NestedLoop(ci pi n rt t kt mi1 mc cn ct it1)
 HashJoin(ci pi n rt t kt mi1 mc cn ct)
 NestedLoop(ci pi n rt t kt mi1 mc cn)
 NestedLoop(ci pi n rt t kt mi1 mc)
 NestedLoop(ci pi n rt t kt mi1)
 HashJoin(ci pi n rt t kt)
 NestedLoop(ci pi n rt t)
 HashJoin(ci pi n rt)
 HashJoin(ci pi n)
 NestedLoop(pi n)
 SeqScan(ci)
 SeqScan(pi)
 IndexScan(n)
 SeqScan(rt)
 IndexScan(t)
 SeqScan(kt)
 IndexScan(mi1)
 IndexScan(mc)
 IndexScan(cn)
 SeqScan(ct)
 SeqScan(it1)
 SeqScan(it2)
 Leading(((((((((((ci (pi n)) rt) t) kt) mi1) mc) cn) ct) it1) it2)) */
SELECT n.gender, rt.role, cn.name, COUNT(*)
FROM title as t,
movie_companies as mc,
company_name as cn,
company_type as ct,
kind_type as kt,
cast_info as ci,
name as n,
role_type as rt,
movie_info as mi1,
info_type as it1,
person_info as pi,
info_type as it2
WHERE t.id = mc.movie_id
AND t.id = ci.movie_id
AND t.id = mi1.movie_id
AND mi1.movie_id = ci.movie_id
AND ci.movie_id = mc.movie_id
AND cn.id = mc.company_id
AND ct.id = mc.company_type_id
AND kt.id = t.kind_id
AND ci.person_id = n.id
AND ci.role_id = rt.id
AND mi1.info_type_id = it1.id
AND n.id = pi.person_id
AND pi.info_type_id = it2.id
AND ci.person_id = pi.person_id
AND (kt.kind IN ('movie','tv mini series','tv movie','tv series','video game','video movie'))
AND (rt.role IN ('actor','costume designer','editor','guest','miscellaneous crew','producer','writer'))
AND (t.production_year <= 2015)
AND (t.production_year >= 1875)
AND (it1.id IN ('4'))
AND (mi1.info ILIKE '%e%')
AND (pi.info ILIKE '%200%')
AND (it2.id IN ('38'))
GROUP BY n.gender, rt.role, cn.name
ORDER BY COUNT(*) DESC


-- 11b12.sql
/*+ NestedLoop(mi1 t kt ci rt pi n mc cn ct it1 it2)
 NestedLoop(mi1 t kt ci rt pi n mc cn ct it1)
 NestedLoop(mi1 t kt ci rt pi n mc cn ct)
 NestedLoop(mi1 t kt ci rt pi n mc cn)
 NestedLoop(mi1 t kt ci rt pi n mc)
 NestedLoop(mi1 t kt ci rt pi n)
 NestedLoop(mi1 t kt ci rt pi)
 HashJoin(mi1 t kt ci rt)
 NestedLoop(mi1 t kt ci)
 NestedLoop(mi1 t kt)
 NestedLoop(mi1 t)
 SeqScan(mi1)
 IndexScan(t)
 IndexScan(kt)
 IndexScan(ci)
 SeqScan(rt)
 IndexScan(pi)
 IndexScan(n)
 IndexScan(mc)
 IndexScan(cn)
 IndexOnlyScan(ct)
 SeqScan(it1)
 SeqScan(it2)
 Leading((((((((((((mi1 t) kt) ci) rt) pi) n) mc) cn) ct) it1) it2)) */
SELECT n.gender, rt.role, cn.name, COUNT(*)
FROM title as t,
movie_companies as mc,
company_name as cn,
company_type as ct,
kind_type as kt,
cast_info as ci,
name as n,
role_type as rt,
movie_info as mi1,
info_type as it1,
person_info as pi,
info_type as it2
WHERE t.id = mc.movie_id
AND t.id = ci.movie_id
AND t.id = mi1.movie_id
AND mi1.movie_id = ci.movie_id
AND ci.movie_id = mc.movie_id
AND cn.id = mc.company_id
AND ct.id = mc.company_type_id
AND kt.id = t.kind_id
AND ci.person_id = n.id
AND ci.role_id = rt.id
AND mi1.info_type_id = it1.id
AND n.id = pi.person_id
AND pi.info_type_id = it2.id
AND ci.person_id = pi.person_id
AND (kt.kind IN ('episode','movie','tv mini series','tv series','video game','video movie'))
AND (rt.role IN ('actor','cinematographer','composer','costume designer','producer'))
AND (t.production_year <= 2015)
AND (t.production_year >= 1990)
AND (it1.id IN ('8'))
AND (mi1.info ILIKE '%cub%')
AND (pi.info ILIKE '%wa%')
AND (it2.id IN ('29'))
GROUP BY n.gender, rt.role, cn.name
ORDER BY COUNT(*) DESC


-- 11b13.sql
/*+ NestedLoop(pi n ci rt t kt mi1 mc cn ct it1 it2)
 NestedLoop(pi n ci rt t kt mi1 mc cn ct it1)
 HashJoin(pi n ci rt t kt mi1 mc cn ct)
 NestedLoop(pi n ci rt t kt mi1 mc cn)
 NestedLoop(pi n ci rt t kt mi1 mc)
 NestedLoop(pi n ci rt t kt mi1)
 HashJoin(pi n ci rt t kt)
 NestedLoop(pi n ci rt t)
 HashJoin(pi n ci rt)
 NestedLoop(pi n ci)
 NestedLoop(pi n)
 SeqScan(pi)
 IndexScan(n)
 IndexScan(ci)
 SeqScan(rt)
 IndexScan(t)
 SeqScan(kt)
 IndexScan(mi1)
 IndexScan(mc)
 IndexScan(cn)
 SeqScan(ct)
 SeqScan(it1)
 SeqScan(it2)
 Leading((((((((((((pi n) ci) rt) t) kt) mi1) mc) cn) ct) it1) it2)) */
SELECT n.gender, rt.role, cn.name, COUNT(*)
FROM title as t,
movie_companies as mc,
company_name as cn,
company_type as ct,
kind_type as kt,
cast_info as ci,
name as n,
role_type as rt,
movie_info as mi1,
info_type as it1,
person_info as pi,
info_type as it2
WHERE t.id = mc.movie_id
AND t.id = ci.movie_id
AND t.id = mi1.movie_id
AND mi1.movie_id = ci.movie_id
AND ci.movie_id = mc.movie_id
AND cn.id = mc.company_id
AND ct.id = mc.company_type_id
AND kt.id = t.kind_id
AND ci.person_id = n.id
AND ci.role_id = rt.id
AND mi1.info_type_id = it1.id
AND n.id = pi.person_id
AND pi.info_type_id = it2.id
AND ci.person_id = pi.person_id
AND (kt.kind IN ('episode','movie','tv mini series','tv series','video game','video movie'))
AND (rt.role IN ('composer','costume designer','director','miscellaneous crew'))
AND (t.production_year <= 2015)
AND (t.production_year >= 1875)
AND (it1.id IN ('3'))
AND (mi1.info ILIKE '%d%')
AND (pi.info ILIKE '%che%')
AND (it2.id IN ('38'))
GROUP BY n.gender, rt.role, cn.name
ORDER BY COUNT(*) DESC


-- 11b14.sql
/*+ NestedLoop(pi n ci rt t kt mi1 mc cn ct it1 it2)
 NestedLoop(pi n ci rt t kt mi1 mc cn ct it1)
 NestedLoop(pi n ci rt t kt mi1 mc cn ct)
 NestedLoop(pi n ci rt t kt mi1 mc cn)
 NestedLoop(pi n ci rt t kt mi1 mc)
 NestedLoop(pi n ci rt t kt mi1)
 NestedLoop(pi n ci rt t kt)
 NestedLoop(pi n ci rt t)
 HashJoin(pi n ci rt)
 NestedLoop(pi n ci)
 NestedLoop(pi n)
 SeqScan(pi)
 IndexScan(n)
 IndexScan(ci)
 SeqScan(rt)
 IndexScan(t)
 IndexScan(kt)
 IndexScan(mi1)
 IndexScan(mc)
 IndexScan(cn)
 IndexOnlyScan(ct)
 SeqScan(it1)
 SeqScan(it2)
 Leading((((((((((((pi n) ci) rt) t) kt) mi1) mc) cn) ct) it1) it2)) */
SELECT n.gender, rt.role, cn.name, COUNT(*)
FROM title as t,
movie_companies as mc,
company_name as cn,
company_type as ct,
kind_type as kt,
cast_info as ci,
name as n,
role_type as rt,
movie_info as mi1,
info_type as it1,
person_info as pi,
info_type as it2
WHERE t.id = mc.movie_id
AND t.id = ci.movie_id
AND t.id = mi1.movie_id
AND mi1.movie_id = ci.movie_id
AND ci.movie_id = mc.movie_id
AND cn.id = mc.company_id
AND ct.id = mc.company_type_id
AND kt.id = t.kind_id
AND ci.person_id = n.id
AND ci.role_id = rt.id
AND mi1.info_type_id = it1.id
AND n.id = pi.person_id
AND pi.info_type_id = it2.id
AND ci.person_id = pi.person_id
AND (kt.kind IN ('episode','movie','tv mini series','tv series','video game','video movie'))
AND (rt.role IN ('actor','cinematographer','director','editor','miscellaneous crew','producer','production designer','writer'))
AND (t.production_year <= 2015)
AND (t.production_year >= 1990)
AND (it1.id IN ('6'))
AND (mi1.info ILIKE '%mo%')
AND (pi.info ILIKE '%alp%')
AND (it2.id IN ('39'))
GROUP BY n.gender, rt.role, cn.name
ORDER BY COUNT(*) DESC


-- 11b15.sql
/*+ NestedLoop(mi1 t kt ci rt pi n mc cn ct it1 it2)
 NestedLoop(mi1 t kt ci rt pi n mc cn ct it1)
 NestedLoop(mi1 t kt ci rt pi n mc cn ct)
 NestedLoop(mi1 t kt ci rt pi n mc cn)
 NestedLoop(mi1 t kt ci rt pi n mc)
 NestedLoop(mi1 t kt ci rt pi n)
 NestedLoop(mi1 t kt ci rt pi)
 HashJoin(mi1 t kt ci rt)
 NestedLoop(mi1 t kt ci)
 NestedLoop(mi1 t kt)
 NestedLoop(mi1 t)
 SeqScan(mi1)
 IndexScan(t)
 IndexScan(kt)
 IndexScan(ci)
 SeqScan(rt)
 IndexScan(pi)
 IndexScan(n)
 IndexScan(mc)
 IndexScan(cn)
 IndexOnlyScan(ct)
 SeqScan(it1)
 SeqScan(it2)
 Leading((((((((((((mi1 t) kt) ci) rt) pi) n) mc) cn) ct) it1) it2)) */
SELECT n.gender, rt.role, cn.name, COUNT(*)
FROM title as t,
movie_companies as mc,
company_name as cn,
company_type as ct,
kind_type as kt,
cast_info as ci,
name as n,
role_type as rt,
movie_info as mi1,
info_type as it1,
person_info as pi,
info_type as it2
WHERE t.id = mc.movie_id
AND t.id = ci.movie_id
AND t.id = mi1.movie_id
AND mi1.movie_id = ci.movie_id
AND ci.movie_id = mc.movie_id
AND cn.id = mc.company_id
AND ct.id = mc.company_type_id
AND kt.id = t.kind_id
AND ci.person_id = n.id
AND ci.role_id = rt.id
AND mi1.info_type_id = it1.id
AND n.id = pi.person_id
AND pi.info_type_id = it2.id
AND ci.person_id = pi.person_id
AND (kt.kind IN ('episode','movie','tv mini series','tv movie','video game','video movie'))
AND (rt.role IN ('actor','actress','cinematographer','costume designer','guest','miscellaneous crew','producer','writer'))
AND (t.production_year <= 2015)
AND (t.production_year >= 1990)
AND (it1.id IN ('6'))
AND (mi1.info ILIKE '%dt%')
AND (pi.info ILIKE '%usa%')
AND (it2.id IN ('39'))
GROUP BY n.gender, rt.role, cn.name
ORDER BY COUNT(*) DESC


-- 1a2454.sql
/*+ NestedLoop(it2 it1 mi2 t kt mi1 ci rt n)
 NestedLoop(it1 mi2 t kt mi1 ci rt n)
 NestedLoop(mi2 t kt mi1 ci rt n)
 HashJoin(mi2 t kt mi1 ci rt)
 NestedLoop(mi2 t kt mi1 ci)
 NestedLoop(mi2 t kt mi1)
 HashJoin(mi2 t kt)
 NestedLoop(mi2 t)
 SeqScan(it2)
 SeqScan(it1)
 SeqScan(mi2)
 IndexScan(t)
 SeqScan(kt)
 IndexScan(mi1)
 IndexScan(ci)
 SeqScan(rt)
 IndexScan(n)
 Leading((it2 (it1 ((((((mi2 t) kt) mi1) ci) rt) n)))) */
SELECT COUNT(*) FROM title as t,
kind_type as kt,
movie_info as mi1,
info_type as it1,
movie_info as mi2,
info_type as it2,
cast_info as ci,
role_type as rt,
name as n
WHERE
t.id = ci.movie_id
AND t.id = mi1.movie_id
AND t.id = mi2.movie_id
AND mi1.movie_id = mi2.movie_id
AND mi1.info_type_id = it1.id
AND mi2.info_type_id = it2.id
AND it1.id = '3'
AND it2.id = '4'
AND t.kind_id = kt.id
AND ci.person_id = n.id
AND ci.role_id = rt.id
AND mi1.info IN ('Comedy','Drama','Musical','Short')
AND mi2.info IN ('Bulgarian','Danish','Hindi','Norwegian','Romanian','Swedish','Tamil')
AND kt.kind IN ('movie','video movie')
AND rt.role IN ('composer','costume designer')
AND n.gender IN ('f','m')
AND t.production_year <= 2015
AND 1925 < t.production_year


-- 1a2459.sql
/*+ NestedLoop(it2 it1 mi1 t kt mi2 ci rt n)
 NestedLoop(it1 mi1 t kt mi2 ci rt n)
 NestedLoop(mi1 t kt mi2 ci rt n)
 HashJoin(mi1 t kt mi2 ci rt)
 NestedLoop(mi1 t kt mi2 ci)
 NestedLoop(mi1 t kt mi2)
 HashJoin(mi1 t kt)
 HashJoin(t kt)
 SeqScan(it2)
 SeqScan(it1)
 SeqScan(mi1)
 SeqScan(t)
 SeqScan(kt)
 IndexScan(mi2)
 IndexScan(ci)
 SeqScan(rt)
 IndexScan(n)
 Leading((it2 (it1 (((((mi1 (t kt)) mi2) ci) rt) n)))) */
SELECT COUNT(*) FROM title as t,
kind_type as kt,
movie_info as mi1,
info_type as it1,
movie_info as mi2,
info_type as it2,
cast_info as ci,
role_type as rt,
name as n
WHERE
t.id = ci.movie_id
AND t.id = mi1.movie_id
AND t.id = mi2.movie_id
AND mi1.movie_id = mi2.movie_id
AND mi1.info_type_id = it1.id
AND mi2.info_type_id = it2.id
AND it1.id = '3'
AND it2.id = '4'
AND t.kind_id = kt.id
AND ci.person_id = n.id
AND ci.role_id = rt.id
AND mi1.info IN ('Comedy','Documentary','Drama','Mystery','News','Romance','Sci-Fi','Thriller')
AND mi2.info IN ('Danish','English','French','German','Greek','Italian','Japanese','Portuguese','Tagalog')
AND kt.kind IN ('tv series','video game')
AND rt.role IN ('costume designer','editor')
AND n.gender IN ('f','m')
AND t.production_year <= 2015
AND 1990 < t.production_year


-- 1a2470.sql
/*+ NestedLoop(it2 it1 mi2 mi1 t kt ci rt n)
 NestedLoop(it1 mi2 mi1 t kt ci rt n)
 NestedLoop(mi2 mi1 t kt ci rt n)
 HashJoin(mi2 mi1 t kt ci rt)
 NestedLoop(mi2 mi1 t kt ci)
 HashJoin(mi2 mi1 t kt)
 NestedLoop(mi2 mi1 t)
 HashJoin(mi2 mi1)
 SeqScan(it2)
 SeqScan(it1)
 SeqScan(mi2)
 SeqScan(mi1)
 IndexScan(t)
 SeqScan(kt)
 IndexScan(ci)
 SeqScan(rt)
 IndexScan(n)
 Leading((it2 (it1 ((((((mi2 mi1) t) kt) ci) rt) n)))) */
SELECT COUNT(*) FROM title as t,
kind_type as kt,
movie_info as mi1,
info_type as it1,
movie_info as mi2,
info_type as it2,
cast_info as ci,
role_type as rt,
name as n
WHERE
t.id = ci.movie_id
AND t.id = mi1.movie_id
AND t.id = mi2.movie_id
AND mi1.movie_id = mi2.movie_id
AND mi1.info_type_id = it1.id
AND mi2.info_type_id = it2.id
AND it1.id = '3'
AND it2.id = '4'
AND t.kind_id = kt.id
AND ci.person_id = n.id
AND ci.role_id = rt.id
AND mi1.info IN ('Adventure','Comedy','Drama','Mystery','Short','Thriller')
AND mi2.info IN ('Dutch','English','Finnish','German','Italian','Japanese','Korean','Russian','Swedish')
AND kt.kind IN ('episode','movie','video movie')
AND rt.role IN ('costume designer','director')
AND n.gender IN ('f','m')
AND t.production_year <= 2015
AND 1990 < t.production_year


-- 1a2479.sql
/*+ NestedLoop(mi2 t kt mi1 it1 it2 ci rt n)
 HashJoin(mi2 t kt mi1 it1 it2 ci rt)
 NestedLoop(mi2 t kt mi1 it1 it2 ci)
 NestedLoop(mi2 t kt mi1 it1 it2)
 NestedLoop(mi2 t kt mi1 it1)
 NestedLoop(mi2 t kt mi1)
 HashJoin(mi2 t kt)
 NestedLoop(mi2 t)
 SeqScan(mi2)
 IndexScan(t)
 SeqScan(kt)
 IndexScan(mi1)
 SeqScan(it1)
 SeqScan(it2)
 IndexScan(ci)
 SeqScan(rt)
 IndexScan(n)
 Leading(((((((((mi2 t) kt) mi1) it1) it2) ci) rt) n)) */
SELECT COUNT(*) FROM title as t,
kind_type as kt,
movie_info as mi1,
info_type as it1,
movie_info as mi2,
info_type as it2,
cast_info as ci,
role_type as rt,
name as n
WHERE
t.id = ci.movie_id
AND t.id = mi1.movie_id
AND t.id = mi2.movie_id
AND mi1.movie_id = mi2.movie_id
AND mi1.info_type_id = it1.id
AND mi2.info_type_id = it2.id
AND it1.id = '3'
AND it2.id = '4'
AND t.kind_id = kt.id
AND ci.person_id = n.id
AND ci.role_id = rt.id
AND mi1.info IN ('Drama','Short')
AND mi2.info IN ('Dutch','Finnish','Hindi')
AND kt.kind IN ('tv series','video game','video movie')
AND rt.role IN ('cinematographer','costume designer')
AND n.gender IN ('f','m')
AND t.production_year <= 1975
AND 1925 < t.production_year


-- 1a2482.sql
/*+ NestedLoop(it2 it1 mi1 t kt mi2 ci rt n)
 NestedLoop(it1 mi1 t kt mi2 ci rt n)
 NestedLoop(mi1 t kt mi2 ci rt n)
 HashJoin(mi1 t kt mi2 ci rt)
 NestedLoop(mi1 t kt mi2 ci)
 NestedLoop(mi1 t kt mi2)
 HashJoin(mi1 t kt)
 NestedLoop(mi1 t)
 SeqScan(it2)
 SeqScan(it1)
 SeqScan(mi1)
 IndexScan(t)
 SeqScan(kt)
 IndexScan(mi2)
 IndexScan(ci)
 SeqScan(rt)
 IndexScan(n)
 Leading((it2 (it1 ((((((mi1 t) kt) mi2) ci) rt) n)))) */
SELECT COUNT(*) FROM title as t,
kind_type as kt,
movie_info as mi1,
info_type as it1,
movie_info as mi2,
info_type as it2,
cast_info as ci,
role_type as rt,
name as n
WHERE
t.id = ci.movie_id
AND t.id = mi1.movie_id
AND t.id = mi2.movie_id
AND mi1.movie_id = mi2.movie_id
AND mi1.info_type_id = it1.id
AND mi2.info_type_id = it2.id
AND it1.id = '3'
AND it2.id = '4'
AND t.kind_id = kt.id
AND ci.person_id = n.id
AND ci.role_id = rt.id
AND mi1.info IN ('Action','Crime','Family','Romance','Sci-Fi','Western')
AND mi2.info IN ('French','German','Italian','Portuguese','Russian','Spanish')
AND kt.kind IN ('tv movie','tv series','video game')
AND rt.role IN ('writer')
AND n.gender IN ('m')
AND t.production_year <= 2015
AND 1925 < t.production_year


-- 2a10.sql
/*+ NestedLoop(mi2 t kt mi1 it1 it2 ci rt n mk k)
 NestedLoop(mi2 t kt mi1 it1 it2 ci rt n mk)
 NestedLoop(mi2 t kt mi1 it1 it2 ci rt n)
 NestedLoop(mi2 t kt mi1 it1 it2 ci rt)
 NestedLoop(mi2 t kt mi1 it1 it2 ci)
 NestedLoop(mi2 t kt mi1 it1 it2)
 NestedLoop(mi2 t kt mi1 it1)
 NestedLoop(mi2 t kt mi1)
 HashJoin(mi2 t kt)
 NestedLoop(mi2 t)
 SeqScan(mi2)
 IndexScan(t)
 SeqScan(kt)
 IndexScan(mi1)
 SeqScan(it1)
 SeqScan(it2)
 IndexScan(ci)
 IndexScan(rt)
 IndexScan(n)
 IndexScan(mk)
 IndexOnlyScan(k)
 Leading(((((((((((mi2 t) kt) mi1) it1) it2) ci) rt) n) mk) k)) */
SELECT COUNT(*) FROM title as t,
kind_type as kt,
info_type as it1,
movie_info as mi1,
movie_info as mi2,
info_type as it2,
cast_info as ci,
role_type as rt,
name as n,
movie_keyword as mk,
keyword as k
WHERE
t.id = ci.movie_id
AND t.id = mi1.movie_id
AND t.id = mi2.movie_id
AND t.id = mk.movie_id
AND k.id = mk.keyword_id
AND mi1.movie_id = mi2.movie_id
AND mi1.info_type_id = it1.id
AND mi2.info_type_id = it2.id
AND (it1.id in ('1'))
AND (it2.id in ('6'))
AND t.kind_id = kt.id
AND ci.person_id = n.id
AND ci.role_id = rt.id
AND (mi1.info in ('15','22','30','60','90','Argentina:60','USA:30'))
AND (mi2.info in ('Dolby','Stereo'))
AND (kt.kind in ('episode','video movie'))
AND (rt.role in ('cinematographer','director'))
AND (n.gender in ('m') OR n.gender IS NULL)
AND (t.production_year <= 2015)
AND (t.production_year >= 1990)


-- 2a2.sql
/*+ NestedLoop(it2 it1 mi2 mi1 t kt ci rt n mk k)
 NestedLoop(it1 mi2 mi1 t kt ci rt n mk k)
 NestedLoop(mi2 mi1 t kt ci rt n mk k)
 NestedLoop(mi2 mi1 t kt ci rt n mk)
 NestedLoop(mi2 mi1 t kt ci rt n)
 HashJoin(mi2 mi1 t kt ci rt)
 NestedLoop(mi2 mi1 t kt ci)
 HashJoin(mi2 mi1 t kt)
 NestedLoop(mi2 mi1 t)
 HashJoin(mi2 mi1)
 SeqScan(it2)
 SeqScan(it1)
 SeqScan(mi2)
 SeqScan(mi1)
 IndexScan(t)
 SeqScan(kt)
 IndexScan(ci)
 SeqScan(rt)
 IndexScan(n)
 IndexScan(mk)
 IndexOnlyScan(k)
 Leading((it2 (it1 ((((((((mi2 mi1) t) kt) ci) rt) n) mk) k)))) */
SELECT COUNT(*) FROM title as t,
kind_type as kt,
info_type as it1,
movie_info as mi1,
movie_info as mi2,
info_type as it2,
cast_info as ci,
role_type as rt,
name as n,
movie_keyword as mk,
keyword as k
WHERE
t.id = ci.movie_id
AND t.id = mi1.movie_id
AND t.id = mi2.movie_id
AND t.id = mk.movie_id
AND k.id = mk.keyword_id
AND mi1.movie_id = mi2.movie_id
AND mi1.info_type_id = it1.id
AND mi2.info_type_id = it2.id
AND (it1.id in ('3'))
AND (it2.id in ('8'))
AND t.kind_id = kt.id
AND ci.person_id = n.id
AND ci.role_id = rt.id
AND (mi1.info in ('Animation','Comedy','Documentary','Drama','Family','Short','Sport','Talk-Show'))
AND (mi2.info in ('Belgium','Canada','Finland','Italy','Portugal','South Korea','Spain','Sweden','UK','USA'))
AND (kt.kind in ('tv movie','tv series','video game'))
AND (rt.role in ('costume designer','production designer'))
AND (n.gender in ('f') OR n.gender IS NULL)
AND (t.production_year <= 2015)
AND (t.production_year >= 1990)


-- 2a4.sql
/*+ NestedLoop(it2 it1 mi2 t kt mi1 ci rt n mk k)
 NestedLoop(it1 mi2 t kt mi1 ci rt n mk k)
 NestedLoop(mi2 t kt mi1 ci rt n mk k)
 NestedLoop(mi2 t kt mi1 ci rt n mk)
 NestedLoop(mi2 t kt mi1 ci rt n)
 HashJoin(mi2 t kt mi1 ci rt)
 NestedLoop(mi2 t kt mi1 ci)
 NestedLoop(mi2 t kt mi1)
 HashJoin(mi2 t kt)
 NestedLoop(mi2 t)
 SeqScan(it2)
 SeqScan(it1)
 SeqScan(mi2)
 IndexScan(t)
 SeqScan(kt)
 IndexScan(mi1)
 IndexScan(ci)
 SeqScan(rt)
 IndexScan(n)
 IndexScan(mk)
 IndexOnlyScan(k)
 Leading((it2 (it1 ((((((((mi2 t) kt) mi1) ci) rt) n) mk) k)))) */
SELECT COUNT(*) FROM title as t,
kind_type as kt,
info_type as it1,
movie_info as mi1,
movie_info as mi2,
info_type as it2,
cast_info as ci,
role_type as rt,
name as n,
movie_keyword as mk,
keyword as k
WHERE
t.id = ci.movie_id
AND t.id = mi1.movie_id
AND t.id = mi2.movie_id
AND t.id = mk.movie_id
AND k.id = mk.keyword_id
AND mi1.movie_id = mi2.movie_id
AND mi1.info_type_id = it1.id
AND mi2.info_type_id = it2.id
AND (it1.id in ('7'))
AND (it2.id in ('1'))
AND t.kind_id = kt.id
AND ci.person_id = n.id
AND ci.role_id = rt.id
AND (mi1.info in ('OFM:35 mm','PCS:Spherical','PFM:35 mm'))
AND (mi2.info in ('10','25','60','75','82','83','89','90','94','95','96','98','99'))
AND (kt.kind in ('episode','movie','video movie'))
AND (rt.role in ('producer'))
AND (n.gender in ('m'))
AND (t.production_year <= 2015)
AND (t.production_year >= 1925)


-- 2a5.sql
/*+ NestedLoop(it2 it1 mi2 t kt mi1 ci rt n mk k)
 NestedLoop(it1 mi2 t kt mi1 ci rt n mk k)
 NestedLoop(mi2 t kt mi1 ci rt n mk k)
 NestedLoop(mi2 t kt mi1 ci rt n mk)
 NestedLoop(mi2 t kt mi1 ci rt n)
 HashJoin(mi2 t kt mi1 ci rt)
 NestedLoop(mi2 t kt mi1 ci)
 NestedLoop(mi2 t kt mi1)
 HashJoin(mi2 t kt)
 NestedLoop(mi2 t)
 SeqScan(it2)
 SeqScan(it1)
 SeqScan(mi2)
 IndexScan(t)
 SeqScan(kt)
 IndexScan(mi1)
 IndexScan(ci)
 SeqScan(rt)
 IndexScan(n)
 IndexScan(mk)
 IndexOnlyScan(k)
 Leading((it2 (it1 ((((((((mi2 t) kt) mi1) ci) rt) n) mk) k)))) */
SELECT COUNT(*) FROM title as t,
kind_type as kt,
info_type as it1,
movie_info as mi1,
movie_info as mi2,
info_type as it2,
cast_info as ci,
role_type as rt,
name as n,
movie_keyword as mk,
keyword as k
WHERE
t.id = ci.movie_id
AND t.id = mi1.movie_id
AND t.id = mi2.movie_id
AND t.id = mk.movie_id
AND k.id = mk.keyword_id
AND mi1.movie_id = mi2.movie_id
AND mi1.info_type_id = it1.id
AND mi2.info_type_id = it2.id
AND (it1.id in ('2'))
AND (it2.id in ('4'))
AND t.kind_id = kt.id
AND ci.person_id = n.id
AND ci.role_id = rt.id
AND (mi1.info in ('Black and White','Color'))
AND (mi2.info in ('Bengali','Italian','Malayalam','Romanian','Spanish'))
AND (kt.kind in ('episode','movie','video movie'))
AND (rt.role in ('production designer'))
AND (n.gender IS NULL)
AND (t.production_year <= 2015)
AND (t.production_year >= 1990)


-- 2a9.sql
/*+ NestedLoop(it2 it1 mi1 t kt mi2 ci rt n mk k)
 NestedLoop(it1 mi1 t kt mi2 ci rt n mk k)
 NestedLoop(mi1 t kt mi2 ci rt n mk k)
 NestedLoop(mi1 t kt mi2 ci rt n mk)
 NestedLoop(mi1 t kt mi2 ci rt n)
 HashJoin(mi1 t kt mi2 ci rt)
 NestedLoop(mi1 t kt mi2 ci)
 NestedLoop(mi1 t kt mi2)
 HashJoin(mi1 t kt)
 HashJoin(t kt)
 SeqScan(it2)
 SeqScan(it1)
 SeqScan(mi1)
 SeqScan(t)
 SeqScan(kt)
 IndexScan(mi2)
 IndexScan(ci)
 SeqScan(rt)
 IndexScan(n)
 IndexScan(mk)
 IndexOnlyScan(k)
 Leading((it2 (it1 (((((((mi1 (t kt)) mi2) ci) rt) n) mk) k)))) */
SELECT COUNT(*) FROM title as t,
kind_type as kt,
info_type as it1,
movie_info as mi1,
movie_info as mi2,
info_type as it2,
cast_info as ci,
role_type as rt,
name as n,
movie_keyword as mk,
keyword as k
WHERE
t.id = ci.movie_id
AND t.id = mi1.movie_id
AND t.id = mi2.movie_id
AND t.id = mk.movie_id
AND k.id = mk.keyword_id
AND mi1.movie_id = mi2.movie_id
AND mi1.info_type_id = it1.id
AND mi2.info_type_id = it2.id
AND (it1.id in ('7'))
AND (it2.id in ('2'))
AND t.kind_id = kt.id
AND ci.person_id = n.id
AND ci.role_id = rt.id
AND (mi1.info in ('LAB:Technicolor','OFM:16 mm','OFM:35 mm','OFM:Live','OFM:Video','PCS:Spherical','PFM:35 mm','PFM:Video','RAT:1.33 : 1'))
AND (mi2.info in ('Black and White','Color'))
AND (kt.kind in ('episode','movie','tv movie'))
AND (rt.role in ('costume designer'))
AND (n.gender IS NULL)
AND (t.production_year <= 1990)
AND (t.production_year >= 1950)


-- 2b1.sql
/*+ NestedLoop(k mk t kt mi1 ci mi2 it1 it2 rt n)
 NestedLoop(k mk t kt mi1 ci mi2 it1 it2 rt)
 NestedLoop(k mk t kt mi1 ci mi2 it1 it2)
 NestedLoop(k mk t kt mi1 ci mi2 it1)
 NestedLoop(k mk t kt mi1 ci mi2)
 NestedLoop(k mk t kt mi1 ci)
 NestedLoop(k mk t kt mi1)
 HashJoin(k mk t kt)
 NestedLoop(k mk t)
 NestedLoop(k mk)
 IndexScan(k)
 IndexScan(mk)
 IndexScan(t)
 SeqScan(kt)
 IndexScan(mi1)
 IndexScan(ci)
 IndexScan(mi2)
 SeqScan(it1)
 SeqScan(it2)
 IndexScan(rt)
 IndexScan(n)
 Leading(((((((((((k mk) t) kt) mi1) ci) mi2) it1) it2) rt) n)) */
SELECT COUNT(*) FROM title as t,
kind_type as kt,
info_type as it1,
movie_info as mi1,
movie_info as mi2,
info_type as it2,
cast_info as ci,
role_type as rt,
name as n,
movie_keyword as mk,
keyword as k
WHERE
t.id = ci.movie_id
AND t.id = mi1.movie_id
AND t.id = mi2.movie_id
AND t.id = mk.movie_id
AND k.id = mk.keyword_id
AND mi1.movie_id = mi2.movie_id
AND mi1.info_type_id = it1.id
AND mi2.info_type_id = it2.id
AND (it1.id in ('6'))
AND (it2.id in ('2'))
AND t.kind_id = kt.id
AND ci.person_id = n.id
AND ci.role_id = rt.id
AND (mi1.info in ('Mono','Silent'))
AND (mi2.info in ('Color'))
AND (kt.kind in ('episode','movie','tv movie'))
AND (rt.role in ('cinematographer','writer'))
AND (n.gender in ('f'))
AND (t.production_year <= 1975)
AND (t.production_year >= 1875)
AND (k.keyword IN ('air-attack','ancient-computer','baby-urinating','botswana-south-africa','cilantro','g-string','jorge-drexler','kameido-tokyo','late-riser','ltr','porno-theatre','reference-to-otis-blackwell','robot-airplane','room-with-a-view','skeleton','tinder','underwater-scene','wet-back'))


-- 2b5.sql
/*+ NestedLoop(k mk t kt mi1 it1 mi2 it2 ci rt n)
 NestedLoop(k mk t kt mi1 it1 mi2 it2 ci rt)
 NestedLoop(k mk t kt mi1 it1 mi2 it2 ci)
 NestedLoop(k mk t kt mi1 it1 mi2 it2)
 NestedLoop(k mk t kt mi1 it1 mi2)
 NestedLoop(k mk t kt mi1 it1)
 NestedLoop(k mk t kt mi1)
 HashJoin(k mk t kt)
 NestedLoop(k mk t)
 NestedLoop(k mk)
 IndexScan(k)
 IndexScan(mk)
 IndexScan(t)
 SeqScan(kt)
 IndexScan(mi1)
 SeqScan(it1)
 IndexScan(mi2)
 SeqScan(it2)
 IndexScan(ci)
 IndexScan(rt)
 IndexScan(n)
 Leading(((((((((((k mk) t) kt) mi1) it1) mi2) it2) ci) rt) n)) */
SELECT COUNT(*) FROM title as t,
kind_type as kt,
info_type as it1,
movie_info as mi1,
movie_info as mi2,
info_type as it2,
cast_info as ci,
role_type as rt,
name as n,
movie_keyword as mk,
keyword as k
WHERE
t.id = ci.movie_id
AND t.id = mi1.movie_id
AND t.id = mi2.movie_id
AND t.id = mk.movie_id
AND k.id = mk.keyword_id
AND mi1.movie_id = mi2.movie_id
AND mi1.info_type_id = it1.id
AND mi2.info_type_id = it2.id
AND (it1.id in ('18'))
AND (it2.id in ('4'))
AND t.kind_id = kt.id
AND ci.person_id = n.id
AND ci.role_id = rt.id
AND (mi1.info in ('Boston, Massachusetts, USA','Brooklyn, New York City, New York, USA','London, England, UK','Los Angeles, California, USA','Madrid, Spain','Manhattan, New York City, New York, USA','Mexico','Miami, Florida, USA','New York City, New York, USA','Paris, France','Philadelphia, Pennsylvania, USA','Santa Clarita, California, USA','Toronto, Ontario, Canada'))
AND (mi2.info in ('English','French','Spanish'))
AND (kt.kind in ('episode','movie','video movie'))
AND (rt.role in ('cinematographer','writer'))
AND (n.gender in ('f'))
AND (t.production_year <= 2015)
AND (t.production_year >= 1990)
AND (k.keyword IN ('alabai','bird-in-cage','bride-to-be','brighton-beach-brooklyn-new-york-city','carrying-someone-on-ones-back','centered','heart-trouble','hit-with-an-umbrella','hunted-turns-hunter','journey','kidney-failure','leg-chains','legal-rights','long-underwear','media-spoof','motorbike-accident','open-sign','opry','red-party','sex-with-an-object','shakespeares-pericles','spooning','surprise-killer','town-boss','verse'))


-- 2b6.sql
/*+ NestedLoop(k mk t kt mi2 mi1 it1 it2 ci rt n)
 NestedLoop(k mk t kt mi2 mi1 it1 it2 ci rt)
 NestedLoop(k mk t kt mi2 mi1 it1 it2 ci)
 NestedLoop(k mk t kt mi2 mi1 it1 it2)
 NestedLoop(k mk t kt mi2 mi1 it1)
 NestedLoop(k mk t kt mi2 mi1)
 NestedLoop(k mk t kt mi2)
 HashJoin(k mk t kt)
 NestedLoop(k mk t)
 NestedLoop(k mk)
 IndexScan(k)
 IndexScan(mk)
 IndexScan(t)
 SeqScan(kt)
 IndexScan(mi2)
 IndexScan(mi1)
 SeqScan(it1)
 SeqScan(it2)
 IndexScan(ci)
 IndexScan(rt)
 IndexScan(n)
 Leading(((((((((((k mk) t) kt) mi2) mi1) it1) it2) ci) rt) n)) */
SELECT COUNT(*) FROM title as t,
kind_type as kt,
info_type as it1,
movie_info as mi1,
movie_info as mi2,
info_type as it2,
cast_info as ci,
role_type as rt,
name as n,
movie_keyword as mk,
keyword as k
WHERE
t.id = ci.movie_id
AND t.id = mi1.movie_id
AND t.id = mi2.movie_id
AND t.id = mk.movie_id
AND k.id = mk.keyword_id
AND mi1.movie_id = mi2.movie_id
AND mi1.info_type_id = it1.id
AND mi2.info_type_id = it2.id
AND (it1.id in ('105'))
AND (it2.id in ('4'))
AND t.kind_id = kt.id
AND ci.person_id = n.id
AND ci.role_id = rt.id
AND (mi1.info in ('$1,000,000','$150,000','$200','$200,000','$250,000','$4,000','$500,000'))
AND (mi2.info in ('English'))
AND (kt.kind in ('episode','movie','video movie'))
AND (rt.role in ('editor','miscellaneous crew'))
AND (n.gender IS NULL)
AND (t.production_year <= 2010)
AND (t.production_year >= 1950)
AND (k.keyword IN ('anal-sex','bare-breasts','homosexual','husband-wife-relationship','jealousy','mother-daughter-relationship','number-in-title'))


-- 2b8.sql
/*+ NestedLoop(k mk t kt mi1 ci mi2 it1 it2 rt n)
 NestedLoop(k mk t kt mi1 ci mi2 it1 it2 rt)
 NestedLoop(k mk t kt mi1 ci mi2 it1 it2)
 NestedLoop(k mk t kt mi1 ci mi2 it1)
 NestedLoop(k mk t kt mi1 ci mi2)
 NestedLoop(k mk t kt mi1 ci)
 NestedLoop(k mk t kt mi1)
 HashJoin(k mk t kt)
 NestedLoop(k mk t)
 NestedLoop(k mk)
 IndexScan(k)
 IndexScan(mk)
 IndexScan(t)
 SeqScan(kt)
 IndexScan(mi1)
 IndexScan(ci)
 IndexScan(mi2)
 SeqScan(it1)
 SeqScan(it2)
 IndexScan(rt)
 IndexScan(n)
 Leading(((((((((((k mk) t) kt) mi1) ci) mi2) it1) it2) rt) n)) */
SELECT COUNT(*) FROM title as t,
kind_type as kt,
info_type as it1,
movie_info as mi1,
movie_info as mi2,
info_type as it2,
cast_info as ci,
role_type as rt,
name as n,
movie_keyword as mk,
keyword as k
WHERE
t.id = ci.movie_id
AND t.id = mi1.movie_id
AND t.id = mi2.movie_id
AND t.id = mk.movie_id
AND k.id = mk.keyword_id
AND mi1.movie_id = mi2.movie_id
AND mi1.info_type_id = it1.id
AND mi2.info_type_id = it2.id
AND (it1.id in ('1'))
AND (it2.id in ('7'))
AND t.kind_id = kt.id
AND ci.person_id = n.id
AND ci.role_id = rt.id
AND (mi1.info in ('100','22','30','60','90','95','Argentina:30','USA:30','USA:60'))
AND (mi2.info in ('OFM:35 mm','PFM:35 mm','RAT:1.33 : 1','RAT:1.78 : 1','RAT:1.85 : 1'))
AND (kt.kind in ('tv movie','tv series','video game'))
AND (rt.role in ('director'))
AND (n.gender in ('m') OR n.gender IS NULL)
AND (t.production_year <= 2015)
AND (t.production_year >= 1990)
AND (k.keyword IN ('bare-chested-male','based-on-play','love','new-york-city','non-fiction','oral-sex','violence'))


-- 2b9.sql
/*+ NestedLoop(k mk t kt mi1 it1 mi2 it2 ci rt n)
 NestedLoop(k mk t kt mi1 it1 mi2 it2 ci rt)
 NestedLoop(k mk t kt mi1 it1 mi2 it2 ci)
 NestedLoop(k mk t kt mi1 it1 mi2 it2)
 NestedLoop(k mk t kt mi1 it1 mi2)
 NestedLoop(k mk t kt mi1 it1)
 NestedLoop(k mk t kt mi1)
 HashJoin(k mk t kt)
 NestedLoop(k mk t)
 NestedLoop(k mk)
 IndexScan(k)
 IndexScan(mk)
 IndexScan(t)
 SeqScan(kt)
 IndexScan(mi1)
 SeqScan(it1)
 IndexScan(mi2)
 SeqScan(it2)
 IndexScan(ci)
 IndexScan(rt)
 IndexScan(n)
 Leading(((((((((((k mk) t) kt) mi1) it1) mi2) it2) ci) rt) n)) */
SELECT COUNT(*) FROM title as t,
kind_type as kt,
info_type as it1,
movie_info as mi1,
movie_info as mi2,
info_type as it2,
cast_info as ci,
role_type as rt,
name as n,
movie_keyword as mk,
keyword as k
WHERE
t.id = ci.movie_id
AND t.id = mi1.movie_id
AND t.id = mi2.movie_id
AND t.id = mk.movie_id
AND k.id = mk.keyword_id
AND mi1.movie_id = mi2.movie_id
AND mi1.info_type_id = it1.id
AND mi2.info_type_id = it2.id
AND (it1.id in ('18'))
AND (it2.id in ('3'))
AND t.kind_id = kt.id
AND ci.person_id = n.id
AND ci.role_id = rt.id
AND (mi1.info in ('Austin, Texas, USA','Berlin, Germany','Chicago, Illinois, USA','Madrid, Spain','Manhattan, New York City, New York, USA','Rome, Lazio, Italy','San Francisco, California, USA','Toronto, Ontario, Canada','USA','Vancouver, British Columbia, Canada','Washington, District of Columbia, USA'))
AND (mi2.info in ('Comedy','Documentary','Drama','Short','Thriller'))
AND (kt.kind in ('tv movie','tv series','video game'))
AND (rt.role in ('cinematographer','production designer'))
AND (n.gender in ('m'))
AND (t.production_year <= 2015)
AND (t.production_year >= 1975)
AND (k.keyword IN ('blood','cigarette-smoking','family-relationships','female-nudity','flashback','hardcore','hospital','kidnapping','murder','number-in-title','police','suicide'))


-- 2c2.sql
/*+ NestedLoop(t kt mi2 ci rt n mi1 it1 it2)
 NestedLoop(t kt mi2 ci rt n mi1 it1)
 NestedLoop(t kt mi2 ci rt n mi1)
 NestedLoop(t kt mi2 ci rt n)
 HashJoin(t kt mi2 ci rt)
 NestedLoop(t kt mi2 ci)
 NestedLoop(t kt mi2)
 HashJoin(t kt)
 SeqScan(t)
 SeqScan(kt)
 IndexScan(mi2)
 IndexScan(ci)
 SeqScan(rt)
 IndexScan(n)
 IndexScan(mi1)
 SeqScan(it1)
 SeqScan(it2)
 Leading(((((((((t kt) mi2) ci) rt) n) mi1) it1) it2)) */
SELECT COUNT(*) FROM title as t,
kind_type as kt,
info_type as it1,
movie_info as mi1,
movie_info as mi2,
info_type as it2,
cast_info as ci,
role_type as rt,
name as n
WHERE
t.id = ci.movie_id
AND t.id = mi1.movie_id
AND t.id = mi2.movie_id
AND mi1.movie_id = mi2.movie_id
AND mi1.info_type_id = it1.id
AND mi2.info_type_id = it2.id
AND (it1.id in ('7'))
AND (it2.id in ('8'))
AND t.kind_id = kt.id
AND ci.person_id = n.id
AND ci.role_id = rt.id
AND (mi1.info IN ('MET:200 m','OFM:Video','PCS:(anamorphic)','PCS:CinemaScope','PCS:Dyaliscope','PCS:Kinescope','PCS:Panavision','PCS:Spherical','PFM:35 mm','RAT:1.37 : 1','RAT:2.20 : 1'))
AND (mi2.info IN ('Argentina','Canada','Czechoslovakia','Hong Kong','Hungary','Mexico','UK','West Germany','Yugoslavia'))
AND (kt.kind in ('movie','tv movie','tv series','video game','video movie'))
AND (rt.role in ('composer'))
AND (n.gender IN ('f','m') OR n.gender IS NULL)
AND (t.production_year <= 1975)
AND (t.production_year >= 1925)
AND (t.title in ('(#1.106)','(#1.12)','(#1.61)','(#1.85)','(#1.94)','(#4.25)','(#5.27)','(#6.2)','(#6.23)','Body and Soul','Casino Royale','Change of Heart','Checkmate','Chûshingura','Dead or Alive','Dick Tracys G-Men','Eagle Squadron','Festival','Golden Girl','Harlow','Johnny Belinda','Laura','Law and Disorder','Like Father, Like Son','Madame Sans-Gêne','Meet Danny Wilson','On the Run','Ryans Hope','Saboteur','Samson and Delilah','South Pacific','The Avengers','The Beginning or the End','The Box','The Greatest Story Ever Told','The Hustler','The Man Who Knew Too Much','The Professionals','The Story of Dr. Wassell','This Is the Life','Voyna i mir','Whats in a Name?'))


-- 2c6.sql
/*+ NestedLoop(t kt mi2 mi1 it1 it2 ci rt n)
 NestedLoop(t kt mi2 mi1 it1 it2 ci rt)
 NestedLoop(t kt mi2 mi1 it1 it2 ci)
 NestedLoop(t kt mi2 mi1 it1 it2)
 NestedLoop(t kt mi2 mi1 it1)
 NestedLoop(t kt mi2 mi1)
 NestedLoop(t kt mi2)
 HashJoin(t kt)
 SeqScan(t)
 SeqScan(kt)
 IndexScan(mi2)
 IndexScan(mi1)
 SeqScan(it1)
 SeqScan(it2)
 IndexScan(ci)
 IndexScan(rt)
 IndexScan(n)
 Leading(((((((((t kt) mi2) mi1) it1) it2) ci) rt) n)) */
SELECT COUNT(*) FROM title as t,
kind_type as kt,
info_type as it1,
movie_info as mi1,
movie_info as mi2,
info_type as it2,
cast_info as ci,
role_type as rt,
name as n
WHERE
t.id = ci.movie_id
AND t.id = mi1.movie_id
AND t.id = mi2.movie_id
AND mi1.movie_id = mi2.movie_id
AND mi1.info_type_id = it1.id
AND mi2.info_type_id = it2.id
AND (it1.id in ('3'))
AND (it2.id in ('8'))
AND t.kind_id = kt.id
AND ci.person_id = n.id
AND ci.role_id = rt.id
AND (mi1.info IN ('Adult','Adventure','Biography','Drama','Family','Game-Show','Horror','Music','Musical','Mystery','News','Reality-TV','Sci-Fi','Thriller','Western'))
AND (mi2.info IN ('Argentina','Belgium','Czech Republic','Indonesia','Mexico','Nigeria'))
AND (kt.kind in ('episode','movie','tv movie','tv series','video game','video movie'))
AND (rt.role in ('actress','cinematographer','composer','guest','producer'))
AND (n.gender IN ('f','m'))
AND (t.production_year <= 2015)
AND (t.production_year >= 1975)
AND (t.title in ('(#1.1453)','(#1.332)','(#1.3503)','(#1.3788)','(#1.5288)','(#10.58)','(#13.10)','(#15.21)','(#16.159)','(#2.87)','(#5.24)','(2000-06-23)','(2002-01-04)','(2003-05-16)','(2005-05-15)','(2006-08-27)','Ask the Dust','Austin Powers: The Spy Who Shagged Me','Basquiat','Can You Dig It?','Del 3','Do You See What I See?','Einsichten','Episode Five','Expectations','Homicide','Immortal Beloved','Insidious','Patience','Red, White and a Little Blue','Romeo y Julieta','Running on Empty','Saru gecchu 3','Secret Society','Tess','The Big Bang Theory','The Firm','The Mummy: Tomb of the Dragon Emperor','The Sting'))


-- 2c7.sql
/*+ NestedLoop(t kt mi1 ci rt it1 mi2 it2 n)
 NestedLoop(t kt mi1 ci rt it1 mi2 it2)
 NestedLoop(t kt mi1 ci rt it1 mi2)
 NestedLoop(t kt mi1 ci rt it1)
 NestedLoop(t kt mi1 ci rt)
 NestedLoop(t kt mi1 ci)
 NestedLoop(t kt mi1)
 HashJoin(t kt)
 SeqScan(t)
 SeqScan(kt)
 IndexScan(mi1)
 IndexScan(ci)
 IndexScan(rt)
 SeqScan(it1)
 IndexScan(mi2)
 SeqScan(it2)
 IndexScan(n)
 Leading(((((((((t kt) mi1) ci) rt) it1) mi2) it2) n)) */
SELECT COUNT(*) FROM title as t,
kind_type as kt,
info_type as it1,
movie_info as mi1,
movie_info as mi2,
info_type as it2,
cast_info as ci,
role_type as rt,
name as n
WHERE
t.id = ci.movie_id
AND t.id = mi1.movie_id
AND t.id = mi2.movie_id
AND mi1.movie_id = mi2.movie_id
AND mi1.info_type_id = it1.id
AND mi2.info_type_id = it2.id
AND (it1.id in ('8'))
AND (it2.id in ('18'))
AND t.kind_id = kt.id
AND ci.person_id = n.id
AND ci.role_id = rt.id
AND (mi1.info IN ('Austria','Canada','Czechoslovakia','Denmark','Hong Kong','Italy','Mexico','Philippines','Poland','Soviet Union','Switzerland','Yugoslavia'))
AND (mi2.info IN ('Barcelona, Cataluña, Spain','Berlin, Germany','Buenos Aires, Federal District, Argentina','Desilu Studios - 9336 W. Washington Blvd., Culver City, California, USA','London, England, UK','Los Angeles, California, USA','Mexico City, Distrito Federal, Mexico','Mexico','Munich, Bavaria, Germany','Paris, France','Philippines','Stage 9, 20th Century Fox Studios - 10201 Pico Blvd., Century City, Los Angeles, California, USA','Universal Studios - 100 Universal City Plaza, Universal City, California, USA'))
AND (kt.kind in ('episode','movie','tv movie','tv series','video game','video movie'))
AND (rt.role in ('editor'))
AND (n.gender IN ('f','m') OR n.gender IS NULL)
AND (t.production_year <= 1990)
AND (t.production_year >= 1950)
AND (t.title in ('(#1.263)','(#1.432)','(#1.944)','Die letzte Chance','Game 6','Honor Bound','Masterpiece','Palace','Running Scared','Special','Thats Entertainment','The Dating Game','The Suicide Club','The Threat'))


-- 2c8.sql
/*+ NestedLoop(t kt mi1 it1 ci rt n mi2 it2)
 NestedLoop(t kt mi1 it1 ci rt n mi2)
 NestedLoop(t kt mi1 it1 ci rt n)
 NestedLoop(t kt mi1 it1 ci rt)
 NestedLoop(t kt mi1 it1 ci)
 NestedLoop(t kt mi1 it1)
 NestedLoop(t kt mi1)
 HashJoin(t kt)
 SeqScan(t)
 SeqScan(kt)
 IndexScan(mi1)
 SeqScan(it1)
 IndexScan(ci)
 IndexScan(rt)
 IndexScan(n)
 IndexScan(mi2)
 SeqScan(it2)
 Leading(((((((((t kt) mi1) it1) ci) rt) n) mi2) it2)) */
SELECT COUNT(*) FROM title as t,
kind_type as kt,
info_type as it1,
movie_info as mi1,
movie_info as mi2,
info_type as it2,
cast_info as ci,
role_type as rt,
name as n
WHERE
t.id = ci.movie_id
AND t.id = mi1.movie_id
AND t.id = mi2.movie_id
AND mi1.movie_id = mi2.movie_id
AND mi1.info_type_id = it1.id
AND mi2.info_type_id = it2.id
AND (it1.id in ('2'))
AND (it2.id in ('6'))
AND t.kind_id = kt.id
AND ci.person_id = n.id
AND ci.role_id = rt.id
AND (mi1.info IN ('Black and White','Color'))
AND (mi2.info IN ('Mono','Silent','Stereo'))
AND (kt.kind in ('tv movie','tv series'))
AND (rt.role in ('actor','cinematographer','director','guest','production designer'))
AND (n.gender IN ('m') OR n.gender IS NULL)
AND (t.production_year <= 1975)
AND (t.production_year >= 1925)
AND (t.title in ('(#1.125)','(#1.82)','(#4.17)','(#4.31)','(#6.11)','(#6.15)','(#7.15)','A Canterbury Tale','A Farewell to Arms','A Life of Her Own','An American in Paris','Beauty and the Beast','Die Ratten','Hurricane','Killer McCoy','Les mystères de Paris','Maya','Meet John Doe','Mrs. Parkington','One Good Turn','San Quentin','Secret Agent X-9','Small Town Girl','Smart Woman','Storm Warning','Tennessee Johnson','The Barretts of Wimpole Street','The Daring Young Man','The Dream','The Frame-Up','The Great Caruso','The Roaring Twenties','The Three Musketeers','The Whole Towns Talking','Up Front','Vengeance'))


-- 2c9.sql
/*+ NestedLoop(t kt mi2 mi1 it1 it2 ci rt n)
 NestedLoop(t kt mi2 mi1 it1 it2 ci rt)
 NestedLoop(t kt mi2 mi1 it1 it2 ci)
 NestedLoop(t kt mi2 mi1 it1 it2)
 NestedLoop(t kt mi2 mi1 it1)
 NestedLoop(t kt mi2 mi1)
 NestedLoop(t kt mi2)
 HashJoin(t kt)
 SeqScan(t)
 SeqScan(kt)
 IndexScan(mi2)
 IndexScan(mi1)
 SeqScan(it1)
 SeqScan(it2)
 IndexScan(ci)
 IndexScan(rt)
 IndexScan(n)
 Leading(((((((((t kt) mi2) mi1) it1) it2) ci) rt) n)) */
SELECT COUNT(*) FROM title as t,
kind_type as kt,
info_type as it1,
movie_info as mi1,
movie_info as mi2,
info_type as it2,
cast_info as ci,
role_type as rt,
name as n
WHERE
t.id = ci.movie_id
AND t.id = mi1.movie_id
AND t.id = mi2.movie_id
AND mi1.movie_id = mi2.movie_id
AND mi1.info_type_id = it1.id
AND mi2.info_type_id = it2.id
AND (it1.id in ('1'))
AND (it2.id in ('3'))
AND t.kind_id = kt.id
AND ci.person_id = n.id
AND ci.role_id = rt.id
AND (mi1.info IN ('55','6','86','USA:50','USA:95'))
AND (mi2.info IN ('Action','Biography','Comedy','Documentary','Film-Noir','History','Mystery','Romance','Short','Thriller'))
AND (kt.kind in ('episode','movie','tv series','video game','video movie'))
AND (rt.role in ('director','guest','miscellaneous crew'))
AND (n.gender IN ('m'))
AND (t.production_year <= 1975)
AND (t.production_year >= 1875)
AND (t.title in ('(#1.72)','(#3.2)','(#3.23)','(#5.4)','(#6.4)','A Place in the Sun','Blind Spot','Brotherly Love','Countdown','Der Raub der Sabinerinnen','Diane','Eyewitness','False Witness','Florian','Fury','Gasparone','Golden Boy','Lilith','Martha','One Foot in Heaven','Perfect Strangers','Reckless','Shine on Harvest Moon','Stingaree','Take Me Out to the Ball Game','The Appointment','The Comeback','The Engagement','The Fanatics','The Feud','The Good Samaritan','The Great Ziegfeld','The Hoodlum Saint','The Raven','The Women','War and Peace','With a Song in My Heart'))


-- 3a1.sql
/*+ NestedLoop(rt ct k mk t kt mc cn ci n)
 NestedLoop(rt ct k mk t kt mc cn ci)
 NestedLoop(ct k mk t kt mc cn ci)
 NestedLoop(ct k mk t kt mc cn)
 NestedLoop(ct k mk t kt mc)
 NestedLoop(k mk t kt mc)
 NestedLoop(k mk t kt)
 NestedLoop(k mk t)
 NestedLoop(k mk)
 SeqScan(rt)
 SeqScan(ct)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(t)
 SeqScan(kt)
 IndexScan(mc)
 IndexScan(cn)
 IndexScan(ci)
 IndexScan(n)
 Leading(((rt (((ct ((((k mk) t) kt) mc)) cn) ci)) n)) */
SELECT COUNT(*) FROM title as t,
movie_keyword as mk, keyword as k,
movie_companies as mc, company_name as cn,
company_type as ct, kind_type as kt,
cast_info as ci, name as n, role_type as rt
WHERE t.id = mk.movie_id
AND t.id = mc.movie_id
AND t.id = ci.movie_id
AND ci.movie_id = mc.movie_id
AND ci.movie_id = mk.movie_id
AND mk.movie_id = mc.movie_id
AND k.id = mk.keyword_id
AND cn.id = mc.company_id
AND ct.id = mc.company_type_id
AND kt.id = t.kind_id
AND ci.person_id = n.id
AND ci.role_id = rt.id
AND t.production_year <= 2015
AND 1925 < t.production_year
AND k.keyword IN ('bare-chested-male','doctor','flashback','husband-wife-relationship','interview','jealousy','kidnapping','lesbian','mother-daughter-relationship','murder','tv-mini-series')
AND cn.country_code IN ('[co]')
AND ct.kind IN ('production companies')
AND kt.kind IN ('tv movie','tv series','video game')
AND rt.role IN ('producer')
AND n.gender IN ('m')


-- 3a12.sql
/*+ NestedLoop(k mk t kt mc ct cn ci rt n)
 NestedLoop(k mk t kt mc ct cn ci rt)
 NestedLoop(k mk t kt mc ct cn ci)
 NestedLoop(k mk t kt mc ct cn)
 NestedLoop(k mk t kt mc ct)
 NestedLoop(k mk t kt mc)
 NestedLoop(k mk t kt)
 NestedLoop(k mk t)
 NestedLoop(k mk)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(t)
 SeqScan(kt)
 IndexScan(mc)
 SeqScan(ct)
 IndexScan(cn)
 IndexScan(ci)
 SeqScan(rt)
 IndexScan(n)
 Leading((((((((((k mk) t) kt) mc) ct) cn) ci) rt) n)) */
SELECT COUNT(*) FROM title as t,
movie_keyword as mk, keyword as k,
movie_companies as mc, company_name as cn,
company_type as ct, kind_type as kt,
cast_info as ci, name as n, role_type as rt
WHERE t.id = mk.movie_id
AND t.id = mc.movie_id
AND t.id = ci.movie_id
AND ci.movie_id = mc.movie_id
AND ci.movie_id = mk.movie_id
AND mk.movie_id = mc.movie_id
AND k.id = mk.keyword_id
AND cn.id = mc.company_id
AND ct.id = mc.company_type_id
AND kt.id = t.kind_id
AND ci.person_id = n.id
AND ci.role_id = rt.id
AND (t.production_year <= 1990)
AND (t.production_year >= 1950)
AND (k.keyword IN ('blood','doctor','flashback','friendship','gun','hardcore','husband-wife-relationship','interview','jealousy','lesbian','lesbian-sex','mother-son-relationship','new-york-city','tv-mini-series'))
AND (cn.country_code IN ('[bg]','[cl]','[cz]','[il]','[lb]','[lu]','[mx]'))
AND (ct.kind IN ('distributors','production companies'))
AND (kt.kind IN ('tv series','video game','video movie'))
AND (rt.role IN ('costume designer','writer'))
AND (n.gender IN ('f'))


-- 3a21.sql
/*+ NestedLoop(rt ct k mk t kt mc cn ci n)
 NestedLoop(rt ct k mk t kt mc cn ci)
 NestedLoop(ct k mk t kt mc cn ci)
 NestedLoop(ct k mk t kt mc cn)
 NestedLoop(ct k mk t kt mc)
 NestedLoop(k mk t kt mc)
 NestedLoop(k mk t kt)
 NestedLoop(k mk t)
 NestedLoop(k mk)
 SeqScan(rt)
 SeqScan(ct)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(t)
 SeqScan(kt)
 IndexScan(mc)
 IndexScan(cn)
 IndexScan(ci)
 IndexScan(n)
 Leading(((rt (((ct ((((k mk) t) kt) mc)) cn) ci)) n)) */
SELECT COUNT(*) FROM title as t,
movie_keyword as mk, keyword as k,
movie_companies as mc, company_name as cn,
company_type as ct, kind_type as kt,
cast_info as ci, name as n, role_type as rt
WHERE t.id = mk.movie_id
AND t.id = mc.movie_id
AND t.id = ci.movie_id
AND ci.movie_id = mc.movie_id
AND ci.movie_id = mk.movie_id
AND mk.movie_id = mc.movie_id
AND k.id = mk.keyword_id
AND cn.id = mc.company_id
AND ct.id = mc.company_type_id
AND kt.id = t.kind_id
AND ci.person_id = n.id
AND ci.role_id = rt.id
AND t.production_year <= 2015
AND 1900 < t.production_year
AND k.keyword IN ('commerce-department','fort-lauderdale-florida','street-name','uttar-pradesh','victim-support')
AND cn.country_code IN ('[gr]','[sg]')
AND ct.kind IN ('distributors')
AND kt.kind IN ('episode','movie','video movie')
AND rt.role IN ('production designer')
AND n.gender IN ('m')


-- 3a28.sql
/*+ NestedLoop(k mk t kt mc ct cn ci rt n)
 NestedLoop(k mk t kt mc ct cn ci rt)
 NestedLoop(k mk t kt mc ct cn ci)
 NestedLoop(k mk t kt mc ct cn)
 NestedLoop(k mk t kt mc ct)
 NestedLoop(k mk t kt mc)
 NestedLoop(k mk t kt)
 NestedLoop(k mk t)
 NestedLoop(k mk)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(t)
 SeqScan(kt)
 IndexScan(mc)
 SeqScan(ct)
 IndexScan(cn)
 IndexScan(ci)
 SeqScan(rt)
 IndexScan(n)
 Leading((((((((((k mk) t) kt) mc) ct) cn) ci) rt) n)) */
SELECT COUNT(*) FROM title as t,
movie_keyword as mk, keyword as k,
movie_companies as mc, company_name as cn,
company_type as ct, kind_type as kt,
cast_info as ci, name as n, role_type as rt
WHERE t.id = mk.movie_id
AND t.id = mc.movie_id
AND t.id = ci.movie_id
AND ci.movie_id = mc.movie_id
AND ci.movie_id = mk.movie_id
AND mk.movie_id = mc.movie_id
AND k.id = mk.keyword_id
AND cn.id = mc.company_id
AND ct.id = mc.company_type_id
AND kt.id = t.kind_id
AND ci.person_id = n.id
AND ci.role_id = rt.id
AND (t.production_year <= 2015)
AND (t.production_year >= 1975)
AND (k.keyword IN ('ambergris','girl-in-a-bikini','head-bash','nomadic','reference-to-mickey-mouse'))
AND (cn.country_code IN ('[ch]','[hk]','[ie]','[ph]','[pl]','[xyu]'))
AND (ct.kind IN ('distributors','production companies'))
AND (kt.kind IN ('episode','movie'))
AND (rt.role IN ('costume designer','production designer'))
AND (n.gender IN ('m'))


-- 3a43.sql
/*+ NestedLoop(ct k mk t kt mc cn ci rt n)
 NestedLoop(ct k mk t kt mc cn ci rt)
 NestedLoop(ct k mk t kt mc cn ci)
 NestedLoop(ct k mk t kt mc cn)
 NestedLoop(ct k mk t kt mc)
 NestedLoop(k mk t kt mc)
 NestedLoop(k mk t kt)
 NestedLoop(k mk t)
 NestedLoop(k mk)
 SeqScan(ct)
 SeqScan(k)
 IndexScan(mk)
 IndexScan(t)
 SeqScan(kt)
 IndexScan(mc)
 IndexScan(cn)
 IndexScan(ci)
 SeqScan(rt)
 IndexScan(n)
 Leading((((((ct ((((k mk) t) kt) mc)) cn) ci) rt) n)) */
SELECT COUNT(*) FROM title as t,
movie_keyword as mk, keyword as k,
movie_companies as mc, company_name as cn,
company_type as ct, kind_type as kt,
cast_info as ci, name as n, role_type as rt
WHERE t.id = mk.movie_id
AND t.id = mc.movie_id
AND t.id = ci.movie_id
AND ci.movie_id = mc.movie_id
AND ci.movie_id = mk.movie_id
AND mk.movie_id = mc.movie_id
AND k.id = mk.keyword_id
AND cn.id = mc.company_id
AND ct.id = mc.company_type_id
AND kt.id = t.kind_id
AND ci.person_id = n.id
AND ci.role_id = rt.id
AND t.production_year <= 1990
AND 1950 < t.production_year
AND k.keyword IN ('blood','death','flashback','interview','lesbian','non-fiction','oral-sex')
AND cn.country_code IN ('[cn]')
AND ct.kind IN ('production companies')
AND kt.kind IN ('episode','movie','tv movie')
AND rt.role IN ('actress','producer')
AND n.gender IN ('f')


-- 3b10.sql
/*+ NestedLoop(t kt mk mc cn ci rt n k ct)
 NestedLoop(t kt mk mc cn ci rt n k)
 NestedLoop(t kt mk mc cn ci rt n)
 HashJoin(t kt mk mc cn ci rt)
 NestedLoop(t kt mk mc cn ci)
 NestedLoop(t kt mk mc cn)
 NestedLoop(t kt mk mc)
 NestedLoop(t kt mk)
 HashJoin(t kt)
 SeqScan(t)
 SeqScan(kt)
 IndexScan(mk)
 IndexScan(mc)
 IndexScan(cn)
 IndexScan(ci)
 SeqScan(rt)
 IndexScan(n)
 IndexOnlyScan(k)
 IndexOnlyScan(ct)
 Leading((((((((((t kt) mk) mc) cn) ci) rt) n) k) ct)) */
SELECT t.title, n.name, cn.name, COUNT(*)
FROM title as t,
movie_keyword as mk,
keyword as k,
movie_companies as mc,
company_name as cn,
company_type as ct,
kind_type as kt,
cast_info as ci,
name as n,
role_type as rt
WHERE t.id = mk.movie_id
AND t.id = mc.movie_id
AND t.id = ci.movie_id
AND ci.movie_id = mc.movie_id
AND ci.movie_id = mk.movie_id
AND mk.movie_id = mc.movie_id
AND k.id = mk.keyword_id
AND cn.id = mc.company_id
AND ct.id = mc.company_type_id
AND kt.id = t.kind_id
AND ci.person_id = n.id
AND ci.role_id = rt.id
AND (t.title ILIKE '%hir%')
AND (n.name_pcode_nf ILIKE '%m%')
AND (cn.name ILIKE '%pic%')
AND (kt.kind IN ('episode','movie','tv series','video game','video movie'))
AND (rt.role IN ('costume designer','miscellaneous crew','producer'))
GROUP BY t.title, n.name, cn.name
ORDER BY COUNT(*) DESC


-- 3b14.sql
/*+ NestedLoop(cn mc t mk ci rt n k ct kt)
 NestedLoop(cn mc t mk ci rt n k ct)
 NestedLoop(cn mc t mk ci rt n k)
 NestedLoop(cn mc t mk ci rt n)
 NestedLoop(cn mc t mk ci rt)
 NestedLoop(cn mc t mk ci)
 NestedLoop(cn mc t mk)
 NestedLoop(cn mc t)
 NestedLoop(cn mc)
 SeqScan(cn)
 IndexScan(mc)
 IndexScan(t)
 IndexScan(mk)
 IndexScan(ci)
 IndexScan(rt)
 IndexScan(n)
 IndexOnlyScan(k)
 IndexOnlyScan(ct)
 IndexScan(kt)
 Leading((((((((((cn mc) t) mk) ci) rt) n) k) ct) kt)) */
SELECT t.title, n.name, cn.name, COUNT(*)
FROM title as t,
movie_keyword as mk,
keyword as k,
movie_companies as mc,
company_name as cn,
company_type as ct,
kind_type as kt,
cast_info as ci,
name as n,
role_type as rt
WHERE t.id = mk.movie_id
AND t.id = mc.movie_id
AND t.id = ci.movie_id
AND ci.movie_id = mc.movie_id
AND ci.movie_id = mk.movie_id
AND mk.movie_id = mc.movie_id
AND k.id = mk.keyword_id
AND cn.id = mc.company_id
AND ct.id = mc.company_type_id
AND kt.id = t.kind_id
AND ci.person_id = n.id
AND ci.role_id = rt.id
AND (t.title ILIKE '%10.%')
AND (n.surname_pcode ILIKE '%m4%')
AND (cn.name ILIKE '%cb%')
AND (kt.kind IN ('episode','movie'))
AND (rt.role IN ('miscellaneous crew','producer','production designer','writer'))
GROUP BY t.title, n.name, cn.name
ORDER BY COUNT(*) DESC


-- 3b4.sql
/*+ NestedLoop(t kt mc cn ci rt n ct mk k)
 NestedLoop(t kt mc cn ci rt n ct mk)
 NestedLoop(t kt mc cn ci rt n ct)
 NestedLoop(t kt mc cn ci rt n)
 HashJoin(t kt mc cn ci rt)
 NestedLoop(t kt mc cn ci)
 HashJoin(t kt mc cn)
 NestedLoop(t kt mc)
 HashJoin(t kt)
 SeqScan(t)
 SeqScan(kt)
 IndexScan(mc)
 SeqScan(cn)
 IndexScan(ci)
 SeqScan(rt)
 IndexScan(n)
 IndexOnlyScan(ct)
 IndexScan(mk)
 IndexOnlyScan(k)
 Leading((((((((((t kt) mc) cn) ci) rt) n) ct) mk) k)) */
SELECT t.title, n.name, cn.name, COUNT(*)
FROM title as t,
movie_keyword as mk,
keyword as k,
movie_companies as mc,
company_name as cn,
company_type as ct,
kind_type as kt,
cast_info as ci,
name as n,
role_type as rt
WHERE t.id = mk.movie_id
AND t.id = mc.movie_id
AND t.id = ci.movie_id
AND ci.movie_id = mc.movie_id
AND ci.movie_id = mk.movie_id
AND mk.movie_id = mc.movie_id
AND k.id = mk.keyword_id
AND cn.id = mc.company_id
AND ct.id = mc.company_type_id
AND kt.id = t.kind_id
AND ci.person_id = n.id
AND ci.role_id = rt.id
AND (t.title ILIKE '%ho%')
AND (n.surname_pcode ILIKE '%k34%')
AND (cn.name ILIKE '%h%')
AND (kt.kind IN ('episode','tv movie','tv series','video game','video movie'))
AND (rt.role IN ('actor','actress','cinematographer','composer','costume designer','director','editor','miscellaneous crew','producer','writer'))
GROUP BY t.title, n.name, cn.name
ORDER BY COUNT(*) DESC


-- 3b5.sql
/*+ NestedLoop(t kt mk mc cn ci rt n k ct)
 NestedLoop(t kt mk mc cn ci rt n k)
 NestedLoop(t kt mk mc cn ci rt n)
 HashJoin(t kt mk mc cn ci rt)
 NestedLoop(t kt mk mc cn ci)
 NestedLoop(t kt mk mc cn)
 NestedLoop(t kt mk mc)
 NestedLoop(t kt mk)
 HashJoin(t kt)
 SeqScan(t)
 SeqScan(kt)
 IndexScan(mk)
 IndexScan(mc)
 IndexScan(cn)
 IndexScan(ci)
 SeqScan(rt)
 IndexScan(n)
 IndexOnlyScan(k)
 IndexOnlyScan(ct)
 Leading((((((((((t kt) mk) mc) cn) ci) rt) n) k) ct)) */
SELECT t.title, n.name, cn.name, COUNT(*)
FROM title as t,
movie_keyword as mk,
keyword as k,
movie_companies as mc,
company_name as cn,
company_type as ct,
kind_type as kt,
cast_info as ci,
name as n,
role_type as rt
WHERE t.id = mk.movie_id
AND t.id = mc.movie_id
AND t.id = ci.movie_id
AND ci.movie_id = mc.movie_id
AND ci.movie_id = mk.movie_id
AND mk.movie_id = mc.movie_id
AND k.id = mk.keyword_id
AND cn.id = mc.company_id
AND ct.id = mc.company_type_id
AND kt.id = t.kind_id
AND ci.person_id = n.id
AND ci.role_id = rt.id
AND (t.title ILIKE '%1997%')
AND (n.name_pcode_nf ILIKE '%d%')
AND (cn.name ILIKE '%wa%')
AND (kt.kind IN ('episode','movie','tv movie','video movie'))
AND (rt.role IN ('composer','producer','production designer','writer'))
GROUP BY t.title, n.name, cn.name
ORDER BY COUNT(*) DESC


-- 3b6.sql
/*+ NestedLoop(t kt mk mc cn ci rt n k ct)
 NestedLoop(t kt mk mc cn ci rt n k)
 NestedLoop(t kt mk mc cn ci rt n)
 HashJoin(t kt mk mc cn ci rt)
 NestedLoop(t kt mk mc cn ci)
 NestedLoop(t kt mk mc cn)
 NestedLoop(t kt mk mc)
 NestedLoop(t kt mk)
 HashJoin(t kt)
 SeqScan(t)
 SeqScan(kt)
 IndexScan(mk)
 IndexScan(mc)
 IndexScan(cn)
 IndexScan(ci)
 SeqScan(rt)
 IndexScan(n)
 IndexOnlyScan(k)
 IndexOnlyScan(ct)
 Leading((((((((((t kt) mk) mc) cn) ci) rt) n) k) ct)) */
SELECT t.title, n.name, cn.name, COUNT(*)
FROM title as t,
movie_keyword as mk,
keyword as k,
movie_companies as mc,
company_name as cn,
company_type as ct,
kind_type as kt,
cast_info as ci,
name as n,
role_type as rt
WHERE t.id = mk.movie_id
AND t.id = mc.movie_id
AND t.id = ci.movie_id
AND ci.movie_id = mc.movie_id
AND ci.movie_id = mk.movie_id
AND mk.movie_id = mc.movie_id
AND k.id = mk.keyword_id
AND cn.id = mc.company_id
AND ct.id = mc.company_type_id
AND kt.id = t.kind_id
AND ci.person_id = n.id
AND ci.role_id = rt.id
AND (t.title ILIKE '%spac%')
AND (n.surname_pcode ILIKE '%k61%')
AND (cn.name ILIKE '%th%')
AND (kt.kind IN ('episode','movie','tv movie','tv series'))
AND (rt.role IN ('actor','actress','miscellaneous crew','producer'))
GROUP BY t.title, n.name, cn.name
ORDER BY COUNT(*) DESC


-- 4a114.sql
/*+ NestedLoop(rt pi1 n an it1 ci)
 NestedLoop(pi1 n an it1 ci)
 NestedLoop(pi1 n an it1)
 NestedLoop(pi1 n an)
 NestedLoop(pi1 n)
 SeqScan(rt)
 IndexScan(pi1)
 IndexScan(n)
 IndexOnlyScan(an)
 SeqScan(it1)
 IndexScan(ci)
 Leading((rt ((((pi1 n) an) it1) ci))) */
SELECT COUNT(*)
FROM
name as n,
aka_name as an,
info_type as it1,
person_info as pi1,
cast_info as ci,
role_type as rt
WHERE
n.id = ci.person_id
AND ci.person_id = pi1.person_id
AND it1.id = pi1.info_type_id
AND n.id = pi1.person_id
AND n.id = an.person_id
AND ci.person_id = an.person_id
AND an.person_id = pi1.person_id
AND rt.id = ci.role_id
AND (n.gender in ('m'))
AND (n.name_pcode_nf in ('A4524','E3632','G1641','G6212','J236','J265','J5213','J5215','J5254','J5635','M6265','N2421','N2423','P3632','W4524'))
AND (ci.note IS NULL)
AND (rt.role in ('actor'))
AND (it1.id in ('31'))


-- 4a144.sql
/*+ NestedLoop(it1 pi1 n an ci rt)
 HashJoin(pi1 n an ci rt)
 NestedLoop(pi1 n an ci)
 NestedLoop(pi1 n an)
 NestedLoop(pi1 n)
 SeqScan(it1)
 SeqScan(pi1)
 IndexScan(n)
 IndexOnlyScan(an)
 IndexScan(ci)
 SeqScan(rt)
 Leading((it1 ((((pi1 n) an) ci) rt))) */
SELECT COUNT(*)
FROM
name as n,
aka_name as an,
info_type as it1,
person_info as pi1,
cast_info as ci,
role_type as rt
WHERE
n.id = ci.person_id
AND ci.person_id = pi1.person_id
AND it1.id = pi1.info_type_id
AND n.id = pi1.person_id
AND n.id = an.person_id
AND ci.person_id = an.person_id
AND an.person_id = pi1.person_id
AND rt.id = ci.role_id
AND (n.gender in ('f','m'))
AND (n.name_pcode_nf in ('A426','B62','C425','D5412','D6251','E2526','G6354','H424','H6156','J5214','K6235','L2426','N3141','O3165','R2145','V4321','V652') OR n.name_pcode_nf IS NULL)
AND (ci.note in ('(credit only)','(executive producer)') OR ci.note IS NULL)
AND (rt.role in ('actor','actress','editor','producer'))
AND (it1.id in ('32'))


-- 4a220.sql
/*+ NestedLoop(it1 n an pi1 ci rt)
 HashJoin(n an pi1 ci rt)
 NestedLoop(n an pi1 ci)
 NestedLoop(n an pi1)
 NestedLoop(n an)
 SeqScan(it1)
 SeqScan(n)
 IndexOnlyScan(an)
 IndexScan(pi1)
 IndexScan(ci)
 SeqScan(rt)
 Leading((it1 ((((n an) pi1) ci) rt))) */
SELECT COUNT(*)
FROM
name as n,
aka_name as an,
info_type as it1,
person_info as pi1,
cast_info as ci,
role_type as rt
WHERE
n.id = ci.person_id
AND ci.person_id = pi1.person_id
AND it1.id = pi1.info_type_id
AND n.id = pi1.person_id
AND n.id = an.person_id
AND ci.person_id = an.person_id
AND an.person_id = pi1.person_id
AND rt.id = ci.role_id
AND (n.gender in ('f'))
AND (n.name_pcode_nf in ('A1654','A2362','A4252','A5263','B6462','D235','D5464','E6246','H2425','J2432','K6523','K6532','L16','L5342','M415','N5236','P4125','P6545','S35','S6235','W53','Z4261'))
AND (ci.note in ('(as Linda Lacoste)','(credit only)','(dancer: title sequence)','(script supervisor)','(voice)') OR ci.note IS NULL)
AND (rt.role in ('actress','miscellaneous crew'))
AND (it1.id in ('22'))


-- 4a279.sql
/*+ NestedLoop(it1 an n pi1 ci rt)
 HashJoin(an n pi1 ci rt)
 NestedLoop(an n pi1 ci)
 NestedLoop(an n pi1)
 HashJoin(an n)
 SeqScan(it1)
 SeqScan(an)
 SeqScan(n)
 IndexScan(pi1)
 IndexScan(ci)
 SeqScan(rt)
 Leading((it1 ((((an n) pi1) ci) rt))) */
SELECT COUNT(*)
FROM
name as n,
aka_name as an,
info_type as it1,
person_info as pi1,
cast_info as ci,
role_type as rt
WHERE
n.id = ci.person_id
AND ci.person_id = pi1.person_id
AND it1.id = pi1.info_type_id
AND n.id = pi1.person_id
AND n.id = an.person_id
AND ci.person_id = an.person_id
AND an.person_id = pi1.person_id
AND rt.id = ci.role_id
AND (n.gender in ('m'))
AND (n.name_pcode_nf in ('A3525','A6361','C4562','D6424','F6535','G5356','G6212','I2652','J1435','J164','J5365','J6354','K3261','K6434','M253','M6216','M6252','P3626','P4126','P4546','R1424','R146','T252','T5414') OR n.name_pcode_nf IS NULL)
AND (ci.note in ('(executive producer)','(executive producer: Williams Street)','(supervising producer)','(uncredited)','(voice)') OR ci.note IS NULL)
AND (rt.role in ('actor','composer','director','producer'))
AND (it1.id in ('37'))


-- 4a86.sql
/*+ NestedLoop(it1 an n pi1 ci rt)
 HashJoin(an n pi1 ci rt)
 NestedLoop(an n pi1 ci)
 NestedLoop(an n pi1)
 HashJoin(an n)
 SeqScan(it1)
 SeqScan(an)
 SeqScan(n)
 IndexScan(pi1)
 IndexScan(ci)
 SeqScan(rt)
 Leading((it1 ((((an n) pi1) ci) rt))) */
SELECT COUNT(*)
FROM
name as n,
aka_name as an,
info_type as it1,
person_info as pi1,
cast_info as ci,
role_type as rt
WHERE
n.id = ci.person_id
AND ci.person_id = pi1.person_id
AND it1.id = pi1.info_type_id
AND n.id = pi1.person_id
AND n.id = an.person_id
AND ci.person_id = an.person_id
AND an.person_id = pi1.person_id
AND rt.id = ci.role_id
AND (n.gender in ('f','m') OR n.gender IS NULL)
AND (n.name_pcode_nf in ('A5625','B6162','C6215','C6231','D5256','J2124','J2353','J5216','K3652','P425','S5326') OR n.name_pcode_nf IS NULL)
AND (ci.note in ('(archive footage)') OR ci.note IS NULL)
AND (rt.role in ('actor','actress','cinematographer','director'))
AND (it1.id in ('37'))


-- 5a2.sql
/*+ NestedLoop(mii2 mii1 t mk mi1 kt it1 it3 it4 k)
 NestedLoop(mii2 mii1 t mk mi1 kt it1 it3 it4)
 NestedLoop(mii2 mii1 t mk mi1 kt it1 it3)
 NestedLoop(mii2 mii1 t mk mi1 kt it1)
 NestedLoop(mii2 mii1 t mk mi1 kt)
 NestedLoop(mii2 mii1 t mk mi1)
 NestedLoop(mii2 mii1 t mk)
 NestedLoop(mii2 mii1 t)
 NestedLoop(mii2 mii1)
 SeqScan(mii2)
 IndexScan(mii1)
 IndexScan(t)
 IndexScan(mk)
 IndexScan(mi1)
 IndexScan(kt)
 IndexOnlyScan(it1)
 SeqScan(it3)
 SeqScan(it4)
 IndexOnlyScan(k)
 Leading((((((((((mii2 mii1) t) mk) mi1) kt) it1) it3) it4) k)) */
SELECT COUNT(*)
FROM title as t,
movie_info as mi1,
kind_type as kt,
info_type as it1,
info_type as it3,
info_type as it4,
movie_info_idx as mii1,
movie_info_idx as mii2,
movie_keyword as mk,
keyword as k
WHERE
t.id = mi1.movie_id
AND t.id = mii1.movie_id
AND t.id = mii2.movie_id
AND t.id = mk.movie_id
AND mii2.movie_id = mii1.movie_id
AND mi1.movie_id = mii1.movie_id
AND mk.movie_id = mi1.movie_id
AND mk.keyword_id = k.id
AND mi1.info_type_id = it1.id
AND mii1.info_type_id = it3.id
AND mii2.info_type_id = it4.id
AND t.kind_id = kt.id
AND (kt.kind IN ('episode','movie'))
AND (t.production_year <= 1975)
AND (t.production_year >= 1925)
AND (mi1.info IN ('Finland:K-16','USA:Approved'))
AND (it1.id IN ('18','5'))
AND it3.id = '100'
AND it4.id = '101'
AND (mii2.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND mii2.info::float <= 9.0)
AND (mii2.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND 4.0 <= mii2.info::float)
AND (mii1.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND 0.0 <= mii1.info::float)
AND (mii1.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND mii1.info::float <= 1000.0)


-- 5a32.sql
/*+ NestedLoop(mii2 mii1 t mk mi1 kt it1 it3 it4 k)
 NestedLoop(mii2 mii1 t mk mi1 kt it1 it3 it4)
 NestedLoop(mii2 mii1 t mk mi1 kt it1 it3)
 NestedLoop(mii2 mii1 t mk mi1 kt it1)
 NestedLoop(mii2 mii1 t mk mi1 kt)
 NestedLoop(mii2 mii1 t mk mi1)
 NestedLoop(mii2 mii1 t mk)
 NestedLoop(mii2 mii1 t)
 NestedLoop(mii2 mii1)
 SeqScan(mii2)
 IndexScan(mii1)
 IndexScan(t)
 IndexScan(mk)
 IndexScan(mi1)
 IndexScan(kt)
 IndexOnlyScan(it1)
 SeqScan(it3)
 SeqScan(it4)
 IndexOnlyScan(k)
 Leading((((((((((mii2 mii1) t) mk) mi1) kt) it1) it3) it4) k)) */
SELECT COUNT(*)
FROM title as t,
movie_info as mi1,
kind_type as kt,
info_type as it1,
info_type as it3,
info_type as it4,
movie_info_idx as mii1,
movie_info_idx as mii2,
movie_keyword as mk,
keyword as k
WHERE
t.id = mi1.movie_id
AND t.id = mii1.movie_id
AND t.id = mii2.movie_id
AND t.id = mk.movie_id
AND mii2.movie_id = mii1.movie_id
AND mi1.movie_id = mii1.movie_id
AND mk.movie_id = mi1.movie_id
AND mk.keyword_id = k.id
AND mi1.info_type_id = it1.id
AND mii1.info_type_id = it3.id
AND mii2.info_type_id = it4.id
AND t.kind_id = kt.id
AND (kt.kind IN ('tv movie','tv series','video game'))
AND (t.production_year <= 2015)
AND (t.production_year >= 1975)
AND (mi1.info IN ('30'))
AND (it1.id IN ('1','16','5'))
AND it3.id = '100'
AND it4.id = '101'
AND (mii2.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND mii2.info::float <= 3.0)
AND (mii2.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND 2.0 <= mii2.info::float)
AND (mii1.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND 1000.0 <= mii1.info::float)
AND (mii1.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND mii1.info::float <= 10000.0)


-- 5a45.sql
/*+ NestedLoop(mii2 mii1 t mk mi1 kt it1 it3 it4 k)
 NestedLoop(mii2 mii1 t mk mi1 kt it1 it3 it4)
 NestedLoop(mii2 mii1 t mk mi1 kt it1 it3)
 NestedLoop(mii2 mii1 t mk mi1 kt it1)
 NestedLoop(mii2 mii1 t mk mi1 kt)
 NestedLoop(mii2 mii1 t mk mi1)
 NestedLoop(mii2 mii1 t mk)
 NestedLoop(mii2 mii1 t)
 NestedLoop(mii2 mii1)
 SeqScan(mii2)
 IndexScan(mii1)
 IndexScan(t)
 IndexScan(mk)
 IndexScan(mi1)
 IndexScan(kt)
 SeqScan(it1)
 SeqScan(it3)
 SeqScan(it4)
 IndexOnlyScan(k)
 Leading((((((((((mii2 mii1) t) mk) mi1) kt) it1) it3) it4) k)) */
SELECT COUNT(*)
FROM title as t,
movie_info as mi1,
kind_type as kt,
info_type as it1,
info_type as it3,
info_type as it4,
movie_info_idx as mii1,
movie_info_idx as mii2,
movie_keyword as mk,
keyword as k
WHERE
t.id = mi1.movie_id
AND t.id = mii1.movie_id
AND t.id = mii2.movie_id
AND t.id = mk.movie_id
AND mii2.movie_id = mii1.movie_id
AND mi1.movie_id = mii1.movie_id
AND mk.movie_id = mi1.movie_id
AND mk.keyword_id = k.id
AND mi1.info_type_id = it1.id
AND mii1.info_type_id = it3.id
AND mii2.info_type_id = it4.id
AND t.kind_id = kt.id
AND (kt.kind IN ('episode','movie'))
AND (t.production_year <= 1975)
AND (t.production_year >= 1925)
AND (mi1.info IN ('Animation','Comedy','Documentary','Drama'))
AND (it1.id IN ('3'))
AND it3.id = '100'
AND it4.id = '101'
AND (mii2.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND mii2.info::float <= 9.0)
AND (mii2.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND 4.0 <= mii2.info::float)
AND (mii1.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND 500.0 <= mii1.info::float)
AND (mii1.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND mii1.info::float <= 7200.0)


-- 5a56.sql
/*+ NestedLoop(mii2 mii1 t mk mi1 kt it1 it3 it4 k)
 NestedLoop(mii2 mii1 t mk mi1 kt it1 it3 it4)
 NestedLoop(mii2 mii1 t mk mi1 kt it1 it3)
 NestedLoop(mii2 mii1 t mk mi1 kt it1)
 NestedLoop(mii2 mii1 t mk mi1 kt)
 NestedLoop(mii2 mii1 t mk mi1)
 NestedLoop(mii2 mii1 t mk)
 NestedLoop(mii2 mii1 t)
 NestedLoop(mii2 mii1)
 SeqScan(mii2)
 IndexScan(mii1)
 IndexScan(t)
 IndexScan(mk)
 IndexScan(mi1)
 IndexScan(kt)
 SeqScan(it1)
 SeqScan(it3)
 SeqScan(it4)
 IndexOnlyScan(k)
 Leading((((((((((mii2 mii1) t) mk) mi1) kt) it1) it3) it4) k)) */
SELECT COUNT(*)
FROM title as t,
movie_info as mi1,
kind_type as kt,
info_type as it1,
info_type as it3,
info_type as it4,
movie_info_idx as mii1,
movie_info_idx as mii2,
movie_keyword as mk,
keyword as k
WHERE
t.id = mi1.movie_id
AND t.id = mii1.movie_id
AND t.id = mii2.movie_id
AND t.id = mk.movie_id
AND mii2.movie_id = mii1.movie_id
AND mi1.movie_id = mii1.movie_id
AND mk.movie_id = mi1.movie_id
AND mk.keyword_id = k.id
AND mi1.info_type_id = it1.id
AND mii1.info_type_id = it3.id
AND mii2.info_type_id = it4.id
AND t.kind_id = kt.id
AND (kt.kind IN ('tv series','video movie'))
AND (t.production_year <= 2015)
AND (t.production_year >= 1990)
AND (mi1.info IN ('Germany','Japan'))
AND (it1.id IN ('8'))
AND it3.id = '100'
AND it4.id = '101'
AND (mii2.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND mii2.info::float <= 8.3)
AND (mii2.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND 5.5 <= mii2.info::float)
AND (mii1.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND 10000.0 <= mii1.info::float)
AND (mii1.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND mii1.info::float <= 20000.0)


-- 5a68.sql
/*+ NestedLoop(mii2 mii1 t mk mi1 kt it1 it3 it4 k)
 NestedLoop(mii2 mii1 t mk mi1 kt it1 it3 it4)
 NestedLoop(mii2 mii1 t mk mi1 kt it1 it3)
 NestedLoop(mii2 mii1 t mk mi1 kt it1)
 NestedLoop(mii2 mii1 t mk mi1 kt)
 NestedLoop(mii2 mii1 t mk mi1)
 NestedLoop(mii2 mii1 t mk)
 NestedLoop(mii2 mii1 t)
 NestedLoop(mii2 mii1)
 SeqScan(mii2)
 IndexScan(mii1)
 IndexScan(t)
 IndexScan(mk)
 IndexScan(mi1)
 IndexScan(kt)
 IndexOnlyScan(it1)
 SeqScan(it3)
 SeqScan(it4)
 IndexOnlyScan(k)
 Leading((((((((((mii2 mii1) t) mk) mi1) kt) it1) it3) it4) k)) */
SELECT COUNT(*)
FROM title as t,
movie_info as mi1,
kind_type as kt,
info_type as it1,
info_type as it3,
info_type as it4,
movie_info_idx as mii1,
movie_info_idx as mii2,
movie_keyword as mk,
keyword as k
WHERE
t.id = mi1.movie_id
AND t.id = mii1.movie_id
AND t.id = mii2.movie_id
AND t.id = mk.movie_id
AND mii2.movie_id = mii1.movie_id
AND mi1.movie_id = mii1.movie_id
AND mk.movie_id = mi1.movie_id
AND mk.keyword_id = k.id
AND mi1.info_type_id = it1.id
AND mii1.info_type_id = it3.id
AND mii2.info_type_id = it4.id
AND t.kind_id = kt.id
AND (kt.kind IN ('movie'))
AND (t.production_year <= 1990)
AND (t.production_year >= 1950)
AND (mi1.info IN ('Canada','Mexico','Philippines','Soviet Union','Spain'))
AND (it1.id IN ('1','8'))
AND it3.id = '100'
AND it4.id = '101'
AND (mii2.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND mii2.info::float <= 8.3)
AND (mii2.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND 5.5 <= mii2.info::float)
AND (mii1.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND 500.0 <= mii1.info::float)
AND (mii1.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND mii1.info::float <= 7200.0)


-- 6a1.sql
/*+ NestedLoop(mii2 mii1 t ci rt mi1 pi1 kt it1 n it3 it4 an it5)
 NestedLoop(mii2 mii1 t ci rt mi1 pi1 kt it1 n it3 it4 an)
 NestedLoop(mii2 mii1 t ci rt mi1 pi1 kt it1 n it3 it4)
 NestedLoop(mii2 mii1 t ci rt mi1 pi1 kt it1 n it3)
 NestedLoop(mii2 mii1 t ci rt mi1 pi1 kt it1 n)
 NestedLoop(mii2 mii1 t ci rt mi1 pi1 kt it1)
 NestedLoop(mii2 mii1 t ci rt mi1 pi1 kt)
 NestedLoop(mii2 mii1 t ci rt mi1 pi1)
 NestedLoop(mii2 mii1 t ci rt mi1)
 NestedLoop(mii2 mii1 t ci rt)
 NestedLoop(mii2 mii1 t ci)
 NestedLoop(mii2 mii1 t)
 NestedLoop(mii2 mii1)
 SeqScan(mii2)
 IndexScan(mii1)
 IndexScan(t)
 IndexScan(ci)
 IndexScan(rt)
 IndexScan(mi1)
 IndexScan(pi1)
 IndexScan(kt)
 IndexOnlyScan(it1)
 IndexScan(n)
 SeqScan(it3)
 SeqScan(it4)
 IndexOnlyScan(an)
 SeqScan(it5)
 Leading((((((((((((((mii2 mii1) t) ci) rt) mi1) pi1) kt) it1) n) it3) it4) an) it5)) */
SELECT COUNT(*)
FROM title as t,
movie_info as mi1,
kind_type as kt,
info_type as it1,
info_type as it3,
info_type as it4,
movie_info_idx as mii1,
movie_info_idx as mii2,
aka_name as an,
name as n,
info_type as it5,
person_info as pi1,
cast_info as ci,
role_type as rt
WHERE
t.id = mi1.movie_id
AND t.id = ci.movie_id
AND t.id = mii1.movie_id
AND t.id = mii2.movie_id
AND mii2.movie_id = mii1.movie_id
AND mi1.movie_id = mii1.movie_id
AND mi1.info_type_id = it1.id
AND mii1.info_type_id = it3.id
AND mii2.info_type_id = it4.id
AND t.kind_id = kt.id
AND (kt.kind IN ('episode'))
AND (t.production_year <= 1975)
AND (t.production_year >= 1925)
AND (mi1.info IN ('USA'))
AND (it1.id IN ('17','8'))
AND it3.id = '100'
AND it4.id = '101'
AND (mii2.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND mii2.info::float <= 7.0)
AND (mii2.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND 3.0 <= mii2.info::float)
AND (mii1.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND 0.0 <= mii1.info::float)
AND (mii1.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND mii1.info::float <= 10000.0)
AND n.id = ci.person_id
AND ci.person_id = pi1.person_id
AND it5.id = pi1.info_type_id
AND n.id = pi1.person_id
AND n.id = an.person_id
AND ci.person_id = an.person_id
AND an.person_id = pi1.person_id
AND rt.id = ci.role_id
AND (n.gender in ('m'))
AND (n.name_pcode_nf in ('C6231','F6525','M6251','P3625','R1631','R1632','R1636','R2632'))
AND (ci.note IS NULL)
AND (rt.role in ('actor'))
AND (it5.id in ('25'))


-- 6a10.sql
/*+ NestedLoop(mii2 mii1 t ci rt mi1 an it1 pi1 kt it3 it4 n it5)
 NestedLoop(mii2 mii1 t ci rt mi1 an it1 pi1 kt it3 it4 n)
 NestedLoop(mii2 mii1 t ci rt mi1 an it1 pi1 kt it3 it4)
 NestedLoop(mii2 mii1 t ci rt mi1 an it1 pi1 kt it3)
 NestedLoop(mii2 mii1 t ci rt mi1 an it1 pi1 kt)
 NestedLoop(mii2 mii1 t ci rt mi1 an it1 pi1)
 NestedLoop(mii2 mii1 t ci rt mi1 an it1)
 NestedLoop(mii2 mii1 t ci rt mi1 an)
 NestedLoop(mii2 mii1 t ci rt mi1)
 NestedLoop(mii2 mii1 t ci rt)
 NestedLoop(mii2 mii1 t ci)
 NestedLoop(mii2 mii1 t)
 NestedLoop(mii2 mii1)
 SeqScan(mii2)
 IndexScan(mii1)
 IndexScan(t)
 IndexScan(ci)
 IndexScan(rt)
 IndexScan(mi1)
 IndexOnlyScan(an)
 IndexOnlyScan(it1)
 IndexScan(pi1)
 IndexScan(kt)
 SeqScan(it3)
 SeqScan(it4)
 IndexScan(n)
 SeqScan(it5)
 Leading((((((((((((((mii2 mii1) t) ci) rt) mi1) an) it1) pi1) kt) it3) it4) n) it5)) */
SELECT COUNT(*)
FROM title as t,
movie_info as mi1,
kind_type as kt,
info_type as it1,
info_type as it3,
info_type as it4,
movie_info_idx as mii1,
movie_info_idx as mii2,
aka_name as an,
name as n,
info_type as it5,
person_info as pi1,
cast_info as ci,
role_type as rt
WHERE
t.id = mi1.movie_id
AND t.id = ci.movie_id
AND t.id = mii1.movie_id
AND t.id = mii2.movie_id
AND mii2.movie_id = mii1.movie_id
AND mi1.movie_id = mii1.movie_id
AND mi1.info_type_id = it1.id
AND mii1.info_type_id = it3.id
AND mii2.info_type_id = it4.id
AND t.kind_id = kt.id
AND (kt.kind IN ('tv movie','video movie'))
AND (t.production_year <= 2015)
AND (t.production_year >= 1925)
AND (mi1.info IN ('90'))
AND (it1.id IN ('1','9'))
AND it3.id = '100'
AND it4.id = '101'
AND (mii2.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND mii2.info::float <= 8.0)
AND (mii2.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND 0.0 <= mii2.info::float)
AND (mii1.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND 0.0 <= mii1.info::float)
AND (mii1.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND mii1.info::float <= 1000.0)
AND n.id = ci.person_id
AND ci.person_id = pi1.person_id
AND it5.id = pi1.info_type_id
AND n.id = pi1.person_id
AND n.id = an.person_id
AND ci.person_id = an.person_id
AND an.person_id = pi1.person_id
AND rt.id = ci.role_id
AND (n.gender in ('m') OR n.gender IS NULL)
AND (n.name_pcode_nf in ('A4163','A4253','A5352','A5362','B6535','C6231','C6235','F6521','F6525','R1631','R1632','S3152') OR n.name_pcode_nf IS NULL)
AND (ci.note IS NULL)
AND (rt.role in ('actor'))
AND (it5.id in ('31'))


-- 6a7.sql
/*+ NestedLoop(mii2 mii1 t ci rt mi1 it1 n kt it3 it4 an pi1 it5)
 NestedLoop(mii2 mii1 t ci rt mi1 it1 n kt it3 it4 an pi1)
 NestedLoop(mii2 mii1 t ci rt mi1 it1 n kt it3 it4 an)
 NestedLoop(mii2 mii1 t ci rt mi1 it1 n kt it3 it4)
 NestedLoop(mii2 mii1 t ci rt mi1 it1 n kt it3)
 NestedLoop(mii2 mii1 t ci rt mi1 it1 n kt)
 NestedLoop(mii2 mii1 t ci rt mi1 it1 n)
 NestedLoop(mii2 mii1 t ci rt mi1 it1)
 NestedLoop(mii2 mii1 t ci rt mi1)
 NestedLoop(mii2 mii1 t ci rt)
 NestedLoop(mii2 mii1 t ci)
 NestedLoop(mii2 mii1 t)
 NestedLoop(mii2 mii1)
 SeqScan(mii2)
 IndexScan(mii1)
 IndexScan(t)
 IndexScan(ci)
 IndexScan(rt)
 IndexScan(mi1)
 IndexOnlyScan(it1)
 IndexScan(n)
 IndexScan(kt)
 SeqScan(it3)
 SeqScan(it4)
 IndexOnlyScan(an)
 IndexScan(pi1)
 SeqScan(it5)
 Leading((((((((((((((mii2 mii1) t) ci) rt) mi1) it1) n) kt) it3) it4) an) pi1) it5)) */
SELECT COUNT(*)
FROM title as t,
movie_info as mi1,
kind_type as kt,
info_type as it1,
info_type as it3,
info_type as it4,
movie_info_idx as mii1,
movie_info_idx as mii2,
aka_name as an,
name as n,
info_type as it5,
person_info as pi1,
cast_info as ci,
role_type as rt
WHERE
t.id = mi1.movie_id
AND t.id = ci.movie_id
AND t.id = mii1.movie_id
AND t.id = mii2.movie_id
AND mii2.movie_id = mii1.movie_id
AND mi1.movie_id = mii1.movie_id
AND mi1.info_type_id = it1.id
AND mii1.info_type_id = it3.id
AND mii2.info_type_id = it4.id
AND t.kind_id = kt.id
AND (kt.kind IN ('episode','movie'))
AND (t.production_year <= 2015)
AND (t.production_year >= 1925)
AND (mi1.info IN ('Dutch','English','Filipino','French','Hindi','Italian','Japanese','Portuguese','Spanish'))
AND (it1.id IN ('13','4'))
AND it3.id = '100'
AND it4.id = '101'
AND (mii2.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND mii2.info::float <= 7.0)
AND (mii2.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND 3.0 <= mii2.info::float)
AND (mii1.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND 5000.0 <= mii1.info::float)
AND (mii1.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND mii1.info::float <= 500000.0)
AND n.id = ci.person_id
AND ci.person_id = pi1.person_id
AND it5.id = pi1.info_type_id
AND n.id = pi1.person_id
AND n.id = an.person_id
AND ci.person_id = an.person_id
AND an.person_id = pi1.person_id
AND rt.id = ci.role_id
AND (n.gender in ('f'))
AND (n.name_pcode_nf in ('D5142','D52','E5252','J2152','J4524','K32','K452','L6526','M4252','M6215','M6325','M6515','N5252'))
AND (ci.note in ('(producer)','(voice)') OR ci.note IS NULL)
AND (rt.role in ('actress','producer'))
AND (it5.id in ('25'))


-- 6a8.sql
/*+ NestedLoop(mii2 mii1 t ci rt mi1 it1 pi1 an n kt it3 it4 it5)
 NestedLoop(mii2 mii1 t ci rt mi1 it1 pi1 an n kt it3 it4)
 NestedLoop(mii2 mii1 t ci rt mi1 it1 pi1 an n kt it3)
 NestedLoop(mii2 mii1 t ci rt mi1 it1 pi1 an n kt)
 NestedLoop(mii2 mii1 t ci rt mi1 it1 pi1 an n)
 NestedLoop(mii2 mii1 t ci rt mi1 it1 pi1 an)
 NestedLoop(mii2 mii1 t ci rt mi1 it1 pi1)
 NestedLoop(mii2 mii1 t ci rt mi1 it1)
 NestedLoop(mii2 mii1 t ci rt mi1)
 NestedLoop(mii2 mii1 t ci rt)
 NestedLoop(mii2 mii1 t ci)
 NestedLoop(mii2 mii1 t)
 NestedLoop(mii2 mii1)
 SeqScan(mii2)
 IndexScan(mii1)
 IndexScan(t)
 IndexScan(ci)
 IndexScan(rt)
 IndexScan(mi1)
 IndexOnlyScan(it1)
 IndexScan(pi1)
 IndexOnlyScan(an)
 IndexScan(n)
 IndexScan(kt)
 SeqScan(it3)
 SeqScan(it4)
 SeqScan(it5)
 Leading((((((((((((((mii2 mii1) t) ci) rt) mi1) it1) pi1) an) n) kt) it3) it4) it5)) */
SELECT COUNT(*)
FROM title as t,
movie_info as mi1,
kind_type as kt,
info_type as it1,
info_type as it3,
info_type as it4,
movie_info_idx as mii1,
movie_info_idx as mii2,
aka_name as an,
name as n,
info_type as it5,
person_info as pi1,
cast_info as ci,
role_type as rt
WHERE
t.id = mi1.movie_id
AND t.id = ci.movie_id
AND t.id = mii1.movie_id
AND t.id = mii2.movie_id
AND mii2.movie_id = mii1.movie_id
AND mi1.movie_id = mii1.movie_id
AND mi1.info_type_id = it1.id
AND mii1.info_type_id = it3.id
AND mii2.info_type_id = it4.id
AND t.kind_id = kt.id
AND (kt.kind IN ('episode','movie'))
AND (t.production_year <= 2015)
AND (t.production_year >= 1925)
AND (mi1.info IN ('CAM:Panavision Cameras and Lenses','LAB:Technicolor','MET:','OFM:16 mm','PCS:Digital Intermediate','PCS:Super 35','PFM:16 mm','RAT:1.66 : 1'))
AND (it1.id IN ('12','17','7'))
AND it3.id = '100'
AND it4.id = '101'
AND (mii2.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND mii2.info::float <= 5.0)
AND (mii2.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND 2.0 <= mii2.info::float)
AND (mii1.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND 0.0 <= mii1.info::float)
AND (mii1.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND mii1.info::float <= 1000.0)
AND n.id = ci.person_id
AND ci.person_id = pi1.person_id
AND it5.id = pi1.info_type_id
AND n.id = pi1.person_id
AND n.id = an.person_id
AND ci.person_id = an.person_id
AND an.person_id = pi1.person_id
AND rt.id = ci.role_id
AND (n.gender in ('f','m'))
AND (n.name_pcode_nf in ('A5164','B3625','B6352','C6232','C6436','D5241','F4126','F6536','G6342','L2524','M232','P4526','R5431','S5265','T5236'))
AND (ci.note in ('(voice)') OR ci.note IS NULL)
AND (rt.role in ('actor','actress'))
AND (it5.id in ('37'))


-- 6a9.sql
/*+ NestedLoop(mii2 mii1 t ci rt n mi1 kt it1 it3 it4 an pi1 it5)
 NestedLoop(mii2 mii1 t ci rt n mi1 kt it1 it3 it4 an pi1)
 NestedLoop(mii2 mii1 t ci rt n mi1 kt it1 it3 it4 an)
 NestedLoop(mii2 mii1 t ci rt n mi1 kt it1 it3 it4)
 NestedLoop(mii2 mii1 t ci rt n mi1 kt it1 it3)
 NestedLoop(mii2 mii1 t ci rt n mi1 kt it1)
 NestedLoop(mii2 mii1 t ci rt n mi1 kt)
 NestedLoop(mii2 mii1 t ci rt n mi1)
 NestedLoop(mii2 mii1 t ci rt n)
 NestedLoop(mii2 mii1 t ci rt)
 NestedLoop(mii2 mii1 t ci)
 NestedLoop(mii2 mii1 t)
 NestedLoop(mii2 mii1)
 SeqScan(mii2)
 IndexScan(mii1)
 IndexScan(t)
 IndexScan(ci)
 IndexScan(rt)
 IndexScan(n)
 IndexScan(mi1)
 IndexScan(kt)
 IndexOnlyScan(it1)
 SeqScan(it3)
 SeqScan(it4)
 IndexOnlyScan(an)
 IndexScan(pi1)
 SeqScan(it5)
 Leading((((((((((((((mii2 mii1) t) ci) rt) n) mi1) kt) it1) it3) it4) an) pi1) it5)) */
SELECT COUNT(*)
FROM title as t,
movie_info as mi1,
kind_type as kt,
info_type as it1,
info_type as it3,
info_type as it4,
movie_info_idx as mii1,
movie_info_idx as mii2,
aka_name as an,
name as n,
info_type as it5,
person_info as pi1,
cast_info as ci,
role_type as rt
WHERE
t.id = mi1.movie_id
AND t.id = ci.movie_id
AND t.id = mii1.movie_id
AND t.id = mii2.movie_id
AND mii2.movie_id = mii1.movie_id
AND mi1.movie_id = mii1.movie_id
AND mi1.info_type_id = it1.id
AND mii1.info_type_id = it3.id
AND mii2.info_type_id = it4.id
AND t.kind_id = kt.id
AND (kt.kind IN ('episode','movie'))
AND (t.production_year <= 2015)
AND (t.production_year >= 1975)
AND (mi1.info IN ('Argentina:16','Australia:PG','France:U','Germany:12','Germany:16','Iceland:16','South Korea:15','UK:PG','USA:PG','USA:PG-13'))
AND (it1.id IN ('103','5','6'))
AND it3.id = '100'
AND it4.id = '101'
AND (mii2.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND mii2.info::float <= 4.0)
AND (mii2.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND 0.0 <= mii2.info::float)
AND (mii1.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND 0.0 <= mii1.info::float)
AND (mii1.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND mii1.info::float <= 1000.0)
AND n.id = ci.person_id
AND ci.person_id = pi1.person_id
AND it5.id = pi1.info_type_id
AND n.id = pi1.person_id
AND n.id = an.person_id
AND ci.person_id = an.person_id
AND an.person_id = pi1.person_id
AND rt.id = ci.role_id
AND (n.gender IS NULL)
AND (n.name_pcode_nf in ('A5362','A6532','C5321','C6231','C6235','R5316') OR n.name_pcode_nf IS NULL)
AND (ci.note in ('(deviser)','(executive producer)','(producer)','(supervising producer)') OR ci.note IS NULL)
AND (rt.role in ('composer','director','editor','producer','writer'))
AND (it5.id in ('22'))


-- 7a1.sql
/*+ NestedLoop(mii2 mii1 t ci rt mi1 an it1 pi1 n kt it3 it4 mk k it5)
 NestedLoop(mii2 mii1 t ci rt mi1 an it1 pi1 n kt it3 it4 mk k)
 NestedLoop(mii2 mii1 t ci rt mi1 an it1 pi1 n kt it3 it4 mk)
 NestedLoop(mii2 mii1 t ci rt mi1 an it1 pi1 n kt it3 it4)
 NestedLoop(mii2 mii1 t ci rt mi1 an it1 pi1 n kt it3)
 NestedLoop(mii2 mii1 t ci rt mi1 an it1 pi1 n kt)
 NestedLoop(mii2 mii1 t ci rt mi1 an it1 pi1 n)
 NestedLoop(mii2 mii1 t ci rt mi1 an it1 pi1)
 NestedLoop(mii2 mii1 t ci rt mi1 an it1)
 NestedLoop(mii2 mii1 t ci rt mi1 an)
 NestedLoop(mii2 mii1 t ci rt mi1)
 NestedLoop(mii2 mii1 t ci rt)
 NestedLoop(mii2 mii1 t ci)
 NestedLoop(mii2 mii1 t)
 NestedLoop(mii2 mii1)
 SeqScan(mii2)
 IndexScan(mii1)
 IndexScan(t)
 IndexScan(ci)
 IndexScan(rt)
 IndexScan(mi1)
 IndexOnlyScan(an)
 IndexOnlyScan(it1)
 IndexScan(pi1)
 IndexScan(n)
 IndexScan(kt)
 SeqScan(it3)
 SeqScan(it4)
 IndexScan(mk)
 IndexOnlyScan(k)
 SeqScan(it5)
 Leading((((((((((((((((mii2 mii1) t) ci) rt) mi1) an) it1) pi1) n) kt) it3) it4) mk) k) it5)) */
SELECT COUNT(*)
FROM title as t,
movie_info as mi1,
kind_type as kt,
info_type as it1,
info_type as it3,
info_type as it4,
movie_info_idx as mii1,
movie_info_idx as mii2,
movie_keyword as mk,
keyword as k,
aka_name as an,
name as n,
info_type as it5,
person_info as pi1,
cast_info as ci,
role_type as rt
WHERE
t.id = mi1.movie_id
AND t.id = ci.movie_id
AND t.id = mii1.movie_id
AND t.id = mii2.movie_id
AND t.id = mk.movie_id
AND mk.keyword_id = k.id
AND mi1.info_type_id = it1.id
AND mii1.info_type_id = it3.id
AND mii2.info_type_id = it4.id
AND t.kind_id = kt.id
AND (kt.kind IN ('tv movie','video movie'))
AND (t.production_year <= 2015)
AND (t.production_year >= 1925)
AND (mi1.info IN ('OFM:35 mm','PFM:Video','RAT:1.33 : 1'))
AND (it1.id IN ('108','7'))
AND it3.id = '100'
AND it4.id = '101'
AND (mii2.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND mii2.info::float <= 7.0)
AND (mii2.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND 3.0 <= mii2.info::float)
AND (mii1.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND 1000.0 <= mii1.info::float)
AND (mii1.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND mii1.info::float <= 10000.0)
AND n.id = ci.person_id
AND ci.person_id = pi1.person_id
AND it5.id = pi1.info_type_id
AND n.id = pi1.person_id
AND n.id = an.person_id
AND rt.id = ci.role_id
AND (n.gender in ('m') OR n.gender IS NULL)
AND (n.name_pcode_nf in ('A4163','A5352','A5362','C6231','C6235','F6525','R1631','R1632','R2632','S3152') OR n.name_pcode_nf IS NULL)
AND (ci.note IS NULL)
AND (rt.role in ('actor'))
AND (it5.id in ('22'))


-- 7a3.sql
/*+ NestedLoop(mii2 mii1 t ci rt mi1 it1 pi1 n kt it3 it4 mk k an it5)
 NestedLoop(mii2 mii1 t ci rt mi1 it1 pi1 n kt it3 it4 mk k an)
 NestedLoop(mii2 mii1 t ci rt mi1 it1 pi1 n kt it3 it4 mk k)
 NestedLoop(mii2 mii1 t ci rt mi1 it1 pi1 n kt it3 it4 mk)
 NestedLoop(mii2 mii1 t ci rt mi1 it1 pi1 n kt it3 it4)
 NestedLoop(mii2 mii1 t ci rt mi1 it1 pi1 n kt it3)
 NestedLoop(mii2 mii1 t ci rt mi1 it1 pi1 n kt)
 NestedLoop(mii2 mii1 t ci rt mi1 it1 pi1 n)
 NestedLoop(mii2 mii1 t ci rt mi1 it1 pi1)
 NestedLoop(mii2 mii1 t ci rt mi1 it1)
 NestedLoop(mii2 mii1 t ci rt mi1)
 NestedLoop(mii2 mii1 t ci rt)
 NestedLoop(mii2 mii1 t ci)
 NestedLoop(mii2 mii1 t)
 NestedLoop(mii2 mii1)
 SeqScan(mii2)
 IndexScan(mii1)
 IndexScan(t)
 IndexScan(ci)
 IndexScan(rt)
 IndexScan(mi1)
 IndexOnlyScan(it1)
 IndexScan(pi1)
 IndexScan(n)
 IndexScan(kt)
 SeqScan(it3)
 SeqScan(it4)
 IndexScan(mk)
 IndexOnlyScan(k)
 IndexOnlyScan(an)
 SeqScan(it5)
 Leading((((((((((((((((mii2 mii1) t) ci) rt) mi1) it1) pi1) n) kt) it3) it4) mk) k) an) it5)) */
SELECT COUNT(*)
FROM title as t,
movie_info as mi1,
kind_type as kt,
info_type as it1,
info_type as it3,
info_type as it4,
movie_info_idx as mii1,
movie_info_idx as mii2,
movie_keyword as mk,
keyword as k,
aka_name as an,
name as n,
info_type as it5,
person_info as pi1,
cast_info as ci,
role_type as rt
WHERE
t.id = mi1.movie_id
AND t.id = ci.movie_id
AND t.id = mii1.movie_id
AND t.id = mii2.movie_id
AND t.id = mk.movie_id
AND mk.keyword_id = k.id
AND mi1.info_type_id = it1.id
AND mii1.info_type_id = it3.id
AND mii2.info_type_id = it4.id
AND t.kind_id = kt.id
AND (kt.kind IN ('episode','movie'))
AND (t.production_year <= 2015)
AND (t.production_year >= 1925)
AND (mi1.info IN ('15','5','9','Canada','France','Germany','India','Japan','Portugal','Soviet Union','UK','West Germany'))
AND (it1.id IN ('1','8','94'))
AND it3.id = '100'
AND it4.id = '101'
AND (mii2.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND mii2.info::float <= 4.0)
AND (mii2.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND 0.0 <= mii2.info::float)
AND (mii1.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND 0.0 <= mii1.info::float)
AND (mii1.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND mii1.info::float <= 1000.0)
AND n.id = ci.person_id
AND ci.person_id = pi1.person_id
AND it5.id = pi1.info_type_id
AND n.id = pi1.person_id
AND n.id = an.person_id
AND rt.id = ci.role_id
AND (n.gender in ('m'))
AND (n.name_pcode_nf in ('A4163','A5356','D5426','J2512','J5236','L24','M6265','N2421','R25','S3152','S5262','V2362'))
AND (ci.note in ('(executive producer)') OR ci.note IS NULL)
AND (rt.role in ('actor','producer'))
AND (it5.id in ('26'))


-- 7a4.sql
/*+ NestedLoop(mii2 mii1 t mk kt ci rt pi1 mi1 it1 it3 it4 k an n it5)
 NestedLoop(mii2 mii1 t mk kt ci rt pi1 mi1 it1 it3 it4 k an n)
 NestedLoop(mii2 mii1 t mk kt ci rt pi1 mi1 it1 it3 it4 k an)
 NestedLoop(mii2 mii1 t mk kt ci rt pi1 mi1 it1 it3 it4 k)
 NestedLoop(mii2 mii1 t mk kt ci rt pi1 mi1 it1 it3 it4)
 NestedLoop(mii2 mii1 t mk kt ci rt pi1 mi1 it1 it3)
 NestedLoop(mii2 mii1 t mk kt ci rt pi1 mi1 it1)
 NestedLoop(mii2 mii1 t mk kt ci rt pi1 mi1)
 NestedLoop(mii2 mii1 t mk kt ci rt pi1)
 HashJoin(mii2 mii1 t mk kt ci rt)
 NestedLoop(mii2 mii1 t mk kt ci)
 NestedLoop(mii2 mii1 t mk kt)
 NestedLoop(mii2 mii1 t mk)
 NestedLoop(mii2 mii1 t)
 NestedLoop(mii2 mii1)
 SeqScan(mii2)
 IndexScan(mii1)
 IndexScan(t)
 IndexScan(mk)
 IndexScan(kt)
 IndexScan(ci)
 SeqScan(rt)
 IndexScan(pi1)
 IndexScan(mi1)
 SeqScan(it1)
 SeqScan(it3)
 SeqScan(it4)
 IndexOnlyScan(k)
 IndexOnlyScan(an)
 IndexScan(n)
 SeqScan(it5)
 Leading((((((((((((((((mii2 mii1) t) mk) kt) ci) rt) pi1) mi1) it1) it3) it4) k) an) n) it5)) */
SELECT COUNT(*)
FROM title as t,
movie_info as mi1,
kind_type as kt,
info_type as it1,
info_type as it3,
info_type as it4,
movie_info_idx as mii1,
movie_info_idx as mii2,
movie_keyword as mk,
keyword as k,
aka_name as an,
name as n,
info_type as it5,
person_info as pi1,
cast_info as ci,
role_type as rt
WHERE
t.id = mi1.movie_id
AND t.id = ci.movie_id
AND t.id = mii1.movie_id
AND t.id = mii2.movie_id
AND t.id = mk.movie_id
AND mk.keyword_id = k.id
AND mi1.info_type_id = it1.id
AND mii1.info_type_id = it3.id
AND mii2.info_type_id = it4.id
AND t.kind_id = kt.id
AND (kt.kind IN ('movie'))
AND (t.production_year <= 1975)
AND (t.production_year >= 1875)
AND (mi1.info IN ('Silent'))
AND (it1.id IN ('6'))
AND it3.id = '100'
AND it4.id = '101'
AND (mii2.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND mii2.info::float <= 7.0)
AND (mii2.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND 3.0 <= mii2.info::float)
AND (mii1.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND 0.0 <= mii1.info::float)
AND (mii1.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND mii1.info::float <= 1000.0)
AND n.id = ci.person_id
AND ci.person_id = pi1.person_id
AND it5.id = pi1.info_type_id
AND n.id = pi1.person_id
AND n.id = an.person_id
AND rt.id = ci.role_id
AND (n.gender in ('f'))
AND (n.name_pcode_nf in ('M6263') OR n.name_pcode_nf IS NULL)
AND (ci.note IS NULL)
AND (rt.role in ('actress'))
AND (it5.id in ('32'))


-- 7a5.sql
/*+ NestedLoop(mii2 mii1 t mk ci rt mi1 kt it1 n it3 it4 k an pi1 it5)
 NestedLoop(mii2 mii1 t mk ci rt mi1 kt it1 n it3 it4 k an pi1)
 NestedLoop(mii2 mii1 t mk ci rt mi1 kt it1 n it3 it4 k an)
 NestedLoop(mii2 mii1 t mk ci rt mi1 kt it1 n it3 it4 k)
 NestedLoop(mii2 mii1 t mk ci rt mi1 kt it1 n it3 it4)
 NestedLoop(mii2 mii1 t mk ci rt mi1 kt it1 n it3)
 NestedLoop(mii2 mii1 t mk ci rt mi1 kt it1 n)
 NestedLoop(mii2 mii1 t mk ci rt mi1 kt it1)
 NestedLoop(mii2 mii1 t mk ci rt mi1 kt)
 NestedLoop(mii2 mii1 t mk ci rt mi1)
 HashJoin(mii2 mii1 t mk ci rt)
 NestedLoop(mii2 mii1 t mk ci)
 NestedLoop(mii2 mii1 t mk)
 NestedLoop(mii2 mii1 t)
 NestedLoop(mii2 mii1)
 SeqScan(mii2)
 IndexScan(mii1)
 IndexScan(t)
 IndexScan(mk)
 IndexScan(ci)
 SeqScan(rt)
 IndexScan(mi1)
 IndexScan(kt)
 IndexOnlyScan(it1)
 IndexScan(n)
 SeqScan(it3)
 SeqScan(it4)
 IndexOnlyScan(k)
 IndexOnlyScan(an)
 IndexScan(pi1)
 SeqScan(it5)
 Leading((((((((((((((((mii2 mii1) t) mk) ci) rt) mi1) kt) it1) n) it3) it4) k) an) pi1) it5)) */
SELECT COUNT(*)
FROM title as t,
movie_info as mi1,
kind_type as kt,
info_type as it1,
info_type as it3,
info_type as it4,
movie_info_idx as mii1,
movie_info_idx as mii2,
movie_keyword as mk,
keyword as k,
aka_name as an,
name as n,
info_type as it5,
person_info as pi1,
cast_info as ci,
role_type as rt
WHERE
t.id = mi1.movie_id
AND t.id = ci.movie_id
AND t.id = mii1.movie_id
AND t.id = mii2.movie_id
AND t.id = mk.movie_id
AND mk.keyword_id = k.id
AND mi1.info_type_id = it1.id
AND mii1.info_type_id = it3.id
AND mii2.info_type_id = it4.id
AND t.kind_id = kt.id
AND (kt.kind IN ('movie'))
AND (t.production_year <= 1975)
AND (t.production_year >= 1925)
AND (mi1.info IN ('Finland:S','UK:U','USA:Passed'))
AND (it1.id IN ('13','16','5'))
AND it3.id = '100'
AND it4.id = '101'
AND (mii2.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND mii2.info::float <= 5.0)
AND (mii2.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND 2.0 <= mii2.info::float)
AND (mii1.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND 1000.0 <= mii1.info::float)
AND (mii1.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND mii1.info::float <= 10000.0)
AND n.id = ci.person_id
AND ci.person_id = pi1.person_id
AND it5.id = pi1.info_type_id
AND n.id = pi1.person_id
AND n.id = an.person_id
AND rt.id = ci.role_id
AND (n.gender in ('f','m'))
AND (n.name_pcode_nf in ('A4163','A4253','A5352','A5362','E6523','F6521','F6525','M6263') OR n.name_pcode_nf IS NULL)
AND (ci.note in ('(uncredited)') OR ci.note IS NULL)
AND (rt.role in ('actor','actress'))
AND (it5.id in ('22'))


-- 7a7.sql
/*+ NestedLoop(mii2 mii1 t mk ci rt mi1 kt it1 pi1 n it3 it4 k an it5)
 NestedLoop(mii2 mii1 t mk ci rt mi1 kt it1 pi1 n it3 it4 k an)
 NestedLoop(mii2 mii1 t mk ci rt mi1 kt it1 pi1 n it3 it4 k)
 NestedLoop(mii2 mii1 t mk ci rt mi1 kt it1 pi1 n it3 it4)
 NestedLoop(mii2 mii1 t mk ci rt mi1 kt it1 pi1 n it3)
 NestedLoop(mii2 mii1 t mk ci rt mi1 kt it1 pi1 n)
 NestedLoop(mii2 mii1 t mk ci rt mi1 kt it1 pi1)
 NestedLoop(mii2 mii1 t mk ci rt mi1 kt it1)
 NestedLoop(mii2 mii1 t mk ci rt mi1 kt)
 NestedLoop(mii2 mii1 t mk ci rt mi1)
 HashJoin(mii2 mii1 t mk ci rt)
 NestedLoop(mii2 mii1 t mk ci)
 NestedLoop(mii2 mii1 t mk)
 NestedLoop(mii2 mii1 t)
 NestedLoop(mii2 mii1)
 SeqScan(mii2)
 IndexScan(mii1)
 IndexScan(t)
 IndexScan(mk)
 IndexScan(ci)
 SeqScan(rt)
 IndexScan(mi1)
 IndexScan(kt)
 IndexOnlyScan(it1)
 IndexScan(pi1)
 IndexScan(n)
 SeqScan(it3)
 SeqScan(it4)
 IndexOnlyScan(k)
 IndexOnlyScan(an)
 SeqScan(it5)
 Leading((((((((((((((((mii2 mii1) t) mk) ci) rt) mi1) kt) it1) pi1) n) it3) it4) k) an) it5)) */
SELECT COUNT(*)
FROM title as t,
movie_info as mi1,
kind_type as kt,
info_type as it1,
info_type as it3,
info_type as it4,
movie_info_idx as mii1,
movie_info_idx as mii2,
movie_keyword as mk,
keyword as k,
aka_name as an,
name as n,
info_type as it5,
person_info as pi1,
cast_info as ci,
role_type as rt
WHERE
t.id = mi1.movie_id
AND t.id = ci.movie_id
AND t.id = mii1.movie_id
AND t.id = mii2.movie_id
AND t.id = mk.movie_id
AND mk.keyword_id = k.id
AND mi1.info_type_id = it1.id
AND mii1.info_type_id = it3.id
AND mii2.info_type_id = it4.id
AND t.kind_id = kt.id
AND (kt.kind IN ('movie'))
AND (t.production_year <= 1975)
AND (t.production_year >= 1875)
AND (mi1.info IN ('MET:300 m','MET:600 m','PCS:Spherical','PFM:35 mm','RAT:1.33 : 1','USA:Approved'))
AND (it1.id IN ('103','5','7'))
AND it3.id = '100'
AND it4.id = '101'
AND (mii2.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND mii2.info::float <= 8.0)
AND (mii2.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND 0.0 <= mii2.info::float)
AND (mii1.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND 1000.0 <= mii1.info::float)
AND (mii1.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND mii1.info::float <= 10000.0)
AND n.id = ci.person_id
AND ci.person_id = pi1.person_id
AND it5.id = pi1.info_type_id
AND n.id = pi1.person_id
AND n.id = an.person_id
AND rt.id = ci.role_id
AND (n.gender in ('m'))
AND (n.name_pcode_nf in ('A4163','A5362','C6421','C6423','C6424','E6523','F6521','F6524','F6525','R1631','R1632') OR n.name_pcode_nf IS NULL)
AND (ci.note in ('(uncredited)') OR ci.note IS NULL)
AND (rt.role in ('actor'))
AND (it5.id in ('26'))


-- 8a3.sql
/*+ NestedLoop(cn mc ct t kt mi1 it1 mk ci rt n k)
 NestedLoop(cn mc ct t kt mi1 it1 mk ci rt n)
 NestedLoop(cn mc ct t kt mi1 it1 mk ci rt)
 NestedLoop(cn mc ct t kt mi1 it1 mk ci)
 NestedLoop(cn mc ct t kt mi1 it1 mk)
 NestedLoop(cn mc ct t kt mi1 it1)
 NestedLoop(cn mc ct t kt mi1)
 HashJoin(cn mc ct t kt)
 NestedLoop(cn mc ct t)
 HashJoin(cn mc ct)
 NestedLoop(cn mc)
 SeqScan(cn)
 IndexScan(mc)
 SeqScan(ct)
 IndexScan(t)
 SeqScan(kt)
 IndexScan(mi1)
 SeqScan(it1)
 IndexScan(mk)
 IndexScan(ci)
 IndexScan(rt)
 IndexScan(n)
 IndexOnlyScan(k)
 Leading((((((((((((cn mc) ct) t) kt) mi1) it1) mk) ci) rt) n) k)) */
SELECT COUNT(*) FROM title as t,
kind_type as kt,
info_type as it1,
movie_info as mi1,
cast_info as ci,
role_type as rt,
name as n,
movie_keyword as mk,
keyword as k,
movie_companies as mc,
company_type as ct,
company_name as cn
WHERE
t.id = ci.movie_id
AND t.id = mc.movie_id
AND t.id = mi1.movie_id
AND t.id = mk.movie_id
AND mc.company_type_id = ct.id
AND mc.company_id = cn.id
AND k.id = mk.keyword_id
AND mi1.info_type_id = it1.id
AND t.kind_id = kt.id
AND ci.person_id = n.id
AND ci.role_id = rt.id
AND (it1.id IN ('18'))
AND (mi1.info in ('CBS Television City - 7800 Beverly Blvd., Fairfax, Los Angeles, California, USA','Los Angeles, California, USA','Metro-Goldwyn-Mayer Studios - 10202 W. Washington Blvd., Culver City, California, USA'))
AND (kt.kind in ('episode','movie'))
AND (rt.role in ('actor','actress','producer'))
AND (n.gender in ('f','m') OR n.gender IS NULL)
AND (n.name_pcode_nf in ('A4163','C6231','C6235','C6421','F6525','J5215','J5216','J5425','M4145','R1632','R1634'))
AND (t.production_year <= 2015)
AND (t.production_year >= 1925)
AND (cn.name in ('Columbia Broadcasting System (CBS)','Fox Network','Independent Television (ITV)','Metro-Goldwyn-Mayer (MGM)','Shout! Factory','Sony Pictures Home Entertainment','Universal TV','Warner Bros'))
AND (ct.kind in ('distributors','production companies'))


-- 8a5.sql
/*+ NestedLoop(cn mc ct t kt mi1 mk ci rt it1 n k)
 NestedLoop(cn mc ct t kt mi1 mk ci rt it1 n)
 NestedLoop(cn mc ct t kt mi1 mk ci rt it1)
 NestedLoop(cn mc ct t kt mi1 mk ci rt)
 NestedLoop(cn mc ct t kt mi1 mk ci)
 NestedLoop(cn mc ct t kt mi1 mk)
 NestedLoop(cn mc ct t kt mi1)
 HashJoin(cn mc ct t kt)
 NestedLoop(cn mc ct t)
 HashJoin(cn mc ct)
 NestedLoop(cn mc)
 SeqScan(cn)
 IndexScan(mc)
 SeqScan(ct)
 IndexScan(t)
 SeqScan(kt)
 IndexScan(mi1)
 IndexScan(mk)
 IndexScan(ci)
 IndexScan(rt)
 SeqScan(it1)
 IndexScan(n)
 IndexOnlyScan(k)
 Leading((((((((((((cn mc) ct) t) kt) mi1) mk) ci) rt) it1) n) k)) */
SELECT COUNT(*) FROM title as t,
kind_type as kt,
info_type as it1,
movie_info as mi1,
cast_info as ci,
role_type as rt,
name as n,
movie_keyword as mk,
keyword as k,
movie_companies as mc,
company_type as ct,
company_name as cn
WHERE
t.id = ci.movie_id
AND t.id = mc.movie_id
AND t.id = mi1.movie_id
AND t.id = mk.movie_id
AND mc.company_type_id = ct.id
AND mc.company_id = cn.id
AND k.id = mk.keyword_id
AND mi1.info_type_id = it1.id
AND t.kind_id = kt.id
AND ci.person_id = n.id
AND ci.role_id = rt.id
AND (it1.id IN ('3'))
AND (mi1.info in ('Adventure','Comedy'))
AND (kt.kind in ('movie','tv series'))
AND (rt.role in ('actor','cinematographer'))
AND (n.gender in ('m'))
AND (n.surname_pcode in ('B24','C62','D12','D4','J25','M324','S23','S415','S5','S53') OR n.surname_pcode IS NULL)
AND (t.production_year <= 2015)
AND (t.production_year >= 1975)
AND (cn.name in ('American Broadcasting Company (ABC)','British Broadcasting Corporation (BBC)','Columbia Broadcasting System (CBS)','National Broadcasting Company (NBC)','Warner Home Video'))
AND (ct.kind in ('distributors','production companies'))


-- 8a6.sql
/*+ NestedLoop(cn mc ct t kt mi1 it1 mk ci rt n k)
 NestedLoop(cn mc ct t kt mi1 it1 mk ci rt n)
 NestedLoop(cn mc ct t kt mi1 it1 mk ci rt)
 NestedLoop(cn mc ct t kt mi1 it1 mk ci)
 NestedLoop(cn mc ct t kt mi1 it1 mk)
 NestedLoop(cn mc ct t kt mi1 it1)
 NestedLoop(cn mc ct t kt mi1)
 NestedLoop(cn mc ct t kt)
 NestedLoop(cn mc ct t)
 NestedLoop(cn mc ct)
 NestedLoop(cn mc)
 SeqScan(cn)
 IndexScan(mc)
 IndexScan(ct)
 IndexScan(t)
 IndexScan(kt)
 IndexScan(mi1)
 SeqScan(it1)
 IndexScan(mk)
 IndexScan(ci)
 IndexScan(rt)
 IndexScan(n)
 IndexOnlyScan(k)
 Leading((((((((((((cn mc) ct) t) kt) mi1) it1) mk) ci) rt) n) k)) */
SELECT COUNT(*) FROM title as t,
kind_type as kt,
info_type as it1,
movie_info as mi1,
cast_info as ci,
role_type as rt,
name as n,
movie_keyword as mk,
keyword as k,
movie_companies as mc,
company_type as ct,
company_name as cn
WHERE
t.id = ci.movie_id
AND t.id = mc.movie_id
AND t.id = mi1.movie_id
AND t.id = mk.movie_id
AND mc.company_type_id = ct.id
AND mc.company_id = cn.id
AND k.id = mk.keyword_id
AND mi1.info_type_id = it1.id
AND t.kind_id = kt.id
AND ci.person_id = n.id
AND ci.role_id = rt.id
AND (it1.id IN ('1'))
AND (mi1.info in ('30'))
AND (kt.kind in ('episode'))
AND (rt.role in ('miscellaneous crew'))
AND (n.gender in ('f') OR n.gender IS NULL)
AND (n.name_pcode_cf in ('A3654','B4353','B6156','C6264','D4253','D4262','L2562','L5326','M5323','R2461','S4362','S5236','S5245'))
AND (t.production_year <= 2015)
AND (t.production_year >= 1990)
AND (cn.name in ('ABS-CBN','American Broadcasting Company (ABC)','British Broadcasting Corporation (BBC)'))
AND (ct.kind in ('distributors','production companies'))


-- 8a8.sql
/*+ NestedLoop(cn mc ct t kt mk mi1 it1 ci rt n k)
 NestedLoop(cn mc ct t kt mk mi1 it1 ci rt n)
 NestedLoop(cn mc ct t kt mk mi1 it1 ci rt)
 NestedLoop(cn mc ct t kt mk mi1 it1 ci)
 NestedLoop(cn mc ct t kt mk mi1 it1)
 NestedLoop(cn mc ct t kt mk mi1)
 NestedLoop(cn mc ct t kt mk)
 NestedLoop(cn mc ct t kt)
 NestedLoop(cn mc ct t)
 NestedLoop(cn mc ct)
 NestedLoop(cn mc)
 SeqScan(cn)
 IndexScan(mc)
 IndexScan(ct)
 IndexScan(t)
 IndexScan(kt)
 IndexScan(mk)
 IndexScan(mi1)
 SeqScan(it1)
 IndexScan(ci)
 IndexScan(rt)
 IndexScan(n)
 IndexOnlyScan(k)
 Leading((((((((((((cn mc) ct) t) kt) mk) mi1) it1) ci) rt) n) k)) */
SELECT COUNT(*) FROM title as t,
kind_type as kt,
info_type as it1,
movie_info as mi1,
cast_info as ci,
role_type as rt,
name as n,
movie_keyword as mk,
keyword as k,
movie_companies as mc,
company_type as ct,
company_name as cn
WHERE
t.id = ci.movie_id
AND t.id = mc.movie_id
AND t.id = mi1.movie_id
AND t.id = mk.movie_id
AND mc.company_type_id = ct.id
AND mc.company_id = cn.id
AND k.id = mk.keyword_id
AND mi1.info_type_id = it1.id
AND t.kind_id = kt.id
AND ci.person_id = n.id
AND ci.role_id = rt.id
AND (it1.id IN ('6'))
AND (mi1.info in ('SDDS','Stereo'))
AND (kt.kind in ('episode','movie'))
AND (rt.role in ('actor','actress','director'))
AND (n.gender in ('f','m'))
AND (n.name_pcode_nf in ('C6231','D5162','F6524','F6525','J5215','P436','R1635','R2632','R2635','S3152'))
AND (t.production_year <= 2015)
AND (t.production_year >= 1990)
AND (cn.name in ('Columbia Broadcasting System (CBS)','Warner Home Video'))
AND (ct.kind in ('distributors'))


-- 8a9.sql
/*+ NestedLoop(cn mc ct t kt ci mi1 it1 rt n mk k)
 NestedLoop(cn mc ct t kt ci mi1 it1 rt n mk)
 NestedLoop(cn mc ct t kt ci mi1 it1 rt n)
 NestedLoop(cn mc ct t kt ci mi1 it1 rt)
 NestedLoop(cn mc ct t kt ci mi1 it1)
 NestedLoop(cn mc ct t kt ci mi1)
 NestedLoop(cn mc ct t kt ci)
 NestedLoop(cn mc ct t kt)
 NestedLoop(cn mc ct t)
 NestedLoop(cn mc ct)
 NestedLoop(cn mc)
 SeqScan(cn)
 IndexScan(mc)
 IndexScan(ct)
 IndexScan(t)
 IndexScan(kt)
 IndexScan(ci)
 IndexScan(mi1)
 SeqScan(it1)
 IndexScan(rt)
 IndexScan(n)
 IndexScan(mk)
 IndexOnlyScan(k)
 Leading((((((((((((cn mc) ct) t) kt) ci) mi1) it1) rt) n) mk) k)) */
SELECT COUNT(*) FROM title as t,
kind_type as kt,
info_type as it1,
movie_info as mi1,
cast_info as ci,
role_type as rt,
name as n,
movie_keyword as mk,
keyword as k,
movie_companies as mc,
company_type as ct,
company_name as cn
WHERE
t.id = ci.movie_id
AND t.id = mc.movie_id
AND t.id = mi1.movie_id
AND t.id = mk.movie_id
AND mc.company_type_id = ct.id
AND mc.company_id = cn.id
AND k.id = mk.keyword_id
AND mi1.info_type_id = it1.id
AND t.kind_id = kt.id
AND ci.person_id = n.id
AND ci.role_id = rt.id
AND (it1.id IN ('18'))
AND (mi1.info in ('CBS Television City - 7800 Beverly Blvd., Fairfax, Los Angeles, California, USA','General Service Studios - 1040 N. Las Palmas, Hollywood, Los Angeles, California, USA','Hal Roach Studios - 8822 Washington Blvd., Culver City, California, USA','Republic Studios - 4024 Radford Avenue, North Hollywood, Los Angeles, California, USA'))
AND (kt.kind in ('episode'))
AND (rt.role in ('actor','miscellaneous crew','producer','production designer'))
AND (n.gender in ('m') OR n.gender IS NULL)
AND (n.name_pcode_nf in ('C6231','C6235','D5216','E3241','G6252','J5162','P3625','R1632','S3152','S3521'))
AND (t.production_year <= 1975)
AND (t.production_year >= 1925)
AND (cn.name in ('American Broadcasting Company (ABC)','Columbia Broadcasting System (CBS)','National Broadcasting Company (NBC)'))
AND (ct.kind in ('distributors'))


-- 9a10.sql
/*+ NestedLoop(ci pi n rt t kt mi1 it1 it2)
 NestedLoop(ci pi n rt t kt mi1 it1)
 NestedLoop(ci pi n rt t kt mi1)
 HashJoin(ci pi n rt t kt)
 NestedLoop(ci pi n rt t)
 HashJoin(ci pi n rt)
 HashJoin(ci pi n)
 NestedLoop(pi n)
 SeqScan(ci)
 SeqScan(pi)
 IndexOnlyScan(n)
 SeqScan(rt)
 IndexScan(t)
 SeqScan(kt)
 IndexScan(mi1)
 SeqScan(it1)
 SeqScan(it2)
 Leading((((((((ci (pi n)) rt) t) kt) mi1) it1) it2)) */
SELECT mi1.info, pi.info, COUNT(*)
FROM title as t,
kind_type as kt,
movie_info as mi1,
info_type as it1,
cast_info as ci,
role_type as rt,
name as n,
info_type as it2,
person_info as pi
WHERE
t.id = ci.movie_id
AND t.id = mi1.movie_id
AND mi1.info_type_id = it1.id
AND t.kind_id = kt.id
AND ci.person_id = n.id
AND ci.movie_id = mi1.movie_id
AND ci.role_id = rt.id
AND n.id = pi.person_id
AND pi.info_type_id = it2.id
AND (it1.id IN ('16'))
AND (it2.id IN ('24'))
AND (mi1.info ILIKE '%re%')
AND (pi.info ILIKE '%19%')
AND (kt.kind IN ('tv movie','tv series','video movie'))
AND (rt.role IN ('composer','costume designer','guest'))
GROUP BY mi1.info, pi.info


-- 9a11.sql
/*+ NestedLoop(t mi1 ci pi n rt kt it1 it2)
 NestedLoop(t mi1 ci pi n rt kt it1)
 HashJoin(t mi1 ci pi n rt kt)
 HashJoin(t mi1 ci pi n rt)
 HashJoin(mi1 ci pi n rt)
 HashJoin(ci pi n rt)
 HashJoin(ci pi n)
 NestedLoop(pi n)
 SeqScan(t)
 SeqScan(mi1)
 SeqScan(ci)
 SeqScan(pi)
 IndexOnlyScan(n)
 SeqScan(rt)
 SeqScan(kt)
 SeqScan(it1)
 SeqScan(it2)
 Leading(((((t (mi1 ((ci (pi n)) rt))) kt) it1) it2)) */
SELECT mi1.info, pi.info, COUNT(*)
FROM title as t,
kind_type as kt,
movie_info as mi1,
info_type as it1,
cast_info as ci,
role_type as rt,
name as n,
info_type as it2,
person_info as pi
WHERE
t.id = ci.movie_id
AND t.id = mi1.movie_id
AND mi1.info_type_id = it1.id
AND t.kind_id = kt.id
AND ci.person_id = n.id
AND ci.movie_id = mi1.movie_id
AND ci.role_id = rt.id
AND n.id = pi.person_id
AND pi.info_type_id = it2.id
AND (it1.id IN ('16'))
AND (it2.id IN ('21'))
AND (mi1.info ILIKE '%us%')
AND (pi.info ILIKE '%200%')
AND (kt.kind IN ('tv mini series','tv movie','tv series','video game'))
AND (rt.role IN ('actor','actress','composer','costume designer','editor','guest','miscellaneous crew','producer','production designer','writer'))
GROUP BY mi1.info, pi.info


-- 9a12.sql
/*+ NestedLoop(mi1 t kt ci pi n rt it1 it2)
 NestedLoop(mi1 t kt ci pi n rt it1)
 HashJoin(mi1 t kt ci pi n rt)
 HashJoin(mi1 t kt ci pi n)
 NestedLoop(pi n)
 NestedLoop(mi1 t kt ci)
 HashJoin(mi1 t kt)
 NestedLoop(mi1 t)
 SeqScan(mi1)
 IndexScan(t)
 SeqScan(kt)
 IndexScan(ci)
 SeqScan(pi)
 IndexOnlyScan(n)
 SeqScan(rt)
 SeqScan(it1)
 SeqScan(it2)
 Leading((((((((mi1 t) kt) ci) (pi n)) rt) it1) it2)) */
SELECT mi1.info, pi.info, COUNT(*)
FROM title as t,
kind_type as kt,
movie_info as mi1,
info_type as it1,
cast_info as ci,
role_type as rt,
name as n,
info_type as it2,
person_info as pi
WHERE
t.id = ci.movie_id
AND t.id = mi1.movie_id
AND mi1.info_type_id = it1.id
AND t.kind_id = kt.id
AND ci.person_id = n.id
AND ci.movie_id = mi1.movie_id
AND ci.role_id = rt.id
AND n.id = pi.person_id
AND pi.info_type_id = it2.id
AND (it1.id IN ('16'))
AND (it2.id IN ('21'))
AND (mi1.info ILIKE '%jap%')
AND (pi.info ILIKE '%19%')
AND (kt.kind IN ('episode','movie','tv movie','tv series','video game','video movie'))
AND (rt.role IN ('actor','actress','cinematographer','composer','costume designer','director','guest','miscellaneous crew','producer','production designer','writer'))
GROUP BY mi1.info, pi.info


-- 9a13.sql
/*+ NestedLoop(mi1 t kt ci pi n rt it1 it2)
 NestedLoop(mi1 t kt ci pi n rt it1)
 HashJoin(mi1 t kt ci pi n rt)
 HashJoin(mi1 t kt ci pi n)
 NestedLoop(pi n)
 NestedLoop(mi1 t kt ci)
 HashJoin(mi1 t kt)
 NestedLoop(mi1 t)
 SeqScan(mi1)
 IndexScan(t)
 SeqScan(kt)
 IndexScan(ci)
 SeqScan(pi)
 IndexOnlyScan(n)
 SeqScan(rt)
 SeqScan(it1)
 SeqScan(it2)
 Leading((((((((mi1 t) kt) ci) (pi n)) rt) it1) it2)) */
SELECT mi1.info, pi.info, COUNT(*)
FROM title as t,
kind_type as kt,
movie_info as mi1,
info_type as it1,
cast_info as ci,
role_type as rt,
name as n,
info_type as it2,
person_info as pi
WHERE
t.id = ci.movie_id
AND t.id = mi1.movie_id
AND mi1.info_type_id = it1.id
AND t.kind_id = kt.id
AND ci.person_id = n.id
AND ci.movie_id = mi1.movie_id
AND ci.role_id = rt.id
AND n.id = pi.person_id
AND pi.info_type_id = it2.id
AND (it1.id IN ('16'))
AND (it2.id IN ('21'))
AND (mi1.info ILIKE '%uk:%')
AND (pi.info ILIKE '%19%')
AND (kt.kind IN ('episode','movie','tv mini series','video game'))
AND (rt.role IN ('actor','actress','cinematographer','composer','guest','miscellaneous crew','production designer','writer'))
GROUP BY mi1.info, pi.info


-- 9a14.sql
/*+ NestedLoop(pi n ci rt t kt mi1 it1 it2)
 NestedLoop(pi n ci rt t kt mi1 it1)
 NestedLoop(pi n ci rt t kt mi1)
 HashJoin(pi n ci rt t kt)
 NestedLoop(pi n ci rt t)
 HashJoin(pi n ci rt)
 NestedLoop(pi n ci)
 NestedLoop(pi n)
 SeqScan(pi)
 IndexOnlyScan(n)
 IndexScan(ci)
 SeqScan(rt)
 IndexScan(t)
 SeqScan(kt)
 IndexScan(mi1)
 SeqScan(it1)
 SeqScan(it2)
 Leading(((((((((pi n) ci) rt) t) kt) mi1) it1) it2)) */
SELECT mi1.info, pi.info, COUNT(*)
FROM title as t,
kind_type as kt,
movie_info as mi1,
info_type as it1,
cast_info as ci,
role_type as rt,
name as n,
info_type as it2,
person_info as pi
WHERE
t.id = ci.movie_id
AND t.id = mi1.movie_id
AND mi1.info_type_id = it1.id
AND t.kind_id = kt.id
AND ci.person_id = n.id
AND ci.movie_id = mi1.movie_id
AND ci.role_id = rt.id
AND n.id = pi.person_id
AND pi.info_type_id = it2.id
AND (it1.id IN ('16'))
AND (it2.id IN ('23'))
AND (mi1.info ILIKE '%be%')
AND (pi.info ILIKE '%octo%')
AND (kt.kind IN ('tv mini series','tv series','video game'))
AND (rt.role IN ('actor','cinematographer','director','editor','guest','miscellaneous crew','producer','production designer','writer'))
GROUP BY mi1.info, pi.info


-- 9b1.sql
/*+ NestedLoop(pi n ci rt t kt mi1 it1 it2)
 HashJoin(pi n ci rt t kt mi1 it1)
 NestedLoop(pi n ci rt t kt mi1)
 HashJoin(pi n ci rt t kt)
 NestedLoop(pi n ci rt t)
 HashJoin(pi n ci rt)
 NestedLoop(pi n ci)
 HashJoin(pi n)
 SeqScan(pi)
 SeqScan(n)
 IndexScan(ci)
 SeqScan(rt)
 IndexScan(t)
 SeqScan(kt)
 IndexScan(mi1)
 SeqScan(it1)
 SeqScan(it2)
 Leading(((((((((pi n) ci) rt) t) kt) mi1) it1) it2)) */
SELECT mi1.info, n.name, COUNT(*)
FROM title as t,
kind_type as kt,
movie_info as mi1,
info_type as it1,
cast_info as ci,
role_type as rt,
name as n,
info_type as it2,
person_info as pi
WHERE
t.id = ci.movie_id
AND t.id = mi1.movie_id
AND mi1.info_type_id = it1.id
AND t.kind_id = kt.id
AND ci.person_id = n.id
AND ci.movie_id = mi1.movie_id
AND ci.role_id = rt.id
AND n.id = pi.person_id
AND pi.info_type_id = it2.id
AND (it1.id IN ('4','5'))
AND (it2.id IN ('26'))
AND (mi1.info IN ('Argentina:Atp','Australia:M','Brazil:14','Finland:S','France:U','French','Japanese','Netherlands:AL','Norway:15','South Korea:12','South Korea:15','Spain:T','Sweden:15','Switzerland:7','UK:12','USA:R','West Germany:12'))
AND (n.name ILIKE '%gha%')
AND (kt.kind IN ('episode','movie','tv movie'))
AND (rt.role IN ('actor','cinematographer','costume designer'))
AND (t.production_year <= 2015)
AND (t.production_year >= 1925)
GROUP BY mi1.info, n.name


-- 9b12.sql
/*+ NestedLoop(mi1 t kt ci rt n pi it1 it2)
 NestedLoop(mi1 t kt ci rt n pi it1)
 NestedLoop(mi1 t kt ci rt n pi)
 NestedLoop(mi1 t kt ci rt n)
 HashJoin(mi1 t kt ci rt)
 NestedLoop(mi1 t kt ci)
 HashJoin(mi1 t kt)
 NestedLoop(mi1 t)
 SeqScan(mi1)
 IndexScan(t)
 SeqScan(kt)
 IndexScan(ci)
 SeqScan(rt)
 IndexScan(n)
 IndexScan(pi)
 SeqScan(it1)
 SeqScan(it2)
 Leading(((((((((mi1 t) kt) ci) rt) n) pi) it1) it2)) */
SELECT mi1.info, n.name, COUNT(*)
FROM title as t,
kind_type as kt,
movie_info as mi1,
info_type as it1,
cast_info as ci,
role_type as rt,
name as n,
info_type as it2,
person_info as pi
WHERE
t.id = ci.movie_id
AND t.id = mi1.movie_id
AND mi1.info_type_id = it1.id
AND t.kind_id = kt.id
AND ci.person_id = n.id
AND ci.movie_id = mi1.movie_id
AND ci.role_id = rt.id
AND n.id = pi.person_id
AND pi.info_type_id = it2.id
AND (it1.id IN ('3'))
AND (it2.id IN ('36'))
AND (mi1.info IN ('Biography','Film-Noir','Game-Show','History','Music','Musical','News','Reality-TV','Sci-Fi','Sport','Talk-Show','War','Western'))
AND (n.name ILIKE '%ma%')
AND (kt.kind IN ('episode','movie','video movie'))
AND (rt.role IN ('actress','costume designer','director','miscellaneous crew','producer'))
AND (t.production_year <= 2015)
AND (t.production_year >= 1925)
GROUP BY mi1.info, n.name


-- 9b6.sql
/*+ NestedLoop(mi1 it1 t kt ci rt n pi it2)
 NestedLoop(mi1 it1 t kt ci rt n pi)
 NestedLoop(mi1 it1 t kt ci rt n)
 HashJoin(mi1 it1 t kt ci rt)
 NestedLoop(mi1 it1 t kt ci)
 HashJoin(mi1 it1 t kt)
 NestedLoop(mi1 it1 t)
 HashJoin(mi1 it1)
 SeqScan(mi1)
 SeqScan(it1)
 IndexScan(t)
 SeqScan(kt)
 IndexScan(ci)
 SeqScan(rt)
 IndexScan(n)
 IndexScan(pi)
 SeqScan(it2)
 Leading(((((((((mi1 it1) t) kt) ci) rt) n) pi) it2)) */
SELECT mi1.info, n.name, COUNT(*)
FROM title as t,
kind_type as kt,
movie_info as mi1,
info_type as it1,
cast_info as ci,
role_type as rt,
name as n,
info_type as it2,
person_info as pi
WHERE
t.id = ci.movie_id
AND t.id = mi1.movie_id
AND mi1.info_type_id = it1.id
AND t.kind_id = kt.id
AND ci.person_id = n.id
AND ci.movie_id = mi1.movie_id
AND ci.role_id = rt.id
AND n.id = pi.person_id
AND pi.info_type_id = it2.id
AND (it1.id IN ('2','5','6'))
AND (it2.id IN ('24'))
AND (mi1.info IN ('70 mm 6-Track','Brazil:16','Canada:PA','Canada:R','Finland:(Banned)','Germany:o.Al.','Iceland:L','Ireland:12A','Ireland:PG','Italy:VM14','New Zealand:PG','Peru:18','Philippines:G','Philippines:R-13','Portugal:M/16','Singapore:PG13','South Korea:12','Spain:7'))
AND (n.name ILIKE '%fr%')
AND (kt.kind IN ('episode','movie','tv series'))
AND (rt.role IN ('cinematographer','composer','editor','writer'))
AND (t.production_year <= 2015)
AND (t.production_year >= 1925)
GROUP BY mi1.info, n.name


-- 9b7.sql
/*+ NestedLoop(n pi ci rt t mi1 kt it1 it2)
 NestedLoop(n pi ci rt t mi1 kt it1)
 NestedLoop(n pi ci rt t mi1 kt)
 NestedLoop(n pi ci rt t mi1)
 NestedLoop(n pi ci rt t)
 HashJoin(n pi ci rt)
 NestedLoop(n pi ci)
 NestedLoop(n pi)
 SeqScan(n)
 IndexScan(pi)
 IndexScan(ci)
 SeqScan(rt)
 IndexScan(t)
 IndexScan(mi1)
 IndexScan(kt)
 IndexOnlyScan(it1)
 SeqScan(it2)
 Leading(((((((((n pi) ci) rt) t) mi1) kt) it1) it2)) */
SELECT mi1.info, n.name, COUNT(*)
FROM title as t,
kind_type as kt,
movie_info as mi1,
info_type as it1,
cast_info as ci,
role_type as rt,
name as n,
info_type as it2,
person_info as pi
WHERE
t.id = ci.movie_id
AND t.id = mi1.movie_id
AND mi1.info_type_id = it1.id
AND t.kind_id = kt.id
AND ci.person_id = n.id
AND ci.movie_id = mi1.movie_id
AND ci.role_id = rt.id
AND n.id = pi.person_id
AND pi.info_type_id = it2.id
AND (it1.id IN ('2','4'))
AND (it2.id IN ('19'))
AND (mi1.info IN ('English'))
AND (n.name ILIKE '%raffe%')
AND (kt.kind IN ('episode','movie','tv movie'))
AND (rt.role IN ('actress','composer','costume designer'))
AND (t.production_year <= 1990)
AND (t.production_year >= 1950)
GROUP BY mi1.info, n.name


-- 9b8.sql
/*+ NestedLoop(it2 mi1 it1 t kt ci rt n pi)
 NestedLoop(mi1 it1 t kt ci rt n pi)
 NestedLoop(mi1 it1 t kt ci rt n)
 HashJoin(mi1 it1 t kt ci rt)
 NestedLoop(mi1 it1 t kt ci)
 HashJoin(mi1 it1 t kt)
 NestedLoop(mi1 it1 t)
 HashJoin(mi1 it1)
 SeqScan(it2)
 SeqScan(mi1)
 SeqScan(it1)
 IndexScan(t)
 SeqScan(kt)
 IndexScan(ci)
 SeqScan(rt)
 IndexScan(n)
 IndexScan(pi)
 Leading((it2 (((((((mi1 it1) t) kt) ci) rt) n) pi))) */
SELECT mi1.info, n.name, COUNT(*)
FROM title as t,
kind_type as kt,
movie_info as mi1,
info_type as it1,
cast_info as ci,
role_type as rt,
name as n,
info_type as it2,
person_info as pi
WHERE
t.id = ci.movie_id
AND t.id = mi1.movie_id
AND mi1.info_type_id = it1.id
AND t.kind_id = kt.id
AND ci.person_id = n.id
AND ci.movie_id = mi1.movie_id
AND ci.role_id = rt.id
AND n.id = pi.person_id
AND pi.info_type_id = it2.id
AND (it1.id IN ('2','3','4'))
AND (it2.id IN ('25'))
AND (mi1.info IN ('American Sign Language','Arabic','Cantonese','Chinese','Croatian','Finnish','Hebrew','Hindi','History','Italian','Korean','Mandarin','News','Polish','Reality-TV','Romance','Talk-Show','War','Western','Yoruba'))
AND (n.name ILIKE '%wa%')
AND (kt.kind IN ('episode','video movie'))
AND (rt.role IN ('actress','costume designer','director','miscellaneous crew'))
AND (t.production_year <= 2015)
AND (t.production_year >= 1925)
GROUP BY mi1.info, n.name