program TDictionaryDemo2;

{$APPTYPE CONSOLE}
{$MODE Delphi}

uses Generics.Collections;

type
  CustomClass = record
                  weight : integer;
                  height : integer;
                  eyes   : string;
  end;

var
  Dictionary: TDictionary<string, CustomClass>;
  cc  : CustomClass;

begin
  Dictionary := TDictionary<string, CustomClass>.Create;

///  cc:=CustomClass.Create;
  cc.weight:=150;
  cc.height:=175;
  cc.eyes:='blue';
  Dictionary.Add('Nick', cc);

//  cc:=CustomClass.Create;
  cc.weight:=160;
  cc.height:=155;
  cc.eyes:='brown';
  Dictionary.Add('Joe', cc);

//  cc:=CustomClass.Create;
  cc.weight:=185;
  cc.height:=180;
  cc.eyes:='green';
  Dictionary.Add('Rick', cc);

 cc.weight:=205;
 cc.height:=182;
 cc.eyes:='red';
// Dictionary.AddOrSetValue('Joe', cc); // replaces value if it exists

  writeln('count= ',Dictionary.count);
  if Dictionary.trygetvalue('Nick',cc) then
  begin
     writeln('cc.eyes ',cc.eyes);
     writeln('cc.weight ',cc.weight);

  end
  else
  begin
    writeln('not found');
  end;
  readln;
  Dictionary.Free;
end.

