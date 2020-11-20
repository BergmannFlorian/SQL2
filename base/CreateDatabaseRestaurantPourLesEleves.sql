-- Diner_restaurant_FAO.sql:	This script creates a database for the management of booking and invoice of a restaurant
--				The database is initialized with fake data and data coming from the restaurant "Hotel de Ville" in Echallens
--				
-- Version:		1.0, novembre 2018
-- Author:		F. Andolfatto
--
-- History:
--			1.0 Database creation
--
--

USE master
GO
SET NOCOUNT ON

alter database [Diner_restaurant_fbn] set single_user with rollback immediate
DROP DATABASE IF EXISTS [Diner_restaurant_fbn]
GO

CREATE DATABASE [Diner_restaurant_fbn]
GO

USE [Diner_restaurant_fbn]
GO

CREATE TABLE Waiter (
  [idWaiter] INT NOT NULL IDENTITY,
  [firstName] VARCHAR(45) NULL,
  [lastName] VARCHAR(45) NULL,
  PRIMARY KEY ([idWaiter]))
;

CREATE TABLE Planning (
  [idPlanning] INT NOT NULL IDENTITY,
  [dataWork] DATETIME2(0) NULL,
  [fkWaiter] INT NOT NULL,
  PRIMARY KEY ([idPlanning]),
  CONSTRAINT [fk_Planning_Waiter1]
    FOREIGN KEY ([fkWaiter])
    REFERENCES Waiter ([idWaiter])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
;
CREATE INDEX [fk_Planning_Waiter1_idx] ON Planning ([fkWaiter] ASC);

CREATE TABLE [Table] (
  [idTable] INT NOT NULL IDENTITY,
  [capacity] SMALLINT NULL,
  PRIMARY KEY ([idTable]))
;

CREATE TABLE PaymentCondition (
  [idPaymentCondition] INT NOT NULL IDENTITY,
  [description] VARCHAR(100) NULL,
  [reduction] DECIMAL(10,2) NULL,
  PRIMARY KEY ([idPaymentCondition]))
;

CREATE TABLE Invoice (
  [idInvoice] INT NOT NULL IDENTITY,
  [InvoiceNumber] INT NULL,
  [totalAmountWithTaxes] DECIMAL(10,2) NULL,
  [totalAmountWithoutTaxes] DECIMAL(10,2) NULL,
  [InvoiceDate] DATE NULL,
  [fkPaymentCond] INT NOT NULL,
  [fkTable] INT NOT NULL,
  [fkWaiter] INT NOT NULL,
  PRIMARY KEY ([idInvoice])
  ,
  CONSTRAINT [fk_Invoice_PaymentCondition1]
    FOREIGN KEY ([fkPaymentCond])
    REFERENCES PaymentCondition ([idPaymentCondition])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT [fk_Invoice_Table1]
    FOREIGN KEY ([fkTable])
    REFERENCES [Table] ([idTable])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT [fk_Invoice_Waiter1]
    FOREIGN KEY ([fkWaiter])
    REFERENCES Waiter ([idWaiter])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
;

CREATE INDEX [fk_Invoice_PaymentCondition1_idx] ON Invoice ([fkPaymentCond] ASC);
CREATE INDEX [fk_Invoice_Table1_idx] ON Invoice ([fkTable] ASC);
CREATE INDEX [fk_Invoice_Waiter1_idx] ON Invoice ([fkWaiter] ASC);

CREATE TABLE TaxRate (
  [taxRateValue] INT NOT NULL IDENTITY,
  [description] VARCHAR(100) NULL,
  PRIMARY KEY ([taxRateValue]))
;

CREATE TABLE [DishType] (
  [idDischType] DECIMAL(4,2) NOT NULL,
  [DishTypeName] VARCHAR(100) NULL,
  PRIMARY KEY ([idDischType]))
;

CREATE TABLE Menu (
  [idMenu] INT NOT NULL IDENTITY,
  [menuName] VARCHAR(50) NULL,
  [ amountWithTaxes] DECIMAL(10,2) NULL,
  PRIMARY KEY ([idMenu]))
;

CREATE TABLE Dish (
  [idDish] INT NOT NULL IDENTITY,
  [dishDescription] VARCHAR(100) NULL,
  [fkDishType] DECIMAL(4,2) NOT NULL,
  [fkMenu] INT NOT NULL,
  [AmountWithTaxes] DECIMAL(5,2) NULL,
  PRIMARY KEY ([idDish]),
  CONSTRAINT [fk_Dish_DischType1]
    FOREIGN KEY ([fkDishType])
    REFERENCES DishType ([idDischType])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT [fk_Dish_Menu1]
    FOREIGN KEY ([fkMenu])
    REFERENCES Menu ([idMenu])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
;

CREATE INDEX [fk_Dish_DischType1_idx] ON Dish ([fkDishType] ASC);
CREATE INDEX [fk_Dish_Menu1_idx] ON Dish ([fkMenu] ASC);

CREATE TABLE InvoiceDetail (
  [idInvoiceDetail] INT NOT NULL IDENTITY,
  [quantity] INT NULL,
  [amountWithTaxes] DECIMAL(10,2) NULL,
  [fkTaxRate] INT NOT NULL,
  [fkInvoice] INT NOT NULL,
  [fkDish] INT NOT NULL,
  [fkMenu] INT NOT NULL,
  PRIMARY KEY ([idInvoiceDetail]),
  CONSTRAINT [fk_InvoiceDetail_TaxRate1]
    FOREIGN KEY ([fkTaxRate])
    REFERENCES TaxRate ([taxRateValue])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT [fk_InvoiceDetail_Invoice1]
    FOREIGN KEY ([fkInvoice])
    REFERENCES Invoice ([idInvoice])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT [fk_InvoiceDetail_Dish1]
    FOREIGN KEY ([fkDish])
    REFERENCES Dish ([idDish])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT [fk_InvoiceDetail_Menu1]
    FOREIGN KEY ([fkMenu])
    REFERENCES Menu ([idMenu])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
;

CREATE INDEX [fk_InvoiceDetail_TaxRate1_idx] ON InvoiceDetail ([fkTaxRate] ASC);
CREATE INDEX [fk_InvoiceDetail_Invoice1_idx] ON InvoiceDetail ([fkInvoice] ASC);
CREATE INDEX [fk_InvoiceDetail_Dish1_idx] ON InvoiceDetail ([fkDish] ASC);
CREATE INDEX [fk_InvoiceDetail_Menu1_idx] ON InvoiceDetail ([fkMenu] ASC);

CREATE TABLE Booking (
  [idBooking] INT NOT NULL IDENTITY,
  [dateBooking] DATETIME2(0) NULL,
  [nbPers] SMALLINT NULL,
  [phonenumber] VARCHAR(20) NULL,
  [lastname] VARCHAR(35) NULL,
  [firstname] VARCHAR(35) NULL,
  [fkTable] INT NOT NULL,
  PRIMARY KEY ([idBooking])
  ,
  CONSTRAINT [fk_Booking_Table1]
    FOREIGN KEY ([fkTable])
    REFERENCES [Table] ([idTable])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
;

CREATE INDEX [fk_Booking_Table1_idx] ON Booking ([fkTable] ASC);

CREATE TABLE Responsible (
  [fkPlanning] INT NOT NULL,
  [fkTablle] INT NOT NULL,
  PRIMARY KEY ([fkPlanning], [fkTablle])
  ,
  CONSTRAINT [fk_Planning_has_Table_Planning]
    FOREIGN KEY ([fkPlanning])
    REFERENCES Planning ([idPlanning])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT [fk_Planning_has_Table_Table1]
    FOREIGN KEY ([fkTablle])
    REFERENCES [Table] ([idTable])
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
;

CREATE INDEX [fk_Planning_has_Table_Table1_idx] ON Responsible ([fkTablle] ASC);
CREATE INDEX [fk_Planning_has_Table_Planning_idx] ON Responsible ([fkPlanning] ASC);

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

insert into [TaxRate](taxRateValue, description) values 
(7.7, 'Taxe suisse standard'),
(2.5, 'Taxe réduit'),
(3.7, 'Taxe spécial hébergement');

insert into [DishType](DishTypeName) values
('Entrées'),
('Poissons'),
('Viande'),
('Fromages'),
('Dessert');

insert into [Dish](dishDescription, AmountWithTaxes, fkDishType) values
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