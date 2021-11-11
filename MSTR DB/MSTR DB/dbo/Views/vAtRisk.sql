









CREATE VIEW [dbo].[vAtRisk]
AS

SELECT Qtr,
       IONumber,
       LineNbr,
       FC_Amt,
       LoadDate,
       CAST(CONVERT(VARCHAR(8),CAST(LoadDate AS DATE),112) AS BIGINT) AS AtRisk_LoadDateID,
       Flag_Owner,
       B.OpportunityID,
       B.OpportunityLineID
	  -- A.[OP_EarliestLaunchDate]
 FROM  SalesReporting.dbo.SSRS_AtRisk_Report_Data A WITH (NOLOCK)
	INNER JOIN SalesReporting.dbo.DimOpportunityLine B WITH (NOLOCK)
		ON REPLACE(A.IONumber,'SF','Q') = B.Opportunity AND A.LineNbr=B.OpportunityLine
 WHERE LoadDate = (SELECT  dbo.udf_returnMonday())
	AND Qtr IN ('2020-Q2','2020-Q4','2021-Q1','Fin','2021-Q2','2021-Q3')



