SELECT
    100.00 * SUM(CASE
        WHEN p.p_type LIKE 'S%'
            THEN l.l_extendedprice * (1 - l.l_discount)
        ELSE 0
    END) / SUM(l.l_extendedprice * (1 - l.l_discount)) AS promo_revenue
FROM
    lineitem AS l,
    part AS p
WHERE
    l.l_partkey = p.p_partkey
    AND l.l_shipdate >= DATE '1998-07-24'
    AND l.l_shipdate < DATE '1998-07-24' + INTERVAL '6' MONTH;

