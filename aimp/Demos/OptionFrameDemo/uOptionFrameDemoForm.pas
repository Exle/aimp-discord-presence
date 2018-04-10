unit uOptionFrameDemoForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, AIMPCustomPlugin, StdCtrls;

type
  TfrmOptionFrameDemo = class(TForm)
    Button1: TButton;
    CheckBox1: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
  private
    FOnModified: TNotifyEvent;
    procedure DoModified;
  public
    procedure ApplyLocalization;
    procedure ConfigLoad;
    procedure ConfigSave;
    //
    property OnModified: TNotifyEvent read FOnModified write FOnModified;
  end;

implementation

{$R *.dfm}

{ TfrmOptionFrameDemo }

procedure TfrmOptionFrameDemo.ApplyLocalization;
begin
  // do something
end;

procedure TfrmOptionFrameDemo.ConfigLoad;
begin
  // do something
end;

procedure TfrmOptionFrameDemo.ConfigSave;
begin
  // do something
end;

procedure TfrmOptionFrameDemo.DoModified;
begin
  if Assigned(OnModified) then
    OnModified(Self);
end;

procedure TfrmOptionFrameDemo.Button1Click(Sender: TObject);
begin
  MessageDlg('Clicked!', mtInformation, [mbOK], 0);
end;

procedure TfrmOptionFrameDemo.CheckBox1Click(Sender: TObject);
begin
  DoModified;
end;

end.
