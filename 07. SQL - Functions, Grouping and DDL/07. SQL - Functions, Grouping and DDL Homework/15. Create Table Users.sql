CREATE TABLE TestUsers
	(Id int PRIMARY KEY NOT NULL IDENTITY,
	 Username nvarchar(50) NOT NULL,
	 Password nvarchar(50) NOT NULL,
	 FullName nvarchar(50) NOT NULL,
	 LastLogin DATE NULL)
GO