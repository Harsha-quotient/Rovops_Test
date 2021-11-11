



















CREATE VIEW [dbo].[vMLOTT]
AS
 SELECT   QTR,
        A.IONumber,
        A.LineNbr,
       -- QTR_MLOTT_RN,
       -- TOTAL_MLOTT_RN,
        A.QTR_MLOTT,
        TOTAL_MLOTT,
        LoadDate,
        CAST(CONVERT(VARCHAR(8),CAST(LoadDate AS DATE),112) AS BIGINT) AS MLOTT_LoadDateID,
        --20210531 AS MLOTT_LoadDateID,
        TotalActivity,
        PrintsRemaining,
        --CouponID,
        --PrintRunLimit,
        --ActiveDate,
        --Shutoff,
        --Expiry,
        Dayslive,
        MLOTT_Type,
        LineType, 
        b.OpportunityID,
        b.OpportunityLineID,
        A.TOP_FLAG
        --CASE WHEN T.IONumber IS NOT NULL THEN 1 ELSE 0 END AS TOP_50_COMPLETED_FLAG,
        --CASE WHEN T1.IONumber IS NOT NULL THEN 1 ELSE 0 END AS TOP_50_ACTIVE_FLAG 
       --- CouponID
        --RN
        ,WB.MLOTT_Activity
        ,WB.Notes
   
FROM  SalesReporting.dbo.SSRS_MLOTTReport_CID_Data	 A
 INNER JOIN SalesReporting.dbo.DimOpportunityLine B
 ON REPLACE(A.IONumber,'SF','Q') = B.Opportunity
 AND A.LineNbr=B.OpportunityLine
 LEFT OUTER JOIN   dbo.vMLOTT_WriteBack WB  
  ON B.Opportunityid = WB.Opportunityid AND B.OpportunityLineID=WB.OpportunityLineID 
  AND CAST(CONVERT(VARCHAR(8),CAST(LoadDate AS DATE),112) AS BIGINT) = WB.Mlott_lOADDATEID
-- LEFT JOIN  (SELECT  DISTINCT TOP   50 IONumber ,LineNbr ,QTR_MLOTT
--					FROM SalesReporting.dbo.SSRS_MLOTTReport_CID_Data WITH (NOLOCK)
--					WHERE LoadDate = (SELECT  dbo.udf_returnMonday())
--					--WHERE LoadDate = '2021-05-17'
--						AND CAST(DATEPART(YEAR,CAST(GETDATE() AS DATE)) AS VARCHAR(4)) + '-Q' + CAST(DATEPART(QUARTER,CAST(GETDATE() AS DATE)) AS VARCHAR(2)) = QTR
--						AND ISNULL([PromoRegion],'') NOT IN ('Ecom')
--						AND LineType = 'Completed Lines'
--						AND RN = 1
					
--					ORDER BY QTR_MLOTT DESC, IONumber ,LineNbr) T 
--					ON A.IONumber = t.IONumber AND A.LineNbr = t.LineNbr
					
--LEFT JOIN (SELECT TOP 50 IONumber ,LineNbr ,QTR_MLOTT
--					FROM SalesReporting.dbo.SSRS_MLOTTReport_CID_Data A WITH (NOLOCK)
--					WHERE LoadDate =(SELECT  dbo.udf_returnMonday())
--						--WHERE LoadDate = '2021-05-17'
--					    AND CAST([Shutoff] AS DATE)> CAST(GETDATE() AS DATE)
--						AND ISNULL([PromoRegion],'') NOT IN ('Ecom')
--						AND LineType = 'Active, Slow-Pacing Lines'
--						AND RN = 1
--					ORDER BY QTR_MLOTT DESC, IONumber ,LineNbr) T1
--				ON A.IONumber = T1.IONumber AND A.LineNbr = T1.LineNbr					
    WHERE LoadDate =(SELECT  dbo.udf_returnMonday()) --3628 
    --WHERE LoadDate = '2021-05-31'
    and RN=1
	















