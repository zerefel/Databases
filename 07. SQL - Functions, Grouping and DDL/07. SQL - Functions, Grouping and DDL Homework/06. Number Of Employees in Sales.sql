SELECT COUNT(FirstName) AS [Employees in Sales] FROM Employees AS e
JOIN Departments d 
ON e.DepartmentID = d.DepartmentID
WHERE d.Name = 'Sales'