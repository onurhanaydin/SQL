use SampleSales

-- STRING FUNCTIONS

-- Len

SELECT LEN(123456789)

SELECT LEN('WELCOME')

-- Char Index

SELECT CHARINDEX('C', 'CHARACTER')

SELECT CHARINDEX('C', 'CHARACTER', 2) -- start from 2. letter

-- PATINDEX

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

-- STRING SPLIT

SELECT value FROM string_split('ALİ,MEHMET,AYŞE', ',')

-- TRIM, LTRIM, RTRIM

SELECT TRIM('  CHARA CTER')

SELECT LTRIM('             CHARA CTER')

SELECT RTRIM('         CHARA CTER         ')

-- REPLACE

SELECT REPLACE('CHARACTER STRING', ' ', '/')

SELECT REPLACE(123123123555, 123, 88)

select REPLACE(1232435464, 123, 'aha')

-- STR

SELECT STR(5454.475, 7)

SELECT STR(5454.475, 7, 3)

-- CAST

SELECT CAST(123135 AS VARCHAR)

SELECT CAST(0.3333333 AS NUMERIC(3,2))

SELECT CAST(0.3333333 AS DECIMAL(3,2))

-- CONVERT

SELECT CONVERT(INT , 30.48)

SELECT CONVERT(DATETIME , '2021-10-10')

SELECT CONVERT (nvarchar , '2021-10-10' , 6)

-- COALESCE

SELECT COALESCE(NULL, NULL, 'Ahmet', NULL)

-- NULLIF

SELECT NULLIF (10, 9)

-- ROUND

SELECT ROUND(432.368, 2)

SELECT ROUND(432.368, 3)

SELECT ROUND(432.368, 2, 1)

SELECT ROUND(432.364, 2)

SELECT ROUND(432.364, 1)

SELECT ROUND(432.364, 1, 1)


-- How namy mails are Yahoo mail among customer mails?

SELECT
SUM(CASE WHEN patindex('%@yahoo%', email) <> 0 AND patindex('%@yahoo%', email) IS NOT NULL THEN 1 ELSE 0 END) AS yahoo
FROM sale.customer

-- OR 

SELECT	count(*)
FROM	sale.customer
WHERE	email LIKE '%@yahoo%'

-- OR

SELECT SUM(CASE WHEN PATINDEX ('%@yahoo%', email) > 0 THEN 1 ELSE 0 END) 
FROM sale.customer

-----------

-- List the contact method for each customer by phone or email.
-- If the customer has phone contact, there is no need email information.
-- If the customer has no phone contact, get email address as contact information.

SELECT	*, COALESCE(phone, nullif(email, 'emily.brooks@yahoo.com'), 'a') contact
FROM	sale.customer

-- List the records that their third value is number by left

SELECT	street, SUBSTRING(street, 3, 1)
FROM	sale.customer
WHERE	ISNUMERIC(SUBSTRING(street, 3, 1)) = 1

-- OR

SELECT	street, SUBSTRING(street, 3, 1)
FROM	sale.customer
WHERE	SUBSTRING(street, 3, 1) LIKE '[0-9]'

-- OR

SELECT	street, SUBSTRING(street, 3, 1)
FROM	sale.customer
WHERE	SUBSTRING(street, 3, 1) NOT LIKE '[a-z]'

-- OR

SELECT	street, SUBSTRING(street, 3, 1)
FROM	sale.customer
WHERE	SUBSTRING(street, 3, 1) NOT LIKE '[^0-9]'





