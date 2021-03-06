-- Function occupation : occupation percentage of the restaurant according to its bookings
-- Author: F. Andolfatto
-- Date: December 2018


USE Diner_Restaurant_FAO
go

drop function occupation
go

create function Occupation (@from DATETIME, @to DATETIME) 
returns int
as
	begin
	Declare @nbres int,
			@nbtables int,
			@nbhours float,
			@nbdishes int;

	-- Beware of bad hours
	If @to <= @from
		Return -2; -- Error code for bad dates

	if Datediff(DAY,@from,@to) = 0 and DatePart(HOUR,@from) > 12 and DatePart(HOUR,@to) < 19
		return -2;  -- Error code for bad dates : interval too short

	if Datediff(DAY,@from,@to) = 0 and DatePart(HOUR,@to) < 12
		return -2;  -- Error code for bad dates : interval too short

	--number of booking between the two dates
	Select @nbres = count(*) from booking Where dateBooking >= @from And dateBooking <= @to;

	--how many tables per dish ?
	Select @nbtables = count(*) from [table];
	--Select @nbres = count(*) from booking Where And datediff(hour,@from, dateBooking) >= 0 And datediff(hour, dateBooking, @to) >= 0;
	
	--how many dishes between the two dates ?
	set @nbdishes = 0;

	--same day
	if Datediff(DAY,@from,@to) = 0
	begin
		if DatePart(HOUR,@from) <= 12 and DatePart(HOUR,@to) >= 19
			set @nbdishes = 2
		else if DatePart(HOUR,@from) > 12 and DatePart(HOUR,@to) >= 19
			set @nbdishes = 1
		else if DatePart(HOUR,@from) <= 12 and DatePart(HOUR,@to) < 19
			set @nbdishes = 1
	end
	else 
	begin
		if DatePart(HOUR,@from) > 12 and DatePart(HOUR,@from) < 20
			set @nbdishes = 1;
		else if DatePart(HOUR,@from) <= 12 
			set @nbdishes = 2;
		if DatePart(HOUR,@to) >= 19
			set @nbdishes = @nbdishes + 2;
		else if DatePart(HOUR,@to) < 19 and DatePart(HOUR,@to) >= 12
			set @nbdishes = @nbdishes + 1;		 

		Set @nbdishes = (Datediff(DAY,@from,@to)-1) * 2 + @nbdishes;
	end

	--percentage calcul
	return Round(@nbres*100/(@nbdishes*@nbtables),0);

end

select dbo.Occupation('2018-12-04 08:00', '2018-12-10 08:00')
select dbo.Occupation('2018-12-04 08:00', '2018-12-07 12:00')
select dbo.Occupation('2018-12-04 08:00', '2018-12-04 11:00')
select dbo.Occupation('2018-12-04 12:00', '2018-12-04 17:00')
select dbo.Occupation('2018-12-04 13:00', '2018-12-04 19:00')
select dbo.Occupation('2018-12-04 11:00', '2018-12-04 21:00')
select dbo.Occupation('2018-12-04 13:00', '2018-12-15 13:00')
select dbo.Occupation('2018-12-04 13:00', '2018-12-15 10:00')
select dbo.Occupation('2018-12-04 13:00', '2018-12-15 21:00')
select dbo.Occupation('2018-11-23 08:00', '2018-12-21 08:00')
select dbo.Occupation('2018-12-19 08:00', '2018-12-11 08:00')
select dbo.Occupation('2018-12-11', '2018-12-18')
