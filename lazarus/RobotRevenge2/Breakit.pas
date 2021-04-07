Program Breakit;
  uses Crt,Collision,VGA;

Const
 Paddle = 1;
 Ball   = 2;
 BottomWall = 3;
 TopWall = 4;
 LeftWall = 5;
 RightWall = 6;
 Brick = 7;

{$I BallImage.con}
{$I PaddleImage.con}

Var
 VirtDir  : integer;
 HorizDir : integer;

procedure DrawPaddle(shapeid : integer);
var
 x,y,x2,y2 : integer;
begin
 GetCoords(shapeid,x,y,x2,y2);
// SetColor(Green);
// Bar(x,y,x2,y2);
 PutImage(x,y,PaddleImage,0);
end;

procedure DrawBall(shapeid : integer);
var
 x,y,x2,y2 : integer;
begin
 GetCoords(shapeid,x,y,x2,y2);
// SetColor(Red);
// Rectangle(x,y,x2,y2);
 PutImage(x,y,BallImage,0);
end;

procedure DrawBrick(shapeid : integer);
var
 x,y,x2,y2 : integer;
begin
 GetCoords(shapeid,x,y,x2,y2);
 SetColor(shapeid);
 Bar(x,y,x2,y2);
end;


procedure DrawWall(shapeid : integer);
var
 x,y,x2,y2 : integer;
begin
 GetCoords(shapeid,x,y,x2,y2);
// SetColor(Blue);
// Rectangle(x,y,x2,y2);
end;

procedure Collission(ShapeId1,ShapeId2,PlayerId1,PlayerId2 : integer);
begin
end;

procedure BallPaddleCollission(ShapeId1,ShapeId2,PlayerId1,PlayerId2 : integer);
begin
  VirtDir :=-1;
end;

procedure BallTopWallCollission(ShapeId1,ShapeId2,PlayerId1,PlayerId2 : integer);
begin
  VirtDir :=1;
end;

procedure BallLeftWallCollission(ShapeId1,ShapeId2,PlayerId1,PlayerId2 : integer);
begin
  HorizDir :=1;
end;

procedure BallRightWallCollission(ShapeId1,ShapeId2,PlayerId1,PlayerId2 : integer);
begin
  HorizDir :=-1;
end;

procedure BallBottomWallCollission(ShapeId1,ShapeId2,PlayerId1,PlayerId2 : integer);
begin
  halt;
end;

procedure BallBrickCollission(ShapeId1,ShapeId2,PlayerId1,PlayerId2 : integer);
begin
  SetShapeActive(Shapeid1,false);
  If VirtDir =1 then
  begin
   VirtDir:=-1;
  end
  else
  begin
   VirtDir:=1;
  end;
end;


Procedure GoRight;
var
 x,y,x2,y2 : integer;
begin
  GetCoords(1,x,y,x2,y2);
  if (x2+4) < 320 then MovePlayerDelta(Paddle,4,0);
end;

Procedure GoLeft;
var
 x,y,x2,y2 : integer;
begin
  GetCoords(1,x,y,x2,y2);
  if (x-4) > -1 then MovePlayerDelta(Paddle,-4,0);
end;

procedure AddBrick(Shapeid,x,y : integer);
begin
 SetShape(Shapeid,Brick,true,true,x*32,y*10,30,8,0,0,@DrawBrick);
 AddCollission(Shapeid,2,@BallBrickCollission);
end;

procedure AddBricks;
var
 i,j : integer;
 Color : integer;
 BrickId : integer;
begin
 BrickId:=7;
 for j:=1 to 4 do
 begin
   for i:=1 to 8 do
   begin
      AddBrick(BrickId,i,j);
      inc(BrickId);
   end;
 end;
end;

var
 Finished : Boolean;
 Key : Char;

begin
 SetVGAMode13;
 InitShapes;
 Initcollisions;

 SetShape(1,Paddle,true,true,20,185,30,8,0,0,@DrawPaddle);
 SetShape(2,Ball,true,true,20,170,5,5,0,0,@DrawBall);
 SetShape(3,BottomWall,true,true,0,195,320,5,0,0,@DrawWall);
 SetShape(4,TopWall,true,true,0,0,320,5,0,0,@DrawWall);
 SetShape(5,LeftWall,true,true,0,5,5,190,0,0,@DrawWall);
 SetShape(6,RightWall,true,true,315,5,5,190,0,0,@DrawWall);

 AddCollission(1,2,@BallPaddleCollission);
 AddCollission(2,3,@BallBottomWallCollission);
 AddCollission(2,4,@BallTopWallCollission);
 AddCollission(2,5,@BallLeftWallCollission);
 AddCollission(2,6,@BallRightWallCollission);

 AddBricks;
 HorizDir:=0;
 VirtDir:=0;
 Finished:=false;
 While Not Finished do
 begin
   ClearScreen(0);
   MovePlayerDelta(Ball,HorizDir,VirtDir);
   DrawShapes;
   ProcessCollissions;
   if KeyPressed then
      Key:=ReadKey;
      case key of 'a':GoLeft;
                  's':GoRight;
                  ' ':begin
                         HorizDir:=1;
                         VirtDir:=-1;
                      end;
                  'q':Finished:=true;
      end;
      Key:=#0;
      delay(100);
 end;
 TextMode(co80);
end.
