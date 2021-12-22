-- Solution 1
-- a
DROP FUNCTION IF EXISTS dbo.GetNumbersRange;
GO

CREATE FUNCTION [dbo].[GetNumbersRange]
(
  @start AS INT = 1,
  @end AS INT = 1
)
RETURNS @Result TABLE(
    [Number] INT
)
AS
BEGIN
    DECLARE @newstart AS INT;
    DECLARE @newend AS INT;
    
    IF @start > @end 
        SELECT @newstart = @end, @newend = @start;
    ELSE
        SELECT @newstart = @start, @newend = @end;
    
    WITH F AS
    (
        SELECT @newstart i UNION ALL
        SELECT i+1 i FROM F WHERE i < @newend
    )
    INSERT INTO @Result([Number]) SELECT i AS [Number] FROM F
    RETURN
END
GO

SELECT * FROM dbo.GetNumbersRange(1, 5);

-- b

DROP PROCEDURE IF EXISTS dbo.NumbersRangeProc
GO
CREATE PROCEDURE dbo.NumbersRangeProc
    @start INT = 1, 
    @end INT = 1
AS
BEGIN
    DECLARE @newstart AS INT;
    DECLARE @newend AS INT;
    
    IF @start > @end 
        SELECT @newstart = @end, @newend = @start;
    ELSE
        SELECT @newstart = @start, @newend = @end;

    WITH F AS
    (
        SELECT @newstart i UNION ALL
        SELECT i+1 i FROM F WHERE i < @newend
    )
    SELECT i AS [Number] FROM F;
END
GO

DECLARE @Values AS TABLE([Number] INT);
INSERT @Values EXEC dbo.NumbersRangeProc 1, 5;
SELECT * FROM  @Values;
