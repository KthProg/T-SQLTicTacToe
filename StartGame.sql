SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[pStartGame] as
print '
==========================================================
Tic Tac Toe - SQL Server 2008 - Kyle Hooks - 10/30/2014
==========================================================
To insert an ''X'', type EXEC pMakeMove row, column, skip.
Row and column must both be between 1 and 3 or you will 
automatically forfeit your move. skip can be either 1 or 
0, with 1 specifying that you''d like to skip your turn. 

You will always start first, unless you decide to skip 
your first turn. You will always be ''X'' and the PC will 
always be ''O''.

When you make a move, the PC will automatically make a 
move as well, the game will check for a winner after 
each of these moves.

After each move, the game board is displayed.

On a winning move, the game board is displayed, a
message is displayed, and the board is cleared.

The game will not display properly unless query output 
is set to text.
'
-- create the board
if not exists (
		select * 
		from INFORMATION_SCHEMA.TABLES 
		where TABLE_SCHEMA = 'dbo' 
		and TABLE_NAME = 'TicTacToe')
begin
	create table TicTacToe
	(
		[row] int,
		[1] bit,
		[2] bit,
		[3] bit
	)
	
	insert into TicTacToe ([row],[1],[2],[3]) values (1,null,null,null),(2,null,null,null),(3,null,null,null)
end
else
begin
	update TicTacToe set [1]=null,[2]=null,[3]=null
end
