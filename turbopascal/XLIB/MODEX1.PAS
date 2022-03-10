(* Conversion procedure to go from LBM to PBM format in DOS XLIB   *)
(* XLIB provides this function in asm - i thought it is easier to  *)
(* understand in just standard turbo pascal                        *)
(* NOTE: Did not study asm code to figure out algorithm - asm code *)
(* might be doing things differently                               *)
(* Date: March 9 - 2022                                            *)

Program modex1;

(* Linear to Planar conversion *)
procedure LBMToPBM(var source, dest);
type
 BMRec = record
            width,height : byte;
            buf : array[1..10000] of byte;
          end;
var
 sptr,dptr    : ^BMRec;
 i,j,r,offset : integer;
 width,height : integer;
begin
 sptr:=@source;
 dptr:=@dest;

 width:=sptr^.width;
 height:=sptr^.height;

 dptr^.width:=width div 4;
 dptr^.height:=height;

 offset:=1;
 for r:=0 to 3 do
 begin
   for j:=0 to height-1 do
   begin
     for i:=0 to (width div 4)-1 do
     begin
       dptr^.buf[offset]:=sptr^.buf[j*width+i*4+r+1];
       inc(offset);
     end;
   end;
 end;
end;

begin
end.