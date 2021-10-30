-- First of all, create a table 

CREATE TABLE transactionlog
(Sender_ID int,
Receiver_ID int,
Amount int,
Transaction_Date date)

-- Check the table if exists or not

select *
FROM transactionlog

---------------------------------------------------------

-- insert the values to the table

INSERT INTO transactionlog (Sender_ID, Receiver_ID, Amount, Transaction_Date)
VALUES 
(55, 22, 500, '2021-05-18'),
(11, 33, 350, '2021-05-19'),
(22, 11, 650, '2021-05-19'),
(22, 33, 900, '2021-05-20'),
(33, 11, 500, '2021-05-21'),
(33, 22, 750, '2021-05-21'),
(11, 44, 300, '2021-05-22')

select *
FROM transactionlog

---------------------------------------------------------

-- Now, create two different tables as debt and hold

SELECT Sender_ID, SUM(Amount) AS Total_debt
FROM transactionlog
GROUP BY Sender_ID        

SELECT Receiver_ID, SUM(Amount) AS Total_holding
FROM transactionlog
GROUP BY Receiver_ID

---------------------------------------------------------

-- do full outer join in order to get both tables

SELECT A.Sender_ID, B.Receiver_ID AS Account_ID,
       (B.Total_holding-A.Total_debt) AS Net_Change

FROM (
      SELECT Sender_ID, SUM(Amount) AS Total_debt
      FROM transactionlog
      GROUP BY Sender_ID 
) A 

FULL OUTER JOIN

(
      SELECT Receiver_ID, SUM(Amount) AS Total_holding
      FROM transactionlog
      GROUP BY Receiver_ID
) B 

ON A.Sender_ID=B.Receiver_ID

---------------------------------------------------------

-- use 'Coalesce' command to avoid NULL values

SELECT COALESCE(A.Sender_ID, B.Receiver_ID) AS Account_ID,
       COALESCE(B.Total_holding,0)-COALESCE(A.Total_debt,0) AS Net_Change

FROM (
      SELECT Sender_ID, SUM(Amount) AS Total_debt
      FROM transactionlog
      GROUP BY Sender_ID 
) A 

FULL OUTER JOIN

(
      SELECT Receiver_ID, SUM(Amount) AS Total_holding
      FROM transactionlog
      GROUP BY Receiver_ID
) B 

ON A.Sender_ID=B.Receiver_ID