unit bullets;

Interface
 uses web,assets;
type
 TBullet = class
           x : integer;
           y : integer;
           ysteps : integer;
           active : boolean;
           renderctx        : TJSCanvasRenderingContext2D;
         //  renderimg        : TJSHTMLImageElement;           

           constructor create;
           procedure setRenderCTX(var ctx : TJSCanvasRenderingContext2D);
          // procedure setRenderImg(var Img : TJSHTMLImageElement);           
           procedure Move;
           procedure fire(nx,ny : integer);
           procedure draw;
           function getx : integer;
           function gety : integer;
           procedure setactive(nactive: boolean);
           function getactive : boolean;            
 end;

Implementation

constructor TBullet.Create;
begin
  x:=0;
  y:=0;
  ysteps := 10;
  active:= false;
end;

procedure TBullet.setRenderCTX(var ctx : TJSCanvasRenderingContext2D);
begin
  renderctx:=ctx;
end;
(*
procedure TBullet.setRenderImg(var Img : TJSHTMLImageElement);
begin
  renderImg:=Img;
end;
*)
procedure TBullet.setactive(nactive : boolean);
begin   
   active:=nactive;
end;
 
function TBullet.getactive : boolean;
begin   
   getactive:=active;
end;
 
procedure TBullet.fire(nx,ny : integer);
begin
   if active = false then
   begin
     x:=nx;
     y:=ny;
     active := true;
     FireSound.Play;
   end; 
end;
 
procedure TBullet.Move;
begin   
   if active = false then exit;
      
   y:=y-ysteps;
   if y < 10 then
   begin
     active := false;
   end;   
 end;
 
 function TBullet.getx : integer;
 begin
   getx:=x;
 end;
  
 function TBullet.gety : integer;
 begin
   gety:=y;
 end;
 
 procedure TBullet.draw;
 begin
   if active=true then
   begin
     renderCTX.drawImage(BulletImage,x,y,3,3)
   end;  
 end;
 
begin 
end.