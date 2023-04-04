unit board;

Interface
 uses web,assets,c4core,findrows;
type
 TBoard = class
           DropColumn : integer;
           PlayerTurn : integer; 
           DropMode   : boolean;
           DropPosY   : integer;
           DropEndY   : integer;
           DropSteps  : integer;
           DropCount  : integer;
           ComputerDropColumn : integer;
           timer : TJSDOMHighResTimeStamp;
           GameOver   : Boolean;
           renderctx        : TJSCanvasRenderingContext2D;

           constructor create;
           procedure Init;
           procedure NewGame;

 
           procedure DrawBoard;
           procedure DrawPosition;
           procedure DrawFalling;
           procedure MovedropPiece(dir : integer);

           procedure setRenderCTX(var ctx : TJSCanvasRenderingContext2D);
           procedure Draw;
           procedure Update(aTime: TJSDOMHighResTimeStamp);

           procedure DropPiece;
           procedure MovePiece;
           procedure DumpRowInfo;
           function isGameOver : boolean;
 end;

Implementation

constructor TBoard.create;
begin
  Init;
end;

procedure TBoard.Init;
begin
  DropColumn:=4;
  ComputerDropColumn:=0;
  PlayerTurn:=RED;
  DropMode:=false;
  DropCount:=0;
  timer:=0;
  GameOver:=false;
  init_board;
end;

procedure TBoard.NewGame;
begin
  Init;
end; 

function TBoard.isGameOver : boolean;
begin
  isGameOver:=GameOver;
end;

procedure TBoard.setRenderCTX(var ctx : TJSCanvasRenderingContext2D);
begin
  renderctx:=ctx;
end;

procedure TBoard.MovedropPiece(dir : integer);
begin
  if DropMode then exit; //we don't want to be moving piece while falling
  inc(DropColumn,dir);
  if DropColumn < 1 then DropColumn:=1;
  if DropColumn > 7 then DropColumn:=7;
end;

procedure TBoard.DrawBoard;
var c, r: integer;
begin
    for r := 1 to 6 do
    begin
       for c := 1 to 7 do
       begin
           case get_game_piece(c,r) of
               RED:renderCTX.drawimage(RedImage,c*29,r*27,32,32);
               YELLOW:renderCTX.drawimage(YellowImage,c*29,r*27,32,32);
           end;
           renderCTX.drawimage(BlueImage,c*29,r*27,32,32); 
       end;
   end;
   renderCTX.drawimage(c4NameImage,8*29+4,1*27+20);
end;

procedure TBoard.DrawFalling;
begin
  if PlayerTurn = RED then
  begin
     renderCTX.drawimage(RedImage,DropColumn*29,DropPosY,32,32);
  end   
  else
  begin
     renderCTX.drawimage(YellowImage,DropColumn*29,DropPosY,32,32);
  end;
end;

procedure TBoard.DrawPosition;
begin
  if PlayerTurn = RED then
  begin
     renderCTX.drawimage(RedImage,DropColumn*29,0,32,32);
  end   
  else
  begin
     renderCTX.drawimage(YellowImage,DropColumn*29,0,32,32);
  end;
end;

procedure TBoard.Draw;
begin
  if DropMode then DrawFalling else DrawPosition;
  DrawBoard;
end;

procedure TBoard.Update(aTime: TJSDOMHighResTimeStamp);
begin
  if aTime > (timer+10)  then
  begin
    timer:=aTime;
    MovePiece;
  end;  
end;

procedure TBoard.DropPiece;
begin
 if GameOver then exit;
 if DropMode then exit;
 DropMode:=true;
 DropPosY:=0;
 DropEndY:=(get_drop_row(DropColumn))*27;
 DropSteps:=1;
 DropCount:=0;
end;  

procedure TBoard.MovePiece;
begin
 // if GameOver then exit;
  if DropMode then
  begin
    inc(DropPosY,DropSteps);
    if (DropPosY >= DropEndY) then  //drop peice has reached drop location
    begin
       if PlayerTurn = RED then
       begin       
         Drop_Piece(DropColumn,RED);
         inc(DropCount);
         DropPosY:=0;
         if is_connect_four(DropColumn) = false then
         begin
           //red did not win - choose drop column - but don't drop
           PlayerTurn:=YELLOW;
           DropColumn:=do_computer_move (YELLOW);
           //writeln(dropcolumn,' ',get_drop_row(DropColumn));
           DropEndY:=(get_drop_row(DropColumn))*27;
         end
         else
         begin
           //writeln('Game Over');
           GameOver:=true;
           DropMode:=false;
         end;  
       end
       else if PlayerTurn = YELLOW then
       begin
         //drop piece reached drop location now - drop the piece - check for win
         Drop_Piece(DropColumn,YELLOW);
         inc(DropCount);
         DropPosY:=0;
         if is_connect_four(DropColumn) = false then
         begin
           PlayerTurn:=RED;
         end
         else
         begin
           //writeln('Game Over');
           GameOver:=true;
           DropMode:=false;
         end;  
       end;

       if DropCount = 2 then 
       begin
         DropMode:=false;
         DropCount:=0;
       end;  

    end;   
  end;
end;

//for debug only
procedure TBoard.DumpRowInfo;
var
 rowcount : integer;
  apoints : aitempoints;
  i : integer;
begin
  rowcount:=FindRowOfColors(apoints,4);
  for i:=0 to rowcount-1 do
  begin
    with apoints[i] do
    begin
  //    writeln('x=',x,' y=',y,' stepx=',stepx,' stepy=',stepy,' item=',item,' count=',count);
    end;  
  end;
end;

begin
end.