unit UMain;

interface

uses
  UBancoCodeUS, Data.DB, System.Classes, System.SysUtils, System.IOUtils,
  FMX.ListView, FMX.Objects, FMX.StdCtrls;

type
  TMainController = class
  public
    UsuarioID: integer;
    BancoCodeUS: TBancoCodeUs;
    ListViewLoad: TListView;
    PanelCaixaMensagem: TRoundRect;
    LabelShowMensagem: TLabel;
    ImagemTarefaCompleta: TImage;
    ImagemTarefaPendente: TImage;
    procedure PopularListaDificuldade(Dificuldade: integer);
    procedure AddList(Completa, Resposta, strNome, strPergunta, strResposta01,
      strResposta02, strResposta03, strResposta04: string);
    procedure AddListRanking(strNome: string);
    function RemoveChars(s: string): string;
    procedure MostrarMensagem(MSGText: string);
  end;

implementation

uses
  FMX.ListView.Appearances, FMX.ListView.Types;

procedure TMainController.PopularListaDificuldade(Dificuldade: integer);
var
  ListaDePerguntas: TDataSet;
  Pergunta, RespostaCorreta, Alternativa1, Alternativa2, Alternativa3,
    AlternativaTemporaria: String;
  Alternativas: array [0 .. 3] of String;
  numPergunta, i, randomNum: integer;
begin
  ListaDePerguntas := nil;
  case Dificuldade of
    0:
      ListaDePerguntas := BancoCodeUS.RetornarListaDeQuiz(0)
        .GetClonedDataSet(true);
    1:
      ListaDePerguntas := BancoCodeUS.RetornarListaDeQuiz(1)
        .GetClonedDataSet(true);
    2:
      ListaDePerguntas := BancoCodeUS.RetornarListaDeQuiz(2)
        .GetClonedDataSet(true);
  else
    PopularListaDificuldade(0);
  end;
  numPergunta := 0;
  if ListaDePerguntas <> nil then
  begin
    ListaDePerguntas.First; // Primeiro registro
    numPergunta := Dificuldade * 10;
    while not ListaDePerguntas.Eof do
    begin
      numPergunta := numPergunta + 1;
      Pergunta := ListaDePerguntas.FieldByName('Pergunta').AsString;
      RespostaCorreta := ListaDePerguntas.FieldByName
        ('RespostaCorreta').AsString;
      Alternativa1 := ListaDePerguntas.FieldByName('Alternativa1').AsString;
      Alternativa2 := ListaDePerguntas.FieldByName('Alternativa2').AsString;
      Alternativa3 := ListaDePerguntas.FieldByName('Alternativa3').AsString;

      Alternativas[0] := RespostaCorreta;
      Alternativas[1] := Alternativa1;
      Alternativas[2] := Alternativa2;
      Alternativas[3] := Alternativa3;

      // Embaralhar o array de alternativas
      Randomize; // Inicializa o gerador de números aleatórios
      randomNum := Random(4); // Gera um número aleatório entre 1 e 3

      if randomNum <> 0 then
      begin
        Alternativas[0] := Alternativas[randomNum];
        Alternativas[randomNum] := RespostaCorreta;
      end;

      // Adicionar à lista com alternativas embaralhadas  ABAIXOOOOOOOOOOOOOOOOOOOOO
      AddList('0', randomNum.ToString, numPergunta.ToString, Pergunta,
        Alternativas[0], Alternativas[1], Alternativas[2], Alternativas[3]);

      ListaDePerguntas.Next; // Avança para o próximo registro
    end;

    ListaDePerguntas.Free; // Libera o dataset clonado
  end;
end;

// IDLOCAL 0... //IDD ID DO BANCO //IDNumCupom NUMERO DO CUPOM //strData DATA //strNome NOME //temIcone Icone
procedure TMainController.AddList(Completa, Resposta, strNome, strPergunta,
  strResposta01, strResposta02, strResposta03, strResposta04: string);
var
  item: TListViewItem;
  txt: TListItemText;
  ILoad: integer;
begin

  try
    ListViewLoad.BeginUpdate;

    try
      item := ListViewLoad.Items.Add;
      with item do
      begin
        txt := TListItemText(Objects.FindDrawable('TxtNome'));
        txt.Text := 'Pergunta ' + strNome;

        txt := TListItemText(Objects.FindDrawable('TxtID'));
        txt.Text := Resposta;
        // PERGUNTA
        txt := TListItemText(Objects.FindDrawable('TxtPergunta'));
        txt.Text := strPergunta;
        // RESPOSTA 01
        txt := TListItemText(Objects.FindDrawable('TxtResposta01'));
        txt.Text := strResposta01;
        // RESPOSTA 02
        txt := TListItemText(Objects.FindDrawable('TxtResposta02'));
        txt.Text := strResposta02;
        // RESPOSTA 03
        txt := TListItemText(Objects.FindDrawable('TxtResposta03'));
        txt.Text := strResposta03;
        // RESPOSTA 04
        txt := TListItemText(Objects.FindDrawable('TxtResposta04'));
        txt.Text := strResposta04;

        if NOT BancoCodeUS.acertouResposta(UsuarioID, StrToInt(strNome)) then
          TListItemImage(Objects.FindDrawable('ImgSinc')).Bitmap :=
            ImagemTarefaPendente.Bitmap
        else
          TListItemImage(Objects.FindDrawable('ImgSinc')).Bitmap :=
            ImagemTarefaCompleta.Bitmap;

      end;
    except
      on Ex: Exception do
        // ShowMessage('Error ao add item na listView');
    end;
  finally
    ListViewLoad.EndUpdate;
  end;
end;

procedure TMainController.AddListRanking(strNome: string);
var
  item: TListViewItem;
  txt: TListItemText;
  strPergunta: string;
  ILoad: integer;
begin

  try
    ListViewLoad.BeginUpdate;

    try
      item := ListViewLoad.Items.Add;
      with item do
      begin
        txt := TListItemText(Objects.FindDrawable('TxtNome'));
        txt.Text := strNome;
        strPergunta := strNome;

        txt := TListItemText(Objects.FindDrawable('TxtPergunta'));
        txt.Text := strPergunta;

      end;
    except
      on Ex: Exception do
        // ShowMessage('Error ao add item na listView');
    end;
  finally
    ListViewLoad.EndUpdate;
  end;
end;

function TMainController.RemoveChars(s: string): string;
var
  x: integer;
  sAux: String;
begin
  sAux := '';
  for x := 1 to Length(s) do
    // Aqui eu testo se são caracteres alphanuméricos comuns ou virgula (,)
    if s[x] in ['0' .. '9'] then
      sAux := sAux + s[x];
  Result := sAux;
end;

procedure TMainController.MostrarMensagem(MSGText: string);
begin
  PanelCaixaMensagem.Visible := true;
  LabelShowMensagem.text := MSGText;

  TThread.CreateAnonymousThread(procedure begin
    sleep(4000);
    TThread.Synchronize(nil, procedure begin
    PanelCaixaMensagem.Visible := false;
    end);
  end).start();
end;

end.
