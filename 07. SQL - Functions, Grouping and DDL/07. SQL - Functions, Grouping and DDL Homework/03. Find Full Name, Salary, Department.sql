SELECT e.FirstName + ' ' + e.LastName AS [Full Name], e.Salary, d.Name [Department Name] 
FROM Employees AS e
INNER JOIN Departments AS d
ON e.DepartmentID = d.DepartmentID
WHERE e.Salary =
	(SELECT MIN(Salary) FROM Employees
	WHERE e.DepartmentID = DepartmentID)