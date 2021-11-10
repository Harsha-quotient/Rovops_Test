



CREATE VIEW [dbo].[vFactOpportunity] AS


SELECT *,CAST(CONVERT(VARCHAR(8),CAST(OpportunityDate AS DATE),112) AS BIGINT) AS OpportunityDate_ID 
FROM MSTRReportingDB.dbo.FactOpportunity 

--SELECT OpportunityID
--      ,OpportunityLineID
--      ,Closed_rev as Closed_rev
--      ,Latest_Rev as Latest_Rev
--      ,QTR
--      ,LoadDate
--      ,CAST(CONVERT(VARCHAR(8),CAST(LoadDate AS DATE),112) AS BIGINT) AS OpportunityDate_ID
--      FROM MSTRReportingDB.dbo.OpportunityMaster 

