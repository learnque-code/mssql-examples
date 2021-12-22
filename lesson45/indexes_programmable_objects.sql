-------------------------------------------------------------------------------
-- Indexes
-------------------------------------------------------------------------------

IF OBJECT_ID('[dbo].[TableName]', 'U') IS NOT NULL
DROP TABLE [dbo].[TableName]
GO

CREATE TABLE [dbo].[Friends]
(
    [Id] INT NOT NULL IDENTITY PRIMARY KEY,
    [Name] NVARCHAR(50) NOT NULL,
    [City] NVARCHAR(50) NOT NULL
);
GO

INSERT INTO [dbo].[Friends]
(
 [Name], [City]
)
VALUES
(
    N'Matt', N'San Francisco'
),
(
    N'Dave', N'Oakland'
),
(
    N'Andrew', N'Blacksburg'
),
(
    N'Todd', N'Chicago'
),
(
    N'Blake', N'Atlanta'
),
(
    N'Evan', N'Detroit'
),
(
    N'Nick', N'New Yourk City'
),
(
    N'Zack', N'Seattle'
)
GO

SELECT * FROM [INFORMATION_SCHEMA].[TABLE_CONSTRAINTS] WHERE [TABLE_NAME] = 'Friends';
GO

CREATE INDEX [index1] ON [dbo].[Friends](Name);
GO

DROP INDEX IF EXISTS [index1] ON [dbo].[Friends];
GO

-------------------------------------------------------------------------------
-- Variables
-------------------------------------------------------------------------------
DECLARE @i AS INT;
SET @i = 10;
GO

DECLARE @empname AS Table;

SET @empname = (SELECT firstname + N' ' + lastname
                FROM HR.Employees
                WHERE empid = 3);

SELECT @empname AS empname;

-- Multiple variable

DECLARE @firstname AS NVARCHAR(20), @lastname AS NVARCHAR(40);

SET @firstname = (SELECT firstname
                  FROM HR.Employees
                  WHERE empid = 3);
SET @lastname = (SELECT lastname
                 FROM HR.Employees
                 WHERE empid = 3);

SELECT @firstname AS firstname, @lastname AS lastname;

DECLARE @FirstNameTable AS TABLE(
    [FirstName] VARCHAR(128)
)
INSERT INTO @FirstNameTable SELECT [FirstName] FROM HR.Employees;
SELECT * FROM @FirstNameTable;

DECLARE @firstname AS NVARCHAR(20), @lastname AS NVARCHAR(40);
SELECT
  @firstname = firstname,
  @lastname  = lastname
FROM HR.Employees
WHERE empid = 3;
SELECT @firstname AS firstname, @lastname AS lastname;

---

-- If more than one record is returned the last one row is used for assignments

DECLARE @empname AS NVARCHAR(61);

SELECT firstname, lastname FROM HR.Employees WHERE mgrid = 2;

SELECT @empname = firstname + N' ' + lastname
FROM HR.Employees
WHERE mgrid = 2;

SELECT @empname AS empname;

/*
The SET statement is safer than the assignment SELECT because it 
requires you to use a scalar subquery to pull data from a table. 
Remember that a scalar subquery fails at run time if it returns 
more than one value. For example, the following code fails:
*/

-- Will throw an exception!!!
DECLARE @empname AS NVARCHAR(61);

SET @empname = (SELECT firstname + N' ' + lastname
                FROM HR.Employees
                WHERE mgrid = 2);

SELECT @empname AS empname;

-------------------------------------------------------------------------------
-- BATCH
-------------------------------------------------------------------------------

PRINT 'First batch';
USE lessons;
GO
-- Invalid batch
PRINT 'Second batch';
SELECT custid FROM Sales.Customers;
SELECT orderid FOM Sales.Orders;
GO
-- Valid batch
PRINT 'Third batch';
SELECT empid FROM HR.Employees;

-------------------------------------------------------------------------------
-- Batches and variables
-------------------------------------------------------------------------------

DECLARE @i AS INT;
SET @i = 10;
-- Succeeds
PRINT @i;
GO

-- Fails
PRINT @i;

-------------------------------------------------------------------------------
-- Statements that cannot be combined in the same batch
-------------------------------------------------------------------------------

-- Will fail

DROP VIEW IF EXISTS Sales.MyView;

CREATE VIEW Sales.MyView
AS

SELECT YEAR(orderdate) AS orderyear, COUNT(*) AS numorders
FROM Sales.Orders
GROUP BY YEAR(orderdate);
GO

-------------------------------------------------------------------------------
-- A batch as a unit of resolution
-------------------------------------------------------------------------------

-- Fail
DROP TABLE IF EXISTS dbo.T1;
CREATE TABLE dbo.T1(col1 INT);

ALTER TABLE dbo.T1 ADD col2 INT;
SELECT col1, col2 FROM dbo.T1;

-- Success
DROP TABLE IF EXISTS dbo.T1;
CREATE TABLE dbo.T1(col1 INT);
ALTER TABLE dbo.T1 ADD col2 INT;
GO
SELECT col1, col2 FROM dbo.T1;

-------------------------------------------------------------------------------
-- The GO n
-------------------------------------------------------------------------------

DROP TABLE IF EXISTS dbo.T1;
CREATE TABLE dbo.T1(col1 INT IDENTITY);
GO

INSERT INTO dbo.T1 DEFAULT VALUES;
GO 100

SELECT * FROM dbo.T1;

-------------------------------------------------------------------------------
-- IF ... ELSE ...
-------------------------------------------------------------------------------

IF YEAR(SYSDATETIME()) <> YEAR(DATEADD(day, 1, SYSDATETIME()))
  PRINT 'Today is the last day of the year.';
ELSE
  PRINT 'Today is not the last day of the year.';

IF YEAR(SYSDATETIME()) <> YEAR(DATEADD(day, 1, SYSDATETIME()))
  PRINT 'Today is the last day of the year.';
ELSE
  IF MONTH(SYSDATETIME()) <> MONTH(DATEADD(day, 1, SYSDATETIME()))
    PRINT 'Today is the last day of the month but not the last day of the year.';
  ELSE
    PRINT 'Today is not the last day of the month.';

-------------------------------------------------------------------------------
-- BEGIN END
-------------------------------------------------------------------------------

IF DAY(SYSDATETIME()) = 1
BEGIN
  PRINT 'Today is the first day of the month.';
  PRINT 'Starting first-of-month-day process.';
  /* ... process code goes here ... */
  PRINT 'Finished first-of-month-day database process.';
END;
ELSE
BEGIN
  PRINT 'Today is not the first day of the month.';
  PRINT 'Starting non-first-of-month-day process.';
  /* ... process code goes here ... */
  PRINT 'Finished non-first-of-month-day process.';
END;