SELECT TOP 1
	t.Name,
	COUNT(t.Name) AS [Number of employees]
FROM Employees AS e
JOIN Addresses AS a
ON e.AddressID = a.AddressID
JOIN Towns AS t
ON a.TownID = t.TownID
GROUP BY t.Name
ORDER BY [Number of employees] DESC
