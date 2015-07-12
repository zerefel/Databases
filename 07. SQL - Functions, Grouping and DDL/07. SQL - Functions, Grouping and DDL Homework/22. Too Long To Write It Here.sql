ALTER TABLE Users
	ALTER COLUMN LastLoginTime Date NULL

INSERT INTO Users(Username, Password, FullName)
SELECT LEFT(FirstName, 1) + LastName, NULL, FirstName + ' ' + LastName FROM Employees