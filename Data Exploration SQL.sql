Select *
From dbo.Marketingdata

-- Menambahkan kolom age ke tabel
	ALTER TABLE dbo.Marketingdata
	ADD age INT;

-- Menambahkan data ke kolom age yang baru
	UPDATE dbo.Marketingdata
	SET age = CASE WHEN MONTH(Dt_Customer) > MONTH(GETDATE()) OR 
                    (MONTH(Dt_Customer) = MONTH(GETDATE()) AND DAY(Dt_Customer) > DAY(GETDATE()))
               THEN YEAR(GETDATE()) - Year_Birth - 1
               ELSE YEAR(GETDATE()) - Year_Birth END;

-- Menghitung total response dan perecntage response
	SELECT SUM(CAST(response AS INT)) AS total_responded
			SUM(CAST(response AS INT)) * 100.0 / COUNT(*) AS percentage_response
	From dbo.Marketingdata

-- Distribusi respon terhadap education

	SELECT Education, COUNT (*) AS Total_education,
       SUM(CAST(response AS INT)) AS total_response,
       SUM(CAST(response AS INT)) * 100.0 / COUNT(*) AS percentage_response
	FROM dbo.Marketingdata
	GROUP BY Education;

--Distribusi respon terhadap income
	Select MAX (Income), MIN (Income)
	From dbo.Marketingdata

	SELECT 
		CASE 
		WHEN Income BETWEEN 1000 AND 10000 THEN '1000-10000' 
		WHEN Income BETWEEN 10000 AND 20000 THEN '10000-20000'
		WHEN Income BETWEEN 20000 AND 30000 THEN '20000-30000'
		WHEN Income BETWEEN 30000 AND 40000 THEN '30000-40000'
		WHEN Income BETWEEN 40000 AND 50000 THEN '40000-50000'
		WHEN Income > 50000 THEN '>500000'
		END AS Income_group,
		COUNT (*) AS Frequency_income,
		SUM(CAST(response AS INT)) AS total_response,
        SUM(CAST(response AS INT)) * 100.0 / COUNT(*) AS percentage_response
	FROM dbo.Marketingdata
	Group by 
		CASE 
		WHEN Income BETWEEN 1000 AND 10000 THEN '1000-10000' 
		WHEN Income BETWEEN 10000 AND 20000 THEN '10000-20000'
		WHEN Income BETWEEN 20000 AND 30000 THEN '20000-30000'
		WHEN Income BETWEEN 30000 AND 40000 THEN '30000-40000'
		WHEN Income BETWEEN 40000 AND 50000 THEN '40000-50000'
		WHEN Income > 50000 THEN '>500000'
		END
	Order by Income_group ASC

-- Distribusi respon terhadap kelompok umur
	SELECT 
		CASE 
		WHEN age BETWEEN 10 AND 20 THEN '10-20' 
		WHEN age BETWEEN 20 AND 30 THEN '20-30'
		WHEN age BETWEEN 30 AND 40 THEN '30-40'
		WHEN age BETWEEN 40 AND 50 THEN '40-50'
		WHEN age >50 THEN '>50'
		END AS age_group,
		COUNT (*) AS Total_age,
		SUM(CAST(response AS INT)) AS total_response,
        SUM(CAST(response AS INT)) * 100.0 / COUNT(*) AS percentage_response
	FROM dbo.Marketingdata
	Group by 
		CASE 
			WHEN age BETWEEN 10 AND 20 THEN '10-20' 
			WHEN age BETWEEN 20 AND 30 THEN '20-30'
			WHEN age BETWEEN 30 AND 40 THEN '30-40'
			WHEN age BETWEEN 40 AND 50 THEN '40-50'
			WHEN age > 50 THEN '>50'
		END;

-- Distribusi respon terhadap status perkawinan
	SELECT Marital_status, COUNT (*) AS Total,
       SUM(CAST(response AS INT)) AS total_response,
       SUM(CAST(response AS INT)) * 100.0 / COUNT(*) AS percentage_response
	FROM dbo.Marketingdata
	GROUP BY Marital_status;

--Ubah nama kolom Number of Kids menjadi Num_kids
	EXEC sp_rename 'dbo.Marketingdata.[Number of Kids]', 'Num_kids', 'COLUMN';

-- Distribusi respon terhadap jumlah anak
	SELECT Num_kids, COUNT (*) AS Frequency,
       SUM(CAST(response AS INT)) AS total_response,
       SUM(CAST(response AS INT)) * 100.0 / COUNT(*) AS percentage_response
	FROM dbo.Marketingdata
	Group by Num_kids
	Order by Num_kids ASC

--Distribusi respon terhadap recency
	SELECT 
		CASE 
		WHEN Recency BETWEEN 0 AND 30 THEN '1 Month' 
		WHEN Recency BETWEEN 30 AND 60 THEN '2 Month'
		WHEN Recency BETWEEN 60 AND 90 THEN '3 Month'
		WHEN Recency >90 THEN '>3 Month'
		END AS Recency_group,
		COUNT (*) AS Total_recency,
		SUM(CAST(response AS INT)) AS total_response,
        SUM(CAST(response AS INT)) * 100.0 / COUNT(*) AS percentage_response
	FROM dbo.Marketingdata
	Group by 
		CASE  
		WHEN Recency BETWEEN 0 AND 30 THEN '1 Month' 
		WHEN Recency BETWEEN 30 AND 60 THEN '2 Month'
		WHEN Recency BETWEEN 60 AND 90 THEN '3 Month'
		WHEN Recency >90 THEN '>3 Month'
		END
	Order by Recency_group ASC;

--Produk yang paling banyak dibeli selama 2 tahun

	SELECT SUM (MntWines) AS FreqWines,
		   SUM (MntFruits) AS FreqFruits,
		   SUM (MntMeatProducts) AS FreqMeat,
		   SUM (MntFishProducts) AS FreqFish,
		   SUM (MntSweetProducts) AS FreqSweetProducts,
		   SUM (MntGoldProds) AS FreqGold
	FROM dbo.Marketingdata

-- Platform purchase yang paling disenangi
	
	SELECT SUM (NumDealsPurchases) AS FreqDisc,
			SUM (NumWebPurchases) AS FreqWeb,
			SUM (NumCatalogPurchases) AS FreqCatalog,
			SUM (NUmStorePurchases) AS FreqStore,
			SUM (NumWebVisitsMonth) AS FreqWebVisits
	FROM dbo.Marketingdata

--Campaign yang paling banyak dipilih penawaran nya
	
	SELECT SUM(CAST(AcceptedCmp1 AS INT)) AS FreqCamp1,
		SUM(CAST(AcceptedCmp2 AS INT)) AS FreqCamp2,
		SUM(CAST(AcceptedCmp3 AS INT)) AS FreqCamp3,
		SUM(CAST(AcceptedCmp4 AS INT)) AS FreqCamp4,
		SUM(CAST(AcceptedCmp5 AS INT)) AS FreqCamp5
	FROM dbo.Marketingdata
	










