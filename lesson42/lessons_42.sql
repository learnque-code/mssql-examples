DROP TABLE IF EXISTS dbo.HelloWorld;

CREATE TABLE HelloWorld (
    ID INT IDENTITY,
    Description VARCHAR(1000)
);

-- DML
INSERT INTO HelloWorld (Description) VALUES ('Hello World');
-- DML
INSERT INTO HelloWorld (Description) VALUES ('Hello World 2');

SELECT * FROM dbo.HelloWorld;

-------------------------------------------------------------------------------

DROP TABLE IF EXISTS dbo.Owners;

CREATE TABLE dbo.Owners(
   firstName VARCHAR(25) NOT NULL,
   lastName VARCHAR(25) NOT NULL
);


-------------------------------------------------------------------------------

ALTER TABLE dbo.HelloWorld 
ADD Email varchar(255);

ALTER TABLE dbo.HelloWorld 
DROP COLUMN Email;

ALTER TABLE dbo.HelloWorld 
ADD Email varchar(255);

ALTER TABLE dbo.HelloWorld 
ALTER COLUMN Email varchar(300);

ALTER TABLE dbo.HelloWorld 
ALTER COLUMN [Description] VARCHAR(100);

ALTER TABLE dbo.HelloWorld 
ALTER COLUMN [Description] INT;

-------------------------------------------------------------------
DROP TABLE IF EXISTS dbo.HelloWorld2; 
CREATE TABLE dbo.HelloWorld2
(
    ID int IDENTITY NOT NULL CONSTRAINT PK_ID PRIMARY KEY(ID)
);

ALTER TABLE dbo.HelloWorld 
ADD CONSTRAINT PK_ID PRIMARY KEY(ID);

-- Delete the primary key constraint.  
ALTER TABLE dbo.HelloWorld2
DROP CONSTRAINT PK_ID;

-- Primary
-- Foreign key

DROP TABLE IF EXISTS [dbo].[Cars];

CREATE TABLE [dbo].[Cars] (
    [Id] INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Car_Id PRIMARY KEY(Id),
    [Type] VARCHAR(50) NOT NULL,
    [Number] VARCHAR(50) NOT NULL
)

DROP TABLE IF EXISTS [dbo].[Trailers]

CREATE TABLE [dbo].[Trailers] (
    [Id] INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Trailer_Id PRIMARY KEY NONCLUSTERED(Id),
    [Number] VARCHAR(50) NOT NULL,
    [CarId] INT -- CONSTRAINT FK_Car_Id FOREIGN KEY REFERENCES [dbo].[Cars](Id) ON DELETE CASCADE
);

ALTER TABLE [dbo].[Trailers] ADD CONSTRAINT [FK_Car_Id] 
FOREIGN KEY(CarId) REFERENCES [dbo].[Cars](Id)

SELECT CONSTRAINT_NAME,
   TABLE_SCHEMA ,
   TABLE_NAME,
   CONSTRAINT_TYPE
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE TABLE_SCHEMA='dbo'

-- Or EXECUTE sp_helpindex employees

INSERT INTO [dbo].[Cars] VALUES('');
---

CREATE TABLE pet_owners (
    [Id] INT NOT NULL IDENTITY,
    [Name] VARCHAR(100),
    PRIMARY KEY([Id])
);

CREATE TABLE pets (
  petId INT NOT NULL IDENTITY,
  race VARCHAR(45) NOT NULL,
  dateOfBirth DATE NOT NULL,
  ownerId INT NOT NULL,
  PRIMARY KEY (petId),
  CONSTRAINT fk_pets_owners
    FOREIGN KEY (ownerId)
    REFERENCES pet_owners (Id));

SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME = 'pets'


DROP TABLE IF EXISTS Parent;
CREATE TABLE Parent (
    Id INT IDENTITY NOT NULL,
    Name VARCHAR(250),
    CONSTRAINT PK_Parent_Id PRIMARY KEY(Id)
);
GO

-------------------------------------------------------------------------------
-- On delete cascade
-------------------------------------------------------------------------------
DROP TABLE IF EXISTS Childs;
DROP TABLE IF EXISTS Parents;
GO

CREATE TABLE Parents (
    Id INT IDENTITY NOT NULL,
    Name VARCHAR(250),
    CONSTRAINT PK_Parent_Id PRIMARY KEY(Id)
);
GO

CREATE TABLE Childs (
    Id INT IDENTITY NOT NULL,
    Name VARCHAR(250),
    ParentId INT,
    CONSTRAINT PK_Childs_Id PRIMARY KEY(Id),
    CONSTRAINT FK_Parents_Id FOREIGN KEY(ParentId) REFERENCES Parents(Id) ON DELETE CASCADE
);
GO

-------------------------------------------------------------------------------
-- Unique constraint
-------------------------------------------------------------------------------

-- Create a new table called '[GrandChild]' in schema '[dbo]'
-- Drop the table if it already exists
IF OBJECT_ID('[dbo].[GrandChild]', 'U') IS NOT NULL
DROP TABLE [dbo].[GrandChild]
GO
-- Create the table in the specified schema
CREATE TABLE [dbo].[GrandChild]
(
    [Id] INT NOT NULL IDENTITY PRIMARY KEY, -- Primary Key column
    [ColumnName2] NVARCHAR(50) NOT NULL,
    [ColumnName3] NVARCHAR(50) NOT NULL,
    CONSTRAINT AK_ColumnName2 UNIQUE(ColumnName2)
    -- Specify more columns here
);
GO
-- Create a new table called '[Person]' in schema '[dbo]'
-- Drop the table if it already exists
IF OBJECT_ID('[dbo].[Person]', 'U') IS NOT NULL
DROP TABLE [dbo].[Person]
GO
-- Create the table in the specified schema
CREATE TABLE [dbo].[Person]
(
    [Id] INT NOT NULL PRIMARY KEY, -- Primary Key column
    [PasswordHash] NVARCHAR(50) NOT NULL,
    [PasswordSalt] NVARCHAR(50) NOT NULL
);
GO

ALTER TABLE Person   
ADD CONSTRAINT AK_Password UNIQUE (PasswordHash, PasswordSalt);
GO

-------------------------------------------------------------------------------
-- Check constraint
-------------------------------------------------------------------------------
-- Create a new table called '[Drinks]' in schema '[dbo]'
-- Drop the table if it already exists
IF OBJECT_ID('[dbo].[Drinks]', 'U') IS NOT NULL
DROP TABLE [dbo].[Drinks]
GO
-- Create the table in the specified schema
CREATE TABLE [dbo].[Drinks]
(
    [Id] INT IDENTITY NOT NULL PRIMARY KEY,
    [Name] INT
);
GO

ALTER TABLE [dbo].[Drinks] 
ADD CONSTRAINT checkName CHECK ([NAME] IN (1, 2, 3));
GO

-------------------------------------------------------------------------------
-- One to one
-------------------------------------------------------------------------------
DROP TABLE IF EXISTS [Salary]
DROP TABLE IF EXISTS [Employee]
CREATE TABLE [Employee] (
    [ID]    INT PRIMARY KEY
,   [Name]  VARCHAR(50)
);
GO

CREATE TABLE [Salary] (
    [EmployeeID]    INT UNIQUE NOT NULL
,   [SalaryAmount]  INT 
);
GO

ALTER TABLE [Salary]
ADD CONSTRAINT FK_Salary_Employee FOREIGN KEY([EmployeeID]) 
    REFERENCES [Employee]([ID]);
GO

INSERT INTO [Employee] (
    [ID]
,   [Name]
)
VALUES
    (1, 'Ram')
,   (2, 'Rahim')
,   (3, 'Pankaj')
,   (4, 'Mohan');

INSERT INTO [Salary] (
    [EmployeeID]
,   [SalaryAmount]
)
VALUES
    (1, 2000)
,   (2, 3000)
,   (3, 2500)
,   (4, 3000);
GO


SELECT [E].[ID], [E].[Name], [S].[SalaryAmount] FROM  [Employee] AS [E] 
LEFT OUTER JOIN [Salary] AS [S] 
    ON [E].[ID] = [S].[EmployeeID];
GO

-------------------------------------------------------------------------------
-- One-To-Many
-------------------------------------------------------------------------------

-- Create a new table called '[Pets]' in schema '[dbo]'
-- Drop the table if it already exists
IF OBJECT_ID('[dbo].[Pets]', 'U') IS NOT NULL
DROP TABLE [dbo].[Pets]
GO

-- Create a new table called '[owners]' in schema '[dbo]'
-- Drop the table if it already exists
IF OBJECT_ID('[dbo].[Owners]', 'U') IS NOT NULL
DROP TABLE [dbo].[Owners]
GO

-- Create the table in the specified schema
CREATE TABLE [dbo].[Owners]
(
    [Id] INT NOT NULL PRIMARY KEY, -- Primary Key column
    [firstName] NVARCHAR(50) NOT NULL,
    [lastName] NVARCHAR(50) NOT NULL
);
GO

-- Create the table in the specified schema
CREATE TABLE [dbo].[Pets]
(
    [Id] INT NOT NULL PRIMARY KEY, -- Primary Key column
    [Race] NVARCHAR(50) NOT NULL,
    [DateOfBirth] DATE NOT NULL DEFAULT GETDATE(),
    [OwnerId] INT REFERENCES [dbo].[Owners](Id)
);
GO

-------------------------------------------------------------------------------
-- Many-To-Many
-------------------------------------------------------------------------------

-------------------------------------------------------------------
-- Create a new table called '[OrderItem]' in schema '[dbo]'
-- Drop the table if it already exists
IF OBJECT_ID('[dbo].[OrderItem]', 'U') IS NOT NULL
DROP TABLE [dbo].[OrderItem]
GO

-- Create a new table called '[Orders]' in schema '[dbo]'
-- Drop the table if it already exists
IF OBJECT_ID('[dbo].[Orders]', 'U') IS NOT NULL
DROP TABLE [dbo].[Orders]
GO
-- Create the table in the specified schema
CREATE TABLE [dbo].[Orders]
(
    [OrderId] INT NOT NULL PRIMARY KEY,
    [Status] NVARCHAR(50) NOT NULL,
    [DeliveryAddress] NVARCHAR(50) NOT NULL
);
GO

-- Create a new table called '[Items]' in schema '[dbo]'
-- Drop the table if it already exists
IF OBJECT_ID('[dbo].[Items]', 'U') IS NOT NULL
DROP TABLE [dbo].[Items]
GO
-- Create the table in the specified schema
CREATE TABLE [dbo].[Items]
(
    [ItemId]        INT NOT NULL PRIMARY KEY, 
    [description]   NVARCHAR(50) NOT NULL,
);
GO

-- Create the table in the specified schema
CREATE TABLE [dbo].[OrderItem]
(
    [orderItemId]   INT NOT NULL PRIMARY KEY,
    [orderId]       INT REFERENCES [dbo].[Orders]([OrderId]),
    [itemId]        INT  REFERENCES [dbo].[Items]([ItemId])
);
GO

-------------------------------------------------------------------------------
-- Self-referencing
-------------------------------------------------------------------------------
-- Create a new table called '[Person]' in schema '[dbo]'
-- Drop the table if it already exists
IF OBJECT_ID('[dbo].[Persons]', 'U') IS NOT NULL
DROP TABLE [dbo].[Persons]
GO
-- Create the table in the specified schema
CREATE TABLE [dbo].[Persons]
(
    [PersonId] INT NOT NULL IDENTITY PRIMARY KEY, -- Primary Key column
    [FirstName] NVARCHAR(50) NOT NULL,
    [LastName] NVARCHAR(50) NOT NULL,
    [FatherId] INT REFERENCES [dbo].[Persons]([PersonId])
    -- Specify more columns here
);
GO

-- Insert rows into table 'Persons' in schema '[dbo]'
INSERT INTO [dbo].[Persons]
( -- Columns to insert data into
 [FirstName], [LastName], [FatherId]
)
VALUES
( -- First row: values for the columns in the list above
    N'Zigmuntas', N'Nareiko', NULL
),
( -- Second row: values for the columns in the list above
    N'Viktor', N'Nareiko', 1
)
GO

SELECT [Father].[FirstName] AS [Father Name], [Child].[FirstName] AS [Child Name] 
FROM [dbo].[Persons] AS [Father]
    LEFT OUTER JOIN [dbo].[Persons] AS [Child] 
    ON [Father].[PersonId] = [Child].[FatherId]
