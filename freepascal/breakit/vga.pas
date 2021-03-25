Unit VGA;

interface
procedure SetVGAMode13;
procedure ClearScreen(c : integer);
procedure putimage(x,y : integer;var image;transcol : integer);
procedure setcolor(c : integer);
procedure Rectangle(x,y,x2,y2 : integer);
procedure Bar(x,y,x2,y2 : integer);

implementation
  uses dos,go32;
var
 sc : array[0..199,0..319] of Byte absolute $A000:0;
 reg : registers;
 color : integer;

procedure SetVGAMode13;
begin
 reg.ax:=$0013;
 intr($10,reg);
end;

procedure ClearScreen(c : integer);
var
 vgasel : word;
begin
 vgasel:=segment_to_descriptor($A000);
 seg_fillchar(vgasel,0,64000,chr(c));
end;

procedure setcolor(c : integer);
begin
 color:=c;
end;

procedure Rectangle(x,y,x2,y2 : integer);
var
 i : integer;
begin
  for i:=x to x2 do
  begin
     sc[y,i]:=color;
     sc[y2,i]:=color;
  end;
  for i:=y to y2 do
  begin
     sc[i,x]:=color;
     sc[i,x2]:=color;
  end;
end;

procedure Bar(x,y,x2,y2 : integer);
var
 i,j : integer;
begin
  for j:=y to y2 do
  begin
    for i:=x to x2 do
    begin
     sc[j,i]:=color;
    end;
  end;
end;

{$R-}
procedure putimage(x,y : integer;var image;transcol : integer);
type
 imgrec = Record
          w,h  : integer;
          im   : array[0..0] of byte;
      end;
var
 ImgPtr : ^imgrec;
 c : integer;
 i,j : integer;
begin
 c:=0;
 ImgPtr:=@image;
 for j:=0 to ImgPtr^.h do
 begin
   for i:=0 to ImgPtr^.w do
   begin
      if ImgPtr^.im[c]<>transcol then sc[j+y,i+x]:=ImgPtr^.im[c];
      inc(c);
   end;
 end;
end;
{$R+}

begin

end.
