program project1;
{$mode objfpc}{$H+}

uses ptcgraph,ptccrt,FPImage,FPReadBMP;

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

procedure DrawFPImage(x,y : integer;var fpimage: TFPCustomImage;gd : smallint);
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
 end;
end;

var
  gd,gm: smallint;
  image: TFPCustomImage;
  reader: TFPCustomImageReader;
begin
  Image := TFPMemoryImage.Create(0,0);
  Reader := TFPReaderBMP.Create;
  Image.LoadFromFile('test.bmp', Reader);

  gd:=D24bit;
  gm:=m1024x768;
  InitGraph(gd,gm,'');

  drawfpimage(0,0,image,gd);
  image.Free;
  Reader.Free;
  delay(10000);
  closegraph;
end.


