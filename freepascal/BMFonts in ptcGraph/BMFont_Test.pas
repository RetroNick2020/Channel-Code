Program  BMFont_test;
uses ptccrt,ptcGraph,BmFont,BmFontGraph;

var
  Fnt : TBmFont;
  C   : TBmChar;
  Pg  : TBmPage;
  FontRender : TBmFontRenderer;
  gd,gm : smallint;
begin
  gd:=VGA;
  gm:=VGAHI;
  Initgraph(gd,gm,'');

  Fnt := TBmFont.Create;
  Fnt.LoadText('pixantiqua.fnt');

  FontRender :=TBmFontRenderer.Create(Fnt,'E:\Development\MyProjects\LazDemos\BMFonts in ptcGraph');

  FontRender.DrawText(10,10,'This is how we say hello!!!');
  FontRender.DrawText(9,9,'This is how we say hello!!!',Green);

  readln;
  FontRender.Free;
  closegraph;
end.
