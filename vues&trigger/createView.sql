
DROP VIEW IF EXISTS [Reservations7ProchainsJours]
GO
CREATE VIEW [Reservations7ProchainsJours] AS
SELECT lastname, dateBooking, fkTable, phonenumber FROM [Booking]
WHERE dateBooking between GETDATE() and (DATEADD(day, +7, GETDATE()))
GO

DROP VIEW IF EXISTS [PlanifTomorrow]
GO
CREATE VIEW [PlanifTomorrow] AS
SELECT firstName, lastName, dateWork, fkTable FROM [Planning]
JOIN [Waiter] ON [Planning].fkWaiter = [Waiter].idWaiter
JOIN [Responsible] ON [Planning].idPlanning = [Responsible].fkPlanning
WHERE CONVERT(DATE, dateWork) = CONVERT(DATE, (DATEADD(day, +1, GETDATE())))
GO

DROP TRIGGER IF EXISTS [trg_PlanifTomorrow]
GO

CREATE TRIGGER [trg_PlanifTomorrow] ON [PlanifTomorrow] INSTEAD OF INSERT, DELETE, UPDATE AS 
DECLARE @firstName AS VARCHAR(255)
DECLARE @lastName AS VARCHAR(255)
DECLARE @dateWork AS DATE
DECLARE @fkTable AS INT
--INSERT
DECLARE cInserted CURSOR FOR SELECT firstName, lastName, dateWork, fkTable FROM inserted
OPEN cInserted
FETCH cInserted INTO @firstName, @lastName, @dateWork, @fkTable
WHILE (@@FETCH_STATUS=0) BEGIN
    IF((Select count(DISTINCT fkTable) from [PlanifTomorrow] WHERE firstName = @firstName AND lastName = @lastName AND CONVERT(DATE, dateWork) = CONVERT(DATE, @dateWork)) < 8)
		BEGIN
			INSERT INTO [Planning](dateWork, fkWaiter)VALUES(@dateWork, (SELECT idWaiter FROM [Waiter] WHERE firstName = @firstName AND lastName = @lastName))
			INSERT INTO [Responsible](fkPlanning, fkTable)VALUES((SELECT idPlanning FROM [Planning] WHERE idPlanning = @@IDENTITY), @fkTable)
		
		END
	ELSE RAISERROR('Waiter already have 8 table', 10, 1)
	FETCH cInserted INTO @firstName, @lastName, @dateWork, @fkTable
END
CLOSE cInserted
DEALLOCATE cInserted
-- DELETE
DECLARE cDeleted CURSOR FOR SELECT firstName, lastName, dateWork FROM deleted
OPEN cDeleted
FETCH cDeleted INTO @firstName, @lastName, @dateWork
WHILE (@@FETCH_STATUS=0) BEGIN
	BEGIN
		print '--------------'
		print @firstName
		print @lastName
		print @dateWork
		print '--------------'
		DELETE FROM [Responsible] WHERE fkPlanning IN (	SELECT idPlanning FROM [Planning] 
														JOIN [Waiter] ON fkWaiter = idWaiter 
														WHERE firstName = @firstName 
															AND lastName = @lastName 
															AND CONVERT(DATE, dateWork) = CONVERT(DATE, @dateWork))
		DELETE FROM [Planning] WHERE idPlanning IN (SELECT idPlanning FROM [Planning] 
													JOIN [Waiter] ON fkWaiter = idWaiter 
													WHERE firstName = @firstName 
														AND lastName = @lastName 
														AND CONVERT(DATE, dateWork) = CONVERT(DATE, @dateWork))
		END
	FETCH cDeleted INTO @firstName, @lastName, @dateWork
END
CLOSE cDeleted
DEALLOCATE cDeleted
GO

SELECT * FROM [Diner_restaurant_fbn].[dbo].[PlanifTomorrow]
GO
INSERT INTO [PlanifTomorrow](firstName, lastName, dateWork, fkTable) VALUES
('Eva', 'Risselle', DATEADD(day, +1, GETDATE()), 1),
('Eva', 'Risselle', DATEADD(day, +1, GETDATE()), 2),
('Eva', 'Risselle', DATEADD(day, +1, GETDATE()), 3),
('Eva', 'Risselle', DATEADD(day, +1, GETDATE()), 4),
('Eva', 'Risselle', DATEADD(day, +1, GETDATE()), 5),
('Eva', 'Risselle', DATEADD(day, +1, GETDATE()), 6),
('Eva', 'Risselle', DATEADD(day, +1, GETDATE()), 7),
('Eva', 'Risselle', DATEADD(day, +1, GETDATE()), 8),
('Eva', 'Risselle', DATEADD(day, +1, GETDATE()), 9),
('Eva', 'Risselle', DATEADD(day, +1, GETDATE()), 10)
GO

SELECT * FROM [Diner_restaurant_fbn].[dbo].[PlanifTomorrow]
GO
DELETE FROM [PlanifTomorrow] WHERE firstName = 'Eva' AND lastName = 'Risselle' AND dateWork = CONVERT(DATE, DATEADD(day, +1, GETDATE()))
GO

SELECT * FROM [Diner_restaurant_fbn].[dbo].[PlanifTomorrow]
GO