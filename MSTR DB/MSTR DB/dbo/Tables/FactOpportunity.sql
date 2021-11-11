CREATE TABLE [dbo].[FactOpportunity] (
    [OpportunityID]     NVARCHAR (18)   NULL,
    [OpportunityLineID] NVARCHAR (18)   NULL,
    [Closed_rev]        NUMERIC (38, 6) NULL,
    [Latest_Rev]        NUMERIC (38, 6) NULL,
    [OpportunityDate]   VARCHAR (10)    NULL,
    [qtr]               VARCHAR (8)     NULL,
    [LoadDate]          DATE            NULL,
    [LoadDateID]        BIGINT          NULL
);

