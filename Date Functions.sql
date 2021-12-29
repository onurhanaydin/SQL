use SampleSales


-- DATE FUNCTIONS


-- Date Types

CREATE TABLE t_date_time 
	(
	A_time time,
	A_date date,
	A_smalldatetime smalldatetime,
	A_datetime datetime,
	A_datetime2 datetime2,
	A_datetimeoffset datetimeoffset
	)


SELECT *
FROM	t_date_time


SELECT Getdate() as [now]


INSERT t_date_time 
VALUES (Getdate(), Getdate(), Getdate(), Getdate(), Getdate(), Getdate())


SELECT Getdate() as [now]

SELECT *
FROM	t_date_time


-- Convert a date to varchar 

SELECT Getdate() as [now]

SELECT CONVERT(varchar , GETDATE() , 10)

-- Convert a varchar to date

SELECT CONVERT(DATE , '25 Oct 21', 1)


-- Functions for return date or time parts


SELECT	A_date,
		DATENAME(WEEKDAY, A_date) [weekDAY],
		DAY (A_date) [DAY2],
		MONTH(A_date) [month],
		YEAR (A_date) [year],
		DATEPART(WEEK , A_DATE) WEEKDAY2,
		A_Time,
		DATEPART (NANOSECOND, A_time)
FROM	t_date_time


-- DATEDIFF


SELECT A_time, A_date, GETDATE(),
       DATEDIFF(MINUTE, A_time, GETDATE()) AS MINUTE_DIFF,
       DATEDIFF(WEEK, A_time, '2021-11-30') AS WEEK_DIFF
FROM t_date_time

-- Calculate the differences dates and weeks

SELECT DATEDIFF(DAY, order_date, shipped_date) DATE_DIFF, order_date, shipped_date
FROM sale.orders

SELECT DATEDIFF(WEEK, order_date, shipped_date) DATE_DIFF, order_date, shipped_date
FROM sale.orders


-- DATEADD

SELECT order_date,
       DATEADD(YEAR, 5, order_date) YEAR_ADD,
       DATEADD(DAY, 10, order_date) DAY_ADD
FROM sale.orders


--EOMONTH (END OF MONTH)

SELECT EOMONTH(GETDATE()), EOMONTH(GETDATE(),2) AS TWO_MONTHS_LATER


-- Check date or not (Result will be 1 or 0)

SELECT ISDATE('2021-10-01')

SELECT ISDATE('select')


-- Add a field about the delivery speed of orders to the Orders table
-- if not delivered, please insert "Not Shipped"
-- if delivered on order date, please insert "Fast"
-- if delivered in following two days after the order date, please insert "Normal"
-- if delivered in more than two days, please insert "Slow"

WITH T1 AS
(SELECT *,
       DATEDIFF(DAY, order_date, shipped_date) DIFF_SHIPPED_AND_ORDER
FROM sale.orders)

SELECT ORDER_DATE, shipped_date,
       CASE WHEN DIFF_SHIPPED_AND_ORDER IS NULL THEN 'Not Shipped'
            WHEN DIFF_SHIPPED_AND_ORDER = 0 THEN 'Fast'
            WHEN DIFF_SHIPPED_AND_ORDER <= 2 THEN 'Normal'
            WHEN DIFF_SHIPPED_AND_ORDER > 2 THEN 'Slow'
            END AS Order_Label
FROM T1

-- List the orders shipped in more than two days after the ordered date

WITH T1 AS
(SELECT *,
       DATEDIFF(DAY, order_date, shipped_date) DIFF
FROM sale.orders)

SELECT *
FROM T1
WHERE DIFF > 2

-- List the distributions of above orders on weekdays

SELECT SUM(CASE WHEN DATENAME(WEEKDAY, order_date)='Monday' THEN 1 END) MONDAY,
       SUM(CASE WHEN DATENAME(WEEKDAY, order_date)='Tuesday' THEN 1 END) TUESDAY,
       SUM(CASE WHEN DATENAME(WEEKDAY, order_date)='Wednesday' THEN 1 END) Wednesday,
       SUM(CASE WHEN DATENAME(WEEKDAY, order_date)='Thursday' THEN 1 END) Thursday,
       SUM(CASE WHEN DATENAME(WEEKDAY, order_date)='Friday' THEN 1 END) FRIDAY,
       SUM(CASE WHEN DATENAME(WEEKDAY, order_date)='Saturday' THEN 1 END) SATURDAY,
       SUM(CASE WHEN DATENAME(WEEKDAY, order_date)='Sunday' THEN 1 END) SUNDAY
FROM sale.orders
WHERE DATEDIFF(DAY, order_date, shipped_date) > 2




















