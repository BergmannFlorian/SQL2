DROP PROCEDURE IF EXISTS [GenerateBookings]
GO

CREATE PROCEDURE GenerateBookings @firstname VARCHAR(255), @lastname VARCHAR(255) AS 
BEGIN
	DECLARE @datetime as DATETIME
	DECLARE @varcharDate as VARCHAR(30)
	DECLARE @randomH as INT
	DECLARE @fkTable as INT
	DECLARE @i as INT
	SET @i = 1
    WHILE @i < CAST((RAND() * (100)) + 1 AS INT)
    BEGIN
		SET @randomH = CAST((RAND() * (2)) + 1 AS INT)
		IF(@randomH = 1) SET @datetime = CONVERT(DATETIME, CONVERT(DATE, (DATEADD(day, +CAST((RAND()*(20))+1 AS INT), GETDATE())))) + '12:00';
		ELSE SET @datetime = CONVERT(DATETIME, CONVERT(DATE, (DATEADD(day, +CAST((RAND()*(20))+0 AS INT), GETDATE())))) + '19:00';
		SET @fkTable = FLOOR(RAND()*((SELECT COUNT(idTable) from [table]))+1)    
        IF( (select COUNT(fkTable) from booking where fkTable = @fkTable AND dateBooking = @datetime) = 0)
            INSERT INTO booking (dateBooking,nbPers,lastname,firstname,fkTable) VALUES
            (@datetime, FLOOR(RAND()*(6)+1), @lastname, @lastname, @fkTable)
        ELSE
            BEGIN
                SET @varcharDate = convert(varchar(30), @datetime) 
                RAISERROR('the table %d cant be booked for %s', 10, 1, @fkTable, @varcharDate)
            END
        SET @i = @i + 1;
    END
END
GO

exec [GenerateBookings] 'Florian', 'Bergmann'
GO

SELECT * FROM Booking

DELETE FROM Booking