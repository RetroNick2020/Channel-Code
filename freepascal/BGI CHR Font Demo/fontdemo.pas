program fontdemo;

uses ptcgraph,ptccrt;
{$I goth.inc}

var
 gd,gm : smallint;
 myfont : smallint;
begin
  gd:=Vga;
  gm:=Vgahi;
  myfont:=installuserfont('K');

  initgraph(gd,gm,'E:\DOSBOX\TP7\BGI');
  //myfont:=registerbgifont(@goth);

  setfillstyle(solidfill,blue);
  bar(0,0,GetMaxX,GetMaxy);
  SetTextStyle(myfont,HorizDir,10);
  SetColor(Red);
  OutTextXY(10,10,'B');
  readkey;
  closegraph;
end.
