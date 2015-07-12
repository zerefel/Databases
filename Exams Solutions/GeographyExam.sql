-- Task 1
SELECT PeakName FROM Peaks
ORDER BY PeakName

-- Task 2
SELECT TOP 30 CountryName, Population FROM Countries
WHERE ContinentCode = 'EU'
ORDER BY Population DESC

-- Task 3
SELECT CountryName, CountryCode, (CASE CurrencyCode WHEN 'EUR' THEN 'Euro' ELSE 'Not Euro' END) AS Currency FROM Countries
ORDER BY CountryName

-- Task 4
SELECT CountryName AS [Country Name], IsoCode AS [ISO Code] FROM Countries
WHERE CountryName LIKE '%a%a%a%'
ORDER BY IsoCode

-- Task 5
SELECT PeakName, MountainRange AS Mountain, Elevation FROM Peaks AS p
JOIN Mountains AS m
ON p.MountainId = m.Id
ORDER BY Elevation DESC, PeakName

-- Task 6
SELECT PeakName, MountainRange AS Mountain, CountryName, ContinentName FROM Peaks AS p
JOIN Mountains AS m
	ON p.MountainId = m.Id
JOIN MountainsCountries AS mc
	ON mc.MountainId = m.Id
JOIN Countries AS c
	ON c.CountryCode = mc.CountryCode
JOIN Continents AS con 
	ON c.ContinentCode = con.ContinentCode
ORDER BY PeakName, CountryName

-- Task 7
SELECT RiverName AS River, COUNT(CountryName) AS [Countries Count] FROM Rivers AS r
JOIN CountriesRivers AS cr
	ON r.Id = cr.RiverId
JOIN Countries AS c
	ON c.CountryCode = cr.CountryCode
GROUP BY RiverName
HAVING COUNT(CountryName) >= 3
ORDER BY RiverName

-- Task 8
SELECT MAX(Elevation) AS MaxElevation, 
	MIN(Elevation) AS  MinElevation,
	AVG(Elevation) AS AverageElevation
FROM Peaks

-- Task 9
SELECT CountryName, 
	ContinentName, 
	COUNT(r.Id) AS RiversCount, 
	ISNULL(SUM(r.Length), 0) AS TotalLength
FROM Countries AS con
	LEFT JOIN Continents AS cont
ON con.ContinentCode = cont.ContinentCode
	LEFT JOIN CountriesRivers AS cr
ON cr.CountryCode = con.CountryCode
	LEFT JOIN Rivers AS r
ON cr.RiverId = r.Id
GROUP BY CountryName, ContinentName
ORDER BY RiversCount DESC, TotalLength DESC, CountryName

-- Task 10
SELECT cur.CurrencyCode, 
	cur.Description AS Currency,
	COUNT(c.CountryCode) AS NumberOfCountries
FROM Currencies AS cur
LEFT JOIN Countries AS c
	ON cur.CurrencyCode = c.CurrencyCode
GROUP BY cur.CurrencyCode, cur.Description
ORDER BY NumberOfCountries DESC, Currency

-- Task 11
SELECT con.ContinentName,
	SUM(coun.AreaInSqKm) AS CountriesArea,
	SUM(CAST(coun.Population as bigint)) AS CountriesPopulation 
FROM Continents AS con
JOIN Countries AS coun
	ON con.ContinentCode = coun.ContinentCode
GROUP BY con.ContinentName
ORDER BY CountriesPopulation DESC

-- Task 12
SELECT coun.CountryName, 
	MAX(p.Elevation) AS HighestPeakElevation, 
	MAX(r.Length) AS LongestRiverLength 
FROM Countries AS coun
LEFT JOIN MountainsCountries AS mc
	ON coun.CountryCode = mc.CountryCode
LEFT JOIN Mountains AS m
	ON m.Id = mc.MountainId
LEFT JOIN Peaks AS p
	ON p.MountainId = m.Id
LEFT JOIN CountriesRivers AS cr
	ON coun.CountryCode = cr.CountryCode
LEFT JOIN Rivers AS r 
	ON r.Id = cr.RiverId
GROUP BY coun.CountryName
ORDER BY HighestPeakElevation DESC, LongestRiverLength DESC, coun.CountryName

-- Task 13
SELECT PeakName, 
	RiverName, 
	LOWER(PeakName + SUBSTRING(RiverName, 2, LEN(RiverName))) AS Mix
FROM Peaks AS p, Rivers AS r
WHERE RIGHT(PeakName, 1) = LEFT(RiverName, 1)
ORDER BY Mix

-- Task 14
SELECT CountryName AS [Country],
	PeakName AS [Highest Peak Name],
	Elevation AS [Highest Peak Elevation],
	MountainRange AS [Mountain]
FROM Countries AS c
LEFT JOIN MountainsCountries AS mc
	ON c.CountryCode = mc.CountryCode
LEFT JOIN Mountains AS m
	ON m.Id = mc.MountainId
LEFT JOIN Peaks AS p
	ON m.Id = p.MountainId
WHERE (SELECT MAX(p.Elevation) FROM MountainsCountries AS mc
	   LEFT JOIN Mountains AS m ON mc.MountainId = m.Id
	   LEFT JOIN Peaks AS p ON m.Id = p.MountainId
	   WHERE mc.CountryCode = c.CountryCode) = p.Elevation
UNION
SELECT CountryName AS [Country],
	'(no highest peak)' AS [Highest Peak Name],
	0 AS [Highest Peak Elevation],
	'(no mountain)' AS [Mountain]
FROM Countries AS c
LEFT JOIN MountainsCountries AS mc
	ON c.CountryCode = mc.CountryCode
LEFT JOIN Mountains AS m
	ON m.Id = mc.MountainId
LEFT JOIN Peaks AS p
	ON m.Id = p.MountainId
WHERE (SELECT MAX(p.Elevation) FROM MountainsCountries AS mc
	   LEFT JOIN Mountains AS m ON mc.MountainId = m.Id
	   LEFT JOIN Peaks AS p ON m.Id = p.MountainId
	   WHERE mc.CountryCode = c.CountryCode) IS NULL
ORDER BY CountryName, [Highest Peak Name]


-- Task 15
CREATE TABLE Monasteries
(Id int NOT NULL PRIMARY KEY IDENTITY,
 Name nvarchar(max) NOT NULL, 
 CountryCode char(2) NOT NULL FOREIGN KEY
 REFERENCES Countries(CountryCode))


 INSERT INTO Monasteries(Name, CountryCode) VALUES
('Rila Monastery “St. Ivan of Rila”', 'BG'), 
('Bachkovo Monastery “Virgin Mary”', 'BG'),
('Troyan Monastery “Holy Mother''s Assumption”', 'BG'),
('Kopan Monastery', 'NP'),
('Thrangu Tashi Yangtse Monastery', 'NP'),
('Shechen Tennyi Dargyeling Monastery', 'NP'),
('Benchen Monastery', 'NP'),
('Southern Shaolin Monastery', 'CN'),
('Dabei Monastery', 'CN'),
('Wa Sau Toi', 'CN'),
('Lhunshigyia Monastery', 'CN'),
('Rakya Monastery', 'CN'),
('Monasteries of Meteora', 'GR'),
('The Holy Monastery of Stavronikita', 'GR'),
('Taung Kalat Monastery', 'MM'),
('Pa-Auk Forest Monastery', 'MM'),
('Taktsang Palphug Monastery', 'BT'),
('Sümela Monastery', 'TR')

ALTER TABLE Countries
ADD IsDeleted bit NOT NULL
DEFAULT (0)

UPDATE Countries
SET IsDeleted = 1
WHERE CountryCode IN (SELECT c.CountryCode FROM Countries AS c
	JOIN CountriesRivers AS cr
		ON c.CountryCode = cr.CountryCode
	JOIN Rivers AS r
		ON r.Id = cr.RiverId
	GROUP BY c.CountryCode
	HAVING COUNT(RiverName) > 3)

SELECT m.Name AS Monastery, c.CountryName AS Country FROM Monasteries AS m
JOIN Countries AS c
	ON m.CountryCode = c.CountryCode
WHERE c.IsDeleted <> 1
ORDER BY Monastery


-- Task 16
SELECT * FROM Countries 
WHERE CountryName = 'Myanmar'

UPDATE Countries
SET CountryName = 'Burma'
WHERE CountryName = 'Myanmar'


INSERT INTO Monasteries(Name, CountryCode) VALUES
('Hanga Abbey', 'TZ')

SELECT con.ContinentName, coun.CountryName, COUNT(m.CountryCode) AS MonasteriesCount FROM Continents AS con
LEFT JOIN Countries AS coun
	ON con.ContinentCode = coun.ContinentCode
LEFT JOIN Monasteries AS m
	ON m.CountryCode = coun.CountryCode
WHERE coun.IsDeleted = 0
GROUP BY con.ContinentName, coun.CountryName
ORDER BY MonasteriesCount DESC, coun.CountryName
GO

-- Task 17
USE Geography
GO

ALTER FUNCTION fn_MountainsPeaksJSON()
	RETURNS nvarchar(max)
AS
BEGIN
	DECLARE @jsonString nvarchar(max) = '{"mountains":['
	
	DECLARE mountainsCursor CURSOR
	FOR
	SELECT m.Id, m.MountainRange FROM Mountains AS m

	OPEN mountainsCursor
	DECLARE	@mountainId int
	DECLARE @mountainName nvarchar(max)
	FETCH NEXT FROM mountainsCursor INTO @mountainId, @mountainName
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @jsonString = @jsonString + '{"name":"' + @mountainName + '","peaks":['
		

		-- BEGIN CURSOR 2
		DECLARE peaksCursor CURSOR FOR
		SELECT PeakName, Elevation FROM Peaks AS p
		WHERE MountainId = @mountainId

		OPEN peaksCursor
		DECLARE @peakName nvarchar(max) 
		DECLARE @peakElevation int
		FETCH NEXT FROM peaksCursor INTO @peakName, @peakElevation
		WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @jsonString = @jsonString + '{"name":"' + @peakName + 
			'","elevation":' + CONVERT(nvarchar(max), @peakElevation) + '}'

			FETCH NEXT FROM peaksCursor INTO @peakName, @peakElevation
			IF @@FETCH_STATUS = 0
			BEGIN
				SET @jsonString = @jsonString + ','
			END
		END

		CLOSE peaksCursor -- close the cursor
		DEALLOCATE peaksCursor -- Deallocate the cursor
		-- END CURSOR 2

		SET @jsonString = @jsonString + ']}'

		FETCH NEXT FROM mountainsCursor INTO @mountainId, @mountainName
		IF @@FETCH_STATUS = 0
		BEGIN
			SET @jsonString = @jsonString + ','
		END
	END

	CLOSE mountainsCursor -- close the cursor
	DEALLOCATE mountainsCursor -- Deallocate the cursor

	SET @jsonString = @jsonString + ']}'
	
	RETURN @jsonString
END

SELECT dbo.fn_MountainsPeaksJSON()