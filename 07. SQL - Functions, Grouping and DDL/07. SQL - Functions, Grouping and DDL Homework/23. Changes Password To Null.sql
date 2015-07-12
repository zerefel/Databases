ALTER TABLE Users
ALTER COLUMN Password nvarchar(50)

UPDATE Users
SET Password = NULL
WHERE CAST(LastLoginTime AS DATE) < CAST('10-Mar-2010' AS DATE) OR LastLoginTime IS NULL