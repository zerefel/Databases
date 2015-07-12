REATE TABLE WorkHoursLogs(
	Message nvarchar(200) NOT NULL,
	DateOfChange datetime NOT NULL)
GO

CREATE TRIGGER tr_WorhHoursInsert
ON WorkHours 
FOR INSERT
AS 
	INSERT INTO WorkHoursLogs(Message, DateOfChange) VALUES
		('Added row', GETDATE())
GO

CREATE TRIGGER tr_WorhHoursUpdate
ON WorkHours 
FOR UPDATE
AS 
	INSERT INTO WorkHoursLogs(Message, DateOfChange) VALUES
		('Updated row', GETDATE())
GO

CREATE TRIGGER tr_WorhHoursDelete
ON WorkHours 
FOR DELETE
AS 
	INSERT INTO WorkHoursLogs(Message, DateOfChange) VALUES
		('Deleted row', GETDATE())
GO

-- Test INSERT
DECLARE @EmployeeId int
SET @EmployeeId = (SELECT TOP 1 e.EmployeeID FROM Employees AS e)

INSERT INTO WorkHours(EmployeeId, Date, Task, Hours, Comments) VALUES
	(@EmployeeId, '15-Jun-15', 'Download reports', 2, 'Download monthly reports'),
	(@EmployeeId, '21-Jun-15', 'Calculate month salaries', 8, NULL),
	(@EmployeeId, '25-Jun-15', 'Add new employee', 1, 'Add Stefan Stefanov to Sales Department')

-- TEST UPDATE
DECLARE @WorkHoursId1 int
SET @WorkHoursId1 = (SELECT TOP 1 WorkHoursId FROM WorkHours ORDER BY WorkHoursId ASC)

UPDATE WorkHours
SET Hours = 10, Date = GETDATE()
WHERE WorkHoursId = @WorkHoursId1

-- TEST DELETE
DECLARE @WorkHoursId2 int
SET @WorkHoursId2 = (SELECT TOP 1 WorkHoursId FROM WorkHours ORDER BY WorkHoursId DESC)

DELETE FROM WorkHours
WHERE WorkHoursId = @WorkHoursId2