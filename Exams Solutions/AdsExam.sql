-- Task 1
SELECT Title FROM Ads
ORDER BY TITLE ASC

-- Task 2
SELECT Title, Date FROM Ads
WHERE Date Between '2014-12-26 00:00:00' AND '2015-01-01 23:59:59.00'
ORDER BY Date

-- Task 3
SELECT Title, Date, (CASE WHEN ImageDataURL IS NULL THEN 'no' ELSE 'yes' END) AS [Has Image] FROM Ads AS a
ORDER BY a.Id

-- Task 4
SELECT * FROM Ads
WHERE TownId IS NULL OR CategoryId IS NULL OR ImageDataURL IS NULL
ORDER BY Id

-- Task 5
SELECT a.Title, t.Name AS Town FROM Ads AS a
LEFT JOIN Towns AS t
	ON a.TownId = t.Id
ORDER BY a.Id

-- Task 6
SELECT a.Title, c.Name AS [CategoryName], t.Name AS [TownName], adst.Status FROM Ads AS a
LEFT JOIN Categories AS c
	ON a.CategoryId = c.Id
LEFT JOIN Towns AS t
	ON a.TownId = t.Id
LEFT JOIN AdStatuses AS adst
	ON a.StatusId = adst.Id
ORDER BY a.Id

-- Task 7
SELECT a.Title, c.Name AS [CategoryName], t.Name AS [TownName], adst.Status FROM Ads AS a
JOIN Categories AS c
	ON a.CategoryId = c.Id
JOIN Towns AS t
	ON a.TownId = t.Id
JOIN AdStatuses AS adst
	ON a.StatusId = adst.Id
WHERE t.Name IN ('Sofia', 'Blagoevgrad', 'Stara Zagora') AND adst.Status = 'Published'
ORDER BY a.Title

-- Task 8
SELECT MIN(Date) AS MinDate, MAX(Date) AS MaxDate FROM Ads

-- Task 9
SELECT TOP 10 a.Title, a.Date, adst.Status FROM Ads AS a
JOIN AdStatuses AS adst
	ON a.StatusId = adst.Id
ORDER BY Date DESC

-- Task 10
SELECT a.Id,
	   a.Title,
	   a.Date,
	   adst.Status 
FROM Ads AS a
JOIN AdStatuses AS adst
	ON a.StatusId = adst.Id
WHERE adst.Status <> 'Published'
AND MONTH(a.Date) = (SELECT MONTH(MIN(Date)) FROM Ads)
AND YEAR(a.Date) = (SELECT YEAR(MIN(Date)) FROM Ads)
ORDER BY a.Id

-- Task 11
SELECT adst.Status, COUNT(a.Id) AS Count FROM Ads AS a
JOIN AdStatuses AS adst
	ON a.StatusId = adst.Id
GROUP BY adst.Status


-- Task 12
SELECT t.Name AS [Town Name], adst.Status, COUNT(a.Id) AS Count FROM Ads AS a
JOIN AdStatuses AS adst
	ON a.StatusId = adst.Id
JOIN Towns AS t
	ON a.TownId = t.Id
GROUP BY t.Name, adst.Status
ORDER BY t.Name, adst.Status

-- Task 13 -- unfinished
SELECT anu.Id,
	anu.UserName, 
	COUNT(a.Id) AS AdsCount,
	(CASE anr.Name WHEN 'Administrator' THEN 'yes' ELSE 'no' END) AS IsAdministrator
FROM Ads AS a
FULL JOIN AspNetUsers AS anu
	ON a.OwnerId = anu.Id
FULL JOIN AspNetUserRoles AS anur
	ON anu.Id = anur.UserId
FULL JOIN AspNetRoles AS anr
	ON anur.RoleId = anr.Id
GROUP BY anu.UserName, anr.Name
HAVING anu.UserName IS NOT NULL
ORDER BY anu.UserName


-- Task 14
SELECT COUNT(a.Id) AS AdsCount, ISNULL(t.Name, '(no town)') AS Town FROM Ads AS a
LEFT JOIN Towns AS t
	ON a.TownId = t.Id
GROUP BY t.Name
HAVING COUNT(a.Id) = 2 OR COUNT(a.Id) = 3
ORDER BY t.Name


-- Task 15
SELECT a.Date AS FirstDate, a2.Date AS SecondDate FROM Ads AS a, Ads AS a2
WHERE a.Date < a2.Date AND DATEDIFF(HOUR, a.Date, a2.Date) < 12
ORDER BY a.Date, a2.Date


-- Task 16
CREATE TABLE Countries
(
	Id int PRIMARY KEY IDENTITY NOT NULL,
	Name nvarchar(100) NOT NULL
)

ALTER TABLE Towns
ADD CountryId int
ALTER TABLE Towns
ADD CONSTRAINT FK_Towns_Countries FOREIGN KEY(CountryId) 
REFERENCES Countries(Id)


INSERT INTO Countries(Name) VALUES ('Bulgaria'), ('Germany'), ('France')
UPDATE Towns SET CountryId = (SELECT Id FROM Countries WHERE Name='Bulgaria')
INSERT INTO Towns VALUES
('Munich', (SELECT Id FROM Countries WHERE Name='Germany')),
('Frankfurt', (SELECT Id FROM Countries WHERE Name='Germany')),
('Berlin', (SELECT Id FROM Countries WHERE Name='Germany')),
('Hamburg', (SELECT Id FROM Countries WHERE Name='Germany')),
('Paris', (SELECT Id FROM Countries WHERE Name='France')),
('Lyon', (SELECT Id FROM Countries WHERE Name='France')),
('Nantes', (SELECT Id FROM Countries WHERE Name='France'))


UPDATE Ads 
SET TownId = (SELECT Id FROM Towns WHERE Name = 'Paris')
WHERE DATENAME(dw, Date) = 'Friday'

UPDATE Ads 
SET TownId = (SELECT Id FROM Towns WHERE Name = 'Hamburg')
WHERE DATENAME(dw, Date) = 'Thursday'

DELETE FROM Ads
WHERE Title IN
(SELECT a.Title FROM Ads AS a
JOIN AspNetUsers AS anu
	ON a.OwnerId = anu.Id
JOIN AspNetUserRoles AS anur
	ON anu.Id = anur.UserId
JOIN AspNetRoles AS anr
	ON anur.RoleId = anr.Id
WHERE anr.Name = 'Partner')

INSERT INTO Ads(Title, Text, Date, OwnerId, StatusId)
VALUES('Free Book', 'Free C# Book', GETDATE(), '39b7333d-664b-428d-9e11-4cde699d5e5e', 2)

SELECT * FROM AspNetUsers
WHERE Name = 'Nakov'

SELECT * From AdStatuses


SELECT t.Name AS Town, c.Name AS Country, COUNT(a.Id) FROM Ads AS a
LEFT JOIN Towns AS t
	ON a.TownId = t.Id
LEFT JOIN Countries AS c
	ON t.CountryId = c.Id
GROUP BY t.Name, c.Name


SELECT t.Name AS Town, c.Name AS Country, COUNT(a.Id) AS AdsCount FROM Towns AS t
FULL OUTER JOIN Ads AS a
	ON t.Id = a.TownId
FULL OUTER JOIN Countries AS c
	ON t.CountryId = c.Id
GROUP BY t.Name, c.Name
ORDER BY t.Name, c.Name
