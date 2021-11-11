


CREATE VIEW [dbo].[vMLOTT_CID]
AS

SELECT  QTR,
        --IONumber,
       -- LineNbr,
       -- QTR_MLOTT_RN,
       -- TOTAL_MLOTT_RN,
        --QTR_MLOTT,
        --TOTAL_MLOTT,
        LoadDate,
        CAST(CONVERT(VARCHAR(8),CAST(LoadDate AS DATE),112) AS BIGINT) AS MLOTT_CID_LoadDateID,
       -- TotalActivity,
       -- PrintsRemaining,
        CouponID,
        PrintRunLimit,
        ActiveDate,
        Shutoff,
        Expiry,
      --    LineType, 
        b.OpportunityID,
        b.OpportunityLineID
        --RN
 FROM  SalesReporting.dbo.SSRS_MLOTTReport_CID_Data	 A
 LEFT JOIN SalesReporting.dbo.DimOpportunityLine B
 ON REPLACE(A.IONumber,'SF','Q') = B.Opportunity
 AND A.LineNbr=B.OpportunityLine
 
 


