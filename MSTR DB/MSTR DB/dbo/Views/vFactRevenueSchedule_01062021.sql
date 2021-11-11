







CREATE VIEW [dbo].[vFactRevenueSchedule_01062021]
AS

SELECT [NZ_CreateDateID] AS RS_LoadDateID
      ,[NZ_CreateDate] AS RS_LoadDate
      ,[ID]
      --,[IO_Line_Item]
      ,A.OpportunityID
      ,A.OpportunityLineID
      
      --,[ProductID]
      --,[StartDate] AS EstimatedRevenueDate 
      --,CAST(CONVERT(VARCHAR(8),CAST([StartDate] AS DATE),112) AS BIGINT) AS EstimatedRevenueDateID
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
      --,[ActualRevenue]
      --,[TotalRevenue]
      --,[RevWeekSID]
      --,[WeightedEstimatedRevenue]
      --,[EstimatedRevenueStatus]
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
  FROM [SalesReporting].[dbo].[FactRevenueSchedule] A WITH (NOLOCK) 
  WHERE NZ_CreateDateID >= 20190101
	AND StartDateMonth >= '2019-01-01'
	AND ([PIPE_REV] > 0 OR [GROSS_PIPE_REV] > 0 OR [BOOKED_REV] > 0) 






