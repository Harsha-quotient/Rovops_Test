
CREATE VIEW [dbo].[vDimOpportunityLine_WriteBack]
AS

with cte as 
(
SELECT [OpportunityID]
      ,[OpportunityLineID]
      ,[Notes]
      ,[LastUpdatedDate]
      , ROW_NUMBER() OVER (PARTITION BY   [OpportunityID]
      ,[OpportunityLineID] ORDER BY [LastUpdatedDate] DESC ) AS RN_DATE   FROM [MSTRReportingDB].[dbo].[DimOpportunityLine_WriteBack]
      )
SELECT * FROM CTE      


