Program Demo4;
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
             function count : integer;
  end;

Var
  Grid : Array[0..19,0..19] of Byte;
  Queue : SimpleQueue;
  QR    : QueueRec;

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

procedure PlaceDir8(x,y : integer);
begin
  PlaceDirShape(x+1,y-1,G_RightUp);
    PlaceDirShape(x-1,y+1,G_LeftDown);
    PlaceDirShape(x+1,y+1,G_RightDown);
    PlaceDirShape(x-1,y-1,G_LeftUp);

    PlaceDirShape(x+1,y,G_Right);
    PlaceDirShape(x,y+1,G_Down);
    PlaceDirShape(x-1,y,G_Left);
    PlaceDirShape(x,y-1,G_Up);
end;

Var
 Gd, Gm: Integer;
 a : string;
Begin
 Gd:=EGA;
 Gm:=EGAHi;
 InitGraph(Gd,Gm,'');

 Queue.Init;

 ClearGrid;
 PlacePlayer(5,5);
 PlaceWall(7,5);
 PlaceWall(7,4);
 PlaceWall(7,6);
 PlaceWall(7,7);
 PlaceWall(7,8);
 PlaceWall(8,8);
 PlaceWall(9,8);
 PlaceWall(10,8);

 PlaceMonster(8,6);
 PlaceDir8(5,5);
 DrawGrid;
 While Queue.Count<>0 do
 begin
   readln(a);
   if a = 'q' then exit;
   Queue.PopFirst(QR);
   PlaceDir8(QR.x,QR.y);
   DrawGrid;
 end;

 CloseGraph;
end.
