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

