












CREATE VIEW [dbo].[vDimCreated_Date]
AS

SELECT DATE_ID AS CREATE_DATE_ID
	,SHORT_DATE AS CREATE_DATE
	--,CAST(DAY_CAPTION AS DATE) AS EST_REV_DATE
	,MONTH_ID AS CREATE_MONTH_ID
	,WEEK_ID AS CREATE_WEEK_ID
	,DAY_OF_WEEK AS CREATE_DAY_OF_WEEK
	,DAY_OF_WEEK_NUMBER AS CREATE_DAY_OF_WEEK_NUMBER
	,LAST_YEAR_SAME_DAY_ID AS CREATE_LAST_YEAR_SAME_DAY_ID
	--,CAST(SUBSTRING(CONVERT(VARCHAR(8),CAST(DATEADD(YY,-1,DAY_START) AS DATE),112),1,8) AS BIGINT) AS EST_REV_LAST_YEAR_SAME_DAY_ID
	--,CONVERT(DATE,DATEADD(d, -1, DATEADD(q, DATEDIFF(q, 0, DATEADD(YEAR,-1,CAST(DAY_CAPTION AS DATE))) +1, +1))) AS LAST_YEAR_QTR_END_DATE
	,LAST_YEAR_QTR_END_DATE_ID AS CREATE_LAST_YEAR_QTR_END_DATE_ID
	--,CAST(SUBSTRING(CONVERT(VARCHAR(8),CAST(CONVERT(DATE,DATEADD(d, -1, DATEADD(q, DATEDIFF(q, 0, DATEADD(YEAR,-1,CAST(DAY_CAPTION AS DATE))) +1, +1))) AS DATE),112),1,8) AS BIGINT) AS EST_REV_LAST_YEAR_QTR_END_DATE_ID
FROM MSTRReportingDB.DBO.MDM_DAY_DIM WITH (NOLOCK)
WHERE DATE_ID >= 20160101 AND DATE_ID < 20230101


--SELECT DATE_ID AS EST_REV_DATE_ID
--	,CAST(DAY_CAPTION AS DATE) AS EST_REV_DATE
--	,MONTH_ID AS EST_REV_MONTH_ID
--	,WEEK_ID AS EST_REV_WEEK_ID
--	,DAY_OF_WEEK AS EST_REV_DAY_OF_WEEK
--	,DAY_OF_WEEK_NUMBER AS EST_REV_DAY_OF_WEEK_NUMBER
--	,CAST(SUBSTRING(CONVERT(VARCHAR(8),CAST(DATEADD(YY,-1,DAY_START) AS DATE),112),1,8) AS BIGINT) AS EST_REV_LAST_YEAR_SAME_DAY_ID
--	--,CONVERT(DATE,DATEADD(d, -1, DATEADD(q, DATEDIFF(q, 0, DATEADD(YEAR,-1,CAST(DAY_CAPTION AS DATE))) +1, +1))) AS LAST_YEAR_QTR_END_DATE
--	,CAST(SUBSTRING(CONVERT(VARCHAR(8),CAST(CONVERT(DATE,DATEADD(d, -1, DATEADD(q, DATEDIFF(q, 0, DATEADD(YEAR,-1,CAST(DAY_CAPTION AS DATE))) +1, +1))) AS DATE),112),1,8) AS BIGINT) AS EST_REV_LAST_YEAR_QTR_END_DATE_ID
--FROM MSTRReportingDB.DBO.MDM_DAY_DIM 
--WHERE DATE_ID >= 20160101 AND DATE_ID < 20220101










