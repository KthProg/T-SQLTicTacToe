SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[pCheckWinner]
as
if 
-- check rows
exists (
	select *
	from TicTacToe
	where [1]=[2] and [2]=[3]
	and [1] is not null
)
or
-- check columns
-- (transpose and repeat)
exists (
	select *
	from
	(
		select row, col, cast(player as float) as player
		from TicTacToe
		unpivot
		(
		player for col in ([1],[2],[3])
		) unpiv
	) src
	pivot
	(
		sum(player)
		for row in ([1],[2],[3])
	) piv
	where [1]=[2] and [2]=[3]
)
or
-- check diagonal 1
exists (
	select * from
	(
		select [1] as player from TicTacToe
		where row = 1
		union all
		select [2] as player from TicTacToe
		where row = 2
		union all
		select [3] as player from TicTacToe
		where row = 3
	) Temp
	having avg(isnull(cast(player as float), 5.0))=0 or avg(isnull(cast(player as float), 5.0))=1
)
or
-- check diagonal 2
exists (
	select * from
	(
		select [1] as player from TicTacToe
		where row = 3
		union all
		select [2] as player from TicTacToe
		where row = 2
		union all
		select [3] as player from TicTacToe
		where row = 1
	) Temp
	having avg(isnull(cast(player as float), 5.0))=0 or avg(isnull(cast(player as float), 5.0))=1
)
begin
	print 'Someone won... you know who. Game reset.'
	select * from vGameBoard
	update TicTacToe set [1]=null,[2]=null,[3]=null
	return 1
end
else
begin
	if not exists (
		select *
		from TicTacToe
		where [1] is null
		or [2] is null
		or [3] is null
	)
	begin
		-- set board when tied
		print 'Tie game'
		select * from vGameBoard
		update TicTacToe set [1]=null,[2]=null,[3]=null
		return 1
	end
end

-- show game result
select * from vGameBoard

