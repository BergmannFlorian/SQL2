USE Diner_Restaurant_FAO
go

drop function ListBookings
go

create function ListBookings() 
returns table
as
	return (select lastname, firstname, dateBooking, fkTable, nbPers 
		from booking 
		where dateBooking > GETDATE() )

select * from ListBookings()
	


