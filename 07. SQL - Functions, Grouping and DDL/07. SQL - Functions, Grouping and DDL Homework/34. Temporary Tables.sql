BEGIN TRAN

DECLARE @EmployeesProjects TABLE(
	EmployeeID int NOT NULL,
	ProjectID int NOT NULL
)

INSERT INTO @EmployeesProjects 
	SELECT * FROM EmployeesProjects

DROP TABLE EmployeesProjects

CREATE TABLE EmployeesProjects(
	EmployeeID int NOT NULL,
	ProjectID int NOT NULL
)

SELECT * FROM EmployeesProjects

INSERT INTO EmployeesProjects
	SELECT * FROM @EmployeesProjects

SELECT * FROM EmployeesProjects

ROLLBACK