program fpcuswindemo;

uses ptcgraph,ptccrt,windows,JwaWinUser;

//real pixel resolution - no DPI adjustments
procedure GetDesktopScreenSize(var scwidth,scheight : integer);
var
 DesktopHandle : HWND;
begin
  DesktopHandle:=GetDesktopWindow();
  scwidth:=GetDeviceCaps(GetDC(DesktopHandle),DESKTOPHORZRES);
  scheight:=GetDeviceCaps(GetDC(DesktopHandle),DESKTOPVERTRES);
end;

//anythining above 100% setting in Win 10 Scale and Layout setting changes the virtual screen size
procedure GetDesktopVirtualScreenSize(var scwidth,scheight : integer);
var
 DesktopHandle : HWND;
begin
  DesktopHandle:=GetDesktopWindow();
  scwidth:=GetDeviceCaps(GetDC(DesktopHandle),HORZRES);
  scheight:=GetDeviceCaps(GetDC(DesktopHandle),VERTRES);
end;

//scwidth and scheight are the values we get from GetDesktopVirtualScreenSize and GetDesktopScreenSize
//bgiwidth,bhiheight are the values we are going to end up with when performing Initgraph
//initgraph(EGA,EGALo,''); gives us bgiwidth=640, bguheight=350
//winwidth and winheight are values that are returned

Procedure SuggestWindowSize(scwidth,scheight,scpercent : integer;
                            bgiwidth,bgiheight : integer;
                            var winwidth,winheight : integer);
var
 ratio : integer;
begin
 ratio:=bgiheight*1000 div bgiwidth;

 winwidth:=scwidth*scpercent div 100;
 winheight:=winwidth*ratio div 1000;
end;

procedure GetCustomWindowGraph(var AWidth,AHeight : Integer);
var
 nw,nh : integer;
 scx,scy : integer;
begin
  GetDesktopvirtualScreenSize(scx,scy);
  //depending on Inigraph mode you will need to adjust the percentange - 80% seems to work for the modes i tried
  //bgiwidth and bgiheight are the sizes you end up when selecting the graphic device and graphic mode
  //values below when we select EGA and EGAHI
  SuggestWindowSize(scx,scy,80,640,350,nw,nh);

  AWidth:=nw;
  AHeight:=nh;
end;

var
 gd,gm : smallint;

begin
  gd:=ega;
  gm:=egahi;
  InitGraphWindowCustom(@GetCustomWindowGraph);
  initgraph(gd,gm,'');

  setfillstyle(solidfill,green);
  bar(0,0,GetMaxX,GetMaxy);
  setcolor(1);
  circle(100,100,50);
  readkey;
  closegraph;
end.
