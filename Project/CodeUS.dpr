program CodeUS;

uses
  System.StartUpCopy,
  FMX.Forms,
  UBancoCodeUS in 'Model\UBancoCodeUS.pas',
  UBancoDAO in 'Model\UBancoDAO.pas' {DMBancoDB: TDataModule} ,
  UMain in 'Controller\UMain.pas',
  Main in 'View\Main.pas' {FMain};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFMain, FMain);
  Application.Run;

end.
