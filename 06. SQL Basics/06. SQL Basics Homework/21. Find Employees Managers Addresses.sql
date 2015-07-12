SELECT  e.FirstName, e.LastName,  m.FirstName AS ManagerFirstName, 
    m.LastName AS ManagerLastName, a.AddressText AS [Living in]
FROM Employees e
LEFT OUTER JOIN Employees m ON e.ManagerID = m.EmployeeID
JOIN Addresses a
ON e.AddressID = a.AddressID