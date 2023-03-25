unit enemy;

Interface
 uses web,assets;
type
 TEnemy = class
           x : integer;
           y : integer;
           direction : integer;
           active    : boolean;
           renderctx        : TJSCanvasRenderingContext2D;
           renderimg        : TJSHTMLImageElement;
           constructor create;
           procedure setRenderCTX(var ctx : TJSCanvasRenderingContext2D);
           //procedure setRenderImg(var Img : TJSHTMLImageElement);           
           procedure MoveTo(nx,ny : integer);
           procedure MoveDelta(xdelta : integer);
           procedure Draw;
           function getx : integer;
           function gety : integer;
           procedure setactive(nactive: boolean);
           function getactive : boolean;           
end;

Implementation

const 
 Left = 1;
 Right = 2;

constructor TEnemy.create;
begin
  x:=0;
  y:=0;
  direction:=0;
  active:= true;
  direction := LEFT; 
end;

procedure TEnemy.setRenderCTX(var ctx : TJSCanvasRenderingContext2D);
begin
  renderctx:=ctx;
end;
(*
procedure TEnemy.setRenderImg(var Img : TJSHTMLImageElement);
begin
  renderImg:=Img;
end;
*)
procedure TEnemy.MoveTo(nx,ny : integer);
begin
  x:=nx;
  y:=ny;
end;

procedure TEnemy.movedelta(xdelta : integer);
begin
    if direction = LEFT then
    begin
       x:=x-xdelta;
       if x < 10 then 
       begin
          y:=y+20;
          direction:=RIGHT;
       end;    
    end   
    else if direction = RIGHT then
    begin
       x:=x+xdelta;
       if x > 290 then
       begin
          y:=y+20;
          direction:=LEFT;
       end;
    end;
end;

procedure TEnemy.draw;
begin
  if active = true then
  begin
    //  renderCTX.drawImage(renderImg,x,y,16,16)
    renderCTX.drawImage(EnemyImage,x,y,16,16);             
  end;    
end;
  
 function TEnemy.getx : integer;
 begin
   getx:=x;
 end;
  
function TEnemy.gety : integer;
begin
  gety:=y;
end;

procedure TEnemy.setactive(nactive : boolean);
begin   
  active:=nactive;
end;
 
function TEnemy.getactive : boolean;
begin   
  getactive:=active;
end;

begin  
end.