unit UBancoDAO;

interface

uses
  System.SysUtils, System.Classes, System.IOUtils, FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.UI.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.FMXUI.Wait,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat,
  FireDAC.Phys.SQLiteDef, FireDAC.Phys.SQLite, Data.DB, FireDAC.Comp.Client,
  FireDAC.Comp.DataSet, FireDAC.Comp.UI;

type
  TDMBancoDB = class(TDataModule)
    FDQuery: TFDQuery;
    FDConnection: TFDConnection;
    FDPhysSQLiteDriverLink: TFDPhysSQLiteDriverLink;
    FDSQLiteSecurity: TFDSQLiteSecurity;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    procedure DataModuleDestroy(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
  private
    procedure CriarTabela;
    procedure ConectarDB;
  public
    procedure CriptografarBancoDeDados(localBanco: String);
  end;

var
  DMBancoDB: TDMBancoDB;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}
{$R *.dfm}

procedure TDMBancoDB.ConectarDB;
var
  MODOTESTE, existia: boolean;
  CaminhoBanco: String;
begin
  // ATIVAR MODO TESTE
  MODOTESTE := False;
  CaminhoBanco := TPath.Combine(TPath.GetDocumentsPath, 'DBCodeUS.sqlite');
  existia := FileExists(CaminhoBanco);

  // Configurações da conexão FireDAC
  FDConnection.DriverName := 'SQLite';
  FDConnection.Params.DataBase := CaminhoBanco;
  FDConnection.Params.Add('OpenMode=CreateUTF8');
  FDConnection.Params.Add('LockingMode=Normal');
  FDConnection.Params.Add('Synchronous=Full');
  FDConnection.Params.Add('JournalMode=WAL');

  // Defina a senha para acessar o banco de dados criptografado
  FDConnection.Params.Add('U_1NI&P!Pzh$ow9B');

  if not FileExists(CaminhoBanco) then
    CriptografarBancoDeDados(CaminhoBanco);

  // Conectar ao banco de dados
  FDConnection.Connected := True;

  // Garantir que o banco de dados está vazio antes de criar as tabelas
  if FileExists(CaminhoBanco) AND (MODOTESTE OR False) then
  // ZERARDB se for true
  begin
    // Desconectar e excluir o arquivo de banco de dados existente
    FDConnection.Connected := False;
    DeleteFile(CaminhoBanco);
  end;

  // Conectar novamente para criar as tabelas
  FDConnection.Connected := True;
end;

procedure TDMBancoDB.CriarTabela;
begin
  // CRIAR TABELA QUIZ
  FDQuery.SQL.Text := 'CREATE TABLE IF NOT EXISTS Quiz (' +
    'ID INTEGER PRIMARY KEY AUTOINCREMENT, ' + 'Dificuldade INTEGER, ' +
    'Pergunta TEXT, ' + 'RespostaCorreta TEXT, ' + 'Alternativa1 TEXT, ' +
    'Alternativa2 TEXT, ' + 'Alternativa3 TEXT)';
  FDQuery.ExecSQL;

  // CRIAR TABELA USUARIO
  FDQuery.SQL.Text := 'CREATE TABLE IF NOT EXISTS Usuario (' +
    'ID INTEGER PRIMARY KEY AUTOINCREMENT, ' + 'Nome TEXT, ' + 'Senha TEXT)';
  FDQuery.ExecSQL;

  // CRIAR TABELA RESPOSTAS
  FDQuery.SQL.Text := 'CREATE TABLE IF NOT EXISTS Respostas (' +
    'ID INTEGER PRIMARY KEY AUTOINCREMENT, ' + 'IDPergunta INTEGER, ' +
    'IDUsuario INTEGER)';
  FDQuery.ExecSQL;
end;

procedure TDMBancoDB.DataModuleCreate(Sender: TObject);
begin
  // Conectar ao banco de dados e criar as tabelas
  ConectarDB;
  CriarTabela;
end;

procedure TDMBancoDB.DataModuleDestroy(Sender: TObject);
begin
  if DMBancoDB.FDConnection.Connected then
    DMBancoDB.FDConnection.Close;
end;

procedure TDMBancoDB.CriptografarBancoDeDados(localBanco: String);
begin
  // Defina o caminho do banco de dados
  FDSQLiteSecurity.DataBase := localBanco;

  // Defina a senha desejada para criptografar o banco de dados
  FDSQLiteSecurity.Password := 'U_1NI&P!Pzh$ow9B';

  // Criptografa o banco de dados
  FDSQLiteSecurity.SetPassword;
end;

end.
