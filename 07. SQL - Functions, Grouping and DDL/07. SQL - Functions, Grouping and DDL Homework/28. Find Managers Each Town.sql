SELECT
	t.Name AS Town,
	COUNT(*) AS [Number of managers]
FROM Employees AS m
JOIN Addresses AS a
ON m.AddressID = a.AddressID
JOIN Towns AS t
ON a.TownID = t.TownID
WHERE m.EmployeeID IN 
	(SELECT DISTINCT e.ManagerID
	FROM Employees AS e
	WHERE e.ManagerID IS NOT NULL)
GROUP BY t.Name
