-- Window Functions

-- find the stock numbers of products

SELECT DISTINCT product_id, SUM(quantity) OVER (PARTITION BY product_id) total_stock
FROM product.stock

-- The minimum price among the bicycles

SELECT MIN(list_price) OVER ()
FROM product.product

-- The minimum prices by the category among the bicycles

SELECT DISTINCT category_id, MIN(list_price) OVER (PARTITION BY category_id)
FROM product.product

-- The name of the cheapest bicycle among all bicycles (use first_value)

SELECT DISTINCT FIRST_VALUE(product_name) OVER(ORDER BY list_price) AS F_V
FROM product.product

-- list the name of the cheapest bike in each category (use first_value)

SELECT DISTINCT category_id,
FIRST_VALUE(product_name) OVER(PARTITION BY category_id ORDER BY list_price) AS F_V
FROM product.product

-- The name of the cheapest bicycle among all bicycles (use last_value)

SELECT DISTINCT 
LAST_VALUE(product_name) OVER(ORDER BY list_price DESC ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) 
AS F_V
FROM product.product

---------------------------------------------------------------------------

-- Lag Function

-- order date of the one previous sale of each staff (use the leg function)

SELECT DISTINCT A.order_id, B.staff_id, B.first_name, B.last_name, order_date,
LAG(order_date, 1) OVER(PARTITION BY B.staff_id ORDER BY order_id) previous_order_date
FROM sale.orders A, sale.staff B
WHERE A.staff_id=B.staff_id

---------------------------------------------------------------------------

-- Lead Function

-- List the order date of next sales of each staff (use Lead function)

SELECT B.staff_id, B.first_name, B.last_name, A.order_id, A.order_date,
		LEAD(order_date) OVER (PARTITION BY A.staff_id ORDER BY order_id) AS NEXT_ORDER_DATE
FROM sale.orders A , sale.staff B
WHERE A.staff_id = B.staff_id

---------------------------------------------------------------------------

-- order the prices by each category

SELECT	category_id, list_price, ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY list_price)
FROM	product.product

-- order the prices by each category and bikes whose same prices will have same order number (use Rank function)

SELECT	category_id, list_price, 
		ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY list_price) ROW_NUM,
		RANK() OVER (PARTITION BY category_id ORDER BY list_price) RANK_NUM
FROM	product.product

-- list the cumulative dispersion of product numbers that customers ordered

WITH T1 AS
(
SELECT	A.customer_id, SUM(quantity) product_quantity
FROM	SALE.orders A, SALE.order_item B
WHERE	 A.order_id = B.order_id
GROUP BY A.customer_id
) 
SELECT DISTINCT product_quantity, ROUND(CUME_DIST() OVER (ORDER BY product_quantity) , 2)CUM_DIST
FROM	T1
ORDER BY 1

-- list the number of cumulative orders of stores in 2018

SELECT	DISTINCT b.store_id, b.store_name, DATEPART(WEEK, A.order_date) weeks,
		COUNT (*) OVER (PARTITION BY B.store_id ORDER BY DATEPART(WEEK, A.order_date)) cnt_cumulative
FROM	sale.orders A, SALE.store B
WHERE	A.store_id = B.store_id
AND		YEAR(order_date) = 2018

-- Calculate 7-day moving average of the number of products sold between '2018-03-12' and '2018-04-12'

WITH T1 AS 
(
SELECT	DISTINCT order_date, SUM(quantity) OVER (PARTITION BY order_date) sum_quantity
FROM	sale.order_item A, sale.orders B
WHERE	A.order_id = B.order_id
AND		B.order_date BETWEEN '2018-03-12' AND '2018-04-12'
)
SELECT	order_date,  sum_quantity,
		AVG(sum_quantity) OVER (ORDER BY order_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) sales_moving_average_7
FROM	T1
