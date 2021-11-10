



CREATE VIEW [dbo].[vFactRevenueSchedule]
AS

SELECT [NZ_CreateDateID] AS RS_LoadDateID
      ,[NZ_CreateDate] AS RS_LoadDate
      ,[ID]
      --,[IO_Line_Item]
      ,OPL.OpportunityID AS OpportunityID
      ,OPL.OpportunityLineID AS OpportunityLineID
      --,ISNULL(OPL.OpportunityID,A.OpportunityID) AS OpportunityID
      --,ISNULL(OPL.OpportunityLineID,A.OpportunityLineID) AS OpportunityLineID
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
	INNER JOIN SalesReporting.dbo.DimOpportunityLine OPL WITH (NOLOCK)
		ON A.Opportunity = OPL.Opportunity
			AND A.OpportunityLine = OPL.OpportunityLine
  WHERE 
	--NZ_CreateDateID >= 20190101 AND StartDateMonth >= '2019-01-01' --Commented by VV on 01/06
	NZ_CreateDateID >= 20200101 AND StartDateMonth >= '2020-01-01'
    AND ([BOOKED_REV]>0 OR [PIPE_REV]>0 OR  [GROSS_PIPE_REV]>0) 









