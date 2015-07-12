SELECT e.FirstName, e.LastName, e.HireDate, d.Name FROM Employees e
JOIN Departments d 
on e.DepartmentID = d.DepartmentID

WHERE e.DepartmentID IN (
Select DepartmentId FROM Departments WHERE (d.Name = 'Sales' OR d.Name = 'Finance')
) AND e.HireDate BETWEEN '1995' AND '2005'