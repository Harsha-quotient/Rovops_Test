


CREATE VIEW [dbo].[vAtRisk_03182021]
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
 FROM  SalesReporting.dbo.SSRS_AtRisk_Report_Data A
 LEFT JOIN SalesReporting.dbo.DimOpportunityLine B
 ON REPLACE(A.IONumber,'SF','Q') = B.Opportunity
 AND A.LineNbr=B.OpportunityLine


