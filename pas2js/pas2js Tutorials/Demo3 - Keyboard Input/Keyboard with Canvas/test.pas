// Keyboard and Canvas Example
// see video for additional info https://youtu.be/rw5y-r0RFq8

Program test;
  uses browserconsole,Web;

var
 canvas : TJSHTMLCanvasElement;
 ctx    : TJSCanvasRenderingContext2D;
 x,y    : integer;

// https://developer.mozilla.org/en-US/docs/Web/API/Canvas_API
Procedure InitCanvas;
begin
  canvas:=TJSHTMLCanvasElement(document.getElementById('canvas'));
  ctx:=TJSCanvasRenderingContext2D(canvas.getContext('2d'));
end;

procedure DrawBox;
begin
  //fill screen with green rectangle that covers entire canvas area
  ctx.fillStyle := 'green';
  ctx.fillRect(0, 0, 300, 300);
  //draw small box at x,y co-ordinates
  ctx.fillStyle := 'red';
  ctx.fillRect(x, y, 30, 30);
end;

// https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent
// https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent/key/Key_Values
function HandleKeyDown(k : TJSKeyBoardEvent) : Boolean;
begin
  if k.key = TJSKeyNames.ArrowLeft then dec(x,5);
  if k.key = TJSKeyNames.ArrowRight then inc(x,5);
  if k.key = TJSKeyNames.ArrowDown then inc(y,5);
  if k.key = TJSKeyNames.ArrowUp then dec(y,5);
  DrawBox;
end;

begin
  x:=100;
  y:=100;
  InitCanvas;
  DrawBox;
  
  writeln('Keyboard and Canvas');
  document.onkeydown:=@HandleKeyDown;
end.