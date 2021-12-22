USE lessons
GO

SELECT TOP 10 * FROM Sales.Orders
GO

SELECT TOP 5 * FROM Sales.Orders
WHERE custid = 71
GO

SELECT TOP 5 orderid, custid, empid, orderdate, freight
FROM Sales.Orders
GO

SELECT TOP 5 custid, orderdate FROM Sales.Orders
WHERE custid > 40
GO

SELECT TOP 5 custid, orderdate FROM Sales.Orders
WHERE custid > 40 AND custid < 45
GO

SELECT TOP 5 custid, orderdate FROM Sales.Orders
WHERE custid IN (41, 42)
GO

SELECT TOP 5 custid, orderdate FROM Sales.Orders 
WHERE custid BETWEEN 41 AND 42
GO

SELECT TOP 5 shipaddress FROM Sales.Orders 
WHERE shipaddress LIKE '%tau%'
GO

SELECT empid, YEAR(orderdate) FROM Sales.Orders
WHERE custid = 71
GO

SELECT empid, YEAR(orderdate) FROM Sales.Orders
WHERE custid = 71
GROUP BY empid, YEAR(orderdate)
GO

SELECT shipregion, YEAR(orderdate) AS [order year %], shippeddate FROM Sales.Orders 
WHERE YEAR(orderdate) > 2015 AND (ISNULL(shippeddate, '') != '')
GO

SELECT empid, YEAR(orderdate) AS orderyear FROM Sales.Orders
WHERE custid = 71
GROUP BY empid, YEAR(orderdate)
GO

SELECT
  empid,
  YEAR(orderdate) AS orderyear,
  COUNT(*) AS numorders
FROM Sales.Orders
WHERE custid = 71
GROUP BY empid, YEAR(orderdate)
GO

SELECT
  empid,
  YEAR(orderdate) AS orderyear,
  SUM(freight) AS totalfreight,
  COUNT(*) AS numorders
FROM Sales.Orders
WHERE custid = 71
GROUP BY empid, YEAR(orderdate)
GO

SELECT
  empid,
  YEAR(orderdate) AS orderyear,
  COUNT(custid) AS numcusts
FROM Sales.Orders
GROUP BY empid, YEAR(orderdate);

SELECT * FROM Sales.Orders WHERE empid = 1 AND YEAR(orderdate) = '2014'
GO

SELECT
  empid,
  YEAR(orderdate) AS orderyear,
  COUNT(DISTINCT custid) AS numcusts
FROM Sales.Orders
GROUP BY empid, YEAR(orderdate)
GO

SELECT DISTINCT custid, empid, YEAR(orderdate) AS orderyear FROM Sales.Orders 
WHERE empid = 1 AND YEAR(orderdate) = '2014'
GO

SELECT empid, YEAR(orderdate) AS orderyear
FROM Sales.Orders
WHERE custid = 71
GROUP BY empid, YEAR(orderdate)
HAVING COUNT(*) > 1;

SELECT empid, YEAR(orderdate) AS orderyear
FROM Sales.Orders
WHERE custid = 71
GROUP BY empid, YEAR(orderdate)
HAVING empid in (6, 7);

SELECT empid, YEAR(orderdate) AS orderyear, COUNT(*) AS numorders
FROM Sales.Orders
WHERE custid = 71
GROUP BY empid, YEAR(orderdate)
HAVING COUNT(*) > 1
ORDER BY empid, orderyear
GO

SELECT empid, YEAR(orderdate) AS orderyear, COUNT(*) AS numorders
FROM Sales.Orders
WHERE custid = 71
GROUP BY empid, YEAR(orderdate)
HAVING COUNT(*) > 1
ORDER BY empid DESC, orderyear ASC
GO

SELECT empid, YEAR(orderdate) AS orderyear, COUNT(*) AS numorders
FROM Sales.Orders
WHERE custid = 71
GROUP BY empid, YEAR(orderdate)
HAVING COUNT(*) > 1
ORDER BY 1, 2
GO

SELECT DISTINCT country
FROM HR.Employees
ORDER BY empid;

SELECT TOP (5) orderid, orderdate, custid, empid
FROM Sales.Orders
ORDER BY orderdate DESC
GO

SELECT TOP (1) PERCENT orderid, orderdate, custid, empid
FROM Sales.Orders
ORDER BY orderdate DESC;

SELECT orderid, orderdate, custid, empid
FROM Sales.Orders
ORDER BY orderdate, orderid
OFFSET 50 ROWS FETCH NEXT 25 ROWS ONLY
GO

SELECT TOP(5) orderid, productid, qty, unitprice, discount,
  FORMAT(ROUND(qty * unitprice * (1 - discount), 2), '##.##') AS val
FROM Sales.OrderDetails
GO

SELECT TOP(5) orderid, productid, qty, unitprice, discount,
  CAST(qty * unitprice * (1 - discount) AS NUMERIC(12, 2)) as val
FROM Sales.OrderDetails
GO

SELECT productid, productname, categoryid,
  CASE categoryid
    WHEN 1 THEN 'Beverages'
    WHEN 2 THEN 'Condiments'
    WHEN 3 THEN 'Confections'
    WHEN 4 THEN 'Dairy Products'
    WHEN 5 THEN 'Grains/Cereals'
    WHEN 6 THEN 'Meat/Poultry'
    WHEN 7 THEN 'Produce'
    WHEN 8 THEN 'Seafood'
    ELSE 'Unknown Category'
  END AS categoryname
FROM Production.Products
GO

SELECT orderid, custid, val,
  CASE
    WHEN val < 1000.00                   THEN 'Less than 1000'
    WHEN val BETWEEN 1000.00 AND 3000.00 THEN 'Between 1000 and 3000'
    WHEN val > 3000.00                   THEN 'More than 3000'
    ELSE 'Unknown'
  END AS valuecategory
FROM Sales.OrderValues;

SELECT custid, country, region, city
FROM Sales.Customers
WHERE region IS NULL -- IS NOT NULL
GO

SELECT custid, country, region, city,
  country + COALESCE( N',' + region, N'') + N',' + city AS location
FROM Sales.Customers
GO

SELECT custid, country, region, city,
  CONCAT(country, N',' + region, N',' + city) AS location
FROM Sales.Customers
GO

SELECT CONCAT('Test1', NULL, 'Test2') AS val
GO

SELECT VALUE AS LASTDAYOFMONTH
    FROM STRING_SPLIT(CAST(EOMONTH('2012-05-06') AS VARCHAR), '-') 
    ORDER BY VALUE 
    OFFSET 2 ROW FETCH NEXT 1 ROW ONLY
GO

SELECT empid, lastname
FROM HR.Employees
WHERE lastname LIKE N'_e%';

SELECT empid, lastname
FROM HR.Employees
WHERE lastname COLLATE Latin1_General_CS_AS LIKE N'[A-z]%';
