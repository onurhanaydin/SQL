-- create a table 

CREATE TABLE visit
(Visitor_ID int NOT NULL,
Adv_Type VARCHAR (30) NOT NULL,
Actionn VARCHAR (30) NOT NULL)

select *
FROM visit

----------------------------------------------

-- insert values to the visit table

INSERT INTO visit (Visitor_ID, Adv_Type, Actionn)
VALUES

(1,'A','Left'),
(2,'A','Order'),
(3,'B','Left'),
(4,'A','Order'),
(5,'A','Review'),
(6,'A','Left'),
(7,'B','Left'),
(8,'B','Order'),
(9,'B','Review'),
(10,'A','Review')

select *
FROM visit

----------------------------------------------

-- retrieve count of total Actions and Orders for each Advertisement Type

SELECT A.Actionn, A.A, B.B
FROM (SELECT Actionn, count(Actionn) AS A
FROM visit
WHERE Adv_Type='A'
GROUP by Actionn) A

FULL OUTER JOIN

(SELECT Actionn, count(Actionn) AS B
FROM visit
WHERE Adv_Type='B'
GROUP by Actionn) B 

ON A.Actionn=B.Actionn

----------------------------------------------

-- calculate Orders (Conversion) rates for each Advertisement Type by dividing by total count of actions casting as float 

SELECT cast(2*1.0/SUM(A) as numeric(3,2)) AS A_conv, cast(1*1.0/SUM(B) as numeric (3,2)) AS B_conv
FROM (SELECT Actionn, count(Actionn) AS A
FROM visit
WHERE Adv_Type='A' 
GROUP by Actionn) A

FULL OUTER JOIN

(SELECT Actionn, count(Actionn) AS B
FROM visit
WHERE Adv_Type='B'
GROUP by Actionn) B 

ON A.Actionn=B.Actionn

