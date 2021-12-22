-- Solution 1
-- Drop a table called 'Employees' in schema 'dbo'
-- Drop the table if it already exists
IF OBJECT_ID('[dbo].[Employees]', 'U') IS NOT NULL
DROP TABLE [dbo].[Employees]
GO

-- Create a new table called '[Employees]' in schema '[dbo]'
-- Create the table in the specified schema
CREATE TABLE [dbo].[Employees]
(
    [EmployeeId] INT NOT NULL,
    [FirstName] NVARCHAR(50) NOT NULL,
    [LastName] NVARCHAR(50) NOT NULL,
    [DateOfBirth] Date NOT NULL,
    [PostalAddress] NVARCHAR(50)
);
GO

-- Add a new column '[PhoneNumber]' to table '[Employees]' in schema '[dbo]'
ALTER TABLE [dbo].[Employees]
    ADD [PhoneNumber]  NVARCHAR(50)
GO

-- Add a new column '[Email]' to table '[Employees]' in schema '[dbo]'
ALTER TABLE [dbo].[Employees]
    ADD [Email]  NVARCHAR(50)
GO

-- Add a new column '[Salary]' to table '[Employees]' in schema '[dbo]'
ALTER TABLE [dbo].[Employees]
    ADD [Salary] NVARCHAR(50)
GO

-- Drop '[PostalAddress]' from table '[Employees]' in schema '[dbo]'
ALTER TABLE [dbo].[Employees]
    DROP COLUMN [PostalAddress]
GO

-- Create a new table called '[EmployeeAddresses]' in schema '[dbo]'
-- Drop the table if it already exists
IF OBJECT_ID('[dbo].[EmployeeAddresses]', 'U') IS NOT NULL
DROP TABLE [dbo].[EmployeeAddresses]
GO
-- Create the table in the specified schema
CREATE TABLE [dbo].[EmployeeAddresses]
(
    [Country] NVARCHAR(50) NOT NULL,
);
GO

-- Solution 2

-- Drop a table called 'Employees' in schema 'dbo'
-- Drop the table if it already exists
IF OBJECT_ID('[dbo].[Employees]', 'U') IS NOT NULL
DROP TABLE [dbo].[Employees]
GO

-- Create a new table called '[Employees]' in schema '[dbo]'
-- Create the table in the specified schema
CREATE TABLE [dbo].[Employees]
(
    [EmployeeId] INT NOT NULL,
    [FirstName] NVARCHAR(50) NOT NULL,
    [LastName] NVARCHAR(50) NOT NULL,
    [DateOfBirth] Date NOT NULL,
    [PostalAddress] NVARCHAR(50)
);
GO

-- Add a new column '[PhoneNumber]' to table '[Employees]' in schema '[dbo]'
ALTER TABLE [dbo].[Employees]
    ADD [PhoneNumber]  NVARCHAR(50)
GO

-- Add a new column '[Email]' to table '[Employees]' in schema '[dbo]'
ALTER TABLE [dbo].[Employees]
    ADD [Email]  NVARCHAR(50)
GO

-- Add a new column '[Salary]' to table '[Employees]' in schema '[dbo]'
ALTER TABLE [dbo].[Employees]
    ADD [Salary] NVARCHAR(50)
GO

-- Drop '[PostalAddress]' from table '[Employees]' in schema '[dbo]'
ALTER TABLE [dbo].[Employees]
    DROP COLUMN [PostalAddress]
GO

-- Insert rows into table 'Employees' in schema '[dbo]'
INSERT INTO [dbo].[Employees]
( -- Columns to insert data into
 [EmployeeId], [FirstName], [LastName], [DateOfBirth], [PhoneNumber], [Email], [Salary]
)
VALUES
( -- First row: values for the columns in the list above
 1, N'John', N'Johnson', '1975-01-01', '0-800-800-314', 'john@johnson.com', 1000
)
-- Add more rows here
GO

-- Update rows in table '[Employees]' in schema '[dbo]'
UPDATE [dbo].[Employees]
SET
    [DateOfBirth] = '1980-01-01'
WHERE [EmployeeId] = 1
GO

-- Delete rows from table '[Employees]' in schema '[dbo]'
DELETE FROM [dbo].[Employees]
GO
-- Or
TRUNCATE TABLE [dbo].[Employees]

-- Insert rows into table 'Employees' in schema '[dbo]'
INSERT INTO [dbo].[Employees]
( -- Columns to insert data into
 [EmployeeId], [FirstName], [LastName], [DateOfBirth], [PhoneNumber], [Email], [Salary]
)
VALUES
( -- First row: values for the columns in the list above
 1, N'John', N'Johnson', '1975-01-01', '0-800-800-314', 'john@johnson.com', 1000
),
( -- First row: values for the columns in the list above
 2, N'James', N'Jameson', '1985-02-02', '0-800-800-999', 'james@jameson.com', 2000
)
-- Add more rows here
GO

-- Solution 3
-- Drop a table called 'Employees' in schema 'dbo'
-- Drop the table if it already exists
IF OBJECT_ID('[dbo].[Employees]', 'U') IS NOT NULL
DROP TABLE [dbo].[Employees]
GO

-- Create a new table called '[Employees]' in schema '[dbo]'
-- Create the table in the specified schema
CREATE TABLE [dbo].[Employees]
(
    [EmployeeId] INT NOT NULL, -- Primary Key column
    [FirstName] NVARCHAR(50) NOT NULL,
    [LastName] NVARCHAR(50) NOT NULL,
    [DateOfBirth] Date NOT NULL,
    [PostalAddress] NVARCHAR(50)
);
GO

-- Add a new column '[PhoneNumber]' to table '[Employees]' in schema '[dbo]'
ALTER TABLE [dbo].[Employees]
    ADD [PhoneNumber]  NVARCHAR(50)
GO

-- Add a new column '[Email]' to table '[Employees]' in schema '[dbo]'
ALTER TABLE [dbo].[Employees]
    ADD [Email]  NVARCHAR(50)
GO

-- Add a new column '[Salary]' to table '[Employees]' in schema '[dbo]'
ALTER TABLE [dbo].[Employees]
    ADD [Salary] NVARCHAR(50)
GO

-- Drop '[PostalAddress]' from table '[Employees]' in schema '[dbo]'
ALTER TABLE [dbo].[Employees]
    DROP COLUMN [PostalAddress]
GO

-- Insert rows into table 'Employees' in schema '[dbo]'
INSERT INTO [dbo].[Employees]
( -- Columns to insert data into
 [EmployeeId], [FirstName], [LastName], [DateOfBirth], [PhoneNumber], [Email], [Salary]
)
VALUES
( -- First row: values for the columns in the list above
 1, N'John', N'Johnson', '1975-01-01', '0-800-800-314', 'john@johnson.com', 1000
)
-- Add more rows here
GO

-- Update rows in table '[Employees]' in schema '[dbo]'
UPDATE [dbo].[Employees]
SET
    [DateOfBirth] = '1980-01-01'
WHERE [EmployeeId] = 1
GO

-- Delete rows from table '[Employees]' in schema '[dbo]'
DELETE FROM [dbo].[Employees]
GO
-- Or
TRUNCATE TABLE [dbo].[Employees]

-- Insert rows into table 'Employees' in schema '[dbo]'
INSERT INTO [dbo].[Employees]
( -- Columns to insert data into
 [EmployeeId], [FirstName], [LastName], [DateOfBirth], [PhoneNumber], [Email], [Salary]
)
VALUES
( -- First row: values for the columns in the list above
 1, N'John', N'Johnson', '1975-01-01', '0-800-800-314', 'john@johnson.com', 1000
),
( -- First row: values for the columns in the list above
 2, N'James', N'Jameson', '1985-02-02', '0-800-800-999', 'james@jameson.com', 2000
)
-- Add more rows here
GO

ALTER TABLE [dbo].[Employees] 
DROP COLUMN [EmployeeId];

ALTER TABLE [dbo].[Employees] 
ADD [EmployeeId] INT IDENTITY NOT NULL;

ALTER TABLE [dbo].[Employees]
ADD CONSTRAINT PK_EmployeeId PRIMARY KEY(EmployeeId);
GO

-- Insert rows into table 'Employees' in schema '[dbo]'
INSERT INTO [dbo].[Employees]
( -- Columns to insert data into
    [FirstName], [LastName], [DateOfBirth], [PhoneNumber], [Email], [Salary]
)
VALUES
( -- First row: values for the columns in the list above
    N'John', N'Johnson', '1975-01-01', '0-800-800-314', 'john@johnson.com', 1000
),
( -- First row: values for the columns in the list above
    N'James', N'Jameson', '1985-02-02', '0-800-800-999', 'james@jameson.com', 2000
)
-- Add more rows here
GO

-- Create a new table called '[Departments]' in schema '[dbo]'
-- Drop the table if it already exists
IF OBJECT_ID('[dbo].[Departments]', 'U') IS NOT NULL
DROP TABLE [dbo].[Departments]
GO
-- Create the table in the specified schema
CREATE TABLE [dbo].[Departments]
(
    [DepartmentId] INT IDENTITY NOT NULL PRIMARY KEY, -- Primary Key column
    [Name] NVARCHAR(50) NOT NULL,
    -- Specify more columns here
);
GO

-- Insert rows into table 'Departments' in schema '[dbo]'
INSERT INTO [dbo].[Departments]
( -- Columns to insert data into
    [Name]
)
VALUES
( -- First row: values for the columns in the list above
    N'HR'
),
( -- Second row: values for the columns in the list above
    N'Finance'
)
-- Add more rows here
GO

-- Add a new column '[NewColumnName]' to table '[TableName]' in schema '[dbo]'
ALTER TABLE [dbo].[Employees]
    ADD [DepartmentId] INT NULL
GO
-- Update rows in table '[Employees]' in schema '[dbo]'
UPDATE [dbo].[Employees]
SET
    [DepartmentId] = 1
WHERE [EmployeeId] = 1
GO

-- Update rows in table '[Employees]' in schema '[dbo]'
UPDATE [dbo].[Employees]
SET
    [DepartmentId] = 2
WHERE [EmployeeId] = 2
GO

-- Delete rows from table '[TableName]' in schema '[dbo]'
DELETE FROM [dbo].[Departments]
WHERE [DepartmentId] = 1
GO

UPDATE [dbo].[Employees]
SET
    [DepartmentId] = 2
WHERE [EmployeeId] = 1
GO

ALTER TABLE [dbo].[Employees] 
ADD CONSTRAINT [FK_Employees_DepartmentId] FOREIGN KEY(DepartmentId) REFERENCES [dbo].[Departments](DepartmentId)

-- Solution 4
ALTER TABLE [dbo].[Employees]
    ADD [ManagerId] INT REFERENCES [dbo].[Employees]([EmployeeId])
GO

-- Insert rows into table 'Employees' in schema '[dbo]'
INSERT INTO [dbo].[Employees]
(
    [FirstName], [LastName], [DateOfBirth], [PhoneNumber], [Email], [Salary]
)
VALUES
(
    N'Sophie', N'Shopie', '1975-01-01', '0-800-800-314', 'sophie@sophie.com', 1000
)
GO

-- Update rows in table '[Employees]' in schema '[dbo]'
UPDATE [dbo].[Employees]
SET
    [ManagerId] = 3
WHERE [EmployeeId] IN (1, 2)
GO

-- Create a new table called '[Projects]' in schema '[dbo]'
-- Drop the table if it already exists
IF OBJECT_ID('[dbo].[Projects]', 'U') IS NOT NULL
DROP TABLE [dbo].[Projects]
GO
-- Create the table in the specified schema
CREATE TABLE [dbo].[Projects]
(
    [ProjectId] INT IDENTITY NOT NULL PRIMARY KEY,
    [Description] NVARCHAR(50) NOT NULL,
);
GO

IF OBJECT_ID('[dbo].[EmployeeProject]', 'U') IS NOT NULL
DROP TABLE [dbo].[EmployeeProject]
GO

CREATE TABLE [dbo].[EmployeeProject]
(
    [EmployeeProjectId]     INT IDENTITY NOT NULL PRIMARY KEY,
    [EmployeeId]            INT REFERENCES [dbo].[Employees]([EmployeeId]),
    [ProjectId]             INT  REFERENCES [dbo].[Projects]([ProjectId])
);
GO

-- Insert rows into table '' in schema '[dbo]'
INSERT INTO [dbo].[Projects]
(
    [Description]
)
VALUES
(
    N'Python - Cinema Web App'
),
(
    N'Java - Fitness Web App'
)
GO

-- Insert rows into table 'EmployeeProject' in schema '[dbo]'
INSERT INTO [dbo].[EmployeeProject]
( 
    [EmployeeId], [ProjectId]
)
VALUES
(
    1, 2 -- you can write a select for getting value.
),
(
    2, 1 -- you can write a select for getting value.
),
-- Something like that
/*
(
    (SELECT [EmployeeId] FROM [dbo].[Employees] WHERE [LastName] = 'Sophie'), 'Project manager'),
    (SELECT [ProjectId] FROM [dbo].[Projects] WHERE [Description] = 'Python - Cinema Web App')
)
*/
GO