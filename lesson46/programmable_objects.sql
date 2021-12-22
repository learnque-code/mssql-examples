-------------------------------------------------------------------------------
-- WHILE LOOP
-------------------------------------------------------------------------------

DECLARE @i AS INT = 1;
WHILE @i <= 10
BEGIN
  PRINT @i;
  SET @i = @i + 1;
END;

DECLARE @i AS INT = 1;
WHILE @i <= 10
BEGIN
  IF @i = 6 BREAK;
  PRINT @i;
  SET @i = @i + 1;
END;

DECLARE @i AS INT = 0;
WHILE @i < 10
BEGIN
  SET @i = @i + 1;
  IF @i = 6 CONTINUE;
  PRINT @i;
END;

-------------------------------------------------------------------------------

SET NOCOUNT ON;
DROP TABLE IF EXISTS dbo.Numbers;
CREATE TABLE dbo.Numbers(n INT NOT NULL PRIMARY KEY);
GO

DECLARE @i AS INT = 1;
WHILE @i <= 1000
BEGIN
  INSERT INTO dbo.Numbers(n) VALUES(@i);
  SET @i = @i + 1;
END;
GO

SELECT * FROM dbo.Numbers

---

SET NOCOUNT ON;

DECLARE @Counter int
SET @Counter = 1
WHILE @Counter < 4
    BEGIN
        PRINT ''
        PRINT 'Category '
            + CONVERT(varchar(10), @Counter) + ':'
        SELECT [ProductName], [CategoryId], [UnitPrice]
        FROM [Production].[Products]
        WHERE [CategoryId] = @Counter
        SET @Counter = @Counter + 1
    END

-------------------------------------------------------------------------------
-- Temporary table
-------------------------------------------------------------------------------

DECLARE @TmpTableAsVariable AS TABLE
(
  custid     INT,
  ordermonth DATE,
  qty        INT
);

INSERT INTO @TmpTableAsVariable SELECT custid, ordermonth, qty
  FROM Sales.CustOrders;

SELECT * FROM @TmpTableAsVariable;

DROP TABLE IF EXISTS #MyOrderTotalsByYear;
GO

CREATE TABLE #MyOrderTotalsByYear
(
  orderyear INT NOT NULL PRIMARY KEY,
  qty       INT NOT NULL
);

INSERT INTO #MyOrderTotalsByYear(orderyear, qty)
  SELECT
    YEAR(O.orderdate) AS orderyear,
    SUM(OD.qty) AS qty
  FROM Sales.Orders AS O
    INNER JOIN Sales.OrderDetails AS OD
      ON OD.orderid = O.orderid
  GROUP BY YEAR(orderdate);

SELECT Cur.orderyear, Cur.qty AS curyearqty, Prv.qty AS prvyearqty
FROM #MyOrderTotalsByYear AS Cur
  LEFT OUTER JOIN #MyOrderTotalsByYear AS Prv
    ON Cur.orderyear = Prv.orderyear + 1;


-- Table type
DROP TYPE IF EXISTS dbo.OrderTotalsByYear;

CREATE TYPE dbo.OrderTotalsByYear AS TABLE
(
  orderyear INT NOT NULL PRIMARY KEY,
  qty       INT NOT NULL
);

DECLARE @MyOrderTotalsByYear AS dbo.OrderTotalsByYear;

-------------------------------------------------------------------------------
-- Cursor
-------------------------------------------------------------------------------

SET NOCOUNT ON;

DECLARE @Result AS TABLE
(
  custid     INT,
  ordermonth DATE,
  qty        INT,
  runqty     INT,
  PRIMARY KEY(custid, ordermonth)
);

DECLARE
  @custid     AS INT,
  @prvcustid  AS INT,
  @ordermonth AS DATE,
  @qty        AS INT,
  @runqty     AS INT;

DECLARE C CURSOR FAST_FORWARD /* read only, forward only */ FOR
  SELECT custid, ordermonth, qty
  FROM Sales.CustOrders
  ORDER BY custid, ordermonth;

OPEN C;

FETCH NEXT FROM C INTO @custid, @ordermonth, @qty;

SELECT @prvcustid = @custid, @runqty = 0;

WHILE @@FETCH_STATUS = 0
BEGIN
  IF @custid <> @prvcustid
    SELECT @prvcustid = @custid, @runqty = 0;

  SET @runqty = @runqty + @qty;

  INSERT INTO @Result VALUES(@custid, @ordermonth, @qty, @runqty);

  FETCH NEXT FROM C INTO @custid, @ordermonth, @qty;
END;

CLOSE C;
DEALLOCATE C;

SELECT
  custid,
  CONVERT(VARCHAR(7), ordermonth, 121) AS ordermonth,
  qty,
  runqty
FROM @Result
ORDER BY custid, ordermonth;

-------------------------------------------------------------------------------
-- Dynamic SQL
-------------------------------------------------------------------------------

DECLARE @sql AS NVARCHAR(100);

SET @sql = N'SELECT orderid, custid, empid, orderdate
FROM Sales.Orders
WHERE orderid = @orderid;';

EXEC sp_executesql
  @stmt = @sql,
  @params = N'@orderid AS INT',
  @orderid = 10248;

GO

SELECT * FROM (
    SELECT shipperid, YEAR(orderdate) AS orderyear, freight
        FROM Sales.Orders) AS D 
        WHERE D.orderyear IN(2014, 2015, 2016);

SELECT DISTINCT(YEAR(orderdate)) AS orderyear
    FROM Sales.Orders ORDER BY orderyear;

DECLARE
  @sql       AS NVARCHAR(1000),
  @orderyear AS INT,
  @first     AS INT;

DECLARE C CURSOR FAST_FORWARD FOR
  SELECT DISTINCT(YEAR(orderdate)) AS orderyear
  FROM Sales.Orders
  ORDER BY orderyear;

SET @first = 1;

SET @sql = N'SELECT *
FROM (SELECT shipperid, YEAR(orderdate) AS orderyear, freight
      FROM Sales.Orders) AS D WHERE orderyear IN(';

OPEN C;

FETCH NEXT FROM C INTO @orderyear;

WHILE @@fetch_status = 0
BEGIN
  IF @first = 0
    SET @sql += N','
  ELSE
    SET @first = 0;

  SET @sql += CAST(@orderyear AS VARCHAR(4));

  FETCH NEXT FROM C INTO @orderyear;
END;

CLOSE C;

DEALLOCATE C;

SET @sql += N');';

PRINT @sql;

EXEC sp_executesql @stmt = @sql;
GO

-------------------------------------------------------------------------------
-- User defined functions
-------------------------------------------------------------------------------

SELECT RAND();

DROP FUNCTION IF EXISTS dbo.GetAge;
GO

-- https://stackoverflow.com/questions/57599/how-to-calculate-age-in-t-sql-with-years-months-and-days

CREATE FUNCTION dbo.GetAge
(
  @birthdate AS DATE,
  @eventdate AS DATE
)
RETURNS INT
AS
BEGIN
  RETURN
    DATEDIFF(year, @birthdate, @eventdate) - 
    CASE 
        WHEN 100 * MONTH(@eventdate) + DAY(@eventdate) < 100 * MONTH(@birthdate) + DAY(@birthdate) THEN 1 
        ELSE 0
    END;
END;
GO

SELECT dbo.GetAge('1986-03-05', '2015-12-01')


SELECT
  empid, firstname, lastname, birthdate,
  dbo.GetAge(birthdate, SYSDATETIME()) AS age
FROM HR.Employees;

-------------------------------------------------------------------------------
-- Stored procedures
-------------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS spCalculateOutput;
GO

CREATE PROCEDURE spCalculateOutput
    @Value1 float,
    @Value2 float,
    @Operator char(10),
    @Result float Output
AS
    IF @Operator = 'Add'
        SET @Result = @Value1 + @Value2
    ELSE IF @Operator = 'Subtract'
        SET @Result = @Value1 - @Value2
    ELSE IF @Operator = 'Multiply'
        SET @Result = @Value1 * @Value2
    ELSE IF @Operator = 'Divide'
        SET @Result = @Value1 / @Value2;
GO

Declare @Out float;

Execute spCalculateOutput 123, 456, 'Add', @Result = @Out Output

Print @Out

DROP PROCEDURE IF EXISTS spCalculateOutput;
GO

CREATE PROCEDURE spCalculateReturn
  @Value1 float,
  @Value2 float,
  @Operator char(10)
AS
    Declare @Result float
    IF @Operator = 'Add'
        SET @Result = @Value1 + @Value2
    ELSE IF @Operator = 'Subtract'
        SET @Result = @Value1 - @Value2
    ELSE IF @Operator = 'Multiply'
        SET @Result = @Value1 * @Value2
    ELSE IF @Operator = 'Divide'
        SET @Result = @Value1 / @Value2
    RETURN @Result;
GO

Declare @Out AS float
EXEC @Out = spCalculateReturn 123, 456, 'Add'
Print @Out

DROP PROC IF EXISTS Sales.GetCustomerOrders;
GO

CREATE PROC Sales.GetCustomerOrders
  @custid   AS INT,
  @fromdate AS DATETIME = '19000101',
  @todate   AS DATETIME = '99991231',
  @numrows  AS INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT orderid, custid, empid, orderdate
    FROM Sales.Orders
    WHERE custid = @custid
    AND orderdate >= @fromdate
    AND orderdate < @todate;

    SET @numrows = @@rowcount;
END
GO

DECLARE @rc AS INT;

EXEC Sales.GetCustomerOrders
  @custid   = 1,
  @fromdate = '20150101',
  @todate   = '20160101',
  @numrows  = @rc OUTPUT;

SELECT @rc AS numrows;

-------------------------------------------------------------------------------
-- Triggers
-------------------------------------------------------------------------------

DROP TABLE IF EXISTS dbo.T1_Audit, dbo.T1;
GO

CREATE TABLE dbo.T1
(
    keycol  INT         NOT NULL PRIMARY KEY,
    datacol VARCHAR(10) NOT NULL
);

CREATE TABLE dbo.T1_Audit
(
    audit_lsn  INT          NOT NULL IDENTITY PRIMARY KEY,
    dt         DATETIME2(3) NOT NULL DEFAULT(SYSDATETIME()),
    login_name sysname      NOT NULL DEFAULT(ORIGINAL_LOGIN()),
    keycol     INT          NOT NULL,
    datacol    VARCHAR(10)  NOT NULL
);
GO

DROP TRIGGER IF EXISTS trg_T1_insert_audit;

CREATE TRIGGER trg_T1_insert_audit ON dbo.T1 AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;


    INSERT INTO dbo.T1_Audit(keycol, datacol)
    SELECT keycol, datacol FROM inserted;
END
GO

INSERT INTO dbo.T1(keycol, datacol) VALUES(10, 'a');
INSERT INTO dbo.T1(keycol, datacol) VALUES(30, 'x');
INSERT INTO dbo.T1(keycol, datacol) VALUES(20, 'g');

SELECT * FROM [dbo].[T1_Audit]

GO

-------------------------------------------------------------------------------
-- DDL Trigger
-------------------------------------------------------------------------------
DROP TABLE IF EXISTS dbo.AuditDDLEvents;

CREATE TABLE dbo.AuditDDLEvents
(
    audit_lsn        INT          NOT NULL IDENTITY,
    posttime         DATETIME2(3) NOT NULL,
    eventtype        sysname      NOT NULL,
    loginname        sysname      NOT NULL,
    schemaname       sysname      NOT NULL,
    objectname       sysname      NOT NULL,
    targetobjectname sysname      NULL,
    eventdata        XML          NOT NULL,
    CONSTRAINT PK_AuditDDLEvents PRIMARY KEY(audit_lsn)
);
GO

CREATE TRIGGER trg_audit_ddl_events
  ON DATABASE FOR DDL_DATABASE_LEVEL_EVENTS
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @eventdata AS XML = eventdata();

    INSERT INTO dbo.AuditDDLEvents(
        posttime, eventtype, loginname, schemaname,
        objectname, targetobjectname, eventdata
    )
    VALUES(
        @eventdata.value('(/EVENT_INSTANCE/PostTime)[1]',         'VARCHAR(23)'),
        @eventdata.value('(/EVENT_INSTANCE/EventType)[1]',        'sysname'),
        @eventdata.value('(/EVENT_INSTANCE/LoginName)[1]',        'sysname'),
        @eventdata.value('(/EVENT_INSTANCE/SchemaName)[1]',       'sysname'),
        @eventdata.value('(/EVENT_INSTANCE/ObjectName)[1]',       'sysname'),
        @eventdata.value('(/EVENT_INSTANCE/TargetObjectName)[1]', 'sysname'),
        @eventdata);
END
GO


DROP TABLE IF EXISTS dbo.T1
CREATE TABLE dbo.T1(col1 INT NOT NULL PRIMARY KEY);
ALTER TABLE dbo.T1 ADD col2 INT NULL;
ALTER TABLE dbo.T1 ALTER COLUMN col2 INT NOT NULL;
CREATE NONCLUSTERED INDEX idx1 ON dbo.T1(col2);

SELECT * FROM dbo.AuditDDLEvents;

DROP TRIGGER IF EXISTS trg_audit_ddl_events ON DATABASE;
DROP TABLE IF EXISTS dbo.AuditDDLEvents;

-------------------------------------------------------------------------------
-- Error handling
-------------------------------------------------------------------------------

BEGIN TRY
  PRINT 10/2;
  PRINT 'No error';
END TRY
BEGIN CATCH
  PRINT 'Error';
END CATCH;

BEGIN TRY
  PRINT 10/0;
  PRINT 'No error';
END TRY
BEGIN CATCH
  PRINT 'Error';
END CATCH;


SELECT * FROM [sys].[messages]
GO

---

DROP TABLE IF EXISTS dbo.Employees;

CREATE TABLE dbo.Employees
(
  empid   INT         NOT NULL,
  empname VARCHAR(25) NOT NULL,
  mgrid   INT         NULL,
  CONSTRAINT PK_Employees PRIMARY KEY(empid),
  CONSTRAINT CHK_Employees_empid CHECK(empid > 0),
  CONSTRAINT FK_Employees_Employees
    FOREIGN KEY(mgrid) REFERENCES dbo.Employees(empid)
);

BEGIN TRY

  INSERT INTO dbo.Employees(empid, empname, mgrid)
    VALUES(1, 'Emp1', NULL);
  -- Also try with empid = 0, 'A', NULL

END TRY
BEGIN CATCH

  IF ERROR_NUMBER() = 2627
  BEGIN
    PRINT '    Handling PK violation...';
  END;
  ELSE IF ERROR_NUMBER() = 547
  BEGIN
    PRINT '    Handling CHECK/FK constraint violation...';
  END;
  ELSE IF ERROR_NUMBER() = 515
  BEGIN
    PRINT '    Handling NULL violation...';
  END;
  ELSE IF ERROR_NUMBER() = 245
  BEGIN
    PRINT '    Handling conversion error...';
  END;
  ELSE
  BEGIN
    PRINT 'Re-throwing error...';
    THROW;
  END;

  PRINT '    Error Number  : ' + CAST(ERROR_NUMBER() AS VARCHAR(10));
  PRINT '    Error Message : ' + ERROR_MESSAGE();
  PRINT '    Error Severity: ' + CAST(ERROR_SEVERITY() AS VARCHAR(10));
  PRINT '    Error State   : ' + CAST(ERROR_STATE() AS VARCHAR(10));
  PRINT '    Error Line    : ' + CAST(ERROR_LINE() AS VARCHAR(10));
  PRINT '    Error Proc    : ' + COALESCE(ERROR_PROCEDURE(), 'Not within proc');

END CATCH;

DROP PROC IF EXISTS dbo.ErrInsertHandler;
GO

CREATE PROC dbo.ErrInsertHandler
AS
BEGIN
SET NOCOUNT ON;

IF ERROR_NUMBER() = 2627
    BEGIN
    PRINT 'Handling PK violation...';
    END;
ELSE IF ERROR_NUMBER() = 547
    BEGIN
    PRINT 'Handling CHECK/FK constraint violation...';
    END;
ELSE IF ERROR_NUMBER() = 515
    BEGIN
    PRINT 'Handling NULL violation...';
    END;
ELSE IF ERROR_NUMBER() = 245
    BEGIN
    PRINT 'Handling conversion error...';
    END;

    PRINT 'Error Number  : ' + CAST(ERROR_NUMBER() AS VARCHAR(10));
    PRINT 'Error Message : ' + ERROR_MESSAGE();
    PRINT 'Error Severity: ' + CAST(ERROR_SEVERITY() AS VARCHAR(10));
    PRINT 'Error State   : ' + CAST(ERROR_STATE() AS VARCHAR(10));
    PRINT 'Error Line    : ' + CAST(ERROR_LINE() AS VARCHAR(10));
    PRINT 'Error Proc    : ' + COALESCE(ERROR_PROCEDURE(), 'Not within proc');
END
GO

BEGIN TRY

  INSERT INTO dbo.Employees(empid, empname, mgrid)
    VALUES(1, 'Emp1', NULL);

END TRY
BEGIN CATCH

  IF ERROR_NUMBER() IN (2627, 547, 515, 245)
    EXEC dbo.ErrInsertHandler;
  ELSE
    THROW;

END CATCH;

RAISERROR (15600,-1,-1, 'mysp_CreateCustomer');

THROW 15600, 'mysp_CreateCustomer', 1;


