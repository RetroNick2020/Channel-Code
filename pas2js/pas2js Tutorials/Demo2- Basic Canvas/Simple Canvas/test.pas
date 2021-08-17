// Simple Canvas Example
// see video for additional info https://youtu.be/kuU1TTrPTzM

Program test;
  uses browserconsole,Web;

var
 canvas : TJSHTMLCanvasElement;
 ctx    : TJSCanvasRenderingContext2D;

// https://developer.mozilla.org/en-US/docs/Web/API/Canvas_API
Procedure drawSomething;
begin
  canvas:=TJSHTMLCanvasElement(document.getElementById('canvas_1'));
  ctx:=TJSCanvasRenderingContext2D(canvas.getContext('2d'));
  //canvas.width:=300;
  //canvas.height:=300;

  ctx.fillStyle := 'green';
  ctx.fillRect(10, 10, 150, 100);

  ctx.strokeStyle := 'red';
  ctx.font := '48px serif';
  ctx.strokeText('Hello Nick', 10, 50);

  //ctx.beginPath();
  //ctx.moveTo(75, 50);
  //ctx.lineTo(100, 75);
  //ctx.lineTo(100, 25);
  //ctx.fill();

end;

begin
  writeln('Draw in Canvas');
  drawSomething;
end.