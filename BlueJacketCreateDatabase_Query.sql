CREATE DATABASE BlueJacket

USE BlueJacket

CREATE TABLE MsCustomer (
	CustomerID CHAR(5) PRIMARY KEY CHECK (CustomerID LIKE 'MC[0-9][0-9][0-9]'),
	CustomerName VARCHAR(100) NOT NULL,
	CustomerGender VARCHAR(10) CHECK (CustomerGender IN ('Male', 'Female')),
	CustomerAddress VARCHAR(50) CHECK (CustomerAddress LIKE '% Street%'),
	CustomerPhone VARCHAR(13) CHECK (CustomerPhone NOT LIKE '%[^0-9a-zA-Z @.-]%' AND CustomerPhone NOT LIKE'%[A-Z]%')
)

CREATE TABLE MsStaff (
	StaffID CHAR(5) PRIMARY KEY CHECK (StaffID LIKE 'MS[0-9][0-9][0-9]'),
	StaffName  VARCHAR(100) NOT NULL,
	StaffGender VARCHAR(10) CHECK (StaffGender IN ('Male', 'Female')),
	StaffEmail VARCHAR(50) NOT NULL,
	StaffPhone VARCHAR(13) CHECK (StaffPhone NOT LIKE '%[^0-9a-zA-Z @.-]%' AND StaffPhone NOT LIKE'%[A-Z]%'),
	StaffSalary INTEGER CHECK (StaffSalary BETWEEN 4000000 AND 100000000)
)

CREATE TABLE MsVendor (
	VendorID CHAR(5) PRIMARY KEY CHECK (VendorID LIKE 'MV[0-9][0-9][0-9]'),
	VendorName VARCHAR(100) NOT NULL,
	VendorEmail VARCHAR(50) NOT NULL,
	VendorPhone VARCHAR(13) CHECK (VendorPhone NOT LIKE '%[^0-9a-zA-Z @.-]%' AND VendorPhone NOT LIKE'%[A-Z]%'),
	VendorAddress VARCHAR(50) NOT NULL
)

CREATE TABLE MsJacketType (
	JacketTypeID CHAR(5) PRIMARY KEY CHECK (JacketTypeID LIKE 'JT[0-9][0-9][0-9]'),
	JacketTypeName VARCHAR(50) NOT NULL
)

CREATE TABLE MsJacketBrand (
	JacketBrandID CHAR(5) PRIMARY KEY CHECK (JacketBrandID LIKE 'JB[0-9][0-9][0-9]'),
	JacketBrandName VARCHAR(50) NOT NULL
)

CREATE TABLE MsJacket (
	JacketID CHAR(5) PRIMARY KEY CHECK (JacketID LIKE 'MJ[0-9][0-9][0-9]'),
	PurchasePrice INTEGER CHECK (PurchasePrice BETWEEN 0 AND 500000000),
	SalesPrice INTEGER CHECK (SalesPrice BETWEEN 0 AND 500000000),
	Stock INTEGER CHECK (Stock BETWEEN 0 AND 1000),
	JacketTypeID CHAR(5) REFERENCES MsJacketType(JacketTypeID) CHECK (JacketTypeID LIKE 'JT[0-9][0-9][0-9]'),
	JacketBrandID CHAR(5) REFERENCES MsJacketBrand(JacketBrandID) CHECK (JacketBrandID LIKE 'JB[0-9][0-9][0-9]'),
)

CREATE TABLE SalesHeader (
	SalesID CHAR(5) PRIMARY KEY CHECK (SalesID LIKE 'SH[0-9][0-9][0-9]'),
	StaffID CHAR(5) REFERENCES MsStaff(StaffID) CHECK (StaffID LIKE 'MS[0-9][0-9][0-9]'),
	CustomerID CHAR(5) REFERENCES MsCustomer(CustomerID) CHECK (CustomerID LIKE 'MC[0-9][0-9][0-9]'),
	SalesDate DATE CHECK (DATENAME(WEEKDAY, SalesDate) != 'Sunday' )
)

CREATE TABLE SalesDetailTransaction (
	SalesID CHAR(5) REFERENCES SalesHeader(SalesID) CHECK (SalesID LIKE 'SH[0-9][0-9][0-9]'),
	JacketID CHAR(5) REFERENCES MsJacket(JacketID) CHECK (JacketID LIKE 'MJ[0-9][0-9][0-9]'),
	SalesQuantity INTEGER CHECK (SalesQuantity BETWEEN 0 AND 100),
	PRIMARY KEY(SalesID, JacketID)
)

CREATE TABLE PurchaseHeader (
	PurchaseID CHAR(5) PRIMARY KEY CHECK (PurchaseID LIKE 'PH[0-9][0-9][0-9]'),
	StaffID CHAR(5) REFERENCES MsStaff(StaffID) CHECK (StaffID LIKE 'MS[0-9][0-9][0-9]'),
	VendorID CHAR(5) REFERENCES MsVendor(VendorID) CHECK (VendorID LIKE 'MV[0-9][0-9][0-9]'),
	PurchaseDate DATE CHECK (DATENAME(WEEKDAY, PurchaseDate) != 'Sunday' )
)

CREATE TABLE PurchaseDetailTransaction (
	PurchaseID CHAR(5) REFERENCES PurchaseHeader(PurchaseID) CHECK (PurchaseID LIKE 'PH[0-9][0-9][0-9]'),
	JacketID CHAR(5) REFERENCES MsJacket(JacketID) CHECK (JacketID LIKE 'MJ[0-9][0-9][0-9]'),
	PurchaseQuantity INTEGER CHECK (PurchaseQuantity BETWEEN 0 AND 100),
	PRIMARY KEY(PurchaseID, JacketID)
)