






CREATE VIEW [dbo].[vLostOppFactRevSchedule ]
AS

SELECT  LostRS_LoadDateID
       , LostRS_LoadDate
      ,[ID]
      , OpportunityID
      , OpportunityLineID
      , EstimatedRevenueDateID
      ,[ActualQuantity]
      ,[DailyAverageActivity]
      ,[DailyExpectedActivity]
      ,[TotalEstimatedRevenue]
      ,[ForecastQuantity]
      ,[ForecastToDate]
      ,[ScheduledQuantity]
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
      ,TOTAL_LOST_REVENUE
  FROM MSTRReportingDB.dbo.LostOppFactRevSchedule












