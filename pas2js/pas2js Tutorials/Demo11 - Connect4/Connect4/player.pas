unit player;

Interface
 uses web,assets;
type
 TPlayer = class
           x : integer;
           y : integer;
           xdir,ydir : integer;
           xstep,ystep : integer;
           xstart,ystart,xend,yend : integer;
           movestatus : boolean;

           renderctx        : TJSCanvasRenderingContext2D;
          // renderimg        : TJSHTMLImageElement; 
           constructor create;
           procedure setRenderCTX(var ctx : TJSCanvasRenderingContext2D);
          // procedure setRenderImg(var Img : TJSHTMLImageElement);
           procedure MoveTo(nx,ny : integer);
           procedure MoveDelta(nxdelta,nydelta : integer);
           procedure SetDirection(nxdir,nydir : integer);
           procedure SetSteps(nxstep,nystep : integer);
           procedure SetPath(nxstart,nystart,nxend,nyend : integer);
           procedure SetMoveStatus(nstatus : boolean);
           procedure StartMove;
           procedure StopMove;
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
end;

procedure TPlayer.setRenderCTX(var ctx : TJSCanvasRenderingContext2D);
begin
  renderctx:=ctx;
end;

procedure TPlayer.SetDirection(nxdir,nydir : integer);
begin
 xdir:=nxdir;
 ydir:=nydir;
end;

procedure TPlayer.SetSteps(nxstep,nystep : integer);
begin
end;

procedure TPlayer.SetPath(nxstart,nystart,nxend,nyend : integer);
begin
end;

procedure TPlayer.SetMoveStatus(nstatus : boolean);
begin
end;

procedure TPlayer.StartMove;
begin
end;

procedure TPlayer.StopMove;
begin
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

procedure TPlayer.MoveDelta(nxdelta,nydelta : integer);
begin
  x:=x+nxdelta;
  y:=y+nydelta;
end;

procedure TPlayer.Draw;
begin
  renderCTX.drawimage(ShipImage,x,y,16,16);
end;

procedure TPlayer.Update;
begin
  (*
  if playerdir < 0 then
  begin
   MoveDelta(-2);
  end
  else if playerdir > 0 then
  begin
   MoveDelta(2); 
  end;
  *)
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