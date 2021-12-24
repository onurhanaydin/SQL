use SampleSales

----- Advanced Grouping Operations

-- Write a query that returns whether the product id is multiple or not from product table

SELECT	product_id, COUNT (*) CNT_ROW
FROM	product.product
GROUP BY	product_id
HAVING	COUNT (*) > 1

-----

-- Write a query that returns category id whose max list price is bigger than 4000 
-- or min list price is lower than 500

SELECT	category_id, MAX(list_price) AS MAX_PRICE, MIN (list_price) MIN_PRICE 
FROM	product.product
GROUP BY	category_id
HAVING	MAX(list_price) > 4000 OR MIN (list_price) < 500

-----

-- Find the average product prices of brands and sort them

SELECT	B.brand_id, B.brand_name, AVG(A.list_price) avg_price
FROM	product.product A, product.brand B
WHERE	A.brand_id = B.brand_id
GROUP BY
		B.brand_id, B.brand_name
ORDER BY 
		avg_price DESC

-- List the brands whose average price is bigger than 1000

SELECT	B.brand_id, B.brand_name, AVG(A.list_price) avg_price
FROM	product.product A, product.brand B
WHERE	A.brand_id = B.brand_id
GROUP BY
		B.brand_id, B.brand_name
HAVING	AVG(A.list_price) > 1000
ORDER BY 
		avg_price DESC

-----

-- SELECT ... INTO FROM ...

SELECT	C.brand_name as Brand, D.category_name as Category, B.model_year as Model_Year, 
		ROUND (SUM (A.quantity * A.list_price * (1 - A.discount)), 0) total_sales_price
INTO	sale.sales_summary

FROM	sale.order_item A, product.product B, product.brand C, product.category D
WHERE	A.product_id = B.product_id
AND		B.brand_id = C.brand_id
AND		B.category_id = D.category_id
GROUP BY
		C.brand_name, D.category_name, B.model_year


----- GROUPING SETS

-----

SELECT *
FROM	sale.sales_summary

-- Calculate amount of the total sales

SELECT	SUM(total_sales_price)
FROM	sale.sales_summary

-- Calculate total sales of brands

SELECT	brand, SUM(total_sales_price) total_sales
FROM	sale.sales_summary
GROUP BY	brand

-- Calculate the total sales by category

SELECT	Category, SUM(total_sales_price) total_sales
FROM	sale.sales_summary
GROUP BY	Category

-- Calculate the total sales by category and brand

SELECT	brand, Category, SUM(total_sales_price) total_sales
FROM	sale.sales_summary
GROUP BY	brand, Category
ORDER BY brand

----

SELECT	brand, category, SUM(total_sales_price) 
FROM	sale.sales_summary
GROUP BY
		GROUPING SETS (
				(brand, category),
				(brand),
				(category),
				()
				)
ORDER BY
	brand, category


-- ROLLUP


-- Calculate the total sales for brand, category, and model year column by using Rollup

SELECT	brand, Category, Model_Year, SUM(total_sales_price) total_price
FROM	sale.sales_summary
GROUP BY
		ROLLUP (brand, Category, Model_Year)


----- Pivot 


-- Calculate the total sales by category and model year from summary table

SELECT *
FROM
	(
	SELECT Category, Model_Year, total_sales_price
	FROM	SALE.sales_summary
	) A
PIVOT
	(
	SUM(total_sales_price)
	FOR Category
	IN (
		[Children Bicycles], 
		[Comfort Bicycles], 
		[Cruisers Bicycles], 
		[Cyclocross Bicycles], 
		[Electric Bikes], 
		[Mountain Bikes], 
		[Road Bikes]
		)
	) AS P1
