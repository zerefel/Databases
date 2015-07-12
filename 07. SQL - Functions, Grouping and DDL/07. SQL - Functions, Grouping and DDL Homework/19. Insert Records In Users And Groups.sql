INSERT INTO Groups(Name) VALUES
	('HighQualityCode'),
	('FrontEnd')

DECLARE @Group1 int
SET @Group1 = (SELECT GroupId FROM Groups WHERE Name = 'Database')
DECLARE @Group2 int
SET @Group2 = (SELECT GroupId FROM Groups WHERE Name = 'FrontEnd')

INSERT INTO Users(Username, Password, FullName, LastLoginTime, GroupId) VALUES
	('kiki', '123753445', 'Kichko Ivanov', GETDATE(), @Group1),
	('paca', 'asd127543g', 'Iordan Petrov', '30-Jun-2015' ,@Group2),
	('ivan', '1fh2265233', 'Sasho Kirislavo', GETDATE(), @Group1),
	('pesho', '51259451', 'Stetlin Nakov', '02-May-2015', @Group2)