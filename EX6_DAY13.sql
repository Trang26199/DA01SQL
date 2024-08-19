--ex1
SELECT COUNT(*) as duplicate_companies
FROM (SELECT company_id, COUNT(title), description FROM job_listings
GROUP BY company_id, description
HAVING COUNT(title)>1) AS JOB_count;
--ex2
WITH table1 AS
(SELECT category, product, SUM(spend) as total_spend FROM product_spend 
where  EXTRACT(year from transaction_date) = 2022 AND category = 'appliance'
GROUP BY category, product
ORDER BY SUM(spend) DESC LIMIT 2),
table2 as 
(SELECT category, product, SUM(spend) as total_spend FROM product_spend 
where  EXTRACT(year from transaction_date) = 2022 AND category = 'electronics'
GROUP BY category, product
ORDER BY SUM(spend) DESC
LIMIT 2)
SELECT * FROM table1
UNION ALL SELECT * from table2 

--ex3
WITH newtable AS
(SELECT policy_holder_id, COUNT(case_id) FROM callers
GROUP BY policy_holder_id 
HAVING COUNT(case_id) >= 3)
SELECT COUNT(*) as policy_holder_count FROM newtable;
--ex4
SELECT a.page_id
FROM  pages a LEFT JOIN page_likes b on a.page_id = b.page_id
where b.page_id is NULL
--ex5 
WITH june_users AS (
    SELECT DISTINCT user_id
    FROM user_actions
    WHERE EXTRACT(month FROM event_date) = 6
      AND EXTRACT(year FROM event_date) = 2022
      AND event_type IN ('sign_in', 'like', 'comment')
),
july_users AS (
    SELECT DISTINCT user_id
    FROM user_actions
    WHERE EXTRACT(month FROM event_date) = 7
      AND EXTRACT(year FROM event_date) = 2022
      AND event_type IN ('sign_in', 'like', 'comment')
)
SELECT 
    7 AS month,
    COUNT(DISTINCT j.user_id) AS monthly_active_users
FROM 
    july_users j
JOIN 
    june_users ju ON j.user_id = ju.user_id;

--ex6
select 
country, 
date_format(trans_date, "%Y-%m") as month, 
count(trans_date) as trans_count,
sum(CASE WHEN state = 'approved' then 1 else 0 end) as approved_count,
sum(amount) as trans_total_amount,
sum(CASE WHEN state = 'approved' then amount else 0 end) as approved_total_amount
from Transactions
group by country, date_format(trans_date, "%Y-%m") 
--ex 7:
SELECT 
    s.product_id,
    MIN(s.year) as first_year,
    s.quantity,
    s.price
FROM 
    Sales s
JOIN 
    Product p 
ON 
    s.product_id = p.product_id
WHERE 
    s.year = (
        SELECT MIN(s2.year)
        FROM Sales s2
        WHERE s2.product_id = s.product_id
    )
GROUP BY 
    s.product_id, s.quantity, s.price
ORDER BY 
    s.product_id;
--ex 8
SELECT customer_id
FROM Customer
GROUP BY customer_id
HAVING COUNT(DISTINCT product_key) = (SELECT COUNT(*) FROM Product);
--ex9
# Write your MySQL query statement below
SELECT employee_id
FROM Employees e
WHERE salary < 30000
AND manager_id IS NOT NULL
AND manager_id NOT IN (SELECT employee_id FROM Employees)
ORDER BY employee_id;
--ex10
SELECT COUNT(*) as duplicate_companies
FROM (SELECT company_id, COUNT(title), description FROM job_listings
GROUP BY company_id, description
HAVING COUNT(title)>1) AS JOB_count;
--ex11
SELECT name AS results
FROM (
    SELECT u.name AS name
    FROM Users u
    JOIN MovieRating mr ON u.user_id = mr.user_id
    GROUP BY u.name
    ORDER BY COUNT(mr.movie_id) DESC, u.name ASC
    LIMIT 1
) AS user_result

UNION ALL

SELECT title AS results
FROM (
    SELECT m.title AS title
    FROM Movies m
    JOIN MovieRating mr ON m.movie_id = mr.movie_id
    WHERE mr.created_at BETWEEN '2020-02-01' AND '2020-02-29'
    GROUP BY m.title
    ORDER BY AVG(mr.rating) DESC, m.title ASC
    LIMIT 1
) AS movie_result;

--ex12
SELECT user_id AS id, COUNT(*) AS num
FROM (
    SELECT requester_id AS user_id
    FROM RequestAccepted
    UNION ALL
    SELECT accepter_id AS user_id
    FROM RequestAccepted
) AS combined
GROUP BY user_id
ORDER BY num DESC
LIMIT 1;



