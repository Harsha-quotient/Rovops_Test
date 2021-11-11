﻿





CREATE VIEW [dbo].[vDimYear]
AS

SELECT DISTINCT YEAR_ID
	,YEAR_START
	,YEAR_END
	,LAST_YEAR_ID 
FROM MSTRReportingDB.DBO.MDM_DAY_DIM WITH (NOLOCK)
WHERE DATE_ID >= 20160101 AND DATE_ID < 20230101




