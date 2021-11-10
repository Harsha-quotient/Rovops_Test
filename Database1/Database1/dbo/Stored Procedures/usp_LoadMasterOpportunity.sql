


CREATE PROCEDURE [dbo].[usp_LoadMasterOpportunity]

AS

BEGIN
/******************************************************************************        
AUTHOR                  : Venkata Vempali
CREATE DATE             : 01/23/2019        
PURPOSE                 : Used to populate DimOpportunity
MODULE NAME             : Warehouse
INPUT PARAMS            :         
OUTPUT PARAMS           : (IF NO OUTPUT PARAMS THEN SAY "SELECT LIST")        
USAGE                   : (SEE EXAMPLE ENTRIES BELOW)        

EXEC [dbo].[usp_LoadMasterOpportunity]
        
MODIFICATION HISTORY (INCLUDES QA/PERFORMANCE TUNING CHANGES) :        
     
VER NO.     DATE            NAME              LOG        
-------     ------          -------          -----        
v1.0		02/04/2021		Ujjwal Krishna   Initial Version 
v1.0		03/10/2021		Venkata Vempali  Fine tuned the code.
*********************************************************************************/   
	SET NOCOUNT ON;

		IF OBJECT_ID('tempdb..#tempOpportunitiesList') IS NOT NULL
			  DROP TABLE #tempOpportunitiesList
		SELECT DISTINCT RSE.Opportunity, RSE.Qtr
		INTO #tempOpportunitiesList
		--FROM ExternalSourcesNoBackup..RevenueScheduleSummary_Core rs WITH (NOLOCK)
		FROM [SalesReporting].[dbo].[RevenueScheduleSummary] RSE WITH (NOLOCK)
			INNER JOIN SalesReporting.dbo.DimOpportunityLine OPL WITH (NOLOCK)
				ON RSE.Opportunity = OPL.Opportunity AND RSE.Opportunity_Line = OPL.OpportunityLine
			INNER JOIN SalesReporting.dbo.DimProduct P (NOLOCK) 
					ON RSE.ProductID = P.ProductID		
		WHERE RSE.Opportunity NOT IN ('Q181699','Q159619','Q159623','Q157265') 
			AND RSE.OP_Acc_Name NOT IN ('Coupons Test Company','Quotient Technology Inc.')
			AND ISNULL(OPL.AA_Region,'') NOT IN ('Ecom')
			AND (PIPE_REV > 0 OR GROSS_PIPE_REV > 0 OR BOOKED_REV > 0) 
			AND ISNULL(RSE.Product_Name,'') NOT IN ('APM Onsite - ABSCo Managed Service') --Added on 10/24/2019
			AND ISNULL(RSE.OP_RecordTypeName,'') NOT IN ('In Revision IO - eCom','New IO Opportunity - eCom','Approved IO - eCom','IO Creation - eCom')
			--AND ISNULL(RSE.Region,'') NOT IN ('Ecom')
			AND ISNULL(Division,'') NOT IN ('Agency','Media Credit')
			AND ISNULL(RSE.Retailer_Division,'') NOT IN ('MEDIA CREDIT', 'AGENCY')
			AND ISNULL(P.ProductType_2020,'') NOT IN ('Data')    
			--AND (CASE WHEN (OPL.PRODUCT_NAME LIKE '%AHALOGY%' AND RSE.Start_Date_Month <'2018-06-01')  THEN 'AHALOGY-EXCLUDE' ELSE OPL.PRODUCT_NAME END) NOT IN ('AHALOGY-EXCLUDE')
			AND qtr in ('2021-01','2021-02','2021-03','2021-04')
			AND LoadDate >= '2019-01-01'

		IF OBJECT_ID('tempdb..#tempFirstLastDates') IS NOT NULL
			  DROP TABLE #tempFirstLastDates
		SELECT t.Opportunity
			,t.Qtr
			,MIN(rs.loaddate) AS First_Seen_Date
			,MAX(rs.loaddate) AS Last_Seen_Date
		INTO #tempFirstLastDates
		FROM #tempOpportunitiesList t
			INNER JOIN SalesReporting..RevenueScheduleSummary rs WITH (NOLOCK)
				ON t.opportunity = rs.opportunity
					AND t.Qtr = rs.Qtr
		WHERE RS.LoadDate >= '2019-01-01'
			AND RS.Qtr IN ('2021-01','2021-02','2021-03','2021-04')
			AND (PIPE_REV > 0 OR GROSS_PIPE_REV > 0 OR BOOKED_REV > 0)
		GROUP BY t.Opportunity,t.qtr


		IF OBJECT_ID('tempdb..#tempBookedDates') IS NOT NULL
		DROP TABLE #tempBookedDates
		--table of the booked opportunities
		SELECT t.Opportunity
			,t.Qtr
			,'Won' Won_Lost
			,MIN(rs.loaddate) AS Closed_Date
			,t.First_Seen_Date
			,t.Last_Seen_Date
		INTO #tempBookedDates
		FROM #tempFirstLastDates t
			INNER JOIN SalesReporting..RevenueScheduleSummary rs WITH (NOLOCK)
				ON t.Opportunity = rs.Opportunity
					AND t.Qtr = rs.Qtr
		WHERE rs.Booked_Rev > 0
			AND RS.LoadDate >= '2019-01-01'
		GROUP BY t.Opportunity
			,t.First_Seen_Date
			,t.Last_Seen_Date
			,t.Qtr

		IF OBJECT_ID('tempdb..#tempBookedOppsClosedRev') IS NOT NULL
			  DROP TABLE #tempBookedOppsClosedRev
		--revenue at the time of booked
		SELECT t.Opportunity
			,rs.Opportunity_Line
			,rs.CPG_Name
			,rs.Product_Name
			,t.Closed_Date
			,t.First_Seen_Date
			,t.Last_Seen_Date
			,t.Won_Lost
			,rs.Qtr
			,SUM(rs.Booked_rev) AS Closed_Rev
			,SUM(rs.Booked_Rev) AS Latest_Rev
		INTO #tempBookedOppsClosedRev
		FROM #tempBookedDates t
			INNER JOIN SalesReporting..RevenueScheduleSummary rs WITH (NOLOCK)
				ON t.Opportunity = rs.Opportunity
					AND t.Last_Seen_Date = rs.LoadDate
					AND t.Qtr = rs.Qtr
		WHERE RS.LoadDate = CAST(GETDATE() AS DATE)
			AND RS.BOOKED_REV > 0
		GROUP BY t.Opportunity
			,rs.Opportunity_Line
			,rs.CPG_Name
			,rs.Product_Name
			,t.Closed_Date
			,t.First_Seen_Date
			,t.Last_Seen_Date
			,t.Won_Lost
			,rs.Qtr
			
		IF OBJECT_ID('tempdb..#tempLostOppsDates') IS NOT NULL
			  DROP TABLE #tempLostOppsDates   
		--table of the lost opportunites
		SELECT DISTINCT Opportunity
			,Qtr
			,Last_Seen_Date AS Closed_Date
			,'Lost' AS Won_Lost
			,First_Seen_Date
			,Last_Seen_Date
		INTO #tempLostOppsDates
		FROM #tempFirstLastDates
		WHERE Last_Seen_Date < CAST(GETDATE() AS DATE) 
			AND Opportunity NOT IN (SELECT DISTINCT Opportunity FROM #tempBookedDates)

		IF OBJECT_ID('tempdb..#tempLostOpps') IS NOT NULL
			  DROP TABLE #tempLostOpps
		--Lost Opportunities with their final revenue
		SELECT t.Opportunity
			,rs.Opportunity_Line
			,rs.CPG_Name
			,rs.Product_Name
			,t.Closed_Date
			,t.First_Seen_Date
			,t.Last_Seen_Date
			,t.Won_Lost
			,rs.Qtr
			,SUM(rs.Gross_Pipe_Rev + rs.BOOKED_REV) AS Closed_Rev
			,SUM(rs.Gross_Pipe_Rev + rs.BOOKED_REV) AS Latest_Rev
		INTO #tempLostOpps
		FROM #tempLostOppsDates t
			INNER JOIN SalesReporting..RevenueScheduleSummary rs WITH (NOLOCK)
				ON t.Opportunity = rs.Opportunity
					AND t.Closed_Date = rs.LoadDate
					AND t.Qtr = rs.Qtr
		WHERE RS.LoadDate >= '2019-01-01'
		GROUP BY  t.Opportunity
			,rs.Opportunity_Line
			,rs.CPG_Name
			,rs.Product_Name
			,t.Closed_Date
			,t.First_Seen_Date
			,t.Last_Seen_Date
			,t.Won_Lost
			,rs.Qtr			
			

		IF OBJECT_ID('tempdb..#tempPipeDates') IS NOT NULL
			DROP TABLE #tempPipeDates
		--table of the booked opportunities
		SELECT t.Opportunity
			,t.Qtr
			,'In Pipe' Won_Lost
			,MIN(rs.loaddate) AS Closed_Date
			,t.First_Seen_Date
			,t.Last_Seen_Date
		INTO #tempPipeDates
		FROM #tempFirstLastDates t
			INNER JOIN SalesReporting..RevenueScheduleSummary rs WITH (NOLOCK)
				ON t.Opportunity = rs.Opportunity
					AND t.Qtr = rs.Qtr
		WHERE (PIPE_REV > 0 OR GROSS_PIPE_REV > 0)
			AND RS.LoadDate >= '2019-01-01'
			AND t.Opportunity NOT IN (SELECT DISTINCT Opportunity FROM #tempLostOpps 
									  UNION 
									  SELECT DISTINCT Opportunity FROM #tempBookedOppsClosedRev)
		GROUP BY t.Opportunity
			,t.First_Seen_Date
			,t.Last_Seen_Date
			,t.Qtr


		IF OBJECT_ID('tempdb..#tempPipeRev') IS NOT NULL
			  DROP TABLE #tempPipeRev
		--revenue at the time of booked
		SELECT t.Opportunity
			,rs.Opportunity_Line
			,rs.CPG_Name
			,rs.Product_Name
			,t.Closed_Date
			,t.First_Seen_Date
			,t.Last_Seen_Date
			,t.Won_Lost
			,rs.Qtr
			,SUM(rs.GROSS_PIPE_REV) AS Closed_Rev
			,SUM(rs.GROSS_PIPE_REV) AS Latest_Rev
		INTO #tempPipeRev
		FROM #tempPipeDates t
			INNER JOIN SalesReporting..RevenueScheduleSummary rs WITH (NOLOCK)
				ON t.Opportunity = rs.Opportunity
					AND t.Last_Seen_Date = rs.LoadDate
					AND t.Qtr = rs.Qtr
		WHERE RS.LoadDate >= '2019-01-01'
			AND (PIPE_REV > 0 OR GROSS_PIPE_REV > 0)
		GROUP BY t.Opportunity
			,rs.Opportunity_Line
			,rs.CPG_Name
			,rs.Product_Name
			,t.Closed_Date
			,t.First_Seen_Date
			,t.Last_Seen_Date
			,t.Won_Lost
			,rs.Qtr


		IF OBJECT_ID('tempdb..#tempClosedOpps') IS NOT NULL
			DROP TABLE #tempClosedOpps
		--combine Booked with Lost
		SELECT Opportunity ,Opportunity_Line ,CPG_Name ,Product_Name ,Closed_Date ,First_Seen_Date ,Last_Seen_Date ,Won_Lost ,Qtr ,Closed_Rev ,Latest_Rev
		INTO #tempClosedOpps 
		FROM (
			SELECT Opportunity ,Opportunity_Line ,CPG_Name ,Product_Name ,Closed_Date ,First_Seen_Date ,Last_Seen_Date ,Won_Lost ,Qtr ,Closed_Rev ,Latest_Rev FROM #tempLostOpps
			UNION ALL
			SELECT Opportunity ,Opportunity_Line ,CPG_Name ,Product_Name ,Closed_Date ,First_Seen_Date ,Last_Seen_Date ,Won_Lost ,Qtr ,Closed_Rev ,Latest_Rev FROM #tempBookedOppsClosedRev
			UNION ALL
			SELECT Opportunity ,Opportunity_Line ,CPG_Name ,Product_Name ,Closed_Date ,First_Seen_Date ,Last_Seen_Date ,Won_Lost ,Qtr ,Closed_Rev ,Latest_Rev FROM #tempPipeRev
			) AS tmp


		IF OBJECT_ID('tempdb..#tempMaster') IS NOT NULL
			  DROP TABLE #tempMaster
		--add region and rep info
		SELECT t.Opportunity
			,t.Opportunity_Line
			,OPL.OpportunityID
			,OPL.OpportunityLineID
			,t.CPG_Name
			,t.Product_Name
			,t.Closed_Date
			,t.First_Seen_Date
			,t.Last_Seen_Date
			,t.Won_Lost
			,t.Qtr
			,t.Closed_Rev
			,t.Latest_Rev
			,DATEDIFF(dd, t.First_Seen_Date, t.Closed_Date)+1 Time_to_Close
			,OPL.Core_Vertical
			,OPL.Core_Manager
			,OPL.Core_SE
			,CASE WHEN DATEDIFF(dd, t.Closed_Date, CAST(GETDATE() AS DATE)) < 30 THEN 1 END AS 'ClosedP30d'
			,CASE WHEN DATEDIFF(dd, t.First_Seen_Date, CAST(GETDATE() AS DATE)) < 30 THEN 1 END AS 'CreatedP30d'
			,CAST(GETDATE() AS DATE) AS LoadDate
		INTO #tempMaster
		FROM #tempClosedOpps t
			LEFT JOIN SalesReporting..DimOpportunityLine OPL
				ON t.opportunity = opl.Opportunity
					AND t.Opportunity_Line = opl.OpportunityLine
		
		
		TRUNCATE TABLE MSTRReportingDB.dbo.OpportunityMaster
		INSERT INTO MSTRReportingDB.dbo.OpportunityMaster  
		SELECT Opportunity
			,Opportunity_Line
			,OpportunityID
			,OpportunityLineID
			,CPG_Name
			,Product_Name
			,Closed_Date
			,First_Seen_Date
			,Last_Seen_Date
			,Won_Lost
			,Qtr
			,Closed_Rev
			,Latest_Rev
			,Time_to_Close
			,Core_Vertical
			,Core_Manager
			,Core_SE
			,[ClosedP30d]
			,[CreatedP30d]
			,LoadDate 
		FROM #tempMaster
		WHERE (OpportunityID IS NOT NULL AND OpportunityLineID IS NOT NULL)
			AND Opportunity NOT IN (SELECT Distinct Opportunity FROM #tempMaster WHERE Won_Lost = 'Lost' AND Product_Name LIKE '%Dummy Product%')




END



