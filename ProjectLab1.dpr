program ProjectLab1;

uses
  Forms,
  UnitLab1 in 'UnitLab1.pas' {FormMain};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
