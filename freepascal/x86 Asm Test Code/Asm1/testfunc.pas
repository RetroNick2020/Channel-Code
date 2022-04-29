(*
compile nasm -f obj myfunc.asm myfunc.obj
*)

Program testfunc;
 uses myfunc;
var
 n1,n2,r1 : integer;
 r2 : longint;
begin

  PassN(10,n2);
  writeln('PassN n2=',n2);

  n1:=10;
  n2:=20;
  ChangeN(n1,n2);
  WriteLn('ChangeN n1=',n1,' n2=',n2);

  r1:=ReturnN(30);
  WriteLn('ReturnN Result=',r1);

  r2:=ReturnN2(30);
  WriteLn('ReturnN Long Result Result=',r2 SHR 16);

end.
