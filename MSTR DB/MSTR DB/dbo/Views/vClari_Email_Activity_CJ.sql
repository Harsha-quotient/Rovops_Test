












CREATE VIEW [dbo].[vClari_Email_Activity_CJ] AS

SELECT B.CPG_AccountName
	--,NatShop.[National/Shopper] AS [National/Shopper]
	--,P.Product_Category
	--,B.[National/Shopper]
	--,CAST(B.ProductCategory AS VARCHAR(20)) AS [Product_Category]
	,B.AA_Region AS Vertical
	,B.AA_SubRegion AS Manager
	,CAST(LTRIM(RTRIM(A.[Rep Name])) AS VARCHAR(50)) AS Core_SE
	--,CAST(A.[Rep Email] AS VARCHAR(100)) AS Rep_Email
	,CAST(A.[meeting] AS INT) AS [Meeting]
	,CAST(A.[upcoming_meeting] AS INT) AS [Upcoming_meeting]
	--,CAST(A.[attachment_received] AS INT) AS [Attachment_Received]
	--,CAST(A.[attachment_sent] AS INT) AS [Attachment_Sent]
	,(CAST(A.[attachment_received] AS INT) + CAST(A.[attachment_sent] AS INT)) AS [Attachments_Sent_Received]
	--,CAST(A.[email_sent] AS INT) AS [Email_Sent]
	--,CAST(A.[email_received] AS INT) AS [Email_Received]
	,(CAST(A.[email_sent] AS INT) + CAST(A.[email_received] AS INT)) AS [Emails_Sent_Received]
	,A.[ActivityDate]
	,CONVERT(BIGINT,CONVERT(VARCHAR(10),A.[ACTIVITYDATE],112)) AS ACTIVITYDATEID
    ,QTR.ActivityQuarter AS Activity_EstQTR
      FROM [MSTRReportingDB].[dbo].[Clari_Email_Activity] A       
    --FROM MSTRReportingDB.dbo.Clari_Email_Activity_05102021 A WITH (NOLOCK)
	INNER JOIN (SELECT DISTINCT CPG_AccountName
				,CAST(LTRIM(RTRIM([AA_Promo_SE])) AS VARCHAR(100)) AS [AA_Promo_SE]
				,[AA_SubRegion]
				,ISNULL([AA_Region],'n/a') AS [AA_Region]
				--,CASE WHEN [CPG/Shopper_Inv] = 'National Only' THEN 'National' ELSE 'Shopper' END [National/Shopper]
				--,P.ProductCategory
				--,P.ProductType
			FROM [MSTRReportingDB].[dbo].[DimAccountInfo_New] D WITH (NOLOCK)
				--INNER JOIN MSTRReportingDB.dbo.vDimProductType P WITH (NOLOCK)
				--	ON D.ProductType_ID = P.ProductType_ID
			WHERE ISNULL(AA_Region,'') NOT IN ('Ecom')) B
		ON A.[Rep Name] =B.[AA_Promo_SE]
				--AND  [ActivityDate]='2021-05-03'
	--CROSS JOIN ( 	
	--		SELECT 'National' AS [National/Shopper] 
	--		UNION
	--		SELECT 'Shopper' AS [National/Shopper]) NatShop
	--CROSS JOIN ( 	
	--		SELECT 'Media' AS Product_Category 
	--		UNION
	--		SELECT 'Promotion' AS Product_Category) P				
	 CROSS JOIN ( 	
			SELECT 20211 AS ActivityQuarter
			UNION 
			SELECT 20212 AS ActivityQuarter
			UNION 
			SELECT 20213 AS ActivityQuarter
			UNION 
			SELECT 20214 AS ActivityQuarter) QTR




