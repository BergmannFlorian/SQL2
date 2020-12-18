DROP FUNCTION IF EXISTS ListBookings
GO

CREATE FUNCTION ListBookings() RETURNS TABLE AS
    RETURN (SELECT dateBooking, nbPers, phonenumber, lastname, firstname, fkTable AS [table] FROM Booking WHERE CONVERT(DATE, [dateBooking]) > CONVERT(DATE, GETDATE()))
GO

SELECT * FROM ListBookings()
GO