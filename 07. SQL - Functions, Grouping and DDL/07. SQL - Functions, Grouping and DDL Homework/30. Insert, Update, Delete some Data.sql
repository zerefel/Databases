-- INSERT DATA 
DECLARE @EmployeeId int
SET @EmployeeId = (SELECT TOP 1 e.EmployeeID FROM Employees AS e)

INSERT INTO WorkHours(EmployeeId, Date, Task, Hours, Comments) VALUES
	(@EmployeeId, '15-Jun-15', 'Download reports', 2, 'Download monthly reports'),
	(@EmployeeId, '21-Jun-15', 'Calculate month salaries', 8, NULL),
	(@EmployeeId, '25-Jun-15', 'Add new employee', 1, 'Add Stefan Stefanov to Sales Department')

-- UPDATE FIRST ROW
DECLARE @WorkHoursId1 int
SET @WorkHoursId1 = (SELECT TOP 1 WorkHoursId FROM WorkHours ORDER BY WorkHoursId ASC)

UPDATE WorkHours
SET Hours = 10, Date = GETDATE()
WHERE WorkHoursId = @WorkHoursId1

-- DELETE LAST ROW
DECLARE @WorkHoursId2 int
SET @WorkHoursId2 = (SELECT TOP 1 WorkHoursId FROM WorkHours ORDER BY WorkHoursId DESC)

DELETE FROM WorkHours
WHERE WorkHoursId = @WorkHoursId2