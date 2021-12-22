DROP TABLE IF EXISTS dbo.HelloWorld;

CREATE TABLE HelloWorld (
    Id INT IDENTITY,
    Description VARCHAR(1000)
);

-- DML
INSERT INTO HelloWorld (Description) VALUES ('Hello World');
-- DML
INSERT INTO HelloWorld (Description) VALUES ('Hello World 2');

SELECT * FROM dbo.HelloWorld;

DROP TABLE IF EXISTS dbo.Owners;

CREATE TABLE dbo.Owners(
   firstName VARCHAR(25) NOT NULL,
   lastName VARCHAR(25) NOT NULL
);

ALTER TABLE dbo.HelloWorld 
DROP COLUMN Email;

ALTER TABLE dbo.HelloWorld 
ADD Email varchar(255);

ALTER TABLE dbo.HelloWorld 
ALTER COLUMN Email varchar(300);

ALTER TABLE dbo.HelloWorld 
ALTER COLUMN Email INT;

ALTER TABLE dbo.HelloWorld 
ALTER COLUMN Email INT;

ALTER TABLE dbo.HelloWorld 
ALTER COLUMN Description VARCHAR(500);

ALTER TABLE dbo.HelloWorld 
ALTER COLUMN Description INT;

SELECT * FROM [dbo].[HelloWorld]
GO