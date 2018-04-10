program uRemoteAccessDemo;

uses
  Forms,
  uRemoteAccessDemoMain in 'uRemoteAccessDemoMain.pas' {frmRemoteAccessDemo};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmRemoteAccessDemo, frmRemoteAccessDemo);
  Application.Run;
end.
