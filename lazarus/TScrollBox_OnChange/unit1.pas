unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,LMessages;

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
    ScrollBar1: TScrollBar;
    ScrollBox1: TScrollBox;
    procedure FormCreate(Sender: TObject);
    procedure ScrollBar1Change(Sender: TObject);


    procedure WMHScroll(var Message : TLMHScroll);
    procedure WMVScroll(var Message : TLMVScroll);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}


procedure TScrollBox.WMHScroll(var Message : TLMHScroll);
begin
   inherited WMHScroll(Message);
   Form1.WMHScroll(Message);
end;

procedure TScrollBox.WMVScroll(var Message : TLMHScroll);
begin
    inherited WMVScroll(Message);
    Form1.WMVScroll(Message);
end;


{ TForm1 }

procedure TForm1.WMHScroll(var Message : TLMHScroll);
begin
  label2.caption:=inttostr(Message.Pos);
end;

procedure TForm1.WMVScroll(var Message : TLMHScroll);
begin
    label3.caption:=inttostr(Message.Pos);
end;

procedure TForm1.ScrollBar1Change(Sender: TObject);
begin
  label1.Caption:=inttostr(scrollbar1.Position);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  image1.width:=1000;
  image1.height:=1000;
  image1.canvas.Ellipse(0,0,1000,1000);
end;

end.

