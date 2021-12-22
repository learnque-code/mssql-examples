-------------------------------------------------------------------------------
-- SELECT INTO
-------------------------------------------------------------------------------
/*
    This example show how to combine data 
    with set operators and create a new table
*/

DROP TABLE IF EXISTS dbo.Locations;

SELECT country, region, city
INTO dbo.Locations
FROM Sales.Customers

EXCEPT

SELECT country, region, city
FROM HR.Employees;

-------------------------------------------------------------------------------
-- SEQUENCE creation example
-------------------------------------------------------------------------------

DROP TABLE IF EXISTS dbo.T1;

CREATE TABLE dbo.T1
(
  keycol  INT         NOT NULL
    CONSTRAINT PK_T1 PRIMARY KEY,
  datacol VARCHAR(10) NOT NULL
);

DECLARE @neworderid AS INT = NEXT VALUE FOR dbo.SeqMaxOrderId;
INSERT INTO dbo.T1(keycol, datacol) VALUES(@neworderid, 'a');

SELECT * FROM dbo.T1;

DROP TABLE IF EXISTS dbo.T2;

CREATE TABLE dbo.T2
(
  keycol  INT NOT NULL DEFAULT NEXT VALUE FOR dbo.SeqMaxOrderId
    CONSTRAINT PK_T2 PRIMARY KEY,
  datacol VARCHAR(10) NOT NULL
);

INSERT INTO dbo.T2(datacol) VALUES('a');
SELECT * FROM dbo.T2;

-------------------------------------------------------------------------------
-- Merge
-------------------------------------------------------------------------------

DROP TABLE IF EXISTS dbo.Customers, dbo.CustomersStage;
GO

CREATE TABLE dbo.Customers
(
  custid      INT         NOT NULL,
  companyname VARCHAR(25) NOT NULL,
  phone       VARCHAR(20) NOT NULL,
  address     VARCHAR(50) NOT NULL,
  CONSTRAINT PK_Customers PRIMARY KEY(custid)
);

INSERT INTO dbo.Customers(custid, companyname, phone, address)
VALUES
  (1, 'cust 1', '(111) 111-1111', 'address 1'),
  (2, 'cust 2', '(222) 222-2222', 'address 2'),
  (3, 'cust 3', '(333) 333-3333', 'address 3'),
  (4, 'cust 4', '(444) 444-4444', 'address 4'),
  (5, 'cust 5', '(555) 555-5555', 'address 5');

CREATE TABLE dbo.CustomersStage
(
  custid      INT         NOT NULL,
  companyname VARCHAR(25) NOT NULL,
  phone       VARCHAR(20) NOT NULL,
  address     VARCHAR(50) NOT NULL,
  CONSTRAINT PK_CustomersStage PRIMARY KEY(custid)
);

INSERT INTO dbo.CustomersStage(custid, companyname, phone, address)
VALUES
  (2, 'AAAAA', '(222) 222-2222', 'address 2'),
  (3, 'cust 3', '(333) 333-3333', 'address 3'),
  (5, 'BBBBB', 'CCCCC', 'DDDDD'),
  (6, 'cust 6 (new)', '(666) 666-6666', 'address 6'),
  (7, 'cust 7 (new)', '(777) 777-7777', 'address 7');

SELECT * FROM dbo.Customers;
SELECT * FROM dbo.CustomersStage;

/*
    Suppose you need to merge the contents of the CustomersStage 
    table (the source) into the Customers table (the target). 
*/

MERGE INTO dbo.Customers AS TGT
USING dbo.CustomersStage AS SRC
  ON TGT.custid = SRC.custid
WHEN MATCHED THEN
  UPDATE SET
    TGT.companyname = SRC.companyname,
    TGT.phone = SRC.phone,
    TGT.address = SRC.address
WHEN NOT MATCHED THEN
  INSERT (custid, companyname, phone, address)
  VALUES (SRC.custid, SRC.companyname, SRC.phone, SRC.address);

/* 
    The MERGE statement supports adding a predicate to the 
    different action clauses by using the AND option; 
*/

MERGE dbo.Customers AS TGT
USING dbo.CustomersStage AS SRC
  ON TGT.custid = SRC.custid
WHEN MATCHED AND
       (    TGT.companyname <> SRC.companyname
        OR  TGT.phone       <> SRC.phone
        OR  TGT.address     <> SRC.address) THEN
  UPDATE SET
    TGT.companyname = SRC.companyname,
    TGT.phone = SRC.phone,
    TGT.address = SRC.address
WHEN NOT MATCHED THEN
  INSERT (custid, companyname, phone, address)
  VALUES (SRC.custid, SRC.companyname, SRC.phone, SRC.address);


-------------------------------------------------------------------------------
-- Updating with TOP, OFFSET FETCH
-------------------------------------------------------------------------------
DROP TABLE IF EXISTS dbo.OrderDetails, dbo.Orders;

CREATE TABLE dbo.Orders
(
  orderid        INT          NOT NULL,
  custid         INT          NULL,
  empid          INT          NOT NULL,
  orderdate      DATE         NOT NULL,
  requireddate   DATE         NOT NULL,
  shippeddate    DATE         NULL,
  shipperid      INT          NOT NULL,
  freight        MONEY        NOT NULL
    CONSTRAINT DFT_Orders_freight DEFAULT(0),
  shipname       NVARCHAR(40) NOT NULL,
  shipaddress    NVARCHAR(60) NOT NULL,
  shipcity       NVARCHAR(15) NOT NULL,
  shipregion     NVARCHAR(15) NULL,
  shippostalcode NVARCHAR(10) NULL,
  shipcountry    NVARCHAR(15) NOT NULL,
  CONSTRAINT PK_Orders PRIMARY KEY(orderid)
);
GO

INSERT INTO dbo.Orders SELECT * FROM Sales.Orders;

DELETE TOP(10) FROM dbo.Orders;
WITH C AS
(
  SELECT *
  FROM dbo.Orders
  ORDER BY orderid DESC
  OFFSET 0 ROWS FETCH NEXT 50 ROWS ONLY
)
DELETE FROM C;

UPDATE TOP(50) dbo.Orders SET freight += 10.00;
WITH C AS
(
  SELECT *
  FROM dbo.Orders
  ORDER BY orderid DESC
  OFFSET 0 ROWS FETCH NEXT 50 ROWS ONLY
)
UPDATE C
  SET freight += 10.00;

-------------------------------------------------------------------------------
-- OUTPUT for debugging
-------------------------------------------------------------------------------

DROP TABLE IF EXISTS dbo.T1;

CREATE TABLE dbo.T1
(
  keycol  INT          NOT NULL IDENTITY(1, 1) CONSTRAINT PK_T1 PRIMARY KEY,
  datacol NVARCHAR(40) NOT NULL
);

INSERT INTO dbo.T1(datacol)
    OUTPUT inserted.keycol, inserted.datacol
SELECT lastname
FROM HR.Employees
WHERE country = N'USA';

DROP TABLE IF EXISTS dbo.T2;

CREATE TABLE dbo.T2
(
  keycol  INT          NOT NULL IDENTITY(1, 1) CONSTRAINT PK_T2 PRIMARY KEY,
  datacol NVARCHAR(40) NOT NULL
);

INSERT INTO dbo.T2(datacol)
    OUTPUT inserted.keycol, inserted.datacol
SELECT lastname
FROM HR.Employees
WHERE country = N'UK';

SELECT * FROM dbo.T1
SELECT * FROM dbo.T2

MERGE INTO dbo.T1 AS TGT
USING dbo.T2 AS SRC
  ON TGT.keycol = SRC.keycol
WHEN MATCHED THEN
  UPDATE SET
    TGT.datacol = SRC.datacol
WHEN NOT MATCHED THEN
  INSERT (datacol)
  VALUES (SRC.datacol)
OUTPUT $action AS theaction, 
    inserted.keycol,
    deleted.datacol AS old,
    inserted.datacol AS new;

-- Auditing

IF OBJECT_ID('[dbo].[Products]', 'U') IS NOT NULL
DROP TABLE [dbo].[Products]
GO

CREATE TABLE [dbo].[Products]
(
    [ProductId] INT NOT NULL PRIMARY KEY,
    [UnitPrice] INT NOT NULL,
    [SupplierId] INT NOT NULL
);
GO

INSERT INTO dbo.Products SELECT productid, unitprice, supplierid FROM Production.Products

IF OBJECT_ID('[dbo].[ProductsAudit]', 'U') IS NOT NULL
DROP TABLE [dbo].[ProductsAudit]
GO

CREATE TABLE [dbo].[ProductsAudit]
(
    [ProductId] INT NOT NULL,
    [ColName] VARCHAR(100),
    [OldVal] INT,
    [NewVal] INT,
);
GO

INSERT INTO dbo.ProductsAudit(productid, colname, oldval, newval)
  SELECT productid, N'unitprice', oldval, newval
  FROM (UPDATE dbo.Products
          SET unitprice *= 1.15
        OUTPUT
          inserted.productid,
          deleted.unitprice AS oldval,
          inserted.unitprice AS newval
        WHERE supplierid = 1) AS D
  WHERE oldval < 20.0 AND newval >= 20.0;

SELECT * FROM dbo.ProductsAudit

-------------------------------------------------------------------------------
-- Window function
-------------------------------------------------------------------------------

SELECT empid, ordermonth, val,
  SUM(val) OVER(PARTITION BY empid
                ORDER BY ordermonth ROWS BETWEEN 10 AND 1 ROW) AS runval)
FROM Sales.EmpOrders;


-----
-- Metadata
-----
SELECT SCHEMA_NAME(schema_id) AS table_schema_name, name AS table_name
FROM sys.tables;

SELECT
  name AS column_name,
  TYPE_NAME(system_type_id) AS column_type,
  max_length,
  collation_name,
  is_nullable
FROM sys.columns
WHERE object_id = OBJECT_ID(N'Sales.Orders');

SELECT OBJECT_NAME(object_id) FROM sys.objects WHERE object_id = OBJECT_ID(N'Sales.Orders');

DROP TABLE IF EXISTS #tables

CREATE TABLE #tables (
    TABLE_QUALIFIER VARCHAR(128),
    TABLE_OWNER VARCHAR(128),
    TABLE_NAME VARCHAR(128),
    TABLE_TYPE VARCHAR(128),
    REMARKS VARCHAR(128)
);

EXEC sys.sp_help
  @objname = N'Sales.Orders';

EXEC sys.sp_columns
  @table_name = N'Orders',
  @table_owner = N'Sales';

INSERT INTO #tables EXEC sp_tables;
SELECT * FROM #tables;
DROP TABLE IF EXISTS #tables;

EXEC sys.sp_help
  @objname = N'Sales.Orders';

EXEC sys.sp_helpconstraint
  @objname = N'dbo.Employee';


EXPLAIN SELECT * FROM dbo.Employee;


DROP TABLE IF EXISTS dbo.Employees

CREATE TABLE dbo.Employees
(
  empid      INT                         NOT NULL
    CONSTRAINT PK_Employees PRIMARY KEY NONCLUSTERED,
  empname    VARCHAR(25)                 NOT NULL,
  department VARCHAR(50)                 NOT NULL,
  salary     NUMERIC(10, 2)              NOT NULL,
  sysstart   DATETIME2(0)
    GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
  sysend     DATETIME2(0)
    GENERATED ALWAYS AS ROW END   HIDDEN NOT NULL,
  PERIOD FOR SYSTEM_TIME (sysstart, sysend),
  INDEX ix_Employees CLUSTERED(empid, sysstart, sysend)
)
WITH (SYSTEM_VERSIONING = ON ( HISTORY_TABLE = dbo.EmployeesHistory ));


INSERT INTO dbo.Employees(empid, empname, department, salary)
  VALUES(1, 'Sara', 'IT'       , 50000.00),
        (2, 'Don' , 'HR'       , 45000.00),
        (3, 'Judy', 'Sales'    , 55000.00),
        (4, 'Yael', 'Marketing', 55000.00),
        (5, 'Sven', 'IT'       , 45000.00),
        (6, 'Paul', 'Sales'    , 40000.00);

SELECT * FROM dbo.Employees;

SELECT empid, empname, department, salary, sysstart, sysend
FROM dbo.Employees;

SELECT empid, empname, department, salary, sysstart, sysend
FROM dbo.EmployeesHistory;

DELETE FROM dbo.Employees
WHERE empid = 6;

UPDATE dbo.Employees
  SET salary *= 1.05
WHERE department = 'IT';


BEGIN TRAN;

UPDATE dbo.Employees
  SET department = 'Sales'
WHERE empid = 5;

UPDATE dbo.Employees
  SET department = 'IT'
WHERE empid = 3;

COMMIT TRAN;
