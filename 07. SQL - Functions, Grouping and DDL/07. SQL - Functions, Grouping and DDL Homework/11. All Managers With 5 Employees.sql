SELECT m.FirstName AS [Manager First Name], m.LastName, COUNT(*) AS [Employees Count] FROM Employees AS e
JOIN Employees AS m
ON e.ManagerID = m.EmployeeID
GROUP BY m.FirstName, m.LastName
HAVING COUNT(*) = 5