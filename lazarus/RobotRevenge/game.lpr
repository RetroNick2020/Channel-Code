program game;

{$mode objfpc}{$H+}

uses cmem, ray_header,collision,SysUtils, Timer,PathFind;

const
 UpDir = 1;
 DownDir = 2;
 LeftDir = 3;
 RightDir = 4;

 screenWidth = 600;
 screenHeight = 450;

 Player = 1;
 Robot = 2;

 BottomWall = 3;
 TopWall = 4;
 LeftWall = 5;
 RightWall = 6;
 Wall1 = 7;
 Wall2 = 8;

 PlayerWidth = 20;
 Playerheight = 20;

 RobotWidth = 20;
 Robotheight = 20;

 WallWidth = 20;
 WallHeight = 20;

Var
 VirtDir  : integer;
 HorizDir : integer;
 Finished : Boolean;
 Key : integer;

 PlayerTexture :TTexture2D;
 Robot1Texture :TTexture2D;

 Flash_Text : Boolean;

 Last_Dir : integer;
 xstr,ystr : string;

 SQ : SimpleQueue;


procedure DrawPlayer(shapeid : integer);
var
 sr : ShapeRec;
begin
 GetShapeRec(shapeid,sr);
 DrawRectangle(sr.x,sr.y,sr.width,sr.height,GREEN);
end;

procedure DrawRobot(shapeid : integer);
var
  sr : ShapeRec;
begin
 GetShapeRec(shapeid,sr);
 DrawRectangle(sr.x,sr.y,sr.width,sr.height,RED);
end;

procedure DrawWall(shapeid : integer);
var
  sr : ShapeRec;
begin
 GetShapeRec(shapeid,sr);
 DrawRectangle(sr.x,sr.y,sr.width,sr.height,BEIGE);
end;

procedure Collission(ShapeId1,ShapeId2,PlayerId1,PlayerId2 : integer);
begin
end;


procedure BulletWallCollission(ShapeId1,ShapeId2,PlayerId1,PlayerId2 : integer);
begin
end;

procedure PlayerWallCollission(ShapeId1,ShapeId2,PlayerId1,PlayerId2 : integer);
begin
 if Last_Dir = UpDir then MovePlayerDelta(Player,0,4)
 else if Last_Dir = DownDir then MovePlayerDelta(Player,0,-4)
 else if Last_Dir = LeftDir then MovePlayerDelta(Player,4,0)
 else if Last_Dir = RightDir then MovePlayerDelta(Player,-4,0);
end;


Function PixelToGridX(num : integer) : integer;
begin
 PixelToGridX:=num div WallWidth;
end;

Function PixelToGridY(num : integer) : integer;
begin
 PixelToGridY:=num div WallHeight;
end;


Function GridToPixelX(num : integer) : integer;
begin
   GridToPixelX:=num*WallWidth;
end;

Function GridToPixelY(num : integer) : integer;
begin
   GridToPixelY:=num*WallHeight;
end;


Procedure AddWalls;
var
  x,y,w,h : integer;
begin
  ClearGrid;
  x:=2;y:=2;w:=2;h:=6;
  PlaceWallArea(x,y,x+w-1,y+h-1);
  SetShape(7,Wall1,true,true,GridToPixelX(x),GridToPixelY(y),WallWidth*w,WallHeight*h,0,0,@DrawWall);

  x:=6;y:=3;w:=6;h:=2;
  PlaceWallArea(x,y,x+w-1,y+h-1);
  SetShape(8,Wall2,true,true,GridToPixelX(x),GridToPixelY(y),WallWidth*w,WallHeight*h,0,0,@DrawWall);

  x:=13;y:=5;w:=5;h:=4;
  PlaceWallArea(x,y,x+w-1,y+h-1);
  SetShape(9,Wall2,true,true,GridToPixelX(x),GridToPixelY(y),WallWidth*w,WallHeight*h,0,0,@DrawWall);

  x:=13;y:=11;w:=5;h:=4;
  PlaceWallArea(x,y,x+w-1,y+h-1);
  SetShape(10,Wall2,true,true,GridToPixelX(x),GridToPixelY(y),WallWidth*w,WallHeight*h,0,0,@DrawWall);

  x:=6;y:=10;w:=6;h:=8;
  PlaceWallArea(x,y,x+w-1,y+h-1);
  SetShape(11,Wall2,true,true,GridToPixelX(x),GridToPixelY(y),WallWidth*w,WallHeight*h,0,0,@DrawWall);

  x:=20;y:=3;w:=8;h:=13;
  PlaceWallArea(x,y,x+w-1,y+h-1);
  SetShape(12,Wall2,true,true,GridToPixelX(x),GridToPixelY(y),WallWidth*w,WallHeight*h,0,0,@DrawWall);


end;

Procedure UpdatePlayerOnGrid;
var
 sr : ShapeRec;
 msr : ShapeRec;
begin
 GetShapeRec(1,sr);
 GetShapeRec(2,msr);
 xstr:=IntToStr(PixelToGridX(sr.x));
 ystr:=IntToStr(PixelToGridX(sr.y));

 ClearGridLeaveWalls;
 PlacePlayer(PixelToGridX(sr.x),PixelToGridY(sr.y));
 PlaceMonster(PixelToGridX(msr.x),PixelToGridY(msr.y));
 CreatePathGridStart(PixelToGridX(sr.x),PixelToGridY(sr.y));
 SQ.Init;
 FindPointPath(PixelToGridX(msr.x),PixelToGridY(msr.y),FindDirectionFromMonster(PixelToGridX(msr.x),PixelToGridY(msr.y)),SQ);
end;

Procedure DrawPaths;
var
 i  : integer;
 qr : QueueRec;
begin
  for i:=1 to SQ.Count do
  begin
    SQ.Get(i,qr);
    DrawRectangle(qr.x*WallWidth,qr.y*WallHeight,Wallwidth,WallHeight,YELLOW);
  end;
end;

Procedure GoRight;
var
 x,y,x2,y2 : integer;
begin
  GetCoords(1,x,y,x2,y2);
  if (x2+4) < (screenwidth-1) then MovePlayerDelta(Player,4,0);
  Last_Dir:=RightDir;
end;

Procedure GoLeft;
var
 x,y,x2,y2 : integer;
begin
  GetCoords(1,x,y,x2,y2);
  if (x-4) > -1 then MovePlayerDelta(Player,-4,0);
  Last_Dir:=LeftDir;
end;

Procedure GoUp;
var
 x,y,x2,y2 : integer;
begin
  GetCoords(1,x,y,x2,y2);
  if (y-4) > -1 then MovePlayerDelta(Player,0,-4);
  Last_Dir:=UpDir;
end;

Procedure GoDown;
var
 x,y,x2,y2 : integer;
begin
  GetCoords(1,x,y,x2,y2);
  if (y2+4) < (screenHeight-4) then MovePlayerDelta(Player,0,4);
  Last_Dir:=DownDir;
end;

procedure DisplayText;
begin
  if Flash_Text then DrawText(PChar(xstr+' '+ystr), 10, 0, 20,WHITE);
end;

procedure FlashText(timerid : integer);
begin
   Flash_Text:=NOT Flash_Text;
end;



begin
 InitShapes;
 Initcollisions;

 SetShape(1,Player,true,true,8*WallWidth,8*WallHeight,PlayerWidth,PlayerHeight,0,0,@DrawPlayer);
 SetShape(2,Robot,true,true,280,40,RobotWidth,Robotheight,0,0,@DrawRobot);
 SetShape(3,BottomWall,true,true,0,screenheight-11,screenwidth,10,0,0,@DrawWall);
 SetShape(4,TopWall,true,true,0,0,screenwidth-1,10,0,0,@DrawWall);
 SetShape(5,LeftWall,true,true,0,10,10,screenheight-21,0,0,@DrawWall);
 SetShape(6,RightWall,true,true,screenwidth-11,10,10,screenheight-21,0,0,@DrawWall);

 AddWalls;

 AddCollission(1,7,@PlayerWallCollission);
 AddCollission(1,8,@PlayerWallCollission);
 AddCollission(1,9,@PlayerWallCollission);
 AddCollission(1,10,@PlayerWallCollission);
 AddCollission(1,11,@PlayerWallCollission);
 AddCollission(1,12,@PlayerWallCollission);


 HorizDir:=0;
 VirtDir:=0;
 Flash_Text:=false;

 InitTimers;
 SetTimer(1,true,false,true,0.2,@FlashText);

begin
 InitWindow(screenWidth, screenHeight, 'Robot Revenge on Raylib');
 SetTargetFPS(120);

 while not WindowShouldClose() and (Finished=False) do
 begin
   if (IsKeyDown(KEY_Q)) then Finished:=True;
   if (IsKeyDown(KEY_F)) then  ToggleFullscreen;

   if (IsKeyDown(KEY_RIGHT)) then GoRight
   else if (IsKeyDown(KEY_LEFT)) then GoLeft
   else if (IsKeyDown(KEY_UP)) then GoUp
   else if (IsKeyDown(KEY_DOWN)) then GoDown;

   UpdatePlayerOnGrid;
   ProcessTimers;
   ProcessCollissions;

   BeginDrawing();
     ClearBackground(BLUE);
     DrawShapes;
     DrawPaths;
     DisplayText;
   EndDrawing();
  end;
  CloseWindow();
 end;
end.
