USE [Safety]
GO
/****** Object:  StoredProcedure [dbo].[pMakeMove]    Script Date: 10/31/2014 16:42:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[pMakeMove]
	@row int = 0,
	@col int = 0,
	@skip bit = 0
as
if @skip = 0
begin
	if (@row between 1 and 3) and (@col between 1 and 3)
	begin
		declare @sql varchar(255)
		set @sql = '
		if (select ['+cast(@col as varchar(1))+'] from TicTacToe where row='+cast(@row as varchar(1))+') is null
		begin
			update TicTacToe
			set ['+cast(@col as varchar(1))+']=1
			where row='+cast(@row as varchar(1))+'
		end
		else
		begin
			print ''there is already a piece there, turn forfeited''
		end
		'
		exec(@sql)
	end
	else
	begin
		print 'row or column not valid, must be between 1 and 3'
	end
end

declare @winner int = 0

exec @winner = pCheckWinner
if @winner = 1 begin return end

declare @pcCol int = 0

while @pcCol not in
(
	select 1 from TicTacToe where [1] is null
	union all
	select 2 from TicTacToe where [2] is null
	union all
	select 3 from TicTacToe where [3] is null
)
begin
	set @pcCol = ceiling(rand()*3)
end

set @sql = '
declare @pcRow int = 0

while @pcRow not in (select row from TicTacToe where ['+cast(@pcCol as varchar(1))+'] is null)
begin
	set @pcRow = ceiling(rand()*3)
end

update TicTacToe
set ['+cast(@pcCol as varchar(1))+']=0
where row=@pcRow
'

exec(@sql)

exec @winner = pCheckWinner
if @winner = 1 begin return end
