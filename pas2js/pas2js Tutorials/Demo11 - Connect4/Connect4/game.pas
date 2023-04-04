{
Connect 4 - Copyright (C) 1999  Andrew Clausen
Original code for Turbo Pascal can be found here
https://github.com/RetroNick2020/pascal_connect4

Ported to Pas2JS by RetroNick April 3 - 2023
Removed direct screen writes and some other code rendered useless by logic changes

This program is free software.  It is released under the terms of the
GNU General Public Licence as published by the Free Software Foundation, Inc.
which can be obtained from www.gnu.org.

This program comes with ABSOLUTELY NO WARRANTY, not even an implied
warranty of merchantability, or fitness for a particular purpose.
}

{$mode objfpc}
Program Game;
  uses JS,Web,assets,board,rowblink;

var
 canvas     : TJSHTMLCanvasElement;
 ctx        : TJSCanvasRenderingContext2D;
 canvas2    : TJSHTMLCanvasElement;
 ctx2       : TJSCanvasRenderingContext2D;
 divElement : TJSHTMLElement;

 myBoard      : TBoard;
 myRowBlink   : TRowBlink;

Procedure InitCanvasPixelProperties;
begin
  ctx:=TJSCanvasRenderingContext2D(canvas.getContext('2d'));
  ctx.imageSmoothingEnabled :=false;
  canvas.style['image-rendering']:='pixelated';
  ctx2:=TJSCanvasRenderingContext2D(canvas2.getContext('2d'));
  ctx2.imageSmoothingEnabled :=false;
  canvas2.style['image-rendering']:='pixelated';
end;

// https://developer.mozilla.org/en-US/docs/Web/API/Canvas_API
Procedure InitCanvas;
begin
  //create main canvas element
  canvas:=TJSHTMLCanvasElement(document.createElement('canvas'));
  canvas.width:=window.innerWidth-20;
  canvas.height:=window.innerHeight-20;
  canvas.id:='canvas';

   //create hidden canvas element
  canvas2:=TJSHTMLCanvasElement(document.createElement('canvas'));
  canvas2.width:=320;
  canvas2.height:=200;
  //canvas2.hidden:=true;
  canvas2.id:='canvas2';

  InitCanvasPixelProperties;

  divElement:=TJSHTMLElement(document.getElementById('gameboard'));
  divElement.appendChild(canvas);
  
  //create main game class and pass rendering info
  myBoard:=TBoard.Create;
  myBoard.setRenderCTX(ctx2);

  myRowBlink:=TRowBlink.Create;
  myRowBlink.setRenderCTX(ctx2);

end;

procedure Update(aTime: TJSDOMHighResTimeStamp);
begin
  myBoard.Update(aTime);
  if myBoard.isGameOver then myRowBlink.Update(aTime);
end;

procedure Draw;
begin
  //draws in canvas2
  canvas2.style['backgroundColor']:='black';
  ctx2.clearRect(0, 0, canvas2.width,canvas2.height);
  myBoard.Draw;
  if myBoard.isGameOver then myRowBlink.Draw;

  //clear main canvas and blit canvas2 to main canvas
  canvas.style['backgroundColor']:='black';
  ctx.clearrect(0,0,canvas.width,canvas.height);
  ctx.drawimage(canvas2,0,0,canvas.width,canvas.height);
end;

procedure main_loop(aTime: TJSDOMHighResTimeStamp);
begin
  Update(atime);
  Draw;
  Window.requestAnimationFrame(@main_loop);
end;

procedure start_main_loop;
begin
  Window.requestAnimationFrame(@main_loop);
end;

function onLoad(aEvent: TEventListenerEvent): boolean;
begin
  LoadResources('game-res.html');
  InitCanvas;
  start_main_loop;
end;

function onResize(aEvent : TJSUIEvent) : Boolean; 
begin
  canvas.width:=window.innerWidth-20;
  canvas.height:=window.innerHeight-20;
  InitCanvasPixelProperties;
  Draw;
end;

Procedure NewGame;
begin
  myRowBlink.ClearRowList;
  myBoard.NewGame;
end;

// https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent
// https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent/key/Key_Values
function HandleKeyDown(k : TJSKeyBoardEvent) : Boolean;
begin
  if k.key = TJSKeyNames.ArrowRight then myBoard.MovedropPiece(1);
  if k.key = TJSKeyNames.ArrowLeft then myBoard.MovedropPiece(-1);
  if k.key = TJSKeyNames.ArrowDown then myBoard.DropPiece;
  if (k.code = 'KeyN') then NewGame;
  if (k.code = 'KeyQ') or (k.code = 'KeyX') then 
  begin
    window.open('https://github.com/RetroNick2020','_self');
  end;
  if (k.key = 'F11') then canvas.requestFullscreen;
end;

begin
  window.onkeydown:=@HandleKeyDown;
  window.onresize:=@onResize;
  window.onLoad:=@onLoad;
 end.