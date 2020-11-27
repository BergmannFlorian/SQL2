-- Diner_restaurant_fbn.sql:	This script creates a database for the management of booking and invoice of a restaurant
--				The database is initialized with fake data and data coming from the restaurant "Hotel de Ville" in Echallens
--				
-- Version:		1.0, novembre 2018
-- Author:		Florian Bergmann
--
-- History:
--			1.0 Database creation
--
--

USE master
GO

IF EXISTS(select * from sys.databases where name='Diner_restaurant_fbn')
alter database [Diner_restaurant_fbn] set single_user with rollback immediate;
DROP DATABASE IF EXISTS [Diner_restaurant_fbn];
GO

CREATE DATABASE [Diner_restaurant_fbn]
GO

USE [Diner_restaurant_fbn]
GO

CREATE TABLE [dbo].[Table](
	[idTable] [int] IDENTITY(1,1) NOT NULL,
	[capacity] [tinyint] NULL,
 CONSTRAINT [PK_Table] PRIMARY KEY CLUSTERED ([idTable] ASC)
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Booking](
	[idBooking] [int] IDENTITY(1,1) NOT NULL,
	[dateBooking] [datetime] NULL,
	[nbPers] [tinyint] NULL,
	[phonenumber] [varchar](20) NULL,
	[lastname] [varchar](35) NULL,
	[firstname] [varchar](35) NULL,
	[fkTable] [int] NULL FOREIGN KEY REFERENCES [Table]([idTable]),
 CONSTRAINT [PK_Booking] PRIMARY KEY CLUSTERED ([idBooking] ASC),
 CONSTRAINT chk_booking_date CHECK([dateBooking] >= GETDATE() AND [dateBooking] != (DATEADD(month, +2, GETDATE()))),
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[DishType](
	[idDishType] [int] IDENTITY(1,1) NOT NULL,
	[DishTypeName] [varchar](100) NULL,
 CONSTRAINT [PK_DishType] PRIMARY KEY CLUSTERED ([idDishType] ASC)
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Menu](
	[idMenu] [int] IDENTITY(1,1) NOT NULL,
	[menuName] [varchar](50) NULL,
	[amountWithTaxes] [decimal](5, 2) NULL,
 CONSTRAINT [PK_Menu] PRIMARY KEY CLUSTERED ([idMenu] ASC)
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Dish](
	[idDish] [int] IDENTITY(1,1) NOT NULL,
	[dishDescription] [varchar](100) NULL,
	[fkDishType] [int] NOT NULL FOREIGN KEY REFERENCES [DishType](idDishType),
	[fkMenu] [int] NULL FOREIGN KEY REFERENCES [Menu]([idMenu]),
	[AmountWithTaxes] [decimal](5, 2) NULL,
 CONSTRAINT [PK_Dish] PRIMARY KEY CLUSTERED ([idDish] ASC)
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[PaymentCondition](
	[idPaymentCond] [int] IDENTITY(1,1) NOT NULL,
	[description] [varchar](100) NULL,
	[reduction] [decimal](4, 2) NULL,
 CONSTRAINT [PK_PaymentCondition] PRIMARY KEY CLUSTERED ([idPaymentCond] ASC)
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Waiter](
	[idWaiter] [int] IDENTITY(1,1) NOT NULL,
	[firstName] [varchar](35) NOT NULL,
	[lastName] [varchar](35) NOT NULL,
 CONSTRAINT [PK_Waiter] PRIMARY KEY CLUSTERED ([idWaiter] ASC),
 UNIQUE (firstName, lastName),
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Planning](
	[idPlanning] [int] IDENTITY(1,1) NOT NULL,
	[dateWork] [datetime] NULL,
	[fkWaiter] [int] NULL FOREIGN KEY REFERENCES [Waiter](idWaiter) ON DELETE CASCADE,
 CONSTRAINT [PK_Planning] PRIMARY KEY CLUSTERED ([idPlanning] ASC),
 CONSTRAINT chk_planing_date CHECK([dateWork] >= GETDATE())
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Responsible](
	[fkPlanning] [int] NOT NULL,
	[fkTable] [int] NOT NULL,
 CONSTRAINT [PK_Responsible] PRIMARY KEY CLUSTERED ([fkPlanning] ASC,[fkTable] ASC)
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[TaxRate](
	[taxRateValue] [decimal](4, 2) NOT NULL,
	[description] [varchar](100) NULL,
 CONSTRAINT [PK_TaxRate] PRIMARY KEY CLUSTERED ([taxRateValue] ASC)
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Invoice](
	[idInvoice] [int] IDENTITY(1,1) NOT NULL,
	[invoiceNumber] [varchar](45) NULL,
	[totalAmountWithTaxes] [decimal](10, 2) NULL,
	[totalAmountWithoutTaxes] [decimal](10, 2) NULL,
	[invoiceDate] [datetime] NULL,
	[fkWaiter] [int] NULL FOREIGN KEY REFERENCES [Waiter](idWaiter),
	[fkTable] [int] NULL FOREIGN KEY REFERENCES [Table]([idTable]),
	[fkPaymentCond] [int] NULL FOREIGN KEY REFERENCES [PaymentCondition]([idPaymentCond]),
 CONSTRAINT [PK_Invoice] PRIMARY KEY CLUSTERED ([idInvoice] ASC)
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[InvoiceDetail](
	[idInvoiceDetail] [int] IDENTITY(1,1) NOT NULL,
	[quantity] [int] NULL,
	[amountWithoutTaxes] [decimal](10, 2) NOT NULL,
	[fkInvoice] [int] NOT NULL FOREIGN KEY REFERENCES [Invoice]([idInvoice]),
	[fkTaxRate] [decimal](4, 2) NOT NULL FOREIGN KEY REFERENCES [dbo].[TaxRate]([taxRateValue]),
	[fkMenu] [int] NULL,
	[fkDish] [int] NULL FOREIGN KEY REFERENCES [dbo].[Dish]([idDish]),
 CONSTRAINT [PK_InvoiceDetail] PRIMARY KEY CLUSTERED ([idInvoiceDetail] ASC),
 CHECK ([fkMenu] IS NOT NULL OR [fkDish] IS NOT NULL)
) ON [PRIMARY]
GO

--data
insert into [waiter] (firstname, lastName) values 
('Eva', 'Risselle'),
('Marylou', 'Koume'),
('Magali', 'Maçon'),
('Harry', 'Cover'),
('Tom', 'Hatte'),
('Sam', 'Chatouille');

insert into [PaymentCondition] (description, reduction) values 
('Passeport gourmand pour 2 personnes', 0.5),
('Passeport gourmand pour 3 personnes', 0.33),
('Passeport gourmand pour 4 personnes', 0.25),
('CPNV', 0.1),
('La Poste', 0.05),
('Philip Morris', 0.1);

insert into [Table](capacity) values 
(2),
(4),
(6),
(2),
(2),
(4),
(4),
(6),
(2),
(2),
(4),
(4),
(2),
(6);

insert into [TaxRate] values 
(7.7, 'Taxe suisse standard'),
(2.5, 'Taxe réduit'),
(3.7, 'Taxe spécial hébergement');

insert into [DishType](DishTypeName) values
('Entrées'),
('Poissons'),
('Viande'),
('Fromages'),
('Dessert');

insert into [Dish](dishDescription, AmountWithTaxes,fkDishType) values
('Risotto tessinois bio aux truffes de Bourgogne et mascarpone',31,1),
('Gravlax de chevreuil aux citrons confits et câprons',30,1),
('Terrine de foie gras aux figues et pain d’épices',29,1),
('Tataki de thon aux pistaches de Bronte',45,2),
('Scalopines de saumon du Tessin, beurre blanc',46,2),
('Noix Saint-Jacques et gambas en brochette de romarin',49,2),
('Médaillons de renne poivrade',54,3),
('Suprême de canard sauvage à l’orange',48,3),
('Ris de veau façon saltimbocca à la sauge',45,3),
('Tournedos de boeuf, vierge automnale aux marrons et pignons',50,3),
('Selle de chevreuil à la raisineé (dès 2 pers.)',52,3),
('Assiette de fromages',21,4),
('Chaud-froid au chocolat noir, sorbet aux poires',19,5),
('Opéra au café et chocolat',20,5),
('Symphonie de crèmes brûlées aux saveurs différentes',19,5),
('Bavarois de poires en verrine, émiettée de spéculoos',19,5);

insert into [Invoice]([invoiceNumber]) values
(1),(2),(3),(4),(5);
