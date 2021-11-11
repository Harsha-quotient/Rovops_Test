




CREATE VIEW  [dbo].[vDimBrand] AS

SELECT BrandID
,ISNULL(BrandCategory,'Unknown') as BrandCategory
--,MajorBrandName 
,REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(MajorBrandName,':',''),'®',''),'™',''),'"',''),'#','') AS MajorBrandName 
--,BrandName
,REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(BrandName,':',''),'®',''),'™',''),'"',''),'#','') AS BrandName    FROM (
SELECT BrandID,BrandCategory,MajorBrandName,BrandName, ROW_NUMBER () OVER (PARTITION BY A.BrandID ORDER BY A.BrandID ) AS RN 
		 FROM ( 
SELECT DISTINCT A.BrandID, --15153
		A.Category AS [BrandCategory],
		--[BrandName] AS [MajorBrandName],
		ISNULL(B.BRAND_NAME_NIELSEN,A.BrandName ) AS MajorBrandName,
		--B.PRODUCTMAJORBRAND_NIELSEN AS MajorBrandName,
		A.[BrandName] 		
	FROM salesReporting.[dbo].[DimBrand] A
	LEFT JOIN (SELECT BRAND_NAME_NIELSEN,BRANDNAME
	           FROM  SalesReporting.dbo.Nielsen_CPG_Brand_Mapping_Final
	           WHERE SFDC_Brand_Unique_Mapping = 'Yes')  B
	ON A.BRANDNAME = B.BrandName
	) A 
	) A WHERE A.RN=1


	UNION ALL

	SELECT 'n/a', 'n/a', 'n/a', 'n/a' 
	

