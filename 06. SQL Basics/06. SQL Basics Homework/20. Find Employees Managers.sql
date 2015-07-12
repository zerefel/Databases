SELECT e1.EmployeeID, e1.FirstName, e1.LastName,  e2.FirstName AS ManagerFirstName, 
    e2.LastName AS ManagerLastName
FROM Employees e1
left outer join Employees e2 ON e1.ManagerID = e2.EmployeeID