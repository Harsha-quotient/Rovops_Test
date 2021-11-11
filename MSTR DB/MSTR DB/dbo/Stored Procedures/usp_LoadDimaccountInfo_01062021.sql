














CREATE PROCEDURE [dbo].[usp_LoadDimaccountInfo_01062021] AS
/******************************************************************************        
AUTHOR                  : Ujjwal Krisha
CREATE DATE             : 07/01/2020        
PURPOSE                 : Used to populate [usp_LoadDimaccountInfo]
MODULE NAME             : Warehouse
INPUT PARAMS            :         
OUTPUT PARAMS           : (IF NO OUTPUT PARAMS THEN SAY "SELECT LIST")        
USAGE                   : (SEE EXAMPLE ENTRIES BELOW)        

EXEC [dbo].[usp_LoadDimaccountInfo]
        
MODIFICATION HISTORY (INCLUDES QA/PERFORMANCE TUNING CHANGES) :        
     
VER NO.     DATE            NAME       LOG        
-------     ------          -------    -----        
v1.0		04/20/2020		Ujjwal		Initial Version  
v1.0		07/30/2020		Ujjwal		usp_LoadDimaccountInfo_07302020
v1.0		08/13/2020		Ujjwal		usp_LoadDimaccountInfo_08132020
v1.1        08/16/2020      Venkat      Update user mapping table and exception rules.
V1.2       10/03/2020       Venkat      Added Alice Tullio to all Longtail/ABSCO except Amy's Kitchen, Inc.,Bio-nutritional Research Group, Inc.,Bob's Red Mill Natural Foods, Inc,Caulipower, LLC,Popchips, Inc.
										Assign  'Annie Figliulo' to Adhold/'Dude Products, Inc','Land O Lakes, Inc' 
*********************************************************************************/   
BEGIN 

		SET NOCOUNT ON;

		IF OBJECT_ID('tempdb..#T1') IS NOT NULL
			DROP TABLE #T1
		SELECT DISTINCT CAST( isnull(CPG_AccountID,'n/a')  AS VARCHAR(100)) AS CPG_AccountID
			 ,ISNULL(CPG_DivisionID,'n/a') AS CPG_DivisionID
			 ,ISNULL(OPL.[RetailerID],1) AS [RetailerID]
			 --,OPL.[ProductID]
			 ,ISNULL(P.[ProductType_ID],15) AS ProductType_ID
			--,OPL.[Retailer_SE]
			 ,AA_Promo_SE
			 ,AA_SubRegion
			 ,AA_Region
			 ,RetailerVP
			 ,RetailerRD
			 ,CASE WHEN RetailerSD ='Jason Hart' THEN 'Paul Koop' ELSE RetailerSD END AS RetailerSD
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
			 ,NULL AS SellType INTO #T1
		FROM SalesReporting.dbo.DimOpportunityLine OPL
			INNER JOIN SalesReporting.dbo.DimProduct P
				ON OPL.ProductID = P.ProductID
			--LEFT JOIN SalesReporting.dbo.DimRetailer R
				--ON OPL.Retailer=R.Retailer
			--LEFT JOIN SalesReporting.dbo.DimProductType PT
			--	ON PT.ProductType = P.ProductType_2020
		WHERE ISNULL(OPL.Retailer_Division,'') NOT IN ('Agency','Media Credit')		
			 AND Opportunity NOT IN ('Q159619','Q159623','Q181699')
			 
			-- DELETE from    #T1  WHERE CPG_DivisionID='n/a' and RetailerID=18 and ProductType_ID=4 and CPG_AccountID='0016000000fvIiJAAU' AND AA_Promo_SE IS NULL
			 
	--		 DELETE  FROM #T1  WHERE CPG_DivisionID='n/a' and RetailerID=2 and ProductType_ID=9 and CPG_AccountID='0010d00001LM0yHAAT' 
	--AND CPG_AccountName='No Cow'
			 
	 --DELETE  FROM #T1  WHERE CPG_DivisionID='n/a' and RetailerID=2 and ProductType_ID=15 and CPG_AccountID='0016000000a44MXAAY' 
  --    AND AA_SOCIAL_SE IS NULL
		
  --  DELETE  FROM #T1 WHERE  CPG_DivisionID='n/a' and RetailerID=18 and ProductType_ID=15 and CPG_AccountID='n/a' 
	 -- AND AA_SOCIAL_SE IS NULL
	
		
 --   DELETE  FROM #T1  WHERE CPG_DivisionID='n/a' and RetailerID=5 and ProductType_ID=4 and CPG_AccountID='0016000000Ph1SKAAZ' 
	--AND RetailerVP IS NULL

	--SELECT CPG_AccountID,CPG_DivisionID,[RetailerID],ProductType_ID ,COUNT(*) FROM #T1 
	--GROUP BY CPG_AccountID,CPG_DivisionID,[RetailerID],ProductType_ID 
	--HAVING COUNT(*)>1

		IF OBJECT_ID('tempdb..#T2') IS NOT NULL
			DROP TABLE #T2
		SELECT DISTINCT CAST(coalesce(A.[AccountID],AccountName,'n/a') AS VARCHAR(100)) AS  CPG_AccountID
			--,CPG_AccountName
		  ,ISNULL(A.[DivisionID],'n/a') AS CPG_DivisionID
		  ,ISNULL(R.RetailerID,'1') AS [RetailerID]
		  ,ISNULL(PT.[ProductType_ID],15) AS ProductType_ID
		  ,UserName  AS AA_Promo_SE
		  ,SubRegion AS AA_SubRegion
		  ,Region AS AA_Region
		  ,CAST(NULL AS VARCHAR(100)) AS RetailerVP
		  ,CAST(NULL AS VARCHAR(100)) AS RetailerRD
		  ,CAST(NULL AS VARCHAR(100)) AS RetailerSD
		  ,CAST(NULL AS VARCHAR(100)) AS BD_RetailerRD
		  ,CAST(NULL AS VARCHAR(100)) AS AA_Data_SE
		  ,CAST(NULL AS VARCHAR(100)) AS AA_Data_SSD
		  ,CAST(NULL AS VARCHAR(100)) AS AA_Social_SE
		  ,CAST(NULL AS VARCHAR(100)) AS AA_Social_SSD
		  ,CAST(NULL AS VARCHAR(100)) AS [National/RetailerOnly]
		  ,CAST(NULL AS VARCHAR(100)) AS [CPG/Shopper_Inv]
		  ,ISNULL(A.[AccountName],'n/a') AS [AccountName]
		  ,[Division]  AS [Division]
		  ,ISNULL(M.Segments,'Unknown') AS Segments
		  ,NULL AS SellType 
		INTO #T2
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
		--WHERE A.AccountID IS  NULL	 --9904


		--SELECT * FROM #T2


	UPDATE T SET
		--SELECT DISTINCT T.Opportunity ,T.OpportunityLine ,T.Retailer,T.CPG_Name,T.AA_Region,
			RetailerVP = CASE WHEN OPL.Retailer_Division IN ('Media Credit') THEN NULL ELSE RTM.RetailerVP END
			,RetailerRD = CASE WHEN OPL.Retailer_Division IN ('Agency','Media Credit') THEN NULL ELSE RTM.RetailerRD END
			,RetailerSD = CASE WHEN OPL.Retailer_Division IN ('Agency','Media Credit') THEN NULL
							WHEN ISNULL(RTM.RetailerName,'') IN ('Giant Eagle','Kroger/Winco','Meijer','HEB','Other Grocery','SEG','Convenience')
								THEN ISNULL(RTM.RetailSD,'unassigned')
							WHEN ISNULL(RTM.RetailerName,'') IN ('Walmart')  THEN 
										CASE WHEN ISNULL(T.AA_Region,'') IN ('Food','Food & Bev') THEN 'Brittany Bray'
											WHEN ISNULL(T.AA_Region,'') IN ('HBA','Household') THEN 'Shannon Gott' END
											--WHEN ISNULL(T.AA_Region,'') IN ('HBA','Household') THEN 'Kari VonStrohe' END --Commented by VV on 10/21/2020
							--WHEN ISNULL(RTM.RetailerName,'') IN ('CVS','Target','Walgreens') AND ISNULL(T.AA_Region,'') IN ('BD') --Commented by VV on 10/10/20
							WHEN ISNULL(RTM.RetailerName,'') IN ('CVS','Target') AND ISNULL(T.AA_Region,'') IN ('BD')
								THEN RTM.Ret_CPG_SD	
							WHEN ISNULL(RTM.RetailerName,'') IN ('CVS','Target') AND ISNULL(T.AA_Region,'') NOT IN ('BD')
								THEN ISNULL(RTM.RetailSD,'unassigned')
							WHEN ISNULL(R_Ahold.[Retailer],'') IN ('Ahold') 
								THEN R_Ahold.Owner
							WHEN ISNULL(RTM.RetailerName,'') IN ('Ahold') AND ISNULL(T.AA_Region,'') IN ('BD') AND ISNULL(T.[AccountName],'') NOT IN ('Del Monte Foods Company','Dude Products, Inc','Land O Lakes, Inc') --10/03/2020
								THEN RTM.Ret_CPG_SD	
							WHEN ISNULL(R_DG.[Retailer],'') IN ('Dollar General') 
								THEN R_DG.Owner
							WHEN ISNULL(R.[Retailer],'') IN ('Albertsons') AND ISNULL(T.[AA_Promo_SE],'') NOT IN ('Mitch Cristol','Geoff Yeh')
								--THEN R_ABSCO.Owner --For BD Crissy will get credit on the accounts that are not assgined as well. 
								THEN CASE WHEN R_ABSCO.Owner IS NOT NULL THEN R_ABSCO.Owner --Added on 03/30/2020
										  WHEN R_ABSCO.Owner IS NULL AND ISNULL(T.AA_Region,'') IN ('BD') AND ISNULL(T.AA_SubRegion,'') = 'Long Tail' THEN 'Alice Tullio' --10/03/2020
										  WHEN R_ABSCO.Owner IS NULL AND ISNULL(T.AA_Region,'') IN ('BD') THEN 'Lindsay Lauterbach' --05/17/2020
										  --WHEN R_ABSCO.Owner IS NULL AND ISNULL(T.AA_Region,'') IN ('BD') THEN 'Crissy Snyder' 
										  ELSE 'unassigned' END 
							--WHEN ISNULL(R_WAG.[Retailer],'') IN ('Walgreens') AND ISNULL(T.AA_Region,'') NOT IN ('BD') --Commented by VV on 10/10/20
							WHEN ISNULL(R_WAG.[Retailer],'') IN ('Walgreens') 
								THEN R_WAG.Owner
							ELSE 'unassigned' END 	
			,[BD_RetailerRD] = CASE WHEN OPL.Retailer_Division IN ('Agency','Media Credit') THEN NULL
									WHEN ISNULL(RTM.RetailerName,'') IN ('Ahold') AND ISNULL(T.AA_Region,'') IN ('BD') AND ISNULL(T.[AccountName],'') NOT IN ('Del Monte Foods Company')
										THEN RTM.Ret_CPG_RD	
									WHEN ISNULL(RTM.RetailerName,'') IN ('Albertsons') AND ISNULL(T.AA_Region,'') IN ('BD') AND ISNULL(T.[AccountName],'') NOT IN ('Del Monte Foods Company','Smithfield Foods, Inc.')
											AND ISNULL(T.[AA_Promo_SE],'') NOT IN ('Mitch Cristol','Geoff Yeh')
										THEN RTM.Ret_CPG_RD	
									WHEN ISNULL(RTM.RetailerName,'') IN ('CVS','Target') AND ISNULL(T.AA_Region,'') IN ('BD')
										THEN RTM.Ret_CPG_RD	
									WHEN ISNULL(RTM.RetailerName,'') IN ('Dollar General') 
											AND ((ISNULL(T.AA_Region,'') IN ('BD') AND T.[AccountName] NOT IN ('Land O Lakes, Inc') --AND ISNULL(T.[AA_Promo_SE],'') NOT IN ('Mitch Cristol','Geoff Yeh')
													)
													OR ISNULL(T.[AccountName],'') IN ('General Mills, Inc.','Kellogg North America Company','Post Consumer Brands'))
										THEN RTM.Ret_CPG_RD												
									WHEN ISNULL(RTM.RetailerName,'') IN ('Walgreens') AND ISNULL(T.AA_Region,'') IN ('BD')
										THEN RTM.Ret_CPG_RD END 
		FROM #T2 T
			LEFT OUTER JOIN SalesReporting.DBO.DimRetailer R WITH (NOLOCK)
				ON T.RetailerID=R.RetailerID
			LEFT OUTER JOIN SalesReporting.DBO.DimOpportunityLine OPL ON 
				OPL.RetailerID=T.RetailerID
			LEFT OUTER JOIN [SalesReporting].[dbo].[RetailerTeamMapping_2019] RTM WITH (NOLOCK)
				ON R.Retailer = RTM.RetailerName
			LEFT OUTER JOIN (SELECT DISTINCT [Retailer] ,[AccountName] ,Division ,[Owner] FROM [SalesReporting].[dbo].[RetailerAccountAssignemntsALL_2019] WITH (NOLOCK) WHERE Retailer = 'Ahold') R_Ahold
				ON R.Retailer = R_Ahold.Retailer AND T.[AccountName] = R_Ahold.AccountName AND ISNULL(T.Division,'') = ISNULL(R_Ahold.Division,'')
			LEFT OUTER JOIN (SELECT DISTINCT [Retailer] ,[AccountName] ,[Owner] FROM [SalesReporting].[dbo].[RetailerAccountAssignemntsALL_2019] WITH (NOLOCK) WHERE [Retailer] = 'Dollar General') R_DG
				ON R.Retailer = R_DG.Retailer AND T.[AccountName] = R_DG.AccountName
			LEFT OUTER JOIN (SELECT DISTINCT [Retailer] ,[AccountName] ,[Owner] FROM [SalesReporting].[dbo].[RetailerAccountAssignemntsALL_2019] WITH (NOLOCK) WHERE [Retailer] = 'Albertsons') R_ABSCO
				ON R.Retailer = R_ABSCO.Retailer AND T.[AccountName] = R_ABSCO.AccountName
			LEFT OUTER JOIN (SELECT DISTINCT [Retailer] ,[AccountName] ,[Owner] FROM [SalesReporting].[dbo].[RetailerAccountAssignemntsALL_2019] WITH (NOLOCK) WHERE [Retailer] = 'Walgreens') R_WAG
				ON R.Retailer = R_WAG.Retailer AND T.[AccountName] = R_WAG.AccountName						
		WHERE R.Retailer IS NOT NULL



		--SELECT CPG_AccountID,CPG_DivisionID,[RetailerID],ProductType_ID ,COUNT(*) FROM #T2
		--GROUP BY CPG_AccountID,CPG_DivisionID,[RetailerID],ProductType_ID 
		--HAVING COUNT(*)>1

		--select * from #t2
		IF OBJECT_ID('tempdb..#TEMP_FINAL') IS NOT NULL
			DROP TABLE #TEMP_FINAL
		SELECT * 
		INTO #TEMP_FINAL
		FROM (SELECT * FROM #T1
				UNION
			  SELECT A.* FROM #T2 A
				LEFT JOIN #T1 B 
					ON A.CPG_AccountID=B.CPG_AccountID
						AND A.CPG_DivisionID=B.CPG_DivisionID
						AND A.ProductType_ID=B.ProductType_ID
						AND A.RetailerID=B.RetailerID
				WHERE B.CPG_AccountID IS NULL
					AND B.CPG_DivisionID IS NULL
					AND B.ProductType_ID IS NULL
					AND B.RetailerID IS NULL) A

 


		--SELECT CPG_AccountID,CPG_DivisionID,[RetailerID],ProductType_ID ,COUNT(*) FROM #TEMP_FINAL
		--GROUP BY CPG_AccountID,CPG_DivisionID,[RetailerID],ProductType_ID 
		--HAVING COUNT(*)>1

	
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
	

    
    
		UPDATE a SET 
			[NATIONAL/RetailerOnly] = CASE WHEN [CPG_AccountID] ='n/a' AND RetailerID <>1 THEN 'Retailer only' ELSE 'National' END 
		FROM [MSTRReportingDB].[dbo].[DimAccountInfo_New]  a
	

		UPDATE a SET 
			[CPG/Shopper_Inv] = CASE WHEN  RetailerID = 1 THEN 'National Only'
									 WHEN [CPG_AccountID] <> 'n/a' AND RetailerID <> 1 THEN 'National / Shopper mix'
									 WHEN RetailerID <>1 THEN 'Retailer Only' END
		FROM [MSTRReportingDB].[dbo].[DimAccountInfo_New]  a
	
		UPDATE A SET 
			SellType= ISNULL(Sell_Type,'Unknown') 
		FROM [MSTRReportingDB].[dbo].[DimAccountInfo_New]  A 
			LEFT OUTER JOIN MSTRReportingDB.dbo.SellType_Revenue B 
				ON ISNULL(A.CPG_AccountName,'')=ISNULL(B.CPG_Name,'')
	
	
         
 
		UPDATE [MSTRReportingDB].[dbo].[DimAccountInfo_New] SET 
			RetailerSD='Anne Figliulo' 
		WHERE RetailerSD='Annie Figliulo'
            	 

            	 
		UPDATE [MSTRReportingDB].[dbo].[DimAccountInfo_New] SET 
			RetailerSD='Chelsea O''dea' 
		WHERE RetailerSD='Chelsea O’Dea'     
            	 
            	 
--UPDATE [MSTRReportingDB].[dbo].[DimAccountInfo_New]  	        	 
--            	  SET RetailerSD=COALESCE(RetailerRD,RetailerVP) 		
--		  FROM     [MSTRReportingDB].[dbo].[DimAccountInfo_New] 
--		  WHERE ISNULL(RetailerSD ,'unassigned') = 'unassigned


            	 
		UPDATE [MSTRReportingDB].[dbo].[DimAccountInfo_New] SET RetailerSD ='unassigned' WHERE RetailerSD IS NULL
		UPDATE [MSTRReportingDB].[dbo].[DimAccountInfo_New] SET RetailerRD ='unassigned' WHERE RetailerRD IS NULL

		UPDATE [MSTRReportingDB].[dbo].[DimAccountInfo_New] SET CPG_Exception_UserID = 'NA'     
		UPDATE [MSTRReportingDB].[dbo].[DimAccountInfo_New] SET Retailer_Excepion_UserID = 'NA'

		UPDATE [MSTRReportingDB].[dbo].[DimAccountInfo_New] SET CPG_PromoSE_UserID ='unassigned' WHERE CPG_PromoSE_UserID IS NULL 
		UPDATE [MSTRReportingDB].[dbo].[DimAccountInfo_New] SET CPG_SSD_USERID ='unassigned' WHERE CPG_SSD_USERID IS NULL 
		UPDATE [MSTRReportingDB].[dbo].[DimAccountInfo_New] SET CPG_RD_UserID ='unassigned' WHERE CPG_RD_UserID IS NULL 

		UPDATE [MSTRReportingDB].[dbo].[DimAccountInfo_New] SET Retailer_PromoSE_UserID ='unassigned' WHERE Retailer_PromoSE_UserID IS NULL 
		UPDATE [MSTRReportingDB].[dbo].[DimAccountInfo_New] SET Retailer_RD_UserID ='unassigned' WHERE Retailer_RD_UserID IS NULL 
		UPDATE [MSTRReportingDB].[dbo].[DimAccountInfo_New] SET Retailer_VP_USERID ='unassigned' WHERE Retailer_VP_USERID IS NULL 		
		
		

		UPDATE a SET
			  CPG_PromoSE_UserID = SUBSTRING(B.EMAIL,1,CHARINDEX('@',B.EMAIL)-1)
		--SELECT distinct A.AA_Promo_SE ,B.NAME ,B.EMAIL ,B.ALIAS
		FROM [MSTRReportingDB].[dbo].[DimAccountInfo_New] a
			  INNER JOIN PIIEDB.dbo.VW_SF_USER b WITH (NOLOCK)
					on a.AA_Promo_SE = B.NAME
					WHERE b.EMAIL like '%quotient%'
        
            
		UPDATE a SET
			  CPG_SSD_UserID = SUBSTRING(B.EMAIL,1,CHARINDEX('@',B.EMAIL)-1)
		--SELECT DISTINCT a.AA_SubRegion ,B.NAME ,B.EMAIL  
		FROM [MSTRReportingDB].[dbo].[DimAccountInfo_New] a
			  INNER JOIN PIIEDB.dbo.MSTR_UserMapping  b WITH (NOLOCK)
					on a.AA_SubRegion = B.RegionRetailer AND B.Active = 1        
            
		UPDATE a SET
			  CPG_RD_UserID = SUBSTRING(B.EMAIL,1,CHARINDEX('@',B.EMAIL)-1)
		--SELECT DISTINCT a.AA_Region ,B.NAME ,B.EMAIL  
		FROM [MSTRReportingDB].[dbo].[DimAccountInfo_New] a
			  LEFT OUTER JOIN PIIEDB.dbo.MSTR_UserMapping  b WITH (NOLOCK)
					on a.AA_Region = B.RegionRetailer AND B.Active = 1                       
            

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
			  INNER JOIN PIIEDB.dbo.VW_SF_USER b WITH (NOLOCK)
					on a.RetailerRD = B.NAME     
            
		UPDATE a SET
			  Retailer_VP_UserID = SUBSTRING(B.EMAIL,1,CHARINDEX('@',B.EMAIL)-1)
		--SELECT distinct A.AA_Promo_SE ,B.NAME ,B.EMAIL ,B.ALIAS
		FROM [MSTRReportingDB].[dbo].[DimAccountInfo_New] a
			  INNER JOIN PIIEDB.dbo.VW_SF_USER b WITH (NOLOCK)
					on a.RetailerVP = B.NAME                      
            
                       

		UPDATE a SET
			  Data_PromoSE_UserID = SUBSTRING(B.EMAIL,1,CHARINDEX('@',B.EMAIL)-1)
		--SELECT distinct A.AA_Promo_SE ,B.NAME ,B.EMAIL ,B.ALIAS
		FROM [MSTRReportingDB].[dbo].[DimAccountInfo_New] a
			  INNER JOIN PIIEDB.dbo.VW_SF_USER b WITH (NOLOCK)
					on a.AA_Data_SE = B.NAME
            
          
		UPDATE a SET
			  Social_PromoSE_UserID = SUBSTRING(B.EMAIL,1,CHARINDEX('@',B.EMAIL)-1)
		--SELECT distinct A.AA_Promo_SE ,B.NAME ,B.EMAIL ,B.ALIAS
		FROM [MSTRReportingDB].[dbo].[DimAccountInfo_New] a
			  INNER JOIN PIIEDB.dbo.VW_SF_USER b WITH (NOLOCK)
					on a.AA_Social_SE = B.NAME         
            
		--Excepiont rules
		--CPG	
		UPDATE a SET 
			CPG_Exception_UserID = 'mcristol'
		FROM [MSTRReportingDB].[dbo].[DimAccountInfo_New] a
		--WHERE ISNULL(AA_Promo_SE,'') IN ('Mitch Cristol','Geoff Yeh')
		WHERE ISNULL(AA_Promo_SE,'') IN ('Geoff Yeh')

 		UPDATE a SET 
			CPG_Exception_UserID = 'pdawson'
		--SELECT *			
		FROM [MSTRReportingDB].[dbo].[DimAccountInfo_New] a
		WHERE CPG_AccountID IN ('0016000000hjtGxAAI' --Sundial Brands LLC
								,'0016000000Ph1y6AAB') --Unilever
		UPDATE a SET 
			CPG_Exception_UserID = 'mjohnson'
		--SELECT * 
		FROM [MSTRReportingDB].[dbo].[DimAccountInfo_New] a
			INNER JOIN [MSTRReportingDB].[dbo].[vDimProductType] b
				ON a.ProductType_ID = b.ProductType_ID
		WHERE CPG_AccountID = '0016000000Oo7BAAAZ' --General Mills, Inc.
				AND b.ProductCategory = 'Promotion'
		
		UPDATE a SET 
			CPG_PromoSE_UserID = 'zbryson'
			,CPG_Exception_UserID = 'wgeller'
		--SELECT * 
		FROM [MSTRReportingDB].[dbo].[DimAccountInfo_New] a
		WHERE ISNULL(AA_Promo_SE,'')  = 'James Radley'
		
		
		--Retailer
		UPDATE a SET
			Retailer_Excepion_UserID='scarlson' 
		FROM [MSTRReportingDB].[dbo].[DimAccountInfo_New] a 			
		WHERE RETAILERID = 16 --Walgreens


		UPDATE a SET
			Retailer_Excepion_UserID = 'csnyder' 
		--SELECT DISTINCT RetailerSD ,Retailer_PromoSE_UserID			
		FROM [MSTRReportingDB].[dbo].[DimAccountInfo_New] a 			
		WHERE RetailerSD = 'Lindsay Lauterbach'
		
		UPDATE a SET
			Retailer_Excepion_UserID = 'kvonstrohe' 
		--SELECT DISTINCT RetailerSD ,Retailer_PromoSE_UserID			
		FROM [MSTRReportingDB].[dbo].[DimAccountInfo_New] a 			
		WHERE RetailerSD = 'Shannon Gott'
		
		
		
		
		--Update UserID unassigned to resolve hierarcy/security issues. 

		UPDATE a SET
			CPG_PromoSE_UserID ='unassigned'
		--SELECT DISTiNCT CPG_PromoSE_UserID,CPG_SSD_USERID	 
		FROM [MSTRReportingDB].[dbo].[DimAccountInfo_New] a	
		WHERE CPG_PromoSE_UserID = CPG_SSD_USERID 

		UPDATE a SET
			CPG_PromoSE_UserID ='unassigned'
		--SELECT DISTiNCT CPG_PromoSE_UserID,CPG_RD_USERID	 
		FROM [MSTRReportingDB].[dbo].[DimAccountInfo_New] a	
		WHERE CPG_PromoSE_UserID = CPG_RD_USERID 
   	        	 
		UPDATE a SET
			CPG_SSD_USERID ='unassigned'
		--SELECT DISTiNCT CPG_PromoSE_UserID,CPG_SSD_USERID,CPG_RD_USERID	 
		FROM [MSTRReportingDB].[dbo].[DimAccountInfo_New] a	
		WHERE CPG_SSD_USERID = CPG_RD_USERID 

		
		UPDATE a SET
			Retailer_PromoSE_UserID ='unassigned'
		--SELECT DISTiNCT Retailer_PromoSE_UserID,Retailer_RD_USERID	 
		FROM [MSTRReportingDB].[dbo].[DimAccountInfo_New] a	
		WHERE Retailer_PromoSE_UserID = Retailer_RD_USERID 
		
		UPDATE a SET
			Retailer_PromoSE_UserID ='unassigned'
		--SELECT DISTiNCT Retailer_PromoSE_UserID,Retailer_VP_UserID	 
		FROM [MSTRReportingDB].[dbo].[DimAccountInfo_New] a	
		WHERE Retailer_PromoSE_UserID = Retailer_VP_UserID 		
	
		UPDATE a SET
			Retailer_RD_UserID ='unassigned'
		--SELECT DISTiNCT Retailer_RD_UserID,Retailer_VP_USERID	 
		FROM [MSTRReportingDB].[dbo].[DimAccountInfo_New] a	
		WHERE Retailer_RD_UserID = Retailer_VP_USERID 

   	        	    	        	
            	 
	END
	


















