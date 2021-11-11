








CREATE VIEW [dbo].[vFactTargets]
AS


SELECT [AccountID]
	,[DivisionID]
	,[RetailerID]
	,[ProductType_ID]
	,Quota
	,TargetMonth_ID
	,LoadDateID
	,CAST('No' AS VARCHAR(5)) AS [NationallyFunded] --06/06/2021
	,CAST('n/a' AS VARCHAR(5)) AS [BrandID] --06/06/2021
FROM MSTRReportingDB.dbo.[FactTargets_2021] WITH (NOLOCK)
UNION ALL
SELECT [AccountID]
	,[DivisionID]
	,[RetailerID]
	,[ProductType_ID]
	,Quota
	,TargetMonth_ID
	,LoadDateID
	,CAST('No' AS VARCHAR(5)) AS [NationallyFunded] --06/06/2021
	,CAST('n/a' AS VARCHAR(5)) AS [BrandID] --06/06/2021
FROM MSTRReportingDB.dbo.[FactTargets_2020] WITH (NOLOCK)



--SELECT [AccountID],[DivisionID],[RetailerID],[ProductType_ID],Quota,TargetMonth_ID,LoadDateID
--FROM MSTRReportingDB.dbo.[FactTargets] WITH (NOLOCK)

--SELECT ISNULL([AccountID],'n/a') AS [AccountID],
--       ISNUll([DivisionID],'n/a') AS [DivisionID],
--       [RetailerID],
--       [ProductType_ID],
--       Quota,
--       --[TargetDate],
--       CAST(SUBSTRING(CONVERT(VARCHAR(8),CAST([TARGETDATE] AS DATE),112),1,6) AS BIGINT) AS TargetMonth_ID FROM (
--SELECT [AccountID]
--      ,[DivisionID]
--      --,[AccountName]
--      --,[Division]
--       ,ISNULL([RetailerID],18) AS [RetailerID]
--    --  ,[ProductCategory]
--      ,[ProductType_ID]
--      --,[YEAR]
--      --,[Quarter]
--      --,[SD_Revenue]
--      ,([SD_Revenue]/3) AS Quota
--      ,CASE WHEN Quarter =  '2020-01' THEN '01-01-2020'
--                WHEN Quarter =  '2020-02' THEN '04-01-2020'
--                WHEN Quarter =  '2020-03' THEN '07-01-2020'
--                WHEN Quarter =  '2020-04' THEN '10-01-2020' END [TargetDate]
--  FROM SalesDB.[dbo].[v2020_Targets] A LEFT JOIN SalesReporting.dbo.DimProductType B
--  ON A.ProductFlag=B.ProductType
--  LEFT JOIN SalesReporting.dbo.DimRetailer C ON C.Retailer=a.Retailer
--  UNION ALL
--  SELECT [AccountID]
--      ,[DivisionID]
--      --,[AccountName]
--      --,[Division]
--          ,ISNULL([RetailerID],18) AS [RetailerID]
--      --,[ProductCategory]
--      ,[ProductType_ID]
--      --,[YEAR]
--      --,[Quarter]
--      --,[SD_Revenue]
--      ,([SD_Revenue]/3) AS Quota
--      ,CASE WHEN Quarter =  '2020-01' THEN '02-01-2020'
--                WHEN Quarter =  '2020-02' THEN '05-01-2020'
--                WHEN Quarter =  '2020-03' THEN '08-01-2020'
--                WHEN Quarter =  '2020-04' THEN '11-01-2020' END [TargetDate]
--  FROM SalesDB.[dbo].[v2020_Targets] A LEFT JOIN SalesReporting.dbo.DimProductType B
--  ON A.ProductFlag=B.ProductType
--   LEFT JOIN SalesReporting.dbo.DimRetailer C ON C.Retailer=a.Retailer
--  UNION ALL
--  SELECT [AccountID]
--      ,[DivisionID]
--      --,[AccountName]
--      --,[Division]
--          ,ISNULL([RetailerID],18) AS [RetailerID]
--      --,[ProductCategory]
--      ,[ProductType_ID]
--      --,[YEAR]
--      --,[Quarter]
--      --,[SD_Revenue]
--      ,([SD_Revenue]/3) AS Quota
--      ,CASE WHEN Quarter =  '2020-01' THEN '03-01-2020'
--                WHEN Quarter =  '2020-02' THEN '06-01-2020'
--                WHEN Quarter =  '2020-03' THEN '09-01-2020'
--                WHEN Quarter =  '2020-04' THEN '12-01-2020' END [TargetDate]
--  FROM SalesDB.[dbo].[v2020_Targets] A LEFT JOIN SalesReporting.dbo.DimProductType B
--  ON A.ProductFlag=B.ProductType
--   LEFT JOIN SalesReporting.dbo.DimRetailer C ON C.Retailer=a.Retailer
--  ) A












