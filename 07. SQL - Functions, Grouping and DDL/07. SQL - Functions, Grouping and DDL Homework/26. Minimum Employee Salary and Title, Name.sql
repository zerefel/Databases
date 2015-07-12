SELECT
	d.Name AS Department,
	e.JobTitle AS [Job Title],
	MIN(e.Salary) AS [Min Salary],
	MIN(e.FirstName) AS [First Name]
FROM Departments AS d
JOIN Employees AS e
ON d.DepartmentID = e.DepartmentID
GROUP BY d.Name, e.JobTitle
ORDER BY d.Name, e.JobTitle