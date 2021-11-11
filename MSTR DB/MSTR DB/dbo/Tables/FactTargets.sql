CREATE TABLE [dbo].[FactTargets] (
    [AccountID]      VARCHAR (50)    NULL,
    [DivisionID]     VARCHAR (50)    NULL,
    [RetailerID]     INT             NULL,
    [ProductType_ID] INT             NULL,
    [Quota]          NUMERIC (22, 6) NULL,
    [TargetMonth_ID] BIGINT          NULL,
    [LoadDateID]     BIGINT          NOT NULL
);


GO
CREATE CLUSTERED INDEX [IX_MSTRReportingDB_LoadDateID]
    ON [dbo].[FactTargets]([LoadDateID] ASC);

