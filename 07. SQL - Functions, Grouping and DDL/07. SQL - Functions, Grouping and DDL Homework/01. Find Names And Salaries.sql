SELECT e.FirstName, e.LastName, e.Salary FROM Employees e
WHERE SALARY = (SELECT MIN(SALARY) FROM Employees)