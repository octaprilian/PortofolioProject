--Grouping sales by Year and Month

Select *
From dbo.DataSales


Select Quantity*UnitPrice AS Sales
From dbo.DataSales

ALTER TABLE dbo.DataSales
Add Sales Float

Update dbo.DataSales
SET Sales = Quantity*UnitPrice

Select YEAR (InvoiceDateConvert) AS Year,
		SUM (Sales) AS TotalSales
From dbo.DataSales
Group by YEAR (InvoiceDateConvert)
Order by Year

Select Month (InvoiceDateConvert) AS Month,
		SUM (Sales) AS TotalSales
From dbo.DataSales
Where Year(InvoiceDateConvert) = '2010'
Group by Month (InvoiceDateConvert)
Order by Month


Select Month (InvoiceDateConvert) AS Month,
		SUM (Sales) AS TotalSales
From dbo.DataSales
Where Year(InvoiceDateConvert) = '2011'
Group by Month (InvoiceDateConvert)
Order by Month(InvoiceDateConvert) ASC

--- Sales by Product

Select Description,
		SUM (Sales) AS TotalSales
From dbo.DataSales
Group by Description
Order by TotalSales DESC

Select Description,
		SUM (Sales) AS TotalSales,
		NTILE (5) OVER (ORDER BY SUM (SALES)) AS Segment
From dbo.DataSales
Group by Description
Order by TotalSales DESC

--- RFM Analysis

Declare @today_date AS DATE = '2012-01-01';

WITH base AS (
	SELECT 
		CustomerID,
		MAX (InvoiceDateConvert) AS Most_Recently_Purchase,
		DATEDIFF (day, MAX (InvoiceDateConvert), @today_date) AS Recency_Score,
		COUNT (InvoiceNo) AS Frequency_Score,
		SUM (Sales) AS Monetary_Score
	FROM dbo.DataSales
	Group by CustomerID
	),

rfm_scores AS (
Select 
	CustomerID,
	Recency_Score,
	Frequency_Score,
	Monetary_Score,
	NTILE (5) OVER (ORDER BY Recency_Score DESC) as R,
	NTILE (5) OVER (ORDER BY Frequency_Score ASC) as F,
	NTILE (5) OVER (ORDER BY Monetary_Score ASC) as M
From base
)

Select *
From rfm_scores