--ex1
SELECT
    SUM(CASE WHEN device_type = 'laptop' THEN 1 ELSE 0 END) AS laptop_reviews,
    SUM(CASE WHEN device_type IN ('tablet', 'phone') THEN 1 ELSE 0 END) AS mobile_views
FROM viewership;
--ex2
select *,
case
    when x + y > z and x + z > y and y + z > x then 'Yes'
    else 'No'
end as triangle
from Triangle
--ex3
SELECT
  ROUND(CAST(SUM(CASE WHEN call_category = 'n/a' or call_category is NULL then 1 ELSE 0 end)*100 as decimal)/COUNT(*),1) as uncategorised_call_pct
FROM callers;
--ex4
SELECT name
FROM Customer
WHERE referee_id <> 2 OR referee_id IS NULL;
--ex5
SELECT
    survived,
    sum(CASE WHEN pclass = 1 THEN 1 ELSE 0 END) AS first_class,
    sum(CASE WHEN pclass = 2 THEN 1 ELSE 0 END) AS second_class,
    sum(CASE WHEN pclass = 3 THEN 1 ELSE 0 END) AS third_class
FROM titanic
GROUP BY 
    survived
