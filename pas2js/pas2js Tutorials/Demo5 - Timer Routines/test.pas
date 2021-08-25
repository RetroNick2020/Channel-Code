// Timer Example
// see video for additional info https://youtu.be/Vzh5zq9O5M8

Program test;
  uses browserconsole,Web;

var
 canvas : TJSHTMLCanvasElement;
 ctx    : TJSCanvasRenderingContext2D;

 timer1_id  : NativeInt;
 timer2_id  : NativeInt;
 timer3_id  : NativeInt;
 
 box1_y     : integer;
 box2_y     : integer;

// https://developer.mozilla.org/en-US/docs/Web/API/Canvas_API
Procedure InitCanvas;
begin
  canvas:=TJSHTMLCanvasElement(document.getElementById('canvas'));
  ctx:=TJSCanvasRenderingContext2D(canvas.getContext('2d'));
end;

Procedure InitBoxLocations;
begin
 box1_y:=0;
 box2_y:=0;
end;

Procedure MoveBox1;
begin
  inc(box1_y,5);
end;

Procedure MoveBox2;
begin
  inc(box2_y,5);
end;

Procedure StopBoxes;
begin
  writeln('Stop Boxes');
  //clear timers for moving the boxes
  window.clearInterval(timer1_id);
  window.clearInterval(timer2_id);
  //stop calling the DrawBoxes routine
  window.clearInterval(timer3_id);
end;

Procedure DrawBoxes;
begin
  ctx.fillstyle:='green';
  ctx.fillRect(0,0,300,300);

  ctx.fillstyle:='red';
  ctx.fillRect(100,box1_y,20,20);

  ctx.fillstyle:='white';
  ctx.fillRect(150,box2_y,20,20);
end;

begin
  writeln('Timer Events');
  InitBoxLocations;
  InitCanvas;
 
  timer1_id:=window.setInterval(@MoveBox1,500); 
  timer2_id:=window.setInterval(@MoveBox2,400);
  timer3_id:=window.setInterval(@DrawBoxes,300);
 
  window.setTimeout(@stopboxes,20000); //only executes once after 20s - NOT every 20s
end.