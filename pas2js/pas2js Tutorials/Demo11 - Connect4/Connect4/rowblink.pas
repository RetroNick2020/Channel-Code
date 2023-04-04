unit rowblink;

Interface
 uses web,assets,c4core,findrows;
type
 TRowBlink = class
           timer : TJSDOMHighResTimeStamp;
           renderctx        : TJSCanvasRenderingContext2D;
           rowcount : integer;
           blinkCount : integer;
           apoints : aitempoints;
           Loaded  : boolean;

           constructor create;
           procedure setRenderCTX(var ctx : TJSCanvasRenderingContext2D);
           procedure BuildRowList;
           procedure ClearRowList;
           procedure Draw;
           procedure Update(aTime: TJSDOMHighResTimeStamp);

 end;

Implementation

constructor TRowBlink.create;
begin
  timer:=0;
  rowcount:=0;
  blinkCount:=0;
  Loaded:=false;
end;

procedure TRowBlink.setRenderCTX(var ctx : TJSCanvasRenderingContext2D);
begin
  renderctx:=ctx;
end;

procedure TRowBlink.Update(aTime: TJSDOMHighResTimeStamp);
begin
if loaded = false then BuildRowList;
if aTime > (timer+200)  then
  begin
    timer:=aTime;
    inc(blinkCount);
    if blinkCount > 2 then blinkCount:=1;
  end;  
end;

procedure TRowBlink.Draw;
var
 i : integer;
 c : integer;
 nx,ny : integer;
begin 
 //writeln('blinking');
 
 if blinkCount = 2 then exit;
 for i:=0 to rowcount-1 do
  begin
    with apoints[i] do
    begin
      nx:=x;
      ny:=y;
      for c:=1 to count do
      begin
        renderCTX.drawimage(BlinkImage,nx*29,ny*27,32,32);
        inc(nx,stepx);
        inc(ny,stepy);
      end;  
    end;  
  end;
end;

procedure TRowBlink.BuildRowList;
begin
  rowcount:=FindRowOfColors(apoints,4);
  Loaded:=true;
end;

procedure TRowBlink.ClearRowList;
begin
  Loaded:=false;
end;

begin
end.