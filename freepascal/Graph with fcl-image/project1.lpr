program project1;
{$mode objfpc}{$H+}

uses ptcgraph,ptccrt,FPImage,FPReadGIF;

type
  XGFHeadFP = Packed Record
              Width,Height : LongInt;
              reserved     : LongInt;
  end;

function RGB16m(r,g,b : byte) : longword;
begin
 // 8:8:8 rgb format
 result:=(r shl 16) + (g shl 8) + (b );
end;

function RGB64k(r,g,b : byte) : longword;
begin
  // 5:6:5 rgb format
  r:=(r * 31 + 128) div 255;
  g:=(g * 63 + 128) div 255;
  b:=(b * 31 + 128) div 255;
  result:=(r shl 11) + (g shl 5) + b;
end;

function RGB32k(r,g,b : byte) : longword;
begin
  // 5:5:5 rgb format
  r:=(r * 31 + 128) div 255;
  g:=(g * 31 + 128) div 255;
  b:=(b * 31 + 128) div 255;
  result:=(r shl 10) + (g shl 5) + b;
end;

procedure Convert16BitRGBTo8Bit(R16, G16, B16: Word; var r,g,b : byte);
begin
  r:=Round(R16 / 65535 * 255);
  g:=Round(G16 / 65535 * 255);
  b:=Round(B16 / 65535 * 255);
end;

procedure CopyFPImagePalette(fpimage: TFPCustomImage;gd : smallint);
var
  col   : integer;
  maxcolor : integer;
  fpcol : TFPColor;
  r,g,b : byte;
begin
  if fpimage.UsePalette = false then exit;
  maxcolor:=fpimage.Palette.Count;
  if maxcolor > 256 then maxcolor:=256;
  for col:=0 to maxcolor-1 do
  begin
    fpcol:=fpimage.Palette.Color[col];
    Convert16BitRGBTo8Bit(fpcol.Red,fpcol.Green,fpcol.Blue,r,g,b);
    setrgbpalette(col,r,g,b);
  end;
end;

procedure DrawFPImage(x,y : integer; fpimage: TFPCustomImage;gd : smallint);
var
    i,j : integer;
  fpcol : TFPColor;
  r,g,b : byte;
begin
 if (gd = D24bit) then
 begin
   for j:=0 to fpimage.Height-1 do
   begin
     for i:=0 to fpimage.Width-1 do
     begin
        fpcol:=fpimage.Colors[i,j];
        Convert16BitRGBTo8Bit(fpcol.Red,fpcol.Green,fpcol.Blue,r,g,b);
        PutPixel(x+i,y+j,RGB16m(r ,g ,b ));
     end;
   end;
 end
 else if (gd = D16bit) then
 begin
   for j:=0 to fpimage.Height-1 do
   begin
     for i:=0 to fpimage.Width-1 do
     begin
       fpcol:=fpimage.Colors[i,j];
       Convert16BitRGBTo8Bit(fpcol.Red,fpcol.Green,fpcol.Blue,r,g,b);
       PutPixel(x+i,y+j,RGB64k(r ,g ,b ));
     end;
   end;
 end
 else if gd = D15bit then
 begin
   for j:=0 to fpimage.Height-1 do
   begin
     for i:=0 to fpimage.Width-1 do
     begin
       fpcol:=fpimage.Colors[i,j];
       Convert16BitRGBTo8Bit(fpcol.Red,fpcol.Green,fpcol.Blue,r,g,b);
       PutPixel(x+i,y+j,RGB32k(r ,g ,b ));
     end;
   end;
 end
 else if gd = d8bit then
  begin
    CopyFPImagePalette(fpimage,gd);
    for j:=0 to fpimage.Height-1 do
    begin
      for i:=0 to fpimage.Width-1 do
      begin
        PutPixel(x+i,y+j,fpimage.Pixels[i,j]);
      end;
    end;
  end;
end;

function GetPutImageSize(width,height,gd : integer) : longint;
begin
  //all FP simulated Graph modes  256 (8 bit),32000(15 bit),64000 (16 bit) colors take word (2 bytes) per pixel
  //16 million color (24 bit) take 4 bytes
  if (gd=D8Bit) or (gd=D16bit) or (gd=D15bit) then GetPutImageSize:=sizeof(XGFHeadFP)+(width*2)*height
  else GetPutImageSize:=sizeof(XGFHeadFP)+(width*4)*height;
end;

procedure FPImageToPutImage(fpimage: TFPCustomImage;var PImage;gd : smallint);
var
    i,j : integer;
  fpcol : TFPColor;
  r,g,b : byte;
  DataLong :array[1..1] OF LongWord absolute PImage;
  DataWord :array[1..1] OF Word absolute PImage;
  DataHead :XGFHeadFP absolute PImage;
  count   : integer;
begin
 //form the PutImage header
 DataHead.Width:=fpimage.Width;
 DataHead.Height:=fpimage.Height;
 DataHead.reserved:=0;
 count:=7;
 if (gd=D24bit) then count:=4;

 for j:=0 to fpimage.Height-1 do
 begin
   for i:=0 to fpimage.Width-1 do
   begin
     if gd = D8bit then
     begin
       DataWord[count]:=fpimage.Pixels[i,j];
     end
     else if gd = D24bit then
     begin
       fpcol:=fpimage.Colors[i,j];
       Convert16BitRGBTo8Bit(fpcol.Red,fpcol.Green,fpcol.Blue,r,g,b);
       DataLong[count]:=RGB16m(r ,g ,b );
     end
     else if gd = D16bit then
     begin
       fpcol:=fpimage.Colors[i,j];
       Convert16BitRGBTo8Bit(fpcol.Red,fpcol.Green,fpcol.Blue,r,g,b);
       DataWord[count]:=RGB64k(r ,g ,b );
     end
     else if gd = D15bit then
     begin
       fpcol:=fpimage.Colors[i,j];
       Convert16BitRGBTo8Bit(fpcol.Red,fpcol.Green,fpcol.Blue,r,g,b);
       DataWord[count]:=RGB32k(r ,g ,b );
     end;
     inc(count);
    end;
 end;
end;



var
  gd,gm: smallint;
  image: TFPCustomImage;
  reader: TFPCustomImageReader;
  Size  : longword;
  MyImage : Pointer;
begin
  Image := TFPMemoryImage.Create(0,0);
  Image.UsePalette:=true;
  Reader := TFPReaderGIF.Create;

  Image.LoadFromFile('test2.gif', Reader);

  gd:=D8bit;
  gm:=m1024x768;
  InitGraph(gd,gm,'');

  //allocate memory for PutImage buffer
  size:=GetPutImageSize(Image.Width,Image.Height,gd);
  GetMem(MyImage,Size);

  //draw image one pixel at time
  drawfpimage(0,0,image,gd);

  //convert image to PutImage format and display. convert once, display multiple times
  //faster than drawfpimage method
  FPImageToPutImage(Image,MyImage^,gd);
  CopyFPImagePalette(Image,gd);
  PutImage(100,100,MyImage^,0);

  Image.Free;
  Reader.Free;
  Delay(10000);
  closegraph;
  //free PutImage memory buffer
  FreeMem(MyImage,Size);
end.


