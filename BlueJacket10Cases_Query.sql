USE BlueJacket
GO

--1
SELECT
	MS.StaffID,
	StaffName,
	[TotalJacketSold] = SUM(SalesQuantity)
FROM MsStaff MS JOIN SalesHeader SH
ON MS.StaffID = SH.StaffID JOIN MsCustomer MC
ON SH.CustomerID = MC.CustomerID JOIN SalesDetailTransaction SDT
ON SH.SalesID = SDT.SalesID
WHERE CustomerGender LIKE 'Male' AND
DATENAME(MONTH,SalesDate) LIKE 'February'
GROUP BY MS.StaffID, StaffName
GO

--2
SELECT
	MS.StaffID,
	StaffName,
	VendorName,
	[TotalTransaction] = COUNT(PurchaseID)
FROM MsStaff MS JOIN PurchaseHeader PH
ON MS.StaffID = PH.StaffID
JOIN MsVendor MV ON MV.VendorID = PH.VendorID
WHERE DATENAME(WEEKDAY,PurchaseDate) LIKE 'Monday' AND
StaffGender LIKE 'Female'
GROUP BY MS.StaffID, StaffName, VendorName
GO

--3
SELECT 
	MV.VendorID,
	VendorName,
	VendorEmail,
	[TotalJacketPurchased]= SUM(PurchaseQuantity)
FROM MsVendor MV JOIN PurchaseHeader PH
ON MV.VendorID = PH.VendorID
JOIN PurchaseDetailTransaction PDT
ON PH.PurchaseID = PDT.PurchaseID
WHERE DATENAME(WEEKDAY,PurchaseDate) LIKE 'Tuesday' AND
DATEDIFF(MONTH, PurchaseDate, '2022-06-22') > 3
GROUP BY MV.VendorID, VendorName, VendorEmail
GO

--4 
SELECT
	MS.StaffID,
	StaffName,
	[TotalJacketSold] = SUM(SalesQuantity)
FROM MsStaff MS JOIN SalesHeader SH
ON MS.StaffID = SH.StaffID JOIN SalesDetailTransaction SDT
ON SH.SalesID = SDT.SalesID
WHERE DATEDIFF(MONTH, SalesDate, '2022-06-22') > 6
GROUP BY MS.StaffID, StaffName
HAVING COUNT(SH.SalesID) >= 3
GO

--5
SELECT
	StaffName = LEFT(StaffName, CHARINDEX(' ', StaffName)),
	StaffSalary,
	VendorName,
	[Year] = YEAR(PurchaseDate)
FROM MsStaff MS, MsVendor MV, PurchaseHeader PH,
(SELECT SALARY = AVG(StaffSalary) FROM MsStaff) AS AVERAGE
WHERE MS.StaffID = PH.StaffID AND MV.VendorID = PH.VendorID
AND YEAR(PurchaseDate) = 2021 AND StaffSalary > AVERAGE.SALARY
GO

--6 
SELECT
	StaffName,
	StaffPhone = STUFF(StaffPhone,1,1,'+62'),
	CustomerName,
	SalesDate
FROM MsStaff MS, MsCustomer MC, SalesHeader SH,
(SELECT SALARY = MIN(StaffSalary) FROM MsStaff) AS MINIMUM
WHERE MS.StaffID = SH.StaffID AND SH.CustomerID = MC.CustomerID
AND DATENAME(MONTH, SalesDate) = 'May' AND StaffSalary = MINIMUM.SALARY
GO

--7
SELECT 
	CustomerName,
	CustomerGender,
	CustomerAddress,
	[TotalSalesPrice] = 'Rp.'+ CAST(SUM(SalesPrice*SalesQuantity) AS VARCHAR)
FROM MsCustomer MC,MsJacket MJ, SalesHeader SH, SalesDetailTransaction SDT,
(SELECT JACKET = MAX(SalesQuantity) FROM SalesDetailTransaction) AS MAXIMUM
WHERE MC.CustomerID = SH.CustomerID AND
SH.SalesID = SDT.SalesID AND SDT.JacketID = MJ.JacketID 
AND DATENAME(MONTH, SalesDate) NOT LIKE 'March' AND
SalesQuantity = MAXIMUM.JACKET
GROUP BY CustomerName, CustomerGender, CustomerAddress
GO

--8 (BELUM ADA DATA)
SELECT
	PH.PurchaseID,
	PurchaseDate,
	MS.StaffID,
	StaffName = LEFT(StaffName, CHARINDEX(' ', StaffName)),
	StaffEmail
FROM PurchaseHeader PH, MsStaff MS, PurchaseDetailTransaction PDT,
(SELECT [JacketPurchased]= MIN(PurchaseQuantity)
FROM PurchaseDetailTransaction) AS TOTAL
WHERE PH.StaffID = MS.StaffID AND PH.PurchaseID = PDT.PurchaseID AND
DATENAME(WEEKDAY, PurchaseDate) LIKE 'Monday' 
GROUP BY PH.PurchaseID, MS.StaffID, PurchaseDate, StaffName, StaffEmail, PurchaseQuantity, TOTAL.JacketPurchased
HAVING PurchaseQuantity =  TOTAL.JacketPurchased
GO

--9 
CREATE VIEW JacketPurchase 
AS
SELECT
	PH.PurchaseID,
	PurchaseMonth = DATENAME(MONTH, PurchaseDate),
	TotalJacketBrand = COUNT(MJB.JacketBrandID),
	TotalPurchasePrice = SUM(PurchasePrice*PurchaseQuantity)
FROM PurchaseHeader PH, 
MsJacketBrand MJB, 
MsJacket MJ, 
PurchaseDetailTransaction PDT
WHERE PH.PurchaseID = PDT.PurchaseID AND PDT.JacketID = MJ.JacketID
AND MJ.JacketBrandID = MJB.JacketBrandID AND
MONTH(PurchaseDate) = 6
GROUP BY PH.PurchaseID, PurchaseDate
HAVING SUM(PurchasePrice*PurchaseQuantity) > 5000000
GO

--10
CREATE VIEW JacketSales
AS
SELECT
	SH.SalesID,
	SalesDate  = CONVERT(VARCHAR,SalesDate,107),
	TotalJacketType = COUNT(MJT.JacketTypeID),
	TotalSalesPrice = 'Rp. ' + CAST(SUM(SalesPrice*SalesQuantity) AS VARCHAR)
FROM SalesHeader SH JOIN SalesDetailTransaction SDT 
ON SH.SalesID = SDT.SalesID JOIN MsJacket MJ 
ON SDT.JacketID = MJ.JacketID JOIN MsJacketType MJT
ON MJ.JacketTypeID = MJT.JacketTypeID
WHERE MONTH(SalesDate) = 7 AND
DATENAME(WEEKDAY,SalesDate) NOT LIKE 'Friday'
GROUP BY SH.SalesID, SalesDate