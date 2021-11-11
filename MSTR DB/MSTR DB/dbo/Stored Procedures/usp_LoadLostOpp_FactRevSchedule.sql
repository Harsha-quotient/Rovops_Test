




CREATE PROCEDURE [dbo].[usp_LoadLostOpp_FactRevSchedule]

AS

BEGIN
	
	SET NOCOUNT ON;

	IF OBJECT_ID('tempdb..#TMP_OP') IS NOT NULL
		DROP TABLE #TMP_OP	
	SELECT [Opportunity]
		  --,OpportunityID
		  ,[OP_Stage]
		  ,[OPH_CurrentStage_Date]
	INTO #TMP_OP
	FROM [SalesReporting].[dbo].[DimOpportunity] WITH (NOLOCK)
	WHERE CreateDate >= '2021-01-01'
		AND ISNULL(OP_Stage,'') IN ('Closed Lost','IO Canceled')
	
	IF OBJECT_ID('tempdb..#TMP_RS_LastSeen') IS NOT NULL
		DROP TABLE #TMP_RS_LastSeen	
	SELECT [Opportunity]
		,MAX([NZ_CreateDateID]) AS Last_Seen_Date
	INTO #TMP_RS_LastSeen		
	FROM [SalesReporting].[dbo].FactRevenueSchedule WITH (NOLOCK)
	WHERE Opportunity IN (SELECT Opportunity FROM #TMP_OP)
		AND NZ_CreateDateID >= 20210101
	GROUP BY Opportunity		

	

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
		  ,[BOOKED_REV]
		  ,ISNULL([BOOKED_REV],0)+ ISNULL([GROSS_PIPE_REV],0) AS TOTAL_LOST_REVENUE INTO #TMP_Result 
	FROM SalesReporting.dbo.FactRevenueSchedule RS
		INNER JOIN #TMP_RS_LastSeen T
			ON RS.Opportunity = T.Opportunity
				AND RS.NZ_CreateDateID = T.Last_Seen_Date
		INNER JOIN SalesReporting.dbo.DimOpportunityLine OPL WITH (NOLOCK)
			ON RS.Opportunity = OPL.Opportunity
				AND RS.OpportunityLine = OPL.OpportunityLine		
	WHERE NZ_CreateDate >= '2021-01-01'


	--DELETE D
	----SELECT *
	--FROM  dbo.LostOppFactRevSchedule    D
	--WHERE LostRS_LoadDate = (SELECT DISTINCT LostRS_LoadDate FROM #TMP_Result)	

	TRUNCATE TABLE dbo.LostOppFactRevSchedule  
	INSERT INTO dbo.LostOppFactRevSchedule  
	SELECT * 
	FROM #TMP_Result 


END



