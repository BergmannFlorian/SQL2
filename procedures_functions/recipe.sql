DROP FUNCTION IF EXISTS Recette
GO

CREATE FUNCTION Recette(@dayNumber int) RETURNS @Recette TABLE(Recette INT, error VARCHAR(255)) AS
BEGIN
    DECLARE @sum AS INT
    IF(@dayNumber > 0 AND @dayNumber <= 365)
        BEGIN
            SET @sum = (SELECT SUM(totalAmountWithTaxes) from invoice
                        WHERE CONVERT(DATE, InvoiceDate) BETWEEN CONVERT(DATE, GETDATE()) AND CONVERT(DATE, GETDATE() - @dayNumber))
            INSERT INTO @Recette(Recette) VALUES (@sum);
        END
    ELSE 
        INSERT INTO @Recette(error) VALUES ('Invalid number');
    RETURN
END
GO

SELECT * FROM Recette(7)
GO
SELECT * FROM Recette(1)
GO
SELECT * FROM Recette(-1)
GO
SELECT * FROM Recette(366)
GO