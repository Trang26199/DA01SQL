--ex1
SELECT COUNT(*) as duplicate_companies
FROM (SELECT company_id, COUNT(title), description FROM job_listings
GROUP BY company_id, description
HAVING COUNT(title)>1) AS JOB_count;
--ex2
SELECT category, product, SUM(spend) FROM product_spend 
where  EXTRACT(year from transaction_date) = 2022
GROUP BY category, product
ORDER BY category, SUM(spend) DESC
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
