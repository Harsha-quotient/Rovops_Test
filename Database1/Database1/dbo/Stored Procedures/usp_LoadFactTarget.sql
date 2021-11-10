


CREATE PROCEDURE [dbo].[usp_LoadFactTarget] 
AS
BEGIN


TRUNCATE TABLE MSTRReportingDB.dbo.[FactTargets_old]




INSERT INTO MSTRReportingDB.dbo.[FactTargets_old]
SELECT ISNULL([AccountID],'n/a') AS [AccountID],
       ISNUll([DivisionID],'n/a') AS [DivisionID],
       [RetailerID],
       [ProductType_ID],
       Quota,
       --[TargetDate],
       CAST(SUBSTRING(CONVERT(VARCHAR(8),CAST([TARGETDATE] AS DATE),112),1,6) AS BIGINT) AS TargetMonth_ID FROM (
SELECT isnull([AccountID],AccountName) as [AccountID]
      ,[DivisionID]
      --,[AccountName]
      --,[Division]
       ,ISNULL([RetailerID],18) AS [RetailerID]
    --  ,[ProductCategory]
      ,[ProductType_ID]
      --,[YEAR]
      --,[Quarter]
      --,[SD_Revenue]
      ,([SD_Revenue]/3) AS Quota
      ,CASE WHEN Quarter =  '2020-01' THEN '01-01-2020'
                WHEN Quarter =  '2020-02' THEN '04-01-2020'
                WHEN Quarter =  '2020-03' THEN '07-01-2020'
                WHEN Quarter =  '2020-04' THEN '10-01-2020' END [TargetDate]
  FROM SalesDB.[dbo].[v2020_Targets] A LEFT JOIN SalesReporting.dbo.DimProductType B
  ON A.ProductFlag=B.ProductType
  LEFT JOIN SalesReporting.dbo.DimRetailer C ON C.Retailer=a.Retailer
  UNION ALL
  SELECT isnull([AccountID],AccountName) as [AccountID]
      ,[DivisionID]
      --,[AccountName]
      --,[Division]
          ,ISNULL([RetailerID],18) AS [RetailerID]
      --,[ProductCategory]
      ,[ProductType_ID]
      --,[YEAR]
      --,[Quarter]
      --,[SD_Revenue]
      ,([SD_Revenue]/3) AS Quota
      ,CASE WHEN Quarter =  '2020-01' THEN '02-01-2020'
                WHEN Quarter =  '2020-02' THEN '05-01-2020'
                WHEN Quarter =  '2020-03' THEN '08-01-2020'
                WHEN Quarter =  '2020-04' THEN '11-01-2020' END [TargetDate]
  FROM SalesDB.[dbo].[v2020_Targets] A LEFT JOIN SalesReporting.dbo.DimProductType B
  ON A.ProductFlag=B.ProductType
   LEFT JOIN SalesReporting.dbo.DimRetailer C ON C.Retailer=a.Retailer
  UNION ALL
  SELECT isnull([AccountID],AccountName) as [AccountID]
      ,[DivisionID]
      --,[AccountName]
      --,[Division]
          ,ISNULL([RetailerID],18) AS [RetailerID]
      --,[ProductCategory]
      ,[ProductType_ID]
      --,[YEAR]
      --,[Quarter]
      --,[SD_Revenue]
      ,([SD_Revenue]/3) AS Quota
      ,CASE WHEN Quarter =  '2020-01' THEN '03-01-2020'
                WHEN Quarter =  '2020-02' THEN '06-01-2020'
                WHEN Quarter =  '2020-03' THEN '09-01-2020'
                WHEN Quarter =  '2020-04' THEN '12-01-2020' END [TargetDate]
  FROM SalesDB.[dbo].[v2020_Targets] A LEFT JOIN SalesReporting.dbo.DimProductType B
  ON A.ProductFlag=B.ProductType
   LEFT JOIN SalesReporting.dbo.DimRetailer C ON C.Retailer=a.Retailer
  ) A


END


