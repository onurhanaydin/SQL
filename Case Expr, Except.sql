use SampleSales

-- EXCEPT

-- List the brands that have 2018 model bikes but not 2019 model bikes.

SELECT	brand_id, brand_name
FROM	product.brand
WHERE	brand_id IN (
					SELECT	brand_id
					FROM	product.product
					WHERE	model_year = 2018

					EXCEPT

					SELECT	brand_id
					FROM	product.product
					WHERE	model_year = 2019
					)


-- List the products ordered in only 2019, not ordered in other years

SELECT A.product_id, A.product_name
FROM product.product A 
INNER JOIN (
			SELECT	A.product_id
			FROM	sale.order_item A, sale.orders B
			WHERE	A.order_id = B.order_id
			AND		B.order_date BETWEEN '2019-01-01' AND '2019-12-31'

			EXCEPT

			SELECT	A.product_id
			FROM	sale.order_item A, sale.orders B
			WHERE	A.order_id = B.order_id
			AND		B.order_date NOT BETWEEN '2019-01-01' AND '2019-12-31'
			) B
ON A.product_id = B.product_id


-- LIKE

SELECT	COUNT (DISTINCT A.product_id)
FROM	sale.order_item A, sale.orders B
WHERE	A.order_id = B.order_id
AND		B.order_date LIKE '2019%'






SELECT A.product_id, A.product_name
FROM product.product A
INNER JOIN (
			SELECT	A.product_id
			FROM	sale.order_item A, sale.orders B
			WHERE	A.order_id = B.order_id
			AND		B.order_date BETWEEN '2019-01-01' AND '2019-12-31'
			) B
ON	A.product_id = B.product_id


-- CASE EXPRESSIONS


-- Create a new column called Order_Status that shows status of orders

-- 1 = Pending; 2 = Processing; 3 = Rejected; 4 = Completed

SELECT  order_id, order_status,
		CASE order_status
			WHEN 1 THEN 'Pending'
			WHEN 2 THEN 'Processing'
			WHEN 3 THEN 'Rejected'
			ELSE 'Completed'
		END AS mean_of_status
FROM	SALE.orders
ORDER BY order_status

-- Add store names of staff into the staff table

SELECT first_name, last_name, store_id,
	CASE store_id	
		WHEN 1 THEN 'Sacremento Bikes'
		WHEN 2 THEN 'Buffalo Bikes'
		ELSE 'San Angelo Bikes'
		
	END AS Store_name
FROM sale.staff

-- 

SELECT first_name, last_name,store_id,
		CASE
			WHEN store_id = 1 then 'Sacramento Bikes'
			WHEN store_id = 2 then 'Buffalo Bikes'
			WHEN store_id = 3 then 'San Angelo Bikes'
		END as Store_name
FROM sale.staff

-- Define the email service providers of customers by creating new column

SELECT	email,
		CASE	
			WHEN email LIKE '%@yahoo%' THEN 'Yahoo'
			WHEN email LIKE '%@gmail%' THEN 'Gmail'
			WHEN email LIKE '%@hotmail%' THEN 'Hotmail'
			WHEN email IS NOT NULL THEN 'Others'
		END Email_providers
FROM	sale.customer