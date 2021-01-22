	use Diner_Restaurant_FAO
	go 

	CREATE LOGIN guest WITH PASSWORD = 'guest', DEFAULT_DATABASE = Diner_Restaurant_FAO, CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF;
	CREATE USER Restoguest FOR LOGIN guest;
	
	CREATE LOGIN Joe WITH PASSWORD = 'ch@Nge2-me' MUST_CHANGE, DEFAULT_DATABASE = Diner_Restaurant_FAO, CHECK_POLICY = ON, CHECK_EXPIRATION = ON ;
	CREATE LOGIN Jack WITH PASSWORD = 'ch@Nge2-me' MUST_CHANGE, DEFAULT_DATABASE = Diner_Restaurant_FAO, CHECK_POLICY = ON, CHECK_EXPIRATION = ON ;
	CREATE LOGIN William WITH PASSWORD = 'ch@Nge2-me' MUST_CHANGE, DEFAULT_DATABASE = Diner_Restaurant_FAO, CHECK_POLICY = ON, CHECK_EXPIRATION = ON ;
	CREATE LOGIN Averell WITH PASSWORD = 'ch@Nge2-me' MUST_CHANGE, DEFAULT_DATABASE = Diner_Restaurant_FAO, CHECK_POLICY = ON, CHECK_EXPIRATION = ON ;

	-- Create users
	CREATE USER Joe FOR LOGIN Joe;
	CREATE USER Jack FOR LOGIN Jack;
	CREATE USER William FOR LOGIN William;
	CREATE USER Averell FOR LOGIN Averell; 
	
	GRANT SELECT ON [table] TO Restoguest;
	GRANT SELECT ON [booking] TO Restoguest;
	GRANT SELECT ON Reservations7ProchainsJours to Restoguest

	-- Create a role
	CREATE ROLE RestoAdmin

	-- Add users in the role
	ALTER ROLE RestoAdmin add member Joe
	ALTER ROLE RestoAdmin add member Jack
	ALTER ROLE RestoAdmin add member William
	ALTER ROLE RestoAdmin add member Averell
	
	-- Grant permissions to role
	ALTER ROLE db_datareader add member RestoAdmin
	ALTER ROLE db_datawriter add member RestoAdmin

	-- Customize certain users
	DENY UPDATE, DELETE, INSERT ON [table] TO Averell
	--DENY UPDATE, DELETE, INSERT ON Waiter TO Averell
	DENY UPDATE, DELETE, INSERT ON Waiter TO Averell
	GRANT UPDATE ON Waiter (FirstName) TO Averell

	GRANT CREATE VIEW TO William
	GRANT ALTER ON SCHEMA::dbo TO William

	--EXEC sp_addrolemember 'db_owner', 'Joe';

	-- Create Login/User for the application
	CREATE LOGIN RestoApp WITH PASSWORD = '1q2w3e4r', DEFAULT_DATABASE = Diner_Restaurant_FAO, CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF ;
	CREATE USER RestoApp FOR LOGIN RestoApp;
	ALTER ROLE db_datareader add member RestoApp
	ALTER ROLE db_datawriter add member RestoApp





