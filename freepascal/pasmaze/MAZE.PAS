Program Maze;
    uses  graph,mkmaze,pathfind,squeue;


Procedure CopyGbToPga(Var GB : MazeRec;Var PGrid : PGA);
var
 i,j : integer;
begin
 For j:=0 to VSize do
 begin
   for i:=0 to  HSize do
   begin
      if GB[i,j]=#219 then PlaceWall(PGrid,i,j);
   end;
 end;
end;

Procedure Plot(x,y,color : integer);
begin
  SetFillStyle(SolidFill,color);
  Bar(x*10,y*10,x*10+10,y*10+10);
end;

Procedure DrawPath(var Path : SimpleQueueRec);
var
 i : integer;

  qr : locationRec;
begin
  for i:=1 to SQueueCount(Path) do
  begin
    SQueueGet(Path,i,qr);
    Plot(qr.x,qr.y,Red);
  end;

end;

procedure DrawGrid(GB : MazeRec);
var
 i,j : integer;
begin
 For j:=0 to VSize do
 begin
   for i:=0 to  HSize do
   begin
      if GB[i,j]=#219 then Plot(i,j,Yellow)
   end;
 end;
end;

procedure DrawGrid2(GB : MazeRec);
var
 i,j : integer;
begin
 For j:=0 to VSize do
 begin
   for i:=0 to  HSize do
   begin
      if GB[i,j]=#219 then Plot(25+i,j,Yellow)
   end;
 end;
end;


var
 GameBoard : MazeRec;
 PathGrid  : PGA;
 FPath     : SimpleQueueRec;
 gd,gm     : integer;
begin
 gd:=EGA;
 gm:=EGAHI;
 Initgraph(gd,gm,'c:\tp7\bgi');

 MakeMaze(GameBoard);
 CopyGBToPGA(GameBoard,PathGrid);
 DrawGrid(GameBoard);
 DrawGrid2(GameBoard);

 readln;
 If FindTargetPath(PathGrid,1,1,19,19,FPath) then
 begin
    DrawPath(FPath);
 end;
 readln;
 closegraph;
end.
