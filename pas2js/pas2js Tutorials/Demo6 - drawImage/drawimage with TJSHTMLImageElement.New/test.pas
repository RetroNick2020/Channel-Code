// drawImage with TJSHTMLImageElement.New and loading image with 
// onload callback Example. see video for additional info https://youtu.be/gYMzEs_AK3g

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

procedure LoadDrawImage(x,y : integer;ctx : TJSCanvasRenderingContext2D; url : string);
var
  myImage : TJSHTMLImageElement;

  function onload(Event: TEventListenerEvent): boolean;
  begin
    //writeln('before draw');
    ctx.drawImage(myImage,x,y);
  end;

begin
  //writeln('before new');
  myImage:=TJSHTMLImageElement.New;
  myImage.src:=url;
  //writeln(myImg.src);
  myImage.onload:=@onload;
end;


Procedure Draw;
begin
  ctx.fillstyle:='green';
  ctx.fillRect(0,0,300,300);

  LoadDrawImage(10,10,ctx,'myImage.png');
  LoadDrawImage(80,80,ctx,'myImage2.png');
end;

function onLoadDraw(Event: TEventListenerEvent): boolean;
Begin
 Draw;
end;

begin
 // window.onload:=@onLoadDraw;
  InitCanvas;
  Draw;
  writeln('drawImage');
end.