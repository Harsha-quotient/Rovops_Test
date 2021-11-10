






CREATE PROCEDURE [dbo].[usp_LoadMasterOpportunity_03182021]

AS

BEGIN

IF OBJECT_ID('tempdb..#tempOpportunitiesList') IS NOT NULL
      DROP TABLE #tempOpportunitiesList


SELECT DISTINCT rs.opportunity
               ,qtr
		INTO #tempOpportunitiesList
		FROM ExternalSourcesNoBackup..RevenueScheduleSummary_Core rs WITH (NOLOCK)
		WHERE qtr in ('2021-01','2021-02','2021-03','2021-04')
		AND LoadDate>='2020-01-01'


IF OBJECT_ID('tempdb..#tempFirstLastDates') IS NOT NULL
      DROP TABLE #tempFirstLastDates

SELECT   #tempOpportunitiesList.opportunity
	    ,#tempOpportunitiesList.qtr
		,min(rs.loaddate) first_seen_date
		,max(rs.loaddate) last_seen_date
		INTO #tempFirstLastDates
		FROM #tempOpportunitiesList
		left join ExternalSourcesNoBackup..RevenueScheduleSummary rs WITH (NOLOCK)
		ON #tempOpportunitiesList.opportunity = rs.opportunity
		WHERE RS.LoadDate>='2020-01-01'
		GROUP BY #tempOpportunitiesList.Opportunity,#tempOpportunitiesList.qtr




IF OBJECT_ID('tempdb..#tempLostOppsDates') IS NOT NULL
      DROP TABLE #tempLostOppsDates   
--table of the lost opportunites
select	opportunity
		,qtr
		,last_seen_date closed_date
		,'Lost' as won_lost
		,first_seen_date
		,last_seen_date
	into #tempLostOppsDates
	from #tempFirstLastDates
	where last_seen_date < cast(getdate() as date) 



IF OBJECT_ID('tempdb..#tempLostOpps') IS NOT NULL
      DROP TABLE #tempLostOpps

--Lost Opportunities with their final revenue

SELECT #tempLostOppsDates.opportunity
		,rs.Opportunity_Line
		,rs.CPG_Name
		,rs.Product_Name
		,#tempLostOppsDates.closed_date
		,#tempLostOppsDates.first_seen_date
		,#tempLostOppsDates.last_seen_date
		,#tempLostOppsDates.won_lost
		,rs.Qtr
		,sum(rs.Gross_Pipe_Rev) closed_rev
		,sum(rs.Gross_Pipe_Rev) latest_rev
		,rs.OpportunityID
		,rs.OpportunityLineID
	INTO #tempLostOpps
	FROM #tempLostOppsDates
	left join ExternalSourcesNoBackup..RevenueScheduleSummary rs WITH (NOLOCK)
		on #tempLostOppsDates.opportunity = rs.opportunity and #tempLostOppsDates.closed_date = rs.loaddate
		and #tempLostOppsDates.Qtr=rs.Qtr
    WHERE RS.LoadDate>='2020-01-01'
	GROUP BY #tempLostOppsDates.opportunity
		,rs.Opportunity
		,rs.Opportunity_Line
		,rs.Product_name
		,rs.CPG_Name
		,#tempLostOppsDates.closed_date
		,#tempLostOppsDates.won_lost
		,rs.Qtr
		,#tempLostOppsDates.first_seen_date
		,#tempLostOppsDates.last_seen_date
			,rs.OpportunityID
		,rs.OpportunityLineID


IF OBJECT_ID('tempdb..#tempBookedDates') IS NOT NULL
      DROP TABLE #tempBookedDates
--table of the booked opportunities

select #tempFirstLastDates.opportunity
,#tempFirstLastDates.Qtr
		,#tempFirstLastDates.first_seen_date
		,#tempFirstLastDates.last_seen_date
		,min(rs.loaddate) closed_date
		,'Won' won_lost
	INTO #tempBookedDates
	FROM #tempFirstLastDates
	left join ExternalSourcesNoBackup..RevenueScheduleSummary rs WITH (NOLOCK)
		on #tempFirstLastDates.opportunity = rs.opportunity
	WHERE rs.Booked_Rev > 0
	AND RS.LoadDate>='2020-01-01'
	group by #tempFirstLastDates.opportunity
		,#tempFirstLastDates.first_seen_date
		,#tempFirstLastDates.last_seen_date
		,#tempFirstLastDates.Qtr


IF OBJECT_ID('tempdb..#tempBookedOppsClosedRev') IS NOT NULL
      DROP TABLE #tempBookedOppsClosedRev
--revenue at the time of booked

select #tempBookedDates.opportunity
		,rs.Opportunity_Line
		,rs.CPG_Name
		,rs.Product_Name
		,#tempBookedDates.closed_date
		,#tempBookedDates.first_seen_date
		,#tempBookedDates.last_seen_date
		,#tempBookedDates.won_lost
		,rs.Qtr
		,sum(rs.Booked_rev) closed_rev
	into #tempBookedOppsClosedRev
	from #tempBookedDates
	left join ExternalSourcesNoBackup..RevenueScheduleSummary rs WITH (NOLOCK)
		on #tempBookedDates.opportunity = rs.opportunity
		and #tempBookedDates.last_seen_date = rs.loaddate
		and #tempBookedDates.Qtr=rs.Qtr
	WHERE RS.LoadDate>='2020-01-01'
	group by #tempBookedDates.opportunity
		,rs.Opportunity_Line
		,rs.Product_Name
		,rs.CPG_Name
		,#tempBookedDates.closed_date
		,#tempBookedDates.first_seen_date
		,#tempBookedDates.last_seen_date
		,#tempBookedDates.won_lost
		,rs.Qtr



IF OBJECT_ID('tempdb..#tempBookedOpps') IS NOT NULL
      DROP TABLE #tempBookedOpps
--Add on latest booked rev

select #tempBookedOppsClosedRev.opportunity
		,#tempBookedOppsClosedRev.Opportunity_Line
		,#tempBookedOppsClosedRev.CPG_Name
		,#tempBookedOppsClosedRev.Product_Name
		,#tempBookedOppsClosedRev.closed_date
		,#tempBookedOppsClosedRev.first_seen_date
		,#tempBookedOppsClosedRev.last_seen_date
		,#tempBookedOppsClosedRev.won_lost
		,#tempBookedOppsClosedRev.Qtr
		,#tempBookedOppsClosedRev.closed_rev
		,sum(rs.Booked_Rev) latest_rev
		,rs.OpportunityID
		,rs.OpportunityLineID
	into #tempBookedOpps
	from #tempBookedOppsClosedRev
	left join ExternalSourcesNoBackup..RevenueScheduleSummary rs WITH (NOLOCK)
		on #tempBookedOppsClosedRev.opportunity = rs.opportunity
		and #tempBookedOppsClosedRev.Opportunity_Line = rs.Opportunity_Line
		and #tempBookedOppsClosedRev.Qtr=rs.Qtr
	where rs.loaddate = cast(getdate() as date) 
	group by #tempBookedOppsClosedRev.opportunity
		,#tempBookedOppsClosedRev.Opportunity_Line
		,#tempBookedOppsClosedRev.Product_Name
		,#tempBookedOppsClosedRev.CPG_Name
		,#tempBookedOppsClosedRev.closed_date
		,#tempBookedOppsClosedRev.first_seen_date
		,#tempBookedOppsClosedRev.last_seen_date
		,#tempBookedOppsClosedRev.won_lost
		,#tempBookedOppsClosedRev.Qtr
		,#tempBookedOppsClosedRev.closed_rev
		,rs.OpportunityID
		,rs.OpportunityLineID


IF OBJECT_ID('tempdb..#tempClosedOpps') IS NOT NULL
      DROP TABLE #tempClosedOpps
--combine Booked with Lost

select * into #tempClosedOpps from (
	select * from #tempLostOpps
	union
	select * from #tempBookedOpps) as tmp

IF OBJECT_ID('tempdb..#tempMaster') IS NOT NULL
      DROP TABLE #tempMaster
--add region and rep info

select #tempClosedOpps.opportunity
		,#tempClosedOpps.Opportunity_Line
		,#tempClosedOpps.OpportunityID
		,#tempClosedOpps.OpportunityLineID
		,#tempClosedOpps.CPG_Name
		,#tempClosedOpps.Product_Name
		,#tempClosedOpps.closed_date
		,#tempClosedOpps.first_seen_date
		,#tempClosedOpps.last_seen_date
		,#tempClosedOpps.won_lost
		,#tempClosedOpps.Qtr
		,#tempClosedOpps.closed_rev
		,#tempClosedOpps.latest_rev
		,datediff(dd, #tempClosedOpps.first_seen_date, #tempClosedOpps.closed_date) time_to_close
		,opl.Core_Vertical
		,opl.Core_Manager
		,opl.Core_SE
		,case when datediff(dd, #tempClosedOpps.closed_date, cast(getdate() as date)) < 30 then 1 end as 'ClosedP30d'
		,case when datediff(dd, #tempClosedOpps.first_seen_date, cast(getdate() as date)) < 30 then 1 end as 'CreatedP30d'
		,CAST(GETDATE() AS DATE) AS LoadDate
	into #tempMaster
	from #tempClosedOpps
	left join SalesReporting..DimOpportunityLine opl
		on #tempClosedOpps.opportunity = opl.Opportunity
		and #tempClosedOpps.Opportunity_Line = opl.OpportunityLine
		


TRUNCATE TABLE MSTRReportingDB.dbo.OpportunityMaster

INSERT INTO MSTRReportingDB.dbo.OpportunityMaster  
SELECT * FROM #tempMaster
		

END





