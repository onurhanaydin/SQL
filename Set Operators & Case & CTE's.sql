use SampleSales

SELECT C.brand_name as Brand, D.category_name as Category, B.model_year as Model_Year, 
ROUND (SUM (A.quantity * A.list_price * (1 - A.discount)), 0) total_sales_price
INTO sale.sales_summary
FROM sale.order_item A, product.product B, product.brand C, product.category D
WHERE A.product_id = B.product_id
AND	B.brand_id = C.brand_id
AND	B.category_id = D.category_id
GROUP BY C.brand_name, D.category_name, B.model_year

------------------------------------------------------------

-- VIEWS

-- create a 'NEW_PRODUCTS' view produced after 2019

create view new_view as
select product_id, model_year
from product.product
where model_year > 2018


DROP VIEW new_view

SELECT * FROM new_view

------------------------------------------------------------

-- CTE's

-- list customers who both ordered before the last order of Sharyn Hopkins and in San Diego

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

------------------------------------------------------------

-- list full name and order dates of customers whose order dates on the same order dates of Abby Parks

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

------------------------------------------------------------

-- Set Operators

-- list last names of customers from Sacramento and Monroe

SELECT	last_name
FROM	sale.customer
WHERE	city = 'Sacramento'

UNION ALL

SELECT	last_name
FROM	sale.customer
WHERE	city = 'Monroe'
ORDER BY last_name

-- UNION

SELECT	last_name
FROM	sale.customer
WHERE	city = 'Sacramento'

UNION 

SELECT	last_name
FROM	sale.customer
WHERE	city = 'Monroe'
ORDER BY last_name

------------------------------------------------------------

-- list customers whose first name or last name is Carter
-- Hint: Do not use OR

select first_name, last_name
from sale.customer
where first_name= 'Carter'
UNION ALL
select first_name, last_name
from sale.customer
where last_name= 'Carter'

------------------------------------------------------------

select first_name, last_name, customer_id
from sale.customer
where first_name= 'Carter'

UNION ALL

select first_name, last_name, customer_id
from sale.customer
where last_name= 'Carter'

------------------------------------------------------------

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

------------------------------------------------------------

-- list names of customers that have orders in 2018,2019, and 2020

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

------------------------------------------------------------

SELECT A.first_name, A.last_name
FROM sale.customer A, sale.orders B
WHERE A.customer_id=B.customer_id AND B.order_date BETWEEN '2018-01-01' AND '2018-12-31'

INTERSECT

SELECT A.first_name, A.last_name
FROM sale.customer A, sale.orders B
WHERE A.customer_id=B.customer_id AND B.order_date BETWEEN '2019-01-01' AND '2019-12-31'

INTERSECT

SELECT A.first_name, A.last_name
FROM sale.customer A, sale.orders B
WHERE A.customer_id=B.customer_id AND B.order_date BETWEEN '2020-01-01' AND '2020-12-31'

                    