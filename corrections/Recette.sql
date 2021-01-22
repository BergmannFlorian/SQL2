/* 
This function enables to get the revenue during a certain time 
Author : F. Andolfatto
Version : 1.0
*/

USE Diner_Restaurant_FAO
go

drop function Recette
go

CREATE FUNCTION Recette (@duration int)
returns decimal
as
begin

	declare @somme decimal(20,2);

	if @duration < 0 or @duration > 365
		set @somme = -1;
	else
		select @somme = sum(totalAmountWithTaxes) from Invoice where DATEADD(DAY,@duration,invoiceDate) > GETDATE();
		
	return @somme;
end

select Recette = dbo.Recette(366)
select Recette = dbo.Recette(-1)
select Recette = dbo.Recette(1)
select Recette = dbo.Recette(7)
select Recette = dbo.Recette(30)

select * from Invoice
insert into invoice (invoiceNumber, totalAmountWithTaxes, totalAmountWithoutTaxes, invoiceDate, fkWaiter, fkTable) 
values ('789456', 205.00, 200.00, '2018-12-11', 1, 3)
insert into invoice (invoiceNumber, totalAmountWithTaxes, totalAmountWithoutTaxes, invoiceDate, fkWaiter, fkTable) 
values ('789789', 420.00, 400.00, '2018-12-10', 1, 3)

select * from Invoice where DATEADD(DAY,60,invoiceDate) > GETDATE()