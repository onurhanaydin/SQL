
use SampleSales


-- CTE's

-- List the customers who have ordered before Sharyn Hopkins's last order date and live in San Diego city

WITH T1 AS
(
SELECT	max(order_date) last_purchase
FROM	sale.customer A, sale.orders B
WHERE	A.customer_id = B.customer_id
AND		A.first_name = 'Sharyn'
AND		A.last_name = 'Hopkins'
) 
SELECT	DISTINCT A.order_date, A.order_id, B.customer_id, B.first_name, B.last_name, B.city
FROM	sale.orders A, sale.customer B, T1
WHERE	A.customer_id = B.customer_id
AND		A.order_date < T1.last_purchase
AND		B.city = 'San Diego'

-- List the customers that have ordered on same order dates as Abby Parks'n order dates 

WITH T1 AS
(
SELECT	order_date
FROM	sale.customer A, sale.orders B
WHERE	A.customer_id = B.customer_id
AND		A.first_name = 'Abby'
AND		A.last_name = 'Parks'
)
SELECT	A.order_date, A.order_id, B.first_name, B.last_name
FROM	sale.orders A, sale.customer B, T1
WHERE	A.customer_id  = B.customer_id 
AND		A.order_date = T1.order_date


------


-- Create a table that includes number from 0 to 9

WITH T1 AS
(
SELECT 0 AS NUM
UNION ALL
SELECT NUM + 2 
FROM	T1
WHERE	NUM < 9
)
SELECT *
FROM T1


-----------


-- SET OPERATORS


-- UNION


-- List the surnames of customers in Sacramento and Monreo city

SELECT	last_name
FROM	sale.customer
WHERE	city = 'Sacramento'

UNION 

SELECT	last_name
FROM	sale.customer
WHERE	city = 'Monroe'
ORDER BY last_name

-- List the customers whose first name or last name is Carter (Do not use OR)

select first_name, last_name, customer_id
from sale.customer
where first_name= 'Carter'

UNION ALL

select first_name, last_name, customer_id
from sale.customer
where last_name= 'Carter'


-- INTERSECT


-- Write a query that returns brands that have products for both 2018 and 2019.

SELECT	B.brand_name
FROM	product.product A, product.brand B
WHERE	A.brand_id = B.brand_id
AND		A.model_year = 2018

INTERSECT

SELECT	B.brand_name
FROM	product.product A, product.brand B
WHERE	A.brand_id = B.brand_id
AND		A.model_year = 2019

-- List customers whose order dates are in all of 2018, 2019, and 2020

SELECT	customer_id, first_name, last_name
FROM	sale.customer
WHERE	customer_id IN	(
						SELECT	customer_id
						FROM	SALE.orders
						WHERE	order_date BETWEEN '2018-01-01' AND '2018-12-31'

						INTERSECT

						SELECT	customer_id
						FROM	SALE.orders
						WHERE	order_date BETWEEN '2019-01-01' AND '2019-12-31'

						INTERSECT
						
						SELECT	customer_id
						FROM	SALE.orders
						WHERE	order_date BETWEEN '2020-01-01' AND '2020-12-31'
						)

