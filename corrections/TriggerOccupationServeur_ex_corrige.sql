-- TriggerOccupationServeur.sql:	This script checks if a waiter can be added as a responsible for a table 
-- if he is not already responsible for 7 other tables
-- Version:		1.0, dec. 2018
-- Author:		F. Andolfatto
--

USE Diner_Restaurant_FAO
go

drop view planificationLendemain
go

create view planificationLendemain as
select firstname, lastname, datework, fkTable, capacity  
from waiter w, planning p, responsible r, [table] t
where w.idWaiter = p.fkWaiter and p.idPlanning = r.fkPlanning and r.fkTable = t.idTable
and CONVERT(DATE,dateWork) =DATEADD(DAY,1,CONVERT(DATE, GETDATE()))
go 

select * from planificationLendemain


drop trigger checkResponsible
go

create trigger checkResponsible
on planificationLendemain
instead of insert, update, delete
as
begin
	declare @dateWork as datetime,
			@fkwaiter as int, 
			@firstname as varchar(50), 
			@lastname as varchar(50),
			@nbtable as int,
			@wid as int,
			@pid as int, 
			@idtable as int,
			@nb as int;

	--Handle inserts
	declare c_insertplanif cursor for
			select firstname, lastname, datework, count(fktable) as nbTable from inserted group by lastname, firstname, datework;
	open c_insertplanif;
	fetch c_insertplanif into @firstname, @lastname, @datework, @nbtable;
	while (@@FETCH_STATUS = 0)
	begin
		select @nb = count(*) from waiter w, planning p, responsible r
			where w.idWaiter = p.fkWaiter and p.idPlanning = r.fkPlanning
			and dateWork =@dateWork and firstName = @firstname and lastName = @lastname
		--a waiter cannot take care of more than 8 tables
		if (@nbtable + @nb) > 7
		begin
			RAISERROR ('Trop de tables',1,1);
		end
		else	
		begin
				--we check the data we get. Do they concern an existing waiter?
				Select @wid=idWaiter From waiter Where firstname = @firstname and lastname = @lastname;
				if @wid is not null
				begin
					--find planning
					Select @pid=idplanning From Planning Where CONVERT(DATE,dateWork) =DATEADD(DAY,1,CONVERT(DATE, GETDATE())) and fkwaiter = @wid;
					if @pid is not null
					begin
						declare c_inserttables cursor for
							select fktable from inserted where firstname = @firstname and lastName = @lastname;
						open c_inserttables;
						fetch c_inserttables into @idtable;
						while (@@FETCH_STATUS = 0)
						begin
							Insert Into Responsible(fkPlanning, fkTable) Values
												(@pid,@idtable) 
							fetch c_inserttables into @idtable;
						end
						close c_inserttables; 
						deallocate c_inserttables;
					end
					else
						RAISERROR('planning inexistant',1,1);
				end	
				else 
					RAISERROR('Données incorrectes',1,1);
		end
		
		fetch c_insertplanif into @firstname, @lastname, @datework, @nbtable;
	end
	close c_insertplanif; 
	deallocate c_insertplanif;

	-- Handle deletes				
	declare c_deleteplanif cursor for
			select firstname, lastname, datework, fktable from deleted;
	open c_deleteplanif;
	fetch c_deleteplanif into @firstname, @lastname, @datework, @idtable;
	while (@@FETCH_STATUS = 0)
	begin
		--Does the waiter exist?
		Select @wid=idWaiter From waiter Where firstname = @firstname and lastname = @lastname;
		if @wid is not null
		begin
			select @pid=idplanning From Planning Where CONVERT(DATE,dateWork) =DATEADD(DAY,1,CONVERT(DATE, GETDATE())) and fkwaiter = @wid;
			--Is there a planning?
			if @pid is not null
				delete from Responsible where fkPlanning = @pid and fkTable = @idtable;
			else
				RAISERROR('planning inexistant',1,1);
		end	
		else 
			RAISERROR('Données incorrectes',1,1);
		
		
		fetch c_deleteplanif into @firstname, @lastname, @datework, @idtable;
	end
	close c_deleteplanif; 
	deallocate c_deleteplanif;


end


insert into planificationLendemain(firstname, lastname, fktable, datework) values ('Prenom', 'nom', 8, '2018.12.07')
insert into planificationLendemain(firstname, lastname, fktable, datework) values ('Marylou', 'Koume', 6, '2018.12.07')


insert into planificationLendemain(firstname, lastname, fktable, datework) values ('Eva', 'Risselle', 8, '2018.12.07')
insert into planificationLendemain(firstname, lastname, fktable, datework) values ('Eva', 'Risselle', 9, '2018.12.07')
insert into planificationLendemain(firstname, lastname, fktable, datework) values ('Eva', 'Risselle', 10, '2018.12.07')
insert into planificationLendemain(firstname, lastname, fktable, datework) values ('Eva', 'Risselle', 11, '2018.12.07')
insert into planificationLendemain(firstname, lastname, fktable, datework) values ('Eva', 'Risselle', 12, '2018.12.07')
insert into planificationLendemain(firstname, lastname, fktable, datework) values ('Marylou', 'Koume', 13, '2018.12.07')
insert into planificationLendemain(firstname, lastname, fktable, datework) values ('Marylou', 'Koume', 14, '2018.12.07')

insert into planificationLendemain(firstname, lastname, fktable, datework) values ('Prenom', 'Nom', 14, '2018.12.07')
delete from planificationLendemain where firstname = 'Prenom' and lastName = 'Nom' and fktable = 14 and datework = '2018.12.07'
delete from planificationLendemain where firstname = 'Marylou' and lastName = 'Koume' and fktable = 14 and datework = '2018.12.07'
delete from planificationLendemain where firstname = 'Marylou' and lastName = 'Koume' and fktable = 13 and datework = '2018.12.07'
delete from planificationLendemain where firstname = 'Marylou' and lastName = 'Koume' and datework = '2018.12.07'
update planificationLendemain set firstname = 'Marylou', lastName = 'Koume', datework = '2018.12.07' where firstname = 'Eva' and lastName = 'Risselle' and fkTable = 11

select * from responsible