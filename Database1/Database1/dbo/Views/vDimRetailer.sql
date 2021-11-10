









CREATE VIEW [dbo].[vDimRetailer]
AS

SELECT [RetailerID]
      ,[Retailer]
      ,[RetailerSegment]
      ,RetailerGroup
      ,CASE WHEN  RetailerGroup ='CPG National' THEN 1
            WHEN  RetailerGroup ='Ahold' THEN 2
            WHEN  RetailerGroup ='Albertsons' THEN 3
            WHEN  RetailerGroup ='Club' THEN 4
            WHEN  RetailerGroup ='Convenience' THEN 5
            WHEN  RetailerGroup ='CVS' THEN 6
            WHEN  RetailerGroup ='Dollar General' THEN 7
            WHEN  RetailerGroup ='Tier2' THEN 8
            WHEN  RetailerGroup ='Target' THEN 9
            WHEN  RetailerGroup ='Walgreens' THEN 10
            WHEN  RetailerGroup ='Walmart' THEN 11
            WHEN  RetailerGroup ='Rite Aid' THEN 12
            WHEN  RetailerGroup ='Pet' THEN 13
            WHEN  RetailerGroup ='AutoZone' THEN 14
            WHEN  RetailerGroup ='UnMapped' THEN 15 ELSE 16 END AS RetailerGroupID
      ,CASE WHEN  Retailer IN  ('Albertsons','Ahold','Dollar General','Rite Aid') THEN 'RPM'
      ELSE 'Non-RPM' END AS [RPMvsNonRPM]  
          
FROM SalesReporting.dbo.DimRetailer WITH (NOLOCK)



--SELECT [RetailerID]
--      ,[Retailer]
--      ,[RetailerSegment]
--      ,RetailerGroup
--      ,CASE WHEN  RetailerGroup ='CPG National' THEN 1
--            WHEN  RetailerGroup ='Ahold' THEN 2
--            WHEN  RetailerGroup ='Albertsons' THEN 3
--            WHEN  RetailerGroup ='Club' THEN 4
--            WHEN  RetailerGroup ='Convenience' THEN 5
--            WHEN  RetailerGroup ='CVS' THEN 6
--            WHEN  RetailerGroup ='Dollar General' THEN 7
--            WHEN  RetailerGroup ='Tier2' THEN 8
--            WHEN  RetailerGroup ='Target' THEN 9
--            WHEN  RetailerGroup ='Walgreens' THEN 10
--            WHEN  RetailerGroup ='Walmart' THEN 11
--            WHEN  RetailerGroup ='Rite Aid' THEN 12
--            WHEN  RetailerGroup ='Pet' THEN 13
--            WHEN  RetailerGroup ='UnMapped' THEN 14 ELSE 15 END AS RetailerGroupID
--FROM SalesReporting.dbo.DimRetailer WITH (NOLOCK)









