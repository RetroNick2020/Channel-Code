program Dispatch1;

uses
  Classes;

type
  TMsg = record
    MSGID: cardinal;
    Data: Pointer;
  end;


  MyClass = class
    procedure MyHandler(var Msg); message 1;
  end;

var
  Msg : TMsg;
  MyTestClass : MyClass;


  procedure MyClass.MyHandler(var Msg);
  begin
    writeln('From MyHandler');
  end;


begin
  MyTestClass := MyClass.Create;

  Msg.MSGID := 1;
  MyTestClass.Dispatch(Msg);

  readln;
end.
