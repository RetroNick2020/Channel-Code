Program testfill;
 uses graph;


const
  Gray50 : FillPatternType = ($AA, $55, $AA,
    $55, $AA, $55, $AA, $55);


(* Turbo Pascal, Width= 8 Height= 8 Colors= 2 *)

pat2b : Array[1..14] of Byte = (
          $07,$00,$07,$00,$00,$7E,$42,$5A,$5A,$42,$7E,$00,
          $00,$00);

(* Turbo Pascal, Width= 8 Height= 8 Colors= 2 *)

pat2d : Array[1..14] of Byte = (
          $07,$00,$07,$00,$00,$18,$18,$24,$24,$42,$7E,$00,
          $00,$00);


Procedure ImageToPattern(var image; var pat : FillPatternType);
type
 img = array[0..13] of byte;
var
 imgptr : ^img;
 i : integer;
begin
 imgptr:=@image;
 move(imgptr^[4],pat,sizeof(pat));
end;


var
 gd,gm : integer;
 newfill : FillPatternType;
begin
 gd:=ega;
 gm:=egahi;
 initgraph(gd,gm,'c:\tp6\bgi');
 SetFillStyle(bkslashFill,White);
 bar(0,0,100,100);
 readln;
 ImageToPattern(pat2d,newfill);
 SetFillPattern(newfill, White);
 bar(0,0,100,100);
 readln;
end.