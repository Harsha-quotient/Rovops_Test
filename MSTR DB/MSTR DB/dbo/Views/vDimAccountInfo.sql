



















CREATE VIEW [dbo].[vDimAccountInfo]
AS

	SELECT [CPG_AccountID]
		  ,[CPG_DivisionID]
		  ,[RetailerID]
		  ,CAST(NULL AS VARCHAR(2)) AS ProductID
		  ,[ProductType_ID]
		  ,[NationallyFunded]  --Added on 06/06/2021 
		  ,CAST(LTRIM(RTRIM([AA_Promo_SE])) AS VARCHAR(100)) AS [AA_Promo_SE]
		  ,[AA_SubRegion]
		  ,ISNULL([AA_Region],'n/a') AS [AA_Region]
		  ,ISNULL([RetailerVP],'n/a') as [RetailerVP]
		  ,[RetailerRD]
		  ,[RetailerSD]
		  ,[BD_RetailerRD]
		  ,[AA_Data_SE]
		  ,[AA_Data_SSD]
		  ,[AA_Social_SE]
		  ,[AA_Social_SSD]
          ,[National/RetailerOnly]
		  ,[CPG/Shopper_Inv]
		  ,CPG_AccountName
		  ,CPG_Division
		  ,Segments
		  ,SellType
		  ,CPG_PromoSE_UserID
		  ,CPG_SSD_USERID
		  ,CPG_RD_USERID
		  ,CPG_EXCEPTION_USERID
		  ,Retailer_PromoSE_UserID
		  ,Retailer_RD_UserID
		  ,Retailer_VP_UserID
		  ,Retailer_Excepion_UserID
		  ,Social_PromoSE_UserID
		  ,Social_SSD_UserID
		  ,Social_Exception_UserID
		  ,DOOH_SE_UserID
		  ,DOOH_SSD_UserID
		  ,DOOH_VP_UserID
		  ,DOOH_Exception_UserID
		  ,CASE WHEN [CPG/Shopper_Inv] = 'National Only' THEN 'National' 
				WHEN [CPG/Shopper_Inv] = 'Retailer Only' THEN 'Retailer Only' 
				ELSE 'Shopper' END [National/Shopper]
	FROM [MSTRReportingDB].[dbo].[DimAccountInfo_New] WITH (NOLOCK)
	WHERE ISNULL(AA_Region,'') NOT IN ('Ecom')
	


















