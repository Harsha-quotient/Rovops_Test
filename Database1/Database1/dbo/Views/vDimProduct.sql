


 
CREATE VIEW [dbo].[vDimProduct]
AS

SELECT [ProductID]
      ,[Product_Name]
      ,[GL_Description]
      ,[Product_Category]
      ,[RevenueCategory]
      ,[ProductLine]
      ,[SubProdcut]
      ,[ServiceType]
      ,[ProductFamily]
      ,[ProductType_2020] AS [ProductType]
      ,[ForecastCategory]
      ,[IsActive]
      ,[ProductType_ID]
FROM [SalesReporting].[dbo].[DimProduct] WITH (NOLOCK) 


















