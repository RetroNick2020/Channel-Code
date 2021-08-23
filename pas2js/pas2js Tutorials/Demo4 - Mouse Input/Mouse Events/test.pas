// Mouse Event Example
// see video for additional info https://youtu.be/TJF-FDJS3U8

Program test;
  uses browserconsole,Web;

var
 canvas : TJSHTMLCanvasElement;
 ctx    : TJSCanvasRenderingContext2D;

// https://developer.mozilla.org/en-US/docs/Web/API/Canvas_API
Procedure InitCanvas;
begin
  canvas:=TJSHTMLCanvasElement(document.getElementById('canvas'));
  ctx:=TJSCanvasRenderingContext2D(canvas.getContext('2d'));
end;

Procedure DrawSomething;
begin
  ctx.fillstyle:='green';
  ctx.fillRect(0,0,300,300);
  ctx.fillstyle:='red';
  ctx.fillRect(100,100,100,100);
end;

function HandleMouseClick(Event: TJSMouseEvent): boolean;
Begin
  writeln('Mouse was clicked in Canvas Area');
  writeln('offsetX =', Event.offsetX);
  writeln('offsetY =', Event.offsetY);
  writeln('x =', Event.x);
  writeln('y =', Event.y);
end;

function HandleMouseMove(Event: TJSMouseEvent): boolean;
Begin
  writeln('Mouse was moved in Canvas Area');
  writeln('offsetX =', Event.offsetX);
  writeln('offsetY =', Event.offsetY);
  writeln('x =', Event.x);
  writeln('y =', Event.y);
end;

// https://developer.mozilla.org/en-US/docs/Web/API/Element/click_event
// https://developer.mozilla.org/en-US/docs/Web/API/Element/mousemove_event

Procedure InitMouseHandler;
begin
  canvas.addEventListener('click',@HandleMouseClick);
  canvas.addEventListener('mousemove',@HandleMouseMove);
end;

begin
  writeln('Mouse Events');
  InitCanvas;
  InitMouseHandler;
  DrawSomething;
end.