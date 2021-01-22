-- Diner_Restaurant_Eleves.sql:	This script creates a database for the management of booking and invoice of a restaurant
--				The database is initialized with fake data and data coming from the restaurant "Hotel de Ville" in Echallens
--				
-- Version:		1.0, january 2021
-- Author:		F. Andolfatto
--
-- History:
--			1.0 Database creation
--
--

USE master
GO

SET NOCOUNT OFF

-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
-- Suppression de la base de donn�es
-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
IF (EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = 'Diner_Restaurant_Eleves'))
BEGIN
	/**Deconnexion de tous les utilsateurs sauf l'administrateur**/
	/**Annulation immediate de toutes les transactions**/
	ALTER DATABASE Diner_Restaurant_Eleves SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

	/**Suppression de la base de donn�es**/
	DROP DATABASE Diner_Restaurant_Eleves;
END
GO

-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
-- CreationDatabase
-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
--adapter le path des fichiers de donn�es et des journaux de logs de la BD

CREATE DATABASE Diner_Restaurant_Eleves
 ON  PRIMARY 
( NAME = N'Diner_Restaurant_Eleves', FILENAME = N'C:\Data\MSSQL\Diner_Restaurant_Eleves.mdf' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'Diner_Restaurant_Eleves_LOG', FILENAME = N'C:\Data\MSSQL\Diner_Restaurant_Eleves_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO

-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
-- Cr�ation des tables
-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------


USE Diner_Restaurant_Eleves
GO

CREATE TABLE [Invoice] (
	idInvoice int IDENTITY(1,1) PRIMARY KEY,
	invoiceNumber varchar(45) NOT NULL,
	totalAmountWithTaxes decimal(10,2) NOT NULL,
	totalAmountWithoutTaxes decimal(10,2) NOT NULL,
	invoiceDate datetime NOT NULL, 
	fkWaiter int NOT NULL,
	fkTable int NOT NULL,
	fkPaymentCond int);

CREATE TABLE InvoiceDetail (
	idInvoiceDetail int IDENTITY(1,1) PRIMARY KEY,
	quantity int NOT NULL,
	amountWithTaxes decimal(10,2) NOT NULL,
	fkInvoice int NOT NULL, 
	fkTaxRate decimal(4,2) NOT NULL,
	fkDish int, 
	fkMenu int);
	
CREATE TABLE Dish (
	idDish int IDENTITY(1,1) PRIMARY KEY,
	dishDescription varchar(100) NOT NULL, 
	fkDishType int NOT NULL, 
	fkMenu int, 
	amountWithTaxes decimal(5,2) NOT NULL);

CREATE TABLE Menu (
	idMenu int IDENTITY(1,1) PRIMARY KEY,
	menuName varchar(50) NOT NULL, 
	amountWithTaxes decimal (5,2) NOT NULL);

CREATE TABLE DishType (
	idDishType int primary key,
	dishTypeName varchar(100) NOT NULL);

CREATE TABLE TaxRate (
	taxRateValue decimal(4,2) PRIMARY KEY, 
	[description] varchar(100) );

CREATE TABLE [Table] (
	idTable int IDENTITY(1,1) PRIMARY KEY,
	capacity tinyint NOT NULL);

CREATE TABLE Waiter (
	idWaiter int  IDENTITY(1,1) PRIMARY KEY,
	firstName varchar(35) NOT NULL,
	lastName varchar(35) NOT NULL,
	fkWaiterGroup int NULL);

CREATE TABLE WaiterGroup (
	idWaiterGroup int  IDENTITY(1,1) PRIMARY KEY,
	name varchar(35) NOT NULL);

CREATE TABLE Planning (
	idPlanning int IDENTITY(1,1) PRIMARY KEY,
	dateWork datetime NOT NULL,
	fkWaiter int NOT NULL);

CREATE TABLE Responsible (
	fkPlanning int NOT NULL,
	fkTable int NOT NULL,
	PRIMARY KEY(fkPlanning, fkTable));

CREATE TABLE PaymentCondition (
	idPaymentCond int IDENTITY(1,1) PRIMARY KEY,
	description varchar(100) NOT NULL,
	reduction decimal(4,2) NOT NULL);

CREATE TABLE Booking (
	idBooking int IDENTITY(1,1) PRIMARY KEY,
	dateBooking datetime NOT NULL,
	nbPers tinyint NOT NULL,
	phonenumber varchar(20),
	lastname varchar(35) NOT NULL,
	firstname varchar(35),
	fkTable int NOT NULL);

GO


ALTER TABLE Invoice  WITH CHECK ADD  CONSTRAINT FK_invoice_waiter FOREIGN KEY(fkWaiter)
REFERENCES Waiter (idwaiter);

ALTER TABLE Waiter  WITH CHECK ADD  CONSTRAINT FK_waiter_waitergroup FOREIGN KEY(fkWaiterGroup)
REFERENCES WaiterGroup (idWaiterGroup);

ALTER TABLE Invoice  WITH CHECK ADD  CONSTRAINT FK_invoice_table FOREIGN KEY(fkTable)
REFERENCES [Table] (idTable);

ALTER TABLE Invoice  WITH CHECK ADD  CONSTRAINT FK_invoice_paymcond FOREIGN KEY(fkPaymentCond)
REFERENCES PaymentCondition (idPaymentCond);
--on delete cascade;

ALTER TABLE InvoiceDetail  WITH CHECK ADD  CONSTRAINT FK_invoicedetail_invoice FOREIGN KEY(fkInvoice)
REFERENCES Invoice (idInvoice)

ALTER TABLE InvoiceDetail  WITH CHECK ADD  CONSTRAINT FK_invoicedetail_taxrate FOREIGN KEY(fkTaxRate)
REFERENCES TaxRate (taxRateValue)

ALTER TABLE InvoiceDetail  WITH CHECK ADD  CONSTRAINT FK_invoicedetail_dish FOREIGN KEY(fkDish)
REFERENCES Dish (idDish)

ALTER TABLE InvoiceDetail  WITH CHECK ADD  CONSTRAINT FK_invoicedetail_menu FOREIGN KEY(fkMenu)
REFERENCES Menu (idMenu)

ALTER TABLE Dish WITH CHECK ADD  CONSTRAINT FK_dish_dishtype FOREIGN KEY(fkDishType)
REFERENCES DishType (idDishType)

ALTER TABLE Dish WITH CHECK ADD  CONSTRAINT FK_dish_menu FOREIGN KEY(fkMenu)
REFERENCES Menu (idMenu)

ALTER TABLE Booking WITH CHECK ADD CONSTRAINT FK_booking_table FOREIGN KEY(fkTable)
REFERENCES [table] (idTable)
--ON DELETE CASCADE

ALTER TABLE Planning WITH CHECK ADD CONSTRAINT FK_planning_waiter FOREIGN KEY(fkWaiter)
REFERENCES waiter (idwaiter)
ON DELETE CASCADE

ALTER TABLE Responsible WITH CHECK ADD CONSTRAINT FK_resp_planning FOREIGN KEY(fkPlanning)
REFERENCES planning (idplanning)

ALTER TABLE Responsible WITH CHECK ADD CONSTRAINT FK_resp_table FOREIGN KEY(fkTable)
REFERENCES [table] (idtable)


alter table waiter add unique (firstname, lastname)

alter table booking add check (dateBooking > GETDATE() and datebooking < DATEADD(MONTH, 2, GETDATE()))

alter table planning add check (dateWork > GETDATE())

--alter table InvoiceDetail add check (fkDish is not null or fkMenu is not null)


--Data

insert into waiter(firstname, lastName) values ('Eva', 'Risselle');
insert into waiter(firstname, lastName) values ('Marylou', 'Koume');
insert into waiter(firstname, lastName) values ('Magali', 'Ma�on');
insert into Waiter (firstName, lastName) values ('Harry', 'Cover');
insert into Waiter (firstName, lastName) values ('Tom', 'Hatte');
insert into Waiter (firstName, lastName) values ('Sam', 'Chatouille');

insert into PaymentCondition (description, reduction) values ('Passeport gourmand pour 2 personnes', 0.5);
insert into PaymentCondition (description, reduction) values ('Passeport gourmand pour 3 personnes', 0.33);
insert into PaymentCondition (description, reduction) values ('Passeport gourmand pour 4 personnes', 0.25);
insert into PaymentCondition (description, reduction) values ('CPNV', 0.1);
insert into PaymentCondition (description, reduction) values ('La Poste', 0.05);
insert into PaymentCondition (description, reduction) values ('Philip Morris', 0.1);

insert into [Table] (capacity) values (2);
insert into [Table] (capacity) values (4);
insert into [Table] (capacity) values (6);
insert into [Table] (capacity) values (2);
insert into [Table] (capacity) values (2);
insert into [Table] (capacity) values (4);
insert into [Table] (capacity) values (4);
insert into [Table] (capacity) values (6);
insert into [Table] (capacity) values (2);
insert into [Table] (capacity) values (2);
insert into [Table] (capacity) values (4);
insert into [Table] (capacity) values (4);
insert into [Table] (capacity) values (2);
insert into [Table] (capacity) values (6);

insert into TaxRate values (7.7, 'Taxe suisse standard');
insert into TaxRate values (2.5, 'Taxe r�duit');
insert into TaxRate values (3.7, 'Taxe sp�cial h�bergement');

insert into invoice (invoiceNumber, totalAmountWithTaxes, totalAmountWithoutTaxes, invoiceDate, fkWaiter, fkTable, fkPaymentCond) 
values ('A12345', 107.7, 100.00, '2021-01-15', 1, 3, 5)

insert into invoice (invoiceNumber, totalAmountWithTaxes, totalAmountWithoutTaxes, invoiceDate, fkWaiter, fkTable, fkPaymentCond) 
values ('A12346', 215.4, 200.00, '2021-01-15', 1, 5, 6)

insert into invoice (invoiceNumber, totalAmountWithTaxes, totalAmountWithoutTaxes, invoiceDate, fkWaiter, fkTable, fkPaymentCond) 
values ('B987654', 134.63, 125.00, '2021-01-15', 1, 11, 2)

insert into invoice (invoiceNumber, totalAmountWithTaxes, totalAmountWithoutTaxes, invoiceDate, fkWaiter, fkTable, fkPaymentCond) 
values ('C456782', 156.38, 145.20, '2021-01-15', 1, 8, 6)

insert into invoice (invoiceNumber, totalAmountWithTaxes, totalAmountWithoutTaxes, invoiceDate, fkWaiter, fkTable, fkPaymentCond) 
values ('C894523', 118.47, 110.00, '2021-01-15', 1, 9, 1)

insert into invoice (invoiceNumber, totalAmountWithTaxes, totalAmountWithoutTaxes, invoiceDate, fkWaiter, fkTable) 
values ('B112233', 107.7, 100.00, '2021-01-16', 1, 11)

insert into invoice (invoiceNumber, totalAmountWithTaxes, totalAmountWithoutTaxes, invoiceDate, fkWaiter, fkTable, fkPaymentCond) 
values ('C445566', 91.55, 85.00, '2021-01-16', 1, 8, 6)

insert into invoice (invoiceNumber, totalAmountWithTaxes, totalAmountWithoutTaxes, invoiceDate, fkWaiter, fkTable, fkPaymentCond) 
values ('C778899', 84.00, 78.00, '2021-01-16', 1, 9, 1)

insert into DishType (idDishType,DishTypeName) values (1, 'Entr�es')
insert into DishType (idDishType,DishTypeName) values (2, 'Poissons')
insert into DishType (idDishType,DishTypeName) values (3, 'Viandes')
insert into DishType (idDishType,DishTypeName) values (4, 'Fromages')
insert into DishType (idDishType,DishTypeName) values (5, 'Desserts')


insert into dish (dishdescription, amountWithTaxes, fkDishType) values ('Ravioles d''�pinards et ricotta aux truffes ',28,1)
insert into dish (dishdescription, amountWithTaxes, fkDishType) values ('Gravlax de chevreuil aux citrons confits et c�prons',30,1)
insert into dish (dishdescription, amountWithTaxes, fkDishType) values ('Op�ra de foie gras aux fruits secs et betteraves',30,1)
insert into dish (dishdescription, amountWithTaxes, fkDishType) values ('Sole enti�re aux amandes, strudel aux l�gumes anciens',47,2)
insert into dish (dishdescription, amountWithTaxes, fkDishType) values ('Escalope de saumon � la cr�me de thym',19.5,2)
insert into dish (dishdescription, amountWithTaxes, fkDishType) values ('Daube d''encornets et Saint-Jacques',48,2)
insert into dish (dishdescription, amountWithTaxes, fkDishType) values ('Rouget barbet farci aux l�gumes et coquillages',51,2)
insert into dish (dishdescription, amountWithTaxes, fkDishType) values ('M�daillons de renne en cro�te de fruits secs et poivre',51,3)
insert into dish (dishdescription, amountWithTaxes, fkDishType) values ('Carr� de porc � la moutarde',19.5,3)
insert into dish (dishdescription, amountWithTaxes, fkDishType) values ('Mignons de sanglier en habit de lard',44,3)
insert into dish (dishdescription, amountWithTaxes, fkDishType) values ('B�uf brais� � l''ancienne',19.5,3)
insert into dish (dishdescription, amountWithTaxes, fkDishType) values ('R�ble de lapin aux truffes et foie gras chaud (par 2 pers.) ',48,3)
insert into dish (dishdescription, amountWithTaxes, fkDishType) values ('Steak hach� b�uf et porc au poivre',19.5,3)
insert into dish (dishdescription, amountWithTaxes, fkDishType) values ('Selle de chevreuil aux sp�culoos �(d�s 2 pers.) ',52,3)
insert into dish (dishdescription, amountWithTaxes, fkDishType) values ('Assiette de fromages ',21,4)
insert into dish (dishdescription, amountWithTaxes, fkDishType) values ('Chaud-froid au chocolat noir,�glace caramel et beurre sal�',19,5)
insert into dish (dishdescription, amountWithTaxes, fkDishType) values ('Disque de g�teaux aux noix, ganache au lait',20,5)
insert into dish (dishdescription, amountWithTaxes, fkDishType) values ('Symphonie de cr�mes br�l�es aux saveurs diff�rentes',19,5)
insert into dish (dishdescription, amountWithTaxes, fkDishType) values ('Mille-feuilles chantilly aux ch�taignes',20,5)

insert into Planning (dateWork, fkWaiter) values ('2021.02.01', 3)
insert into Planning (dateWork, fkWaiter) values ('2021.02.02', 3)
insert into Planning (dateWork, fkWaiter) values ('2021.02.04', 3)
insert into Planning (dateWork, fkWaiter) values ('2021.02.05', 3)
insert into Planning (dateWork, fkWaiter) values ('2021.02.06', 3)

insert into InvoiceDetail (quantity, amountWithTaxes, fkInvoice, fkTaxRate) values (2, 50.00, 2, 7.7 )

USE Diner_Restaurant_Eleves
GO

CREATE TABLE [User](
	[idUser] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[firstname] [varchar](50) NULL,
	[lastname] [varchar](50) NOT NULL)
GO

insert into [user](firstname, lastname) values ( 'Quentin','AELLEN')
insert into [user](firstname, lastname) values ( 'Marwan','ALHELO')
insert into [user](firstname, lastname) values ( 'Joao-Paulo','ALIPIO-PENEDO')
insert into [user](firstname, lastname) values ( 'Roderick','ANGELOZ')
insert into [user](firstname, lastname) values ( 'Yann','APOTHELOZ')
insert into [user](firstname, lastname) values ( 'Laurent','BARRAUD')
insert into [user](firstname, lastname) values ( 'Alexandre','BASEIA')
insert into [user](firstname, lastname) values ( 'Luca','BASSI')
insert into [user](firstname, lastname) values ( 'Yannick','BAUDRAZ')
insert into [user](firstname, lastname) values ( 'Florian','BERGMANN')
insert into [user](firstname, lastname) values ( 'Dylan','BERNEY')
insert into [user](firstname, lastname) values ( 'Jan','BLATTER')
insert into [user](firstname, lastname) values ( 'Ian','BOEHLER')
insert into [user](firstname, lastname) values ( 'Jessy','BORCARD')
insert into [user](firstname, lastname) values ( 'Arthur','BOURGUE')
insert into [user](firstname, lastname) values ( 'Bruno','BRACAMONTE')
insert into [user](firstname, lastname) values ( 'Rodrigue','BRUPPACHER')
insert into [user](firstname, lastname) values ( 'Franck-Luca','BULLIARD')
insert into [user](firstname, lastname) values ( 'Jimmy','CATARINO-DINIS')
insert into [user](firstname, lastname) values ( 'Milos','CEROVIC')
insert into [user](firstname, lastname) values ( 'Damien','CHERVET')
insert into [user](firstname, lastname) values ( 'Bastian','CHOLLET')
insert into [user](firstname, lastname) values ( 'Luca','CODURI')
insert into [user](firstname, lastname) values ( 'Theo','COOK')
insert into [user](firstname, lastname) values ( 'Mauricio','COSTA-CABRAL')
insert into [user](firstname, lastname) values ( 'Mauro-Alexandre','COSTA-DOS-SANTOS')
insert into [user](firstname, lastname) values ( 'Ingo','COTTIER')
insert into [user](firstname, lastname) values ( 'Jason','CRISANTE')
insert into [user](firstname, lastname) values ( 'Simon','CUANY')
insert into [user](firstname, lastname) values ( 'Dylan-David','CUNHA-ROCHA')
insert into [user](firstname, lastname) values ( 'Bruno','DA-COSTA-LOURENCO')
insert into [user](firstname, lastname) values ( 'Catarina','DE-JESUS')
insert into [user](firstname, lastname) values ( 'Guilherme','DE-OLIVEIRA-CALHAU')
insert into [user](firstname, lastname) values ( 'Joris','DECOPPET')
insert into [user](firstname, lastname) values ( 'Kevin','DOS-SANTOS-ALVES')
insert into [user](firstname, lastname) values ( 'Joel','DOS-SANTOS-MATIAS')
insert into [user](firstname, lastname) values ( 'Guillaume','DUVOISIN')
insert into [user](firstname, lastname) values ( 'Kaarththigan','EAASWARALINGAM')
insert into [user](firstname, lastname) values ( 'Theo','ESSEIVA')
insert into [user](firstname, lastname) values ( 'Bryan','EVANGELISTI')
insert into [user](firstname, lastname) values ( 'Naima','FAHMY-HANNA')
insert into [user](firstname, lastname) values ( 'Bastien','FARDEL')
insert into [user](firstname, lastname) values ( 'Zacharie','FAVRE')
insert into [user](firstname, lastname) values ( 'Arben','FERATI')
insert into [user](firstname, lastname) values ( 'Luis-Pedro','FERNANDES-PINHEIRO')
insert into [user](firstname, lastname) values ( 'Ricardo-Joao','FERREIRA-DANTAS')
insert into [user](firstname, lastname) values ( 'Filipe','FERREIRA-DANTAS')
insert into [user](firstname, lastname) values ( 'Tiago-Manuel','FERREIRA-OLIVEIRA')
insert into [user](firstname, lastname) values ( 'Mounir-Yann','FIAUX')
insert into [user](firstname, lastname) values ( 'Alexandre','FONTES')
insert into [user](firstname, lastname) values ( 'Kevin','GACON')
insert into [user](firstname, lastname) values ( 'Maxime','GAILLARD')
insert into [user](firstname, lastname) values ( 'Sylvain','GANDINI')
insert into [user](firstname, lastname) values ( 'Theo','GAUTIER')
insert into [user](firstname, lastname) values ( 'Loic','GAVIN')
insert into [user](firstname, lastname) values ( 'Niels','GERMANN')
insert into [user](firstname, lastname) values ( 'Luca','GIANNANTONIO')
insert into [user](firstname, lastname) values ( 'Esteban','GIORGIS')
insert into [user](firstname, lastname) values ( 'Maxim','GOLAY')
insert into [user](firstname, lastname) values ( 'Cyril','GOLDENSCHUE')
insert into [user](firstname, lastname) values ( 'Adrien','GOY')
insert into [user](firstname, lastname) values ( 'Sebastien','GRANDJEAN')
insert into [user](firstname, lastname) values ( 'Thomas','GROSSMANN')
insert into [user](firstname, lastname) values ( 'Adam','GRUBER')
insert into [user](firstname, lastname) values ( 'Jonathan','GRUNDER')
insert into [user](firstname, lastname) values ( 'Diego','HALDI')
insert into [user](firstname, lastname) values ( 'William','HAUSMANN')
insert into [user](firstname, lastname) values ( 'Jonas','HAUTIER')
insert into [user](firstname, lastname) values ( 'Michael','HOFER')
insert into [user](firstname, lastname) values ( 'Thomas','HUGUET')
insert into [user](firstname, lastname) values ( 'Anthony','JACCARD')
insert into [user](firstname, lastname) values ( 'Luke','JACOBSON')
insert into [user](firstname, lastname) values ( 'Szymon','JAGLA')
insert into [user](firstname, lastname) values ( 'Damien','JAKOB')
insert into [user](firstname, lastname) values ( 'Eqbal','JALALY')
insert into [user](firstname, lastname) values ( 'Jerome','JAQUEMET')
insert into [user](firstname, lastname) values ( 'Gatien','JAYME')
insert into [user](firstname, lastname) values ( 'Anthony','JOST')
insert into [user](firstname, lastname) values ( 'Jeremy','JUNGO')
insert into [user](firstname, lastname) values ( 'Stephane','JUNOD')
insert into [user](firstname, lastname) values ( 'Nicolas','KAELIN')
insert into [user](firstname, lastname) values ( 'Ahmad-Bilal','KAKAR')
insert into [user](firstname, lastname) values ( 'Christnovie','KIALA-BINGA')
insert into [user](firstname, lastname) values ( 'Luana','KIRCHNER-BANNWART')
insert into [user](firstname, lastname) values ( 'Nathan','LERCH')
insert into [user](firstname, lastname) values ( 'Nicolas','MAITRE')
insert into [user](firstname, lastname) values ( 'Fabien','MASSON')
insert into [user](firstname, lastname) values ( 'Theo','MAURON')
insert into [user](firstname, lastname) values ( 'Guilain','MBAYO')
insert into [user](firstname, lastname) values ( 'Dmitri','MEILI')
insert into [user](firstname, lastname) values ( 'Samuel-Souka','MEYER')
insert into [user](firstname, lastname) values ( 'Benoit','MEYLAN')
insert into [user](firstname, lastname) values ( 'Rui-Manuel','MOTA-CARNEIRO')
insert into [user](firstname, lastname) values ( 'Imane','MOUTAOUAKEL')
insert into [user](firstname, lastname) values ( 'Dorian','NICLASS')
insert into [user](firstname, lastname) values ( 'Dylan','OLIVEIRA-RAMOS')
insert into [user](firstname, lastname) values ( 'Romain','ONRUBIA')
insert into [user](firstname, lastname) values ( 'Christopher','PARDO')
insert into [user](firstname, lastname) values ( 'Kevin','PASTEUR')
insert into [user](firstname, lastname) values ( 'Michael','PEDROLETTI')
insert into [user](firstname, lastname) values ( 'Yan','PETTER')
insert into [user](firstname, lastname) values ( 'Alexandre','PHILIBERT')
insert into [user](firstname, lastname) values ( 'Benoit','PIERREHUMBERT')
insert into [user](firstname, lastname) values ( 'Pedro','PINTO')
insert into [user](firstname, lastname) values ( 'Mathieu','RABOT')
insert into [user](firstname, lastname) values ( 'Nathan','RAYBURN')
insert into [user](firstname, lastname) values ( 'Almir','RAZIC')
insert into [user](firstname, lastname) values ( 'Paul','REEVE')
insert into [user](firstname, lastname) values ( 'Mathias','RENOULT')
insert into [user](firstname, lastname) values ( 'Caroline','REY')
insert into [user](firstname, lastname) values ( 'Louis','RICHARD')
insert into [user](firstname, lastname) values ( 'Brian','RODRIGUES-FRAGA')
insert into [user](firstname, lastname) values ( 'Samuel','ROLAND')
insert into [user](firstname, lastname) values ( 'Alessandro','ROSSI')
insert into [user](firstname, lastname) values ( 'David','ROSSY')
insert into [user](firstname, lastname) values ( 'David','ROULET')
insert into [user](firstname, lastname) values ( 'Roman','RUCHAT')
insert into [user](firstname, lastname) values ( 'Ilan','RUIZ-DE-PORRAS')
insert into [user](firstname, lastname) values ( 'Lavdim','SADIKAJ')
insert into [user](firstname, lastname) values ( 'Diego','SANCHEZ')
insert into [user](firstname, lastname) values ( 'Tiago','SANTOS')
insert into [user](firstname, lastname) values ( 'Leandro','SARAIVA-MAIA')
insert into [user](firstname, lastname) values ( 'Robin','SCHMUTZ')
insert into [user](firstname, lastname) values ( 'Miguel','SOARES')
insert into [user](firstname, lastname) values ( 'Stephane','SORDET')
insert into [user](firstname, lastname) values ( 'Flavio','SOVILLA')
insert into [user](firstname, lastname) values ( 'Kevin','TEIXEIRA')
insert into [user](firstname, lastname) values ( 'Yannick','TERCIER')
insert into [user](firstname, lastname) values ( 'Julien','TERRAPON')
insert into [user](firstname, lastname) values ( 'Olivier','TISSOT')
insert into [user](firstname, lastname) values ( 'Keanu','TROSSET')
insert into [user](firstname, lastname) values ( 'Ander','URIEL-GLARIA')
insert into [user](firstname, lastname) values ( 'Sacha','USAN')
insert into [user](firstname, lastname) values ( 'Johnny','VACA-JARAMILLO')
insert into [user](firstname, lastname) values ( 'Michael','VARA')
insert into [user](firstname, lastname) values ( 'David-Manuel','VAROSO-GOMES')
insert into [user](firstname, lastname) values ( 'Kevin','VAUCHER')
insert into [user](firstname, lastname) values ( 'Diogo','VIEIRA-FERREIRA')
insert into [user](firstname, lastname) values ( 'Johan','VOLAND')
insert into [user](firstname, lastname) values ( 'Gwenael','WEST')
insert into [user](firstname, lastname) values ( 'Altin','ZILI')
insert into [user](firstname, lastname) values ( 'Valentin','ZINGG')
insert into [user](firstname, lastname) values ( 'Leo','ZMOOS')

Use Diner_Restaurant_Eleves
GO

create procedure GenerateBookings
as
begin

	Declare @zeday datetime = GETDATE(),
			@nbdays integer,
			@nres integer,
			@table integer,
			@hour integer,
			@moment datetime,
			@nbres integer,
			@nbPers int,
			@madeByName varchar(35),
			@madeByFirstName varchar(35);

	Set @zeday = DATEADD(DAY,1,@zeday);
	Set @zeday = CAST(CAST(DATEPART(YEAR,@zeday) AS varchar) + '-' + CAST(DATEPART(MONTH,@zeday) AS varchar) + '-' + CAST(DATEPART(DAY,@zeday) AS varchar) AS DATETIME);


	Set @nbdays = 0;
	--we want data for the next 20 days
	While @nbdays < 20
	Begin
		Set @hour = 12;
		--we only want data for lunch (12h) and dinner (19h)
		while @hour < 20
		begin
			Set @nbres = 4 + Round(Rand()*10,0);
			Set @nres = 0;
	
			while @nres < @nbres
			Begin
				--il y a max 14 tables
				Set @table = @nres + 1;
				Set @moment = DATEADD(HOUR,@hour,@zeday);
				Begin Try
						Select Top 1 @madeByName = lastname, @madeByFirstName = firstname From [user] Order By NEWID();
						set @nbPers = (select capacity from [table] where idTable = @table);
						Insert Into booking (dateBooking, nbPers, lastname, firstname, fkTable) Values (@moment, @nbPers, @madeByName, @madeByFirstName, @table);
				End Try
				Begin catch
					Print ('Pas de bol');
				End Catch

				Set @nres=@nres+1;
			End
			set @hour=@hour+7;
		end

		Set @zeday = DATEADD(DAY,1,@zeday);
		Set @nbdays = @nbdays + 1;
	End

end
GO 

EXEC GenerateBookings
GO

-- TO ADD function, trigger and rights here 

-- 1 Fonction
USE Diner_Restaurant_Eleves
GO

DROP FUNCTION IF EXISTS NbDishesPerType
GO

CREATE FUNCTION NbDishesPerType(@typeName VARCHAR(255)) RETURNS INT AS
BEGIN
	DECLARE @result AS INT
	SET @result = (SELECT COUNT(*) FROM Dish
			JOIN DishType
			ON DishType.idDishType = Dish.fkDishType
			WHERE DishType.dishTypeName LIKE @typeName)
	IF(@result = 0)SET @result = -1
	RETURN @result
END
GO

select dbo.NbDishesPerType('Poissons')
select dbo.NbDishesPerType('Viandes')
select dbo.NbDishesPerType('Fast-Food')
GO

-- 2 Trigger
USE Diner_Restaurant_Eleves
GO

DROP TRIGGER IF EXISTS ManageBoocking
GO

CREATE TRIGGER ManageBoocking ON Booking INSTEAD OF INSERT, UPDATE AS
	DECLARE @dateBooking AS DATETIME
	DECLARE @nbPers AS TINYINT
	DECLARE @phonenumber AS VARCHAR(20) 
	DECLARE @lastname AS VARCHAR(35)
	DECLARE @firstname AS VARCHAR(35)
	DECLARE @fkTable AS INT

	DECLARE cInserted CURSOR FOR SELECT dateBooking, nbPers, phonenumber, lastname, firstname, fkTable FROM inserted
	OPEN cInserted
	FETCH cInserted INTO @dateBooking, @nbPers, @phonenumber, @lastname, @firstname, @fkTable
	WHILE (@@FETCH_STATUS=0) BEGIN
		-- count table free on @dateBooking
		IF((SELECT COUNT(*) FROM [Table] WHERE idTable NOT IN (SELECT fkTable FROM Booking WHERE dateBooking = @dateBooking)) = 0)
			RAISERROR('Aucune table de disponible',1,1);
		ELSE IF((SELECT capacity FROM [Table] WHERE idTable = @fkTable) < @nbPers)
			RAISERROR('La table est trop petite',1,1);
		ELSE IF((SELECT SUM(capacity) FROM [Table]) >= (SELECT SUM(nbPers) FROM Booking WHERE dateBooking = @dateBooking))
			RAISERROR('La salle n''as plus asez de place',1,1);
		ELSE INSERT INTO Booking(dateBooking, nbPers, phonenumber, lastname, firstname, fkTable) VALUES 
			(@dateBooking, @nbPers, @phonenumber, @lastname, @firstname, @fkTable)
		FETCH cInserted INTO @dateBooking, @nbPers, @phonenumber, @lastname, @firstname, @fkTable
	END
	CLOSE cInserted
	DEALLOCATE cInserted
GO

INSERT INTO Booking VALUES ('2021-02-11 19:00', 4, '079 123 45 67', 'Martin', 'Germaine', 10)
INSERT INTO Booking VALUES ('2021-02-03 19:00', 4, '079 123 45 67', 'Dupont', 'Henri', 2)
INSERT INTO Booking VALUES ('2021-02-15 19:00', 4, '079 123 45 67', 'Rochat', 'Gertrude', 3)
INSERT INTO Booking VALUES ('2021-02-01 19:00', 4, '079 123 45 67', 'Dupont', 'Henri', 2)
INSERT INTO Booking VALUES ('2021-02-12 19:00', 4, '079 123 45 67', 'Martin', 'Germaine', 3)

-- 3 Droits
USE Diner_Restaurant_Eleves
GO

DROP TRIGGER IF EXISTS ManageRole
GO
DROP ROLE IF EXISTS ApprentiGroup
DROP ROLE IF EXISTS FormateurGroup
GO

CREATE TRIGGER ManageRole ON WaiterGroup AFTER INSERT, UPDATE, DELETE AS
	DECLARE @goupName AS VARCHAR(255)
	Declare @sqlRequest nvarchar(1000)
	-- INSERT
	DECLARE cInserted CURSOR FOR SELECT [name] FROM inserted
	OPEN cInserted
	FETCH cInserted INTO @goupName
	WHILE (@@FETCH_STATUS=0) BEGIN
		SET @sqlRequest = 'CREATE ROLE ' + @goupName + 'Group'
		Exec sp_executesql @sqlRequest
		FETCH cInserted INTO @goupName
	END
	CLOSE cInserted
	DEALLOCATE cInserted
	-- DELETE
	DECLARE cDeleted CURSOR FOR SELECT [name] FROM deleted
	OPEN cDeleted
	FETCH cDeleted INTO @goupName
	WHILE (@@FETCH_STATUS=0) BEGIN
		SET @sqlRequest = 'DROP ROLE ' + @goupName + 'Group'
		Exec sp_executesql @sqlRequest
		FETCH cDeleted INTO @goupName
	END
	CLOSE cDeleted
	DEALLOCATE cDeleted
GO

INSERT INTO WaiterGroup VALUES ('Apprenti')
INSERT INTO WaiterGroup VALUES ('Formateur')
GO

DELETE FROM WaiterGroup WHERE [name] = 'Formateur'
GO