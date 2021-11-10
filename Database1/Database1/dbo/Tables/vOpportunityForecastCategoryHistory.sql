CREATE TABLE [dbo].[vOpportunityForecastCategoryHistory] (
    [Opportunity]      NVARCHAR (30) NULL,
    [ForecastCategory] VARCHAR (100) NULL,
    [LoadDate]         DATETIME2 (7) NULL,
    [OpportunityID]    VARCHAR (20)  NOT NULL
);

