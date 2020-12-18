USE [Diner_restaurant_fbn]
GO

DROP FUNCTION IF EXISTS Occupation
GO

CREATE FUNCTION Occupation (@startDate AS DATETIME, @endDate AS DATETIME) RETURNS INT AS
BEGIN
	DECLARE @occupation AS INT
	DECLARE @totalBoocking AS INT
	DECLARE @totalTable AS INT
	BEGIN
		IF(@startDate < @endDate)
			BEGIN
				SET @totalBoocking = (SELECT COUNT(*) from [Booking]
					WHERE dateBooking BETWEEN @startDate AND @endDate)
				SET @totalTable = (SELECT DATEDIFF(day,@startDate, @endDate) * COUNT(*) * 2 FROM [table])
				SET @occupation = (CONVERT(INT, @totalBoocking * 100 / @totalTable))
			END
		ELSE
			SET @occupation = (CONVERT(INT, DATEDIFF(day,@startDate, @endDate)))
	END
	RETURN @occupation
END
GO

SELECT dbo.Occupation('2018-12-07 08:00','2018-12-21 08:00')
GO
SELECT dbo.Occupation('2018-11-23 08:00','2018-12-21 08:00')
GO
SELECT dbo.Occupation('2018-12-10 13:00','2018-12-24 21:00')
GO
SELECT dbo.Occupation('2018-12-10 11:00','2018-12-24 18:00')
GO
SELECT dbo.Occupation('2018-12-10','2018-12-24')
GO
SELECT dbo.Occupation('2018-12-19 08:00','2018-12-11 08:00')
GO