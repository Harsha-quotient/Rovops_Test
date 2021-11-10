





CREATE PROCEDURE  [dbo].[usp_LoadDimCPGAccount]
AS
BEGIN

      TRUNCATE TABLE dbo.DimCPGAccount
      
      INSERT INTO dbo.DimCPGAccount 
	  SELECT DISTINCT ISNULL(CPG_AccountID,'n/a') AS CPG_AccountID
		,ISNULL(CPG_Name,'n/a')  AS CPG_AccountName
		,ISNULL(CPG_DivisionID,'n/a') AS CPG_DivisionID 
		,CPG_Division AS CPG_Division
		,ISNULL(CPG_Segments,'Unknown') AS Segments
		,NULL AS SellType
		FROM SalesReporting.dbo.DimOpportunityLine WITH (NOLOCK)
		WHERE CPG_AccountID IS not  NULL
		AND CPG_AccountID <>'0016000000M0tXXAAZ'
	UNION 
	   SELECT DISTINCT ISNULL(A.[AccountID],'n/a') AS [AccountID]
      ,ISNULL(A.[AccountName],'n/a') AS [AccountName]
      ,ISNULL(A.[DivisionID],'n/a') AS [DivisionID]
      ,[Division]  AS [Division]
      ,ISNULL(M.Segments,'Unknown') AS Segments
      ,NULL AS SellType
		FROM SalesReporting.[dbo].[v2020_Targets] A
		LEFT OUTER JOIN [SalesReporting].[dbo].[CPG_Segments_Mapping] M WITH (NOLOCK)
			ON A.AccountID = M.AccountID	
		--	WHERE A.AccountID <>'0016000000M0tXXAAZ'
	--WHERE A.AccountID IS NOT NULL		
	
	DELETE FROM dbo.DimCPGAccount  WHERE CPG_ACCOUNTID='n/a' AND CPG_ACCOUNTNAME IS NOT NULL  AND  CPG_ACCOUNTNAME <>'n/a'	
	
	UPDATE  A SET SellType= ISNULL(Sell_Type,'Unknown') FROM dbo.DimCPGAccount  A LEFT OUTER JOIN MSTRReportingDB.dbo.SellType_Revenue B 
	ON ISNULL(A.CPG_AccountName,'')=ISNULL(B.CPG_Name,'')
	
END





