CREATE TABLE [dbo].[FactTargets_2021] (
    [AccountID]      VARCHAR (50)    NULL,
    [DivisionID]     VARCHAR (50)    NULL,
    [RetailerID]     INT             NULL,
    [ProductType_ID] INT             NULL,
    [Quota]          NUMERIC (22, 6) NULL,
    [TargetMonth_ID] BIGINT          NULL,
    [LoadDateID]     BIGINT          NOT NULL
);


GO
CREATE CLUSTERED INDEX [IX_LoadDateID_2021]
    ON [dbo].[FactTargets_2021]([LoadDateID] ASC);

