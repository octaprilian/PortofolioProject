-- Changing date format

Select *
From dbo.DataSales

Select InvoiceDate, CONVERT (Date,InvoiceDate)
From dbo.DataSales

Update dbo.DataSales
SET InvoiceDate = CONVERT (Date,InvoiceDate)

ALTER TABLE dbo.DataSales
Add InvoiceDateConvert Date;

Update dbo.DataSales
SET InvoiceDateConvert = CONVERT (Date,InvoiceDate)

--- Filling Description by looking the corellation in StockCode Coloumn

Select StockCode, Description
From dbo.DataSales
WHERE Description is NULL

Select StockCode, Description
From dbo.DataSales
WHERE StockCode = 'DCGS0071'

Select a.StockCode, a.Description, b.StockCode, b.Description, ISNULL (a.Description, b.Description)
From dbo.DataSales a
JOIN dbo.DataSales b
	on a.StockCode = b.StockCode
Where a.Description is NULL

Update a
SET Description =  ISNULL (a.Description, b.Description)
From dbo.DataSales a
JOIN dbo.DataSales b
	on a.StockCode = b.StockCode
Where a.Description is NULL

UPDATE dbo.DataSales
SET Description = (
    SELECT TOP 1 Description
    FROM dbo.DataSales b
    WHERE b.StockCode = dbo.DataSales.StockCode
          AND b.Description IS NOT NULL
		  )
WHERE Description IS NULL;


--- Deleting Duplicate

SELECT InvoiceNo, 
		StockCode, 
		Quantity, 
		InvoiceDateConvert, 
		UnitPrice, 
		CustomerID, 
		COUNT(*) as JumlahDuplikat
FROM dbo.DataSales
GROUP BY InvoiceNo,StockCode, Quantity, InvoiceDateConvert, UnitPrice, CustomerID
HAVING COUNT(*) > 1

WITH CTE AS (
    SELECT InvoiceNo, 
			StockCode, 
			Quantity, 
			InvoiceDateConvert, 
			UnitPrice, 
			CustomerID,
           ROW_NUMBER() OVER (PARTITION BY InvoiceNo, StockCode, Quantity, InvoiceDateConvert, UnitPrice, CustomerID ORDER BY (SELECT NULL)) AS RowNum
    FROM dbo.DataSales
)
DELETE FROM CTE WHERE RowNum > 1;

-- Deleting NULL 

Select *
From dbo.DataSales

Select InvoiceNo,
		Quantity, 
		UnitPrice, 
		CustomerID
From dbo.DataSales
Where InvoiceNo <0 
	  OR Quantity <0 
	  OR UnitPrice <0 
	  OR CustomerID <0

Select InvoiceNo, 
	   Quantity, 
	   UnitPrice, 
	   CustomerID
From dbo.DataSales
Where InvoiceNo IS NULL AND Quantity >0 

Select *
From dbo.DataSales
Where CustomerID IS NULL

Select *
From dbo.DataSales
Where InvoiceDate IS NULL

DELETE FROM dbo.DataSales
Where CustomerID IS NULL
	OR Quantity < 0
	OR QUantity IS NULL
	OR UnitPrice < 0
	OR UnitPrice IS NULL
	OR InvoiceDate IS NULL

-- Checking outliers

Select *
From dbo.DataSales

Select Min (InvoiceDateConvert),
	   Max (InvoiceDateConvert)
From dbo.DataSales

Select Min (Quantity),
	   Max (Quantity)
From dbo.DataSales