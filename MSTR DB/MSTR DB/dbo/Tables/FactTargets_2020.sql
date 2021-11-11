CREATE TABLE [dbo].[FactTargets_2020] (
    [AccountID]      VARCHAR (50)    NULL,
    [DivisionID]     VARCHAR (50)    NULL,
    [RetailerID]     INT             NULL,
    [ProductType_ID] INT             NULL,
    [Quota]          NUMERIC (22, 6) NULL,
    [TargetMonth_ID] BIGINT          NULL,
    [LoadDateID]     BIGINT          NOT NULL
);

