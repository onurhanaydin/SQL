------------------------------------------------------------

-- DATEDIFF

SELECT A_time, A_date, GETDATE(),
       DATEDIFF(MINUTE, A_time, GETDATE()) AS MINUTE_DIFF,
       DATEDIFF(WEEK, A_time, '2021-11-30') AS WEEK_DIFF
FROM t_date_time

------------------------------------------------------------

-- caculate the differences dates and weeks

SELECT DATEDIFF(DAY, order_date, shipped_date) DATE_DIFF, order_date, shipped_date
FROM sale.orders

SELECT DATEDIFF(WEEK, order_date, shipped_date) DATE_DIFF, order_date, shipped_date
FROM sale.orders

------------------------------------------------------------

-- DATEADD

SELECT order_date,
       DATEADD(YEAR, 5, order_date) YEAR_ADD,
       DATEADD(DAY, 10, order_date) DAY_ADD
FROM sale.orders

------------------------------------------------------------

--EOMONTH (END OF MONTH)

SELECT EOMONTH(GETDATE()), EOMONTH(GETDATE(),2) AS TWO_MONTHS_LATER

------------------------------------------------------------

-- check date or not (Result will be 1 or 0)

SELECT ISDATE('2021-10-01')

SELECT ISDATE('select')

------------------------------------------------------------

-- add a field about the delivery speed of orders to the Orders table
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

------------------------------------------------------------

-- list the orders shipped in more than two days after the ordered date

WITH T1 AS
(SELECT *,
       DATEDIFF(DAY, order_date, shipped_date) DIFF
FROM sale.orders)

SELECT *
FROM T1
WHERE DIFF > 2

------------------------------------------------------------

-- list the distributions of above orders on weekdays

SELECT SUM(CASE WHEN DATENAME(WEEKDAY, order_date)='Monday' THEN 1 END) MONDAY,
       SUM(CASE WHEN DATENAME(WEEKDAY, order_date)='Tuesday' THEN 1 END) TUESDAY,
       SUM(CASE WHEN DATENAME(WEEKDAY, order_date)='Wednesday' THEN 1 END) Wednesday,
       SUM(CASE WHEN DATENAME(WEEKDAY, order_date)='Thursday' THEN 1 END) Thursday,
       SUM(CASE WHEN DATENAME(WEEKDAY, order_date)='Friday' THEN 1 END) FRIDAY,
       SUM(CASE WHEN DATENAME(WEEKDAY, order_date)='Saturday' THEN 1 END) SATURDAY,
       SUM(CASE WHEN DATENAME(WEEKDAY, order_date)='Sunday' THEN 1 END) SUNDAY
FROM sale.orders
WHERE DATEDIFF(DAY, order_date, shipped_date) > 2

------------------------------------------------------------

-- String Functions

SELECT LEN(123456789)

SELECT LEN('WELCOME')

-- Char Index

SELECT CHARINDEX('C', 'CHARACTER')

SELECT CHARINDEX('C', 'CHARACTER', 2) -- start from 2. letter

-- Pat Index

SELECT PATINDEX('R', 'CHARACTER')

SELECT PATINDEX('R%','CHARACTER')

SELECT PATINDEX('%R%','CHARACTER')

SELECT PATINDEX('%R','CHARACTER')

-- LEFT

SELECT LEFT('CHARACTER',3)

-- RIGHT

SELECT RIGHT('CHARACTER',3)

-- SUBSTRING

SELECT SUBSTRING('CHARACTER',1,3)

SELECT SUBSTRING('CHARACTER',-1,3)

SELECT SUBSTRING('CHARACTER',0,1)

-- LOWER

SELECT LOWER('CHARACTER')

-- UPPER

SELECT UPPER('character')

------------------------------------------------------------

-- STRING SPLIT

SELECT value FROM string_split('ALİ,MEHMET,AYŞE', ',')

-- TRIM, LTRIM, RTRIM

SELECT TRIM('  CHARA CTER')

SELECT LTRIM('             CHARA CTER')

SELECT RTRIM('         CHARA CTER         ')

------------------------------------------------------------

-- Replace

SELECT REPLACE('CHARACTER STRING', ' ', '/')

SELECT REPLACE(123123123555, 123, 88)

-- STR

SELECT STR(5454.475, 7)

SELECT STR(5454.475, 7, 3)

-- Cast

SELECT CAST(123135 AS varchar) 

SELECT CAST(0.333333 AS numeric(3,2))


-- Convert

SELECT CONVERT(INT, 30.48)

SELECT CONVERT(datetime, '2021-10-10')

-- COALESCE 

SELECT COALESCE(NULL, NULL, 'Ahmet', NULL)

-- NULLIF

SELECT NULLIF(10,9)

-- ROUND

SELECT ROUND(432.365, 2)

SELECT ROUND(432.365, 3)

SELECT ROUND(432.365, 2, 1)

------------------------------------------------------------

-- Add a new column to the customers table that contains the customers' contact information.
-- If the phone is not null, the phone information will be printed, if not, the email information will be printed.

SELECT *, COALESCE(phone, NULLIF(email, 'emily.brooks@yahoo.com')) Contact
FROM sale.customer

-- get the rows that its left third characte is number in the street column

SELECT street, SUBSTRING(street, 3, 1)
FROM sale.customer
WHERE ISNUMERIC(SUBSTRING(street, 3, 1))=1