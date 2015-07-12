BEGIN TRAN
DELETE Employees
WHERE DepartmentID = 
	(SELECT d.DepartmentID FROM Departments AS d
	WHERE d.Name = 'Sales')
ROLLBACK
