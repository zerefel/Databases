SELECT t.Name, d.Name, COUNT(*) AS [Employees Count] FROM Employees AS e
JOIN Departments AS d
ON e.DepartmentID = d.DepartmentID
JOIN Addresses AS a
ON e.AddressID = a.AddressID
JOIN Towns AS t
ON a.TownID = t.TownID

GROUP BY t.Name, d.Name