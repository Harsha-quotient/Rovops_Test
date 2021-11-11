




CREATE PROCEDURE [dbo].[usp_LoadDimaccountInfo_08172021] AS
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
V1.2        10/03/2020      Venkat      Added Alice Tullio to all Longtail/ABSCO except Amy's Kitchen, Inc.,Bio-nutritional Research Group, Inc.,Bob's Red Mill Natural Foods, Inc,Caulipower, LLC,Popchips, Inc.
										Assign  'Annie Figliulo' to Adhold/'Dude Products, Inc','Land O Lakes, Inc' 
v1.3       	01/14/2021      Venkat      Update 2021 Targets table & code clean up.	Update UserID hierarchy 
v1.4       	03/28/2021      Venkat      Added Rob Reinfeld as exception user for Madeline  Aerni on Social
V1.5        04/12/2021      Ujjwal      Adding DOOH Group
V1.6        06/07/2021      Ujjwal      Added National Funded code
v1.7        06/23/2021      Ujjwal      Added Branden Depp and Jamie Jacobson as Exception users
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
			 ,ISNULL(OP.[NationallyFunded],'No') AS [NationallyFunded]
			--,OPL.[Retailer_SE]
			 ,Core_SE AS AA_Promo_SE
			 ,Core_Manager AS AA_SubRegion
			 ,Core_Vertical AS AA_Region
			 ,RetailerVP
			 ,RetailerRD
			 ,RetailerSD  AS RetailerSD
			 --,CASE WHEN RetailerSD ='Jason Hart' THEN 'Paul Koop' ELSE RetailerSD END AS RetailerSD
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
			--,CAST(NULL AS VARCHAR(100)) AS DOOH_SE
			--,CAST(NULL AS VARCHAR(100)) AS DOOH_SSD
			--,CAST(NULL AS VARCHAR(100)) AS DOOH_VP			 
			 ,DOOH_SE
			 ,DOOH_SSD
			 ,DOOH_VP 
		INTO #T1
		FROM SalesReporting.dbo.DimOpportunityLine OPL
			INNER JOIN SalesReporting.dbo.DimOpportunity OP 
				ON OPL.Opportunity = OP.Opportunity
			INNER JOIN SalesReporting.dbo.DimProduct P
				ON OPL.ProductID = P.ProductID
			--LEFT JOIN SalesReporting.dbo.DimRetailer R
				--ON OPL.Retailer=R.Retailer
			--LEFT JOIN SalesReporting.dbo.DimProductType PT
			--	ON PT.ProductType = P.ProductType_2020
		WHERE ISNULL(OPL.Retailer_Division,'') NOT IN ('Agency','Media Credit')		
			 AND OPL.Opportunity NOT IN ('Q159619','Q159623','Q181699')
 
			 

		IF OBJECT_ID('tempdb..#T2') IS NOT NULL
			DROP TABLE #T2
		SELECT DISTINCT CAST(coalesce(A.[AccountID],AccountName,'n/a') AS VARCHAR(100)) AS  CPG_AccountID
			--,CPG_AccountName
		  ,ISNULL(A.[DivisionID],'n/a') AS CPG_DivisionID
		  ,ISNULL(R.RetailerID,'1') AS [RetailerID]
		  ,ISNULL(PT.[ProductType_ID],15) AS ProductType_ID
		  ,'No' AS [NationallyFunded]
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
		  ,CAST(NULL AS VARCHAR(100)) AS DOOH_SE
		  ,CAST(NULL AS VARCHAR(100)) AS DOOH_SSD
		  ,CAST(NULL AS VARCHAR(100)) AS DOOH_VP
		INTO #T2
		FROM SalesDB.[dbo].[v2021_Targets] A
			LEFT OUTER JOIN SalesReporting.dbo.DimRetailer R  WITH (NOLOCK)
				ON A.Retailer = R.Retailer
			LEFT OUTER JOIN SalesReporting.dbo.DimProductType PT WITH (NOLOCK)
				ON A.ProductFlag= PT.ProductType	
			LEFT OUTER JOIN [SalesReporting].[dbo].[CPG_Segments_Mapping] M WITH (NOLOCK)
				ON A.AccountID = M.AccountID	


	 --    UPDATE a SET
		----SELECT OPL.[AccountName] ,OPL.[Division]
		--	 [AA_Social_SE] = ISNULL(AA.UserName,'Drew Hall')
		--	,[AA_Social_SSD] = 'Drew Hall'
		--	--,[AA_Region] = AA.Region
		--FROM #t2 a WITH (NOLOCK)
		--	LEFT OUTER JOIN SalesReporting.dbo.DimAccountAssignments_Social AA WITH (NOLOCK)
		--		ON a.CPG_AccountID = AA.AccountID AND ISNULL(a.[CPG_DivisionID],'n/a') = ISNULL(AA.[DivisionID],'n/a')
		--		WHERE a.ProductType_ID =3



		UPDATE T SET
		--SELECT DISTINCT T.Opportunity ,T.OpportunityLine ,T.Retailer,T.CPG_Name,T.AA_Region,
			RetailerVP =  RTM.RetailerVP 
			,RetailerRD = RTM.RetailerRD 
			,RetailerSD = ISNULL(RTM.RetailSD,'unassigned')  	
			,[BD_RetailerRD] = NULL
		--	,T.RetailerGroup = RTM.[RetailerGroup]
		FROM #T2 T
			LEFT OUTER JOIN SalesReporting.DBO.DimRetailer R WITH (NOLOCK)
				ON T.RetailerID=R.RetailerID
			--LEFT OUTER JOIN SalesReporting.DBO.DimOpportunityLine OPL ON 
			--	OPL.RetailerID=T.RetailerID
			LEFT OUTER JOIN [SalesReporting].[dbo].[RetailerTeamMapping_2019] RTM WITH (NOLOCK)
				ON R.Retailer = RTM.RetailerName
		WHERE R.Retailer <>'CPG National'
		
		UPDATE a SET
		--SELECT a.[AccountName] ,a.[Division],
	         DOOH_SE = CASE WHEN AA.UserName IS NOT NULL THEN AA.UserName
							WHEN AA.UserName IS NULL AND CPG_AccountID = 'Long Tail' THEN 'Alex Weinberger'
							WHEN AA.UserName IS NULL AND CPG_AccountID = 'n/a' AND RetailerID = 3 THEN 'Leslie Weigandt'   --ABSCO  
							WHEN AA.UserName IS NULL AND CPG_AccountID = 'n/a' AND RetailerID = 20 THEN 'Karen Chan'   --RiteAid 
							ELSE 'Norman Chait' END
			,DOOH_SSD = 'Norman Chait'
			,DOOH_VP = 'Gilad Amitai'
		FROM #t2 a WITH (NOLOCK)
			LEFT OUTER JOIN  SalesReporting.dbo.DimAccountAssignments_DOOH AA WITH (NOLOCK)
				ON a.CPG_AccountID = AA.AccountID AND ISNULL(a.[CPG_DivisionID],'n/a') = ISNULL(AA.[DivisionID],'n/a')
		WHERE a.ProductType_ID = 5


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
			  SELECT A.* 
			  FROM #T2 A
				LEFT JOIN #T1 B 
					ON A.CPG_AccountID=B.CPG_AccountID
						AND A.CPG_DivisionID=B.CPG_DivisionID
						AND A.ProductType_ID=B.ProductType_ID
						AND A.RetailerID=B.RetailerID
						AND A.NationallyFunded = B.NationallyFunded
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
			,[NationallyFunded]
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
			,[SellType]
			,DOOH_SE
			,DOOH_SSD
			,DOOH_VP)
		SELECT CPG_AccountID
			,CPG_DivisionID
			,RetailerID
			,ProductType_ID
			,NationallyFunded
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
			,DOOH_SE
			,DOOH_SSD
			,DOOH_VP
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
	
		UPDATE A SET
			AA_Region = 'Retailer Only'
			,AA_SubRegion = CASE WHEN AA_SubRegion IS NULL THEN 'Jamie Clarke' ELSE AA_SubRegion END
		FROM [MSTRReportingDB].[dbo].[DimAccountInfo_New]  A 
		WHERE A.AA_Region = 'Jamie Clarke'
		
		UPDATE a SET
			AA_Region =  'n/a'
			,AA_SubRegion = 'Other'
			,AA_Promo_SE = CASE WHEN AA_Promo_SE = 'Admin Batch' THEN 'Admin Batch' ELSE 'unassigned' END
		--SELECT Distinct AA_Promo_SE, AA_SubRegion ,AA_Region
		FROM [MSTRReportingDB].[dbo].[DimAccountInfo_New] a 
		WHERE AA_Region IS NULL OR AA_Region IN ('n/a')


		---- Fix for the Social SE 

		UPDATE a SET
		  [AA_Social_SE] = CASE WHEN CPG_AccountID = 'Long Tail' THEN 'Rob Reinfeld' ELSE ISNULL(AA.UserName,'Drew Hall') END
		  ,[AA_Social_SSD] = 'Drew Hall'
	--SELECT [CPG_AccountID] ,[CPG_DivisionID] ,b.ProductType ,[AA_Social_SE] ,[AA_Social_SSD] ,ISNULL(AA.UserName,'Drew Hall')
	    FROM [MSTRReportingDB].[dbo].[DimAccountInfo_New] a
		INNER JOIN SalesReporting.dbo.DimProductType b
			ON a.ProductType_ID = b.ProductType_ID
		LEFT OUTER JOIN SalesReporting.dbo.DimAccountAssignments_Social AA WITH (NOLOCK)
				ON a.CPG_AccountID = AA.AccountID AND ISNULL(a.[CPG_DivisionID],'n/a') = ISNULL(AA.[DivisionID],'n/a')	
	    WHERE b.ProductType = 'Social'
			AND a.AA_Social_SSD IS NULL
		
            	 
		UPDATE [MSTRReportingDB].[dbo].[DimAccountInfo_New] SET RetailerSD ='unassigned' WHERE RetailerSD IS NULL
		UPDATE [MSTRReportingDB].[dbo].[DimAccountInfo_New] SET RetailerRD ='unassigned' WHERE RetailerRD IS NULL

		UPDATE [MSTRReportingDB].[dbo].[DimAccountInfo_New] SET CPG_Exception_UserID = 'NA'     
		UPDATE [MSTRReportingDB].[dbo].[DimAccountInfo_New] SET Retailer_Excepion_UserID = 'NA'
		UPDATE [MSTRReportingDB].[dbo].[DimAccountInfo_New] SET Social_Exception_UserID = 'NA'
	    UPDATE [MSTRReportingDB].[dbo].[DimAccountInfo_New] SET DOOH_Exception_UserID = 'NA'

		UPDATE [MSTRReportingDB].[dbo].[DimAccountInfo_New] SET CPG_PromoSE_UserID ='unassigned' WHERE CPG_PromoSE_UserID IS NULL 
		UPDATE [MSTRReportingDB].[dbo].[DimAccountInfo_New] SET CPG_SSD_USERID ='unassigned' WHERE CPG_SSD_USERID IS NULL 
		UPDATE [MSTRReportingDB].[dbo].[DimAccountInfo_New] SET CPG_RD_UserID ='unassigned' WHERE CPG_RD_UserID IS NULL 

		UPDATE [MSTRReportingDB].[dbo].[DimAccountInfo_New] SET Retailer_PromoSE_UserID ='unassigned' WHERE Retailer_PromoSE_UserID IS NULL 
		UPDATE [MSTRReportingDB].[dbo].[DimAccountInfo_New] SET Retailer_RD_UserID ='unassigned' WHERE Retailer_RD_UserID IS NULL 
		UPDATE [MSTRReportingDB].[dbo].[DimAccountInfo_New] SET Retailer_VP_USERID ='unassigned' WHERE Retailer_VP_USERID IS NULL 		
		
		UPDATE [MSTRReportingDB].[dbo].[DimAccountInfo_New] SET Social_PromoSE_UserID ='unassigned' WHERE Social_PromoSE_UserID IS NULL 
		UPDATE [MSTRReportingDB].[dbo].[DimAccountInfo_New] SET Social_SSD_USERID ='unassigned' WHERE Social_SSD_USERID IS NULL 
		
		UPDATE [MSTRReportingDB].[dbo].[DimAccountInfo_New] SET DOOH_SE_UserID ='unassigned' WHERE DOOH_SE_UserID IS NULL 
		UPDATE [MSTRReportingDB].[dbo].[DimAccountInfo_New] SET DOOH_SSD_UserID ='unassigned' WHERE DOOH_SSD_UserID IS NULL 
		UPDATE [MSTRReportingDB].[dbo].[DimAccountInfo_New] SET DOOH_VP_UserID ='unassigned' WHERE DOOH_VP_UserID IS NULL
		
		IF OBJECT_ID('tempdb..#TMP_RetailerManagers') IS NOT NULL
			DROP TABLE #TMP_RetailerManagers
		SELECT UserName
		INTO #TMP_RetailerManagers
		FROM (
			SELECT DISTINCT [RetailerVP] AS UserName FROM [SalesReporting].[dbo].[RetailerTeamMapping_2019] WHERE [RetailerVP] IS NOT NULL
			UNION
			SELECT DISTINCT [RetailerRD] AS UserName FROM [SalesReporting].[dbo].[RetailerTeamMapping_2019] WHERE [RetailerRD] IS NOT NULL
			UNION
			SELECT DISTINCT [RetailSD] AS UserName FROM [SalesReporting].[dbo].[RetailerTeamMapping_2019] WHERE [RetailSD] IS NOT NULL
			) t
		
		--Promo SE
		UPDATE a SET
			  CPG_PromoSE_UserID = SUBSTRING(B.EMAIL,1,CHARINDEX('@',B.EMAIL)-1)
		--SELECT distinct A.AA_Promo_SE ,B.NAME ,B.EMAIL ,B.ALIAS
		FROM [MSTRReportingDB].[dbo].[DimAccountInfo_New] a
			  INNER JOIN PIIEDB.dbo.VW_SF_USER b WITH (NOLOCK)
					on a.AA_Promo_SE = B.NAME
		WHERE b.EMAIL like '%quotient%'
			AND b.NAME NOT IN (SELECT UserName FROM #TMP_RetailerManagers)
			
		
        --SubRegion        
		UPDATE a SET
			  CPG_SSD_UserID = SUBSTRING(B.EMAIL,1,CHARINDEX('@',B.EMAIL)-1)
			  ,AA_SubRegion = b.Name
		--SELECT DISTINCT a.AA_SubRegion ,B.NAME ,B.EMAIL  
		FROM [MSTRReportingDB].[dbo].[DimAccountInfo_New] a
			  INNER JOIN PIIEDB.dbo.MSTR_UserMapping  b WITH (NOLOCK)
					on a.AA_SubRegion = B.RegionRetailer AND B.Active = 1        
        
        --Region/Vertical
		UPDATE a SET
			  CPG_RD_UserID = SUBSTRING(B.EMAIL,1,CHARINDEX('@',B.EMAIL)-1)
		--SELECT DISTINCT a.AA_Region ,B.NAME ,B.EMAIL  
		FROM [MSTRReportingDB].[dbo].[DimAccountInfo_New] a
			  INNER JOIN PIIEDB.dbo.MSTR_UserMapping  b WITH (NOLOCK)
					on a.AA_Region = B.RegionRetailer AND B.Active = 1                       
            
		--Retailer SD
		UPDATE a SET
			  Retailer_PromoSE_UserID = SUBSTRING(B.EMAIL,1,CHARINDEX('@',B.EMAIL)-1)
		--SELECT distinct A.AA_Promo_SE ,B.NAME ,B.EMAIL ,B.ALIAS
		FROM [MSTRReportingDB].[dbo].[DimAccountInfo_New] a
			  INNER JOIN PIIEDB.dbo.VW_SF_USER b 
					on a.RetailerSD = B.NAME
            
		--Retailer RD
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
					
		UPDATE a SET
			  Social_SSD_UserID = SUBSTRING(B.EMAIL,1,CHARINDEX('@',B.EMAIL)-1)
		--SELECT distinct A.AA_Promo_SE ,B.NAME ,B.EMAIL ,B.ALIAS
		FROM [MSTRReportingDB].[dbo].[DimAccountInfo_New] a
			  INNER JOIN PIIEDB.dbo.VW_SF_USER b WITH (NOLOCK)
					on a.AA_Social_SSD = B.NAME      			   
            
            
        -- DOOH Updates 
        
        UPDATE a SET
			  DOOH_SE_UserID = SUBSTRING(B.EMAIL,1,CHARINDEX('@',B.EMAIL)-1)
		--SELECT distinct A.AA_Promo_SE ,B.NAME ,B.EMAIL ,B.ALIAS
		FROM [MSTRReportingDB].[dbo].[DimAccountInfo_New] a
			  INNER JOIN PIIEDB.dbo.VW_SF_USER b WITH (NOLOCK)
					on a.DOOH_SE = B.NAME      
					
		UPDATE a SET
			  DOOH_SSD_UserID = SUBSTRING(B.EMAIL,1,CHARINDEX('@',B.EMAIL)-1)
		--SELECT distinct A.AA_Promo_SE ,B.NAME ,B.EMAIL ,B.ALIAS
		FROM [MSTRReportingDB].[dbo].[DimAccountInfo_New] a
			  INNER JOIN PIIEDB.dbo.VW_SF_USER b WITH (NOLOCK)
					on a.DOOH_SSD = B.NAME      			   
            
         UPDATE a SET
			  DOOH_VP_UserID = SUBSTRING(B.EMAIL,1,CHARINDEX('@',B.EMAIL)-1)
		--SELECT distinct A.AA_Promo_SE ,B.NAME ,B.EMAIL ,B.ALIAS
		FROM [MSTRReportingDB].[dbo].[DimAccountInfo_New] a
			  INNER JOIN PIIEDB.dbo.VW_SF_USER b WITH (NOLOCK)
					on a.DOOH_VP = B.NAME 
					
					
		--Excepiont rules
		--CPG	
		
 		UPDATE a SET 
			CPG_Exception_UserID = 'pdawson'
		--SELECT DISTINCT CPG_AccountID	,AA_Promo_SE ,CPG_PromoSE_UserID ,CPG_Exception_UserID		
		FROM [MSTRReportingDB].[dbo].[DimAccountInfo_New] a
		WHERE CPG_AccountID IN ('0016000000Ph1y6AAB') --Unilever
			AND AA_Promo_SE = 'Kal Prince'
		
		UPDATE a SET 
			CPG_Exception_UserID = 'cdooley'
		--SELECT DISTINCT CPG_AccountID	,AA_Promo_SE ,CPG_PromoSE_UserID ,CPG_Exception_UserID
		FROM [MSTRReportingDB].[dbo].[DimAccountInfo_New] a
		WHERE CPG_AccountID IN ('0016000000PgrHaAAJ') --P&G
			AND  AA_Promo_SE  = 'Whitney Geller'
		
		UPDATE a SET 
			CPG_Exception_UserID = 'ccordaro'
		--SELECT DISTINCT CPG_AccountID	,AA_Promo_SE ,CPG_PromoSE_UserID ,CPG_Exception_UserID
		FROM [MSTRReportingDB].[dbo].[DimAccountInfo_New] a
		WHERE AA_Promo_SE  = 'Allison Landauer' --All J&J accounts
		
		
		UPDATE a SET 
			Social_Exception_UserID = 'stlutz'
		--SELECT DISTINCT CPG_AccountID	,AA_Promo_SE ,CPG_PromoSE_UserID ,CPG_Exception_UserID
		FROM [MSTRReportingDB].[dbo].[DimAccountInfo_New] a
		WHERE AA_Social_SE  = 'Noah Stone' 
		
		UPDATE a SET 
			Social_Exception_UserID = 'rreinfeld'
		--SELECT DISTINCT AA_Social_SE, [Social_PromoSE_UserID], Social_Exception_UserID
		FROM [MSTRReportingDB].[dbo].[DimAccountInfo_New] a
		WHERE AA_Social_SE  = 'Madeline Aerni'
		
		UPDATE a SET 
			Retailer_Excepion_UserID = 'pkoop'
		--SELECT DISTINCT AA_Social_SE, [Social_PromoSE_UserID], Social_Exception_UserID
		FROM [MSTRReportingDB].[dbo].[DimAccountInfo_New] a
		WHERE ProductType_ID IN (7,8,9,10,11,12)

			-- Added on 06/23/2021		
		UPDATE [MSTRReportingDB].[dbo].[DimAccountInfo_New] SET DOOH_Exception_UserID='bdepp'
		WHERE AA_SubRegion='Ashley Schneider'

		UPDATE [MSTRReportingDB].[dbo].[DimAccountInfo_New] SET CPG_Exception_UserID='jjacobson'
		WHERE AA_Promo_SE='Cassie Graves'
		
		--UPDATE a SET 
		--	CPG_Exception_UserID = 'mjohnson'
		----SELECT * 
		--FROM [MSTRReportingDB].[dbo].[DimAccountInfo_New] a
		--	INNER JOIN [MSTRReportingDB].[dbo].[vDimProductType] b
		--		ON a.ProductType_ID = b.ProductType_ID
		--WHERE CPG_AccountID = '0016000000Oo7BAAAZ' --General Mills, Inc.
		--		AND b.ProductCategory = 'Promotion'
		
		
		
		
		----Retailer
		--UPDATE a SET
		--	Retailer_Excepion_UserID='scarlson' 
		--FROM [MSTRReportingDB].[dbo].[DimAccountInfo_New] a 			
		--WHERE RETAILERID = 16 --Walgreens


		--UPDATE a SET
		--	Retailer_Excepion_UserID = 'csnyder' 
		----SELECT DISTINCT RetailerSD ,Retailer_PromoSE_UserID			
		--FROM [MSTRReportingDB].[dbo].[DimAccountInfo_New] a 			
		--WHERE RetailerSD = 'Lindsay Lauterbach'
		
		--UPDATE a SET
		--	Retailer_Excepion_UserID = 'kvonstrohe' 
		----SELECT DISTINCT RetailerSD ,Retailer_PromoSE_UserID			
		--FROM [MSTRReportingDB].[dbo].[DimAccountInfo_New] a 			
		--WHERE RetailerSD = 'Shannon Gott'
		
		
		
		
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
	
	
	







