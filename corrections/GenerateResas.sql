Use Diner_Restaurant_FAO
GO

drop procedure GenerateBookings
go

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

exec GenerateBookings

delete from Booking


select * from booking