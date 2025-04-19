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



SELECT
    shipping.supp_nation,
    shipping.cust_nation,
    shipping.l_year,
    SUM(shipping.volume) AS revenue
FROM
    (
        SELECT
            n1.n_name AS supp_nation,
            n2.n_name AS cust_nation,
            EXTRACT(YEAR FROM l.l_shipdate) AS l_year,
            l.l_extendedprice * (1 - l.l_discount) AS volume
        FROM
            supplier AS s,
            lineitem AS l,
            orders AS o,
            customer AS c,
            nation AS n1,
            nation AS n2
        WHERE
            s.s_suppkey = l.l_suppkey
            AND o.o_orderkey = l.l_orderkey
            AND c.c_custkey = o.o_custkey
            AND s.s_nationkey = n1.n_nationkey
            AND c.c_nationkey = n2.n_nationkey
            AND (
                (n1.n_name = 'FRANCE' AND n2.n_name = 'GERMANY')
                OR (n1.n_name = 'GERMANY' AND n2.n_name = 'FRANCE')
            )
            AND l.l_shipdate BETWEEN DATE '1995-01-01' AND DATE '1999-12-31'
    ) AS shipping
GROUP BY
    shipping.supp_nation,
    shipping.cust_nation,
    shipping.l_year
ORDER BY
    shipping.supp_nation,
    shipping.cust_nation,
    shipping.l_year;

SELECT
    shipping.supp_nation,
    shipping.cust_nation,
    shipping.l_year,
    SUM(shipping.volume) AS revenue
FROM
    (
        SELECT
            n1.n_name AS supp_nation,
            n2.n_name AS cust_nation,
            EXTRACT(YEAR FROM l.l_shipdate) AS l_year,
            l.l_extendedprice * (1 - l.l_discount) AS volume
        FROM
            supplier AS s,
            lineitem AS l,
            orders AS o,
            customer AS c,
            nation AS n1,
            nation AS n2
        WHERE
            s.s_suppkey = l.l_suppkey
            AND o.o_orderkey = l.l_orderkey
            AND c.c_custkey = o.o_custkey
            AND s.s_nationkey = n1.n_nationkey
            AND c.c_nationkey = n2.n_nationkey
            AND (
                (n1.n_name = 'FRANCE' AND n2.n_name = 'GERMANY')
                OR (n1.n_name = 'GERMANY' AND n2.n_name = 'FRANCE')
            )
            AND l.l_shipdate BETWEEN DATE '1990-01-01' AND DATE '1999-12-31'
    ) AS shipping
GROUP BY
    shipping.supp_nation,
    shipping.cust_nation,
    shipping.l_year
ORDER BY
    shipping.supp_nation,
    shipping.cust_nation,
    shipping.l_year;

SELECT
    shipping.supp_nation,
    shipping.cust_nation,
    shipping.l_year,
    SUM(shipping.volume) AS revenue
FROM
    (
        SELECT
            n1.n_name AS supp_nation,
            n2.n_name AS cust_nation,
            EXTRACT(YEAR FROM l.l_shipdate) AS l_year,
            l.l_extendedprice * (1 - l.l_discount) AS volume
        FROM
            supplier AS s,
            lineitem AS l,
            orders AS o,
            customer AS c,
            nation AS n1,
            nation AS n2
        WHERE
            s.s_suppkey = l.l_suppkey
            AND o.o_orderkey = l.l_orderkey
            AND c.c_custkey = o.o_custkey
            AND s.s_nationkey = n1.n_nationkey
            AND c.c_nationkey = n2.n_nationkey
            AND (
                (n1.n_name = 'ROMANIA' AND n2.n_name = 'INDIA')
                OR (n1.n_name = 'INDIA' AND n2.n_name = 'ROMANIA')
            )
            AND l.l_shipdate BETWEEN DATE '1995-01-01' AND DATE '1996-12-31'
    ) AS shipping
GROUP BY
    shipping.supp_nation,
    shipping.cust_nation,
    shipping.l_year
ORDER BY
    shipping.supp_nation,
    shipping.cust_nation,
    shipping.l_year;


SELECT
    100.00 * SUM(CASE
        WHEN p.p_type LIKE 'SMALL%'
            THEN l.l_extendedprice * (1 - l.l_discount)
        ELSE 0
    END) / SUM(l.l_extendedprice * (1 - l.l_discount)) AS promo_revenue
FROM
    lineitem AS l,
    part AS p
WHERE
    l.l_partkey = p.p_partkey
    AND l.l_shipdate >= DATE '1997-07-01'
    AND l.l_shipdate < DATE '1997-07-01' + INTERVAL '3' MONTH;

SELECT
    l.l_shipmode,
    SUM(CASE
        WHEN o.o_orderpriority = '1-URGENT'
            OR o.o_orderpriority = '3-MEDIUM'
            THEN 1
        ELSE 0
    END) AS high_line_count,
    SUM(CASE
        WHEN o.o_orderpriority <> '1-URGENT'
            AND o.o_orderpriority <> '3-MEDIUM'
            THEN 1
        ELSE 0
    END) AS low_line_count
FROM
    orders AS o,
    lineitem AS l
WHERE
    o.o_orderkey = l.l_orderkey
    AND l.l_shipmode IN ('FOB', 'RAIL')
    AND l.l_commitdate < l.l_receiptdate
    AND l.l_shipdate < l.l_commitdate
    AND l.l_receiptdate >= DATE '1995-05-01'
    AND l.l_receiptdate < DATE '1995-05-01' + INTERVAL '3' YEAR
GROUP BY
    l.l_shipmode
ORDER BY
    l.l_shipmode;

