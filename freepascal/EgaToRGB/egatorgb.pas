//utility functions to convert EGA Index Palette to RGB
//and 4 bit RGB value to EGA palette Index (0 to 63)

Program egatorgb;


Function BitOn(Position,Testbyte : Byte) : Boolean;
Var
  Bt : Byte;
Begin
  Bt :=$01;
  Bt :=Bt Shl Position;
  Biton :=(Bt And Testbyte) > 0;
End;

Procedure SetBit(Position, Value : Byte; Var Changebyte : Byte);
Var
  Bt : Byte;
Begin
  Bt :=$01;
  Bt :=Bt Shl Position;
  If Value = 1 then
     Changebyte :=Changebyte Or Bt
  Else
   Begin
     Bt :=Bt Xor $FF;
     Changebyte :=Changebyte And Bt;
  End;
End;

// convert EGA Index to 8 bit rgb values
procedure EGAToRGB8(egaindex : byte; var r,g,b : byte);
begin
 r:=85*(((egaindex SHR 1) AND 2) OR (egaindex SHR 5) AND 1);
 g:=85*(((egaindex AND 2) OR (egaindex  SHR 4) AND 1));
 b:=85*(((egaindex SHL 1) AND 2) OR (egaindex SHR 3) AND 1);
end;

// convert EGA Index to 4 bit rgb values
procedure EGAToRGB4(egaindex : byte; var r,g,b : byte);
begin
 r:=(((egaindex SHR 1) AND 2) OR (egaindex SHR 5) AND 1);
 g:=(((egaindex AND 2) OR (egaindex  SHR 4) AND 1));
 b:=(((egaindex SHL 1) AND 2) OR (egaindex SHR 3) AND 1);
end;

// convert EGA Index to 4 bit rgb values using biton function
procedure EGAToRGB4B(egaindex : byte; var r,g,b : byte);
begin
 r:=0;
 g:=0;
 b:=0;
 if biton(5,egaindex) then inc(r);
 if biton(2,egaindex) then inc(r,2);

 if biton(4,egaindex) then inc(g);
 if biton(1,egaindex) then inc(g,2);

 if biton(3,egaindex) then inc(b);
 if biton(0,egaindex) then inc(b,2);
end;

//convert 4 bit rgb values to EGA Index
function RGBToEGAIndex(r,g,b : byte) : byte;
var
egaindex : byte;
begin
 egaindex:=0;

 if biton(0,r) then SetBit(5,1,egaindex);
 if biton(1,r) then SetBit(2,1,egaindex);

 if biton(0,g) then SetBit(4,1,egaindex);
 if biton(1,g) then SetBit(1,1,egaindex);

 if biton(0,b) then SetBit(3,1,egaindex);
 if biton(1,b) then SetBit(0,1,egaindex);
 RGBToEGAIndex:=egaindex;
end;

//convert 4 bit rgb values to EGA Index - without setbit function
function RGBToEGAIndex2(r,g,b : byte) : byte;
var
egaindex,x : byte;
begin
{$R-}
 egaindex:=0;
 x:=r SHL 7;
 x:=x SHR 7;
 if x > 0 then inc(egaindex,32);

 x:=r SHL 6;
 x:=x SHR 7;
 if x > 0 then inc(egaindex,4);

 x:=g SHL 7;
 x:=x SHR 7;
 if x > 0 then inc(egaindex,16);

 x:=g SHL 6;
 x:=x SHR 7;
 if x > 0 then inc(egaindex,2);

 x:=b SHL 7;
 x:=x SHR 7;
 if x > 0 then inc(egaindex,8);

 x:=b SHL 6;
 x:=x SHR 7;
 if x > 0 then inc(egaindex,1);

 RGBToEGAIndex2:=egaindex;
 {$R+}
end;

function EightToTwoBit(EightBitValue : integer) : integer;
begin
(*  EightToTwoBit:=EightBitValue SHR 6;*)   //not precise ??
  EightToTwoBit:=round((double(EightBitValue) * 3) / 255)
end;

function TwoToEightBit(TwoBitValue : integer) : integer;
begin
(*   TwoToEightBit := TwoBitValue SHL 6;*)  // not precise ??
  TwoToEightBit := TwoBitValue * 255 div 3;
end;


var
 r,g,b : byte;
 i     : integer;
begin
 for i:=0 to 63 do
 begin
    EGAToRGB4(i,r,g,b);
    writeln('Index = ',i,' r = ',r,' g = ',g,' b = ',b);
    writeln('RGB To EGA Index = ',RGBToEGAIndex(r,g,b));
 end;

 readln;
end.
