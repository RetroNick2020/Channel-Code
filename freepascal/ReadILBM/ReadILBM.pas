Program ReadILBM;
         uses graph;
Type
  ChunkNameRec = array[1..4] of char;

  ColorMapRec = Packed Record
    red   : Byte;
    green : Byte;
    blue  : Byte;
  End;

  BitMapHeaderRec = Packed Record
    w : Word;                    (* raster width in pixels  *)
    h : Word;                    (* raster height in pixels *)
    x : Integer;                    (* x offset in pixels *)
    y : Integer;                    (* y offset in pixels *)
    nplanes : Byte;              (* # source bitplanes *)
    masking : Byte;              (* masking technique, 0 = mskNone, 1 = mskHasMask, 2 = mskHasTransparentColor, 3 = mskLasso *)
    compression : Byte;          (* compression algoithm, 0 = cmpNone, 1 = cmpByteRun1 *)
    pad1 : Byte;                 (* UNUSED.  For consistency, put 0 here. *)
    transparentColor : Word;     (* transparent "color number" *)
    xaspect : Byte;              (* aspect ratio, a rational number x/y *)
    yaspect : byte;              (* aspect ratio, a rational number x/y *)
    pagewidth : Integer;            (* source "page" size in pixels *)
    pageheight : Integer;           (* source "page" size in pixels *)
 End;

 LineBufType = Array[0..4023] of Byte;

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

Procedure mpTOsp(Var planarBuf,singlePlane : LineBufType;BytesPerPlane,nPlanes : Word);
Var
  i,j    : Word;
  xpos   : Word;
  Col    : Word;
  ImgOff2,ImgOff3,ImgOff4,ImgOff5,ImgOff6,ImgOff7,ImgOff8 : Word;
begin
   xpos:=0;
   ImgOff2:=BytesPerPlane;
   ImgOff3:=ImgOff2*2;
   ImgOff4:=ImgOff2*3;
   ImgOff5:=ImgOff2*4;
   ImgOff6:=ImgOff2*5;
   ImgOff7:=ImgOff2*6;
   ImgOff8:=ImgOff2*7;

   FillChar(singlePlane,SizeOf(singlePlane),0);
   For i:=0 to ImgOff2-1 do
   begin
     For j:=7 downto 0 do
     begin
        Col:=0;
        if biton(j,planarBuf[i]) then
        begin
        Inc(Col,1);
        end;

        if (nPlanes > 1) AND biton(j,planarBuf[i+ImgOff2]) then
        begin
        Inc(Col,2);
        end;

        if (nPlanes > 2) AND biton(j,planarBuf[i+ImgOff3]) then
        begin
        Inc(Col,4);
        end;

        if (nPlanes > 3) AND biton(j,planarBuf[i+ImgOff4]) then
        begin
        Inc(Col,8);
        end;

        if (nPlanes > 4) AND biton(j,planarBuf[i+ImgOff5]) then
        begin
        Inc(Col,16);
        end;

        if (nPlanes > 5) AND biton(j,planarBuf[i+ImgOff6]) then
        begin
        Inc(Col,32);
        end;

        if (nPlanes > 6) AND biton(j,planarBuf[i+ImgOff7]) then
        begin
        Inc(Col,64);
        end;

        if (nPlanes > 7) AND biton(j,planarBuf[i+ImgOff8]) then
        begin
        Inc(Col,128);
        end;

        singlePlane[xpos]:=Col;
        Inc(xpos);
     end;
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

Function RowBytes(w: Word): word;
BEGIN
  RowBytes:= ((((w + 15) DIV 16) * 2));
END;

Procedure DrawImgLine(Ln : word;var singleBuf : linebuftype; width : word);
var
 i : word;
begin
 for i:=0 to width-1 do
 begin
  putpixel(i,Ln,singleBuf[i]);
 end;
end;

Procedure ProcessBODY(var F : File;bmap : BitMapHeaderRec;pbm,ilbm : boolean);
var
  mybytes : longint;
  mybmap  : longint;
  bwidth,bheight : word;
  Ln,j,k : integer;
  a,b,c : byte;
  planarBuf,singleBuf : LineBufType;
  counter : word;
  n : integer;
  nplanes : word;
begin
  fillchar(planarBuf,sizeof(planarBuf),0);
  bwidth:=WordToLE(bmap.w);
  bheight:=WordToLE(bmap.h);

  mybytes:=rowbytes(bwidth);
  nplanes:=bmap.nplanes;
  mybmap:=mybytes*bheight;
    FOR Ln:=0 TO bheight-1 do
    begin
        counter:=0;
        FOR j:=0 TO bmap.nplanes-1 do
        begin
            IF bmap.compression=0 THEN
            BEGIN
               FOR k:=0 TO mybytes-1 do
               begin
                 Blockread(F,a,sizeof(a));
                 planarBuf[k]:=a;
               END;
            end
            ELSE
            begin
              WHILE counter < (mybytes*bmap.nplanes-1) do
               begin
                 Blockread(F,c,1);
                 if c > 127 then n:=c-256 else n:=c;  //using 16 bit integer like 8 bit integer
                 //trying to avoid using freepascal int8 and still making code look like C algorithm
                 IF (n >=0) and (n<=127)  THEN
                 begin
                    FOR k:=0 TO n do
                     begin
                       Blockread(F,b,1);
                       planarBuf[counter+k]:=b;
                     end;
                     inc(counter,n+1);
                  end
                  ELSE IF (n<0) and (n>-128) THEN
                  begin
                     Blockread(F,b,1);
                     FOR k:=0 TO abs(n) do
                     begin
                       planarBuf[counter+k]:=b;
                     end;
                     inc(counter,abs(n)+1);
                  END;  //if
                END;   //while
            END;  //if
          End;   // next j

          if pbm then
             DrawImgLine(Ln,planarBuf,bwidth)
          else
          begin
             mptosp(planarBuf,singleBuf,mybytes,nplanes);
             DrawImgLine(Ln,singleBuf,bwidth);
          end;
    end;  //next i
end;

Procedure ProcessCMAP(var F: File;cmapsize : longword);
var
 numColors,i : integer;
 cmap        : ColorMapRec;
begin
 numColors:=cmapsize div 3;
 for i:=0 to numColors-1 do
 begin
    BlockRead(F,cmap,sizeof(cmap));
    SetRGBPalette(i,cmap.red ,cmap.green ,cmap.blue );
 end;
end;

Procedure BuildChunkName(var chunkname : chunknamerec; newbyte : byte;var chunknamelength : integer);
begin
  if chunknamelength = 0 then chunkname:='****';
  inc(chunknamelength);
  if (chunknamelength > 4) then
  begin
    ChunkName[1]:=Chunkname[2];
    ChunkName[2]:=Chunkname[3];
    ChunkName[3]:=Chunkname[4];
    ChunkName[4]:=chr(newbyte);
    Chunknamelength:=4;
  end
  else
    chunkname[chunknamelength]:=chr(newbyte);
end;

Procedure Process(var F : File);
var
  chunkname : chunknamerec;
  chunknamelength : integer;
  mybyte : byte;
  FormSize : LongWord;
  bmap : BitMapHeaderRec;
  bmhdsize : LongWord;
  bodysize : longword;
  cmapsize : longword;
  foundBMap : boolean;
  ILBMFile : boolean;
  PBMFile : boolean;

begin
  ILBMFile:=false;
  PBMFile:=false;
  FoundBMap:=false;
  Chunknamelength:=0;
  While Not Eof(F) do
  begin
    BlockRead(F,mybyte,sizeof(mybyte));
    BuildChunkName(chunkname,mybyte,chunknamelength);
    if chunkname='FORM' then
    begin
      BlockRead(F,FormSize,sizeof(FormSize));
    end
    else if chunkname ='PBM ' then
    begin
      PBMFile:=true;
    end
    else if chunkname ='ILBM' then
    begin
      ILBMFile:=true;
    end
    else if chunkname ='BMHD' then
    begin
      BlockRead(F,bmhdsize,sizeof(bmhdsize));
      BlockRead(F,bmap,sizeof(bmap));
      FoundBMap:=true;
    end
    else if chunkname ='CMAP' then
    begin
      BlockRead(F,cmapsize,sizeof(cmapsize));
      cmapsize:=LongToLE(cmapsize);
      ProcessCMAP(F,cmapsize);
    end
    else if (chunkname ='BODY') And FoundBMap   then
    begin
      BlockRead(F,bodysize,sizeof(bodysize));
      ProcessBODY(F,bmap,pbmFile,ILBMFile);
    end;
  end;
end;


var
 gd,gm : integer;
 F     : File;
begin
  gd:=d8bit;
  gm:=m320x200;
  initgraph(gd,gm,'');
  Assign(F,'test256.lbm');
  Reset(f,1);
  Process(F);
  close(f);
  readln;
  closegraph;
 end.
