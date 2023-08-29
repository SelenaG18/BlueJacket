USE BlueJacket

--We purchase some Jacket
INSERT INTO PurchaseHeader
VALUES	('PH022','MS005','MV011','2022-06-17')

INSERT INTO PurchaseDetailTransaction
VALUES	('PH022','MJ017',4),
		('PH022','MJ023',6),
		('PH022','MJ031',12),
		('PH022','MJ036',10),
		('PH022','MJ039',15)

--Sale some Jacket
INSERT INTO SalesHeader
VALUES	('SH022', 'MS006', 'MC013', '2022-06-09')

INSERT INTO SalesDetailTransaction
VALUES	('SH022','MJ017',16),
		('SH022','MJ018',24),
		('SH022','MJ022',10),
		('SH022','MJ024',33),
		('SH022','MJ029',32),
		('SH022','MJ030',41)

--Update staff data because staff change their email
UPDATE MsStaff
SET StaffEmail = 'Purnomorey25@gmail.com'
WHERE StaffID = 'MS012'

--Delete transaction because customer give a wrong order
DELETE 
FROM SalesDetailTransaction
WHERE SalesID = 'SH022' AND JacketID = 'MJ024'