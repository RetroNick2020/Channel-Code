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
 LastRobotDir : integer;
 NewRobotDir : integer;
 pxstr,pystr : string;
 mxstr,mystr : string;
 SQ : SimpleQueue;
 PauseGame : Boolean;

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


procedure DisplayPathNumbers;
var i,j : integer;
begin
 for j:=0 to Max_Grid_Y do
 begin
   for i:=0 to Max_Grid_x do
   begin
     DrawText(PChar(IntToStr(GetGridDir(i,j))), i*WallWidth, j*WallHeight, 20,WHITE);

   end;
 end;
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
 gx,gy : integer;
 dx : integer;
begin
  GetCoords(1,x,y,x2,y2);
  dx:=4;
  if (x2+dx) < (screenwidth-1) then
  begin
    gx:=PixelToGridX(x+dx);
    gy:=PixelToGridY(y);
    if GetGridDir(gx,gy)<>G_Wall then
    begin
      MovePlayerDelta(Player,dx,0);
      Last_Dir:=RightDir;
    end;
  end;
end;

Procedure GoLeft;
var
 x,y,x2,y2 : integer;
 gx,gy : integer;
 dx : integer;
begin
  GetCoords(1,x,y,x2,y2);
  dx:=-4;
  if (x+dx) > -1 then
  begin
    gx:=PixelToGridX(x+dx);
    gy:=PixelToGridY(y);
    if GetGridDir(gx,gy)<>G_Wall then
    begin
      MovePlayerDelta(Player,dx,0);
      Last_Dir:=LeftDir;
    end;
  end;
end;

Procedure GoUp;
var
 x,y,x2,y2 : integer;
 gx,gy : integer;
 dy : integer;
begin
  GetCoords(1,x,y,x2,y2);
  dy:=-4;
  if (y+dy) > -1 then
  begin
    gx:=PixelToGridX(x);
    gy:=PixelToGridY(y+dy);
    if GetGridDir(gx,gy)<>G_Wall then
    begin
      MovePlayerDelta(Player,0,dy);
      Last_Dir:=UpDir;
    end;
  end;
end;

Procedure GoDown;
var
 x,y,x2,y2 : integer;
 gx,gy : integer;
 dy : integer;
 begin
  GetCoords(1,x,y,x2,y2);
  dy:=4;
  if (y2+dy) < (screenHeight-4) then
  begin
    gx:=PixelToGridX(x);
    gy:=PixelToGridY(y+dy);
    if GetGridDir(gx,gy)<>G_Wall then
    begin
      MovePlayerDelta(Player,0,dy);
      Last_Dir:=DownDir;
    end;
  end;
end;

procedure DisplayText;
begin
  if Flash_Text then DrawText(PChar(pxstr+' '+pystr+' - '+mxstr+' '+mystr+'['+IntToStr(LastRobotDir)+']'), 10, 0, 20,WHITE);
end;

procedure FlashText(timerid : integer);
begin
   Flash_Text:=NOT Flash_Text;
end;

Procedure UpdatePlayerAndRobotOnGrid;
var
 sr : ShapeRec;
 msr : ShapeRec;
begin
 GetShapeRec(1,sr);
 GetShapeRec(2,msr);
 pxstr:=IntToStr(PixelToGridX(sr.x));
 pystr:=IntToStr(PixelToGridX(sr.y));
 mxstr:=IntToStr(PixelToGridX(msr.x));
 mystr:=IntToStr(PixelToGridX(msr.y));

 ClearGridLeaveWalls;
 PlacePlayer(PixelToGridX(sr.x),PixelToGridY(sr.y));
 PlaceEnemy(PixelToGridX(msr.x),PixelToGridY(msr.y));
 CreatePathGridStart(PixelToGridX(sr.x),PixelToGridY(sr.y));
 SQ.Init;
 LastRobotDir:=FindDirectionFromEnemy(PixelToGridX(msr.x),PixelToGridY(msr.y));
 FindPointPath(PixelToGridX(msr.x),PixelToGridY(msr.y),LastRobotDir,SQ);
end;

procedure MoveRobot(timerid : integer);
var
 x,y,x2,y2 : integer;
 deltax,deltay : integer;
 gridx,gridy : integer;
 rx,ry : integer;
begin
  GetCoords(2,x,y,x2,y2);
  gridx:=PixelToGridX(x);
  gridy:=PixelToGridY(y);

  deltax:=0;
  deltay:=0;
  If NewRobotDir = 0 then
  begin
    NewRobotDir:=FindDirectionFromEnemy(gridx,gridy);
  end;

  if NewRobotDir=G_Left then
  begin
    if (gridx > 0) and (GetGridDir(gridx-1,gridy) <> G_Wall) then deltax:=-4 else NewRobotDir:=G_Right;
  end;

  if NewRobotDir=G_Right then
  begin
    if (gridx < Max_Grid_X) and (GetGridDir(gridx+1,gridy) <> G_Wall) then deltax:=4 else NewRobotDir:=G_UP;
  end;

  if NewRobotDir=G_Up then
  begin
    if (gridy > 0) and (GetGridDir(gridx,gridy-1) <> G_Wall) then deltay:=-4 else NewRobotDir:=G_Down;
  end;

  if NewRobotDir=G_Down then
  begin
    if (gridy < Max_Grid_Y) and (GetGridDir(gridx,gridy+1) <> G_Wall) then deltay:=4;
  end;
  rx:=PixelToGridX(x+deltax);
  ry:=PixelToGridY(y+deltay);
  if (rx<>gridx) or (ry<>gridy) then
  begin
    if (GetGridDir(rx,ry) <> G_Wall) then
    begin
      if (rx<>gridx) then
        MovePlayer(Robot,rx*wallwidth,y)
      else
       MovePlayer(Robot,x,ry*wallheight);
       UpdatePlayerAndrobotOnGrid;
       NewRobotDir:=LastRobotDir;
    end;
  end
  else
  begin
    if (GetGridDir(rx,ry) <> G_Wall) then
    begin
      MovePlayerDelta(Robot,deltax,deltay);
      UpdatePlayerAndRobotOnGrid;
      NewRobotDir:=LastRobotDir;
    end;
  end;
end;



begin
 InitShapes;
 Initcollisions;

 SetShape(1,Player,true,true,8*WallWidth,8*WallHeight,PlayerWidth,PlayerHeight,0,0,@DrawPlayer);
 SetShape(2,Robot,true,true,18*WallWidth,8*WallHeight,RobotWidth,Robotheight,0,0,@DrawRobot);
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
 LastRobotDir:=0;
 NewRobotDir:=0;

 InitTimers;
 SetTimer(1,true,false,true,0.2,@FlashText);
 SetTimer(2,true,false,true,0.03,@MoveRobot);


begin
 InitWindow(screenWidth, screenHeight, 'Robot Revenge 2 on Raylib');

 SetTargetFPS(120);
 Finished:=false;
 PauseGame:=false;

 while not WindowShouldClose() and (Finished=False) do
 begin
   if (IsKeyDown(KEY_Q)) then Finished:=True;
   if (IsKeyDown(KEY_F)) then  ToggleFullscreen;
   if (IsKeyDown(KEY_P)) then
   begin
     PauseGame:=true;
   end;
   if (IsKeyDown(KEY_SPACE)) then
   begin
     PauseGame:=false;
   end;

   if (IsKeyDown(KEY_RIGHT)) then GoRight
   else if (IsKeyDown(KEY_LEFT)) then GoLeft
   else if (IsKeyDown(KEY_UP)) then GoUp
   else if (IsKeyDown(KEY_DOWN)) then GoDown;

   if PauseGame = false then
   begin
     ProcessTimers;
     ProcessCollissions;
     UpdatePlayerAndRobotOnGrid;
   end;
   BeginDrawing();
     ClearBackground(BLUE);
     DrawShapes;
     //DrawPaths;
     //DisplayPathNumbers;
     //DisplayText;
   EndDrawing();
  end;
  CloseWindow();
 end;
end.
