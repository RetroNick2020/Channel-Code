// drawimage with img html tag and windows.onload Example
// see video for additional info https://youtu.be/gYMzEs_AK3g

Program test;
  uses browserconsole,Web;

var
 canvas : TJSHTMLCanvasElement;
 ctx    : TJSCanvasRenderingContext2D;

 myImage : TJSHTMLImageElement;

// https://developer.mozilla.org/en-US/docs/Web/API/Canvas_API
Procedure InitCanvas;
begin
  canvas:=TJSHTMLCanvasElement(document.getElementById('canvas'));
  ctx:=TJSCanvasRenderingContext2D(canvas.getContext('2d'));
end;

Procedure Draw;
begin
  ctx.fillstyle:='green';
  ctx.fillRect(0,0,300,300);

  myImage:=TJSHTMLImageElement(document.getElementById('myImage_id'));
  ctx.drawImage(myImage,100,100);
 end;

function onLoadImageDraw(Event: TEventListenerEvent): boolean;
Begin
  writeln('all images loaded!');
  Draw;
end;

begin
  InitCanvas;
  writeln('drawImage');
  //draw;
  window.onload:=@onLoadImageDraw;
end.