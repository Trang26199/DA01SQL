--ex1
WITH FirstOrders AS 
(SELECT
customer_id,
order_date,
customer_pref_delivery_date,
ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date) AS rank FROM Delivery)
SELECT
ROUND((SUM(CASE WHEN order_date = customer_pref_delivery_date THEN 1 ELSE 0 END) * 100.0) /COUNT(*),2)
AS immediate_percentage
FROM FirstOrders
WHERE rank = 1;
--ex2
WITH table1 AS (
SELECT 
player_id, 
event_date,
LEAD(event_date) OVER (PARTITION BY player_id ORDER BY event_date) AS next_event_date, 
ROW_NUMBER() OVER (PARTITION BY player_id ORDER BY event_date) AS rk 
FROM Activity 
)
SELECT
ROUND(
SUM(CASE 
WHEN next_event_date = event_date + INTERVAL '1 day' AND rk = 1 THEN 1 ELSE 0 END) * 1.0 / COUNT(Distinct player_id), 2) 
AS fraction  
FROM table1;
-- EX3:
SELECT 
CASE 
WHEN id % 2 = 1 AND id  < (SELECT MAX(id) FROM Seat) THEN id + 1
WHEN id % 2 = 0 THEN id - 1
ELSE id
END AS id,
student
FROM Seat
ORDER BY id ;
--  ex4:
--ex5
WITH table1 AS 
(SELECT tiv_2015
FROM Insurance
GROUP BY tiv_2015
HAVING COUNT(*) > 1),
table2 AS 
(SELECT *
FROM Insurance
WHERE (lat, lon) NOT IN (SELECT lat, lon FROM Insurance GROUP BY lat, lon HAVING COUNT(*) > 1))
SELECT ROUND(CAST(SUM(tiv_2016) AS numeric), 2) AS tiv_2016
FROM table2
WHERE tiv_2015 IN (SELECT tiv_2015 FROM table1);

--ex6
WITH RankedSalaries AS (
SELECT 
E.id,
E.name,
E.salary,
E.departmentId,
DENSE_RANK() OVER (PARTITION BY E.departmentId ORDER BY E.salary DESC) AS salary_rank
FROM Employee E
)
SELECT 
D.name AS Department,
R.name AS Employee,
R.salary AS Salary
FROM RankedSalaries R
JOIN Department D ON R.departmentId = D.id
WHERE R.salary_rank <= 3;

--ex7
WITH table1 AS
(SELECT 
person_id,
person_name,
weight,
turn,
SUM(weight) OVER (ORDER BY turn) AS cumulative_weight
FROM Queue)
SELECT 
person_name
FROM table1
WHERE cumulative_weight <= 1000
ORDER BY turn DESC
LIMIT 1;

--ex8
SELECT 
product_id,
COALESCE(
(SELECT new_price 
FROM Products 
WHERE product_id = P.product_id 
AND change_date <= '2019-08-16' 
ORDER BY change_date DESC 
LIMIT 1), 10) AS price
FROM (SELECT DISTINCT product_id FROM Products) P
ORDER BY product_id;

