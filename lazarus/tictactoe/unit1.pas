unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  ComCtrls, StdCtrls, LCLType;

type

  { TForm1 }

  TForm1 = class(TForm)
    NewGame: TButton;
    QuitGame: TButton;
    O9: TLabel;
    O1: TLabel;
    O2: TLabel;
    O3: TLabel;
    O4: TLabel;
    O5: TLabel;
    O6: TLabel;
    O7: TLabel;
    O8: TLabel;
    X9: TLabel;
    X2: TLabel;
    X3: TLabel;
    X4: TLabel;
    X5: TLabel;
    X6: TLabel;
    X7: TLabel;
    X8: TLabel;
    PlayerTurnLabel: TLabel;
    X1: TLabel;

    VBar1: TShape;
    POS6: TShape;
    POS7: TShape;
    POS8: TShape;
    POS9: TShape;
    VBar2: TShape;
    HBar1: TShape;
    HBar2: TShape;
    POS1: TShape;
    POS2: TShape;
    POS3: TShape;
    POS4: TShape;
    POS5: TShape;
    ToolBar: TToolBar;

    procedure QuitGameClick(Sender: TObject);
    procedure NewGameClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure StartNewGame;
    procedure POSMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    PlayerTurn : string;
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.POSMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Sender = POS1 then
  begin
    if PlayerTurn = 'X' then X1.Visible:=true else O1.Visible:=true;
  end
  else if Sender = POS2 then
  begin
    if PlayerTurn = 'X' then X2.Visible:=true else O2.Visible:=true;
  end
  else if Sender = POS3 then
  begin
    if PlayerTurn = 'X' then X3.Visible:=true else O3.Visible:=true;
  end
  else if Sender = POS4 then
  begin
    if PlayerTurn = 'X' then X4.Visible:=true else O4.Visible:=true;
  end
  else if Sender = POS5 then
  begin
    if PlayerTurn = 'X' then X5.Visible:=true else O5.Visible:=true;
  end
  else if Sender = POS6 then
  begin
    if PlayerTurn = 'X' then X6.Visible:=true else O6.Visible:=true;
  end
  else if Sender = POS7 then
  begin
    if PlayerTurn = 'X' then X7.Visible:=true else O7.Visible:=true;
  end
  else if Sender = POS8 then
  begin
    if PlayerTurn = 'X' then X8.Visible:=true else O8.Visible:=true;
  end
  else if Sender = POS9 then
  begin
    if PlayerTurn = 'X' then X9.Visible:=true else O9.Visible:=true;
  end;
  if PlayerTurn = 'X' then PlayerTurn:='O' else PlayerTurn:='X';
  PlayerTurnLabel.caption:='PLAYER '+PlayerTurn+' TURN';
end;


procedure TForm1.FormCreate(Sender: TObject);
begin
  StartNewGame;
end;

procedure TForm1.NewGameClick(Sender: TObject);
begin
  StartNewGame;
end;

procedure TForm1.StartNewGame;
begin
  PlayerTurn :='X'; //x
  PlayerTurnLabel.caption:='PLAYER '+PlayerTurn+' TURN';
  X1.Visible:=false;
  X2.Visible:=false;
  X3.Visible:=false;
  X4.Visible:=false;
  X5.Visible:=false;
  X6.Visible:=false;
  X7.Visible:=false;
  X8.Visible:=false;
  X9.Visible:=false;
  O1.Visible:=false;
  O2.Visible:=false;
  O3.Visible:=false;
  O4.Visible:=false;
  O5.Visible:=false;
  O6.Visible:=false;
  O7.Visible:=false;
  O8.Visible:=false;
  O9.Visible:=false;
end;

procedure TForm1.QuitGameClick(Sender: TObject);
begin
  Close;
end;


end.

