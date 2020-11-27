USE [Diner_restaurant_fbn]
GO

DROP TRIGGER IF EXISTS trg_InvoiceDetail
GO

CREATE TRIGGER trg_InvoiceDetail ON  [InvoiceDetail] AFTER INSERT,DELETE,UPDATE AS 
DECLARE @fkInvoice AS int
DECLARE cInserted CURSOR FOR SELECT fkInvoice FROM inserted
OPEN cInserted
FETCH cInserted INTO @fkInvoice
WHILE (@@FETCH_STATUS=0) BEGIN
	BEGIN
    UPDATE [Invoice] SET totalAmountWithoutTaxes = (SELECT SUM(amountWithoutTaxes) FROM [InvoiceDetail] 
													WHERE fkInvoice=@fkInvoice
													GROUP BY fkInvoice)
					 WHERE idInvoice = @fkInvoice
	UPDATE [Invoice] SET totalAmountWithTaxes = (SELECT SUM(amountWithoutTaxes * (1+(fkTaxRate / 100))) FROM [InvoiceDetail] 
												 WHERE fkInvoice=@fkInvoice
												 GROUP BY fkInvoice)
					 WHERE idInvoice = @fkInvoice
	
	END
	FETCH cInserted INTO @fkInvoice
END
CLOSE cInserted
DEALLOCATE cInserted
DECLARE cDeleted CURSOR FOR SELECT fkInvoice FROM deleted
OPEN cDeleted
FETCH cDeleted INTO @fkInvoice
WHILE (@@FETCH_STATUS=0) BEGIN
	BEGIN
    UPDATE [Invoice] SET totalAmountWithoutTaxes = (SELECT SUM(amountWithoutTaxes) FROM [InvoiceDetail] 
													WHERE fkInvoice=@fkInvoice
													GROUP BY fkInvoice)
					 WHERE idInvoice = @fkInvoice
	UPDATE [Invoice] SET totalAmountWithTaxes = (SELECT SUM(amountWithoutTaxes * (1+(fkTaxRate / 100))) FROM [InvoiceDetail] 
												 WHERE fkInvoice=@fkInvoice
												 GROUP BY fkInvoice)
					 WHERE idInvoice = @fkInvoice
	
	END
	FETCH cDeleted INTO @fkInvoice
END
CLOSE cDeleted
DEALLOCATE cDeleted
GO

SELECT * FROM [Invoice]
GO

INSERT INTO [InvoiceDetail]([fkInvoice], [amountWithoutTaxes], [fkTaxRate], [fkDish]) values 
(1, 100, 7.7, 1),
(1, 99, 7.7, 1)
GO
SELECT * FROM [Invoice]
GO

DELETE FROM [InvoiceDetail]
WHERE amountWithoutTaxes = 99
GO
SELECT * FROM [Invoice]
GO

UPDATE [InvoiceDetail] 
SET amountWithoutTaxes = 200
WHERE amountWithoutTaxes = 100
GO
SELECT * FROM [Invoice]
GO

DELETE FROM [InvoiceDetail]
WHERE amountWithoutTaxes = 200
GO