--ex1
WITH table1 AS
(SELECT product_ID, EXTRACT(year from transaction_date) as year, 
spend as curr_year_spend,
LAG(spend) OVER(PARTITION BY product_ID ORDER BY product_ID) as prev_year_spend
FROM user_transactions)
SELECT year,	product_id,	curr_year_spend,
prev_year_spend,
ROUND((curr_year_spend - prev_year_spend)*100.0/ prev_year_spend,2) as yoy_rate
from table1
--ex2
WITH ranked_cards AS 
(SELECT
card_name,
issued_amount,
ROW_NUMBER() OVER (PARTITION BY card_name ORDER BY issue_year, issue_month) AS rank
FROM monthly_cards_issued)
SELECTcard_name,
issued_amount 
FROM ranked_cards
WHERE rank = 1
ORDER BY issued_amount DESC;

--ex3
WITH ranked_Trans as
(SELECT user_id,spend, transaction_date,	ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY transaction_date) AS rank
FROM transactions)
SELECT user_id,spend, transaction_date from ranked_Trans where rank = 3

--ex4
WITH table1 AS
(SELECT DISTINCT user_id, transaction_date,
COUNT(product_id) OVER(PARTITION BY user_id ,transaction_date) as purchase_count,
RANK() OVER(PARTITION BY user_id ORDER BY transaction_date DESC)
FROM user_transactions)
SELECT user_id, transaction_date, purchase_count 
FROM table1 
where rank = 1
ORDER BY transaction_date

--ex5:


--ex6:
WITH payments AS (
  SELECT
    transaction_id, merchant_id, credit_card_id, amount,
    transaction_timestamp,
    EXTRACT(EPOCH FROM (transaction_timestamp - LAG(transaction_timestamp) OVER (PARTITION BY merchant_id, credit_card_id, amount ORDER BY transaction_timestamp)))/60 AS diff_in_minutes
FROM transactions
) 

SELECT COUNT(merchant_id) AS payment_count
FROM payments 
WHERE diff_in_minutes <= 10;
;
--ex7
WITH table1 AS 
(SELECT 
category, 
product, 
SUM(spend) AS total_spend,
RANK() OVER (
PARTITION BY category 
ORDER BY SUM(spend) DESC) AS ranking 
FROM product_spend
WHERE EXTRACT(YEAR FROM transaction_date) = 2022
GROUP BY category, product)

SELECT 
category, 
product, 
total_spend 
FROM table1
WHERE ranking <= 2 
ORDER BY category, ranking;

--ex8
WITH joined_table AS 
(SELECT 
a.artist_name,
DENSE_RANK() OVER (ORDER BY COUNT(s.song_id) DESC) AS artist_rank
FROM artists a
JOIN songs s
ON a.artist_id = s.artist_id
JOIN global_song_rank g
ON s.song_id = g.song_id
WHERE g.rank <= 10
GROUP BY a.artist_name)

SELECT artist_name, artist_rank
FROM joined_table
WHERE artist_rank <= 5;
