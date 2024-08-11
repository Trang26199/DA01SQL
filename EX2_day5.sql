--ex1
SELECT DISTINCT CITY
FROM station
WHERE ID% 2 = 0
--ex2
select count(city) - count(distinct city) from station
--ex4
SELECT 
ROUND(CAST(sum(item_count*order_occurrences)/SUM(order_occurrences)) as DECIMAL,1)
FROM items_per_order;
--ex5
SELECT candidate_id FROM candidates
WHERE skill in ('Python','Tableau','PostgreSQL')
GROUP BY candidate_id
HAVING COUNT(candidate_id)=3
--ex6
select user_id, Date(max(post_date))-Date(min(post_date))) as Days_beetween from posts
where post_date>= '2021-01-01' and post_date<= '2022-01-01'
group by user_id
having count(user_id)>1
--ex7
SELECT card_name, 
MAX(issued_amount) - MIN(issued_amount) as difference  
FROM monthly_cards_issued
GROUP BY card_name
ORDER BY difference DESC;
--ex8
SELECT 
    manufacturer,
    COUNT(product_id) AS number_of_drugs_with_losses,
    ABS(SUM(total_sales - cogs)) AS total_losses
FROM 
    pharmacy_sales
WHERE 
    total_sales < cogs
GROUP BY 
    manufacturer
ORDER BY 
    total_losses DESC;

--ex9
select * from Cinema
where id%2 = 1 and description  <> 'boring'
order by rating DESC;
--ex10
# Write your MySQL query statement below
# Write your MySQL query statement below
SELECT 
    teacher_id,
    COUNT(DISTINCT subject_id) AS cnt
FROM 
    Teacher
GROUP BY 
    teacher_id;
--ex11
SELECT 
    user_id,
    COUNT(follower_id) AS followers_count
FROM 
    Followers
GROUP BY 
    user_id
ORDER BY 
    user_id ASC;
--ex12
SELECT 
    class
FROM 
    Courses
GROUP BY 
    class
HAVING 
    COUNT(student) >= 5;
