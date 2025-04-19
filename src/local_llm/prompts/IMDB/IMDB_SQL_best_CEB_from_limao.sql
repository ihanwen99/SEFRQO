/*+ NestLoop(mk k t mi2 kt it2 mi1 it1 ci rt n)
 NestLoop(mk k t mi2 kt it2 mi1 it1 ci rt)
 NestLoop(mk k t mi2 kt it2 mi1 it1 ci)
 HashJoin(mk k t mi2 kt it2 mi1 it1)
 NestLoop(mk k t mi2 kt it2 mi1)
 HashJoin(mk k t mi2 kt it2)
 HashJoin(mk k t mi2 kt)
 HashJoin(mk k t mi2)
 HashJoin(mk k t)
 HashJoin(mk k)
 SeqScan(mk)
 SeqScan(k)
 IndexScan(t)
 IndexScan(mi2)
 IndexScan(kt)
 SeqScan(it2)
 IndexScan(mi1)
 IndexScan(it1)
 IndexScan(ci)
 SeqScan(rt)
 IndexScan(n)
 Leading(((((((((((mk k) t) mi2) kt) it2) mi1) it1) ci) rt) n)) */
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
AND (it2.id in ('8'))
AND t.kind_id = kt.id
AND ci.person_id = n.id
AND ci.role_id = rt.id
AND (mi1.info in ('MET:600 m','OFM:35 mm','PCS:Spherical','PFM:35 mm','RAT:1.37 : 1'))
AND (mi2.info in ('France','Germany','Japan','Mexico','Portugal','Spain','UK','USA'))
AND (kt.kind in ('tv series','video game','video movie'))
AND (rt.role in ('producer'))
AND (n.gender in ('m') OR n.gender IS NULL)
AND (t.production_year <= 1975)
AND (t.production_year >= 1925)


/*+ MergeJoin(t kt mi2 mi1 it2 ci rt mk it1 n k)
 HashJoin(t kt mi2 mi1 it2 ci rt mk it1 n)
 HashJoin(t kt mi2 mi1 it2 ci rt mk it1)
 HashJoin(t kt mi2 mi1 it2 ci rt mk)
 HashJoin(t kt mi2 mi1 it2 ci rt)
 NestLoop(t kt mi2 mi1 it2 ci)
 HashJoin(t kt mi2 mi1 it2)
 HashJoin(t kt mi2 mi1)
 HashJoin(t kt mi2)
 HashJoin(t kt)
 SeqScan(t)
 IndexScan(kt)
 SeqScan(mi2)
 SeqScan(mi1)
 IndexScan(it2)
 IndexScan(ci)
 IndexScan(rt)
 IndexScan(mk)
 SeqScan(it1)
 SeqScan(n)
 IndexScan(k)
 Leading(((((((((((t kt) mi2) mi1) it2) ci) rt) mk) it1) n) k)) */
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
AND (it2.id in ('8'))
AND t.kind_id = kt.id
AND ci.person_id = n.id
AND ci.role_id = rt.id
AND (mi1.info in ('MET:600 m','OFM:35 mm','PCS:Spherical','PFM:35 mm','RAT:1.37 : 1'))
AND (mi2.info in ('France','Germany','Japan','Mexico','Portugal','Spain','UK','USA'))
AND (kt.kind in ('tv series','video game','video movie'))
AND (rt.role in ('producer'))
AND (n.gender in ('m') OR n.gender IS NULL)
AND (t.production_year <= 2000)
AND (t.production_year >= 1925)


/*+ NestLoop(mk k t mi2 kt it2 mi1 it1 ci rt n)
 NestLoop(mk k t mi2 kt it2 mi1 it1 ci rt)
 NestLoop(mk k t mi2 kt it2 mi1 it1 ci)
 HashJoin(mk k t mi2 kt it2 mi1 it1)
 NestLoop(mk k t mi2 kt it2 mi1)
 HashJoin(mk k t mi2 kt it2)
 HashJoin(mk k t mi2 kt)
 HashJoin(mk k t mi2)
 HashJoin(mk k t)
 HashJoin(mk k)
 SeqScan(mk)
 SeqScan(k)
 IndexScan(t)
 IndexScan(mi2)
 IndexScan(kt)
 SeqScan(it2)
 IndexScan(mi1)
 IndexScan(it1)
 IndexScan(ci)
 SeqScan(rt)
 IndexScan(n)
 Leading(((((((((((mk k) t) mi2) kt) it2) mi1) it1) ci) rt) n)) */
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
AND (it2.id in ('8'))
AND t.kind_id = kt.id
AND ci.person_id = n.id
AND ci.role_id = rt.id
AND (mi1.info in ('MET:600 m','OFM:35 mm','PCS:Spherical','PFM:35 mm','RAT:1.37 : 1'))
AND (mi2.info in ('Japan','Mexico','Portugal','Spain','UK','USA'))
AND (kt.kind in ('tv series','video game','video movie'))
AND (rt.role in ('producer'))
AND (n.gender in ('m') OR n.gender IS NULL)
AND (t.production_year <= 1975)
AND (t.production_year >= 1925)


/*+ NestLoop(mk k t mi2 kt it2 mi1 it1 ci rt n)
 NestLoop(mk k t mi2 kt it2 mi1 it1 ci rt)
 NestLoop(mk k t mi2 kt it2 mi1 it1 ci)
 HashJoin(mk k t mi2 kt it2 mi1 it1)
 NestLoop(mk k t mi2 kt it2 mi1)
 HashJoin(mk k t mi2 kt it2)
 MergeJoin(mk k t mi2 kt)
 HashJoin(mk k t mi2)
 HashJoin(mk k t)
 HashJoin(mk k)
 SeqScan(mk)
 SeqScan(k)
 IndexScan(t)
 IndexScan(mi2)
 IndexScan(kt)
 SeqScan(it2)
 IndexScan(mi1)
 IndexScan(it1)
 IndexScan(ci)
 SeqScan(rt)
 IndexScan(n)
 Leading(((((((((((mk k) t) mi2) kt) it2) mi1) it1) ci) rt) n)) */
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
AND (it2.id in ('18'))
AND t.kind_id = kt.id
AND ci.person_id = n.id
AND ci.role_id = rt.id
AND (mi1.info in ('OFM:35 mm','OFM:Live','PFM:35 mm','RAT:1.33 : 1'))
AND (mi2.info in ('20th Century Fox Studios - 10201 Pico Blvd., Century City, Los Angeles, California, USA','Desilu Studios - 9336 W. Washington Blvd., Culver City, California, USA','Hal Roach Studios - 8822 Washington Blvd., Culver City, California, USA','New York City, New York, USA','Revue Studios, Hollywood, Los Angeles, California, USA','Universal Studios - 100 Universal City Plaza, Universal City, California, USA','Warner Brothers Burbank Studios - 4000 Warner Boulevard, Burbank, California, USA'))
AND (kt.kind in ('tv series','video game','video movie'))
AND (rt.role in ('actress','writer'))
AND (n.gender in ('f','m'))
AND (t.production_year <= 1975)
AND (t.production_year >= 1925)


/*+ NestLoop(mk k t mi2 kt it2 mi1 it1 ci rt n)
 NestLoop(mk k t mi2 kt it2 mi1 it1 ci rt)
 NestLoop(mk k t mi2 kt it2 mi1 it1 ci)
 HashJoin(mk k t mi2 kt it2 mi1 it1)
 NestLoop(mk k t mi2 kt it2 mi1)
 HashJoin(mk k t mi2 kt it2)
 MergeJoin(mk k t mi2 kt)
 HashJoin(mk k t mi2)
 HashJoin(mk k t)
 HashJoin(mk k)
 SeqScan(mk)
 SeqScan(k)
 IndexScan(t)
 IndexScan(mi2)
 IndexScan(kt)
 SeqScan(it2)
 IndexScan(mi1)
 IndexScan(it1)
 IndexScan(ci)
 SeqScan(rt)
 IndexScan(n)
 Leading(((((((((((mk k) t) mi2) kt) it2) mi1) it1) ci) rt) n)) */
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
AND (it2.id in ('18'))
AND t.kind_id = kt.id
AND ci.person_id = n.id
AND ci.role_id = rt.id
AND (mi1.info in ('OFM:35 mm','OFM:Live','PFM:35 mm','RAT:1.33 : 1'))
AND (mi2.info in ('20th Century Fox Studios - 10201 Pico Blvd., Century City, Los Angeles, California, USA','Desilu Studios - 9336 W. Washington Blvd., Culver City, California, USA','Hal Roach Studios - 8822 Washington Blvd., Culver City, California, USA','New York City, New York, USA','Revue Studios, Hollywood, Los Angeles, California, USA','Universal Studios - 100 Universal City Plaza, Universal City, California, USA','Warner Brothers Burbank Studios - 4000 Warner Boulevard, Burbank, California, USA'))
AND (kt.kind in ('tv series','video game','video movie'))
AND (rt.role in ('actress','writer'))
AND (n.gender in ('f','m'))
AND (t.production_year <= 2000)
AND (t.production_year >= 1950)


/*+ NestLoop(mk k t mi2 kt it2 mi1 it1 ci rt n)
 NestLoop(mk k t mi2 kt it2 mi1 it1 ci rt)
 NestLoop(mk k t mi2 kt it2 mi1 it1 ci)
 HashJoin(mk k t mi2 kt it2 mi1 it1)
 NestLoop(mk k t mi2 kt it2 mi1)
 HashJoin(mk k t mi2 kt it2)
 HashJoin(mk k t mi2 kt)
 HashJoin(mk k t mi2)
 HashJoin(mk k t)
 HashJoin(mk k)
 SeqScan(mk)
 SeqScan(k)
 IndexScan(t)
 IndexScan(mi2)
 IndexScan(kt)
 SeqScan(it2)
 IndexScan(mi1)
 IndexScan(it1)
 IndexScan(ci)
 SeqScan(rt)
 IndexScan(n)
 Leading(((((((((((mk k) t) mi2) kt) it2) mi1) it1) ci) rt) n)) */
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
AND (it2.id in ('18'))
AND t.kind_id = kt.id
AND ci.person_id = n.id
AND ci.role_id = rt.id
AND (mi1.info in ('OFM:35 mm','OFM:Live','PFM:35 mm','RAT:1.33 : 1'))
AND (mi2.info in ('20th Century Fox Studios - 10201 Pico Blvd., Century City, Los Angeles, California, USA','Desilu Studios - 9336 W. Washington Blvd., Culver City, California, USA','Hal Roach Studios - 8822 Washington Blvd., Culver City, California, USA','New York City, New York, USA','Revue Studios, Hollywood, Los Angeles, California, USA','Universal Studios - 100 Universal City Plaza, Universal City, California, USA','Warner Brothers Burbank Studios - 4000 Warner Boulevard, Burbank, California, USA'))
AND (kt.kind in ('tv series','video game','video movie'))
AND (rt.role in ('actress','writer'))
AND (n.gender in ('f'))
AND (t.production_year <= 1975)
AND (t.production_year >= 1925)


/*+ NestLoop(t mi2 it2 kt mi1 mk k it1 ci rt n)
 NestLoop(t mi2 it2 kt mi1 mk k it1 ci rt)
 NestLoop(t mi2 it2 kt mi1 mk k it1 ci)
 HashJoin(t mi2 it2 kt mi1 mk k it1)
 HashJoin(t mi2 it2 kt mi1 mk k)
 NestLoop(t mi2 it2 kt mi1 mk)
 NestLoop(t mi2 it2 kt mi1)
 HashJoin(t mi2 it2 kt)
 HashJoin(t mi2 it2)
 HashJoin(t mi2)
 SeqScan(t)
 SeqScan(mi2)
 IndexScan(it2)
 SeqScan(kt)
 IndexScan(mi1)
 IndexScan(mk)
 IndexScan(k)
 IndexScan(it1)
 IndexScan(ci)
 IndexScan(rt)
 IndexScan(n)
 Leading(((((((((((t mi2) it2) kt) mi1) mk) k) it1) ci) rt) n)) */
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
AND (it2.id in ('3'))
AND t.kind_id = kt.id
AND ci.person_id = n.id
AND ci.role_id = rt.id
AND (mi1.info in ('PCS:Spherical','PFM:16 mm','PFM:35 mm','RAT:1.33 : 1','RAT:1.66 : 1','RAT:1.85 : 1'))
AND (mi2.info in ('Adult','Comedy','Documentary','Drama','Mystery','Romance','Short','Thriller','Western'))
AND (kt.kind in ('tv series','video game','video movie'))
AND (rt.role in ('miscellaneous crew','producer'))
AND (n.gender in ('f','m'))
AND (t.production_year <= 1990)
AND (t.production_year >= 1950)


/*+ MergeJoin(t kt mi2 mi1 it2 ci rt n it1 mk k)
 HashJoin(t kt mi2 mi1 it2 ci rt n it1 mk)
 MergeJoin(t kt mi2 mi1 it2 ci rt n it1)
 HashJoin(t kt mi2 mi1 it2 ci rt n)
 HashJoin(t kt mi2 mi1 it2 ci rt)
 NestLoop(t kt mi2 mi1 it2 ci)
 HashJoin(t kt mi2 mi1 it2)
 HashJoin(t kt mi2 mi1)
 HashJoin(t kt mi2)
 HashJoin(t kt)
 SeqScan(t)
 IndexScan(kt)
 SeqScan(mi2)
 SeqScan(mi1)
 IndexScan(it2)
 IndexScan(ci)
 IndexScan(rt)
 IndexScan(n)
 SeqScan(it1)
 IndexScan(mk)
 IndexScan(k)
 Leading(((((((((((t kt) mi2) mi1) it2) ci) rt) n) it1) mk) k)) */
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
AND (it2.id in ('3'))
AND t.kind_id = kt.id
AND ci.person_id = n.id
AND ci.role_id = rt.id
AND (mi1.info in ('PCS:Spherical','PFM:16 mm','PFM:35 mm','RAT:1.33 : 1','RAT:1.66 : 1','RAT:1.85 : 1'))
AND (mi2.info in ('Adult','Comedy','Documentary','Drama','Mystery','Romance','Short','Thriller','Western'))
AND (kt.kind in ('tv series','video game','video movie'))
AND (rt.role in ('miscellaneous crew','producer'))
AND (n.gender in ('m'))
AND (t.production_year <= 1990)
AND (t.production_year >= 1950)


/*+ NestLoop(t mi2 it2 kt mi1 mk k it1 ci rt n)
 NestLoop(t mi2 it2 kt mi1 mk k it1 ci rt)
 NestLoop(t mi2 it2 kt mi1 mk k it1 ci)
 HashJoin(t mi2 it2 kt mi1 mk k it1)
 HashJoin(t mi2 it2 kt mi1 mk k)
 NestLoop(t mi2 it2 kt mi1 mk)
 NestLoop(t mi2 it2 kt mi1)
 HashJoin(t mi2 it2 kt)
 HashJoin(t mi2 it2)
 HashJoin(t mi2)
 SeqScan(t)
 SeqScan(mi2)
 IndexScan(it2)
 SeqScan(kt)
 IndexScan(mi1)
 IndexScan(mk)
 IndexScan(k)
 IndexScan(it1)
 IndexScan(ci)
 IndexScan(rt)
 IndexScan(n)
 Leading(((((((((((t mi2) it2) kt) mi1) mk) k) it1) ci) rt) n)) */
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
AND (it2.id in ('3'))
AND t.kind_id = kt.id
AND ci.person_id = n.id
AND ci.role_id = rt.id
AND (mi1.info in ('PFM:35 mm','RAT:1.33 : 1','RAT:1.66 : 1','RAT:1.85 : 1'))
AND (mi2.info in ('Adult','Comedy','Documentary','Drama','Mystery','Romance','Short','Thriller','Western'))
AND (kt.kind in ('tv series','video game','video movie'))
AND (rt.role in ('miscellaneous crew','producer'))
AND (n.gender in ('f','m'))
AND (t.production_year <= 1990)
AND (t.production_year >= 1950)


/*+ NestLoop(t mi2 kt ci rt it2 n mi1 it1)
 NestLoop(t mi2 kt ci rt it2 n mi1)
 HashJoin(t mi2 kt ci rt it2 n)
 NestLoop(t mi2 kt ci rt it2)
 HashJoin(t mi2 kt ci rt)
 NestLoop(t mi2 kt ci)
 HashJoin(t mi2 kt)
 HashJoin(t mi2)
 IndexScan(t)
 IndexScan(mi2)
 SeqScan(kt)
 IndexScan(ci)
 IndexScan(rt)
 IndexScan(it2)
 SeqScan(n)
 IndexScan(mi1)
 SeqScan(it1)
 Leading(((((((((t mi2) kt) ci) rt) it2) n) mi1) it1)) */
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
AND it1.id = '8'
AND it2.id = '4'
AND t.kind_id = kt.id
AND ci.person_id = n.id
AND ci.role_id = rt.id
AND mi1.info IN ('Brazil','India','Ireland','Italy','Netherlands','Philippines','Poland','USA')
AND mi2.info IN ('English','French','Italian','Malayalam','Polish','Portuguese','Tagalog')
AND kt.kind IN ('tv movie','tv series','video game')
AND rt.role IN ('cinematographer','composer')
AND n.gender IN ('m')
AND t.production_year <= 2015
AND 1990 < t.production_year


/*+ NestLoop(t mi2 kt ci rt it2 n mi1 it1)
 NestLoop(t mi2 kt ci rt it2 n mi1)
 HashJoin(t mi2 kt ci rt it2 n)
 NestLoop(t mi2 kt ci rt it2)
 HashJoin(t mi2 kt ci rt)
 NestLoop(t mi2 kt ci)
 HashJoin(t mi2 kt)
 HashJoin(t mi2)
 IndexScan(t)
 IndexScan(mi2)
 SeqScan(kt)
 IndexScan(ci)
 IndexScan(rt)
 IndexScan(it2)
 SeqScan(n)
 IndexScan(mi1)
 SeqScan(it1)
 Leading(((((((((t mi2) kt) ci) rt) it2) n) mi1) it1)) */
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
AND it1.id = '8'
AND it2.id = '4'
AND t.kind_id = kt.id
AND ci.person_id = n.id
AND ci.role_id = rt.id
AND mi1.info IN ('Italy','Netherlands','Philippines','Poland','USA')
AND mi2.info IN ('English','French','Italian','Malayalam','Polish','Portuguese','Tagalog')
AND kt.kind IN ('tv movie','tv series','video game')
AND rt.role IN ('cinematographer','composer')
AND n.gender IN ('m')
AND t.production_year <= 2015
AND 1990 < t.production_year


/*+ MergeJoin(it1 t kt mi2 ci rt mi1 n it2)
 NestLoop(it1 t kt mi2 ci rt mi1 n)
 NestLoop(t kt mi2 ci rt mi1 n)
 NestLoop(t kt mi2 ci rt mi1)
 HashJoin(t kt mi2 ci rt)
 NestLoop(t kt mi2 ci)
 HashJoin(t kt mi2)
 HashJoin(t kt)
 SeqScan(it1)
 SeqScan(t)
 IndexScan(kt)
 SeqScan(mi2)
 IndexScan(ci)
 IndexScan(rt)
 IndexScan(mi1)
 IndexScan(n)
 SeqScan(it2)
 Leading(((it1 ((((((t kt) mi2) ci) rt) mi1) n)) it2)) */
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
AND it1.id = '8'
AND it2.id = '4'
AND t.kind_id = kt.id
AND ci.person_id = n.id
AND ci.role_id = rt.id
AND mi1.info IN ('Brazil','India','Ireland','Italy','Netherlands','Philippines','Poland','USA')
AND mi2.info IN ('English','French','Italian','Malayalam','Polish','Portuguese','Tagalog')
AND kt.kind IN ('tv movie','tv series','video game')
AND rt.role IN ('cinematographer','composer')
AND n.gender IN ('m')
AND t.production_year <= 2015
AND 2000 < t.production_year


/*+ MergeJoin(t kt mi1 mi2 ci it2 rt n it1)
 HashJoin(t kt mi1 mi2 ci it2 rt n)
 HashJoin(t kt mi1 mi2 ci it2 rt)
 NestLoop(t kt mi1 mi2 ci it2)
 NestLoop(t kt mi1 mi2 ci)
 HashJoin(t kt mi1 mi2)
 HashJoin(t kt mi1)
 HashJoin(t kt)
 SeqScan(t)
 IndexScan(kt)
 SeqScan(mi1)
 IndexScan(mi2)
 IndexScan(ci)
 IndexScan(it2)
 IndexScan(rt)
 SeqScan(n)
 SeqScan(it1)
 Leading(((((((((t kt) mi1) mi2) ci) it2) rt) n) it1)) */
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
AND it2.id = '7'
AND t.kind_id = kt.id
AND ci.person_id = n.id
AND ci.role_id = rt.id
AND mi1.info IN ('Comedy','Crime','Fantasy','Mystery','Short')
AND mi2.info IN ('LAB:FotoKem Laboratory, Burbank (CA), USA','MET:','MET:300 m','PCS:Spherical','RAT:1.33 : 1','RAT:1.66 : 1')
AND kt.kind IN ('episode','movie','video movie')
AND rt.role IN ('miscellaneous crew')
AND n.gender IN ('f')
AND t.production_year <= 2015
AND 1925 < t.production_year


/*+ HashJoin(t kt mi2 ci rt it2 mi1 n it1)
 NestLoop(t kt mi2 ci rt it2 mi1 n)
 HashJoin(t kt mi2 ci rt it2 mi1)
 NestLoop(t kt mi2 ci rt it2)
 HashJoin(t kt mi2 ci rt)
 NestLoop(t kt mi2 ci)
 HashJoin(t kt mi2)
 HashJoin(t kt)
 SeqScan(t)
 IndexScan(kt)
 IndexScan(mi2)
 IndexScan(ci)
 IndexScan(rt)
 IndexScan(it2)
 IndexScan(mi1)
 IndexScan(n)
 SeqScan(it1)
 Leading(((((((((t kt) mi2) ci) rt) it2) mi1) n) it1)) */
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
AND it2.id = '7'
AND t.kind_id = kt.id
AND ci.person_id = n.id
AND ci.role_id = rt.id
AND mi1.info IN ('Comedy','Crime','Fantasy','Mystery','Short')
AND mi2.info IN ('LAB:FotoKem Laboratory, Burbank (CA), USA','MET:','MET:300 m','PCS:Spherical','RAT:1.33 : 1','RAT:1.66 : 1')
AND kt.kind IN ('movie','video movie')
AND rt.role IN ('miscellaneous crew')
AND n.gender IN ('f')
AND t.production_year <= 2015
AND 1950 < t.production_year


/*+ NestLoop(t mi1 mi2 ci rt it2 kt n it1)
 NestLoop(t mi1 mi2 ci rt it2 kt n)
 HashJoin(t mi1 mi2 ci rt it2 kt)
 NestLoop(t mi1 mi2 ci rt it2)
 NestLoop(t mi1 mi2 ci rt)
 NestLoop(t mi1 mi2 ci)
 HashJoin(t mi1 mi2)
 HashJoin(t mi1)
 IndexScan(t)
 SeqScan(mi1)
 IndexScan(mi2)
 IndexScan(ci)
 SeqScan(rt)
 IndexScan(it2)
 IndexScan(kt)
 IndexScan(n)
 SeqScan(it1)
 Leading(((((((((t mi1) mi2) ci) rt) it2) kt) n) it1)) */
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
AND it2.id = '7'
AND t.kind_id = kt.id
AND ci.person_id = n.id
AND ci.role_id = rt.id
AND mi1.info IN ('Fantasy','Mystery','Short')
AND mi2.info IN ('LAB:FotoKem Laboratory, Burbank (CA), USA','MET:','MET:300 m','PCS:Spherical','RAT:1.33 : 1','RAT:1.66 : 1')
AND kt.kind IN ('episode','movie','video movie')
AND rt.role IN ('miscellaneous crew')
AND n.gender IN ('f')
AND t.production_year <= 2015
AND 1925 < t.production_year


/*+ NestLoop(n pi1 ci it5 an t kt rt mii1 it3 mii2 it4 mk mi1 it1 k)
 NestLoop(n pi1 ci it5 an t kt rt mii1 it3 mii2 it4 mk mi1 it1)
 NestLoop(n pi1 ci it5 an t kt rt mii1 it3 mii2 it4 mk mi1)
 NestLoop(n pi1 ci it5 an t kt rt mii1 it3 mii2 it4 mk)
 NestLoop(n pi1 ci it5 an t kt rt mii1 it3 mii2 it4)
 NestLoop(n pi1 ci it5 an t kt rt mii1 it3 mii2)
 NestLoop(n pi1 ci it5 an t kt rt mii1 it3)
 NestLoop(n pi1 ci it5 an t kt rt mii1)
 NestLoop(n pi1 ci it5 an t kt rt)
 NestLoop(n pi1 ci it5 an t kt)
 HashJoin(n pi1 ci it5 an t)
 NestLoop(n pi1 ci it5 an)
 NestLoop(n pi1 ci it5)
 NestLoop(n pi1 ci)
 NestLoop(n pi1)
 IndexScan(n)
 IndexScan(pi1)
 IndexScan(ci)
 SeqScan(it5)
 IndexScan(an)
 SeqScan(t)
 IndexScan(kt)
 IndexScan(rt)
 IndexScan(mii1)
 SeqScan(it3)
 IndexScan(mii2)
 IndexScan(it4)
 IndexScan(mk)
 IndexScan(mi1)
 SeqScan(it1)
 IndexScan(k)
 Leading((((((((((((((((n pi1) ci) it5) an) t) kt) rt) mii1) it3) mii2) it4) mk) mi1) it1) k)) */
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
AND (mi1.info IN ('Austria','Czechoslovakia','Denmark','Hong Kong','Poland','Portugal','South Korea','Soviet Union','Sweden','Switzerland','Turkey','Yugoslavia'))
AND (it1.id IN ('15','8','97'))
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
AND rt.id = ci.role_id
AND (n.gender IS NULL)
AND (n.name_pcode_nf in ('C5321','C6231','C6235','R516','R5316','S3152','S3521') OR n.name_pcode_nf IS NULL)
AND (ci.note in ('(deviser)','(producer)','(production assistant)','(senior producer)','(supervising producer)','(writer)') OR ci.note IS NULL)
AND (rt.role in ('cinematographer','composer','director','editor','miscellaneous crew','producer','production designer','writer'))
AND (it5.id in ('19'))


/*+ NestLoop(n pi1 ci it5 an t kt rt mii1 it3 mii2 it4 mk mi1 it1 k)
 NestLoop(n pi1 ci it5 an t kt rt mii1 it3 mii2 it4 mk mi1 it1)
 NestLoop(n pi1 ci it5 an t kt rt mii1 it3 mii2 it4 mk mi1)
 NestLoop(n pi1 ci it5 an t kt rt mii1 it3 mii2 it4 mk)
 NestLoop(n pi1 ci it5 an t kt rt mii1 it3 mii2 it4)
 NestLoop(n pi1 ci it5 an t kt rt mii1 it3 mii2)
 NestLoop(n pi1 ci it5 an t kt rt mii1 it3)
 NestLoop(n pi1 ci it5 an t kt rt mii1)
 NestLoop(n pi1 ci it5 an t kt rt)
 NestLoop(n pi1 ci it5 an t kt)
 HashJoin(n pi1 ci it5 an t)
 NestLoop(n pi1 ci it5 an)
 NestLoop(n pi1 ci it5)
 NestLoop(n pi1 ci)
 NestLoop(n pi1)
 IndexScan(n)
 IndexScan(pi1)
 IndexScan(ci)
 SeqScan(it5)
 IndexScan(an)
 SeqScan(t)
 IndexScan(kt)
 IndexScan(rt)
 IndexScan(mii1)
 SeqScan(it3)
 IndexScan(mii2)
 IndexScan(it4)
 IndexScan(mk)
 IndexScan(mi1)
 SeqScan(it1)
 IndexScan(k)
 Leading((((((((((((((((n pi1) ci) it5) an) t) kt) rt) mii1) it3) mii2) it4) mk) mi1) it1) k)) */
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
AND (mi1.info IN ('Hong Kong','Poland','Portugal','South Korea','Soviet Union','Sweden','Switzerland','Turkey','Yugoslavia'))
AND (it1.id IN ('15','8','97'))
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
AND rt.id = ci.role_id
AND (n.gender IS NULL)
AND (n.name_pcode_nf in ('A4163','A4253','A5362','A6532','C5321','C6231','C6235','R516','R5316','S3152','S3521') OR n.name_pcode_nf IS NULL)
AND (ci.note in ('(deviser)','(producer)','(production assistant)','(senior producer)','(supervising producer)','(writer)') OR ci.note IS NULL)
AND (rt.role in ('cinematographer','composer','director','editor','miscellaneous crew','producer','production designer','writer'))
AND (it5.id in ('19'))


/*+ HashJoin(kt n mk k mc cn ci rt ct t)
 MergeJoin(n mk k mc cn ci rt ct t)
 HashJoin(n mk k mc cn ci rt ct)
 MergeJoin(n mk k mc cn ci rt)
 HashJoin(n mk k mc cn ci)
 NestLoop(mk k mc cn ci)
 HashJoin(mk k mc cn)
 HashJoin(mk k mc)
 HashJoin(mk k)
 SeqScan(kt)
 SeqScan(n)
 SeqScan(mk)
 SeqScan(k)
 SeqScan(mc)
 IndexScan(cn)
 IndexScan(ci)
 SeqScan(rt)
 IndexScan(ct)
 SeqScan(t)
 Leading((kt ((((n ((((mk k) mc) cn) ci)) rt) ct) t))) */
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
AND (t.production_year >= 1900)
AND (k.keyword IN ('bare-breasts','based-on-novel','doctor','surrealism'))
AND (cn.country_code IN ('[cn]','[my]'))
AND (ct.kind IN ('production companies'))
AND (kt.kind IN ('tv movie','tv series','video game'))
AND (rt.role IN ('miscellaneous crew','producer'))
AND (n.gender IN ('m'))


/*+ MergeJoin(n pi1 it5 ci t kt rt mii1 an mii2 it4 it3 mi1 it1 mk k)
 NestLoop(n pi1 it5 ci t kt rt mii1 an mii2 it4 it3 mi1 it1 mk)
 NestLoop(n pi1 it5 ci t kt rt mii1 an mii2 it4 it3 mi1 it1)
 NestLoop(n pi1 it5 ci t kt rt mii1 an mii2 it4 it3 mi1)
 NestLoop(n pi1 it5 ci t kt rt mii1 an mii2 it4 it3)
 NestLoop(n pi1 it5 ci t kt rt mii1 an mii2 it4)
 NestLoop(n pi1 it5 ci t kt rt mii1 an mii2)
 NestLoop(n pi1 it5 ci t kt rt mii1 an)
 NestLoop(n pi1 it5 ci t kt rt mii1)
 NestLoop(n pi1 it5 ci t kt rt)
 NestLoop(n pi1 it5 ci t kt)
 HashJoin(n pi1 it5 ci t)
 NestLoop(n pi1 it5 ci)
 NestLoop(n pi1 it5)
 NestLoop(n pi1)
 IndexScan(n)
 IndexScan(pi1)
 SeqScan(it5)
 IndexScan(ci)
 SeqScan(t)
 IndexScan(kt)
 IndexScan(rt)
 IndexScan(mii1)
 IndexScan(an)
 IndexScan(mii2)
 IndexScan(it4)
 IndexScan(it3)
 IndexScan(mi1)
 IndexScan(it1)
 IndexScan(mk)
 IndexScan(k)
 Leading((((((((((((((((n pi1) it5) ci) t) kt) rt) mii1) an) mii2) it4) it3) mi1) it1) mk) k)) */
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
AND (kt.kind IN ('episode'))
AND (t.production_year <= 1975)
AND (t.production_year >= 1875)
AND (mi1.info IN ('Color','OFM:Live','OFM:Video','PFM:Video'))
AND (it1.id IN ('103','2','7'))
AND it3.id = '100'
AND it4.id = '101'
AND (mii2.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND mii2.info::float <= 11.0)
AND (mii2.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND 7.0 <= mii2.info::float)
AND (mii1.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND 0.0 <= mii1.info::float)
AND (mii1.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND mii1.info::float <= 10000.0)
AND n.id = ci.person_id
AND ci.person_id = pi1.person_id
AND it5.id = pi1.info_type_id
AND n.id = pi1.person_id
AND n.id = an.person_id
AND rt.id = ci.role_id
AND (n.gender in ('m'))
AND (n.name_pcode_nf in ('C6231','F6362','F6525','J513','R1631','R1632','R1636','R2631','S2153'))
AND (ci.note IS NULL)
AND (rt.role in ('actor'))
AND (it5.id in ('25'))


/*+ MergeJoin(n pi1 it5 ci t kt rt mii1 an mii2 it4 it3 mi1 it1 mk k)
 NestLoop(n pi1 it5 ci t kt rt mii1 an mii2 it4 it3 mi1 it1 mk)
 NestLoop(n pi1 it5 ci t kt rt mii1 an mii2 it4 it3 mi1 it1)
 NestLoop(n pi1 it5 ci t kt rt mii1 an mii2 it4 it3 mi1)
 NestLoop(n pi1 it5 ci t kt rt mii1 an mii2 it4 it3)
 NestLoop(n pi1 it5 ci t kt rt mii1 an mii2 it4)
 NestLoop(n pi1 it5 ci t kt rt mii1 an mii2)
 NestLoop(n pi1 it5 ci t kt rt mii1 an)
 NestLoop(n pi1 it5 ci t kt rt mii1)
 NestLoop(n pi1 it5 ci t kt rt)
 NestLoop(n pi1 it5 ci t kt)
 HashJoin(n pi1 it5 ci t)
 NestLoop(n pi1 it5 ci)
 NestLoop(n pi1 it5)
 NestLoop(n pi1)
 IndexScan(n)
 IndexScan(pi1)
 SeqScan(it5)
 IndexScan(ci)
 SeqScan(t)
 IndexScan(kt)
 IndexScan(rt)
 IndexScan(mii1)
 IndexScan(an)
 IndexScan(mii2)
 IndexScan(it4)
 IndexScan(it3)
 IndexScan(mi1)
 IndexScan(it1)
 IndexScan(mk)
 IndexScan(k)
 Leading((((((((((((((((n pi1) it5) ci) t) kt) rt) mii1) an) mii2) it4) it3) mi1) it1) mk) k)) */
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
AND (kt.kind IN ('episode'))
AND (t.production_year <= 1975)
AND (t.production_year >= 1875)
AND (mi1.info IN ('Color','OFM:Live','OFM:Video','PFM:Video'))
AND (it1.id IN ('103','2','7'))
AND it3.id = '100'
AND it4.id = '101'
AND (mii2.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND mii2.info::float <= 11.0)
AND (mii2.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND 7.0 <= mii2.info::float)
AND (mii1.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND 0.0 <= mii1.info::float)
AND (mii1.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND mii1.info::float <= 10000.0)
AND n.id = ci.person_id
AND ci.person_id = pi1.person_id
AND it5.id = pi1.info_type_id
AND n.id = pi1.person_id
AND n.id = an.person_id
AND rt.id = ci.role_id
AND (n.gender in ('m','f'))
AND (n.name_pcode_nf in ('C6231','F6362','F6525','J513','R1631','R1632','R1636','R2631','S2153'))
AND (ci.note IS NULL)
AND (rt.role in ('actor','actress'))
AND (it5.id in ('25'))


/*+ HashJoin(rt an pi1 n it1 ci)
 NestLoop(an pi1 n it1 ci)
 NestLoop(an pi1 n it1)
 HashJoin(an pi1 n)
 NestLoop(pi1 n)
 IndexScan(rt)
 SeqScan(an)
 SeqScan(pi1)
 IndexScan(n)
 IndexScan(it1)
 IndexScan(ci)
 Leading((rt (((an (pi1 n)) it1) ci))) */
SELECT COUNT(*)
FROM
name as n,
aka_name as an,
info_type as it1,
person_info AS pi1,
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


/*+ NestLoop(n pi1 it1 ci an rt)
 HashJoin(n pi1 it1 ci an)
 NestLoop(n pi1 it1 ci)
 HashJoin(n pi1 it1)
 HashJoin(n pi1)
 SeqScan(n)
 SeqScan(pi1)
 SeqScan(it1)
 IndexScan(ci)
 SeqScan(an)
 IndexScan(rt)
 Leading((((((n pi1) it1) ci) an) rt)) */
SELECT COUNT(*)
FROM
name as n,
aka_name as an,
info_type as it1,
person_info AS pi1,
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
AND (n.gender in ('m') OR n.gender IS NULL)
AND (n.name_pcode_nf in ('A6364','B6252','E3634','G6216','J162','J5162','J5236','K6231','L6525','P3624','R1632','R52','T5242','V2362') OR n.name_pcode_nf IS NULL)
AND (ci.note in ('(executive producer)') OR ci.note IS NULL)
AND (rt.role in ('actor','composer','producer'))
AND (it1.id in ('37'))


/*+ NestLoop(t mi_idx mi1 mii2 kt it4 it3 it1 mk k)
 NestLoop(t mi_idx mi1 mii2 kt it4 it3 it1 mk)
 NestLoop(t mi_idx mi1 mii2 kt it4 it3 it1)
 NestLoop(t mi_idx mi1 mii2 kt it4 it3)
 NestLoop(t mi_idx mi1 mii2 kt it4)
 HashJoin(t mi_idx mi1 mii2 kt)
 HashJoin(t mi_idx mi1 mii2)
 HashJoin(t mi_idx mi1)
 HashJoin(t mi_idx)
 SeqScan(t)
 SeqScan(mi_idx)
 SeqScan(mi1)
 IndexScan(mii2)
 IndexScan(kt)
 IndexScan(it4)
 IndexScan(it3)
 SeqScan(it1)
 IndexScan(mk)
 IndexScan(k)
 Leading((((((((((t mi_idx) mi1) mii2) kt) it4) it3) it1) mk) k)) */
SELECT COUNT(*)
FROM title as t,
movie_info as mi1,
kind_type as kt,
info_type as it1,
info_type as it3,
info_type as it4,
movie_info_idx as mi_idx,
movie_info_idx as mii2,
movie_keyword as mk,
keyword as k
WHERE
t.id = mi1.movie_id
AND t.id = mi_idx.movie_id
AND t.id = mii2.movie_id
AND t.id = mk.movie_id
AND mii2.movie_id = mi_idx.movie_id
AND mi1.movie_id = mi_idx.movie_id
AND mk.movie_id = mi1.movie_id
AND mk.keyword_id = k.id
AND mi1.info_type_id = it1.id
AND mi_idx.info_type_id = it3.id
AND mii2.info_type_id = it4.id
AND t.kind_id = kt.id
AND (kt.kind IN ('episode','movie'))
AND (t.production_year <= 1975)
AND (t.production_year >= 1925)
AND (mi1.info IN ('Mono'))
AND (it1.id IN ('6'))
AND it3.id = '100'
AND it4.id = '101'
AND (mii2.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND mii2.info::float <= 11.0)
AND (mii2.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND 7.0 <= mii2.info::float)
AND (mi_idx.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND 0.0 <= mi_idx.info::float)
AND (mi_idx.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND mi_idx.info::float <= 500.0)


/*+ NestLoop(mi1 mi_idx mii2 mk k it4 it3 it1 t kt)
 NestLoop(mi1 mi_idx mii2 mk k it4 it3 it1 t)
 NestLoop(mi1 mi_idx mii2 mk k it4 it3 it1)
 NestLoop(mi1 mi_idx mii2 mk k it4 it3)
 NestLoop(mi1 mi_idx mii2 mk k it4)
 HashJoin(mi1 mi_idx mii2 mk k)
 NestLoop(mi1 mi_idx mii2 mk)
 NestLoop(mi1 mi_idx mii2)
 NestLoop(mi1 mi_idx)
 IndexScan(mi1)
 IndexScan(mi_idx)
 IndexScan(mii2)
 IndexScan(mk)
 IndexScan(k)
 IndexScan(it4)
 SeqScan(it3)
 SeqScan(it1)
 IndexScan(t)
 IndexScan(kt)
 Leading((((((((((mi1 mi_idx) mii2) mk) k) it4) it3) it1) t) kt)) */
SELECT COUNT(*)
FROM title as t,
movie_info as mi1,
kind_type as kt,
info_type as it1,
info_type as it3,
info_type as it4,
movie_info_idx as mi_idx,
movie_info_idx as mii2,
movie_keyword as mk,
keyword as k
WHERE
t.id = mi1.movie_id
AND t.id = mi_idx.movie_id
AND t.id = mii2.movie_id
AND t.id = mk.movie_id
AND mii2.movie_id = mi_idx.movie_id
AND mi1.movie_id = mi_idx.movie_id
AND mk.movie_id = mi1.movie_id
AND mk.keyword_id = k.id
AND mi1.info_type_id = it1.id
AND mi_idx.info_type_id = it3.id
AND mii2.info_type_id = it4.id
AND t.kind_id = kt.id
AND (kt.kind IN ('tv movie','tv series','video game'))
AND (t.production_year <= 2015)
AND (t.production_year >= 1925)
AND (mi1.info IN ('OFM:35 mm','PFM:35 mm','RAT:1.78 : 1'))
AND (it1.id IN ('2','5','7'))
AND it3.id = '100'
AND it4.id = '101'
AND (mii2.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND mii2.info::float <= 3.0)
AND (mii2.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND 2.0 <= mii2.info::float)
AND (mi_idx.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND 500.0 <= mi_idx.info::float)
AND (mi_idx.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND mi_idx.info::float <= 7200.0)


/*+ MergeJoin(pi1 n it5 an ci t miidx mii2 it4 it3 mi1 rt kt it1)
 MergeJoin(pi1 n it5 an ci t miidx mii2 it4 it3 mi1 rt kt)
 NestLoop(pi1 n it5 an ci t miidx mii2 it4 it3 mi1 rt)
 NestLoop(pi1 n it5 an ci t miidx mii2 it4 it3 mi1)
 NestLoop(pi1 n it5 an ci t miidx mii2 it4 it3)
 NestLoop(pi1 n it5 an ci t miidx mii2 it4)
 NestLoop(pi1 n it5 an ci t miidx mii2)
 NestLoop(pi1 n it5 an ci t miidx)
 NestLoop(pi1 n it5 an ci t)
 NestLoop(pi1 n it5 an ci)
 NestLoop(pi1 n it5 an)
 HashJoin(pi1 n it5)
 HashJoin(pi1 n)
 SeqScan(pi1)
 SeqScan(n)
 SeqScan(it5)
 IndexScan(an)
 IndexScan(ci)
 IndexScan(t)
 IndexScan(miidx)
 IndexScan(mii2)
 SeqScan(it4)
 SeqScan(it3)
 IndexScan(mi1)
 IndexScan(rt)
 SeqScan(kt)
 IndexScan(it1)
 Leading((((((((((((((pi1 n) it5) an) ci) t) miidx) mii2) it4) it3) mi1) rt) kt) it1)) */
SELECT COUNT(*)
FROM title as t,
movie_info as mi1,
kind_type as kt,
info_type as it1,
info_type as it3,
info_type as it4,
movie_info_idx as miidx,
movie_info_idx as mii2,
aka_name as an,
name as n,
info_type as it5,
person_info AS pi1,
cast_info as ci,
role_type as rt
WHERE
t.id = mi1.movie_id
AND t.id = ci.movie_id
AND t.id = miidx.movie_id
AND t.id = mii2.movie_id
AND mii2.movie_id = miidx.movie_id
AND mi1.movie_id = miidx.movie_id
AND mi1.info_type_id = it1.id
AND miidx.info_type_id = it3.id
AND mii2.info_type_id = it4.id
AND t.kind_id = kt.id
AND (kt.kind IN ('episode','movie'))
AND (t.production_year <= 2015)
AND (t.production_year >= 1975)
AND (mi1.info IN ('Argentina','Canada','France','Germany','Italy','Japan','Mexico','Netherlands','Spain','UK','USA'))
AND (it1.id IN ('8'))
AND it3.id = '100'
AND it4.id = '101'
AND (mii2.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND mii2.info::float <= 4.0)
AND (mii2.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND 0.0 <= mii2.info::float)
AND (miidx.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND 0.0 <= miidx.info::float)
AND (miidx.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND miidx.info::float <= 1000.0)
AND n.id = ci.person_id
AND ci.person_id = pi1.person_id
AND it5.id = pi1.info_type_id
AND n.id = pi1.person_id
AND n.id = an.person_id
AND ci.person_id = an.person_id
AND an.person_id = pi1.person_id
AND rt.id = ci.role_id
AND (n.gender in ('f') OR n.gender IS NULL)
AND (n.name_pcode_nf in ('A5362','J2452','J5162','M2345','M252','M6453','R2562','S26','S3151','S3152','T5252','T6252') OR n.name_pcode_nf IS NULL)
AND (ci.note IS NULL)
AND (rt.role in ('actress','director','editor'))
AND (it5.id in ('19'))


/*+ MergeJoin(pi1 n it5 an ci rt t mii2 it4 miidx it3 mi1 it1 kt)
 NestLoop(pi1 n it5 an ci rt t mii2 it4 miidx it3 mi1 it1)
 NestLoop(pi1 n it5 an ci rt t mii2 it4 miidx it3 mi1)
 NestLoop(pi1 n it5 an ci rt t mii2 it4 miidx it3)
 NestLoop(pi1 n it5 an ci rt t mii2 it4 miidx)
 MergeJoin(pi1 n it5 an ci rt t mii2 it4)
 NestLoop(pi1 n it5 an ci rt t mii2)
 NestLoop(pi1 n it5 an ci rt t)
 NestLoop(pi1 n it5 an ci rt)
 NestLoop(pi1 n it5 an ci)
 NestLoop(pi1 n it5 an)
 NestLoop(pi1 n it5)
 HashJoin(pi1 n)
 SeqScan(pi1)
 SeqScan(n)
 IndexScan(it5)
 IndexScan(an)
 IndexScan(ci)
 IndexScan(rt)
 IndexScan(t)
 IndexScan(mii2)
 IndexScan(it4)
 IndexScan(miidx)
 SeqScan(it3)
 IndexScan(mi1)
 IndexScan(it1)
 IndexScan(kt)
 Leading((((((((((((((pi1 n) it5) an) ci) rt) t) mii2) it4) miidx) it3) mi1) it1) kt)) */
SELECT COUNT(*)
FROM title as t,
movie_info as mi1,
kind_type as kt,
info_type as it1,
info_type as it3,
info_type as it4,
movie_info_idx as miidx,
movie_info_idx as mii2,
aka_name as an,
name as n,
info_type as it5,
person_info AS pi1,
cast_info as ci,
role_type as rt
WHERE
t.id = mi1.movie_id
AND t.id = ci.movie_id
AND t.id = miidx.movie_id
AND t.id = mii2.movie_id
AND mii2.movie_id = miidx.movie_id
AND mi1.movie_id = miidx.movie_id
AND mi1.info_type_id = it1.id
AND miidx.info_type_id = it3.id
AND mii2.info_type_id = it4.id
AND t.kind_id = kt.id
AND (kt.kind IN ('episode','movie'))
AND (t.production_year <= 1990)
AND (t.production_year >= 1950)
AND (mi1.info IN ('Australia','Canada','Hong Kong','Mexico','OFM:16 mm','PFM:16 mm','Philippines','RAT:1.66 : 1','RAT:1.85 : 1','Soviet Union','Spain','Turkey','West Germany','Yugoslavia'))
AND (it1.id IN ('7','8','9'))
AND it3.id = '100'
AND it4.id = '101'
AND (mii2.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND mii2.info::float <= 5.0)
AND (mii2.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND 2.0 <= mii2.info::float)
AND (miidx.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND 0.0 <= miidx.info::float)
AND (miidx.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND miidx.info::float <= 10000.0)
AND n.id = ci.person_id
AND ci.person_id = pi1.person_id
AND it5.id = pi1.info_type_id
AND n.id = pi1.person_id
AND n.id = an.person_id
AND ci.person_id = an.person_id
AND an.person_id = pi1.person_id
AND rt.id = ci.role_id
AND (n.gender in ('m') OR n.gender IS NULL)
AND (n.name_pcode_nf in ('B6524','D1352','G6252','J25','J5235','M2412','M2423','M2424','M6241','M6252','M6352','S3153','W4125','W4361','W4525'))
AND (ci.note IS NULL)
AND (rt.role in ('actor'))
AND (it5.id in ('37'))


/*+ NestLoop(n pi1 it5 ci rt t kt mii2 it4 mii1 mk mi1 an it3 it1 k)
 NestLoop(n pi1 it5 ci rt t kt mii2 it4 mii1 mk mi1 an it3 it1)
 NestLoop(n pi1 it5 ci rt t kt mii2 it4 mii1 mk mi1 an it3)
 NestLoop(n pi1 it5 ci rt t kt mii2 it4 mii1 mk mi1 an)
 NestLoop(n pi1 it5 ci rt t kt mii2 it4 mii1 mk mi1)
 NestLoop(n pi1 it5 ci rt t kt mii2 it4 mii1 mk)
 NestLoop(n pi1 it5 ci rt t kt mii2 it4 mii1)
 NestLoop(n pi1 it5 ci rt t kt mii2 it4)
 NestLoop(n pi1 it5 ci rt t kt mii2)
 NestLoop(n pi1 it5 ci rt t kt)
 NestLoop(n pi1 it5 ci rt t)
 NestLoop(n pi1 it5 ci rt)
 NestLoop(n pi1 it5 ci)
 NestLoop(n pi1 it5)
 NestLoop(n pi1)
 IndexScan(n)
 IndexScan(pi1)
 SeqScan(it5)
 IndexScan(ci)
 IndexScan(rt)
 IndexScan(t)
 IndexScan(kt)
 IndexScan(mii2)
 SeqScan(it4)
 IndexScan(mii1)
 IndexScan(mk)
 IndexScan(mi1)
 IndexScan(an)
 SeqScan(it3)
 IndexScan(it1)
 IndexScan(k)
 Leading((((((((((((((((n pi1) it5) ci) rt) t) kt) mii2) it4) mii1) mk) mi1) an) it3) it1) k)) */
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
person_info AS pi1,
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
AND (t.production_year <= 1990)
AND (t.production_year >= 1950)
AND (mi1.info IN ('Comedy','Documentary','Drama'))
AND (it1.id IN ('103','3','6'))
AND it3.id = '100'
AND it4.id = '101'
AND (mii2.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND mii2.info::float <= 11.0)
AND (mii2.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND 7.0 <= mii2.info::float)
AND (mii1.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND 0.0 <= mii1.info::float)
AND (mii1.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND mii1.info::float <= 1000.0)
AND n.id = ci.person_id
AND ci.person_id = pi1.person_id
AND it5.id = pi1.info_type_id
AND n.id = pi1.person_id
AND n.id = an.person_id
AND rt.id = ci.role_id
AND (n.gender in ('f') OR n.gender IS NULL)
AND (n.name_pcode_nf in ('B6161','C6235','C6416','C6452','D5162','E4213','J5215','M6216','M6263','R3565'))
AND (ci.note IS NULL)
AND (rt.role in ('actress','director'))
AND (it5.id in ('31'))


/*+ NestLoop(n pi1 it5 ci rt t kt mii2 it4 mii1 mk it3 an mi1 it1 k)
 MergeJoin(n pi1 it5 ci rt t kt mii2 it4 mii1 mk it3 an mi1 it1)
 NestLoop(n pi1 it5 ci rt t kt mii2 it4 mii1 mk it3 an mi1)
 HashJoin(n pi1 it5 ci rt t kt mii2 it4 mii1 mk it3 an)
 NestLoop(n pi1 it5 ci rt t kt mii2 it4 mii1 mk it3)
 NestLoop(n pi1 it5 ci rt t kt mii2 it4 mii1 mk)
 NestLoop(n pi1 it5 ci rt t kt mii2 it4 mii1)
 NestLoop(n pi1 it5 ci rt t kt mii2 it4)
 NestLoop(n pi1 it5 ci rt t kt mii2)
 NestLoop(n pi1 it5 ci rt t kt)
 NestLoop(n pi1 it5 ci rt t)
 NestLoop(n pi1 it5 ci rt)
 NestLoop(n pi1 it5 ci)
 NestLoop(n pi1 it5)
 NestLoop(n pi1)
 IndexScan(n)
 IndexScan(pi1)
 SeqScan(it5)
 IndexScan(ci)
 IndexScan(rt)
 IndexScan(t)
 IndexScan(kt)
 IndexScan(mii2)
 IndexScan(it4)
 IndexScan(mii1)
 IndexScan(mk)
 SeqScan(it3)
 SeqScan(an)
 IndexScan(mi1)
 SeqScan(it1)
 IndexScan(k)
 Leading((((((((((((((((n pi1) it5) ci) rt) t) kt) mii2) it4) mii1) mk) it3) an) mi1) it1) k)) */
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
person_info AS pi1,
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
AND (t.production_year <= 1990)
AND (t.production_year >= 1950)
AND (mi1.info IN ('30','60'))
AND (it1.id IN ('1','17','98'))
AND it3.id = '100'
AND it4.id = '101'
AND (mii2.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND mii2.info::float <= 11.0)
AND (mii2.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND 7.0 <= mii2.info::float)
AND (mii1.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND 0.0 <= mii1.info::float)
AND (mii1.info ~ '^(?:[1-9]\d*|0)?(?:\.\d+)?$' AND mii1.info::float <= 10000.0)
AND n.id = ci.person_id
AND ci.person_id = pi1.person_id
AND it5.id = pi1.info_type_id
AND n.id = pi1.person_id
AND n.id = an.person_id
AND rt.id = ci.role_id
AND (n.gender in ('m') OR n.gender IS NULL)
AND (n.name_pcode_nf in ('A5351','C6235','C6421','C6425','F6362','F6521','J5216','J525','P3623','R1632','R1636','V4356','V5253') OR n.name_pcode_nf IS NULL)
AND (ci.note in ('(producer)') OR ci.note IS NULL)
AND (rt.role in ('actor','composer','producer'))
AND (it5.id in ('31'))


/*+ MergeJoin(n pi1 it5 ci t kt rt mii1 mii2 it4 an it3 mi1 it1 mk k)
 NestLoop(n pi1 it5 ci t kt rt mii1 mii2 it4 an it3 mi1 it1 mk)
 NestLoop(n pi1 it5 ci t kt rt mii1 mii2 it4 an it3 mi1 it1)
 NestLoop(n pi1 it5 ci t kt rt mii1 mii2 it4 an it3 mi1)
 NestLoop(n pi1 it5 ci t kt rt mii1 mii2 it4 an it3)
 NestLoop(n pi1 it5 ci t kt rt mii1 mii2 it4 an)
 NestLoop(n pi1 it5 ci t kt rt mii1 mii2 it4)
 NestLoop(n pi1 it5 ci t kt rt mii1 mii2)
 HashJoin(n pi1 it5 ci t kt rt mii1)
 NestLoop(n pi1 it5 ci t kt rt)
 NestLoop(n pi1 it5 ci t kt)
 NestLoop(n pi1 it5 ci t)
 NestLoop(n pi1 it5 ci)
 NestLoop(n pi1 it5)
 NestLoop(n pi1)
 IndexScan(n)
 IndexScan(pi1)
 SeqScan(it5)
 IndexScan(ci)
 IndexScan(t)
 IndexScan(kt)
 IndexScan(rt)
 SeqScan(mii1)
 IndexScan(mii2)
 IndexScan(it4)
 IndexScan(an)
 SeqScan(it3)
 IndexScan(mi1)
 IndexScan(it1)
 IndexScan(mk)
 IndexScan(k)
 Leading((((((((((((((((n pi1) it5) ci) t) kt) rt) mii1) mii2) it4) an) it3) mi1) it1) mk) k)) */
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
AND (t.production_year >= 1975)
AND (mi1.info IN ('Biography','Fantasy','OFM:35 mm','OFM:Video','Romance','Sci-Fi','Sport','Thriller'))
AND (it1.id IN ('3','7'))
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
AND rt.id = ci.role_id
AND (n.gender in ('f') OR n.gender IS NULL)
AND (n.name_pcode_nf in ('C6235') OR n.name_pcode_nf IS NULL)
AND (ci.note in ('(archive footage)') OR ci.note IS NULL)
AND (rt.role in ('actress'))
AND (it5.id in ('34'))


/*+ MergeJoin(n pi1 it5 ci t kt rt mii1 mii2 it4 an it3 mi1 it1 mk k)
 NestLoop(n pi1 it5 ci t kt rt mii1 mii2 it4 an it3 mi1 it1 mk)
 NestLoop(n pi1 it5 ci t kt rt mii1 mii2 it4 an it3 mi1 it1)
 NestLoop(n pi1 it5 ci t kt rt mii1 mii2 it4 an it3 mi1)
 NestLoop(n pi1 it5 ci t kt rt mii1 mii2 it4 an it3)
 NestLoop(n pi1 it5 ci t kt rt mii1 mii2 it4 an)
 NestLoop(n pi1 it5 ci t kt rt mii1 mii2 it4)
 NestLoop(n pi1 it5 ci t kt rt mii1 mii2)
 HashJoin(n pi1 it5 ci t kt rt mii1)
 NestLoop(n pi1 it5 ci t kt rt)
 NestLoop(n pi1 it5 ci t kt)
 NestLoop(n pi1 it5 ci t)
 NestLoop(n pi1 it5 ci)
 NestLoop(n pi1 it5)
 NestLoop(n pi1)
 IndexScan(n)
 IndexScan(pi1)
 SeqScan(it5)
 IndexScan(ci)
 IndexScan(t)
 IndexScan(kt)
 IndexScan(rt)
 SeqScan(mii1)
 IndexScan(mii2)
 IndexScan(it4)
 IndexScan(an)
 SeqScan(it3)
 IndexScan(mi1)
 IndexScan(it1)
 IndexScan(mk)
 IndexScan(k)
 Leading((((((((((((((((n pi1) it5) ci) t) kt) rt) mii1) mii2) it4) an) it3) mi1) it1) mk) k)) */
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
AND (t.production_year >= 1975)
AND (mi1.info IN ('Biography','Fantasy','OFM:35 mm','OFM:Video','Romance','Sci-Fi','Sport','Thriller'))
AND (it1.id IN ('3','7'))
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
AND rt.id = ci.role_id
AND (n.gender in ('m') OR n.gender IS NULL)
AND (n.name_pcode_nf in ('C6235') OR n.name_pcode_nf IS NULL)
AND (ci.note in ('(archive footage)') OR ci.note IS NULL)
AND (rt.role in ('actor'))
AND (it5.id in ('34'))


/*+ NestLoop(n pi1 it5 ci t kt rt mii1 mii2 it3 it4 an mi1 it1 mk k)
 NestLoop(n pi1 it5 ci t kt rt mii1 mii2 it3 it4 an mi1 it1 mk)
 NestLoop(n pi1 it5 ci t kt rt mii1 mii2 it3 it4 an mi1 it1)
 NestLoop(n pi1 it5 ci t kt rt mii1 mii2 it3 it4 an mi1)
 NestLoop(n pi1 it5 ci t kt rt mii1 mii2 it3 it4 an)
 NestLoop(n pi1 it5 ci t kt rt mii1 mii2 it3 it4)
 NestLoop(n pi1 it5 ci t kt rt mii1 mii2 it3)
 NestLoop(n pi1 it5 ci t kt rt mii1 mii2)
 HashJoin(n pi1 it5 ci t kt rt mii1)
 NestLoop(n pi1 it5 ci t kt rt)
 NestLoop(n pi1 it5 ci t kt)
 NestLoop(n pi1 it5 ci t)
 NestLoop(n pi1 it5 ci)
 NestLoop(n pi1 it5)
 NestLoop(n pi1)
 IndexScan(n)
 IndexScan(pi1)
 SeqScan(it5)
 IndexScan(ci)
 IndexScan(t)
 IndexScan(kt)
 IndexScan(rt)
 SeqScan(mii1)
 IndexScan(mii2)
 IndexScan(it3)
 SeqScan(it4)
 IndexScan(an)
 IndexScan(mi1)
 IndexScan(it1)
 IndexScan(mk)
 IndexScan(k)
 Leading((((((((((((((((n pi1) it5) ci) t) kt) rt) mii1) mii2) it3) it4) an) mi1) it1) mk) k)) */
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
AND (t.production_year >= 1975)
AND (mi1.info IN ('Sci-Fi','Sport','Thriller'))
AND (it1.id IN ('3','7'))
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
AND rt.id = ci.role_id
AND (n.gender in ('f') OR n.gender IS NULL)
AND (n.name_pcode_nf in ('C6235') OR n.name_pcode_nf IS NULL)
AND (ci.note in ('(archive footage)') OR ci.note IS NULL)
AND (rt.role in ('actress'))
AND (it5.id in ('34'))


/*+ HashJoin(n ci rt t mi1 it1 mc ct cn mk k kt)
 HashJoin(n ci rt t mi1 it1 mc ct cn mk k)
 HashJoin(n ci rt t mi1 it1 mc ct cn mk)
 NestLoop(n ci rt t mi1 it1 mc ct cn)
 MergeJoin(n ci rt t mi1 it1 mc ct)
 HashJoin(n ci rt t mi1 it1 mc)
 HashJoin(n ci rt t mi1 it1)
 NestLoop(n ci rt t mi1)
 HashJoin(n ci rt t)
 HashJoin(n ci rt)
 NestLoop(n ci)
 IndexScan(n)
 IndexScan(ci)
 SeqScan(rt)
 SeqScan(t)
 IndexScan(mi1)
 SeqScan(it1)
 SeqScan(mc)
 IndexScan(ct)
 IndexScan(cn)
 SeqScan(mk)
 IndexScan(k)
 IndexScan(kt)
 Leading((((((((((((n ci) rt) t) mi1) it1) mc) ct) cn) mk) k) kt)) */
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
AND (it1.id IN ('7'))
AND (mi1.info in ('OFM:35 mm','PFM:35 mm','RAT:1.33 : 1','RAT:1.78 : 1','RAT:16:9 HD'))
AND (kt.kind in ('episode','movie','tv movie','tv series'))
AND (rt.role in ('actor','composer','editor','miscellaneous crew','producer'))
AND (n.gender in ('m') OR n.gender IS NULL)
AND (n.name_pcode_cf in ('A2365','A6252','C52','C6325','E1524','J5252','P6235','Q5325','R1632','R2425','R25','R3626','V4524','V4626'))
AND (t.production_year <= 2015)
AND (t.production_year >= 1925)
AND (cn.name in ('ABS-CBN','British Broadcasting Corporation (BBC)','Granada Television','National Broadcasting Company (NBC)'))
AND (ct.kind in ('distributors','production companies'))


/*+ NestLoop(t n ci mi1 rt mc it1 ct kt cn mk k)
 NestLoop(t n ci mi1 rt mc it1 ct kt cn mk)
 HashJoin(t n ci mi1 rt mc it1 ct kt cn)
 NestLoop(t n ci mi1 rt mc it1 ct kt)
 NestLoop(t n ci mi1 rt mc it1 ct)
 HashJoin(t n ci mi1 rt mc it1)
 HashJoin(t n ci mi1 rt mc)
 HashJoin(t n ci mi1 rt)
 NestLoop(t n ci mi1)
 HashJoin(t n ci)
 NestLoop(n ci)
 IndexScan(t)
 IndexScan(n)
 IndexScan(ci)
 IndexScan(mi1)
 SeqScan(rt)
 SeqScan(mc)
 IndexScan(it1)
 IndexScan(ct)
 IndexScan(kt)
 IndexScan(cn)
 IndexScan(mk)
 IndexScan(k)
 Leading(((((((((((t (n ci)) mi1) rt) mc) it1) ct) kt) cn) mk) k)) */
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


/*+ NestLoop(n pi1 it5 ci an t kt mii1 mii2 it4 it3 mi1 it1 rt)
 MergeJoin(n pi1 it5 ci an t kt mii1 mii2 it4 it3 mi1 it1)
 NestLoop(n pi1 it5 ci an t kt mii1 mii2 it4 it3 mi1)
 NestLoop(n pi1 it5 ci an t kt mii1 mii2 it4 it3)
 NestLoop(n pi1 it5 ci an t kt mii1 mii2 it4)
 NestLoop(n pi1 it5 ci an t kt mii1 mii2)
 HashJoin(n pi1 it5 ci an t kt mii1)
 NestLoop(n pi1 it5 ci an t kt)
 NestLoop(n pi1 it5 ci an t)
 NestLoop(n pi1 it5 ci an)
 NestLoop(n pi1 it5 ci)
 NestLoop(n pi1 it5)
 NestLoop(n pi1)
 IndexScan(n)
 IndexScan(pi1)
 SeqScan(it5)
 IndexScan(ci)
 IndexScan(an)
 IndexScan(t)
 IndexScan(kt)
 SeqScan(mii1)
 IndexScan(mii2)
 SeqScan(it4)
 SeqScan(it3)
 IndexScan(mi1)
 SeqScan(it1)
 IndexScan(rt)
 Leading((((((((((((((n pi1) it5) ci) an) t) kt) mii1) mii2) it4) it3) mi1) it1) rt)) */
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
AND (mi1.info IN ('Black and White'))
AND (it1.id IN ('2'))
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
AND (n.gender in ('f') OR n.gender IS NULL)
AND (n.name_pcode_nf in ('A5136','B4532','C6435','H4524','J2451','J6362','L2525','M6415','S4125','W5245'))
AND (ci.note in ('(writer)') OR ci.note IS NULL)
AND (rt.role in ('actress','cinematographer','writer'))
AND (it5.id in ('26'))


/*+ HashJoin(n pi1 it2 ci t mi1 rt it1 kt)
 HashJoin(n pi1 it2 ci t mi1 rt it1)
 HashJoin(n pi1 it2 ci t mi1 rt)
 HashJoin(n pi1 it2 ci t mi1)
 HashJoin(n pi1 it2 ci t)
 HashJoin(n pi1 it2 ci)
 HashJoin(n pi1 it2)
 HashJoin(n pi1)
 IndexScan(n)
 SeqScan(pi1)
 IndexScan(it2)
 SeqScan(ci)
 SeqScan(t)
 IndexScan(mi1)
 SeqScan(rt)
 IndexScan(it1)
 SeqScan(kt)
 Leading(((((((((n pi1) it2) ci) t) mi1) rt) it1) kt)) */
SELECT mi1.info, pi1.info, COUNT(*)
FROM title as t,
kind_type as kt,
movie_info as mi1,
info_type as it1,
cast_info as ci,
role_type as rt,
name as n,
info_type as it2,
person_info AS pi1
WHERE
t.id = ci.movie_id
AND t.id = mi1.movie_id
AND mi1.info_type_id = it1.id
AND t.kind_id = kt.id
AND ci.person_id = n.id
AND ci.movie_id = mi1.movie_id
AND ci.role_id = rt.id
AND n.id = pi1.person_id
AND pi1.info_type_id = it2.id
AND (it1.id IN ('16'))
AND (it2.id IN ('23'))
AND (mi1.info ILIKE '%usa%')
AND (pi1.info ILIKE '%19%')
AND (kt.kind IN ('movie','tv mini series','tv movie','video game'))
AND (rt.role IN ('cinematographer','composer','costume designer','director','editor','miscellaneous crew','producer','writer'))
GROUP BY mi1.info, pi1.info


/*+ HashJoin(kt mi1 n pi1 it2 ci it1 rt t)
 HashJoin(mi1 n pi1 it2 ci it1 rt t)
 HashJoin(mi1 n pi1 it2 ci it1 rt)
 HashJoin(mi1 n pi1 it2 ci it1)
 HashJoin(mi1 n pi1 it2 ci)
 NestLoop(n pi1 it2 ci)
 NestLoop(n pi1 it2)
 HashJoin(n pi1)
 IndexScan(kt)
 SeqScan(mi1)
 IndexScan(n)
 IndexScan(pi1)
 IndexScan(it2)
 IndexScan(ci)
 SeqScan(it1)
 SeqScan(rt)
 IndexScan(t)
 Leading((kt ((((mi1 (((n pi1) it2) ci)) it1) rt) t))) */
SELECT mi1.info, pi1.info, COUNT(*)
FROM title as t,
kind_type as kt,
movie_info as mi1,
info_type as it1,
cast_info as ci,
role_type as rt,
name as n,
info_type as it2,
person_info AS pi1
WHERE
t.id = ci.movie_id
AND t.id = mi1.movie_id
AND mi1.info_type_id = it1.id
AND t.kind_id = kt.id
AND ci.person_id = n.id
AND ci.movie_id = mi1.movie_id
AND ci.role_id = rt.id
AND n.id = pi1.person_id
AND pi1.info_type_id = it2.id
AND (it1.id IN ('16'))
AND (it2.id IN ('21'))
AND (mi1.info ILIKE '%spai%')
AND (pi1.info ILIKE '%196%')
AND (kt.kind IN ('episode','movie','tv mini series','tv movie','video game','video movie'))
AND (rt.role IN ('actor','actress','cinematographer','composer','costume designer','director','guest','miscellaneous crew','producer','production designer','writer'))
GROUP BY mi1.info, pi1.info


/*+ NestLoop(n pi1 ci it2 t kt mi1 it1 rt)
 NestLoop(n pi1 ci it2 t kt mi1 it1)
 NestLoop(n pi1 ci it2 t kt mi1)
 NestLoop(n pi1 ci it2 t kt)
 NestLoop(n pi1 ci it2 t)
 NestLoop(n pi1 ci it2)
 NestLoop(n pi1 ci)
 HashJoin(n pi1)
 SeqScan(n)
 SeqScan(pi1)
 IndexScan(ci)
 SeqScan(it2)
 IndexScan(t)
 SeqScan(kt)
 IndexScan(mi1)
 SeqScan(it1)
 IndexScan(rt)
 Leading(((((((((n pi1) ci) it2) t) kt) mi1) it1) rt)) */
SELECT mi1.info, n.name, COUNT(*)
FROM title as t,
kind_type as kt,
movie_info as mi1,
info_type as it1,
cast_info as ci,
role_type as rt,
name as n,
info_type as it2,
person_info AS pi1
WHERE
t.id = ci.movie_id
AND t.id = mi1.movie_id
AND mi1.info_type_id = it1.id
AND t.kind_id = kt.id
AND ci.person_id = n.id
AND ci.movie_id = mi1.movie_id
AND ci.role_id = rt.id
AND n.id = pi1.person_id
AND pi1.info_type_id = it2.id
AND (it1.id IN ('3','6','8'))
AND (it2.id IN ('24'))
AND (mi1.info IN ('Animation','Belgium','Brazil','Comedy','Crime','Documentary','Family','France','Italy','Mexico','Mono','Musical','Mystery','Netherlands','Romance','Sport','Stereo','Thriller','UK'))
AND (n.name ILIKE '%co%')
AND (kt.kind IN ('tv movie','tv series','video game'))
AND (rt.role IN ('actress','director','miscellaneous crew','producer'))
AND (t.production_year <= 1975)
AND (t.production_year >= 1875)
GROUP BY mi1.info, n.name


/*+ HashJoin(pi1 n ci t kt it2 rt mi1 it1)
 NestLoop(pi1 n ci t kt it2 rt mi1)
 NestLoop(pi1 n ci t kt it2 rt)
 NestLoop(pi1 n ci t kt it2)
 NestLoop(pi1 n ci t kt)
 HashJoin(pi1 n ci t)
 NestLoop(pi1 n ci)
 HashJoin(pi1 n)
 SeqScan(pi1)
 SeqScan(n)
 IndexScan(ci)
 IndexScan(t)
 IndexScan(kt)
 SeqScan(it2)
 SeqScan(rt)
 IndexScan(mi1)
 IndexScan(it1)
 Leading(((((((((pi1 n) ci) t) kt) it2) rt) mi1) it1)) */
SELECT mi1.info, n.name, COUNT(*)
FROM title as t,
kind_type as kt,
movie_info as mi1,
info_type as it1,
cast_info as ci,
role_type as rt,
name as n,
info_type as it2,
person_info AS pi1
WHERE
t.id = ci.movie_id
AND t.id = mi1.movie_id
AND mi1.info_type_id = it1.id
AND t.kind_id = kt.id
AND ci.person_id = n.id
AND ci.movie_id = mi1.movie_id
AND ci.role_id = rt.id
AND n.id = pi1.person_id
AND pi1.info_type_id = it2.id
AND (it1.id IN ('6','8'))
AND (it2.id IN ('17'))
AND (mi1.info IN ('Argentina','Chile','Czech Republic','DTS','Denmark','Dolby SR','Ireland','Netherlands','New Zealand','Portugal','Sweden','Turkey','Ultra Stereo','Venezuela','West Germany'))
AND (n.name ILIKE '%cu%')
AND (kt.kind IN ('tv series','video game','video movie'))
AND (rt.role IN ('actor','cinematographer','composer'))
AND (t.production_year <= 2015)
AND (t.production_year >= 1925)
GROUP BY mi1.info, n.name