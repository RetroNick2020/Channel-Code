unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,LMessages, Types;


const
  LM_CHILDMSG = LM_USER + 1;

type

  TScrollBox = class(Forms.TScrollBox)
    procedure WMHScroll(var Message : TLMHScroll); message LM_HScroll;
    procedure WMVScroll(var Message : TLMVScroll); message LM_VScroll;
  end;
  { TForm1 }

  TForm1 = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    ScrollBar1: TScrollBar;
    ScrollBox1: TScrollBox;
    procedure FormCreate(Sender: TObject);
    procedure Ding(var Message : TLMHScroll);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
      );
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);

    procedure ScrollBar1Change(Sender: TObject);
    procedure ScrollBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ScrollBox1MouseLeave(Sender: TObject);
    procedure ScrollBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ScrollBox1MouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure ScrollBox1MouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure ScrollBox1Paint(Sender: TObject);


    procedure WMHScroll(var Message : TLMHScroll);
    procedure WMVScroll(var Message : TLMVScroll);
  private

  public
    grab : boolean;

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}


procedure TScrollBox.WMHScroll(var Message : TLMHScroll);
var
Form: TCustomForm;

begin
   inherited WMHScroll(Message);
   Form1.WMHScroll(Message);
   //Form := GetFirstParentForm(Self);
   //if Form <> nil then Form.Perform(LM_CHILDMSG, 0, 0);

end;

procedure TScrollBox.WMVScroll(var Message : TLMVScroll);
begin
    inherited WMVScroll(Message);
    Form1.WMVScroll(Message);
end;


{ TForm1 }

procedure TForm1.WMHScroll(var Message : TLMHScroll);
begin
  label2.caption:=inttostr(Message.Pos);
end;

procedure TForm1.WMVScroll(var Message : TLMVScroll);
begin
    label3.caption:=inttostr(Message.Pos);
end;

procedure TForm1.ScrollBar1Change(Sender: TObject);
begin
  label1.Caption:=inttostr(scrollbar1.Position);
end;

procedure TForm1.ScrollBox1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
end;

procedure TForm1.ScrollBox1MouseLeave(Sender: TObject);
begin

end;

procedure TForm1.ScrollBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  label5.Caption:=inttostr(x)+' '+inttostr(y);
end;

procedure TForm1.ScrollBox1MouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  handled:=false;
  Label5.Caption:='Wheel down';
end;

procedure TForm1.ScrollBox1MouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin

  Label5.Caption:='Wheel up';
end;

procedure TForm1.ScrollBox1Paint(Sender: TObject);
begin
  ScrollBox1.canvas.Draw(0,0,image1.Picture.Bitmap);
end;

procedure TForm1.Ding(var Message : TLMHScroll);
begin
  //Msg.
  label1.Caption:='Ding';
end;

procedure TForm1.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 grab:=true;
end;

procedure TForm1.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if grab then
  begin
    image1.Left:=x;
    image1.Top:=y;
  end;
  label4.Caption:=inttostr(x)+' '+inttostr(y);
end;

procedure TForm1.Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  grab:=false;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
//  scrollbox1.Width:=1000;
//  scrollbox1.height:=1000;
  image1.width:=1000;
  image1.height:=1000;
  image1.canvas.Ellipse(0,0,1000,1000);
  grab:=false;
end;

end.

