-- Solutions
USE lessons;

-- Exercise 1
SELECT orderid, orderdate, custid, empid
FROM Sales.Orders
WHERE YEAR(orderdate) = 2015 AND MONTH(orderdate) = 6;

-- Or
SELECT orderid, orderdate, custid, empid
FROM Sales.Orders
WHERE orderdate >= '20150601' 
  AND orderdate < '20150701';

-- Exercise 2

-- With the EOMONTH function
SELECT orderid, orderdate, custid, empid
FROM Sales.Orders
WHERE orderdate = EOMONTH(orderdate);

-- Without the EOMONTH function
SELECT orderid, orderdate, custid, empid 
FROM Sales.Orders WHERE MONTH(orderdate) != MONTH(DATEADD(DD, 1, orderdate))
ORDER BY orderdate ASC

-- Exercise 3

-- Solution
SELECT empid, firstname, lastname
FROM HR.Employees
WHERE lastname LIKE '%e%e%';

-- Exercise 4

-- Incorrect solution
SELECT empid, lastname
FROM HR.Employees
WHERE lastname COLLATE Latin1_General_CS_AS LIKE N'[a-z]%';

-- Correct solutions
SELECT empid, lastname
FROM HR.Employees
WHERE lastname COLLATE Latin1_General_CS_AS LIKE N'[abcdefghijklmnopqrstuvwxyz]%';

SELECT empid, lastname 
FROM HR.Employees 
WHERE LEFT(lastname COLLATE Latin1_General_CS_AS, 1) = LOWER(LEFT(lastname, 1))

-- Exercise 5

-- Solution
SELECT TOP (3) shipcountry, AVG(freight) AS avgfreight
FROM Sales.Orders
WHERE orderdate >= '20150101' AND orderdate < '20160101'
GROUP BY shipcountry
ORDER BY avgfreight DESC;

-- With OFFSET-FETCH
SELECT shipcountry, AVG(freight) AS avgfreight
FROM Sales.Orders
WHERE orderdate >= '20150101' AND orderdate < '20160101'
GROUP BY shipcountry
ORDER BY avgfreight DESC
OFFSET 0 ROWS FETCH NEXT 3 ROWS ONLY;

SELECT
TOP 3
SO.shipcountry,
AVG(freight)
FROM Sales.Orders SO
WHERE
YEAR(SO.orderdate) = 2015
GROUP BY SO.shipcountry
ORDER BY AVG(freight) DESC

-- Exercise 6

-- Solutions
SELECT empid, firstname, lastname, titleofcourtesy,
  CASE titleofcourtesy
    WHEN 'Ms.'  THEN 'Female'
    WHEN 'Mrs.' THEN 'Female'
    WHEN 'Mr.'  THEN 'Male'
    ELSE             'Unknown'
  END AS gender
FROM HR.Employees;

SELECT empid, firstname, lastname, titleofcourtesy,
  CASE 
    WHEN titleofcourtesy IN('Ms.', 'Mrs.') THEN 'Female'
    WHEN titleofcourtesy = 'Mr.'           THEN 'Male'
    ELSE                                        'Unknown'
  END AS gender
FROM HR.Employees;


-- Exercise 7
-- Return for each customer the customer ID and region
-- sort the rows in the output by region
-- having NULLs sort last (after non-NULL values)
-- Note that the default in T-SQL is that NULLs sort first
-- Tables involved: Sales.Customers table

-- Desired output:
custid      region
----------- ---------------
55          AK
10          BC
42          BC
45          CA
37          Co. Cork
33          DF
71          ID
38          Isle of Wight
46          Lara
78          MT
...
1           NULL
2           NULL
3           NULL
4           NULL
5           NULL
6           NULL
7           NULL
8           NULL
9           NULL
11          NULL
...

(91 row(s) affected)

-- Solution
SELECT custid, region
FROM Sales.Customers
ORDER BY
  CASE WHEN region IS NULL THEN 1 ELSE 0 END, region;

SELECT custid, region FROM Sales.Customers
ORDER BY ISNULL(region, 'z') ASC, custid
