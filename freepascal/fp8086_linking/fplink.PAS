(* ************************************************************ *)
(* YouTube video https://youtu.be/-HzhSGruX3U                   *)
(* fplink.pas putimage link to exe demo For freepascal 8086     *)
(*                                                              *)
(* FPIMG.XGF was created by Exporting image as putimage file    *)
(* from Raster Master. Borland's Turbo C BGIOBJ can be used to  *)
(* to convert image to obj format. You can also use Turbo Pascal*)
(* BINOBJ to do the same. When using BINOBJ make sure your      *)
(* procedure name is in UPPERCASE                               *)
(* This allows us to link image to exe without creating arrays. *)                             *)
(*                                                              *)
(* BGIOBJ fpimg.xgf fpimg.obj fpimg                             *)
(* or                                                           *)
(* BINOBJ fpimg.xgf fpimg.obj fpimg                             *)
(* ppcross8086 -WmLarge FPLink.PAS                              *)
(*                                                              *)
(* ************************************************************ *)

Program FPLink;
 uses Crt,Graph;

//if using BINOBJ - make sure procedure name is in uppercase
procedure FPIMG;external;
{$L fpimg.obj}

//links BGI font file that has been converted to OBJ file
//BGI font/CHR files are compatible with Freepascal
procedure goth;external;
{$L goth.obj}

var
  ImgBuf : Pointer;
  myfont : integer;
  gd,gm  : integer;
begin
  gd:=EGA;
  gm:=EGAHI;
  initgraph(gd,gm,'');
  myfont:=registerbgifont(@goth);
  SetFillStyle(SolidFill,1);
  Bar(0,0,GetMaxX,GetMaxY);
  ImgBuf:=@fpimg;
  putimage(120,200,ImgBuf^,COPYPUT);
  //putimage(120,200,Pointer(@FPIMG)^,COPYPUT);  // this works also if you want to eliminate temp variable
  SetTextStyle(myfont,HorizDir,10);
  SetColor(White);
  OutTextXY(10,10,'Goth Font');

  readkey;
  closegraph;
end.
