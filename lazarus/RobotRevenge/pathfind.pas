Unit PathFind;

Interface
Const
G_Empty = 0;
G_Left = 1;
G_Right = 2;
G_Up = 3;
G_Down = 4;
G_LeftDown = 5;
G_LeftUp = 6;
G_RightDown = 7;
G_RightUp = 8;
G_Monster = 9;
G_Player  = 10;
G_Wall  = 11;

Max_Grid_X = 50;
Max_Grid_Y = 50;

Type
  QueueRec = record
            x,y,direction : integer;
  end;

  SimpleQueue = object
             c : integer;
             qlist : array[1..2000] of QueueRec;
             constructor init;
             procedure push(qr : QueueRec);
             procedure pop(var qr : QueueRec);
             procedure popfirst(var qr : QueueRec);
             procedure Get(n : integer;var qr : QueueRec);
             function count : integer;
  end;

Procedure CreatePathGridStart(x,y : integer);
Function FindPointNext(x,y,dir : integer; var np : QueueRec) : Boolean;
Function FindPointPath(StartX,StartY,StartDir : integer; Var PathQueue : SimpleQueue) : Boolean;
Function FindDirectionFromMonster(x,y : integer) : integer;
procedure PlacePlayer(x,y : integer);
procedure PlaceMonster(x,y : integer);

procedure PlaceWall(x,y : integer);
procedure PlaceWallArea(x,y,x2,y2 : integer);
procedure ClearGrid;
procedure ClearGridLeaveWalls;

Implementation
type
  GridRec = Record
               Dir  : byte;
               CVal : integer;
            end;

Var
  Grid : Array[0..Max_Grid_X,0..Max_Grid_Y] of GridRec;
  Queue : SimpleQueue;
  QR    : QueueRec;
  FoundQR : QueueRec;
  CValCounter : integer;

constructor SimpleQueue.init;
begin
 c:=0;
end;


procedure SimpleQueue.push(qr : QueueRec);
begin
 inc(c);
 if c > 999 then halt;
 qlist[c]:=qr;
end;

procedure SimpleQueue.pop(var qr : QueueRec);
begin
 if c > 0 then
 begin
   qr:=qlist[c];
   dec(c);
 end;
end;

procedure SimpleQueue.Get(n : integer;var qr : QueueRec);
begin
   qr:=qlist[n];
end;

procedure SimpleQueue.popfirst(var qr : QueueRec);
var
i : integer;
begin
 if c > 0 then
 begin
   qr:=qlist[1];
   dec(c);
   for i:=1 to c do
   begin
      qlist[i]:=qlist[i+1];
   end;
 end;
end;


function SimpleQueue.count : integer;
begin
  count:=c;
end;


procedure ClearGrid;
var
 i,j : integer;
begin
 CValCounter:=0;
 for j:=0 to Max_Grid_Y do
  begin
    for i:=0 to Max_Grid_X do
    begin
      Grid[i,j].Dir:=G_Empty;
      Grid[i,j].CVal:=0;
    end;
  end;
end;

procedure ClearGridLeaveWalls;
var
 i,j : integer;
begin
 CValCounter:=0;
 for j:=0 to Max_Grid_Y do
  begin
    for i:=0 to Max_Grid_X do
    begin
      if Grid[i,j].Dir<>G_Wall then
      begin
        Grid[i,j].Dir:=G_Empty;
        Grid[i,j].CVal:=0;
      end;
    end;
  end;
end;


procedure PlaceMonster(x,y : integer);
begin
  GRID[x,y].Dir:=G_Monster;
end;

procedure PlacePlayer(x,y : integer);
begin
  GRID[x,y].Dir:=G_Player;
end;

procedure PlaceWall(x,y : integer);
begin
  GRID[x,y].Dir:=G_Wall;
end;

procedure PlaceWallArea(x,y,x2,y2 : integer);
var
i,j : integer;
begin
 for j:=y to y2 do
 begin
   for i:=x to x2 do
   begin
     PlaceWall(i,j);
   end;
 end;
end;

Function GetReverseDir(inDir : integer) : integer;
begin
  Case InDir of G_Up:GetReverseDir:=G_Down;
              G_Down:GetReverseDir:=G_Up;
              G_Left:GetReverseDir:=G_Right;
              G_Right:GetReverseDir:=G_Left;
              G_Player:GetReverseDir:=G_Player;
  end;
end;

Function FindPointNext(x,y,dir : integer; var np : QueueRec) : Boolean;
begin
  FindPointNext:=false;
  IF Grid[x,y].Dir = G_Player then exit;

  if Dir=G_Up   then
  begin
     np.x:=x;
     np.y:=y-1;
     np.direction:=GetReverseDir(Grid[x,y-1].Dir);
     FindPointNext:=true;
  end
  else if Dir=G_Left then
  begin
     np.x:=x-1;
     np.y:=y;
     np.direction:=GetReverseDir(Grid[x-1,y].Dir);
     FindPointNext:=true;
  end
  else if Dir=G_Down then
  begin
     np.x:=x;
     np.y:=y+1;
     np.direction:=GetReverseDir(Grid[x,y+1].Dir);
     FindPointNext:=true;
  end
  else if Dir=G_Right then
  begin
     np.x:=x+1;
     np.y:=y;
     np.direction:=GetReverseDir(Grid[x+1,y].Dir);
     FindPointNext:=true;
  end;
end;


Function FindDirectionFromMonster(x,y : integer) : integer;
var
 startdir,cval : integer;
begin
startdir:=0;
cval:=0;
  if x > 0 then
 begin
    startdir:=G_Left;
    cval:=Grid[x-1,y].CVal;
 end;
 if x < Max_Grid_x then
 begin
   if Grid[x+1,y].CVal < cval then
   begin
     startdir:=G_Right;
     CVal:=Grid[x+1,y].CVal;
   end;
 end;

 if y > 0 then
 begin
   if Grid[x,y-1].CVal < cval then
   begin
     startdir:=G_UP;
     CVal:=Grid[x,y-1].CVal;
   end;
 end;

 if y < Max_Grid_Y then
 begin
   if Grid[x,y+1].CVal < cval then
   begin
     startdir:=G_DOWN;
     CVal:=Grid[x,y+1].CVal;
   end;
 end;
 FindDirectionFromMonster:=startdir;
end;

//FindPointPath is looking for G_Player - it must be set or find will fail
Function FindPointPath(StartX,StartY,StartDir : integer; Var PathQueue : SimpleQueue) : Boolean;
var
 CP,NP : QueueRec;
begin
 FindPointPath:=False;
 CP.x:=StartX;
 CP.y:=StartY;
 CP.Direction:=StartDir;
 While FindPointNext(CP.x,CP.y,CP.Direction,NP) do
 begin
   if (NP.Direction=G_Player) then
   begin
     if PathQueue.count > 0 then FindPointPath:=true;
     exit;
   end;
   PathQueue.Push(NP);
   CP:=NP;
 end;
 if PathQueue.Count > 0 then
 begin
    FindPointPath:=True;
 end;
end;

procedure PlaceDirShape(x,y,G_Dir : integer);
begin
 if (x < 0) or (x>Max_Grid_X) or (y<0) or (y>Max_Grid_Y) then exit;
 if GRID[x,y].Dir <> G_Empty then exit;

 inc(CValCounter);
 GRID[x,y].Dir := G_Dir;
 GRID[x,y].CVal := CValCounter;

 QR.x:=x;
 QR.y:=y;
 QR.Direction:=G_Dir;
 Queue.push(QR);
end;

procedure PlaceDirectionArrows(x,y : integer);
begin
 PlaceDirShape(x+1,y,G_Right);
 PlaceDirShape(x,y+1,G_Down);
 PlaceDirShape(x-1,y,G_Left);
 PlaceDirShape(x,y-1,G_Up);
end;

Procedure CreatePathGridStart(x,y : integer);
begin
 Queue.Init;
 PlaceDirectionArrows(x,y);
 While Queue.Count<>0 do
 begin
   Queue.PopFirst(QR);
   PlaceDirectionArrows(QR.x,QR.y);
 end;
end;


(*


Var
 Gd, Gm: Integer;
 PathPoints : SimpleQueue;
 a : string;
Begin
 Gd:=EGA;
 Gm:=EGAHi;
 InitGraph(Gd,Gm,'');

 Queue.Init;

 ClearGrid;
 PlaceWallArea(7,4,7,8);
 PlaceWallArea(8,8,10,8);

 PlaceWall(18,4);
 PlaceWallArea(17,5,17,8);

 PlaceWall(18,8);
 PlaceWall(19,8);
 PlaceWall(19,7);

 PlaceWallArea(10,10,15,12);
 PlaceWallArea(2,2,4,4);

 PlaceWallArea(2,9,6,18);
 PlaceWallArea(7,14,19,16);

 PlaceMonster(18,6);
 PlaceMonster(8,6);
 PlaceMonster(11,8);

 PlacePlayer(19,19);
 PlaceDirectionArrows(19,19);
 DrawGrid;
 While Queue.Count<>0 do
 begin
   Queue.PopFirst(QR);
   PlaceDirectionArrows(QR.x,QR.y);
 end;
 DrawGrid;

 PathPoints.Init;

 if FindPointPath(18,6,G_UP,PathPoints) then
 begin
   DrawDotPath(PathPoints);
 end;
 readln;
 CloseGraph;*)

begin

end.
