program CodeUS;

uses
  System.StartUpCopy,
  FMX.Forms,
  UCodeUS in 'UCodeUS.pas' {FCodeUS};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFCodeUS, FCodeUS);
  Application.Run;

end.
