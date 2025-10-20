unit BmFontGraph;
{$mode objfpc}{$H+}

interface

uses
  BmFont, ptcGraph,  SysUtils, Classes,  FPImage,FPReadPNG,graphcopy;


type
  TBmFontRenderer = class
  private
    FFont  : TBmFont;
    FPages: array of TFPCustomImage;         // one TFPCustomImage per texture page
    FKerningOn: Boolean;

    procedure LoadPages(const BasePath: string);
    function  KernAmount(first, second: integer): integer;
  public
    constructor Create(Font: TBmFont; const TextureBasePath: string);
    destructor  Destroy; override;
    procedure DrawText(x, y: Integer; const txt: string; col: longword = White);
    property  KerningOn: Boolean read FKerningOn write FKerningOn;
  end;

implementation

procedure TBmFontRenderer.LoadPages(const BasePath: string);
var
  i: Integer;
  fs: TFileStream;
  reader: TFPCustomImageReader;
  fname : string;
begin
  SetLength(FPages, FFont.Pages.Count);
  reader := TFPReaderPNG.Create;      // works for PNG atlases
  try
    for i := 0 to FFont.Pages.Count - 1 do
    begin
      fname:=IncludeTrailingPathDelimiter(BasePath) + FFont.Pages[i].filename;
      fs := TFileStream.Create(fname, fmOpenRead);
      try
        FPages[i] := TFPMemoryImage.Create(0, 0);
        FPages[i].LoadFromStream(fs, reader);
      finally
        fs.Free;
      end;
    end;
  finally
    reader.Free;
  end;
end;

{ ---------- helper: look up kerning pair ---------- }
function TBmFontRenderer.KernAmount(first, second: integer): integer;
var
  i: Integer;
begin
  if not FKerningOn then Exit(0);
  for i := 0 to High(FFont.Kerns) do
    if (FFont.Kerns[i].first = first) and (FFont.Kerns[i].second = second) then
      Exit(FFont.Kerns[i].amount);
  Result := 0;
end;

constructor TBmFontRenderer.Create(Font: TBmFont; const TextureBasePath: string);
begin
  inherited Create;
  FFont      := Font;
  FKerningOn := True;
  LoadPages(TextureBasePath);
end;

destructor TBmFontRenderer.Destroy;
var
  i: Integer;
begin
  for i := 0 to FFont.Pages.Count - 1 do
  begin
    FPages[i].Free;
  end;
  inherited;
end;

procedure TBmFontRenderer.DrawText(x, y: Integer; const txt: string; col: longword);
var
  cx, cy, i, page, dstX, dstY: Integer;
  c: TBmChar;
  kern: integer;
begin
  if not Assigned(FFont) then Exit;
  dstX := x;
  for i := 1 to Length(txt) do
  begin
    c := FFont.GetCharByID(Ord(txt[i]));
    if c.id = 0 then    // missing glyph space
    begin
      dstX := dstX + FFont.Common.LineHeight div 3;
      Continue;
    end;

    // kerning with previous character
    if (i > 1) and FKerningOn then
      dstX := dstX + KernAmount(Ord(txt[i-1]), Ord(txt[i]));

    page := c.page;
    if (page < 0) or (page > High(FPages)) then Continue;

    // destination top-left on screen
    dstX := dstX + c.xo;
    dstY := y + c.yo;

    // copy the glyph rectangle from atlas to screen
    CopyImageRect(
      FPages[page],        // source atlas (TFPMemoryImage)
      c.x, c.y,            // source top-left
      dstX, dstY,          // destination top-left
      c.w, c.h,            // width / height
      128,                 // alpha threshold (0-255)
      col);                // ptcGraph colour tint

    // advance cursor
    dstX := dstX + c.xa - c.xo;   // xa already includes xo
  end;
end;

end.
