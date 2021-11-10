








CREATE VIEW [dbo].[vAtRisk_WriteBack]
AS




with cte as 
(
SELECT A.[OpportunityID]
      ,[Notes]
      --, B.AtRisk_LoadDateID AS AtRisk_LoadDateID
      --, DATEADD(wk, DATEDIFF(wk,0,GETDATE()), 0)
     , CAST(CONVERT(VARCHAR(8),CAST(DATEADD(wk, DATEDIFF(wk,0,GETDATE()), 0) AS DATE),112) AS BIGINT) AS AtRisk_LoadDateID
      
      ,[LastUpdatedDate]
      , ROW_NUMBER() OVER (PARTITION BY   A.[OpportunityID] ORDER BY [LastUpdatedDate] DESC ) AS RN_DATE   FROM [dbo].[AtRisk_WriteBack] A 
	   --JOIN (SELECT [OpportunityID], MAX(AtRisk_LoadDateID) AS AtRisk_LoadDateID FROM [dbo].[vAtRisk] GROUP BY [OpportunityID] ) B
	   --  ON A.[OpportunityID]=B.[OpportunityID]
      )
SELECT * FROM CTE  where RN_DATE=1 





--with cte as 
--(
--SELECT A.[OpportunityID]
--      ,[Notes]
--      , B.AtRisk_LoadDateID AS AtRisk_LoadDateID
--      ,[LastUpdatedDate]
--      , ROW_NUMBER() OVER (PARTITION BY   A.[OpportunityID] ORDER BY [LastUpdatedDate] DESC ) AS RN_DATE   FROM [dbo].[AtRisk_WriteBack] A 
--	   JOIN (SELECT [OpportunityID], MAX(AtRisk_LoadDateID) AS AtRisk_LoadDateID FROM [dbo].[vAtRisk] GROUP BY [OpportunityID] ) B  ON A.[OpportunityID]=B.[OpportunityID]
--      )
--SELECT * FROM CTE  where RN_DATE=1   








