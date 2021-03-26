program game;

{$mode objfpc}{$H+}

uses cmem, ray_header,collision,SysUtils;

const
 screenWidth = 600;
 screenHeight = 400;

 Paddle = 1;
 Ball   = 2;
 BottomWall = 3;
 TopWall = 4;
 LeftWall = 5;
 RightWall = 6;
 Brick = 7;

 PaddleWidth = 62;
 PaddleHeight = 16;

 BallWidth = 11;
 BallHeight = 11;

 BrickWidth = 60;
 Brickheight = 20;

Var
 VirtDir  : integer;
 HorizDir : integer;
 Finished : Boolean;
 Key : integer;

 PaddleTexture :TTexture2D;
 BallTexture :TTexture2D;

procedure DrawPaddle(shapeid : integer);
var
// x,y,x2,y2 : integer;
 sr : ShapeRec;
begin
 GetShapeRec(shapeid,sr);
 //DrawRectangle(sr.x,sr.y,sr.width,sr.height,GREEN);
  DrawTexture(PaddleTexture,sr.x,sr.y,WHITE);
end;

procedure DrawBall(shapeid : integer);
var
  sr : ShapeRec;
begin
 GetShapeRec(shapeid,sr);
 DrawTexture(BallTexture,sr.x,sr.y,WHITE);
 //DrawRectangle(sr.x,sr.y,sr.width,sr.height,WHITE);
end;

procedure DrawBrick(shapeid : integer);
var
  sr : ShapeRec;
begin
 GetShapeRec(shapeid,sr);
 DrawRectangle(sr.x,sr.y,sr.width,sr.height,YELLOW);
end;


procedure DrawWall(shapeid : integer);
var
  sr : ShapeRec;
begin
// GetShapeRec(shapeid,sr);
// DrawRectangleLines(sr.x,sr.y,sr.width,sr.height,BLUE);
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
  Finished:=true;
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
  if (x2+4) < (screenwidth-1) then MovePlayerDelta(Paddle,4,0);
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
 SetShape(Shapeid,Brick,true,true,x*(BrickWidth+4)-20,y*(BrickHeight+2),BrickWidth,BrickHeight,0,0,@DrawBrick);
 AddCollission(Shapeid,2,@BallBrickCollission);
end;

procedure AddBricks;
var
 i,j : integer;
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


begin
 InitShapes;
 Initcollisions;

 SetShape(1,Paddle,true,true,20,screenheight-35,PaddleWidth,PaddleHeight,0,0,@DrawPaddle);
 SetShape(2,Ball,true,true,20,screenheight-50,BallWidth,Ballheight,0,0,@DrawBall);
 SetShape(3,BottomWall,true,true,0,screenheight-11,screenwidth,10,0,0,@DrawWall);
 SetShape(4,TopWall,true,true,0,0,screenwidth-1,10,0,0,@DrawWall);
 SetShape(5,LeftWall,true,true,0,10,10,screenheight-21,0,0,@DrawWall);
 SetShape(6,RightWall,true,true,screenwidth-11,10,10,screenheight-21,0,0,@DrawWall);

 AddCollission(1,2,@BallPaddleCollission);
 AddCollission(2,3,@BallBottomWallCollission);
 AddCollission(2,4,@BallTopWallCollission);
 AddCollission(2,5,@BallLeftWallCollission);
 AddCollission(2,6,@BallRightWallCollission);

 AddBricks;
 HorizDir:=0;
 VirtDir:=0;

begin
 InitWindow(screenWidth, screenHeight, 'Breakit for raylib');
 SetTargetFPS(120);

 PaddleTexture := LoadTexture('images/paddle.png');
 BallTexture := LoadTexture('images/ball.png');
// ToggleFullscreen;
 while not WindowShouldClose() and (Finished=False) do
 begin
   if (IsKeyDown(KEY_Q)) then Finished:=True;
   if (IsKeyDown(KEY_F)) then  ToggleFullscreen;
   if (IsKeyDown(KEY_RIGHT)) then GoRight;
   if (IsKeyDown(KEY_LEFT)) then GoLeft;
   if (IsKeyDown(KEY_SPACE)) then
   begin
     HorizDir:=1;
     VirtDir:=-1;
   end;
   MovePlayerDelta(Ball,HorizDir,VirtDir);
   ProcessCollissions;
   BeginDrawing();
     ClearBackground(BLACK);
     DrawShapes;
   EndDrawing();
  end;
  CloseWindow();
 end;
end.
