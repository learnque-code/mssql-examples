-------------------------------------------------------------------------------
-- Union, Union All
-------------------------------------------------------------------------------

SELECT country, region, city FROM HR.Employees
UNION
SELECT country, region, city FROM Sales.Customers;

SELECT country, region, city FROM HR.Employees
UNION ALL
SELECT country, region, city FROM Sales.Customers;

-------------------------------------------------------------------------------
-- Intersect
-------------------------------------------------------------------------------

SELECT country, region, city FROM HR.Employees
INTERSECT
SELECT country, region, city FROM Sales.Customers;

SELECT DISTINCT E.country, E.region, E.city 
FROM HR.Employees AS E
INNER JOIN Sales.Customers AS C
    ON E.region = C.region OR (E.region IS NULL AND C.region IS NULL)

SELECT
  ROW_NUMBER()
    OVER(PARTITION BY country, region, city
         ORDER     BY (SELECT 0)) AS rownum,
  country, region, city
FROM HR.Employees

INTERSECT

SELECT
  ROW_NUMBER()
    OVER(PARTITION BY country, region, city
         ORDER     BY (SELECT 0)),
  country, region, city
FROM Sales.Customers;

WITH INTERSECT_ALL
AS
(
  SELECT
    ROW_NUMBER()
      OVER(PARTITION BY country, region, city
           ORDER     BY (SELECT 0)) AS rownum,
    country, region, city
  FROM HR.Employees

  INTERSECT

  SELECT
    ROW_NUMBER()
      OVER(PARTITION BY country, region, city
           ORDER     BY (SELECT 0)),
    country, region, city
  FROM Sales.Customers
)
SELECT country, region, city
FROM INTERSECT_ALL;

SELECT country, region, city FROM HR.Employees
EXCEPT
SELECT country, region, city FROM Sales.Customers;

SELECT country, region, city FROM Sales.Customers
EXCEPT
SELECT country, region, city FROM HR.Employees;

WITH EXCEPT_ALL
AS
(
  SELECT
    ROW_NUMBER()
      OVER(PARTITION BY country, region, city
           ORDER     BY (SELECT 0)) AS rownum,
    country, region, city
    FROM HR.Employees

  EXCEPT

  SELECT
    ROW_NUMBER()
      OVER(PARTITION BY country, region, city
           ORDER     BY (SELECT 0)),
    country, region, city
  FROM Sales.Customers
)
SELECT country, region, city
FROM EXCEPT_ALL;

-------------------------------------------------------------------------------
-- Precendence
-------------------------------------------------------------------------------
SELECT country, region, city FROM Production.Suppliers
EXCEPT
SELECT country, region, city FROM HR.Employees
INTERSECT
SELECT country, region, city FROM Sales.Customers;

/*
Because INTERSECT precedes EXCEPT, the INTERSECT operator is evaluated first, 
even though it appears second in the code. The meaning of this query is, 
“locations that are supplier locations, 
but not (locations that are both employee and customer locations).”
*/

-- Note

SELECT country, COUNT(*) AS numlocations
FROM (SELECT country, region, city FROM HR.Employees
      UNION
      SELECT country, region, city FROM Sales.Customers) AS U
GROUP BY country;

SELECT empid, orderid, orderdate
FROM (SELECT TOP (2) empid, orderid, orderdate
      FROM Sales.Orders
      WHERE empid = 3
      ORDER BY orderdate DESC, orderid DESC) AS D1

UNION ALL

SELECT empid, orderid, orderdate
FROM (SELECT TOP (2) empid, orderid, orderdate
      FROM Sales.Orders
      WHERE empid = 5
      ORDER BY orderdate DESC, orderid DESC) AS D2;
