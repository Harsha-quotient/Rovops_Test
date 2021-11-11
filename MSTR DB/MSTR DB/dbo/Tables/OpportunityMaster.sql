CREATE TABLE [dbo].[OpportunityMaster] (
    [Opportunity]       VARCHAR (30)    NULL,
    [Opportunity_Line]  NUMERIC (18)    NULL,
    [OpportunityID]     NVARCHAR (18)   NULL,
    [OpportunityLineID] NVARCHAR (18)   NULL,
    [CPG_Name]          NVARCHAR (510)  NULL,
    [Product_Name]      NVARCHAR (255)  NULL,
    [Closed_Date]       DATETIME2 (7)   NULL,
    [First_Seen_Date]   DATETIME2 (7)   NULL,
    [Last_Seen_Date]    DATETIME2 (7)   NULL,
    [Won_Lost]          VARCHAR (10)    NULL,
    [Qtr]               VARCHAR (8)     NULL,
    [Closed_Rev]        NUMERIC (38, 2) NULL,
    [Latest_Rev]        NUMERIC (38, 2) NULL,
    [Time_to_Close]     INT             NULL,
    [Core_Vertical]     VARCHAR (50)    NULL,
    [Core_Manager]      VARCHAR (50)    NULL,
    [Core_SE]           VARCHAR (100)   NULL,
    [ClosedP30d]        INT             NULL,
    [CreatedP30d]       INT             NULL,
    [LoadDate]          DATE            NULL
);

