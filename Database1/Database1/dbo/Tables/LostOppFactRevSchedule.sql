﻿CREATE TABLE [dbo].[LostOppFactRevSchedule] (
    [LostRS_LoadDateID]                  BIGINT          NULL,
    [LostRS_LoadDate]                    DATE            NULL,
    [ID]                                 VARCHAR (20)    NULL,
    [OpportunityID]                      VARCHAR (20)    NOT NULL,
    [OpportunityLineID]                  VARCHAR (100)   NOT NULL,
    [EstimatedRevenueDateID]             BIGINT          NULL,
    [ActualQuantity]                     INT             NULL,
    [DailyAverageActivity]               NUMERIC (18, 2) NULL,
    [DailyExpectedActivity]              NUMERIC (18, 5) NULL,
    [TotalEstimatedRevenue]              NUMERIC (18, 2) NULL,
    [ForecastQuantity]                   NUMERIC (18, 2) NULL,
    [ForecastToDate]                     NUMERIC (18, 2) NULL,
    [ScheduledQuantity]                  BIGINT          NULL,
    [UnRealizedDaysLeft]                 INT             NULL,
    [UnRealizedMonthlyActivityRemaining] NUMERIC (18, 2) NULL,
    [Low_PIPE_REV]                       NUMERIC (18, 2) NULL,
    [High_PIPE_REV]                      NUMERIC (18, 2) NULL,
    [Verbal_PIPE_REV]                    NUMERIC (18, 2) NULL,
    [PIPE_REV]                           NUMERIC (18, 2) NULL,
    [Low_GROSS_PIPE_REV]                 NUMERIC (18, 2) NULL,
    [High_GROSS_PIPE_REV]                NUMERIC (18, 2) NULL,
    [Verbal_GROSS_PIPE_REV]              NUMERIC (18, 2) NULL,
    [GROSS_PIPE_REV]                     NUMERIC (18, 2) NULL,
    [BOOKED_REV_FD]                      NUMERIC (18, 2) NULL,
    [BOOKED_REV_CMP]                     NUMERIC (18, 2) NULL,
    [BOOKED_REV_DEV]                     NUMERIC (18, 2) NULL,
    [BOOKED_REV]                         NUMERIC (18, 2) NULL,
    [TOTAL_LOST_REVENUE]                 NUMERIC (18, 2) NULL
);
