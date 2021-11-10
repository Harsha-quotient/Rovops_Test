






CREATE PROCEDURE [dbo].[usp_LoadClariActivityData] 

AS

BEGIN

IF OBJECT_ID('MSTRReportingDB.dbo.Clari_Email_Activity', 'U') IS NOT NULL 
	DROP TABLE MSTRReportingDB.dbo.Clari_Email_Activity


select [Rep Name]
	,[Rep Email]
	,SUM(CAST(meeting AS INT)) AS meeting
	,SUM(CAST(upcoming_meeting AS INT)) AS upcoming_meeting
	,SUM(CAST(attachment_received AS INT)) AS attachment_received
	,SUM(CAST(attachment_sent AS INT)) AS attachment_sent
	,SUM(CAST(email_sent AS INT)) AS email_sent
	,SUM(CAST(email_received AS INT)) AS email_received
	,[ActivityDate]  
into MSTRReportingDB.dbo.Clari_Email_Activity
from (

	select  [Rep Name],[Rep Email],ActivityDate,meeting,0 as upcoming_meeting, attachment_received,  attachment_sent, email_sent, email_received  
	from
	(
	  select  [Rep Name],[Rep Email],ActivityData, [Activity Type], CAST(ActivityDate AS DATE) AS ActivityDate
	  from  MSTRReportingDB.DBO.Clari_Activity WHERE LoadType='L7D' --'Last7Days'
	) d
	pivot
	(
	  max(ActivityData)
	  for [Activity Type] in (meeting, attachment_received, attachment_sent, email_sent, email_received)
	) piv

	union all

	select [Rep Name],[Rep Email],ActivityDate,0 as  meeting, meeting as upcoming_meeting, attachment_received, attachment_sent, email_sent, email_received  
	from  
	(
	select  [Rep Name],[Rep Email],UPCOMING,[Activity Type] , CAST(ActivityDate AS DATE) AS ActivityDate
	 from  MSTRReportingDB.DBO.Clari_Activity WHERE LoadType='L7D' --'Last7Days'
	) d
	pivot
	(
	max(UPCOMING)
	for  [Activity Type] in (meeting, attachment_received, attachment_sent, email_sent, email_received)
	) piv2
	
	union all
	
	select  [Rep Name],[Rep Email],ActivityDate,meeting,0 as upcoming_meeting, attachment_received,  attachment_sent, email_sent, email_received  
	from
	(
	  select  [Rep Name],[Rep Email],ActivityData, [Activity Type],CAST(ActivityDate AS DATE) AS ActivityDate
	  from  MSTRReportingDB.DBO.Clari_Activity WHERE LoadType='MTD'
	) d
	pivot
	(
	  max(ActivityData)
	  for [Activity Type] in (meeting, attachment_received, attachment_sent, email_sent, email_received)
	) piv

	union all

	select [Rep Name],[Rep Email],ActivityDate, meeting, meeting as upcoming_meeting, attachment_received, attachment_sent, email_sent, email_received  
	from  
	(
	select  [Rep Name],[Rep Email],UPCOMING,[Activity Type] ,CAST(ActivityDate AS DATE) AS ActivityDate
	 from  MSTRReportingDB.DBO.Clari_Activity WHERE LoadType='MTD'
	) d
	pivot
	(
	max(UPCOMING)
	for  [Activity Type] in (meeting, attachment_received, attachment_sent, email_sent, email_received)
	) piv2
	
	union all
	
	select  [Rep Name],[Rep Email],ActivityDate,meeting,0 as upcoming_meeting, attachment_received,  attachment_sent, email_sent, email_received  
	from
	(
	  select  [Rep Name],[Rep Email],ActivityData, [Activity Type],CAST(ActivityDate AS DATE) AS ActivityDate
	  from  MSTRReportingDB.DBO.Clari_Activity WHERE LoadType='QTD'
	) d
	pivot
	(
	  max(ActivityData)
	  for [Activity Type] in (meeting, attachment_received, attachment_sent, email_sent, email_received)
	) piv

	union all

	select [Rep Name],[Rep Email],ActivityDate, meeting, meeting as upcoming_meeting, attachment_received, attachment_sent, email_sent, email_received  
	from  
	(
	select  [Rep Name],[Rep Email],UPCOMING,[Activity Type], CAST(ActivityDate AS DATE) AS ActivityDate
	 from  MSTRReportingDB.DBO.Clari_Activity WHERE LoadType='QTD'
	) d
	pivot
	(
	max(UPCOMING)
	for  [Activity Type] in (meeting, attachment_received, attachment_sent, email_sent, email_received)
	) piv2
	
) A
GROUP BY  [Rep Name]
	,[Rep Email]
	,[ActivityDate]

END







