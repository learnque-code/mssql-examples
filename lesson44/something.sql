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


CREATE TABLE dbo.Departments
(
  deptid    INT                          NOT NULL
    CONSTRAINT PK_Departments PRIMARY KEY,
  deptname  VARCHAR(25)                  NOT NULL,
  mgrid INT                              NOT NULL,
  validfrom DATETIME2(0)
    GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
  validto   DATETIME2(0)
    GENERATED ALWAYS AS ROW END   HIDDEN NOT NULL,
  PERIOD FOR SYSTEM_TIME (validfrom, validto)
)
WITH ( SYSTEM_VERSIONING = ON ( HISTORY_TABLE = dbo.DepartmentsHistory ) );

INSERT INTO dbo.Departments(deptid, deptname, mgrid)
  VALUES(1, 'HR'       , 7 ),
        (2, 'IT'       , 5 ),
        (3, 'Sales'    , 11),
        (4, 'marketing', 13);

SELECT * FROM dbo.DepartmentsHistory

