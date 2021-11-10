














CREATE VIEW [dbo].[vMLOTT_WriteBack]
AS


WITH CTE AS 
(
SELECT A.[OpportunityID]
      ,A.[OpportunityLineID]
      ,[Notes]
      ,0 as Revenue
      --,B.MLOTT_LoadDateID AS MLOTT_LoadDateID
      ,CAST(CONVERT(VARCHAR(8),CAST(DATEADD(wk, DATEDIFF(wk,0,GETDATE()), 0) AS DATE),112) AS BIGINT) AS MLOTT_LoadDateID
      --,20210531 AS MLOTT_LoadDateID
      ,[LastUpdatedDate]
      ,'' as [Actively_Working]
      ,'' as [Will_Not_Mitigate]
      ,'' as [Not_MLOTT]
      ,'' as [Closely Monitoring]
      ,MLOTT_Activity
      ,ROW_NUMBER() OVER (PARTITION BY   A.[OpportunityID],A.OpportunityLineID ORDER BY [LastUpdatedDate] DESC ) AS RN_DATE   
FROM [dbo].[MLOTT_WriteBack] A 
      )
SELECT [OpportunityID]
      ,[OpportunityLineID]
      ,ISNULL([Notes],' ') AS [Notes]
      ,0 as Revenue
      ,MLOTT_LoadDateID
      ,[LastUpdatedDate]
      ,[Actively_Working]
      ,[Will_Not_Mitigate]
      ,[Not_MLOTT]
      ,[Closely Monitoring]
      ,MLOTT_Activity
      ,RN_DATE    
FROM CTE  where RN_DATE=1   


--WITH CTE AS 
--(
--SELECT A.[OpportunityID]
--      ,A.[OpportunityLineID]
--      ,[Notes]
--      ,Revenue
--      ,B.MLOTT_LoadDateID AS MLOTT_LoadDateID
--      ,[LastUpdatedDate]
--      ,[Actively_Working]
--      ,[Will_Not_Mitigate]
--      ,[Not_MLOTT]
--      ,[Closely Monitoring]
--      ,MLOTT_Activity
--      , ROW_NUMBER() OVER (PARTITION BY   A.[OpportunityID],A.OpportunityLineID ORDER BY [LastUpdatedDate] DESC ) AS RN_DATE   
--FROM [dbo].[MLOTT_WriteBack] A 
--	   JOIN (SELECT [OpportunityID],OpportunityLineID, MAX(MLOTT_LoadDateID) AS MLOTT_LoadDateID FROM [dbo].[vMLOTT] GROUP BY [OpportunityID],OpportunityLineID ) B 
--	    ON A.[OpportunityID]=B.[OpportunityID] AND A.[OpportunityLineID]=B.[OpportunityLineID]
--      )
--SELECT * FROM CTE  where RN_DATE=1   













