// get/put onload callback Example. 
// see video for additional info https://youtu.be/79lTMzS3qtM

Program test;
  uses browserconsole,Web;

var
 canvas : TJSHTMLCanvasElement;
 ctx    : TJSCanvasRenderingContext2D;

 myImageData : TJSImageData;

// https://developer.mozilla.org/en-US/docs/Web/API/Canvas_API
Procedure InitCanvas;
begin
  canvas:=TJSHTMLCanvasElement(document.getElementById('canvas'));
  ctx:=TJSCanvasRenderingContext2D(canvas.getContext('2d'));
end;

// https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/putImageData
// https://developer.mozilla.org/en-US/docs/Web/API/ImageData
// https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/getImageData
Procedure Draw;
var
  i : integer;
begin
  ctx.fillstyle:='green';
  ctx.fillRect(0,0,300,300);

  ctx.fillstyle:='red';
  ctx.fillRect(0,0,64,64);
  ctx.fillstyle:='white';
  ctx.fillText('Hello World', 5, 35);
  
  //Allocate the imagedata structure
  myImageData := TJSImageData.new(64,64);  //width and height of image area
  myImageData:=ctx.getImageData(0,0,64,64);
  ctx.putImageData(myImageData, 10, 100);
  
  //manipulate the data by accessing the internal memory sturcture of bitmap
  for i:=0 to (64*4*64-1) do
  begin
    myImageData.data[i]:=128 and myImageData.data[i];
  end;  
  ctx.putImageData(myImageData, 100, 100);
end;

function onLoadDraw(Event: TEventListenerEvent): boolean;
Begin
 Draw;
end;

begin
  //window.onload:=@onLoadDraw;
  InitCanvas;
  Draw;
  writeln('get put imagedata');
end.