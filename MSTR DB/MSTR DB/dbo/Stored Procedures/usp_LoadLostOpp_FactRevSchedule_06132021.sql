



CREATE PROCEDURE [dbo].[usp_LoadLostOpp_FactRevSchedule_06132021]

AS

BEGIN

IF OBJECT_ID('tempdb..#TMP') IS NOT NULL
			DROP TABLE #TMP	
SELECT [Opportunity]
      --,OpportunityID
      ,[OP_Stage]
      ,[OPH_CurrentStage_Date]
INTO #TMP
FROM [SalesReporting].[dbo].[DimOpportunity]
WHERE CreateDate >= '2021-01-01'
	AND ISNULL(OP_Stage,'') IN ('Closed Lost','IO Canceled')
	

IF OBJECT_ID('tempdb..#TMP_Result') IS NOT NULL
			DROP TABLE #TMP_Result	
SELECT CAST(CONVERT(VARCHAR(8),CAST(GETDATE() AS DATE),112) AS BIGINT) AS LostRS_LoadDateID
      ,CAST(GETDATE() AS DATE) AS LostRS_LoadDate
      ,[ID]
      ,OPL.OpportunityID AS OpportunityID
      ,OPL.OpportunityLineID AS OpportunityLineID
      ,[StartDateID] AS EstimatedRevenueDateID
      --,[Qtr]
      --,[StartDateMonth]
      --,[EndDate]
      ,[ActualQuantity]
      --,[CreatedDate]
      --,[LastModifiedDate]
      ,[DailyAverageActivity]
      ,[DailyExpectedActivity]
      ,[TotalEstimatedRevenue]
      ,[ForecastQuantity]
      ,[ForecastToDate]
      --,[IsDeleted]
      --,[RS_Name]
      --,[SalesPrice]
      ,[ScheduledQuantity]
      --,[RS_Status]
      ,[UnRealizedDaysLeft]
      ,[UnRealizedMonthlyActivityRemaining]
      ,[Low_PIPE_REV]
      ,[High_PIPE_REV]
      ,[Verbal_PIPE_REV]
      ,[PIPE_REV] 
      ,[Low_GROSS_PIPE_REV] 
      ,[High_GROSS_PIPE_REV] 
      ,[Verbal_GROSS_PIPE_REV] 
      ,[GROSS_PIPE_REV] 
      ,[BOOKED_REV_FD] 
      ,[BOOKED_REV_CMP] 
      ,[BOOKED_REV_DEV] 
      ,[BOOKED_REV] INTO #TMP_Result 
FROM SalesReporting.dbo.FactRevenueSchedule RS
	INNER JOIN #TMP T
		ON RS.Opportunity = T.Opportunity
			AND RS.NZ_CreateDate = DATEADD(DAY,-1,T.OPH_CurrentStage_Date)
	INNER JOIN SalesReporting.dbo.DimOpportunityLine OPL WITH (NOLOCK)
		ON RS.Opportunity = OPL.Opportunity
			AND RS.OpportunityLine = OPL.OpportunityLine		
WHERE NZ_CreateDate >= '2021-01-01'


DELETE D
		--SELECT *
		FROM  dbo.LostOppFactRevSchedule    D
		WHERE LostRS_LoadDate = (SELECT DISTINCT LostRS_LoadDate FROM #TMP_Result)	


INSERT INTO dbo.LostOppFactRevSchedule  
SELECT * FROM  #TMP_Result 


END


