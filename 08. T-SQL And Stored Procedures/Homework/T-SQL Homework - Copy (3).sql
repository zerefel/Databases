CREATE DATABASE BANK
GO

USE BANK
GO

-- Create table People
CREATE TABLE People 
(Id int PRIMARY KEY IDENTITY NOT NULL,
FirstName nvarchar(50) NOT NULL,
LastName nvarchar(50) NOT NULL,
SSN nvarchar(10) NOT NULL)
GO
---- Create table Accounts
CREATE TABLE Accounts
(Id int PRIMARY KEY IDENTITY NOT NULL,
PersonId int FOREIGN KEY REFERENCES People(Id) NOT NULL,
Balance money NOT NULL)
GO

INSERT INTO People(FirstName, LastName, SSN) 
	VALUES ('Ivan', 'Todorov', '1234567890'),
	('Tosho', 'Goshov', '0985215215'), 
	('Doktor', 'Nakov', '5952915919')
GO

INSERT INTO Accounts(PersonId, Balance)
VALUES (1, 5215.51), 
	   (2, 2157578.52),
	   (3, 99999999.99)


--Create Stored Procedure to get Full Name of a Person
CREATE PROC sp_FullNames
AS
BEGIN
	SELECT FirstName + ' ' + LastName AS [Full Name] FROM People 
END

EXEC sp_FullNames



-- Create Stored Procedure to get all People by their balance from Accounts
ALTER PROC sp_PeopleWithHigherThanXMoney(@balance AS MONEY)
AS
BEGIN
	SELECT p.FirstName, p.LastName, a.Balance FROM People AS p
	JOIN Accounts AS a
	ON p.Id = a.PersonId
	WHERE Balance >= @balance
END

EXEC sp_PeopleWithHigherThanXMoney '5215.53'
GO


-- CREATE CALCULATE INTEREST FUNCTION
ALTER FUNCTION ufn_CalculateInterest
	(
		@sum AS MONEY,
		@interest AS FLOAT,
		@months AS INT
	)
	RETURNS MONEY
AS
BEGIN
	DECLARE @interestPercentage FLOAT,
			@moneyAfterInterest MONEY;
	SET @interestPercentage = @interest / 100;
	
	SET @moneyAfterInterest =  @sum * (@interestPercentage / 12) * @months;

	RETURN @moneyAfterInterest;
END
-- EXECUTE THE FUNCTION WITH A SELECT STATEMENT
SELECT Balance, dbo.ufn_CalculateInterest(Balance, 2, 12) AS [Calculated Interest] FROM Accounts
GO



-- CREATE A STORED PROCEDURE THAT USES THE FUNCTION
ALTER PROCEDURE usp_UpdateMonthlyAccountInterest 
	(
		@accountId AS INT,
		@interest AS FLOAT
	)
AS
BEGIN
	DECLARE @accountBalance MONEY,
			@moneyAfterInterest MONEY;

	-- FIND THE CURRENT ACCOUNT BALANCE
	SET @accountBalance = 
	(SELECT Balance FROM Accounts AS a
	 WHERE a.Id = @accountId)

	 SET @moneyAfterInterest = dbo.ufn_CalculateInterest(@accountBalance, @interest, 1)

	 -- UPDATE THE BALANCE ON THAT PERSON'S ACCOUNT
	 UPDATE Accounts
	 SET Balance = (@moneyAfterInterest + @accountBalance)
	 WHERE Id = @accountId
END



-- TEST TO SEE IF THE BALANCE UPDATE SUCCESSFULLY
EXEC dbo.usp_UpdateMonthlyAccountInterest 1, 3

SELECT Balance FROM Accounts AS a
WHERE a.Id = 1



-- PROCEDURE TO WITHDRAW MONEY FROM ACCOUNT
ALTER PROCEDURE usp_WithdrawMoney
	(
		@accountId AS INT,
		@amount AS MONEY
	)
AS
BEGIN
	DECLARE @accountBalance MONEY,
			@leftAmount MONEY;

	SET @accountBalance = 
	(SELECT Balance FROM Accounts AS a
	 WHERE a.Id = @accountId)

	 BEGIN TRAN
	 SET @leftAmount = @accountBalance - @amount;

	 IF @leftAmount> 0
		BEGIN
			UPDATE Accounts
			SET Balance = (@leftAmount)
			WHERE @accountId = Id
			PRINT 'Withdraw successful, you now have ' + CAST(@leftAmount AS nvarchar) + ' money left in your account.';
			COMMIT TRAN
		END
	ELSE 
		BEGIN
			PRINT 'Withdraw unsuccessful, not enough money in your account.';
			ROLLBACK TRAN
		END
END

 EXEC usp_WithdrawMoney 1, 50

SELECT Balance FROM Accounts AS a
	 WHERE a.Id = 1

 -- CREATE DEPOSIT MONEY PROCEDURE
CREATE PROCEDURE usp_DepositMoney
	(
		@accountId AS INT,
		@amount AS MONEY
	)
AS
BEGIN
	DECLARE @accountBalance MONEY,
			@newAmount MONEY;

	SET @accountBalance = 
	(SELECT Balance FROM Accounts AS a
	 WHERE a.Id = @accountId)

	 BEGIN TRAN
	 SET @newAmount = @accountBalance + @amount;

	 IF @amount > 0
		BEGIN
			UPDATE Accounts
			SET Balance = (@newAmount)
			WHERE @accountId = Id
			PRINT 'Deposit successful, you now have ' + CAST(@newAmount AS nvarchar) + ' money in your account.';
			COMMIT TRAN
		END
	ELSE 
		BEGIN
			PRINT 'Deposit unsuccessful, you cannot deposit negative values.';
			ROLLBACK TRAN
		END
END

 EXEC usp_DepositMoney 1, 59.584375872752

 SELECT Balance FROM Accounts AS a
	 WHERE a.Id = 1



-- CREATE LOGS TABLE
CREATE TABLE Logs
	(
		Id int PRIMARY KEY IDENTITY NOT NULL,
		AccountId int FOREIGN KEY References Accounts(Id),
		OldSum money NOT NULL,
		NewSum money NOT NULL
	)
GO