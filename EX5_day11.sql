--ex1
select COUNTRY.CONTINENT, FLOOR(AVG(CITY.Population)) 
from CITY JOIN COUNTRY on CITY.CountryCode = COUNTRY.Code
group by COUNTRY.CONTINENT
--ex2
SELECT ROUND(CAST((COUNT(DISTINCT e.email_id) FILTER (WHERE t.signup_action = 'Confirmed')) as Decimal) / CAST(COUNT(DISTINCT e.email_id) as Decimal),2) AS activation_rate
FROM emails e
LEFT JOIN texts t
ON e.email_id = t.email_id;
--ex3
SELECT age_bucket, 
ROUND(SUM(CASE WHEN a.activity_type = 'open' THEN a.time_spent ELSE 0 END) * 100.0 / SUM(a.time_spent), 2) AS open_perc, 
ROUND(SUM(CASE WHEN a.activity_type = 'send' THEN a.time_spent ELSE 0 END) * 100.0 / SUM(a.time_spent), 2) AS send_perc
FROM activities AS a 
JOIN age_breakdown AS b 
ON a.user_id = b.user_id
WHERE a.activity_type IN ('open', 'send')
GROUP BY age_bucket
ORDER BY age_bucket;
--ex4
SELECT  customer_id
FROM customer_contracts c JOIN products p on c.product_id = p.product_id
GROUP BY customer_id 
HAVING COUNT( DISTINCT product_category) = (SELECT COUNT(DISTINCT product_category) FROM products)
--ex5 
SELECT 
    e.employee_id AS employee_id ,
    e.name AS name,
    COUNT(r.employee_id) AS reports_count ,
    ROUND(AVG(r.age)) AS average_age
FROM Employees e
JOIN Employees r 
ON e.employee_id = r.reports_to
GROUP BY e.employee_id, e.name
ORDER BY e.employee_id;
--ex6
# Write your MySQL query statement below
SELECT p.product_name, 
SUM(o.unit) AS unit 
FROM Orders o
JOIN Products p 
ON o.product_id = p.product_id
WHERE o.order_date >= '2020-02-01' AND o.order_date < '2020-03-01'
GROUP BY p.product_name
HAVING SUM(o.unit) >= 100;
--ex7
SELECT p.page_id
FROM pages p
LEFT JOIN page_likes pl 
ON p.page_id = pl.page_id
WHERE pl.page_id IS NULL
ORDER BY p.page_id;


