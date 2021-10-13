Unit PathFind;

Interface
 Uses squeue;

const
 VSIZE = 21;
 HSIZE = 21;

type
  PGA = Array[0..HSIZE-1,0..VSIZE-1] of Integer;

procedure ClearGrid(var TGrid : PGA);
procedure PlaceWall(var TGrid : PGA;x,y : integer);
procedure PlaceSource(var TGrid : PGA;x,y : integer);
procedure PlaceTarget(var TGrid : PGA;x,y : integer);
Function FindPointPath(var TGrid : PGA;StartX,StartY,StartDir : integer;
                       var PathQueue : SimpleQueueRec) : integer;

procedure PlaceDirectionArrows(var TQueue : SimpleQueueRec;
                               var TGrid  : PGA;
                               x,y : integer);

Function FindTargetPath(var PGrid : PGA;
                         sx,sy,tx,ty : integer;
                         var FoundPath : SimpleQueueRec) : Boolean;


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
 G_Source = 9;
 G_Target  = 10;
 G_Wall    = 11;

Implementation

procedure ClearGrid(var TGrid : PGA);
var
 i,j : integer;
begin
  for j:=0 to VSIZE-1 do
  begin
    for i:=0 to HSIZE-1 do
    begin
      TGrid[i,j]:=G_Empty;
    end;
  end;
end;

procedure PlaceSource(var TGrid : PGA;x,y : integer);
begin
  TGRID[x,y]:=G_Source;
end;

procedure PlaceTarget(var TGrid : PGA;x,y : integer);
begin
  TGRID[x,y]:=G_Target;
end;

procedure PlaceWall(var TGrid : PGA;x,y : integer);
begin
  TGRID[x,y]:=G_Wall;
end;

procedure PlaceWallArea(var TGrid : PGA;x,y,x2,y2 : integer);
var
i,j : integer;
begin
 for j:=y to y2 do
 begin
   for i:=x to x2 do
   begin
     PlaceWall(TGrid,i,j);
   end;
 end;
end;

Function GetReverseDir(inDir : integer) : integer;
begin
  Case InDir of G_Up:GetReverseDir:=G_Down;
              G_Down:GetReverseDir:=G_Up;
              G_Left:GetReverseDir:=G_Right;
              G_Right:GetReverseDir:=G_Left;
              G_Target:GetReverseDir:=G_Target;
  end;
end;

Function FindPointNext(var TGrid : PGA;x,y,dir : integer; var np : LocationRec) : Boolean;
begin
  FindPointNext:=false;
  if (x<0) or (y<0) or (x > (HSize-1)) or (y >(VSize-1)) then exit;
  IF TGrid[x,y] = G_Target then exit;

  if (Dir=G_Up) and (y>0)   then
  begin
     np.x:=x;
     np.y:=y-1;
     np.direction:=GetReverseDir(TGrid[x,y-1]);
     FindPointNext:=true;
  end
  else if (Dir=G_Left) and (x > 0) then
  begin
     np.x:=x-1;
     np.y:=y;
     np.direction:=GetReverseDir(TGrid[x-1,y]);
     FindPointNext:=true;
  end
  else if (Dir=G_Down) and (y < (VSize-1)) then
  begin
     np.x:=x;
     np.y:=y+1;
     np.direction:=GetReverseDir(TGrid[x,y+1]);
     FindPointNext:=true;
  end
  else if (Dir=G_Right) and (x < (HSize-1)) then
  begin
     np.x:=x+1;
     np.y:=y;
     np.direction:=GetReverseDir(TGrid[x+1,y]);
     FindPointNext:=true;
  end;
end;

function isGoodStart(var TGrid : PGA;StartX,StartY, StartDir : integer) : boolean;
var
 nx,ny : integer;
 goodxy  : Boolean;
begin
 nx:=StartX;
 ny:=StartY;
 if StartDir = G_UP then Dec(ny);
 if StartDir = G_DOWN then inc(ny);
 if StartDir = G_LEFT then Dec(nx);
 if StartDir = G_RIGHT then inc(nx);
 goodxy:=(nx >=0) AND (nx < HSIZE) AND (ny>=0) AND (ny<VSIZE);
 isGoodStart:=goodxy and (TGrid[nx,ny]<>G_WALL);
end;

Function FindPointPath(var TGrid : PGA;StartX,StartY,StartDir : integer; Var PathQueue : SimpleQueueRec) : integer;
var
 CP,NP : LocationRec;

begin
 FindPointPath:=0;
 if isGoodStart(TGrid,StartX,StartY,StartDir)=FALSE then exit;
 CP.x:=StartX;
 CP.y:=StartY;
 CP.Direction:=StartDir;
 While FindPointNext(TGrid,CP.x,CP.y,CP.Direction,NP) do
 begin
   if (NP.Direction=G_Target) then
   begin
     if SQueueCount(PathQueue) > 0 then FindPointPath:=SQueueCount(PathQueue);
     exit;
   end;
   SQueuePush(PathQueue,NP);

   CP:=NP;
 end;
end;

procedure PlaceDirShape(var TQueue : SimpleQueueRec;
                        var TGrid  : PGA;
                        x,y,G_Dir  : integer);
var
 QR : LocationRec;
begin
 if (x < 0) or (x>(HSIZE-1)) or (y<0) or (y>(VSIZE-1)) then exit;
 if TGRID[x,y] <> G_Empty then exit;

 TGRID[x,y] := G_Dir;
 QR.x:=x;
 QR.y:=y;
 QR.Direction:=G_Dir;
 SQueuePush(TQueue,QR);
end;

procedure PlaceDirectionArrows(var TQueue : SimpleQueueRec;
                               var TGrid  : PGA;
                               x,y : integer);
begin
    PlaceDirShape(TQueue,TGrid,x+1,y,G_Right);
    PlaceDirShape(TQueue,TGrid,x,y+1,G_Down);
    PlaceDirShape(TQueue,TGrid,x-1,y,G_Left);
    PlaceDirShape(TQueue,TGrid,x,y-1,G_Up);
end;

Function FindTargetPath(var PGrid : PGA;
                         sx,sy,tx,ty : integer;
                         var FoundPath : SimpleQueueRec) : Boolean;

var
 Queue  : SimpleQueueRec;
 qr    : LocationRec;
 found : integer;
begin
 FindTargetPath:=False;
 InitSQueue(Queue);
 PlaceSource(PGrid,sx,sy);
 PlaceTarget(PGrid,tx,ty);

 PlaceDirectionArrows(Queue,PGrid,tx,ty);
 While SQueueCount(Queue)<>0 do
 begin
   SQueuePopFirst(Queue,QR);
   PlaceDirectionArrows(Queue,PGrid,QR.x,QR.y);
 end;

 (*check in all directions*)
 InitSQueue(FoundPath);
 found:=FindPointPath(PGrid,sx,sy,G_DOWN,FoundPath);
 if found = 0 then
 begin
    InitSQueue(FoundPath);
    found:=FindPointPath(PGrid,sx,sy,G_LEFT,FoundPath);
 end;

 if found = 0 then
 begin
    InitSQueue(FoundPath);
    found:=FindPointPath(PGrid,sx,sy,G_UP,FoundPath);
 end;

 if found = 0 then
 begin
    InitSQueue(FoundPath);
    found:=FindPointPath(PGrid,sx,sy,G_RIGHT,FoundPath);
 end;

 if found > 0 then FindTargetPath:=True;
end;

begin
end.