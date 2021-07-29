Program MShape;
  uses Mouse,graph;

(* Turbo Pascal, Width= 16 Height= 16 Colors= 4 *)
const
m1 : Array[1..70] of Byte = (
          $0F,$00,$0F,$00,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,
          $AF,$FF,$FF,$AA,$AC,$00,$03,$2A,$AC,$AA,$AB,$2A,
          $AC,$AA,$AB,$2A,$AC,$AA,$AB,$2A,$AC,$AA,$AB,$2A,
          $AC,$AA,$AB,$2A,$AC,$AA,$AB,$2A,$AC,$AA,$AB,$2A,
          $AF,$FF,$FF,$2A,$A8,$00,$00,$2A,$AA,$AA,$AA,$AA,
          $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$00,$00);

(* Turbo Pascal, Width= 16 Height= 16 Colors= 4 *)

m2 : Array[1..70] of Byte = (
          $0F,$00,$0F,$00,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,
          $AF,$FF,$FF,$AA,$AE,$AA,$AB,$2A,$AE,$55,$5B,$2A,
          $AE,$55,$5B,$2A,$AE,$55,$5B,$2A,$AE,$55,$5B,$2A,
          $AE,$55,$5B,$2A,$AE,$55,$5B,$2A,$AE,$AA,$AB,$2A,
          $AF,$FF,$FF,$2A,$A8,$00,$00,$2A,$AA,$AA,$AA,$AA,
          $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$00,$00);


(* Turbo Pascal, Width= 16 Height= 16 Colors= 4 *)

m3 : Array[1..70] of Byte = (
          $0F,$00,$0F,$00,$AA,$AF,$EA,$AA,$AA,$BF,$FA,$AA,
          $AA,$B3,$3A,$AA,$AA,$BF,$FA,$AA,$AA,$AC,$EA,$AA,
          $AA,$AF,$EA,$AA,$AA,$AB,$AA,$AA,$AF,$FF,$FF,$FA,
          $AA,$AB,$AA,$AA,$AA,$AB,$AA,$AA,$AA,$AB,$AA,$AA,
          $AA,$AB,$AA,$AA,$AA,$AB,$AA,$AA,$AB,$FF,$FF,$AA,
          $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$00,$00);

type
  LineBufType = array[1..16] of byte;
  MouseShapeType = array[1..32] of Word;

Procedure packedToSingle(pLine : byte;var uline : lineBufType; offset : Word);
begin
   uline[offset]:=pLine shr 6;
   uline[offset+1]:=pline shl 2;
   uline[offset+1]:=uline[offset+1] shr 6;
   uline[offset+2]:=pLine  shl 4;
   uline[offset+2]:=uline[offset+2] shr 6;
   uline[offset+3]:=pLine shl 6;
   uline[offset+3]:=uline[offset+3] shr 6;
end;  

function bin2dec (s : string) : longint;
var
  tmp : longint;
  p : byte;
begin
  tmp := 0;
  for p := 1 to length(s) do
  begin
    inc(tmp,longint(ord(s[length(s)])-48) shl pred(p));
    dec(s[0]);
  end;
  bin2dec := tmp;
end;

Procedure DrawImgLine(x,y : integer; ImgLine : LineBufType);
var
 i : integer;
begin
 for i:=1 to 16 do
 begin
   PutPixel(x+i-1,y,ImgLine[i]);
 end;
end;

Procedure ImageToMouseShape(Var Image;Var MouseShape : MouseShapeType);
type
  ImageBuf = array[1..70] of byte;
Var
  i,j : Word;
  MImage,MMask : String[16];
  Count,position,offset         : Word;
  ImageLine   : lineBufType;
  ImageBufPtr : ^ImageBuf;
begin
  ImageBufPtr:=@Image;
  Count:=1;
  position:=5;

  For j:=1 to 16 do
  begin
   Fillchar(ImageLine,0,sizeof(ImageLine));
   PackedToSingle(ImageBufPtr^[position],ImageLine,1);
   PackedToSingle(ImageBufPtr^[position+1],ImageLine,5);
   PackedToSingle(ImageBufPtr^[position+2],ImageLine,9);
   PackedToSingle(ImageBufPtr^[position+3],ImageLine,13);
   inc(position,4);

   (* DrawImgLine(200,10+j,ImageLine); *)

   MImage :='1111111111111111';
   MMask :='0000000000000000';

   For i:=1 to 16 do
     begin
       If ImageLine[i] = 0 then  (* 0 is black *)
       begin
         MImage[i]:='0';
         MMask[i]:='0';
       end
       else if ImageLine[i]=3 then (* 3 is white *)
       begin
         MImage[i]:='0';
         MMask[i]:='1';
       end
       else if ImageLine[i]=2 then (* 2 pink / tranparent *)
       begin
         MImage[i]:='1';
         MMask[i]:='0';
       end
       else
       begin                      (* XOR the bits on this part of the mouse shape *)
         MImage[i]:='1';
         MMask[i]:='1';
       end;
     end;
     MouseShape[Count]:=Bin2Dec(MImage);
     MouseShape[Count+16]:=Bin2Dec(MMask);
     Inc(Count);
   end;
end;

Procedure PrintN;
begin
  SetColor(0);
  OutTextXY(2,2,'N');
  SetColor(3);
  OutTextXY(1,1,'N');
end;

var
  gd,gm : integer;
  MyMouse : MouseShapeType;
  TImage  : Array[1..70] of Byte;
begin
  gd:=cga;
  gm:=cgac1;
  initgraph(gd,gm,'c:\tp6\bgi');

  SetFillStyle(SolidFill,2);
  Bar(0,0,50,50);
  SetFillStyle(SolidFill,3);
  Bar(100,100,150,150);

  MouseShow;
  readln;

  ImageToMouseShape(m3,MyMouse);
  MouseGraphCursor(0,0,Seg(MyMouse), Ofs(MyMouse));
  
  readln;
  PrintN;
  GetImage(0,0,15,15,TImage);
  ImageToMouseShape(TImage,MyMouse);
  MouseGraphCursor(0,0,Seg(MyMouse), Ofs(MyMouse));
  readln;
end.