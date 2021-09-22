// Mouse Cursors with canvas 
// see video for additional info https://youtu.be/N24Uq90LN0Q

Program test;
  uses browserconsole,Web;

var
 canvas : TJSHTMLCanvasElement;
 ctx    : TJSCanvasRenderingContext2D;

Procedure InitCanvas;
begin
  canvas:=TJSHTMLCanvasElement(document.getElementById('canvas'));
  ctx:=TJSCanvasRenderingContext2D(canvas.getContext('2d'));

  ctx.fillstyle:='green';
  ctx.fillRect(0,0,800,600);
end;

procedure LoadDrawImage(x,y : integer;ctx : TJSCanvasRenderingContext2D; url : string);
var
  myImage : TJSHTMLImageElement;

  function onload(Event: TEventListenerEvent): boolean;
  begin
    ctx.drawImage(myImage,x,y);
  end;

begin
  myImage:=TJSHTMLImageElement.New;
  myImage.src:=url;
  myImage.onload:=@onload;
end;

// https://developer.mozilla.org/en-US/docs/Web/CSS/cursor
procedure ChangeMouseCursor;
begin
  // builtin
  // canvas.style['cursor']:='crosshair';
 //  canvas.style['cursor']:='pointer';

  // png files
  // canvas.style.setproperty('cursor','url("mouse.png"), auto');
  //  canvas.style['cursor']:='url("mouse2.png"), auto';
  
  // cur files
  canvas.style['cursor']:='url("arrow.cur"), auto';
end;

Procedure DrawSomething;
begin
  LoadDrawImage(10,10,ctx,'invader.png')
end;

begin
  InitCanvas;
  DrawSomething;
  ChangeMouseCursor;
  //window.onload:=@onLoadDraw;
  
 end.