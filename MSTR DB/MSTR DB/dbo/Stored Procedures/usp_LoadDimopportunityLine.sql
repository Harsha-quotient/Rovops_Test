﻿












CREATE PROCEDURE  [dbo].[usp_LoadDimopportunityLine] AS
/******************************************************************************        
AUTHOR                  : Venkata Vempali
CREATE DATE             : 01/23/2019        
PURPOSE                 : Used to populate DimOpportunityLine
MODULE NAME             : MSTRReportingDB
INPUT PARAMS            :         
OUTPUT PARAMS           : (IF NO OUTPUT PARAMS THEN SAY "SELECT LIST")        
USAGE                   : (SEE EXAMPLE ENTRIES BELOW)        

EXEC [dbo].[usp_LoadDimopportunityLine]  
        
MODIFICATION HISTORY (INCLUDES QA/PERFORMANCE TUNING CHANGES) :        
     
VER NO.     DATE            NAME       LOG        
-------     ------          -------    -----        
v1.0		   		        Venkat		Initial Version 
v1.1		06/06/2021      Venkat		Added NationallyFunded object.

*********************************************************************************/  
BEGIN

SET NOCOUNT ON;

TRUNCATE TABLE [MSTRReportingDB].[dbo].[DimOpportunityLine] 

INSERT INTO [MSTRReportingDB].[dbo].[DimOpportunityLine] 
SELECT 
       OPL.OpportunityLineID
      ,OPL.OpportunityID
      ,OPL.Opportunity
      ,OPL.OpportunityLine
      ,[OPL_AccountID]
      ,OPL.[OPL_ACC_Name]
      ,OPL.[OPL_Acc_Type]
      ,OPL.[OPL_Agency_Name]
      ,OPL.[BookingCategory]
      ,OPL.[OPL_ItemNumber]
      ,OPL.[OPL_Ahalogy_SE]
      ,ISNULL(OPL.[CPG_AccountID],'n/a') as [CPG_AccountID]
      --,OPL.[CPG_AccountID]
      ,ISNULL(OPL.[CPG_DivisionID],'n/a') as [CPG_DivisionID]
      ,OPL.[CPG_Name]
      ,OPL.[CPG_Division]
      ,OPL.[Retailer_AccountID]
      ,OPL.[Retailer_DivisionID]
      ,OPL.[Retailer_Acc_Name]
      ,OPL.[Retailer_Division]
      --,OPL.RETAILER
      ,ISNULL(OPL.[RetailerID],1) AS [RetailerID]
      --,OPL.[Retailer_SE]
      ,OPL.[Launch_Date] 
      ,OPL.[End_Date]
      ,OPL.[ProductID]
      --,OPL.[Product_Name]
      --,OPL.[GL_Description]
      --,OPL.[Product_Category]
      --,OPL.[RevenueCategory]
      --,OPL.[ProductLine]
      --,OPL.[SubProdcut]
      --,OPL.[ServiceType]
      --,OPL.[ProductFamily]
      ,OPL.[CommitQuantity]
      ,OPL.[SalePrice]
      --,OPL.[ProductType]
      ,OPL.[ParentAccountName]
      ,P.ProductType_ID
      --,OPL.[RS_Status]
      --,OPL.[EstimatedRevenueStatus] AS RS_EstimatedRevenueStatus
      ,OPL.[EstimatedRevenueStatus] AS [RS_Status]  --- Hot fix done on 11/25/2020
      ,OPL.[RS_Status] AS RS_EstimatedRevenueStatus --- Hot fix done on 11/25/2020
	  --,OPL.BrandID
	  ,CASE WHEN OPL.BrandID = 'NA' THEN 'n/a'
		        WHEN OPL.BrandID IS NULL THEN 'n/a' 
					ELSE OPL.BrandID END 
	  ,OP.NationallyFunded  
	  --,b.BrandName AS OPL_BrandName
	  --,b.MajorBrandName AS OPL_MajorBrandName 
	  --,b.BrandCategory AS OPL_BrandCategory
     -- ,OPL.RetailerGroup
     -- ,CASE WHEN CPG_Name IS NULL THEN 'Retailer only' ELSE 'National' END AS 'National/RetailerOnly' 
     -- ,CASE WHEN (AA_Region IN ('BD','Food','Food & Bev','HBA','Household') OR CPG_Name IS NOT NULL) AND Retailer IS NULL THEN 'National Only'
			  --WHEN (AA_Region IN ('BD','Food','Food & Bev','HBA','Household') OR CPG_Name IS NOT NULL) AND Retailer IS NOT NULL THEN 'National / Shopper mix'
			  --WHEN Retailer IS NOT NULL THEN 'Retailer Only' END  AS [CPG/Shopper_Inv]
      --,OPL.[SF_OP_Promo_SE]
      --,OPL.[SF_OP_Retail_SE]
      --,OPL.[SF_OP_Media_SE]
      --,OPL.[SF_OPL_Promo_SE]
      --,OPL.[SF_OPL_Retail_SE]
      --,OPL.[SF_OPL_Media_SE]
      --,OPL.[AA_Promo_SE]
      --,OPL.[AA_SubRegion]
      --,OPL.[AA_Region]
      --,OPL.[CPG_Segments]
      --,OPL.[RetailerVP]
      --,OPL.[RetailerRD]
      --,OPL.[RetailerSD]
      --,OPL.[BD_RetailerRD]
      --,OPL.[AA_Data_SE]
      --,OPL.[AA_Data_SSD]
      --,OPL.[AA_Social_SE]
      --,OPL.[AA_Social_SSD]
   
FROM SalesReporting.dbo.DimOpportunityLine OPL WITH (NOLOCK) 
	INNER JOIN SalesReporting.dbo.DimOpportunity OP WITH (NOLOCK)
		ON OPL.Opportunity = OP.Opportunity
	INNER JOIN SalesReporting.dbo.DimProduct P WITH (NOLOCK)
		ON OPL.ProductID=P.ProductID
	--LEFT JOIN MSTRReportingDB.[dbo].[vDimBrand] b WITH (NOLOCK)
	--	ON CASE WHEN OPL.BrandID = 'NA' THEN 'n/a'
	--	        WHEN OPL.BrandID IS NULL THEN 'n/a' 
	--				ELSE OPL.BrandID END  = b.BrandID
WHERE ISNULL(OPL.Retailer_Division,'') NOT IN ('Agency','Media Credit')
      AND OP.Opportunity NOT IN ('Q159619','Q159623','Q181699','Q163155','Q163156','Q163157','Q198239','Q198802','Q205906','Q204387','Q210619','Q161007','Q204763','Q198258','Q205017','Q199057','Q204762','Q203319') --Q245691 Added by VV on 09/12/2021
	  AND ISNULL(OP.OP_Acc_Name,'') NOT IN ('Coupons Test Company','Quotient Technology Inc.')
	  --AND ISNULL([Retailer_Acc_Name],'') NOT IN ('Coupons Test Company')
      AND ISNULL(OP.RecordTypeName,'') NOT IN ('In Revision IO - eCom','New IO Opportunity - eCom','Approved IO - eCom','IO Creation - eCom')
      --AND ISNULL(BookingCategory,'') NOT IN ('Ecom')
      AND  ISNULL(AA_Region,'') NOT IN ('Ecom')
      --AND ISNULL(P.ProductType_2020,'') NOT IN ('Data') --Added by VV on 01/06/2021


 UPDATE [MSTRReportingDB].[dbo].[DimOpportunityLine]  SET  BrandID ='n/a' where (BrandID is null or BrandID = 'NA') 
	
--      AND Opportunity NOT IN ('Q161007','Q163155','Q163156','Q163157') -- Region are NULL for 2019Q1 and 2019Q2 in DimOpportunityLine but actual had Ecom value so filtering out
--      AND Opportunity NOT IN ('Q204762','Q205017','Q210619') --  Region are NULL for 2020Q1 in dimOpportunityLine but actual had Ecom value and hence filetring out
--      AND Opportunity NOT IN ('Q163155',
--'Q163156',
--'Q163157',
--'Q198239',
--'Q198802',
--'Q205906',
--'Q204387',
--'Q210619',
--'Q161007',
--'Q204763',
--'Q198258',
--'Q205017',
--'Q199057',
--'Q204762',
--'Q203319'
--)

     -- --LEFT JOIN SalesReporting.dbo.DimRetailer R
     -- --ON OPL.Retailer=R.Retailer
     
     -- 342665




END








