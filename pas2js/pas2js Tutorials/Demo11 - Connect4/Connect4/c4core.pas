{
Connect 4 - Copyright (C) 1999  Andrew Clausen
Original code for Turbo Pascal can be found here
https://github.com/RetroNick2020/pascal_connect4

Ported to Pas2JS by RetroNick April 3 - 2023
Removed direct screen writes and some other code rendered useless by logic changes

This program is free software.  It is released under the terms of the
GNU General Public Licence as published by the Free Software Foundation, Inc.
which can be obtained from www.gnu.org.

This program comes with ABSOLUTELY NO WARRANTY, not even an implied
warranty of merchantability, or fitness for a particular purpose.
}
unit c4core;

Interface

const EMPTY = 0;
      RED = 1;
      YELLOW = 2;

const PLAYER_VS_COMPUTER   = 1;
      COMPUTER_VS_PLAYER   = 2;
      PLAYER_VS_PLAYER     = 3;
      COMPUTER_VS_COMPUTER = 4;
      QUIT              = 5;

const LookAheadDepth = 5; (* DEF 5*)

const weight : array [1..7, 1..6] of integer =
{
      (
          (  0,  0, 20, 30, 30, 20),
          (  0, 40, 40, 50, 60, 60),
          ( 50, 60, 70, 90, 90, 80),
          ( 80, 90,100,100, 70, 90),
          ( 50, 60, 70, 90, 90, 80),
          (  0, 40, 40, 50, 60, 60),
          (  0,  0, 20, 30, 30, 20)
      );
}
	(
		(  3,   1,   0,  11,  20,  26),
		(  0,  38,  33,  42,  39,  27),
		( 35,  60,  74,  81,  77,  48),
		( 72,  91,  91, 100,  88,  68),
		( 37,  48,  88,  95,  81,  78),
		(  9,  51,  25,  64,  22,  18),
		(  3,   7,   6,  28,  26,  27)
	);

type
 boardtype = array [1..7, 1..6] of integer;


type
 TMove = Record
    col, row: integer;
    score: integer;
 end;

procedure init_board;
function drop_piece(col, team : integer) : integer;
function do_computer_move(team: integer) : integer;
function is_connect_four(col : integer) : boolean;
function get_move_number : integer;
function get_drop_row(col : integer) : integer;
function get_game_piece(col,row : integer) : integer;

Implementation

var move_result: TMove;
    move_num : integer;
    board: boardtype;

procedure init_board;
var c, r: integer;
begin
   move_num:=0;
   for r := 1 to 6 do
       for c := 1 to 7 do
           board [c, r] := EMPTY;
end;

function get_move_number : integer;
begin
  get_move_number:=move_num;
end;

function get_drop_row(col : integer) : integer;
var
 i : integer;
 row : integer;
begin
  row:=-1;
  for i:=1 to 6 do
  begin
    if board[col,i] = EMPTY then row:=i;
  end;
  get_drop_row:=row;
end;

function get_game_piece(col,row : integer) : integer;
begin
  get_game_piece:=board [col,row];
end;

function drop_piece(col, team : integer) : integer;
var
 row : integer;
begin
    for row :=6 downto 1 do
    begin
        if board [col, row] = EMPTY then
        begin
            board [col, row] := team;
            drop_piece := row;
            inc(move_num);
            exit;
        end;
    end;
end;

procedure undrop_piece(col : integer);
var 
 row: integer;
begin
   row := 1;
   while board [col, row] = EMPTY do
       row := row + 1;
   board [col, row] := EMPTY;
end;

function min(a, b: integer) : integer;
begin
    if a < b then
        min := a
    else
        min := b;
end;

function max(a, b: integer) : integer;
begin
    if a > b then
        max := a
    else
        max := b;
end;

function is_connect_four_vert (col, row, team : integer) : boolean;
var 
  i: integer;
begin
    if row > 3 then
        is_connect_four_vert := false
    else
    begin
      is_connect_four_vert := true;
      for i := row to row + 3 do
          if board [col, i] <> team then
             is_connect_four_vert := false;
    end;
end;

function is_connect_four_horiz (col, row, team : integer) : boolean;
var i, run: integer;
begin
    run := 0;
    is_connect_four_horiz := false;
    for i := max (col - 4, 1) to min (col + 4, 7) do
    begin
        if board [i, row] = team then
        begin
            run := run + 1;
            if run = 4 then
                is_connect_four_horiz := true;
        end
        else run := 0;
    end;
end;

function is_connect_four_ldiag (col, row, team : integer) : boolean;
var pos, start, finish, run : integer;
begin
    start := - min (min (col - 1, row - 1), 3);
    finish := min (min (7 - col, 6 - row), 3);
    run := 0;
    is_connect_four_ldiag := false;
    for pos := start to finish do
    begin
        if board [col + pos, row + pos] = team then
        begin
            run := run + 1;
            if run = 4 then
                is_connect_four_ldiag := true;
        end
        else run := 0;
    end;
end;

function is_connect_four_rdiag (col, row, team : integer) : boolean;
var pos, start, finish, run : integer;
begin
    start := - min (min (col - 1, 6 - row), 3);
    finish := min (min (7 - col, row - 1), 3);
    run := 0;
    is_connect_four_rdiag := false;
    for pos := start to finish do
    begin
        if board [col + pos, row - pos] = team then
        begin
            run := run + 1;
            if run = 4 then
                is_connect_four_rdiag := true;
        end
        else run := 0;
    end;
end;

function is_connect_four_diag (col, row, team : integer) : boolean;
begin
    is_connect_four_diag := is_connect_four_ldiag (col, row, team)
                            or is_connect_four_rdiag (col, row, team);
end;

{ Checks for connect 4, going through (x, y) }
function is_connect_four (col: integer) : boolean;
var team: integer;
    row : integer;
begin
    row := 1;
    while board [col, row] = EMPTY do
        inc(row);
    team := board [col, row];
    is_connect_four := is_connect_four_diag (col, row, team)
                       or is_connect_four_vert (col, row, team)
                       or is_connect_four_horiz (col, row, team);
end;


function other_team (team: integer) : integer;
begin
    if team = RED then
        other_team := YELLOW
    else
        other_team := RED;
end;

procedure think (team, lookahead : integer);
var 
  best_move : TMove;
  this_move : TMove;
  movecol   : integer;
begin
    best_move.col := 4;
    best_move.score := -16384;

    //this_move.col;
    for movecol := 1 to 7 do
    begin
        this_move.col:=movecol; 
        if board [this_move.col, 1] = EMPTY then
        begin
            this_move.row := drop_piece (this_move.col, team);

            if is_connect_four (this_move.col) then
            begin
                 undrop_piece (this_move.col);
                 this_move.score := 16384;
                 move_result := this_move;
                 exit;
            end;

            this_move.score := 0;
            if lookahead > 0 then
            begin
                think (other_team (team), lookahead - 1);
                this_move.score := - move_result.score * 5 div 6;
            end;

            this_move.score := this_move.score
                               + weight [this_move.col, this_move.row];
            undrop_piece (this_move.col);

            if this_move.score > best_move.score then
            begin
                best_move.col := this_move.col;
                best_move.score := this_move.score;
            end;
        end;
    end;
    move_result := best_move;
end;

// returns column it was dropped
function do_computer_move (team: integer) : integer;
begin
    think (team, LookAheadDepth);
    do_computer_move := move_result.col;
end;

begin
end.
