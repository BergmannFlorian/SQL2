USE Diner_restaurant_fbn
GO

DROP FUNCTION IF EXISTS FrequentCustomers
GO

CREATE FUNCTION FrequentCustomers(@frequence AS INT, @dateStart AS DATETIME, @dateEnd AS DATETIME) RETURNS @FrequentCustomers TABLE(Firstname VARCHAR(255), Lastname VARCHAR(255), error VARCHAR(255)) AS
BEGIN
    DECLARE @firstname AS VARCHAR(255)
    DECLARE @lastname AS VARCHAR(255)
    DECLARE @idBoocking AS INT
    DECLARE @idBoocking1 AS INT
    DECLARE @inserted AS BIT
    DECLARE @date1 AS DATETIME
    DECLARE @date2 AS DATETIME

    IF(@frequence <= 0) BEGIN
        INSERT INTO @FrequentCustomers (error) VALUES ('Pas possible pour un jour négatif')
    END
    IF(@frequence > DATEDIFF(day, @dateStart, @dateEnd)) BEGIN
        INSERT INTO @FrequentCustomers (error) VALUES ('Internval plus grand que la durée réel')
    END
    IF(@dateStart >= @dateEnd) BEGIN
        INSERT INTO @FrequentCustomers (error) VALUES ('La date de départ doit être plus petite que la date de fin')
    END
    IF( (SELECT COUNT(*) FROM @FrequentCustomers) = 0) BEGIN
        DECLARE cClients CURSOR FOR SELECT DISTINCT lastname, firstname FROM Booking WHERE dateBooking BETWEEN @dateStart AND @dateEnd
        OPEN cClients    

        FETCH cClients INTO @lastname, @firstname
        WHILE (@@FETCH_STATUS = 0 ) BEGIN
            SET @inserted = 'false'
            DECLARE cBoockings CURSOR FOR SELECT idBooking FROM Booking WHERE lastname = @lastname AND firstname = @firstname
            OPEN cBoockings
            FETCH cBoockings INTO @idBoocking

            WHILE (@@FETCH_STATUS=0 AND @inserted = 'false') BEGIN
                SET @date1 = (SELECT dateBooking FROM booking WHERE idBooking = @idBoocking)
                SET @date2 = (SELECT dateBooking FROM booking WHERE idBooking = @idBoocking1)
            
                IF(DATEDIFF(day, @date1, @date2) <= @frequence) BEGIN
                    INSERT INTO @FrequentCustomers (Firstname, Lastname) VALUES (@firstname, @lastname)
                    SET @inserted = 'true'
                END
                SET @idBoocking1 = @idBoocking
                FETCH cBoockings INTO @idBoocking
            END

            FETCH cClients INTO @lastname, @firstname
            CLOSE cBoockings
            DEALLOCATE cBoockings
        END
    END
    RETURN
END
GO

SELECT * FROM FrequentCustomers(8,DATEADD(MONTH,-1, GETDATE()),GETDATE())
GO