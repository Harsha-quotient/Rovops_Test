














CREATE VIEW [dbo].[vDimOpportunity_06132021]
AS


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
      ,OP.[CreateDate]
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
      ,OP.OPH_ClosedLostDate
      ,OP.ClosedLost_Reason
      ,OP.OPH_CurrentStage_Date
      ,OP.ForecastCategory_Stage_Date
      ,OP.CSM
      ,OP.DCM
      ,OP.First_Seen_Date
      ,OP.Closed_Date
      ,OP.Last_Seen_Date
      ,OP.Won_Lost
      ,OP.time_to_close
      ,OP.ClosedP30d
      ,OP.CreatedP30d
	  ,WB.Notes
	  ,EarliestLaunchDate
FROM [MSTRReportingDB].dbo.DimOpportunity OP WITH (NOLOCK)  LEFT OUTER JOIN vAtRisk_WriteBack WB WITH (NOLOCK)
		ON OP.OpportunityID = WB.OpportunityID

