// drawimage with canvas as source image Example
// see video for additional info https://youtu.be/gYMzEs_AK3g

Program test;
  uses browserconsole,Web;

var
 canvas : TJSHTMLCanvasElement;
 ctx    : TJSCanvasRenderingContext2D;

 canvas2 : TJSHTMLCanvasElement;
 ctx2    : TJSCanvasRenderingContext2D;

 canvas3 : TJSHTMLCanvasElement;
 ctx3    : TJSCanvasRenderingContext2D;

 canvas4 : TJSHTMLCanvasElement;
 ctx4    : TJSCanvasRenderingContext2D;


Procedure InitCanvas;
begin
  //main canvas
  canvas:=TJSHTMLCanvasElement(document.getElementById('canvas'));
  ctx:=TJSCanvasRenderingContext2D(canvas.getContext('2d'));

  //second canvas
  canvas2:=TJSHTMLCanvasElement(document.getElementById('canvas_2'));
  ctx2:=TJSCanvasRenderingContext2D(canvas2.getContext('2d'));

  //third canvas
  canvas3:=TJSHTMLCanvasElement(document.getElementById('canvas_3'));
  ctx3:=TJSCanvasRenderingContext2D(canvas3.getContext('2d'));

  //fourth canvas
  canvas4:=TJSHTMLCanvasElement(document.getElementById('canvas_4'));
  ctx4:=TJSCanvasRenderingContext2D(canvas4.getContext('2d'));
end;

// https://developer.mozilla.org/en-US/docs/Web/API/Canvas_API
Procedure Draw;
begin
  //main canvas
  ctx.fillstyle:='green';
  ctx.fillRect(0,0,300,300);

  //second canvas
  ctx2.fillstyle:='red';
  ctx2.fillRect(0,0,64,64);
  ctx2.fillstyle:='white';
  ctx2.fillText('Hello World', 5, 35);
  //draw contents of second canvas to main canvas
  ctx.drawimage(canvas2,10,100);
  
  //third canvas
  ctx3.fillstyle:='blue';
  ctx3.fillRect(0,0,64,64);
  ctx3.fillstyle:='white';
  ctx3.fillText('Hello World', 5, 35);
  //draw contents of third canvas to main canvas
  ctx.drawimage(canvas3,100,100);
  
  //fourth canvas
  ctx4.fillstyle:='orange';
  ctx4.fillRect(0,0,64,64);
  ctx4.fillstyle:='white';
  ctx4.fillText('Hello World', 5, 35);
  //draw contents of third canvas to main canvas
  ctx.drawimage(canvas4,190,100);
end;

begin
  InitCanvas;
  //window.onload:=@onLoadDraw;
  Draw;
  writeln('drawImage');
 end.