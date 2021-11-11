


CREATE VIEW [dbo].[vDimProductType]
AS
SELECT ProductType_ID
	,ProductType
	, ProductCategory

FROM SalesReporting.dbo.DimProductType WITH (NOLOCK)


