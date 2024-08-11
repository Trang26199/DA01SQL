--ex1
select name from STUDENTS 
where marks > 75
order by right(name,3), id 
--ex2
select user_id,
concat(upper(left(name,1)),lower(right(name,length(name)-1))) as name
from Users
order by user_id
--ex3
SELECT manufacturer, 
'$'||ROUND(SUM(total_sales)/1000000,0)||' '||'million'
FROM pharmacy_sales
GROUP BY manufacturer
ORDER BY SUM(total_sales) DESC, manufacturer
--ex4
SELECT extract(month from submit_date) as mth,
product_id,	
ROUND(avg(stars),2) as avg_stars 
FROM reviews
GROUP BY extract(month from submit_date), product_id
ORDER BY mth, product_id
--ex5
SELECT sender_id, COUNT(message_id) as message_count
FROM messages
where sent_date BETWEEN '08/01/2022' and '09/01/2022'
GROUP BY sender_id
ORDER BY message_count DESC
LIMIT 2;
--ex6
# Write your MySQL query statement below
select tweet_id from Tweets 
where length(content) > 15
--ex7
# Write your MySQL query statement below
SELECT 
    activity_date as day, 
    COUNT(DISTINCT user_id) AS active_users 
FROM 
    Activity
WHERE 
    activity_date BETWEEN '2019-06-28' AND '2019-07-27'
GROUP BY 
    activity_date
--ex8
SELECT COUNT(*)
FROM employees
WHERE joining_date BETWEEN '2022-01-01' AND '2022-07-31';
--ex9
select position('a' in first_name) from worker
where first_name =  'Amitah';
--ex10
select substring(title, length(winery)+2,4) 
from winemag_p2
where country = 'Macedonia'
