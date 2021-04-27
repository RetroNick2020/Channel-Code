Program SaceILBM;
         uses sysutils,graph,npacker,gpacker,mpacker;
Type
  ChunkNameRec = array[1..4] of char;

  //FORM chunk is followed by longword total filesize-8
  //"PBM " is not followed size id
  //BMHD is followed by longword size id of 20
  //CMAP is followed by longword size n colors * 3
  //if CMAP size is an odd number a pad byte is added but not counted as part
  //of size. if there were 3 color - that would be 3*3 = 9 . so longword size
  // is 9 and followed by pad byte;

  ColorMapRec = Packed Record
    red   : Byte;
    green : Byte;
    blue  : Byte;
  End;

  BitMapHeaderRec = Packed Record
    w : Word;                    (* raster width in pixels  *)
    h : Word;                    (* raster height in pixels *)
    x : word;                    (* x offset in pixels *)
    y : word;                    (* y offset in pixels *)
    nplanes : Byte;              (* # source bitplanes *)
    masking : Byte;              (* masking technique, 0 = mskNone, 1 = mskHasMask, 2 = mskHasTransparentColor, 3 = mskLasso *)
    compression : Byte;          (* compression algoithm, 0 = cmpNone, 1 = cmpByteRun1 *)
    pad1 : Byte;                 (* UNUSED.  For consistency, put 0 here. *)
    transparentColor : Word;     (* transparent "color number" *)
    xaspect : Byte;              (* aspect ratio, a rational number x/y *)
    yaspect : byte;              (* aspect ratio, a rational number x/y *)
    pagewidth : word;            (* source "page" size in pixels *)
    pageheight : word;           (* source "page" size in pixels *)
 End;

 LineBufType = Array[0..16023] of Byte;

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

Procedure spTOmp(Var singlePlane : LineBufType ;
                 var multiplane : LineBufType;
                 PixelWidth,BytesPerPlane,nPlanes : Word);

var
 BitPlane1 : Word;
 BitPlane2 : Word;
 BitPlane3 : Word;
 BitPlane4 : Word;
 BitPlane5 : Word;
 pixelpos  : Word;
 color     : Word;
 xoffset   : Word;
 x,j       : Word;
begin

 Fillchar(multiplane,sizeof(multiplane),0);

 BitPlane1:=0;
 BitPlane2:=bytesPerPlane;
 BitPlane3:=BytesPerPlane*2;
 BitPlane4:=BytesPerPlane*3;
 BitPlane5:=BytesPerPlane*4;  //32 colors
 xoffset:=0;
 pixelpos:=0;
 for x:=0 to bytesPerPlane-1 do
 begin
   for j:=0 to 7 do
   begin
      color:=SinglePlane[xoffset+j];
      if (nPlanes > 4) AND biton(4,color) then setbit((7-j),1,multiplane[BitPlane5+pixelpos]);
      if (nPlanes > 3) AND biton(3,color) then setbit((7-j),1,multiplane[BitPlane4+pixelpos]);
      if (nPlanes > 2) AND biton(2,color) then setbit((7-j),1,multiplane[BitPlane3+pixelpos]);
      if (nPlanes > 1) AND biton(1,color) then setbit((7-j),1,multiplane[BitPlane2+pixelpos]);
      if (nPlanes > 0) AND biton(0,color) then setbit((7-j),1,multiplane[BitPlane1+pixelpos]);
    end;
   inc(pixelpos);
   inc(xoffset,8);
 end;
end;

Function LongToLE(myLongWord : LongWord) : LongWord;
var
 Temp : array[1..4] of Byte;
begin
  Move(myLongWord,Temp,sizeof(Temp));
  LongToLE := (Temp[1] shl 24) + (Temp[2] shl 16) + (Temp[3] shl 8) + Temp[4];
end;

Function WordToLE(myWord : Word) : Word; (* if its little endian to will become big endian vice versa*)
begin
  WordToLE:=LO(myWord) SHL 8 + HI(myWord);
end;

Function RowBytes(w : Word): word;
BEGIN
  RowBytes:= ((((w + 15) DIV 16) * 2));
END;

Procedure WriteChunkName(var f : file; chunkname : chunknamerec);
begin
 blockwrite(f,chunkname,sizeof(chunkname));
end;

Procedure WriteChunkSize(var f : file; size : longword);
begin
 blockwrite(f,size,sizeof(size));
end;

Procedure WriteBMHD(var f : file; var bmhd: BitMapHeaderRec);
begin
 blockwrite(f,bmhd,sizeof(bmhd));
end;


Function GetCMAPSize : Longword;
var
 size: longword;
begin
 size:=(getmaxcolor+1)*3;
 if odd(size) then inc(size);
 GetCMAPSize:=size;
end;

Procedure WriteCMAP(var f : file);
var
 cmap  : array[0..255] of ColorMapRec;
 i     : integer;
 r,g,b : integer;
 pad0  : byte;
begin
 pad0:=0;
 for i:= 0 to GetMaxColor do
 begin
   GetRGBPalette(i,r,g,b);
   cmap[i].red:=r;
   cmap[i].green:=g;
   cmap[i].blue:=b;
 end;
 blockwrite(f,cmap,(GetMaxColor+1)*3);
 if ((GetMaxColor+1)*3)< GetCMAPSize then Blockwrite(f,pad0,sizeof(pad0));
end;

Function GetNPLanes : Byte;
begin
 GetNPlanes:=0;
 Case GetMaxColor of 1:GetNPlanes:=1;
                     3:GetNPlanes:=2;
                     7:GetNPlanes:=3;
                     15:GetNPlanes:=4;
                     31:GetNPlanes:=5;
                     63:GetNPlanes:=6;
                     127:GetNPlanes:=7;
                     255:GetNPlanes:=8;
 end;
end;

Function WriteBODY(var f : file; x,y,x2,y2 : word;cmp : byte) : longword;
var
  singlePlane : LineBufType;
  multiPlane  : LineBufType;
  ImgPacked   : LineBufType;
  PackedSize  : integer;
  BodySize    : longword;

  pad0        : byte;
  NPlanes     : byte;
  colorIndex  : word;

  w,h         : word;
  pcount      : integer;
   i          : integer;
  LinePos     : integer;

begin
 w:=x2-x+1;
 h:=y2-y+1;
 BodySize:=0;
 pad0:=0;
 nPlanes:=GetNPlanes;

 for LinePos:=y to y2 do
 begin
   colorIndex:=0;
   //get a line of pixels and store them in singleplane array
   for i:=x to x2 do
   begin
     singlePlane[colorIndex]:=GetPixel(i,LinePos);
     inc(colorIndex);
   end;

   if nPlanes = 8 then //we use the PBM format for this - everyhing else ILBM
   begin
     if cmp = 1 then
     begin
       packedsize:=nPackRow(singleplane,0,imgpacked,w);
       blockwrite(f,imgpacked,packedsize);
       inc(Bodysize,packedsize);
     end
     else
     begin
       blockwrite(f,singleplane,w);
       inc(Bodysize,w);
     end;
   end
   else
   begin
     //convert single plane color to multiple planes and store in array
     spTOmp(singlePlane,multiPlane,w,RowBytes(w),nPlanes);
     //cycle throuh planes and dump bit plane rows to be compressed
     for pcount:=0 to nplanes-1 do
     begin
       if cmp = 1 then
       begin
         //compress each row bitplane seperately - Do Not compress all bitplanes in one packrow command!
         packedsize:=nPackRow(multiplane,pcount*rowbytes(w),imgpacked,RowBytes(w));
       //  packedsize:=nPackRow2(multiplane,pcount*rowbytes(w),imgpacked,RowBytes(w));
       //  packedsize:=gPackRow(multiplane,pcount*rowbytes(w),imgpacked,RowBytes(w));
       //  packedsize:=mPackRow(@multiplane[pcount*rowbytes(w)],imgpacked,RowBytes(w));

         blockwrite(f,imgpacked,packedsize);
         inc(Bodysize,packedsize);
       end
       else
       begin
         blockwrite(f,multiplane[pcount*rowbytes(w)],rowbytes(w));
         inc(Bodysize,rowbytes(w));
       end;
     end;  //pcount loop
   end; //nplanes if
 end;  //j loop

 if Odd(BodySize) then  //if the BODY is odd Delexe Paint reports it mangled iff
 begin
   inc(BodySize);
   BlockWrite(f,pad0,sizeof(pad0));
 end;

 WriteBody:=BodySize;
end;


Procedure UpdateFormSize(var f : file);
var
 size : longword;
begin
 size:=LongToLE(filesize(f)-8);   //form size is FileSize - 8
 Seek(f,4);
 blockwrite(f,size,sizeof(size));
end;

Procedure SaveILBM(filename : string; x,y,x2,y2 : word;cmp  :byte);
var
 f        : File;
 bmhd     : BitMapHeaderRec;
 BodyFP   : longint;
 BodySize : longword;

begin
 assign(f,filename);
 rewrite(f,1);

 WriteChunkName(f,'FORM');
 WriteChunkSize(f,0); //we don't know the final size yet - we will update below
 If GetNPlanes = 8 then
   WriteChunkName(f,'PBM ')
 else
   WriteChunkName(f,'ILBM');

 WriteChunkName(f,'BMHD');
 WriteChunkSize(f,LongToLE(20));

 bmhd.w:=WordToLE(x2-x+1);
 bmhd.h:=WordToLE(y2-y+1);
 bmhd.x:=WordToLE(0);
 bmhd.y:=WordToLE(0);

 bmhd.nplanes:=GetNPlanes;
 bmhd.masking:=0;
 bmhd.compression:=cmp;
 bmhd.pad1:=0;
 bmhd.transparentColor:=WordToLE(GetMaxColor);

 bmhd.xaspect:= 4;  //fill your own aspect rations
 bmhd.yaspect:= 5;

 bmhd.pagewidth:=WordToLE(GetMaxX+1);
 bmhd.pageheight:=WordToLE(GetMaxY+1);

 WriteBMHD(f,bmhd);

 WriteChunkName(f,'CMAP');
 WriteChunkSize(f,LongToLE(GetCMAPSize));
 WriteCMAP(f);

 WriteChunkName(f,'BODY');
 BodyFP:=FilePos(f); //save position where Body size should be updated
 WriteChunkSize(f,LongToLE(0)); //we don't know yet - update below

 BodySize:=LongToLE(WriteBODY(f,x,y,x2,y2,cmp));
 Seek(F,BodyFP);
 Blockwrite(f,bodysize,sizeof(bodysize));  //update body size
 UpdateFormSize(f);

 close(f);
end;

var
 gd,gm,i : integer;

begin
//  gd:=cga;
//  gm:=cgahi; //show monchrome mode
//  gm:=cgac0;  //4 color mode

  gd:=ega;
  gm:=egahi; //16 color mode

//  gd:=d8bit;
//  gm:=m320x200; //256 color mode

  initgraph(gd,gm,'');

  for i:=0 to 15 do
  begin
    SetColor(i Mod GetMaxColor+1);
    Rectangle(10+i*2,15+i*2,GetMaxX-i*2-10,GetMaxY-i*2-10);
  end;
  SetColor(1);
  OutTextXy(50,4,'This should be '+intToStr(GetMaxColor+1)+' colors!');
  SetColor(GetMaxColor);
  Rectangle(0,0,GetMaxX,GetMaxY);

  SaveILBM('TESTILBM.LBM',0,0,GetMaxX,GetMaxY,1);
  readln;
end.
