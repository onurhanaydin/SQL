-- Except

-- list brands that have a 2018 model product but not a have 2019 model product

SELECT brand_id,brand_name
FROM product.brand
WHERE brand_id IN (
                    SELECT brand_id
                    FROM product.product
                    WHERE model_year=2018

                    EXCEPT

                    SELECT brand_id
                    FROM product.product
                    WHERE model_year=2019)   

------------------------------------------------------------

-- list the products ordered in only 2019

SELECT A.product_name, B.product_id
FROM product.product A
INNER JOIN (
            SELECT A.product_id
            FROM sale.order_item A, sale.orders B 
            WHERE A.order_id=B.order_id
            AND B.order_date BETWEEN '2019-01-01' AND '2019-12-31'

            EXCEPT

            SELECT A.product_id
            FROM sale.order_item A, sale.orders B 
            WHERE A.order_id=B.order_id
            AND B.order_date NOT BETWEEN '2019-01-01' AND '2019-12-31'
) B ON A.product_id=B.product_id

------------------------------------------------------------

-- Case Expression

-- Create a new field that shows meanings of the values in Order_Status

-- 1=Pending; 2=Processing; 3=Rejected; 4=Completed

SELECT order_id, order_status,

CASE order_status
WHEN 1 THEN 'Pending'
WHEN 2 THEN 'Processing'
WHEN 3 THEN 'Rejected'
ELSE 'Completed'
END AS mean_of_status

FROM sale.orders
ORDER BY order_status

------------------------------------------------------------

-- Add a column to the sales.staffs table containing the store names of the employess

-- 1=Sacramento Bikes; 2=Buffalo Bikes; 3=San Angelo Bikes

SELECT first_name, last_name, store_id,

CASE store_id
WHEN 1 THEN 'Sacramento Bikes'
WHEN 2 THEN 'Buffalo Bikes'
ELSE 'San Angelo Bikes'
END AS Store_name

FROM sale.staff
ORDER BY store_id

------------------------------------------------------------

-- Create a new column containing the labels of the customers'email service providers ("Gmail", "Hotmail", "Yahoo" or "Other")

SELECT first_name, last_name, email,

CASE
WHEN email LIKE '%yahoo.com' THEN 'Yahoo'
WHEN email LIKE '%hotmail.com' THEN 'Hotmail'
WHEN email LIKE '%gmail.com' THEN 'Gmail'
ELSE 'Others'
END AS service_provider

FROM sale.customer
ORDER BY service_provider

------------------------------------------------------------

-- Data Types

CREATE TABLE t_date_time
(
A_time TIME,
A_date DATE,
A_smalldatetime SMALLDATETIME,
A_datetime DATETIME,
A_datetime2 DATETIME2,
A_datetimeoffset DATETIMEOFFSET
)

SELECT GETDATE() AS [now]

INSERT t_date_time
VALUES (GETDATE(), GETDATE(), GETDATE(), GETDATE(), GETDATE(), GETDATE())

SELECT *
FROM t_date_time

------------------------------------------------------------

-- Convert date to varchar

SELECT CONVERT(varchar, GETDATE(), 6) -- 6: one of the date time formats

-- Convert varchar to date

SELECT CONVERT(DATE, '25 Oct 21', 6) 

------------------------------------------------------------

SELECT A_date,
DATENAME(WEEKDAY, A_date) [WEEKDAY],
DAY(A_date) [DAY2],
MONTH(A_date) [MONTH],
YEAR(A_date) [YEAR],
DATEPART(WEEK,A_date) WEEKDAY2,
A_time,
DATEPART(NANOSECOND, A_time)
FROM t_date_time