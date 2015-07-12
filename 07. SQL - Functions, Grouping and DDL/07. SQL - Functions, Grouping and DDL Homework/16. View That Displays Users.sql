CREATE VIEW [Active Users Today] AS
SELECT * FROM Users AS u
WHERE CAST(u.LastLoginTime AS DATE) = Cast(GetDate() AS DATE)