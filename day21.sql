--1
SELECT 
    FORMAT_TIMESTAMP('%Y-%m', created_at) AS month_year, 
    COUNT(DISTINCT user_id) AS total_users, 
    sum(CASE WHEN status = 'Complete' THEN 1 END) AS total_orders
FROM 
    bigquery-public-data.thelook_ecommerce.orders
WHERE 
    created_at BETWEEN '2019-01-01' AND '2022-04-30'
GROUP BY 
    1
ORDER BY 
    1;
--insight: tổng lượng người dùng và lượng đơn đặt hàng tăng dần theo từng tháng
--2
SELECT 
    FORMAT_TIMESTAMP('%Y-%m', o.created_at) AS month_year, 
    COUNT(DISTINCT o.user_id) AS distinct_users,
    SUM(oi.sale_price) / COUNT(DISTINCT o.order_id) AS average_order_value
FROM 
    bigquery-public-data.thelook_ecommerce.orders o
JOIN 
    bigquery-public-data.thelook_ecommerce.order_items oi ON o.order_id = oi.order_id
WHERE 
    o.created_at BETWEEN '2019-01-01' AND '2022-04-30'
GROUP BY 
    1
ORDER BY 
    1;
--insight: Số lượng người dùng tăng đáng kể từ 13 người dùng vào tháng 1 năm 2019 lên 127 người dùng vào tháng 5 năm 2019, có 1 số tháng giảm nhẹ nhưng ko đáng kể, xu hướng nhìn chung tăng

--3
WITH youngest_customers AS (
    SELECT 
        first_name, 
        last_name, 
        gender, 
        age,
        'youngest' AS tag
    FROM 
        bigquery-public-data.thelook_ecommerce.users
    WHERE 
        created_at BETWEEN '2019-01-01' AND '2022-04-30'
    ORDER BY 
        age ASC
    LIMIT 1
),
oldest_customers AS (
    SELECT 
        first_name, 
        last_name, 
        gender, 
        age,
        'oldest' AS tag
    FROM 
        bigquery-public-data.thelook_ecommerce.users
    WHERE 
        created_at BETWEEN '2019-01-01' AND '2022-04-30'
    ORDER BY 
        age DESC
    LIMIT 1
)

-- Union youngest and oldest customers
SELECT * FROM youngest_customers
UNION ALL
SELECT * FROM oldest_customers;
--Insight: khách hàng trẻ nhất 12 tuổi và già nhất 70 tuổi

--4
WITH monthly_sales AS (
    SELECT 
        FORMAT_TIMESTAMP('%Y-%m', oi.created_at) AS month_year,
        p.id AS product_id,
        p.name AS product_name,
        SUM(oi.sale_price) AS sales,
        SUM(p.cost) AS cost,  -- Assuming 1 item per order item row
        SUM(oi.sale_price - p.cost) AS profit
    FROM 
        bigquery-public-data.thelook_ecommerce.order_items oi
    JOIN 
        bigquery-public-data.thelook_ecommerce.products p ON oi.product_id = p.id
    JOIN 
        bigquery-public-data.thelook_ecommerce.orders o ON oi.order_id = o.order_id
    WHERE 
        o.created_at BETWEEN '2019-01-01' AND '2022-04-30'
    GROUP BY 
        month_year, p.id, p.name
),
ranked_sales AS (
    SELECT 
        month_year,
        product_id,
        product_name,
        sales,
        cost,
        profit,
        DENSE_RANK() OVER (PARTITION BY month_year ORDER BY profit DESC) AS rank_per_month
    FROM 
        monthly_sales
)

-- Fetch the top 5 products per month
SELECT 
    month_year,
    product_id,
    product_name,
    sales,
    cost,
    profit,
    rank_per_month
FROM 
    ranked_sales
WHERE 
    rank_per_month <= 5
ORDER BY 
    month_year, rank_per_month;


--5
SELECT 
    FORMAT_TIMESTAMP('%Y-%m-%d', o.created_at) AS dates,
    p.category AS product_categories,
    SUM(oi.sale_price) AS revenue
FROM 
    bigquery-public-data.thelook_ecommerce.orders o
JOIN 
    bigquery-public-data.thelook_ecommerce.order_items oi ON o.order_id = oi.order_id
JOIN 
    bigquery-public-data.thelook_ecommerce.products p ON oi.product_id = p.id
WHERE 
    o.created_at BETWEEN TIMESTAMP('2022-01-15') AND TIMESTAMP('2022-04-15')
GROUP BY 
    dates, product_categories
ORDER BY 
    dates ASC, product_categories ASC;

