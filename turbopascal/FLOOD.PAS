Program FloodFill;
 uses
  graph;

Procedure Fill(xx,yy,NColor: Word);
const
 Left =1;
 right=2;
 up   =3;
 down =4;
 StackMax = 8000;
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
 gd,gm : integer;
begin
  gd:=ega;
  gm:=egahi;
  initgraph(gd,gm,'c:\tp7\bgi');

  setcolor(green);
  rectangle(10,10,50,50);

  Fill(100,100,Red);
  readln;
end.

