use SampleSales

-- Summary Table

SELECT	C.brand_name as Brand, D.category_name as Category, B.model_year as Model_Year, 
		ROUND (SUM (A.quantity * A.list_price * (1 - A.discount)), 0) total_sales_price
INTO	sale.sales_summary

FROM	sale.order_item A, product.product B, product.brand C, product.category D
WHERE	A.product_id = B.product_id
AND		B.brand_id = C.brand_id
AND		B.category_id = D.category_id
GROUP BY
		C.brand_name, D.category_name, B.model_year


----- SUBQUERIES


-- Calculate the total list prices by order id

SELECT	DISTINCT order_id,
		(SELECT SUM(list_price) FROM sale.order_item B WHERE A.order_id = B.order_id) SUM_PRICE
FROM	sale.order_item A

-- List all staff in store where Maria Cussona works

SELECT	first_name, last_name
FROM	sale.staff 
WHERE	store_id = (
						SELECT	store_id
						FROM	SALE.staff
						WHERE	first_name = 'Maria' AND last_name = 'Cussona'
					)

-- List the staff whose manager is Jane Destrey

SELECT *
FROM	sale.staff
WHERE	manager_id = (
						SELECT	staff_id
						FROM	sale.staff
						WHERE	first_name = 'Jane' AND last_name = 'Destrey'
						)

-- List order dates of customers who live in Holbrook city

SELECT	customer_id, order_id, order_date
FROM	SALE.orders
WHERE	customer_id IN (
						SELECT	customer_id
						FROM	SALE.customer
						WHERE	city = 'Holbrook'
						)

-- List the customers who has same order date as Abby Parks' order date

SELECT	C.first_name, C.last_name, A.order_id, A.order_date
FROM	sale.orders A 
INNER JOIN (
			SELECT	A.first_name, A.last_name, B.customer_id, B.order_id, B.order_date
			FROM	sale.customer A INNER JOIN sale.orders B ON A.customer_id = B.customer_id
			WHERE	A.last_name = 'Parks' AND A.first_name = 'Abby'
			) B 
ON A.order_date = B.order_date
INNER JOIN sale.customer C ON A.customer_id = C.customer_id

-- List the bicycles more expensive than all electricity bicycles and sort them

SELECT	list_price
FROM	product.product A INNER JOIN product.category B ON A.category_id = B.category_id
WHERE	B.category_name = 'Electric Bikes'
ORDER BY 
		1

-- List the bicycles more expensive than all electricity bicycles and model year is 2020

SELECT	product_name, list_price
FROM	product.product 
WHERE	list_price > ALL (
							SELECT	list_price
							FROM	product.product A INNER JOIN product.category B ON A.category_id = B.category_id
							WHERE	B.category_name = 'Electric Bikes'
							)
AND		model_year = 2020


-- EXIST


SELECT DISTINCT B.first_name, B.last_name, A.order_date
FROM Sale.orders A
JOIN Sale.customer B
ON A.customer_id = B.customer_id
WHERE EXISTS (
					SELECT 1
					FROM Sale.customer C
					JOIN Sale.orders D
					ON C.customer_id = D.customer_id
					WHERE first_name = 'Abby' AND last_name = 'Parks'
					AND		A.order_date = D.order_date
					)

--

SELECT DISTINCT B.first_name, B.last_name, A.order_date
FROM Sale.orders A
JOIN Sale.customer B
ON A.customer_id = B.customer_id
WHERE NOT EXISTS (
					SELECT 1
					FROM Sale.customer A
					JOIN Sale.orders B
					ON A.customer_id = B.customer_id
					WHERE first_name = 'Abbay' AND last_name = 'Parks'
					)

-- List the states where the product of Trek Remedy 9.8 - 2019 is not ordered

SELECT DISTINCT state
FROM sale.customer X
WHERE	NOT EXISTS
					(
					SELECT A.product_id, A.product_name, B.product_id, B.order_id, C.order_id, C.customer_id, D.*
					FROM	product.product A, sale.order_item B, sale.orders C, sale.customer D
					WHERE	A.product_id = B.product_id
					AND		B.order_id = C.order_id
					AND		C.customer_id = D.customer_id
					AND		A.product_name = 'Trek Remedy 9.8 - 2019'
					AND		X.state = D.state
					)


-- VIEWS


-- Create a view called new_view that includes products produced after 2019

create view new_view as
select product_id, model_year
from product.product
where model_year > 2018

