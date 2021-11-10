


















CREATE PROCEDURE  [dbo].[usp_LoadDimopportunity] AS

BEGIN

TRUNCATE TABLE [MSTRReportingDB].[dbo].[DimOpportunity] 

INSERT INTO [MSTRReportingDB].[dbo].[DimOpportunity] 


SELECT OP.OpportunityID,
       OP.Opportunity,
       OP.[AdvertiserFullName]
      ,OP.[StageName]
      ,OP.[ForecastCategory]
      ,OP.[Probability]
      ,OP.[CommissionInformation]
      ,OP.[OpportunityName]
      ,OP.[CampaignName]
      ,OP.[OP_AccountID]
      ,OP.[OP_Acc_Name]
      ,OP.[OP_Acc_Type]
      ,OP.[OP_DivisionID]
      ,OP.[OP_Division]
      ,OP.[OP_AgencyID]
      ,OP.[OP_Agency_Name]
      ,CAST(OP.[CreateDate] AS DATE) AS [CreateDate]
      ,OP.[CreateDemandFlag]
      ,OP.[LastModifiedDate]
      ,OP.[AtRiskDetails]
      ,OP.[AtRiskStatus]
      ,OP.[DaysAtRisk]
      ,OP.[TimeEnteredAtRisk]
      ,OP.[TimeExitedAtRisk]
      ,OP.[OwnerID]
      ,OP.[OwnerName] 
      ,OP.OPH_FirstCloseDate
      ,CASE WHEN OP.StageName IN ('Closed Lost','IO Canceled') AND OPH_ClosedLostDate IS NOT NULL
			THEN CAST(OP.OPH_ClosedLostDate AS DATE) END AS OPH_ClosedLostDate
      --,OP.OPH_ClosedLostDate
      ,OP.ClosedLost_Reason
      ,OP.OPH_CurrentStage_Date
      ,OP.ForecastCategory_Stage_Date
      ,OP.CSM
      ,OP.DCM
      ,OP.[CreateDate] AS First_Seen_Date
    --,OM.Closed_Date 
      ,CASE WHEN OP.StageName IN ('Closed Won','Closed Won - Historic','IO Creation','IO in Revision') AND OP.OPH_FirstCloseDate IS NOT NULL 
			THEN OP.OPH_FirstCloseDate END AS Closed_Date
			--THEN CAST(ISNULL(OP.OPH_FirstCloseDate,OP.OPH_CurrentStage_Date) AS DATE) END AS Closed_Date
            --THEN CAST(OP.OPH_CurrentStage_Date AS DATE) END AS Closed_Date
     -- ,OM.Last_Seen_Date
     ,OP.OPH_CurrentStage_Date AS Last_Seen_Date
	 ,CASE WHEN OP.StageName IN ('Closed Won','Closed Won - Historic','IO Creation','IO in Revision') AND OP.OPH_FirstCloseDate IS NOT NULL THEN 'Closed Won'
		   WHEN OP.StageName IN ('Closed Lost','IO Canceled') AND OPH_ClosedLostDate IS NOT NULL THEN 'Closed Lost'
           ELSE 'In Pipe' End AS Won_Lost 
   --   ,CASE WHEN OM.Won_Lost = 'Won' THEN 'Closed Won'
			--WHEN OM.Won_Lost = 'Lost' THEN 'Closed Lost'
			--ELSE 'In Pipe' End AS Won_Lost
     -- ,OM.time_to_close
      ,CASE WHEN OP.StageName IN ('Closed Won','Closed Won - Historic','IO Creation','IO in Revision') AND OP.OPH_FirstCloseDate IS NOT NULL 
				THEN DATEDIFF(DD,OP.[CreateDate],OP.OPH_FirstCloseDate) + 1
			WHEN OP.StageName IN ('Closed Lost','IO Canceled') AND OPH_ClosedLostDate IS NOT NULL
				THEN DATEDIFF(DD,OP.[CreateDate],OP.OPH_ClosedLostDate) + 1
			ELSE 0 END 	time_to_close			
     --,DATEDIFF(DD,OP.[CreateDate],CASE WHEN OP.StageName IN ('Closed Won','Closed Won - Historic','IO Creation','IO in Revision')  
     --       THEN  OPH_CurrentStage_Date END) + 1  AS time_to_close
      --,OM.time_to_close 
      --,OM.ClosedP30d
      --,OM.CreatedP30d
      ,CASE WHEN DATEDIFF(dd, CASE WHEN OP.StageName IN ('Closed Won','Closed Won - Historic','IO Creation','IO in Revision')  
            THEN  OPH_CurrentStage_Date END, CAST(GETDATE() AS DATE)) < 30 THEN 1 END AS 'ClosedP30d'
	  ,CASE WHEN DATEDIFF(dd,OP.[CreateDate], CAST(GETDATE() AS DATE)) < 30 THEN 1 END AS 'CreatedP30d'
	  ,WB.Notes
	  ,OP.EarliestLaunchDate 
	  ,CAST(CONVERT(VARCHAR(8),CAST(OP.[CreateDate] AS DATE),112) AS BIGINT) AS CreateDateID
	  ,CASE WHEN OP.StageName IN ('Closed Lost','IO Canceled') 
				THEN CAST(OP.OPH_CurrentStage_Date AS DATE) 
		   WHEN OP.StageName IN ('Closed Won','Closed Won - Historic')--,'IO Creation')  
				THEN CAST(ISNULL(OP.OPH_FirstCloseDate,OP.OPH_CurrentStage_Date) AS DATE) --CAST(OP.OPH_FirstCloseDate AS DATE) 
           ELSE CAST(GETDATE() AS DATE) 
				--CAST([CreateDate] AS DATE) 
           END AS Derived_ActivityDate
      ,CAST(CONVERT(VARCHAR(8),(CASE WHEN OP.StageName IN ('Closed Lost','IO Canceled') 
								THEN CAST(OP.OPH_CurrentStage_Date AS DATE) 
							WHEN OP.StageName IN ('Closed Won','Closed Won - Historic')   
								THEN CAST(ISNULL(OP.OPH_FirstCloseDate,OP.OPH_CurrentStage_Date) AS DATE) --CAST(OP.OPH_FirstCloseDate AS DATE) 
							ELSE CAST(GETDATE() AS DATE) END)
							--ELSE CAST([CreateDate] AS DATE) END)
				,112) AS BIGINT) AS Derived_ActivityDateID				
FROM SalesReporting.dbo.DimOpportunity OP WITH (NOLOCK)
	--LEFT OUTER JOIN (SELECT OpportunityID ,Opportunity ,First_Seen_Date, Closed_Date, Last_Seen_Date, Won_Lost, time_to_close ,ClosedP30d ,CreatedP30d
	--				FROM (
	--					SELECT DISTINCT OpportunityID ,Opportunity ,First_Seen_Date, Closed_Date, Last_Seen_Date, Won_Lost, time_to_close ,ClosedP30d ,CreatedP30d 
	--						,DENSE_RANK() OVER (PARTITION BY Opportunity ORDER BY Opportunity ,First_Seen_Date ,Closed_Date ,Last_Seen_Date) AS Rnk
	--					FROM MSTRReportingDB.dbo.OpportunityMaster WITH (NOLOCK)
	--					--WHERE Opportunity IN ('Q223606','Q228310','Q228698','Q228704','Q228941','Q229399')
	--					) t
	--				WHERE Rnk = 1) OM 
	--	ON OP.OpportunityID = OM.OpportunityID
	LEFT OUTER JOIN vAtRisk_WriteBack WB WITH (NOLOCK)
		ON OP.OpportunityID = WB.OpportunityID

	--Additional logic where IO's set to current activity due do their Stage no Closed Won are set back to their First Closed Won Date.
	IF OBJECT_ID('tempdb..#TMP_DimOpportunity') IS NOT NULL
		DROP TABLE #TMP_DimOpportunity
	SELECT OP.Opportunity
		,OP.CreateDate
		,OP.StageName
		,OP.Won_Lost
		,OP.Derived_ActivityDate
		,OP.OPH_FirstCloseDate
		,OP.OPH_CurrentStage_Date
		,R.BOOKED_REV
		,R.GROSS_PIPE_REV
	INTO #TMP_Opp_List		
	FROM [MSTRReportingDB].[dbo].[DimOpportunity] OP WITH (NOLOCK)	
		LEFT OUTER JOIN (SELECT Opportunity ,SUM([BOOKED_REV]) AS [BOOKED_REV], SUM([GROSS_PIPE_REV]) AS [GROSS_PIPE_REV]
					FROM [SalesReporting].[dbo].[FactRevenueSchedule] A WITH (NOLOCK) 
					WHERE NZ_CreateDateID = (CAST(CONVERT(VARCHAR(8),CAST(GETDATE() AS DATE),112) AS BIGINT))
					GROUP BY Opportunity) R  
			ON OP.Opportunity = R.Opportunity 
	WHERE Derived_ActivityDate = CAST(GETDATE() AS DATE)
		AND Won_Lost = 'Closed Won'
		AND OP.StageName NOT IN ('Closed Won','Closed Won - Historic')
	ORDER BY CreateDate	
	
	UPDATE OP SET 
	--SELECT OP.*,
		Derived_ActivityDate = CAST(ISNULL(OP.OPH_FirstCloseDate,OP.OPH_CurrentStage_Date) AS DATE) --CAST(OP.OPH_FirstCloseDate AS DATE) 
        ,Derived_ActivityDateID = (CAST(CONVERT(VARCHAR(8),CAST(ISNULL(OP.OPH_FirstCloseDate,OP.OPH_CurrentStage_Date) AS DATE),112) AS BIGINT)) 
	FROM #TMP_Opp_List T
		INNER JOIN [MSTRReportingDB].[dbo].[DimOpportunity] OP WITH (NOLOCK)
			ON OP.Opportunity = T.Opportunity
	WHERE ISNULL(GROSS_PIPE_REV,0) = 0 


END

















