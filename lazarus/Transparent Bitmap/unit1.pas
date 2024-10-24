unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs;

type

  { TForm1 }

  TForm1 = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
  private

  public
     BitMap1,BitMap2 : TBitMap;
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure RenderGrid(Canvas: TCanvas; Height, Width: Integer;
  Size: Integer; Color1, Color2: TColor);
var
  y: Integer;
  x: Integer;
begin
  for y := 0 to Height div Size do
    for x := 0 to Width div Size do
    begin
      if Odd(x) xor Odd(y) then
        Canvas.Brush.Color := Color1
      else
        Canvas.Brush.Color := Color2;
        Canvas.FillRect(Rect(x*Size, y*Size, (x+1)*Size, (y+1)*Size));
    end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
 BitMap1:=TBitmap.Create;
 BitMap2:=TBitmap.Create;

 BitMap1.SetSize(400,400);
 BitMap2.SetSize(400,400);


 BitMap1.PixelFormat:=pf24bit;
 RenderGrid(BitMap1.Canvas,400,400,40,clWhite,clGray);

 BitMap2.PixelFormat:=pf24bit;
 BitMap2.TransparentColor:=clBlue;
 BitMap2.TransparentMode:=tmFixed;
 BitMap2.Transparent:=true;

 BitMap2.canvas.Brush.Color:=clBlue;
 BitMap2.Canvas.Rectangle(0,0,400,400);

 BitMap2.canvas.Brush.Color:=clRed;
 BitMap2.Canvas.Rectangle(10,10,80,80);
end;

procedure TForm1.FormPaint(Sender: TObject);
begin
//  RenderGrid(canvas,400,400,40,clWhite,clGray);
  canvas.Draw(0,0,BitMap1);
  canvas.Draw(0,0,BitMap2);
end;

end.

