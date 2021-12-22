USE lessons;

-------------------------------------------------------------------------------
-- Cross join
-------------------------------------------------------------------------------

SELECT C.custid, E.empid
FROM Sales.Customers AS C
  CROSS JOIN HR.Employees AS E;

SELECT COUNT(*) 
FROM Sales.Customers AS C
  CROSS JOIN HR.Employees AS E;

SELECT COUNT(*)
FROM Sales.Customers; -- 91 

SELECT COUNT(*)
FROM HR.Employees; -- 8

SELECT * FROM Sales.Orders as orders 
    CROSS JOIN HR.Employees as employees;

SELECT * FROM Sales.Orders, HR.Employees; -- ISO/ANSI SQL-89 syntax

-- Do not works
-- SELECT * FROM Sales.Orders JOIN HR.Employees;

-- Self join
SELECT E1.address, E2.address FROM HR.Employees AS E1
  CROSS JOIN HR.Employees AS E2; 

-- Generation of seq of numbers from 1 to 1000
DROP TABLE IF EXISTS dbo.Digits;

CREATE TABLE dbo.Digits(digit INT NOT NULL PRIMARY KEY);

INSERT INTO dbo.Digits(digit)
  VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9);

SELECT digit FROM dbo.Digits;

SELECT D3.digit * 100 + D2.digit * 10 + D1.digit + 1 AS n
FROM         dbo.Digits AS D1
  CROSS JOIN dbo.Digits AS D2
  CROSS JOIN dbo.Digits AS D3
ORDER BY n;

-------------------------------------------------------------------------------
-- inner join
-------------------------------------------------------------------------------

SELECT E.empid, E.firstname, E.lastname, O.orderid
FROM HR.Employees AS E
  INNER JOIN Sales.Orders AS O
    ON E.empid = O.empid;

SELECT E.empid, E.firstname, E.lastname, O.orderid
FROM HR.Employees AS E, Sales.Orders AS O
    WHERE E.empid = O.empid;

-- no equi join

SELECT
  E1.empid,
  E2.empid
FROM HR.Employees AS E1
  CROSS JOIN HR.Employees AS E2;

SELECT
  E1.empid,
  E2.empid
FROM HR.Employees AS E1
  INNER JOIN HR.Employees AS E2
    ON E1.empid < E2.empid;

-------------------------------------------------------------------------------
-- left join
-------------------------------------------------------------------------------
-- Check what orders do not exist for customer.

SELECT C.custid, C.companyname, O.orderid
FROM Sales.Customers AS C
  LEFT OUTER JOIN Sales.Orders AS O
    ON C.custid = O.custid;
-- WHERE orderid IS NULL; will return two records


-------------------------------------------------------------------------------
-- right join
-------------------------------------------------------------------------------

SELECT C.custid, C.companyname, O.orderid
FROM Sales.Customers AS C
  RIGHT OUTER JOIN Sales.Orders AS O
    ON C.custid = O.custid;
-- WHERE orderid IS NULL; will return empty

-------------------------------------------------------------------------------
-- composite join
-------------------------------------------------------------------------------

SELECT OD.orderid, OD.productid, OD.qty
FROM Sales.OrderDetails AS OD
  INNER JOIN Sales.OrderDetails AS ODA
    ON OD.orderid = ODA.orderid
    AND OD.productid = ODA.productid;

-------------------------------------------------------------------------------
-- advanced join
-------------------------------------------------------------------------------

SELECT DATEADD(day, n-1, CAST('20140101' AS DATE)) AS orderdate
FROM dbo.Nums
WHERE n <= DATEDIFF(day, '20140101', '20161231') + 1
ORDER BY orderdate;

SELECT DATEADD(day, Nums.n - 1, CAST('20140101' AS DATE)) AS orderdate,
  O.orderid, O.custid, O.empid
FROM dbo.Nums
  LEFT OUTER JOIN Sales.Orders AS O
    ON DATEADD(day, Nums.n - 1, CAST('20140101' AS DATE)) = O.orderdate
WHERE Nums.n <= DATEDIFF(day, '20140101', '20161231') + 1
ORDER BY orderdate;

SELECT C.custid, C.companyname, O.orderid, O.orderdate
FROM Sales.Customers AS C
  LEFT OUTER JOIN Sales.Orders AS O
    ON C.custid = O.custid
WHERE O.orderdate IS NULL;