SELECT d.Name, AVG(Salary) AS [Average Sales Dept. Salary] FROM Employees AS e
JOIN Departments AS d
ON e.DepartmentID = d.DepartmentID
GROUP BY d.Name
HAVING d.Name = 'Sales'