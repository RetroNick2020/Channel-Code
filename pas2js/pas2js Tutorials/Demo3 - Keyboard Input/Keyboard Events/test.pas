// Keyboard Event Example
// see video for additional info https://youtu.be/rw5y-r0RFq8

Program test;
  uses browserconsole,Web;

// https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent
// https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent/key/Key_Values

function HandleKeyDown(k : TJSKeyBoardEvent) : Boolean;
begin
  writeln('A key was pressed');
  writeln('code=',k.code);
  writeln('key=',k.Key);
  // pas2js helper class TJSKeyNames.[key value] it corresponds with mozilla key values
  // TJSKeyNames.F1 is the same as 'F1'
  // if k.key = TJSKeyNames.F1 then writeln('you pressed F1');
  //if k.key = 'F1' then writeln('you pressed F1');
  //if k.altkey then writeln('Alt was pressed with this key');
  //if k.ctrlkey then writeln('Control was pressed with this key');
end;

function HandleKeyUp(k : TJSKeyBoardEvent) : Boolean;
begin
  writeln('A key was released');
  writeln('code=',k.code);
  writeln('key=',k.Key);
end;

begin
  writeln('Keyboard Events');
  document.onkeydown:=@HandleKeyDown;
  //document.onkeyup:=@HandleKeyUp;
  //window.onkeydown:=@HandleKeyDown;
end.