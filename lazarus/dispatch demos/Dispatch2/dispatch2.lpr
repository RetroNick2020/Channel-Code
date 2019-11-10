program Dispatch2;

uses
  Classes;

type
  TMsgStr = record
    MsgStr: string[10];
    Data: Pointer;
  end;


  MyClass = class
    procedure MyHandler(var Msg); message 'fire';
  end;

var
  Msg: TMsgStr;
  MyTestClass: MyClass;


  procedure Myclass.MyHandler(var Msg);
  begin
    writeln('From My Handler');
  end;


begin
  MyTestClass := MyClass.Create;
  Msg.MsgStr := 'fire';
  MyTestClass.DispatchStr(Msg);
  readln;
end.
