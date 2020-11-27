
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
WHERE dateWork = (DATEADD(day, +1, GETDATE()))
GO