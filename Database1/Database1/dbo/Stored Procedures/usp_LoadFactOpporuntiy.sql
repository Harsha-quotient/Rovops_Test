


CREATE PROCEDURE [dbo].[usp_LoadFactOpporuntiy]

AS

BEGIN


	
	
IF OBJECT_ID('MSTRReportingDB.dbo.FactOpportunity', 'U') IS NOT NULL 
	DROP TABLE MSTRReportingDB.dbo.FactOpportunity	


SELECT * INTO MSTRReportingDB.dbo.FactOpportunity FROM (
SELECT OpportunityID
      ,OpportunityLineID
      ,Closed_rev/3 as Closed_rev
      ,Latest_Rev/3 as Latest_Rev
      ,CASE WHEN qtr =  '2021-01' THEN '01-01-2021'
            WHEN qtr =  '2021-02' THEN '04-01-2021'
            WHEN qtr =  '2021-03' THEN '07-01-2021'
            WHEN qtr =  '2021-04' THEN '10-01-2021' END [OpportunityDate]
            ,qtr
            ,LoadDate
            ,CAST(CONVERT(VARCHAR(8),CAST(LoadDate AS DATE),112) AS BIGINT) AS LoadDateID
             FROM  MSTRReportingDB.dbo.OpportunityMaster 
      UNION ALL

SELECT OpportunityID
      ,OpportunityLineID
      ,Closed_rev/3 as Closed_rev
      ,Latest_Rev/3 as Latest_Rev
       ,CASE WHEN qtr =  '2021-01' THEN '02-01-2021'
             WHEN qtr =  '2021-02' THEN '05-01-2021'
             WHEN qtr =  '2021-03' THEN '08-01-2021'
             WHEN qtr =  '2021-04' THEN '11-01-2021' END [OpportunityDate]
             ,qtr
             ,LoadDate
            ,CAST(CONVERT(VARCHAR(8),CAST(LoadDate AS DATE),112) AS BIGINT) AS LoadDateID
              FROM  MSTRReportingDB.dbo.OpportunityMaster 
             
        UNION ALL

SELECT OpportunityID
      ,OpportunityLineID
      ,Closed_rev/3 as Closed_rev
      ,Latest_Rev/3 as Latest_Rev
       ,CASE WHEN qtr =  '2021-01' THEN '03-01-2021'
             WHEN qtr =  '2021-02' THEN '06-01-2021'
             WHEN qtr =  '2021-03' THEN '09-01-2021'
             WHEN qtr =  '2021-04' THEN '12-01-2021' END [OpportunityDate]
             ,qtr
             ,LoadDate
            ,CAST(CONVERT(VARCHAR(8),CAST(LoadDate AS DATE),112) AS BIGINT) AS LoadDateID
              FROM  MSTRReportingDB.dbo.OpportunityMaster 
      

) a

END


