USE [Diner_restaurant_fbn]
GO

-- 4 Success
SELECT * FROM [Invoice]
GO
-- 6 Success
SELECT Count(*) FROM [DishType]
GO
-- 7 Success
SELECT Count(*) FROM [Dish]
GO
-- 8 Failed
insert into [Dish](dishDescription, AmountWithTaxes,fkDishType) values
('Plat de type Accompagnement',31,(SELECT idDishType from [DishType] WHERE [DishTypeName] = 'Accompagnement'));
GO
-- 9 Success
insert into [Dish](dishDescription, AmountWithTaxes,fkDishType) values
('Plat de type Viande',31,(SELECT idDishType from [DishType] WHERE [DishTypeName] = 'Viande'));
GO
-- 10 Failed
DELETE FROM [DishType]
WHERE [DishTypeName] = 'Viande';
GO
-- 11 Failed
insert into [waiter] (firstname, lastName) values 
('Eva', 'Risselle');
GO
-- 12 Failed
insert into [waiter] (firstname) values 
('Eva');
GO
-- 13 Failed
insert into [waiter] (lastName) values 
('Risselle');
GO
-- 14 Failed
insert into [Booking](fkTable) values
(20);
GO
-- 15 Failed
insert into [Booking](dateBooking, fkTable) values
('2019-01-01', 1);
GO
-- 16 Failed
insert into [Dish](dishDescription, AmountWithTaxes, fkDishType, fkMenu) values
('Plat de type Accompagnement',31,(SELECT idDishType from [DishType] WHERE [DishTypeName] = 'Viande'),15);
GO
-- 17 Failed
insert into [Planning](dateWork, fkWaiter) values
('2021-01-01', 10);
GO
-- 18 Failed
insert into [Planning](dateWork, fkWaiter) values
('2019-01-01', 1);
GO
-- 19 Failed
insert into [Invoice]([fkWaiter], [fkTable], [fkPaymentCond]) values
(10,20,10);
GO
-- 20 failed
insert into [InvoiceDetail]([fkInvoice], [fkTaxRate], [fkDish]) values
(100,20,35)
GO
-- 21 Failed
insert into [InvoiceDetail]([fkInvoice], [fkTaxRate]) values
(1,1)
GO
-- 22 Success
insert into [InvoiceDetail]([fkInvoice], [fkTaxRate], [fkDish]) values
(1, 7.7, 1)
GO
-- 23 Failed
insert into [Responsible]([fkPlanning], [fkTable]) values
(150, 50)
GO
-- 24 Failed
insert into [Booking](dateBooking) values
(DATEADD(month, +2, GETDATE()));
GO
-- 25 Failed
insert into [Waiter]([firstName], [lastName]) values
('Henri', 'Dupont')
insert into [Planning](dateWork, fkWaiter) values
(DATEADD(day, +1, GETDATE()), (SELECT idWaiter from [Waiter] WHERE firstName = 'Henri' AND lastName = 'Dupont'));
GO
-- 26 Success
DELETE FROM [Waiter]
WHERE firstName = 'Henri' AND lastName = 'Dupont'
GO