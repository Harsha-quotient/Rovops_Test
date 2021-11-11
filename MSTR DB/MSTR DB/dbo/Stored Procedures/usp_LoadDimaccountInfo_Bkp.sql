

/* coments for test */






CREATE PROCEDURE [dbo].[usp_LoadDimaccountInfo_Bkp] AS

BEGIN 

IF OBJECT_ID('tempdb..#Temp_Final') IS NOT NULL
			  DROP TABLE #Temp_Final

SELECT * INTO #Temp_Final FROM (

SELECT DISTINCT CAST( isnull(CPG_AccountID,'n/a')  AS VARCHAR(100)) AS CPG_AccountID
	 ,ISNULL(CPG_DivisionID,'n/a') AS CPG_DivisionID
	 ,ISNULL(OPL.[RetailerID],18) AS [RetailerID]
	 --,OPL.[ProductID]
	 ,ISNULL(P.[ProductType_ID],15) AS ProductType_ID
	--,OPL.[Retailer_SE]
	 ,AA_Promo_SE
	 ,AA_SubRegion
	 ,AA_Region
	 ,RetailerVP
	 ,RetailerRD
	 ,RetailerSD
	 ,BD_RetailerRD
	 ,AA_Data_SE
	 ,AA_Data_SSD
	 ,AA_Social_SE
	 ,AA_Social_SSD
	 ,NULL AS [National/RetailerOnly]
	 ,NULL AS [CPG/Shopper_Inv]
	 ,ISNULL(OPL.CPG_Name,'n/a')  AS CPG_AccountName
	 ,OPL.CPG_Division
	 ,ISNULL(CPG_Segments,'Unknown') AS Segments
	 ,NULL AS SellType
	FROM SalesReporting.dbo.DimOpportunityLine OPL
	INNER JOIN SalesReporting.dbo.DimProduct P
		ON OPL.ProductID = P.ProductID
	--LEFT JOIN SalesReporting.dbo.DimRetailer R
		--ON OPL.Retailer=R.Retailer
	--LEFT JOIN SalesReporting.dbo.DimProductType PT
	--	ON PT.ProductType = P.ProductType_2020
WHERE ISNULL(OPL.Retailer_Division,'') NOT IN ('Agency','Media Credit')		
	 AND Opportunity NOT IN ('Q159619','Q159623','Q181699')
	
UNION 
	
	SELECT DISTINCT CAST(coalesce(A.[AccountID],AccountName,'n/a') AS VARCHAR(100)) AS  [AccountID]
      ,ISNULL(A.[DivisionID],'n/a') AS [DivisionID]
      ,ISNULL(R.RetailerID,'18') AS [RetailerID]
      ,ISNULL(PT.[ProductType_ID],15) AS ProductType_ID
      ,UserName  AS AA_Promo_SE
	  ,SubRegion AS AA_SubRegion
	  ,Region AS AA_Region
      ,NULL AS RetailerVP
	  ,NULL AS RetailerRD
	  ,NULL AS RetailerSD
	  ,NULL AS BD_RetailerRD
	  ,NULL AS AA_Data_SE
	  ,NULL AS AA_Data_SSD
	  ,NULL AS AA_Social_SE
	  ,NULL AS AA_Social_SSD
	  ,NULL AS [National/RetailerOnly]
	  ,NULL AS [CPG/Shopper_Inv]
	  ,ISNULL(A.[AccountName],'n/a') AS [AccountName]
	  ,[Division]  AS [Division]
	  ,ISNULL(M.Segments,'Unknown') AS Segments
	   ,NULL AS SellType
	FROM SalesDB.[dbo].[v2020_Targets] A
		LEFT OUTER JOIN SalesReporting.dbo.DimRetailer R  WITH (NOLOCK)
			ON A.Retailer = R.Retailer
		LEFT OUTER JOIN SalesReporting.dbo.DimProductType PT WITH (NOLOCK)
		    ON A.ProductFlag= PT.ProductType	
		    LEFT OUTER JOIN [SalesReporting].[dbo].[CPG_Segments_Mapping] M WITH (NOLOCK)
			ON A.AccountID = M.AccountID	
		--LEFT JOIN SalesReporting.dbo.DimOpportunityLine  OPL WITH (NOLOCK) 
		--    ON ISNULL(A.AccountID,'') =ISNULL(OPL.CPG_AccountID,'')
		--    AND ISNULL(A.DivisionID,'')=ISNULL(OPL.CPG_DivisionID,'')
		--    AND A.ProductFlag = OPL.ProductType
	--WHERE A.AccountID IS  NULL	
	 
	
	 
	 
	
	) A
	
	;WITH CTE AS 
	(
	SELECT * , ROW_NUMBER() OVER (PARTITION BY  CPG_AccountID,CPG_DivisionID,RetailerID,ProductType_ID ORDER BY RetailerVP DESC ) AS RN
    FROM #Temp_Final --WHERE CPG_AccountID='0016000000M0thyAAB' AND CPG_DivisionID='n/a' and RetailerID=12 AND ProductType_ID=4
	)
	DELETE FROM CTE WHERE RN>1
	
	TRUNCATE TABLE [MSTRReportingDB].[dbo].[DimAccountInfo_New]
	
	INSERT INTO [MSTRReportingDB].[dbo].[DimAccountInfo_New]([CPG_AccountID]
      ,[CPG_DivisionID]
      ,[RetailerID]
      ,[ProductType_ID]
      ,[AA_Promo_SE]
      ,[AA_SubRegion]
      ,[AA_Region]
      ,[RetailerVP]
      ,[RetailerRD]
      ,[RetailerSD]
      ,[BD_RetailerRD]
      ,[AA_Data_SE]
      ,[AA_Data_SSD]
      ,[AA_Social_SE]
      ,[AA_Social_SSD]
      ,[National/RetailerOnly]
      ,[CPG/Shopper_Inv]
      ,[CPG_AccountName]
      ,[CPG_Division]
      ,[Segments]
      ,[SellType])
	SELECT CPG_AccountID
		,CPG_DivisionID
		,RetailerID
		,ProductType_ID
		,AA_Promo_SE
		,AA_SubRegion
		,AA_Region
		,RetailerVP
		,RetailerRD
		,RetailerSD
		,BD_RetailerRD
		,AA_Data_SE
		,AA_Data_SSD
		,AA_Social_SE
		,AA_Social_SSD
		,[National/RetailerOnly]
		,[CPG/Shopper_Inv]
		,CPG_AccountName
		,CPG_Division
		,Segments
		,SellType
	FROM #Temp_Final
	


	SELECT DISTINCT RetailerID,RetailerSD,RetailerRD,RetailerVP INTO #TEMP  FROM [MSTRReportingDB].[dbo].[DimAccountInfo_New]  WHERE RetailerVP IS NOT NULL	
	
	UPDATE A SET A.RetailerVP=B.RetailerVP, A.RetailerRD=B.RetailerRD,A.RetailerSD=B.RetailerSD FROM  [MSTRReportingDB].[dbo].[DimAccountInfo_New] A
	JOIN #TEMP B ON A.RetailerID=B.RetailerID WHERE A.RetailerVP IS NULL  AND A.RetailerID<>18
	

	
    --UPDATE [MSTRReportingDB].[dbo].[DimAccountInfo_New] SET AA_Region='n/a' where CPG_AccountID='n/a'
    --and CPG_DivisionID='n/a' and RetailerID=6 and ProductType_ID=9 and AA_Region='BD'
    
    
    
	UPDATE a
	set [National/RetailerOnly] = CASE WHEN [CPG_AccountID] ='n/a' and RetailerID<>18 THEN 'Retailer only' ELSE 'National' END 
	from [MSTRReportingDB].[dbo].[DimAccountInfo_New]  a


	UPDATE a
	set [CPG/Shopper_Inv] = CASE WHEN  RetailerID = 18 THEN 'National Only'
					WHEN [CPG_AccountID] <> 'n/a'AND RetailerID <> 18 THEN 'National / Shopper mix'
					WHEN RetailerID<>18 THEN 'Retailer Only' END
	from [MSTRReportingDB].[dbo].[DimAccountInfo_New]  a
	
	UPDATE  A SET SellType= ISNULL(Sell_Type,'Unknown') FROM [MSTRReportingDB].[dbo].[DimAccountInfo_New]  A LEFT OUTER JOIN MSTRReportingDB.dbo.SellType_Revenue B 
	ON ISNULL(A.CPG_AccountName,'')=ISNULL(B.CPG_Name,'')
	
	
         
 
UPDATE [MSTRReportingDB].[dbo].[DimAccountInfo_New] SET RetailerSD='Anne Figliulo' 
            	 WHERE RetailerSD='Annie Figliulo'
            	 

            	 
UPDATE [MSTRReportingDB].[dbo].[DimAccountInfo_New] SET RetailerSD='Chelsea O''dea' 
            	 WHERE RetailerSD='Chelsea O’Dea'     
            	 
            	 
--UPDATE [MSTRReportingDB].[dbo].[DimAccountInfo_New]  	        	 
--            	  SET RetailerSD=COALESCE(RetailerRD,RetailerVP) 		
--		  FROM     [MSTRReportingDB].[dbo].[DimAccountInfo_New] 
--		  WHERE ISNULL(RetailerSD ,'unassigned') = 'unassigned


            	 
UPDATE [MSTRReportingDB].[dbo].[DimAccountInfo_New] SET RetailerSD ='unassigned' WHERE RetailerSD IS NULL
            	 
UPDATE [MSTRReportingDB].[dbo].[DimAccountInfo_New] SET RetailerRD ='unassigned' WHERE RetailerRD IS NULL







	
	
UPDATE a SET
      CPG_PromoSE_UserID = SUBSTRING(B.EMAIL,1,CHARINDEX('@',B.EMAIL)-1)
--SELECT distinct A.AA_Promo_SE ,B.NAME ,B.EMAIL ,B.ALIAS
FROM [MSTRReportingDB].[dbo].[DimAccountInfo_New] a
      INNER JOIN PIIEDB.dbo.VW_SF_USER b 
            on a.AA_Promo_SE = B.NAME
            

	
UPDATE a SET
      CPG_SSD_UserID = SUBSTRING(B.EMAIL,1,CHARINDEX('@',B.EMAIL)-1)
--SELECT distinct A.AA_Promo_SE ,B.NAME ,B.EMAIL ,B.ALIAS
FROM [MSTRReportingDB].[dbo].[DimAccountInfo_New] a
      INNER JOIN SALESDB.[dbo].[vSalesDashboard_Report_Subscription_SubRegion]  b 
            on a.AA_SubRegion = B.SubRegion        
            
UPDATE a SET
      CPG_RD_UserID = SUBSTRING(B.EMAIL,1,CHARINDEX('@',B.EMAIL)-1)
--SELECT distinct A.AA_Promo_SE ,B.NAME ,B.EMAIL ,B.ALIAS
FROM [MSTRReportingDB].[dbo].[DimAccountInfo_New] a
      INNER JOIN SALESDB.[dbo].[vSalesDashboard_Report_Subscription_Region]  b 
            on a.AA_Region = B.Region                       
            


UPDATE a SET
      Retailer_PromoSE_UserID = SUBSTRING(B.EMAIL,1,CHARINDEX('@',B.EMAIL)-1)
--SELECT distinct A.AA_Promo_SE ,B.NAME ,B.EMAIL ,B.ALIAS
FROM [MSTRReportingDB].[dbo].[DimAccountInfo_New] a
      INNER JOIN PIIEDB.dbo.VW_SF_USER b 
            on a.RetailerSD = B.NAME
            

UPDATE a SET
      Retailer_RD_UserID = SUBSTRING(B.EMAIL,1,CHARINDEX('@',B.EMAIL)-1)
--SELECT distinct A.AA_Promo_SE ,B.NAME ,B.EMAIL ,B.ALIAS
FROM [MSTRReportingDB].[dbo].[DimAccountInfo_New] a
      INNER JOIN PIIEDB.dbo.VW_SF_USER b 
            on a.RetailerRD = B.NAME     
            
UPDATE a SET
      Retailer_VP_UserID = SUBSTRING(B.EMAIL,1,CHARINDEX('@',B.EMAIL)-1)
--SELECT distinct A.AA_Promo_SE ,B.NAME ,B.EMAIL ,B.ALIAS
FROM [MSTRReportingDB].[dbo].[DimAccountInfo_New] a
      INNER JOIN PIIEDB.dbo.VW_SF_USER b 
            on a.RetailerVP = B.NAME                      
            
                       

UPDATE a SET
      Data_PromoSE_UserID = SUBSTRING(B.EMAIL,1,CHARINDEX('@',B.EMAIL)-1)
--SELECT distinct A.AA_Promo_SE ,B.NAME ,B.EMAIL ,B.ALIAS
FROM [MSTRReportingDB].[dbo].[DimAccountInfo_New] a
      INNER JOIN PIIEDB.dbo.VW_SF_USER b 
            on a.AA_Data_SE = B.NAME
            
          
UPDATE a SET
      Social_PromoSE_UserID = SUBSTRING(B.EMAIL,1,CHARINDEX('@',B.EMAIL)-1)
--SELECT distinct A.AA_Promo_SE ,B.NAME ,B.EMAIL ,B.ALIAS
FROM [MSTRReportingDB].[dbo].[DimAccountInfo_New] a
      INNER JOIN PIIEDB.dbo.VW_SF_USER b 
            on a.AA_Social_SE = B.NAME         
            
UPDATE [MSTRReportingDB].[dbo].[DimAccountInfo_New]  set CPG_Exception_UserID ='NA'      
            
UPDATE [MSTRReportingDB].[dbo].[DimAccountInfo_New]  set Retailer_Excepion_UserID ='NA'   

UPDATE [MSTRReportingDB].[dbo].[DimAccountInfo_New]  SET CPG_Exception_UserID ='mcristol' WHERE CPG_PromoSE_UserID IN ('mcristol','gyeh')

UPDATE [MSTRReportingDB].[dbo].[DimAccountInfo_New] SET CPG_PromoSE_UserID ='unassigned' 
WHERE CPG_PromoSE_UserID='mkrakower' AND CPG_SSD_USERID='mkrakower'
   	        	 

UPDATE [MSTRReportingDB].[dbo].[DimAccountInfo_New] SET CPG_PromoSE_UserID ='unassigned' 
WHERE CPG_PromoSE_UserID='tpeets' AND CPG_SSD_USERID='tpeets'


UPDATE [MSTRReportingDB].[dbo].[DimAccountInfo_New] SET CPG_PromoSE_UserID ='unassigned' 
WHERE CPG_PromoSE_UserID='nweymouth' AND CPG_RD_USERID='nweymouth'


UPDATE [MSTRReportingDB].[dbo].[DimAccountInfo_New] SET CPG_PromoSE_UserID ='unassigned' 
WHERE CPG_PromoSE_UserID='djakubowicz' AND CPG_RD_USERID='djakubowicz'


UPDATE [MSTRReportingDB].[dbo].[DimAccountInfo_New] SET CPG_PromoSE_UserID ='unassigned' 
WHERE CPG_PromoSE_UserID='ahill' AND CPG_RD_USERID='ahill'


UPDATE [MSTRReportingDB].[dbo].[DimAccountInfo_New] SET CPG_PromoSE_UserID ='unassigned' 
WHERE CPG_PromoSE_UserID='jradley' AND CPG_RD_USERID='jradley'




UPDATE [MSTRReportingDB].[dbo].[DimAccountInfo_New] SET Retailer_PromoSE_UserID ='unassigned' 
WHERE Retailer_PromoSE_UserID='pkoop' AND Retailer_RD_USERID='pkoop'


UPDATE [MSTRReportingDB].[dbo].[DimAccountInfo_New] SET Retailer_RD_UserID ='unassigned' 
WHERE Retailer_RD_UserID='tbecker' AND Retailer_VP_USERID='tbecker'



UPDATE [MSTRReportingDB].[dbo].[DimAccountInfo_New] SET CPG_PromoSE_UserID ='unassigned' WHERE CPG_PromoSE_UserID IS NULL 

UPDATE [MSTRReportingDB].[dbo].[DimAccountInfo_New] SET CPG_SSD_USERID ='unassigned' WHERE CPG_SSD_USERID IS NULL 

UPDATE [MSTRReportingDB].[dbo].[DimAccountInfo_New] SET CPG_RD_UserID ='unassigned' WHERE CPG_RD_UserID IS NULL 


UPDATE [MSTRReportingDB].[dbo].[DimAccountInfo_New] SET Retailer_PromoSE_UserID ='unassigned' WHERE Retailer_PromoSE_UserID IS NULL 

UPDATE [MSTRReportingDB].[dbo].[DimAccountInfo_New] SET Retailer_RD_UserID ='unassigned' WHERE Retailer_RD_UserID IS NULL 

UPDATE [MSTRReportingDB].[dbo].[DimAccountInfo_New] SET Retailer_VP_USERID ='unassigned' WHERE Retailer_VP_USERID IS NULL 

UPDATE [MSTRReportingDB].[dbo].[DimAccountInfo_New] set cpg_ssd_userid='swalston' WHERE AA_SubRegion= 'Growth'


   	        	    	        	
            	 
	END
	
