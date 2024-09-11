--1
SELECT  PRODUCTLINE, YEAR_ID, DEALSIZE, sum(sales) REVENUE 
FROM SALES_DATASET_RFM_PRJ
group by PRODUCTLINE ,YEAR_ID, DEALSIZE;
--2
WITH RankedSales AS (
SELECT 
	ORDERNUMBER,
    year_id,
    month_ID,
    SUM(sales) AS REVENUE,
    RANK() OVER(PARTITION BY year_id ORDER BY SUM(sales) DESC) AS rank
  FROM sales_dataset_rfm_prj
  GROUP BY year_id, month_ID, ORDERNUMBER)
select ORDERNUMBER, year_id, month_ID
FROM RankedSales
WHERE rank = 1;
--3
select productline, month_ID,  sum(sales) as REVENUE,count(ordernumber) as ORDER_NUMBER 
from sales_dataset_rfm_prj
where month_ID =11
group by productline,month_ID
order by sum(sales) desc , count(ordernumber) desc
limit 1
--4
WITH RankedSales AS (
  SELECT 
    YEAR_ID,
    PRODUCTLINE,
    SUM(sales) AS REVENUE,
    RANK() OVER(PARTITION BY YEAR_ID ORDER BY SUM(sales) DESC) AS rank
  FROM public.sales_dataset_rfm_prj
  WHERE country = 'UK'
  GROUP BY YEAR_ID, PRODUCTLINE
)
SELECT *
FROM RankedSales
WHERE rank = 1;
--5
WITH rfm_data AS (
  SELECT 
    contactfullname,
    postalcode,
    current_date - MAX(orderdate) AS R,
    COUNT(DISTINCT ordernumber) AS F,
    SUM(sales) AS M
  FROM public.sales_dataset_rfm_prj
  GROUP BY contactfullname, postalcode
),
rfm_scores AS (
  SELECT 
    contactfullname,
    postalcode,
    NTILE(5) OVER(ORDER BY R DESC) AS R_score,
    NTILE(5) OVER(ORDER BY F) AS F_score,
    NTILE(5) OVER(ORDER BY M) AS M_score
  FROM rfm_data
),
rfm_combined AS (
  SELECT 
    contactfullname,
    postalcode,
    CAST(R_score AS varchar) || CAST(F_score AS varchar) || CAST(M_score AS varchar) AS rfm_score
  FROM rfm_scores
)
SELECT 
  a.contactfullname,
  a.postalcode,
  a.rfm_score
FROM rfm_combined AS a
JOIN public.segment_score AS b 
  ON a.rfm_score = b.scores
WHERE b.segment = 'Champions';
