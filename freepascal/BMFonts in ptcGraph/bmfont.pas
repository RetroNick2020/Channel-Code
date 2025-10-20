unit BmFont;
{$mode objfpc}{$H+}

interface

uses
   Classes, SysUtils, StrUtils, fgl, Generics.Collections;

type
  TBmInfo = record
     face     : string;
     size     : integer;
     bold     : integer;
     italic   : integer;
     charset  : string;
     unicode  : integer;
     stretchH : integer;
     smooth   : integer;
     aa       : integer;
     padding  : string;
     spacing  : string;
     outline  : integer;
  end;

  TBmCommon = record
    LineHeight : integer;
    Base       : integer;
    Width      : integer;
    Height     : integer;
    pages      : integer;
    ppacked    : integer;
    alphaChnl  : integer;
    redChnl    : integer;
    greenChnl  : integer;
    blueChnl   : integer;
  end;

  TBmPage = record
    id         : integer;
    filename   : string;
  end;

  TBmChar = record
    id          : Integer;  // unicode code-point
    x, y, w, h  : Integer;  // texture rectangle
    xo, yo      : integer;  // x/y offset when drawing
    xa          : Integer;  // x-advance for next glyph
    page        : Integer;
    chnl        : Integer;
  end;

  TBmKern = record
    first, second: integer;
    amount: integer;
  end;

  CharDict = specialize TDictionary<integer, TBmChar>;
  PagesDict = specialize TDictionary<integer, TBmPage>;

  TBmFont = class
  public
    info   : TBmInfo;
    Common : TBmCommon;
    Pages  : PagesDict;               // texture file names
    Chars  : CharDict; // glyph data
    Kerns  : array of TBmKern;          // kerning pairs
    constructor Create;
    destructor  Destroy; override;
    procedure LoadText(const FileName: string);  // .fnt text format
    function  GetCharByID(id: integer): TBmChar;       // fast lookup
    function  GetPageByID(id: integer): TBmPage;
   end;

implementation

constructor TBmFont.Create;
begin
  Pages := PagesDict.Create;
  Chars := CharDict.Create;
end;

destructor TBmFont.Destroy;
begin
  Pages.Free;
  Chars.Free;
  inherited;
end;



procedure TBmFont.LoadText(const FileName: string);
var
  sl: TStringList;
  ln: string;
  p : TStringArray;

  procedure Split(const s: string);
  begin
    p := s.Split([' '], TStringSplitOptions.ExcludeEmpty);
  end;

  function xVal(const key: string; Default: Integer = 0): Integer;
  var
    i: Integer;
    t: string;
  begin
    for i := 0 to High(p) do
    begin
      t := p[i];
      if t.StartsWith(key) then
        Exit(t.Substring(key.Length+1).ToInteger);
    end;
    Result := Default;
  end;

  function sVal(const key: string; Default: String = ''): string;
  var
    i: Integer;
    t: string;
  begin
    for i := 0 to High(p) do
    begin
      t := p[i];
      t := StringReplace(t, '"', '', [rfReplaceAll]); //remove "" from string

      if t.StartsWith(key) then
        Exit(t.Substring(key.Length+1));
    end;
    Result := Default;
  end;


var
  c : TBmChar;
  k : TBmKern;
  pg: TBmPage;
  n : integer;
begin
  sl := TStringList.Create;
  try
    sl.LoadFromFile(FileName);
    for ln in sl do
    begin
      if ln.StartsWith('info') then
      begin
        Split(ln);  //takes lines and converts to TStringArray
        Info.face     := sVal('face');
        Info.size     := xVal('size');
        Info.bold     := xVal('bold');
        Info.italic   := xVal('italic');
        Info.charset  := sVal('charset');
        Info.unicode  := xVal('unicode');
        Info.stretchH := xVal('stretchH');
        Info.smooth:= xVal('smooth');
        Info.aa:= xVal('aa');
        Info.padding:= sVal('padding');
        Info.spacing:= sVal('spacing');
        Info.outline:= xVal('outline');
      end
      else if ln.StartsWith('common') then
      begin
        Split(ln);  //takes lines and converts to TStringArray
        Common.LineHeight := xVal('lineHeight');
        Common.Base       := xVal('base');
        Common.Width      := xVal('scaleW');
        Common.Height     := xVal('scaleH');
        Common.pages      := xVal('pages');
        Common.ppacked    := xVal('packed');
        Common.alphaChnl  := xVal('alphaChnl');
        Common.redChnl    := xVal('redChnl');
        Common.greenChnl  := xVal('greenChnl');
        Common.blueChnl   := xVal('blueChnl');
      end
      else if ln.StartsWith('page') then
      begin
        Split(ln);
        pg.id       := xVal('id');
        pg.filename := sVal('file');
        Pages.AddOrSetValue(pg.id, pg);
      end
      else if ln.StartsWith('char') then
      begin
        Split(ln);
        c.id   := xVal('id');
        c.x    := xVal('x');
        c.y    := xVal('y');
        c.w    := xVal('width');
        c.h    := xVal('height');
        c.xo   := xVal('xoffset');
        c.yo   := xVal('yoffset');
        c.xa   := xVal('xadvance');
        c.page := xVal('page');
        c.chnl := xVal('chnl');
        Chars.AddOrSetValue(c.id, c);
      end
      else if ln.StartsWith('kerning') then
      begin
        Split(ln);
        k.first  := xVal('first');
        k.second := xVal('second');
        k.amount := xVal('amount');
        SetLength(Kerns, Length(Kerns) + 1);
        Kerns[High(Kerns)] := k;
      end;
    end;
  finally
    sl.Free;
  end;
end;

function TBmFont.GetCharByID(id: integer): TBmChar;
begin
  if not Chars.TryGetValue(id, Result) then
    Result := Default(TBmChar);   // zero-filled = missing glyph
end;

function TBmFont.GetPageByID(id: integer): TBmPage;
begin
  if not Pages.TryGetValue(id, Result) then
    Result := Default(TBmPage);
end;


end.

