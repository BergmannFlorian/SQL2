-- Diner_restaurant_kpr.sql:	This script creates a database for the management of booking and invoice of a restaurant
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

alter database Diner_restaurant_fbn set single_user with rollback immediate;
DROP DATABASE IF EXISTS Diner_restaurant_fbn;

CREATE DATABASE Diner_restaurant_fbn;

USE [Diner_restaurant_fbn]
GO

GO
CREATE TABLE [dbo].[Booking](
	[idBooking] [int] IDENTITY(1,1) NOT NULL,
	[dateBooking] [datetime] NULL,
	[nbPers] [tinyint] NULL,
	[phonenumber] [varchar](20) NULL,
	[lastname] [varchar](35) NULL,
	[firstname] [varchar](35) NULL,
	[fkTable] [int] NULL,
 CONSTRAINT [PK_Booking] PRIMARY KEY CLUSTERED ([idBooking] ASC)
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Dish](
	[idDish] [int] IDENTITY(1,1) NOT NULL,
	[dishDescription] [varchar](100) NULL,
	[fkDishType] [int] NULL,
	[fkMenu] [int] NULL,
	[AmountWithTaxes] [decimal](5, 2) NULL,
 CONSTRAINT [PK_Dish] PRIMARY KEY CLUSTERED ([idDish] ASC)
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[DishType](
	[idDishType] [int] IDENTITY(1,1) NOT NULL,
	[DishTypeName] [varchar](100) NULL,
 CONSTRAINT [PK_DishType] PRIMARY KEY CLUSTERED ([idDishType] ASC)
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Invoice](
	[idInvoice] [int] IDENTITY(1,1) NOT NULL,
	[invoiceNumber] [varchar](45) NULL,
	[totalAmountWithTaxes] [decimal](10, 2) NULL,
	[totalAmountWithoutTaxes] [decimal](10, 2) NULL,
	[invoiceDate] [datetime] NULL,
	[fkWaiter] [int] NULL,
	[fkTable] [int] NULL,
	[fkPaymentCond] [int] NULL,
 CONSTRAINT [PK_Invoice] PRIMARY KEY CLUSTERED ([idInvoice] ASC)
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[InvoiceDetail](
	[idInvoiceDetail] [int] IDENTITY(1,1) NOT NULL,
	[quantity] [int] NULL,
	[amountWithoutTaxes] [decimal](10, 2) NULL,
	[fkInvoice] [int] NULL,
	[fkTaxRate] [decimal](4, 2) NULL,
	[fkMenu] [int] NULL,
	[fkDish] [int] NULL,
 CONSTRAINT [PK_InvoiceDetail] PRIMARY KEY CLUSTERED ([idInvoiceDetail] ASC)
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Menu](
	[idMenu] [int] IDENTITY(1,1) NOT NULL,
	[menuName] [varchar](50) NULL,
	[amountWithTaxes] [decimal](5, 2) NULL,
 CONSTRAINT [PK_Menu] PRIMARY KEY CLUSTERED ([idMenu] ASC)
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[PaymentCondition](
	[idPaymentCond] [int] IDENTITY(1,1) NOT NULL,
	[description] [varchar](100) NULL,
	[reduction] [decimal](4, 2) NULL,
 CONSTRAINT [PK_PaymentCondition] PRIMARY KEY CLUSTERED ([idPaymentCond] ASC)
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Planning](
	[idPlanning] [int] IDENTITY(1,1) NOT NULL,
	[dateWork] [datetime] NULL,
	[fkWaiter] [int] NULL,
 CONSTRAINT [PK_Planning] PRIMARY KEY CLUSTERED ([idPlanning] ASC)
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Responsible](
	[fkPlanning] [int] NOT NULL,
	[fkTable] [int] NOT NULL,
 CONSTRAINT [PK_Responsible] PRIMARY KEY CLUSTERED ([fkPlanning] ASC,[fkTable] ASC)
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Table](
	[idTable] [int] IDENTITY(1,1) NOT NULL,
	[capacity] [tinyint] NULL,
 CONSTRAINT [PK_Table] PRIMARY KEY CLUSTERED 
(
	[idTable] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TaxRate]    Script Date: 20.11.2020 11:48:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TaxRate](
	[taxRateValue] [decimal](4, 2) NOT NULL,
	[description] [varchar](100) NULL,
 CONSTRAINT [PK_TaxRate] PRIMARY KEY CLUSTERED ([taxRateValue] ASC)
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Waiter](
	[idWaiter] [int] IDENTITY(1,1) NOT NULL,
	[firstName] [varchar](35) NULL,
	[lastName] [varchar](35) NULL,
 CONSTRAINT [PK_Waiter] PRIMARY KEY CLUSTERED ([idWaiter] ASC)
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Booking]  WITH CHECK ADD  CONSTRAINT [FK_Booking_Table] FOREIGN KEY([fkTable])
REFERENCES [dbo].[Table] ([idTable])
GO
ALTER TABLE [dbo].[Booking] CHECK CONSTRAINT [FK_Booking_Table]
GO
ALTER TABLE [dbo].[Dish]  WITH CHECK ADD  CONSTRAINT [FK_Dish_DishType] FOREIGN KEY([fkDishType])
REFERENCES [dbo].[DishType] ([idDishType])
GO
ALTER TABLE [dbo].[Dish] CHECK CONSTRAINT [FK_Dish_DishType]
GO
ALTER TABLE [dbo].[Dish]  WITH CHECK ADD  CONSTRAINT [FK_Dish_Menu] FOREIGN KEY([fkMenu])
REFERENCES [dbo].[Menu] ([idMenu])
GO
ALTER TABLE [dbo].[Dish] CHECK CONSTRAINT [FK_Dish_Menu]
GO
ALTER TABLE [dbo].[Invoice]  WITH CHECK ADD  CONSTRAINT [FK_Invoice_PaymentCondition] FOREIGN KEY([fkPaymentCond])
REFERENCES [dbo].[PaymentCondition] ([idPaymentCond])
GO
ALTER TABLE [dbo].[Invoice] CHECK CONSTRAINT [FK_Invoice_PaymentCondition]
GO
ALTER TABLE [dbo].[Invoice]  WITH CHECK ADD  CONSTRAINT [FK_Invoice_Table] FOREIGN KEY([fkTable])
REFERENCES [dbo].[Table] ([idTable])
GO
ALTER TABLE [dbo].[Invoice] CHECK CONSTRAINT [FK_Invoice_Table]
GO
ALTER TABLE [dbo].[Invoice]  WITH CHECK ADD  CONSTRAINT [FK_Invoice_Waiter] FOREIGN KEY([fkWaiter])
REFERENCES [dbo].[Waiter] ([idWaiter])
GO
ALTER TABLE [dbo].[Invoice] CHECK CONSTRAINT [FK_Invoice_Waiter]
GO
ALTER TABLE [dbo].[InvoiceDetail]  WITH CHECK ADD  CONSTRAINT [FK_InvoiceDetail_Dish] FOREIGN KEY([fkDish])
REFERENCES [dbo].[Dish] ([idDish])
GO
ALTER TABLE [dbo].[InvoiceDetail] CHECK CONSTRAINT [FK_InvoiceDetail_Dish]
GO
ALTER TABLE [dbo].[InvoiceDetail]  WITH CHECK ADD  CONSTRAINT [FK_InvoiceDetail_Invoice] FOREIGN KEY([fkInvoice])
REFERENCES [dbo].[Invoice] ([idInvoice])
GO
ALTER TABLE [dbo].[InvoiceDetail] CHECK CONSTRAINT [FK_InvoiceDetail_Invoice]
GO
ALTER TABLE [dbo].[InvoiceDetail]  WITH CHECK ADD  CONSTRAINT [FK_InvoiceDetail_Menu] FOREIGN KEY([fkMenu])
REFERENCES [dbo].[Menu] ([idMenu])
GO
ALTER TABLE [dbo].[InvoiceDetail] CHECK CONSTRAINT [FK_InvoiceDetail_Menu]
GO
ALTER TABLE [dbo].[InvoiceDetail]  WITH CHECK ADD  CONSTRAINT [FK_InvoiceDetail_TaxRate] FOREIGN KEY([fkTaxRate])
REFERENCES [dbo].[TaxRate] ([taxRateValue])
GO
ALTER TABLE [dbo].[InvoiceDetail] CHECK CONSTRAINT [FK_InvoiceDetail_TaxRate]
GO
ALTER TABLE [dbo].[Responsible]  WITH NOCHECK ADD  CONSTRAINT [FK_Responsible_Planning] FOREIGN KEY([fkPlanning])
REFERENCES [dbo].[Planning] ([idPlanning])
NOT FOR REPLICATION 
GO
ALTER TABLE [dbo].[Responsible] CHECK CONSTRAINT [FK_Responsible_Planning]
GO
ALTER TABLE [dbo].[Responsible]  WITH CHECK ADD  CONSTRAINT [FK_Responsible_Table] FOREIGN KEY([fkTable])
REFERENCES [dbo].[Table] ([idTable])
GO
ALTER TABLE [dbo].[Responsible] CHECK CONSTRAINT [FK_Responsible_Table]
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