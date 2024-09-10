--1 tạo metric
WITH monthly_data AS (
    SELECT
        FORMAT_TIMESTAMP('%Y-%m', o.created_at) AS month,
        EXTRACT(YEAR FROM o.created_at) AS year,
        p.category AS product_category,
        SUM(oi.sale_price) AS tpv, -- Tổng doanh thu (Total Payment Volume)
        COUNT(DISTINCT o.order_id) AS tpo, -- Tổng số đơn hàng (Total Purchase Orders)
        SUM(p.cost) AS total_cost, -- Tổng chi phí sản phẩm
        SUM(oi.sale_price - p.cost) AS total_profit -- Tổng lợi nhuận
    FROM
        bigquery-public-data.thelook_ecommerce.orders o
    JOIN
        bigquery-public-data.thelook_ecommerce.order_items oi ON o.order_id = oi.order_id
    JOIN
        bigquery-public-data.thelook_ecommerce.products p ON oi.product_id = p.id
    GROUP BY
        month, year, product_category
),
growth_metrics AS (
    SELECT
        month,
        year,
        product_category,
        tpv,
        tpo,
        total_cost,
        total_profit,
        LAG(tpv, 1) OVER (PARTITION BY product_category ORDER BY month) AS prev_tpv,
        LAG(tpo, 1) OVER (PARTITION BY product_category ORDER BY month) AS prev_tpo
    FROM
        monthly_data
)
SELECT
    month,
    year,
    product_category,
    tpv,
    tpo,
    total_cost,
    total_profit,
    (tpv - prev_tpv) / prev_tpv * 100 AS revenue_growth, -- Tăng trưởng doanh thu (%)
    (tpo - prev_tpo) / prev_tpo * 100 AS order_growth, -- Tăng trưởng đơn hàng (%)
    total_profit / total_cost AS profit_to_cost_ratio -- Tỷ lệ lợi nhuận trên chi phí
FROM
    growth_metrics
WHERE
    year >= 2019 -- Giới hạn năm dữ liệu (có thể tùy chỉnh)
ORDER BY
    month, product_category;

--2.
WITH first_order AS (
    SELECT 
        o.user_id, 
        MIN(DATE_TRUNC(o.created_at, MONTH)) AS first_purchase_date
    FROM 
        bigquery-public-data.thelook_ecommerce.orders o
    GROUP BY 
        o.user_id
),
cohort_data AS (
    SELECT 
        fo.user_id,
        fo.first_purchase_date AS cohort_date,
        DATE_TRUNC(o.created_at, MONTH) AS order_month,
        -- Calculate the index of months since the first purchase
        EXTRACT(YEAR FROM o.created_at) * 12 + EXTRACT(MONTH FROM o.created_at) - 
        (EXTRACT(YEAR FROM fo.first_purchase_date) * 12 + EXTRACT(MONTH FROM fo.first_purchase_date)) + 1 AS index
    FROM 
        first_order fo
    JOIN 
        bigquery-public-data.thelook_ecommerce.orders o 
        ON fo.user_id = o.user_id
),
customer_cohort AS (
    
    SELECT 
        cohort_date,
        COUNT(DISTINCT CASE WHEN index = 1 THEN user_id END) AS m1,
        COUNT(DISTINCT CASE WHEN index = 2 THEN user_id END) AS m2,
        COUNT(DISTINCT CASE WHEN index = 3 THEN user_id END) AS m3,
        COUNT(DISTINCT CASE WHEN index = 4 THEN user_id END) AS m4
    FROM 
        cohort_data
    GROUP BY 
        cohort_date
)

SELECT 
    cohort_date,
    ROUND(100.00 * m1/m1, 2) || '%' AS m1,  
    ROUND(100.00 * m2/m1, 2) || '%' AS m2,  
    ROUND(100.00 * m3/m1, 2) || '%' AS m3,  
    ROUND(100.00 * m4/m1, 2) || '%' AS m4   
FROM 
    customer_cohort
