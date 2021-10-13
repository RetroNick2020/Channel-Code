unit mkmaze;
(* RANDOMIZE TIMER *)
INTERFACE


(* REM must be even *)
const
  VSIZE = 21;
  HSIZE = 21;

  mhsize = HSIZE-1;
  mvsize = VSIZE-1;
  WChar = #219;

Type
 MazeRec = array[0..hsize, 0..vsize] of char;


Procedure MakeMaze(var Maze : MazeRec);


IMPLEMENTATION

  (* make array and fill *)

Procedure MakeMaze(var Maze : MazeRec);
var
 x,y : integer;
 cx,cy : integer;
 xcount,ycount : integer;
 done  : integer;
 oldx,oldy : integer;
 dir,i       : integer;
begin
  randomize;
  FOR x := 0 to mhsize do
  begin
    FOR y := 0 to mvsize do
    begin
        maze[x, y] := WChar;
    end;
  end;

(* REM initial start location *)
cx := random(mhsize);
cy := random(mvsize);
(*cx := 1; *)
(*cy := 1;*)

(* REM value must be odd*)
IF cx MOD 2 = 0 THEN inc(cx);
IF cy MOD 2 = 0 THEN inc(cy);
maze[cx, cy] := ' ';

(*REM generate maze*)
done := 0;
WHILE done = 0 do
begin
    FOR i := 1 TO 1 do
    begin
        oldx := cx;
        oldy := cy;

        (* REM move in random direction*)
        dir:=Random(4);
        if dir = 0 then
        begin
          IF cx + 2 < mhsize THEN inc(cx,2);
        end
        else if dir = 1 then
        begin
          IF cy + 2 < mvsize THEN inc(cy,2);
        end
        else if dir = 2 then
        begin
          IF cx - 2 > 0 THEN dec(cx,2);
        end
        else
        begin
          IF cy - 2 > 0 THEN dec(cy,2);
        end;

        (* REM if cell is unvisited then connect it *)
        IF maze[cx, cy] = WChar THEN
        begin
            maze[cx, cy] := ' ';
            maze[(cx + oldx) div 2, (cy + oldy )div 2] := ' ';
        end;
    end; (* i *)

    (* REM check if all cells are visited *)
    done := 1;

    x:=-1;
    y:=-1;
    FOR xcount := 1 TO (mhsize div 2) -1 do
    begin
      inc(x,2);

      FOR ycount := 1 TO (mvsize div 2) -1 do
      begin
         inc(y,2);
(*       writeln(y);*)
         IF maze[x, y] = WChar THEN done := 0;
      end;
      y:=-1;
    end;
 end;
end;


(* REM draw maze *)
Procedure PrintMaze(Maze : MazeRec);
var
 x,y : integer;
begin
  FOR y := 0 TO mvsize do
  begin
    FOR x := 0 TO mhsize do
    begin
        write(maze[x, y]);
    end;
    writeln;
  end;

(* REM wait *)
readln;
end;

begin
end.
