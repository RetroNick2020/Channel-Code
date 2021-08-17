// Dynamic Canvas Example
// see video for additional info https://youtu.be/kuU1TTrPTzM
Program test;
  uses browserconsole,Web;

var
 canvas     : TJSHTMLCanvasElement;
 ctx        : TJSCanvasRenderingContext2D;
 divElement : TJSHTMLElement;

// https://developer.mozilla.org/en-US/docs/Web/API/Canvas_API
Procedure drawSomething;
begin
  //create canvas element
  canvas:=TJSHTMLCanvasElement(document.createElement('canvas'));
  canvas.width:=400;
  canvas.height:=400;
  canvas.id:='canvas_2';
  
  divElement:=TJSHTMLElement(document.getElementById('gameboard'));
  //insert canvas element inside gameboard div
  divElement.appendChild(canvas);
  // or insert inside body
  // https://developer.mozilla.org/en-US/docs/Web/API/Node/appendChild
  //document.body.appendChild(canvas);
  
  ctx:=TJSCanvasRenderingContext2D(canvas.getContext('2d'));

  ctx.fillStyle:='red';
  ctx.fillRect(10, 10, 250, 100);
  
  ctx.fillStyle:='blue';
  ctx.font:='48px serif';
  ctx.fillText('Hello world', 20, 80);
end;

begin
  writeln('Draw in Canvas');
  drawSomething;
end.