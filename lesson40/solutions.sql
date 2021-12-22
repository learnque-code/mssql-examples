-- Solution 1

WITH C AS
(
  SELECT orderid, orderdate, custid, empid,
    DATEFROMPARTS(YEAR(orderdate), 12, 31) AS endofyear
  FROM Sales.Orders
)
SELECT orderid, orderdate, custid, empid, endofyear
FROM C
WHERE orderdate <> endofyear;

SELECT orderid, orderdate, custid, empid, endofyear
FROM (
  SELECT orderid, orderdate, custid, empid,
    DATEFROMPARTS(YEAR(orderdate), 12, 31) AS endofyear
  FROM Sales.Orders
) AS C
WHERE orderdate <> endofyear;

-- Solution 2

SELECT empid, MAX(orderdate) AS maxorderdate
FROM Sales.Orders
GROUP BY empid;

--

SELECT O.empid, O.orderdate, O.orderid, O.custid
FROM Sales.Orders AS O
  INNER JOIN (SELECT empid, MAX(orderdate) AS maxorderdate
              FROM Sales.Orders
              GROUP BY empid) AS D
    ON O.empid = D.empid
    AND O.orderdate = D.maxorderdate;

-- Solution 3

WITH OrdersRowNumber AS
(
  SELECT orderid, orderdate, custid, empid,
    ROW_NUMBER() OVER(ORDER BY orderdate, orderid) AS rownum
  FROM Sales.Orders
)
SELECT * FROM OrdersRowNumber WHERE rownum BETWEEN 11 AND 20;

-- Solution 4

DROP VIEW IF EXISTS Sales.ViewEmployeeOrders
GO

CREATE VIEW  Sales.ViewEmployeeOrders
AS
SELECT
  empid,
  YEAR(orderdate) AS orderyear,
  SUM(qty) AS qty
FROM Sales.Orders AS O
  INNER JOIN Sales.OrderDetails AS OD
    ON O.orderid = OD.orderid
GROUP BY
  empid,
  YEAR(orderdate)
GO

--

SELECT empid, orderyear, qty,
  (SELECT SUM(qty)
   FROM  Sales.ViewEmployeeOrders AS V2
   WHERE V2.empid = V1.empid
     AND V2.orderyear <= V1.orderyear) AS runqty
FROM  Sales.ViewEmployeeOrders AS V1
ORDER BY empid, orderyear;

-- Solution 5

DROP FUNCTION IF EXISTS Production.TopProducts;
GO
CREATE FUNCTION Production.TopProducts
  (@supid AS INT, @n AS INT)
  RETURNS TABLE
AS
RETURN
  SELECT TOP (@n) productid, productname, unitprice
  FROM Production.Products
  WHERE supplierid = @supid
  ORDER BY unitprice DESC

  /*
  -- With OFFSET-FETCH
  SELECT productid, productname, unitprice
  FROM Production.Products
  WHERE supplierid = @supid
  ORDER BY unitprice DESC
  OFFSET 0 ROWS FETCH NEXT @n ROWS ONLY;
  */
GO

-- Solution 6

SELECT custid, empid
FROM Sales.Orders
WHERE orderdate >= '20160101' AND orderdate < '20160201'
EXCEPT
SELECT custid, empid
FROM Sales.Orders
WHERE orderdate >= '20160201' AND orderdate < '20160301';

-- Solution 7

SELECT custid, empid
FROM Sales.Orders
WHERE orderdate >= '20160101' AND orderdate < '20160201'

INTERSECT

SELECT custid, empid
FROM Sales.Orders
WHERE orderdate >= '20160201' AND orderdate < '20160301';

-- Solution 8

SELECT custid, empid
FROM Sales.Orders
WHERE orderdate >= '20160101' AND orderdate < '20160201'

INTERSECT

SELECT custid, empid
FROM Sales.Orders
WHERE orderdate >= '20160201' AND orderdate < '20160301'

EXCEPT

SELECT custid, empid
FROM Sales.Orders
WHERE orderdate >= '20150101' AND orderdate < '20160101';