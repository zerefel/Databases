SELECT e.FirstName, ISNULL(m.FirstName + ' ' + m.LastName, '(no manager)') AS [Manager Name] FROM Employees AS e
LEFT JOIN Employees AS m
ON e.ManagerID = m.EmployeeID
