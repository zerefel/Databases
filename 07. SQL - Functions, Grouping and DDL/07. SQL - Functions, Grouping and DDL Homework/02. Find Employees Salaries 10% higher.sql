SELECT e.FirstName, e.LastName, e.Salary FROM Employees AS e
WHERE e.Salary <= 
	(SELECT MIN(Salary) * 1.10 FROM Employees)