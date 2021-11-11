
CREATE PROCEDURE [dbo].[usp_LoadSelltype_Revenue] 
AS

BEGIN

IF OBJECT_ID('tempdb..#TMP') IS NOT NULL
			  DROP TABLE #TMP
SELECT t.*
INTO #TMP
FROM (
	SELECT LEFT(QTR,4) AS [Year],
	qtr,
		  OPL.CPG_Name,
		  SUM(RS.Booked_Rev) AS BookedRev
	FROM SalesReporting..RevenueScheduleSummary RS WITH (NOLOCK)
		  INNER JOIN SalesReporting.dbo.DimOpportunityLine OPL WITH (NOLOCK)
				ON RS.Opportunity = OPL.Opportunity AND RS.Opportunity_Line = OPL.OpportunityLine
		  INNER JOIN SalesReporting.dbo.DimOpportunity OP WITH (NOLOCK)
				ON OPL.OpportunityID = OP.OpportunityID
		  INNER JOIN SalesReporting.dbo.DimProduct DP WITH (NOLOCK)
				ON OPL.ProductID = DP.ProductID
	WHERE ((RS.Loaddate = '2019-04-01' AND RS.qtr IN ('2019-01'))
				OR (RS.Loaddate = '2020-04-01' AND RS.qtr IN ('2020-01')))
		  AND ISNULL(OPL.Retailer_Division,'n/a') NOT IN ('Agency','Media Credit')
		  AND OP.Opportunity NOT IN ('Q157265')
		  AND ISNULL(opl.AA_Region,'') NOT IN ('Ecom')
		  AND ISNULL(RS.Region,'') NOT IN ('Ecom')
		  AND ISNULL(opl.BookingCategory,'') NOT IN ('Ecom')
		  AND op.OP_ACC_NAME NOT IN ('COUPONS TEST COMPANY')
		  AND OPL.OPPORTUNITY NOT IN ('Q159619','Q159623')
		  AND RS.BOOKED_REV > 0
		  AND ISNULL(RS.Product_Name,'') NOT IN ('APM Onsite - ABSCo Managed Service')
		  AND OPL.CPG_Name IS NOT NULL
	GROUP BY LEFT(QTR,4), OPL.CPG_Name,qtr
	UNION
	SELECT LEFT(QTR,4) AS [Year],
	qtr,
		OPL.CPG_Name,
		SUM(RS.Booked_Rev) AS BookedRev
	FROM SalesReporting..RevenueScheduleSummary RS WITH (NOLOCK)
		  INNER JOIN SalesReporting.dbo.DimOpportunityLine OPL WITH (NOLOCK)
				ON RS.Opportunity = OPL.Opportunity AND RS.Opportunity_Line = OPL.OpportunityLine
		  INNER JOIN SalesReporting.dbo.DimOpportunity OP WITH (NOLOCK)
				ON OPL.OpportunityID = OP.OpportunityID
		  INNER JOIN SalesReporting.dbo.DimProduct DP WITH (NOLOCK)
				ON OPL.ProductID = DP.ProductID
	WHERE ((RS.Loaddate = DATEADD(Year,-1,CAST(GETDATE()-1 AS DATE)) AND RS.qtr IN ('2019-02'))
				OR (RS.Loaddate = CAST(GETDATE()-1 AS DATE) AND RS.qtr IN ('2020-02')))
		  AND ISNULL(OPL.Retailer_Division,'n/a') NOT IN ('Agency','Media Credit')
		  AND OP.Opportunity NOT IN ('Q157265')
		  AND ISNULL(opl.AA_Region,'') NOT IN ('Ecom')
		  AND ISNULL(RS.Region,'') NOT IN ('Ecom')
		  AND ISNULL(opl.BookingCategory,'') NOT IN ('Ecom')
		  AND op.OP_ACC_NAME NOT IN ('COUPONS TEST COMPANY')
		  AND OPL.OPPORTUNITY NOT IN ('Q159619','Q159623')
		  AND RS.BOOKED_REV > 0
		  AND ISNULL(RS.Product_Name,'') NOT IN ('APM Onsite - ABSCo Managed Service')
		  AND OPL.CPG_Name IS NOT NULL
	GROUP BY LEFT(QTR,4), OPL.CPG_Name,qtr
	) t

TRUNCATE TABLE 	MSTRReportingDB.dbo.SellType_Revenue
	
INSERT INTO 	MSTRReportingDB.dbo.SellType_Revenue
	
SELECT CPG_Name,LastYearBooked,CurrentYearBooked,
                CASE WHEN LastYearBooked IS NULL AND  CurrentYearBooked IS NOT NULL THEN 'New Logo'
                     WHEN CurrentYearBooked IS NULL AND LastYearBooked<>0 THEN 'Churn'
                     WHEN isnull(CurrentYearBooked,0)-isnull(LastYearBooked,0)>0 THEN 'Upsell'
                     WHEN isnull(CurrentYearBooked,0)-isnull(LastYearBooked,0)<0 THEN 'Downsell'
                      END AS 'Sell_Type'  FROM (
SELECT CPG_Name,sum(CASE WHEN Year='2019' THEN BookedRev END) AS LastYearBooked, sum(CASE WHEN Year='2020' THEN BookedRev END) AS CurrentYearBooked
FROM #TMP
--where CPG_Name='Abbott Nutrition'
group by  CPG_Name 
) A


END

