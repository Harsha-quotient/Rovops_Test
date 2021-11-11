CREATE TABLE [dbo].[FactCSFDaily] (
    [Month_ID]          BIGINT          NULL,
    [Opportunity]       VARCHAR (30)    NULL,
    [OpportunityLine]   INT             NULL,
    [OpportunityID]     VARCHAR (20)    NULL,
    [OpportunityLineID] VARCHAR (100)   NULL,
    [Revenue]           NUMERIC (18, 2) NULL,
    [LoadDateID]        BIGINT          NOT NULL
);

