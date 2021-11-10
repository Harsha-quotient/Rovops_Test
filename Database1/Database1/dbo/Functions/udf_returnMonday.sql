

CREATE FUNCTION [dbo].[udf_returnMonday] (
	
)
RETURNS date AS
BEGIN
	
DECLARE @Date DATETIME 
DECLARE @Monday DATETIME

SET @Date = CAST(GETDATE() AS DATE)

IF DATENAME(dw,@Date) = 'Sunday'
	BEGIN 
		SET @Date = DATEADD(DAY,-1,@Date)
	END 

SET @Monday = DATEADD(wk, DATEDIFF(wk, 6, @Date), 7)

RETURN  cast(@Monday as date)

END;
