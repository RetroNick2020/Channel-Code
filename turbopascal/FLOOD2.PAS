program flood2;
uses graph;

Type
  Point = record
            x,y : integer;
  end;

  StackPoint = object
             c : integer;
             slist : array[1..1000] of point;
             constructor init;
             destructor done;
             procedure push(pt : point);
             procedure pop(var pt : point);
             function count : integer;
  end;

constructor StackPoint.init;
begin
 c:=0;
end;

destructor StackPoint.done;
begin
end;


procedure StackPoint.push(pt : point);
begin
 inc(c);
 if c > 999 then halt;
 slist[c]:=pt;
end;

procedure StackPoint.pop(var pt : point);
begin
 if c > 0 then
 begin
   pt:=slist[c];
   dec(c);
 end;
end;

function StackPoint.count : integer;
begin
  count:=c;
end;

procedure FloodFill(px,py, replacementColor : integer);
var
 pixels : StackPoint; (*implement stack point class*)
 temp   : point;
 txy    : point;
 y1     : integer;
 spanleft,spanright : boolean;
 targetColor : integer;
begin
  pixels.Init;
  txy.x:=px;
  txy.y:=py;
  targetColor := GetPixel(txy.X, txy.Y);
  if (targetColor=replacementColor) then
  begin
    exit;
  end;

  pixels.Init;
  pixels.Push(txy);
  while (pixels.Count <> 0) do
  begin
    pixels.Pop(temp);
    y1 := temp.Y;
    while (y1 >= 0) AND (GetPixel(temp.X, y1) = targetColor) do
    begin
      Dec(y1);
    end;
    inc(y1);
    spanLeft := false;
    spanRight := false;
    while (y1 <GetMaxY) AND (GetPixel(temp.X, y1) = targetColor) do
    begin
      PutPixel(temp.X, y1, replacementColor);
      if (NOT spanLeft) AND (temp.X > 0) AND (GetPixel(temp.X - 1, y1) = targetColor) then
      begin
        txy.x:=temp.x-1;
        txy.y:=y1;
        pixels.Push(txy);
        spanLeft := true;
      end
      else if ((spanLeft AND (temp.X - 1 = 0)) AND (GetPixel(temp.X - 1, y1) <> targetColor)) then
      begin
        spanLeft := false;
      end;
      if (NOT spanRight AND (temp.X < GetMaxX - 1) AND (GetPixel(temp.X + 1, y1) = targetColor)) then
      begin
        txy.x:=temp.x+1;
        txy.y:=y1;
        pixels.Push(txy);
        spanRight := true;
      end
      else if (spanRight AND (temp.X < GetMaxX - 1) AND (GetPixel(temp.X + 1, y1) <> targetColor)) then
      begin
        spanRight := false;
      end;
     inc(y1);
    end;
  end;
end;


procedure recflood(x,y,fill,old : integer);
var
 current : integer;
begin
    if (x<0) or (x>=getmaxx) then exit;
    if (y<0) or (y>=getmaxy) then exit;

 if (getpixel(x,y) = old)  then
  begin
      putpixel(x,y,fill);
      recflood(x+1,y,fill,old);
      recflood(x,y+1,fill,old);
      recflood(x-1,y,fill,old);
      recflood(x,y-1,fill,old);
  end;
end;


Procedure NickFlood(xx,yy,NColor: Word);
const
 Left =1;
 right=2;
 up   =3;
 down =4;
 StackMax = 10000;
Var
 StackHolderX : Array[0..StackMax] of Integer;
 StackHolderY :  Array[0..StackMax] of Integer;
 StackHolderPos :  Array[0..StackMax] of Integer;
 sthnum    : word;
 pp        : Word;
 coltofill : Word;


Procedure AddToStack(nx,ny,np : integer);
begin
  if (sthnum >= StackMax) then exit;
  inc(sthnum);
  StackHolderx[sthnum]:=nx;
  StackHoldery[sthnum]:=ny;
  StackHolderpos[sthnum]:=np;
end;

Procedure CheckRight;
begin
if xx<GetMaxX then
begin
if getpixel(xx+1,yy) = ColTofill  then
   begin
     putpixel(xx+1,yy,Ncolor);
     AddToStack(xx+1,yy,Right);
   end;
   end;
end;

Procedure CheckLeft;
Begin
if xx >0 then
begin
  if GetPixel(xx-1,yy) = ColTofill then
  begin
    PutPixel(xx-1,yy,Ncolor);
    AddToStack(xx-1,yy,Left);
  end;
 end;
end;

Procedure CheckUp;
begin
  if yy>0 then
  begin
    if GetPixel(xx,yy-1) = ColTofill then
    begin
      PutPixel(xx,yy-1,Ncolor);
      AddToStack(xx,yy-1,up);
    end;
  end;
end;

Procedure CheckDown;
begin
  if yy<GetMaxY then
  begin
   If GetPixel(xx,yy+1)=ColTofill then
   begin
     PutPixel(xx,yy+1,Ncolor);
     AddToStack(xx,yy+1,down);
   end;
  end;
end;

Procedure GetColortoFill;
begin
   ColToFill:=GetPixel(xx,yy);
end;

Procedure GetNewCord;
begin
 if sthnum > 0 then
 begin
  xx:=StackHolderx[sthnum];
  yy:=StackHoldery[sthnum];
  pp:=StackHolderpos[sthnum];
  dec(sthnum);
 end;
end;

begin
  sthnum:=1;
  GetColorTofill;
  If ColToFill = NColor then exit;
  PutPixel(xx,yy,Ncolor);

  Repeat
   case pp of
   Left: begin
          CheckLeft;
          CheckDown;
          Checkup;
         end;
   Right:begin
          CheckRight;
          CheckUp;
          CheckDown;
         end;
   Up:begin
         CheckRight;
         CheckLeft;
         Checkup;
       end;
   Down:begin
         CheckDown;
         CheckRight;
         CheckLeft;
       end;
 else
    begin
           CheckRight;
           CheckUP;
           CheckDown;
           CheckLeft;
    end;
 end;
 GetNewCord;
 Until sthnum=0;
end;






 var
 mypt : point;
 gd,gm : integer;

begin
 gd:=ega;
 gm:=egahi;
 initgraph(gd,gm,'c:\tp7\bgi');
 setcolor(white);
 rectangle(0,0,getMaxX,GetMaxY);
 rectangle(100,100,150,150);
 rectangle(11,11,120,120);
 rectangle(200,60,600,120);
 rectangle(250,20,620,48);
 rectangle(170,125,300,330);

 circle(180,50,30);
 circle(80,250,50);
 circle(400,250,70);
 circle(500,300,70);

 floodfill(10,10,Red);
{ nickflood(10,10,Red);}

{ recflood(10,10,Red,0);}
 readln;
 closegraph;
end.
