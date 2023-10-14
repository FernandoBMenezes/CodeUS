unit UCodeUS;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.DateTimeCtrls, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.Edit, FMX.ListView, System.IOUtils;

type
  TFCodeUS = class(TForm)
    Painel: TPanel;
    CaixaDados: TRoundRect;
    LblName: TLabel;
    LblTextoPontos: TLabel;
    LblPontos: TLabel;
    lv_Notas: TListView;
    rectGroupName: TRectangle;
    EditNameGroup: TEdit;
    BtnCreate: TButton;
    LblNameGroup: TLabel;
    ImagemTarefaCompleta: TImage;
    ImagemTarefaPendente: TImage;
    PainelPerguntas: TPanel;
    CaixaResposta02: TRoundRect;
    CaixaResposta01: TRoundRect;
    CaixaResposta04: TRoundRect;
    CaixaResposta03: TRoundRect;
    CaixaDePergunta: TRoundRect;
    LblTextoPergunta: TLabel;
    TextoResposta01: TLabel;
    TextoResposta02: TLabel;
    TextoResposta03: TLabel;
    TextoResposta04: TLabel;
    LblPergunta: TLabel;
    LblErrou: TLabel;
    TimerErrou: TTimer;
    Label1: TLabel;
    PainelDificuldades: TPanel;
    CaixaDificuldadeFacil: TRoundRect;
    CaixaDificuldadeDificil: TRoundRect;
    LblFacil: TLabel;
    LblDificil: TLabel;
    PainelBloqueio: TPanel;
    CaixaSeuNome: TRoundRect;
    LblTextoQualSeuNome: TLabel;
    EditNome: TEdit;
    LblDefinirNome: TLabel;
    BotaoConfirmarNome: TCircle;
    PainelSplash: TPanel;
    CaixaSplash: TRoundRect;
    LblTextSplash: TLabel;
    TimerSplash: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure lv_NotasItemClick(const Sender: TObject; const AItem: TListViewItem);
    procedure CaixaResposta01Click(Sender: TObject);
    procedure CaixaResposta02Click(Sender: TObject);
    procedure CaixaResposta03Click(Sender: TObject);
    procedure CaixaResposta04Click(Sender: TObject);
    procedure TimerErrouTimer(Sender: TObject);
    procedure CaixaDificuldadeDificilClick(Sender: TObject);
    procedure CaixaDificuldadeFacilClick(Sender: TObject);
    procedure LblDefinirNomeClick(Sender: TObject);
    procedure TimerSplashTimer(Sender: TObject);
    procedure SaveTXT(sTexts: TStrings; sArquivo: string);
    function readTXT(sArquivo: string): TStrings;
    procedure updateScore(userPoints: string);
  private
    { Private declarations }
  public
    procedure AddList(Completa, IDD, strNome, strPergunta, strResposta01, strResposta02, strResposta03, strResposta04: string);
    { Public declarations }
  end;

var
  FCodeUS: TFCodeUS;
  Pontos: Integer;
  RespostaCerta: String;

implementation

{$R *.fmx}

// IDLOCAL 0... //IDD ID DO BANCO //IDNumCupom NUMERO DO CUPOM //strData DATA //strNome NOME //temIcone Icone
procedure TFCodeUS.AddList(Completa, IDD, strNome, strPergunta, strResposta01, strResposta02, strResposta03, strResposta04: string);
var
  item: TListViewItem;
  txt: TListItemText;
  ILoad: Integer;
begin

  try
    lv_Notas.BeginUpdate;

    try
      item := lv_Notas.Items.Add;
      with item do
      begin
        txt := TListItemText(Objects.FindDrawable('TxtNome'));
        txt.Text := strNome;

        txt := TListItemText(Objects.FindDrawable('TxtID'));
        txt.Text := IDD;
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

        if Completa = '0' then
          TListItemImage(Objects.FindDrawable('ImgSinc')).Bitmap := ImagemTarefaPendente.Bitmap
        else
          TListItemImage(Objects.FindDrawable('ImgSinc')).Bitmap := ImagemTarefaPendente.Bitmap;

      end;
    except
      on Ex: Exception do
        ShowMessage('Error ao add item na listView');
    end;
  finally
    lv_Notas.EndUpdate;
  end;
end;

procedure TFCodeUS.CaixaDificuldadeDificilClick(Sender: TObject);
var
  Pergunta, Resposta0, Resposta1, Resposta2, Resposta3: String;
begin
  // DIFICIL
  lv_Notas.Items.Clear;
  LblDificil.TextSettings.FontColor := TAlphaColors.Blueviolet;
  LblFacil.TextSettings.FontColor := TAlphaColors.Darkgrey;
  Pergunta :=
    'O uso do termo desenvolvimento sustentável tem se tornado recorrente à medida que cresce a preocupação mundial com as questões ambientais. O conceito de desenvolvimento está ligado à';
  Resposta0 := 'A) Conciliação entre os ideais de desenvolvimento econômico e a preservação ambiental.';
  Resposta1 :=
    'B) O uso do termo desenvolvimento sustentável tem se tornado recorrente à medida que cresce a preocupação mundial com as questões ambientais. O conceito de desenvolvimento está ligado à';
  Resposta2 := 'C) Diminuição dos níveis de poluição verificados nas áreas mais industrializadas do mundo.';
  Resposta3 := 'D) Ligação entre os grandes produtores agropecuários e a diminuição do uso de agrotóxicos.';
  AddList('0', '0', 'Questão 06', Pergunta, Resposta0, Resposta1, Resposta2, Resposta3);
  Pergunta :=
    'O Relatório Nosso Futuro Comum, divulgado no ano de 1987, foi o primeiro documento que abordou claramente o conceito de desenvolvimento sustentável. Já o primeiro encontro da Organização das Nações Unidas para a discussão das questões ambientais foi';
  Resposta0 := 'A) A Conferência das Nações Unidas sobre Meio Ambiente Humano.';
  Resposta1 := 'B) A Palestra das Nações Unidas sobre Desenvolvimento Humano Planetário.';
  Resposta2 := 'C) A Conferência das Nações Unidas para o Meio Ambiente e o Desenvolvimento.';
  Resposta3 := 'D) O Acordo de Paris sobre as principais mudanças ambientais globais mundiais.';
  AddList('0', '0', 'Questão 07', Pergunta, Resposta0, Resposta1, Resposta2, Resposta3);
  Pergunta := 'Quais são os três princípios básicos que apoiam o conceito de desenvolvimento sustentável?';
  Resposta0 := 'A) Ambiental, econômico e social.';
  Resposta1 := 'B) Florestal, financeiro e humano.';
  Resposta2 := 'C) Sanitário, humanístico e cultural.';
  Resposta3 := 'D) Humano, financeiro e ambiental.';
  AddList('0', '0', 'Questão 08', Pergunta, Resposta0, Resposta1, Resposta2, Resposta3);
  Pergunta :=
    'As discussões sobre o conceito de desenvolvimento sustentável estão embasadas, em especial, no contexto ambiental. Um dos argumentos que retratam a preocupação com a conservação do meio ambiente está atrelado à';
  Resposta0 := 'A) Finitude da maioria dos recursos naturais.';
  Resposta1 := 'B) Elevação das reservas de água potável.';
  Resposta2 := 'C) Diminuição global da temperatura.';
  Resposta3 := 'D) Imutabilidade dos aspectos climáticos.';
  AddList('0', '0', 'Questão 09', Pergunta, Resposta0, Resposta1, Resposta2, Resposta3);
  Pergunta := 'Assinale a alternativa que NÃO apresenta um dos Objetivos do Desenvolvimento Sustentável (ODS):';
  Resposta0 := 'A) Energia acessível e poluente.';
  Resposta1 := 'B) Educação de qualidade.';
  Resposta2 := 'C) Igualdade de gênero.';
  Resposta3 := 'D) Erradicação da pobreza.';
  AddList('0', '0', 'Questão 10', Pergunta, Resposta0, Resposta1, Resposta2, Resposta3);
  Pergunta := 'Qual alternativa abaixo descreve corretamente a importância do desenvolvimento sustentável:';
  Resposta0 := 'A) Promoção de formas eficientes de manejo dos recursos naturais.';
  Resposta1 := 'B) Preocupação com as perdas ambientais dos países desenvolvidos.';
  Resposta2 := 'C) Atenuação da aplicação de objetivos ambientais para as nações.';
  Resposta3 := 'D) Incentivação do uso de agrotóxicos para produção de alimentos.';
  AddList('0', '0', 'Questão 11', Pergunta, Resposta0, Resposta1, Resposta2, Resposta3);
end;

procedure TFCodeUS.CaixaDificuldadeFacilClick(Sender: TObject);
var
  Pergunta, Resposta0, Resposta1, Resposta2, Resposta3: String;
begin
  // FACIL
  lv_Notas.Items.Clear;
  LblDificil.TextSettings.FontColor := TAlphaColors.Darkgrey;
  LblFacil.TextSettings.FontColor := TAlphaColors.Blueviolet;
  Pergunta := 'Quais são os três princípios básicos que apoiam o conceito de desenvolvimento sustentável?';
  Resposta0 := 'A) Ambiental, econômico e social.';
  Resposta1 := 'B) Florestal, financeiro e humano.';
  Resposta2 := 'C) Sanitário, humanístico e cultural.';
  Resposta3 := 'D) Humano, financeiro e ambiental.';
  AddList('0', '0', 'Questão 00', Pergunta, Resposta0, Resposta1, Resposta2, Resposta3);
  Pergunta :=
    'As discussões sobre o conceito de desenvolvimento sustentável estão embasadas, em especial, no contexto ambiental. Um dos argumentos que retratam a preocupação com a conservação do meio ambiente está atrelado à';
  Resposta0 := 'A) Finitude da maioria dos recursos naturais.';
  Resposta1 := 'B) Elevação das reservas de água potável.';
  Resposta2 := 'C) Diminuição global da temperatura.';
  Resposta3 := 'D) Imutabilidade dos aspectos climáticos.';
  AddList('0', '0', 'Questão 01', Pergunta, Resposta0, Resposta1, Resposta2, Resposta3);
  Pergunta := 'Assinale a alternativa que NÃO apresenta um dos Objetivos do Desenvolvimento Sustentável (ODS):';
  Resposta0 := 'A) Energia acessível e poluente.';
  Resposta1 := 'B) Educação de qualidade.';
  Resposta2 := 'C) Igualdade de gênero.';
  Resposta3 := 'D) Erradicação da pobreza.';
  AddList('0', '0', 'Questão 02', Pergunta, Resposta0, Resposta1, Resposta2, Resposta3);
  Pergunta := 'Qual alternativa abaixo descreve corretamente a importância do desenvolvimento sustentável:';
  Resposta0 := 'A) Promoção de formas eficientes de manejo dos recursos naturais.';
  Resposta1 := 'B) Preocupação com as perdas ambientais dos países desenvolvidos.';
  Resposta2 := 'C) Atenuação da aplicação de objetivos ambientais para as nações.';
  Resposta3 := 'D) Incentivação do uso de agrotóxicos para produção de alimentos.';
  AddList('0', '0', 'Questão 03', Pergunta, Resposta0, Resposta1, Resposta2, Resposta3);
  Pergunta :=
    'O uso do termo desenvolvimento sustentável tem se tornado recorrente à medida que cresce a preocupação mundial com as questões ambientais. O conceito de desenvolvimento está ligado à';
  Resposta0 := 'A) Conciliação entre os ideais de desenvolvimento econômico e a preservação ambiental.';
  Resposta1 :=
    'B) O uso do termo desenvolvimento sustentável tem se tornado recorrente à medida que cresce a preocupação mundial com as questões ambientais. O conceito de desenvolvimento está ligado à';
  Resposta2 := 'C) Diminuição dos níveis de poluição verificados nas áreas mais industrializadas do mundo.';
  Resposta3 := 'D) Ligação entre os grandes produtores agropecuários e a diminuição do uso de agrotóxicos.';
  AddList('0', '0', 'Questão 04', Pergunta, Resposta0, Resposta1, Resposta2, Resposta3);
  Pergunta :=
    'O Relatório Nosso Futuro Comum, divulgado no ano de 1987, foi o primeiro documento que abordou claramente o conceito de desenvolvimento sustentável. Já o primeiro encontro da Organização das Nações Unidas para a discussão das questões ambientais foi';
  Resposta0 := 'A) A Conferência das Nações Unidas sobre Meio Ambiente Humano.';
  Resposta1 := 'B) A Palestra das Nações Unidas sobre Desenvolvimento Humano Planetário.';
  Resposta2 := 'C) A Conferência das Nações Unidas para o Meio Ambiente e o Desenvolvimento.';
  Resposta3 := 'D) O Acordo de Paris sobre as principais mudanças ambientais globais mundiais.';
  AddList('0', '0', 'Questão 05', Pergunta, Resposta0, Resposta1, Resposta2, Resposta3);
end;

procedure TFCodeUS.CaixaResposta01Click(Sender: TObject);
begin
  PainelBloqueio.Visible := true;
  if RespostaCerta.Equals('0') then
  begin
    Pontos := Pontos + 5;
    updateScore(Pontos.ToString);
    LblPontos.Text := Pontos.ToString;
    LblErrou.TextSettings.FontColor := TAlphaColors.Darkgreen;
    LblErrou.Text := '✓';
    LblErrou.Visible := true;
    TimerErrou.Enabled := true;
  end
  else
  begin
    LblErrou.Visible := true;
    TimerErrou.Enabled := true;
  end;
end;

procedure TFCodeUS.CaixaResposta02Click(Sender: TObject);
begin
  PainelBloqueio.Visible := true;
  if RespostaCerta.Equals('1') then
  begin
    Pontos := Pontos + 5;
    updateScore(Pontos.ToString);
    LblPontos.Text := Pontos.ToString;
    LblErrou.TextSettings.FontColor := TAlphaColors.Darkgreen;
    LblErrou.Text := '✓';
    LblErrou.Visible := true;
    TimerErrou.Enabled := true;
  end
  else
  begin
    LblErrou.Visible := true;
    TimerErrou.Enabled := true;
  end;
end;

procedure TFCodeUS.CaixaResposta03Click(Sender: TObject);
begin
  PainelBloqueio.Visible := true;
  if RespostaCerta.Equals('2') then
  begin
    Pontos := Pontos + 5;
    updateScore(Pontos.ToString);
    LblPontos.Text := Pontos.ToString;
    LblErrou.TextSettings.FontColor := TAlphaColors.Darkgreen;
    LblErrou.Text := '✓';
    LblErrou.Visible := true;
    TimerErrou.Enabled := true;
  end
  else
  begin
    LblErrou.Visible := true;
    TimerErrou.Enabled := true;
  end;
end;

procedure TFCodeUS.CaixaResposta04Click(Sender: TObject);
begin
  PainelBloqueio.Visible := true;
  if RespostaCerta.Equals('3') then
  begin
    Pontos := Pontos + 5;
    updateScore(Pontos.ToString);
    LblPontos.Text := Pontos.ToString;
    LblErrou.TextSettings.FontColor := TAlphaColors.Darkgreen;
    LblErrou.Text := '✓';
    LblErrou.Visible := true;
    TimerErrou.Enabled := true;
  end
  else
  begin
    LblErrou.Visible := true;
    TimerErrou.Enabled := true;
  end;
end;

procedure TFCodeUS.FormCreate(Sender: TObject);
begin
  if (readTXT('/UserData.txt').Count <= 0) then
  begin
    PainelBloqueio.Visible := true;
    CaixaSeuNome.Visible := true;
    PainelPerguntas.Visible := False;
  end
  else
  begin
    LblName.Text := 'Ola, ' + readTXT('/UserData.txt')[0] + '.';
    Pontos := readTXT('/UserData.txt')[1].ToInteger;
    LblPontos.Text := readTXT('/UserData.txt')[1];
  end;
  PainelSplash.Visible := true;
  CaixaDificuldadeFacilClick(self);
end;

procedure TFCodeUS.LblDefinirNomeClick(Sender: TObject);
var
  sDocumentos: string;
  memo: TStrings;
begin
  sDocumentos := '/UserData.txt';
  try
    memo := TStringList.Create();
    memo.Add(EditNome.Text);
    memo.Add('0');
    SaveTXT(memo, sDocumentos);
  except
    on E: Exception do
      //
  end;

  LblName.Text := 'Ola, ' + EditNome.Text + '.';
  CaixaSeuNome.Visible := False;
  PainelBloqueio.Visible := False;
end;

procedure TFCodeUS.lv_NotasItemClick(const Sender: TObject; const AItem: TListViewItem);
begin
  LblErrou.Visible := False;
  LblErrou.Text := '✗';
  LblErrou.TextSettings.FontColor := TAlphaColors.Darkred;
  // PERGUNTA
  LblPergunta.Text := TListItemText(AItem.Objects.FindDrawable('TxtPergunta')).Text;
  // RESPOSTA
  TextoResposta01.Text := TListItemText(AItem.Objects.FindDrawable('TxtResposta01')).Text;
  TextoResposta02.Text := TListItemText(AItem.Objects.FindDrawable('TxtResposta02')).Text;
  TextoResposta03.Text := TListItemText(AItem.Objects.FindDrawable('TxtResposta03')).Text;
  TextoResposta04.Text := TListItemText(AItem.Objects.FindDrawable('TxtResposta04')).Text;
  RespostaCerta := TListItemText(AItem.Objects.FindDrawable('TxtID')).Text;
  PainelPerguntas.Visible := true;
end;

procedure TFCodeUS.TimerErrouTimer(Sender: TObject);
begin
  PainelPerguntas.Visible := False;
  PainelBloqueio.Visible := False;
  TimerErrou.Enabled := False;
end;

procedure TFCodeUS.TimerSplashTimer(Sender: TObject);
begin
  TimerSplash.Enabled := False;
  PainelSplash.Visible := False;
end;

procedure TFCodeUS.SaveTXT(sTexts: TStrings; sArquivo: string);
var
  local: String;
begin
  local := System.IOUtils.TPath.GetSharedDocumentsPath;
  sTexts.SaveToFile(local + sArquivo);
end;

function TFCodeUS.readTXT(sArquivo: string): TStrings;
var
  memo: TStrings;
begin
  memo := TStringList.Create();
  try
    if FileExists(System.IOUtils.TPath.GetSharedDocumentsPath + sArquivo) then
      memo.LoadFromFile(System.IOUtils.TPath.GetSharedDocumentsPath + sArquivo);
    Result := memo;
  except
    on E: Exception do
      Result := memo;
  end;
end;

procedure TFCodeUS.updateScore(userPoints: string);
var
  sDocumentos: string;
  memo: TStrings;
begin
  sDocumentos := '/UserData.txt';
  try
    memo := TStringList.Create();
    memo.Add(readTXT('/UserData.txt')[0]);
    memo.Add(userPoints);
    SaveTXT(memo, sDocumentos);
  except
    on E: Exception do
      //
  end;
end;

end.
