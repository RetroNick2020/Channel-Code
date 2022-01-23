program TDictionaryDemo1;

{$APPTYPE CONSOLE}
{$MODE Delphi}

uses Generics.Collections;

var
  Dictionary: TDictionary<string, Integer>;
  n : integer;
begin
  Dictionary := TDictionary<string, Integer>.Create;

  Dictionary.Add('Nick', 5);
  Dictionary.Add('Joe', 10);
  Dictionary.Add('Rick', 15);

 // Dictionary.AddOrSetValue('Nick', 6);
  writeln('count= ',Dictionary.count);

  if Dictionary.trygetvalue('Joe',n) then
  begin
     writeln('n=',n);
  end
  else
  begin
    writeln('not found');
  end;
  readln;
  Dictionary.Free;
end.

