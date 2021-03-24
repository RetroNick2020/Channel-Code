Program Collision1;
  uses crt,graph;

const
 MaxShapes = 50;
 MaxCollisions = 50;
{$I GDot.con}
{$I Player.con}
{$I Monster.con}

type
 PointRec = Record
              x,y,x2,y2 : integer;
            End;

 DrawProc = procedure(shapeid : integer);
 ShapeRec = Record
              shapeid,playerid     : integer;
              active,visible       : boolean;
              x,y : integer;
              width,height : integer;
              xoff,yoff : integer;
              Draw   : DrawProc;
            end;

 CollisionProc = procedure(ShapeId1,ShapeId2,PlayerId1,PlayerId2 : integer);
 CollisionRec = Record
                  shapeid1,shapeid2 : integer;
                  Collision : CollisionProc;
                end;
Var
 ShapeList : array[1..MaxShapes] of ShapeRec;
 CollisionList : array[1..MaxCollisions] of CollisionRec;
 CollisionCount : integer;
 Score           : integer;


procedure InitCollisions;
begin
 CollisionCount:=0;
end;

procedure MovePlayer(playerid,x,y : integer);
var
 i : integer;
 FindFirst : boolean;
 dx,dy : integer;
begin
 FindFirst:=false;
 for i:=1 to MaxShapes do
 begin
   if ShapeList[i].playerid = playerid then
   begin
     If FindFirst = false then
     begin
       dx:=x-ShapeList[i].x;
       dy:=y-ShapeList[i].y;
       FindFirst:=true;
     end;
     ShapeList[i].x:=ShapeList[i].x+dx;
     ShapeList[i].y:=ShapeList[i].y+dy;
   end;
 end;
end;

procedure MovePlayerDelta(playerid,xp,yp : integer);
var
 i : integer;
begin
 for i:=1 to MaxShapes do
 begin
   if ShapeList[i].playerid = playerid then
   begin
     Inc(ShapeList[i].x,xp);
     Inc(ShapeList[i].y,yp);
   end;
 end;
end;


procedure DrawShapes;
var
 i : integer;
begin
 for i:=1 to MaxShapes do
 begin
    if ShapeList[i].active then ShapeList[i].Draw(i);
 end;
end;

procedure InitShapes;
var
 i : integer;
begin
 for i:=1 to MaxShapes do
 begin
    ShapeList[i].active:=false;
 end;
end;

procedure SetShape(shapeid,playerid: integer;active,visible: boolean;
                   x,y,width,height,xoff,yoff: integer; Draw : DrawProc);
begin
 if shapeid > MaxShapes then exit;
 ShapeList[Shapeid].shapeid:=shapeid;
 ShapeList[Shapeid].playerid:=playerid;
 ShapeList[Shapeid].active:=active;
 ShapeList[Shapeid].visible:=visible;
 ShapeList[Shapeid].x:=x;
 ShapeList[Shapeid].y:=y;
 ShapeList[Shapeid].width:=width;
 ShapeList[Shapeid].height:=height;
 ShapeList[Shapeid].xoff:=xoff;
 ShapeList[Shapeid].yoff:=yoff;
 ShapeList[Shapeid].Draw:=Draw;
end;

procedure AddCollission(shapeid1,shapeid2 : integer;Collision : CollisionProc);
begin
 if CollisionCount < MaxCollisions then
 begin
   inc(CollisionCount);
   CollisionList[CollisionCount].shapeid1:=shapeid1;
   CollisionList[CollisionCount].shapeid2:=shapeid2;
   CollisionList[CollisionCount].Collision:=Collision;
 end;
end;


procedure ProcessCollissions;
var
 i : integer;
 Shape1,Shape2 : PointRec;
 ShapeId1,ShapeId2 : integer;
 PlayerId1,PlayerId2 : integer;
begin
  for i:=1 to CollisionCount do
  begin
   ShapeId1:=CollisionList[i].Shapeid1;
   ShapeId2:=CollisionList[i].Shapeid2;

   PlayerId1:=ShapeList[ShapeId1].PlayerId;
   PlayerId2:=ShapeList[ShapeId2].PlayerId;

   Shape1.x:=ShapeList[ShapeId1].x+ShapeList[ShapeId1].xoff;
   Shape1.y:=ShapeList[ShapeId1].y+ShapeList[ShapeId1].yoff;
   Shape1.x2:=Shape1.x+ShapeList[ShapeId1].width-1;
   Shape1.y2:=Shape1.y+ShapeList[ShapeId1].height-1;

   Shape2.x:=ShapeList[ShapeId2].x+ShapeList[ShapeId2].xoff;
   Shape2.y:=ShapeList[ShapeId2].y+ShapeList[ShapeId2].yoff;
   Shape2.x2:=Shape2.x+ShapeList[ShapeId2].width-1;
   Shape2.y2:=Shape2.y+ShapeList[ShapeId2].height-1;

   if (Shape1.x < Shape2.x2) AND
      (Shape1.x2 > Shape2.x) AND
      (Shape1.y < Shape2.y2) AND
      (Shape1.y2 > Shape2.y) then
      CollisionList[i].Collision(ShapeId1,ShapeId2,PlayerId1,PlayerId2);
   end;
end;


procedure DrawShape(shapeid : integer);
begin
  SetColor(Green);
  Rectangle(Shapelist[shapeid].x,
            ShapeList[shapeid].y,
            Shapelist[shapeid].x+Shapelist[shapeid].width-1,
            ShapeList[shapeid].y+Shapelist[shapeid].height-1);

  //PutImage(Shapelist[shapeid].x,ShapeList[shapeid].y,Player,NormalPut);
end;

procedure DrawShape2(shapeid : integer);
begin
  SetColor(Red);
  Rectangle(Shapelist[shapeid].x,
            ShapeList[shapeid].y,
            Shapelist[shapeid].x+Shapelist[shapeid].width-1,
            ShapeList[shapeid].y+Shapelist[shapeid].height-1);

  //PutImage(Shapelist[shapeid].x,ShapeList[shapeid].y,Monster,NormalPut);
end;

procedure Collission(ShapeId1,ShapeId2,PlayerId1,PlayerId2 : integer);
begin
 SetColor(Green);
 OutTextXY(500,30,'Collission!');
 Inc(Score,10);
 MovePlayerDelta(2,-50+Random(100),-20+Random(40));
end;


Procedure GoUp;
begin
  MovePlayerDelta(1,0,-2);
end;

Procedure GoDown;
begin
  MovePlayerDelta(1,0,2);
end;

Procedure GoRight;
begin
  MovePlayerDelta(1,2,0);
end;

Procedure GoLeft;
begin
  MovePlayerDelta(1,-2,0);
end;

Procedure PrintScore;
var
 ScoreStr : string;
begin
 Str(Score,ScoreStr);
 OutTextXY(500,20,ScoreStr);
end;

var
 gd,gm : integer;
 Finished : Boolean;
 Key : Char;

begin
 gd:=ega;
 gm:=egahi;
 initgraph(gd,gm,'');

 InitShapes;
 Initcollisions;

 SetShape(1,1,true,true,14,2,10,6,0,0,@DrawShape);
 SetShape(2,1,true,true,10,10,16,16,0,0,@DrawShape);

 SetShape(3,2,true,true,30,30,16,16,0,0,@DrawShape2);
 AddCollission(2,3,@Collission);
 AddCollission(1,3,@Collission);

 MovePlayer(1,100,100);
 While Not Finished do
 begin
   ClearViewPort;
   DrawShapes;
   ProcessCollissions;
   PrintScore;
   delay(100);
   if KeyPressed then
      Key:=ReadKey;
      case key of 'a':GoLeft;
                  's':GoRight;
                  'w':GoUp;
                  'z':GoDown;
                  'q':Finished:=true;
      end;
      Key:=#0;
 end;
 closegraph;
end.
