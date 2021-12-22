USE lessons;

-------------------------------------------------------------------------------
-- Self-contained subqueries
-------------------------------------------------------------------------------

SELECT orderid, orderdate, empid, custid
  FROM Sales.Orders
WHERE orderid = (SELECT MAX(O.orderid)
                  FROM Sales.Orders AS O);

-- Why not works

SELECT orderid
FROM Sales.Orders
WHERE empid =
  (SELECT E.empid
   FROM HR.Employees AS E
   WHERE E.lastname LIKE N'D%');

-- Fixed

SELECT orderid
FROM Sales.Orders
WHERE empid =
  (SELECT E.empid
   FROM HR.Employees AS E
   WHERE E.lastname LIKE N'C%');

-- NULL

SELECT orderid
FROM Sales.Orders
WHERE empid =
  (SELECT E.empid
   FROM HR.Employees AS E
   WHERE E.lastname LIKE N'A%');

-- Multi value

SELECT orderid
FROM Sales.Orders
WHERE empid IN
  (SELECT E.empid
   FROM HR.Employees AS E
   WHERE E.lastname LIKE N'D%');

-- Alternative

SELECT O.orderid
FROM HR.Employees AS E
  INNER JOIN Sales.Orders AS O
    ON E.empid = O.empid
WHERE E.lastname LIKE N'D%';

/*
Write a query that returns orders placed by customers 
from the United States. You can write a query against 
the Orders table that returns orders where the customer ID is in the set of customer IDs of customers from the United States. 
You can implement the last part in a self-contained, 
multivalued subquery. 
*/

SELECT custid, orderid, orderdate, empid
FROM Sales.Orders
WHERE custid IN
  (SELECT C.custid
   FROM Sales.Customers AS C
   WHERE C.country = N'USA');

-- We can use NOT IN as well

SELECT custid, orderid, orderdate, empid
FROM Sales.Orders
WHERE custid IN
  (SELECT C.custid
   FROM Sales.Customers AS C
   WHERE C.country = N'USA');

SELECT n
FROM dbo.Nums
WHERE n BETWEEN (SELECT MIN(O.orderid) FROM Sales.Orders AS O)
            AND (SELECT MAX(O.orderid) FROM Sales.Orders AS O)

SELECT
*
FROM
Sales.Customers C
INNER JOIN (
    SELECT * FROM Sales.Orders
) OrderData ON orderdata.custid = c.custid

-- Corelated subquery

-- Will find latest max order id
SELECT custid, orderid, orderdate, empid
FROM Sales.Orders AS O1
WHERE orderid =
  (SELECT MAX(O2.orderid)
   FROM Sales.Orders AS O2
   WHERE O2.custid = O1.custid);

SELECT orderid, custid, val,
  CAST(100. * val / (SELECT SUM(O2.val)
                     FROM Sales.OrderValues AS O2
                     WHERE O2.custid = O1.custid)
       AS NUMERIC(5,2)) AS pct
FROM Sales.OrderValues AS O1
ORDER BY custid, orderid;

SELECT orderid, custid, val,
  CAST(100. * val / 10000
       AS NUMERIC(5,2)) AS pct
FROM Sales.OrderValues AS O1
ORDER BY custid, orderid;

-- What order for customer exist or not exist
SELECT custid, companyname
FROM Sales.Customers AS C
WHERE country = N'Spain'
  AND NOT EXISTS
    (SELECT * FROM Sales.Orders AS O
     WHERE O.custid = C.custid);

-- What order for customer exist or not exist join
SELECT S.custid, S.country 
FROM Sales.Customers 
AS S LEFT JOIN Sales.Orders AS O ON  O.custid = S.custid 
WHERE O.orderid IS NULL AND S.country = N'Spain';

-- Find previous orders?
SELECT orderid, orderdate, empid, custid,
  (SELECT MAX(O2.orderid)
   FROM Sales.Orders AS O2
   WHERE O2.orderid < O1.orderid) AS prevorderid
FROM Sales.Orders AS O1;