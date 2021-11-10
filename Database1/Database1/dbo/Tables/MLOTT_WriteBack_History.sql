CREATE TABLE [dbo].[MLOTT_WriteBack_History] (
    [OpportunityID]     VARCHAR (20)  NULL,
    [OpportunityLineID] VARCHAR (20)  NULL,
    [Notes]             VARCHAR (MAX) NULL,
    [MLOTT_LoadDateID]  INT           NULL,
    [LastUpdatedDate]   DATETIME      NULL,
    [MLOTT_Activity]    VARCHAR (100) NULL
);

