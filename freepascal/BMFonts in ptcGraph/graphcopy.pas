unit GraphCopy;
{$mode objfpc}{$H+}

interface

uses
  ptcGraph, FPImage;

procedure CopyImageRect(
  SrcImg: TFPCustomImage;   // source atlas (TFPMemoryImage)
  SrcX, SrcY,               // top-left in atlas
  DstX, DstY,               // top-left on screen
  Width, Height: Integer;   // rectangle size
  AlphaThreshold: Byte = 128; // 0-255 : skip pixels below this alpha
  ColorTint: longword = White   // ptcGraph colour to use (mono-chrome tint)
);

implementation

procedure CopyImageRect(
  SrcImg: TFPCustomImage;
  SrcX, SrcY, DstX, DstY, Width, Height: Integer;
  AlphaThreshold: Byte;
  ColorTint: longword);
var
  sx, sy, dx, dy: Integer;
  c: TFPColor;
begin
  for sy := 0 to Height - 1 do
    for sx := 0 to Width - 1 do
    begin
       c := SrcImg.Colors[SrcX + sx, SrcY + sy];
       //   if c.alpha > (AlphaThreshold shl 8) then   // TFPColor.alpha is 0..65535
       if (c.red > 0) or (c.green > 0) or (c.blue > 0)  then
           PutPixel(DstX + sx, DstY + sy, ColorTint);
    end;
end;

end.
