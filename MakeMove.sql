SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[pMakeMove]
	@row int = 0,
	@col int = 0,
	@skip bit = 0
as
-- only set piece if player did not skip
if @skip = 0
begin
	-- if row and column are valid
	if (@row between 1 and 3) and (@col between 1 and 3)
	begin
		-- update if space is null, otherwise, player forfeits move
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

-- check if player woon after move
exec @winner = pCheckWinner
if @winner = 1 begin return end

declare @pcCol int = 0

-- true for rows where column has empty spaces
while @pcCol not in
(
	select 1 from TicTacToe where [1] is null
	union all
	select 2 from TicTacToe where [2] is null
	union all
	select 3 from TicTacToe where [3] is null
)
begin
	-- set pc position column between 1 and 3
	set @pcCol = ceiling(rand()*3)
end

-- set pc row between 1 and 3 checking column for empty space
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

-- check if pc won after move
exec @winner = pCheckWinner
if @winner = 1 begin return end
