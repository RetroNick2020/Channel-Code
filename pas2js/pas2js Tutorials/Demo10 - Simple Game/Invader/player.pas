unit player;

Interface
 uses web,assets;
type
 TPlayer = class
           x : integer;
           y : integer;
           playerdir : integer;
           renderctx        : TJSCanvasRenderingContext2D;
          // renderimg        : TJSHTMLImageElement; 
           constructor create;
           procedure setRenderCTX(var ctx : TJSCanvasRenderingContext2D);
          // procedure setRenderImg(var Img : TJSHTMLImageElement);
           procedure MoveTo(nx,ny : integer);
           procedure MoveDelta(xdelta : integer);
           procedure SetDirection(dir : integer);
           procedure Draw;
           procedure Update;
           function getx : integer;
           function gety : integer;           
 end;

Implementation

constructor TPlayer.create;
begin
  x:=100;
  y:=170;  
  playerdir:=0;
end;

procedure TPlayer.setRenderCTX(var ctx : TJSCanvasRenderingContext2D);
begin
  renderctx:=ctx;
end;

procedure TPlayer.SetDirection(dir : integer);
begin
 playerdir:=dir;
end;

(*
procedure TPlayer.setRenderImg(var Img : TJSHTMLImageElement);
begin
  renderImg:=Img;
end;
*)

procedure TPlayer.MoveTo(nx,ny : integer);
begin
  x:=nx;
  y:=ny;
end;

procedure TPlayer.MoveDelta(xdelta : integer);
begin
  x:=x+xdelta;
end;

procedure TPlayer.Draw;
begin
  renderCTX.drawimage(ShipImage,x,y,16,16);
end;

procedure TPlayer.Update;
begin
  if playerdir < 0 then
  begin
   MoveDelta(-2);
  end
  else if playerdir > 0 then
  begin
   MoveDelta(2); 
  end;
end;


function TPlayer.getx : integer;
begin
  getx:=x;
end;
  
function TPlayer.gety : integer;
begin
  gety:=y;
end;

begin
end.