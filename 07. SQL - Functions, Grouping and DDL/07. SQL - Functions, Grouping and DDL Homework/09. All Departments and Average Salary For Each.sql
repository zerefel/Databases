SELECT d.Name, AVG(Salary) AS [Average Salary] FROM Employees as e
JOIN Departments AS d 
ON e.DepartmentID = d.DepartmentID
GROUP BY d.Name