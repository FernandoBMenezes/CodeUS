unit URest;

interface

uses System.SysUtils, uRESTDWPoolerDB;

type
  Rest = class(TObject) // Rest.Create({PRECISA PASSAR RESTDWClientSQL});
    procedure AddParamValueStr(param, value: String); // AddParamValueStr({PARAMETRO}, {VALOR_TIPO_STRING});
    procedure AddParamValueInt(param: String; value: Integer); // AddParamValueInt({PARAMETRO}, {VALOR_TIPO_INTEGER});
    function getSQL: String;
    procedure Execute;
    procedure Insert(table: String); // Insert({TABELA});

  private
    restClient: TRESTDWClientSQL;
    modeSQL: String;
    valuesSQL: String;
    paramsSQL: String;
    tableSQL: String;
  public

  published
    Constructor Create(restSQL: TRESTDWClientSQL);

  end;

implementation

uses
  System.Classes;

constructor Rest.Create(restSQL: TRESTDWClientSQL);
begin
  restClient := restSQL;
end;

procedure Rest.AddParamValueStr(param, value: String);
begin
  if ''.IsNullOrEmpty(paramsSQL) AND ''.IsNullOrEmpty(valuesSQL) then
  begin
    paramsSQL := param;
    valuesSQL := '''' + value + '''';
  end
  else
  begin
    paramsSQL := paramsSQL + ', ' + param;
    valuesSQL := valuesSQL + ', ' + '''' + value + '''';
  end;
end;

procedure Rest.AddParamValueInt(param: String; value: Integer);
begin
  if ''.IsNullOrEmpty(paramsSQL) AND ''.IsNullOrEmpty(valuesSQL) then
  begin
    paramsSQL := param;
    valuesSQL := IntToStr(value);
  end
  else
  begin
    paramsSQL := paramsSQL + ', ' + param;
    valuesSQL := valuesSQL + ', ' + IntToStr(value);
  end;
end;

procedure Rest.Insert(table: String);
begin
  tableSQL := table;
  modeSQL := 'insert';
  Execute;
end;

function Rest.getSQL: String;
begin
  result := '';
  if modeSQL = 'insert' then
  begin
    result := 'INSERT INTO ' + tableSQL + ' (' + paramsSQL + ') VALUES (' + valuesSQL + ');';
  end;
end;

procedure Rest.Execute;
var
  memSQL: TStringList;
begin
  with restClient do
  begin
    Close;
    memSQL := SQL;
    restClient.SQL.Clear;
    SQL.Add(getSQL);
    ExecSQL;
    Close;
    SQL.Clear;
    SQL := memSQL;
  end;
end;

end.
