{$mode objfpc}
Program Game;
  uses JS,Web,invader,player,bullets,assets;

var
 myInvader  : TInvader;

 canvas     : TJSHTMLCanvasElement;
 ctx        : TJSCanvasRenderingContext2D;
 canvas2    : TJSHTMLCanvasElement;
 ctx2       : TJSCanvasRenderingContext2D;
 divElement : TJSHTMLElement;


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
  myInvader:=TInvader.Create;
  myInvader.myPlayer.setRenderCTX(ctx2);
  myInvader.setRenderCTX(ctx2);
  myInvader.UpdateEnemyRenderCTX;
  myInvader.myBullet.setRenderCTX(ctx2);
end;

procedure Update(aTime: TJSDOMHighResTimeStamp);
begin
  myInvader.update(aTime);
end;

procedure Draw;
begin
  canvas2.style['backgroundColor']:='black';
  ctx2.clearRect(0, 0, canvas2.width,canvas2.height);
  myinvader.draw;  //draws in canvas2

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

// https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent
// https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent/key/Key_Values
function HandleKeyDown(k : TJSKeyBoardEvent) : Boolean;
begin
  if k.key = TJSKeyNames.ArrowRight then myInvader.myPlayer.SetDirection(1);
  if k.key = TJSKeyNames.ArrowLeft then myInvader.myPlayer.SetDirection(-1);

  if (k.key = 'f') or (k.key = 'F') then  myInvader.myBullet.fire(myInvader.myPlayer.getx+7,170);
  if (k.key = 'F11') then canvas.requestFullscreen;
end;

function HandleKeyUp(k : TJSKeyBoardEvent) : Boolean;
begin
  if (k.key = TJSKeyNames.ArrowRight) or (k.key = TJSKeyNames.ArrowLeft) then myInvader.myPlayer.SetDirection(0);
end;

begin
  window.onkeydown:=@HandleKeyDown;
  window.onkeyup:=@HandleKeyUp;
  window.onresize:=@onResize;
  window.onLoad:=@onLoad;
 end.