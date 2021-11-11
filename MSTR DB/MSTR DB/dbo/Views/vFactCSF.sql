


CREATE VIEW [dbo].[vFactCSF]
AS
SELECT Month_ID,Opportunity,OpportunityLine,OpportunityID,OpportunityLineID,
Revenue,LoadDateID , case  when LEFT([LoadDateID],6) <[Month_ID] then '0' else Revenue end as IncrementalRevenue FROM MSTRReportingDB.dbo.FactCSFDaily WITH (NOLOCK)


