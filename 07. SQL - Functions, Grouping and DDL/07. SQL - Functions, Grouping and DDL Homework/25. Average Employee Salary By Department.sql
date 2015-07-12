SELECT
	d.Name AS Department,
	e.JobTitle,
	AVG(e.Salary) AS [Average Salary]
FROM Departments AS d
JOIN Employees AS e
ON d.DepartmentID = e.DepartmentID
GROUP BY d.Name, e.JobTitle
ORDER BY d.Name ASC, e.JobTitle ASC