-- Task 1
SELECT Name From Characters
ORDER BY Name

-- Task 2 -- TODO UNFINISHED
SELECT TOP 50 
	g.Name AS Game, 
	CONVERT(varchar(10), g.Start, 120) AS Start
FROM Games AS g
WHERE YEAR(g.Start) = 2011 OR YEAR(g.Start) = 2012
ORDER BY g.Start, g.Name

-- Task 3
SELECT
	Username, 
	RIGHT(Email,LEN(Email)-CHARINDEX('@',Email)) AS [Email Provider] 
FROM Users AS u
ORDER BY [Email Provider], Username


-- Task 4
SELECT u.Username, u.IpAddress AS [IP Address] FROM Users AS u
WHERE u.IpAddress LIKE '___.1%.%.___'
ORDER BY Username

-- Task 5
SELECT * FROM Games

SELECT 
	Name AS [Game], 
	(CASE
	 WHEN DATEPART(HOUR, START) >= 0 AND DATEPART(HOUR, START) < 12 THEN 'Morning'
	 WHEN DATEPART(HOUR, START) >= 12 AND DATEPART(HOUR, START) < 18 THEN 'Afternoon'
	 WHEN DATEPART(HOUR, START) >= 18 AND DATEPART(HOUR, START) < 24 THEN 'Evening'
	 END
	) AS [Part of the Day],
	(CASE 
	 WHEN Duration BETWEEN 0 AND 3 THEN 'Extra Short'
	 WHEN Duration BETWEEN 4 AND 6 THEN 'Short'
	 WHEN Duration > 6 THEN 'Long'
	 WHEN Duration IS NULL THEN 'Extra Long'
	 END ) AS [Duration]
FROM Games
ORDER BY Name, Duration, [Part of the Day]


-- Task 6
SELECT 
	RIGHT(Email, LEN(Email)- CHARINDEX('@', Email)) AS [Email Provider],
	COUNT(u.Id) AS [Number Of Users]
FROM Users AS u
GROUP BY RIGHT(Email, LEN(Email)- CHARINDEX('@', Email))
ORDER BY COUNT(u.Id) DESC, [Email Provider]


-- Task 7
SELECT 
	g.Name AS Game,
	gt.Name AS [Game Type],
	u.Username,
	ug.Level, 
	ug.Cash, 
	c.Name AS Character
FROM Users AS u
JOIN UsersGames AS ug
	ON u.Id = ug.UserId
JOIN Games AS g
	ON ug.GameId = g.Id
JOIN GameTypes AS gt
	ON g.GameTypeId = gt.Id
JOIN Characters AS c
	ON ug.CharacterId = c.Id
ORDER BY Level DESC, u.Username, g.Name

-- Task 8
SELECT 
	u.Username, 
	g.Name AS Game, 
	COUNT(i.Id) AS [Items Count], 
	SUM(i.Price)AS [Items Price] 
FROM Users AS u
JOIN UsersGames AS ug
	ON u.Id = ug.UserId
JOIN Games AS g
	ON ug.GameId = g.Id
JOIN GameTypes AS gt
	ON g.GameTypeId = gt.Id
JOIN UserGameItems AS ugi
	ON ug.Id = ugi.UserGameId
JOIN Items AS i
	ON ugi.ItemId = i.Id
GROUP BY u.Username, g.Name
HAVING COUNT(i.Id) >= 10
ORDER BY COUNT(i.Id) DESC, SUM(i.Price) DESC, u.Username ASC



-- Task 9 

-- Task 10
SELECT 
	i.Name, 
	i.Price, 
	i.MinLevel, 
	s.Strength, 
	s.Defence, 
	s.Speed, 
	s.Luck, 
	s.Mind 
FROM Items AS i
JOIN [Statistics] AS s
	ON i.StatisticId = s.Id
WHERE s.Mind > (SELECT AVG(Mind) FROM [Statistics])
	AND s.Luck > (SELECT AVG(Luck) FROM [Statistics])
	AND s.Speed > (SELECT AVG(Speed) FROM [Statistics])
ORDER BY i.Name


-- Task 11
SELECT 
	i.Name AS Item, 
	i.Price, 
	i.MinLevel,
	gt.Name AS [Forbidden Game Type] 
FROM Items AS i
LEFT JOIN GameTypeForbiddenItems AS gtfi
	ON i.Id = gtfi.ItemId
LEFT JOIN GameTypes AS gt
	ON gtfi.GameTypeId = gt.Id
ORDER BY gt.Name DESC, i.Name ASC 


-- Task 12
-- Check Alex's Cash
SELECT ug.Id FROM Users AS u
JOIN UsersGames AS ug 
	ON u.Id = ug.UserId
JOIN Games AS g
	ON ug.GameId = g.Id
JOIN UserGameItems AS ugi
	ON ugi.UserGameId = u.Id
JOIN Items AS i
	ON ugi.ItemId = i.Id
WHERE u.Username = 'Alex' AND g.Name = 'Edinburgh'

-- Find the sum of all Itmes Alex wants
SELECT SUM(Price) FROM Items AS i 
WHERE i.Name 
IN ('Blackguard', 
'Bottomless Potion of Amplification',
'Eye of Etlich (Diablo III)',
'Gem of Efficacious Toxin',
'Golden Gorget of Leoric',
'Hellfire Amulet')

-- Update Alex's Cash
UPDATE UsersGames 
SET Cash = 
Cash - (SELECT SUM(Price) FROM Items AS i 
WHERE i.Name 
IN ('Blackguard', 
'Bottomless Potion of Amplification',
'Eye of Etlich (Diablo III)',
'Gem of Efficacious Toxin',
'Golden Gorget of Leoric',
'Hellfire Amulet'))
WHERE UserId  = (SELECT Id FROM Users WHERE Username = 'Alex')
	AND GameId = (SELECT Id FROM Games WHERE Name = 'Edinburgh')


INSERT INTO UserGameItems(ItemId, UserGameId)
VALUES((SELECT Id FROM Items WHERE Name = 'Blackguard'), 235),
((SELECT Id FROM Items WHERE Name = 'Bottomless Potion of Amplification'), 235),
((SELECT Id FROM Items WHERE Name = 'Eye of Etlich (Diablo III)'), 235),
((SELECT Id FROM Items WHERE Name = 'Gem of Efficacious Toxin'), 235),
((SELECT Id FROM Items WHERE Name = 'Golden Gorget of Leoric'), 235),
((SELECT Id FROM Items WHERE Name = 'Hellfire Amulet'), 235)


SELECT u.Username, g.Name, ug.Cash, i.Name AS [Item Name] FROM Users AS u
JOIN UsersGames AS ug 
	ON u.Id = ug.UserId
JOIN Games AS g
	ON ug.GameId = g.Id
JOIN UserGameItems AS ugi
	ON ugi.UserGameId = ug.Id
JOIN Items AS i
	ON ugi.ItemId = i.Id
WHERE g.Name = 'Edinburgh' -- AND u.Username = 'Alex'
ORDER BY i.Name






-- Task 13
SELECT u.Username, g.Name, ug.Cash, i.Name AS [Item Name] FROM Users AS u
JOIN UsersGames AS ug 
	ON u.Id = ug.UserId
JOIN Games AS g
	ON ug.GameId = g.Id
JOIN UserGameItems AS ugi
	ON ugi.UserGameId = ug.Id
JOIN Items AS i
	ON ugi.ItemId = i.Id
WHERE g.Name = 'Safflower' AND u.Username = 'Stamat'
ORDER BY i.Name

SELECT SUM(Price) FROM Items AS i
WHERE i.MinLevel IN (11, 12, 19, 20, 21)


BEGIN TRANSACTION












-- Task 14
ALTER FUNCTION fn_CashInUsersGames(@gameName NVARCHAR(MAX))
RETURNS MONEY
AS 
BEGIN 
	DECLARE @gameCash MONEY

	SELECT @gameCash = SUM(Cash)
	FROM (
		SELECT Cash, ROW_NUMBER() OVER(ORDER BY Cash DESC) AS RowNumber 
				--Row_Number() starts with 1
		FROM Games AS g
		JOIN UsersGames AS ug
			ON g.Id = ug.GameId
		WHERE g.Name = @gameName

	) AS tempTable
	WHERE tempTable.RowNumber % 2 = 1 -- Odd Rows Only
	ORDER BY SUM(Cash) DESC

	RETURN @gameCash
END

SELECT dbo.fn_CashInUsersGames('Bali') AS SumCash
UNION
SELECT dbo.fn_CashInUsersGames('Lily Stargazer')
UNION 
SELECT dbo.fn_CashInUsersGames('Love in a mist')
UNION
SELECT dbo.fn_CashInUsersGames('Mimosa')
UNION
SELECT dbo.fn_CashInUsersGames('Ming fern')
ORDER BY SumCash ASC



-- Task 15
CREATE TRIGGER UserGameItemsLevelInsert
ON UserGameItems
FOR INSERT
AS
BEGIN
	
END










INSERT INTO UserGameItems(ItemId, UserGameId)
VALUES((SELECT Id FROM Items WHERE Name = 'Blackguard'), 235),
((SELECT Id FROM Items WHERE Name = 'Bottomless Potion of Amplification'), 235),
((SELECT Id FROM Items WHERE Name = 'Eye of Etlich (Diablo III)'), 235),
((SELECT Id FROM Items WHERE Name = 'Gem of Efficacious Toxin'), 235),
((SELECT Id FROM Items WHERE Name = 'Golden Gorget of Leoric'), 235),
((SELECT Id FROM Items WHERE Name = 'Hellfire Amulet'), 235)
