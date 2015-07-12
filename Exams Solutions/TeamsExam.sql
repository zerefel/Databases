USE Football
GO

-- Task 1
SELECT TeamName FROM Teams
ORDER BY TeamName

-- Task 2
SELECT TOP 50 CountryName, Population FROM Countries
ORDER BY Population DESC, CountryName

-- Task 3
SELECT 
	CountryName, 
	CountryCode, 
	(CASE CurrencyCode WHEN 'EUR' THEN 'Inside' ELSE 'Outside' END) AS Eurozone
FROM Countries
ORDER BY CountryName

-- Task 4
SELECT TeamName AS [Team Name], CountryCode AS [Country Code] FROM Teams
WHERE TeamName LIKE '%[0-9.]%'

-- Task 5
SELECT 
	c2.CountryName AS [Home Team], 
	c.CountryName AS [Away Team], 
	MatchDate AS [Match Date] 
FROM InternationalMatches AS im
JOIN Countries AS c
	ON im.AwayCountryCode = c.CountryCode
JOIN Countries AS c2 
	ON im.HomeCountryCode = c2.CountryCode
ORDER BY MatchDate DESC

-- Task 6
SELECT 
	CONVERT(nvarchar(max), t.TeamName) AS [Team Name], 
	l.LeagueName AS [League],
	ISNULL(c.CountryName, 'International') AS [League Country] 
 FROM Teams AS t
 JOIN Leagues_Teams AS lt
	ON lt.TeamId = t.Id
 JOIN Leagues AS l
	ON lt.LeagueId = l.Id
LEFT JOIN Countries AS c
	ON l.CountryCode = c.CountryCode
ORDER BY [Team Name], [League]

-- Task 7
SELECT t.TeamName AS [Team],
	(SELECT COUNT(DISTINCT tm.Id) FROM TeamMatches AS tm
	WHERE tm.HomeTeamId = t.Id OR tm.AwayTeamId = t.Id) AS [Matches Count]
FROM Teams AS t
	WHERE (SELECT COUNT(DISTINCT tm.Id) FROM TeamMatches AS tm
	WHERE tm.HomeTeamId = t.Id OR tm.AwayTeamId = t.Id) > 1
ORDER BY t.TeamName


SELECT TeamName FROM TeamMatches AS tm
 JOIN Teams AS t1
	ON t1.Id = tm.HomeTeamId
 JOIN Teams AS t2
	ON t2.Id = tm.AwayTeamId
 JOIN Leagues AS l
	ON tm.LeagueId = l.Id
ORDER BY TeamName


-- Task 8
SELECT 
	LeagueName AS [League Name], 
	COUNT(DISTINCT lt.TeamId) AS [Teams],
	COUNT(DISTINCT tm.Id) AS [Matches],
	ISNULL(AVG(tm.AwayGoals + tm.HomeGoals), 0) AS [Average Goals]
FROM Leagues AS l
LEFT JOIN Leagues_Teams AS lt
	ON l.Id = lt.LeagueId
LEFT JOIN TeamMatches AS tm
	ON l.Id = tm.LeagueId
GROUP BY LeagueName
ORDER BY [Teams] DESC, [Matches] DESC


-- Task 9
SELECT 
	TeamName, 
	ISNULL(SUM(tm.HomeGoals), 0) + ISNULL(SUM(tm2.AwayGoals), 0) AS [Total Goals]
FROM Teams AS t
LEFT JOIN TeamMatches AS tm
	ON t.Id = tm.HomeTeamId
LEFT JOIN TeamMatches AS tm2
	ON t.Id = tm2.AwayTeamId
GROUP BY TeamName
ORDER BY [Total Goals] DESC, TeamName

select
t.TeamName,
isnull((select sum(tm.HomeGoals) from TeamMatches tm where tm.HomeTeamId = t.Id), 0) + 
isnull((select sum(tm.AwayGoals) from TeamMatches tm where tm.AwayTeamId = t.Id), 0) as [Total Goals]
from Teams t
order by [Total Goals] desc, t.TeamName


-- Task 10
SELECT tm1.MatchDate AS [First Date], tm2.MatchDate AS [Second Date] 
FROM TeamMatches AS tm1, TeamMatches tm2
	WHERE tm1.MatchDate < tm2.MatchDate
	AND DATEDIFF(day, tm1.MatchDate, tm2.MatchDate) < 1
ORDER BY [First Date] DESC, [Second Date] DESC

-- Task 11
SELECT LOWER(t1.TeamName + SUBSTRING(REVERSE(t2.TeamName), 2, LEN(t2.TeamName))) AS Mix
FROM Teams AS t1, Teams AS t2
WHERE RIGHT(t1.TeamName, 1) = LEFT(REVERSE(t2.TeamName), 1)
ORDER BY Mix


-- Task 12
SELECT 
	c.CountryName AS [Country Name], 
	COUNT(DISTINCT im1.Id) + COUNT(DISTINCT im2.Id) AS [International Matches],
    COUNT(DISTINCT tm.Id) AS [Team Matches]
FROM Countries AS c
LEFT JOIN InternationalMatches AS im1
	ON c.CountryCode = im1.HomeCountryCode
LEFT JOIN InternationalMatches AS im2
	ON c.CountryCode = im2.AwayCountryCode
LEFT JOIN Leagues AS l
	ON l.CountryCode = c.CountryCode
LEFT JOIN TeamMatches AS tm 
	ON l.Id = tm.LeagueId
GROUP BY c.CountryName
HAVING (COUNT(DISTINCT im1.Id) + COUNT(DISTINCT im2.Id)) > 0
		OR COUNT(DISTINCT tm.Id) > 0
ORDER BY [International Matches] DESC, [Team Matches] DESC, c.CountryName


-- Task 13
CREATE TABLE FriendlyMatches
(
	Id int PRIMARY KEY IDENTITY NOT NULL,
	HomeTeamId int NOT NULL FOREIGN KEY
		REFERENCES Teams(Id),
	AwayTeamId int NOT NULL FOREIGN KEY
		REFERENCES Teams(Id),
	MatchDate date NULL
)


INSERT INTO Teams(TeamName) VALUES
 ('US All Stars'),
 ('Formula 1 Drivers'),
 ('Actors'),
 ('FIFA Legends'),
 ('UEFA Legends'),
 ('Svetlio & The Legends')
GO

INSERT INTO FriendlyMatches(
  HomeTeamId, AwayTeamId, MatchDate) VALUES
  
((SELECT Id FROM Teams WHERE TeamName='US All Stars'), 
 (SELECT Id FROM Teams WHERE TeamName='Liverpool'),
 '30-Jun-2015 17:00'),
 
((SELECT Id FROM Teams WHERE TeamName='Formula 1 Drivers'), 
 (SELECT Id FROM Teams WHERE TeamName='Porto'),
 '12-May-2015 10:00'),
 
((SELECT Id FROM Teams WHERE TeamName='Actors'), 
 (SELECT Id FROM Teams WHERE TeamName='Manchester United'),
 '30-Jan-2015 17:00'),

((SELECT Id FROM Teams WHERE TeamName='FIFA Legends'), 
 (SELECT Id FROM Teams WHERE TeamName='UEFA Legends'),
 '23-Dec-2015 18:00'),

((SELECT Id FROM Teams WHERE TeamName='Svetlio & The Legends'), 
 (SELECT Id FROM Teams WHERE TeamName='Ludogorets'),
 '22-Jun-2015 21:00')

GO


SELECT t2.TeamName AS [Home Team], t1.TeamName AS [Away Team], tm.MatchDate AS [Match Date] FROM TeamMatches AS tm
JOIN Teams AS t1
	ON tm.AwayTeamId = t1.Id
JOIN Teams AS t2
	ON tm.HomeTeamId = t2.Id
UNION
SELECT t2.TeamName AS [Home Team], t1.TeamName AS [Away Team], fm.MatchDate AS [Match Date] FROM FriendlyMatches AS fm
JOIN Teams AS t1
	ON fm.AwayTeamId = t1.Id
JOIN Teams AS t2
	ON fm.HomeTeamId = t2.Id
ORDER BY [Match Date] DESc

-- Task 14
ALTER TABLE Leagues
ADD IsSeasonal bit NOT NULL
DEFAULT (0)

INSERT INTO TeamMatches(HomeTeamId, AwayTeamId, HomeGoals, AwayGoals, MatchDate, LeagueId)
VALUES (60, 70, 2, 2, '19-Apr-2015 16:00', 2), (66, 64, 0, 0, '19-Apr-2015 21:45', 2)

SELECT * FROM Teams 
WHERE TeamName = 'AC Milan'

SELECT * FROM Leagues 
WHERE LeagueName = 'Italian Serie A'


UPDATE Leagues
SET IsSeasonal = 1
WHERE LeagueName IN (
SELECT LeagueName FROM Leagues AS l
LEFT JOIN TeamMatches AS tm
	ON l.Id = tm.LeagueId
GROUP BY LeagueName
HAVING COUNT(tm.Id) >= 1)


SELECT 
	t1.TeamName AS [Home Team],
	tm.HomeGoals AS [Home Goals],
	t2.TeamName AS [Away Team],
	tm.AwayGoals AS [Away Goals],
	l.LeagueName AS [League Name]
FROM TeamMatches AS tm
JOIN Teams AS t1
	ON t1.Id = tm.HomeTeamId
JOIN Teams AS t2
	ON t2.Id = tm.AwayTeamId
JOIN Leagues as l
	on TM.LeagueId = l.Id
	WHERE tm.MatchDate > '2015-04-10'
ORDER BY [League Name], tm.HomeGoals DESC, tm.AwayGoals DESC


SELECT * FROM TeamMatches

GO



-- Task 15
ALTER FUNCTION fn_TeamsJSON()
RETURNS NVARCHAR(MAX)
AS
BEGIN
	DECLARE @teamJson NVARCHAR(MAX)
	DECLARE @teamName NVARCHAR(MAX)
	DECLARE @teamId int

	SET @teamJson = '{"teams":['

	DECLARE teamsCursor CURSOR
	FOR SELECT Id, TeamName FROM Teams AS t
		JOIN Countries AS c
			ON t.CountryCode = c.CountryCode
		WHERE CountryName = 'Bulgaria'
		ORDER BY TeamName

	OPEN teamsCursor
	FETCH NEXT FROM teamsCursor INTO @teamId, @teamName
	WHILE @@FETCH_STATUS = 0
	BEGIN 
		SET @teamJson = @teamJson + '{"name":"' + @teamName + '","matches":['

		DECLARE @homeTeamName NVARCHAR(MAX)
		DECLARE @awayTeamName NVARCHAR(MAX)
		DECLARE @matchDate NVARCHAR(MAX)
		DECLARE @homeTeamGoals int
		DECLARE @awayTeamGoals int

		DECLARE matchesCursor CURSOR
		FOR SELECT t1.TeamName, t2.TeamName, tm.HomeGoals, 
				   tm.AwayGoals, CONVERT(NVARCHAR(10), tm.MatchDate, 103) FROM TeamMatches AS tm
			JOIN Teams AS t1
				ON tm.HomeTeamId = t1.Id
			JOIN Teams AS t2
				ON tm.AwayTeamId = t2.Id
			WHERE tm.AwayTeamId = @teamId OR tm.HomeTeamId = @teamId
			ORDER BY tm.MatchDate DESC
		OPEN matchesCursor
		FETCH NEXT FROM matchesCursor INTO @homeTeamName, @awayTeamName, @homeTeamGoals, @awayTeamGoals, @matchDate
		WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @teamJson = @teamJson + '{"' + @homeTeamName + '":' + CONVERT(NVARCHAR(MAX), @homeTeamGoals) + 
							',"' + @awayTeamName + '":' + CONVERT(NVARCHAR(MAX), @awayTeamGoals) + 
							',"date":' + @matchDate + '}'

			FETCH NEXT FROM matchesCursor INTO @homeTeamName, @awayTeamName, @homeTeamGoals, @awayTeamGoals, @matchDate
			IF @@FETCH_STATUS = 0
				SET @teamJson = @teamJson + ','
		END

		CLOSE matchesCursor
		DEALLOCATE matchesCursor

		SET @teamJson = @teamJson + ']}'

		FETCH NEXT FROM teamsCursor INTO @teamId, @teamName
		IF @@FETCH_STATUS = 0
			SET @teamJson = @teamJson + ','
	END

	SET @teamJson = @teamJson + ']}'
	
	CLOSE teamsCursor
	DEALLOCATE teamsCursor

	RETURN @teamJson
END

SELECT dbo.fn_TeamsJSON()