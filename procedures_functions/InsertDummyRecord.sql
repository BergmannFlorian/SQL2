use Diner_Restaurant_DVF
go
drop procedure if exists InsertDummyRecord 
go
create procedure InsertDummyRecord @table nvarchar(255), @number int = 1
as
begin
	Declare @sqlRequest nvarchar(1000)
	DECLARE @data nvarchar(1000)
	DECLARE @columns table (columnName nvarchar(255), columnType nvarchar(255))

	insert into  @columns(columnName, columnType) 
	select COLUMN_NAME, DATA_TYPE from information_schema.columns
			where table_name like @table and COLUMN_NAME not in 
				(SELECT name FROM sys.columns 
				WHERE OBJECT_NAME(object_id) like @table
				AND COLUMNPROPERTY(object_id, name, 'IsIdentity') = 1)

	DECLARE @values nvarchar(1000)
	select @values = STRING_AGG(columnName, ', ') from @columns

    DECLARE @columnName AS nvarchar(255)
    DECLARE @columnType AS nvarchar(255)
    DECLARE @value AS nvarchar(255)
    DECLARE @valueTable AS TABLE(columnName nvarchar(255), columnValue nvarchar(255))

	DECLARE cColumn SCROLL CURSOR FOR
        select columnName,columnType from @columns
    OPEN cColumn
    WHILE(@number > 0) BEGIN
        DELETE FROM @valueTable
        FETCH FIRST FROM cColumn INTO @columnName, @columnType
        WHILE (@@FETCH_STATUS=0) BEGIN
		print @columnType 
		print @columnName
            SET @value = CASE @columnType
                            WHEN 'int' THEN CONVERT(nVARCHAR(40), Floor(RAND()*99))
							when 'decimal' THEN ''''+CONVERT(nVARCHAR(40), CONVERT(Decimal(10,2), RAND()*99))+''''
                            WHEN 'datetime' THEN ''''+CONVERT(nVARCHAR(45), GETDATE(), 23)+''''
                            ELSE ''''+CONVERT(NVARCHAR(40), NEWID())+''''							
                        END
            INSERT INTO @valueTable(columnName, columnValue) VALUES (@columnName, @value)
			
			select @data = STRING_AGG(columnValue, ', ') from @valueTable
			print @data
            FETCH cColumn INTO @columnName, @columnType
        END
		
			  
		-- disable all checks :D
		set @sqlRequest = 'ALTER TABLE ' + @table + ' NOCHECK CONSTRAINT ALL;';
		print @sqlRequest
		Exec sp_executesql @sqlRequest

		set @sqlRequest = 'Insert into ' + @table + '(' + @values + ') values (' + @data+ ')';
		print @sqlRequest
		Exec sp_executesql @sqlRequest
        SET @number = @number-1
    END
    SELECT * FROM @valueTable
    CLOSE cColumn
    DEALLOCATE cColumn
end 
go

exec InsertDummyRecord 'invoice'
go