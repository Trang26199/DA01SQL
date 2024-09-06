--1
ALTER TABLE SALES_DATASET_RFM_PRJ
ALTER COLUMN ordernumber TYPE BIGINT,
ALTER COLUMN quantityordered TYPE INT USING quantityordered::INT,
ALTER COLUMN priceeach TYPE DECIMAL(10, 2) USING priceeach::DECIMAL,
ALTER COLUMN orderlinenumber TYPE INT USING orderlinenumber::INT,
ALTER COLUMN sales TYPE DECIMAL(10, 2) USING sales::DECIMAL,
ALTER COLUMN orderdate TYPE DATE USING orderdate::DATE,
ALTER COLUMN msrp TYPE DECIMAL(10, 2) USING msrp::DECIMAL;
--2
SELECT *
FROM SALES_DATASET_RFM_PRJ
WHERE 
  (ordernumber IS NULL) OR
  (quantityordered IS NULL ) OR
  (priceeach IS NULL ) OR
  (orderlinenumber IS NULL) OR
  (sales IS NULL ) OR
  (orderdate IS NULL);
--3
ALTER TABLE SALES_DATASET_RFM_PRJ
ADD COLUMN contactlastname VARCHAR,
ADD COLUMN contactfirstname VARCHAR;
UPDATE SALES_DATASET_RFM_PRJ
SET contactlastname = INITCAP(LEFT(contactfullname, POSITION(' ' IN contactfullname) - 1)),
    contactfirstname = INITCAP(RIGHT(contactfullname, LENGTH(contactfullname) - POSITION(' ' IN contactfullname)));

--4
ALTER TABLE SALES_DATASET_RFM_PRJ
ADD COLUMN QTR_ID INT,
ADD COLUMN MONTH_ID INT,
ADD COLUMN YEAR_ID INT;
UPDATE SALES_DATASET_RFM_PRJ
SET QTR_ID = EXTRACT(QUARTER FROM orderdate),
    MONTH_ID = EXTRACT(MONTH FROM orderdate),
    YEAR_ID = EXTRACT(YEAR FROM orderdate);
--5+6
WITH quantile_values AS (
    SELECT 
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY quantityordered::INT) AS Q1,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY quantityordered::INT) AS Q3,
        (Q3 - Q1) AS IQR
    FROM SALES_DATASET_RFM_PRJ
)
DELETE FROM SALES_DATASET_RFM_PRJ
WHERE quantityordered::INT < (SELECT Q1 - 1.5 * IQR FROM quantile_values)
   OR quantityordered::INT > (SELECT Q3 + 1.5 * IQR FROM quantile_values);
   
-- Bước 3: Lưu dữ liệu còn lại vào bảng mới
CREATE TABLE SALES_DATASET_RFM_PRJ_CLEAN AS
SELECT * 
FROM SALES_DATASET_RFM_PRJ;
