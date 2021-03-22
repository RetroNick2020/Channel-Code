Program PathFind2;
 Uses Crt,Graph;
Const
{$I aDown.con}
{$I aUp.con}
{$I aLeft.con}
{$I aRight.con}
{$I aLU.con}
{$I aLD.con}
{$I aRU.con}
{$I aRD.con}
{$I Player.con}
{$I Monster.con}
{$I Empty.con}
{$I Wall.con}
{$I GDot.con}

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

Type
  QueueRec = record
            x,y,direction : integer;
  end;

  SimpleQueue = object
             c : integer;
             qlist : array[1..1000] of QueueRec;
             constructor init;
             procedure push(qr : QueueRec);
             procedure pop(var qr : QueueRec);
             procedure popfirst(var qr : QueueRec);
             procedure Get(n : integer;var qr : QueueRec);
             function count : integer;
  end;

Var
  Grid : Array[0..19,0..19] of Byte;
  Queue : SimpleQueue;
  QR    : QueueRec;
  FoundQR : QueueRec;

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

procedure DrawGridItem(x,y : integer);
begin
 case Grid[x,y] of G_Empty:PutImage(X*16,y*16,Empty,NormalPut);
              G_Left:PutImage(X*16,y*16,aLeft,NormalPut);
             G_Right:PutImage(X*16,y*16,aRight,NormalPut);
                G_Up:PutImage(X*16,y*16,aUp,NormalPut);
              G_Down:PutImage(X*16,y*16,aDown,NormalPut);
          G_LeftDown:PutImage(X*16,y*16,aLD,NormalPut);
            G_LeftUp:PutImage(X*16,y*16,aLU,NormalPut);
          G_RightDown:PutImage(X*16,y*16,aRD,NormalPut);
            G_RightUp:PutImage(X*16,y*16,aRU,NormalPut);
            G_Player:PutImage(X*16,y*16,Player,NormalPut);
            G_Monster:PutImage(X*16,y*16,Monster,NormalPut);
            G_Wall:PutImage(X*16,y*16,Wall,NormalPut);

 end;
end;


procedure DrawGrid;
var
 i,j : integer;
begin
  for j:=0 to 19 do
  begin
    for i:=0 to 19 do
    begin
      DrawGridItem(i,j);
    end;
  end;
end;

procedure ClearGrid;
var
 i,j : integer;
begin
  for j:=0 to 19 do
  begin
    for i:=0 to 19 do
    begin
      Grid[i,j]:=G_Empty;
    end;
  end;
end;

procedure DrawDot(x,y : integer);
begin
  PutImage(X*16,y*16,GDot,NormalPut);
end;

procedure DrawDotPath(var QP : SimpleQueue);
var
  i : integer;
  qr : QueueRec;
begin
 for i:=1 to QP.Count do
 begin
     QP.Get(i,qr);
     DrawDot(qr.x,qr.y);
 end;
end;

procedure PlaceMonster(x,y : integer);
begin
  GRID[x,y]:=G_Monster;
end;

procedure PlacePlayer(x,y : integer);
begin
  GRID[x,y]:=G_Player;
end;

procedure PlaceWall(x,y : integer);
begin
  GRID[x,y]:=G_Wall;
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
  IF Grid[x,y] = G_Player then exit;

  if Dir=G_Up   then
  begin
     np.x:=x;
     np.y:=y-1;
     np.direction:=GetReverseDir(Grid[x,y-1]);
     FindPointNext:=true;
  end
  else if Dir=G_Left then
  begin
     np.x:=x-1;
     np.y:=y;
     np.direction:=GetReverseDir(Grid[x-1,y]);
     FindPointNext:=true;
  end
  else if Dir=G_Down then
  begin
     np.x:=x;
     np.y:=y+1;
     np.direction:=GetReverseDir(Grid[x,y+1]);
     FindPointNext:=true;
  end
  else if Dir=G_Right then
  begin
     np.x:=x+1;
     np.y:=y;
     np.direction:=GetReverseDir(Grid[x+1,y]);
     FindPointNext:=true;
  end;
end;

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
 if (x < 0) or (x>19) or (y<0) or (y>19) then exit;
 if GRID[x,y] <> G_Empty then exit;

 GRID[x,y] := G_Dir;
 QR.x:=x;
 QR.y:=y;
 QR.Direction:=G_Dir;
 Queue.push(QR);
end;

procedure PlaceDirectionArrows(x,y : integer);
begin
  (*  PlaceDirShape(x+1,y-1,G_RightUp);
    PlaceDirShape(x-1,y+1,G_LeftDown);
    PlaceDirShape(x+1,y+1,G_RightDown);
    PlaceDirShape(x-1,y-1,G_LeftUp);*)

    PlaceDirShape(x+1,y,G_Right);
    PlaceDirShape(x,y+1,G_Down);
    PlaceDirShape(x-1,y,G_Left);
    PlaceDirShape(x,y-1,G_Up);
end;

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
    if keypressed then
      begin
      if readkey = 'q' then exit;
     end;
   Queue.PopFirst(QR);
   PlaceDirectionArrows(QR.x,QR.y);
 //  DrawGrid;
 end;
 DrawGrid;

 PathPoints.Init;

 if FindPointPath(18,6,G_UP,PathPoints) then
 begin
   DrawDotPath(PathPoints);
 end;
 readln;
 CloseGraph;
end.
