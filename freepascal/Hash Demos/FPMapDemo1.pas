program FPMapDemo1;
{$APPTYPE CONSOLE}
{$MODE Delphi}

uses fgl;

var
 Dictionary: TFPGMap<string, Integer>;
 i : integer;
 kv : integer;
begin
  Dictionary := TFPGMap<string, Integer>.Create;

  Dictionary.Add('Nick', 5);
  Dictionary.Add('Joe', 10);
  Dictionary.Add('Rick', 15);

  Dictionary.TryGetData('Nick',kv);
  writeln(kv);
  readln;

  for i:=0 to Dictionary.Count-1 do
  begin
//     writeln(Dictionary.data[i]);
     writeln(Dictionary.Keys[i]);
  end;
  readln;
  for i:=0 to Dictionary.Count-1 do
  begin
      writeln(Dictionary.Keys[i]);
  end;
  readln;
  Dictionary.Free;
end.

