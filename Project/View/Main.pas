unit Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.DateTimeCtrls, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.Edit, FMX.ListView, System.IOUtils, UBancoCodeUS, UMain, FMX.Layouts;

type
  TFMain = class(TForm)
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
    CaixaResposta1: TRoundRect;
    CaixaResposta0: TRoundRect;
    CaixaResposta3: TRoundRect;
    CaixaResposta2: TRoundRect;
    CaixaDePergunta: TRoundRect;
    LblTextoPergunta: TLabel;
    TextoResposta0: TLabel;
    TextoResposta1: TLabel;
    TextoResposta2: TLabel;
    TextoResposta3: TLabel;
    LblPergunta: TLabel;
    LblErrou: TLabel;
    TimerErrou: TTimer;
    LabelInfoSecondTitle: TLabel;
    PainelDificuldades: TPanel;
    PanelCaixaLogin: TRoundRect;
    LblDefinirNome: TLabel;
    BotaoConfirmarNome: TCircle;
    PainelSplash: TPanel;
    CaixaSplash: TRoundRect;
    LblTextSplash: TLabel;
    TimerSplash: TTimer;
    CaixaDificuldadeDificil: TRoundRect;
    LblDificil: TLabel;
    CaixaDificuldadeFacil: TRoundRect;
    LblFacil: TLabel;
    CaixaDificuldadeMedio: TRoundRect;
    LblMedio: TLabel;
    GridPanelLayout1: TGridPanelLayout;
    LblTextoQualSeuNome: TLabel;
    LabelSenha: TLabel;
    EditNome: TEdit;
    EditSenha: TEdit;
    PainelBloqueio: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButtonRanking: TSpeedButton;
    LabelRankingTitle: TLabel;
    PanelCaixaMensagem: TRoundRect;
    GridPanelLayout2: TGridPanelLayout;
    LabelShowMensagem: TLabel;
    ButtonCircleOKMSG: TCircle;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure lv_NotasItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure CaixaRespostaClick(Sender: TObject);
    procedure TimerErrouTimer(Sender: TObject);
    procedure CaixaDificuldadeDificilClick(Sender: TObject);
    procedure CaixaDificuldadeFacilClick(Sender: TObject);
    procedure LblDefinirNomeClick(Sender: TObject);
    procedure TimerSplashTimer(Sender: TObject);
    procedure CaixaDificuldadeMedioClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ButtonExitClick(Sender: TObject);
    procedure SpeedButtonRankingClick(Sender: TObject);
    procedure ButtonCircleOKMSGClick(Sender: TObject);
  private
    { Private declarations }
  public
    MainController: TMainController;
    BancoCodeUS: TBancoCodeUs;
    { Public declarations }
  end;

var
  FMain: TFMain;
  Pontos: integer;
  RespostaCerta: String;
  UsuarioID, PerguntaID: integer;

implementation

uses
  Data.DB;

{$R *.fmx}

procedure TFMain.CaixaDificuldadeFacilClick(Sender: TObject);
var
  Pergunta, Resposta0, Resposta1, Resposta2, Resposta3: String;
begin
  LabelRankingTitle.Visible := false;
  // FACIL
  lv_Notas.Items.Clear;
  LblDificil.TextSettings.FontColor := TAlphaColors.Darkgrey;
  LblMedio.TextSettings.FontColor := TAlphaColors.Darkgrey;
  LblFacil.TextSettings.FontColor := TAlphaColors.Blueviolet;

  // Perguntas
  MainController.PopularListaDificuldade(0);
end;

procedure TFMain.CaixaDificuldadeMedioClick(Sender: TObject);
var
  Pergunta, Resposta0, Resposta1, Resposta2, Resposta3: String;
begin
  LabelRankingTitle.Visible := false;
  // MEDIO
  lv_Notas.Items.Clear;
  LblDificil.TextSettings.FontColor := TAlphaColors.Darkgrey;
  LblFacil.TextSettings.FontColor := TAlphaColors.Darkgrey;
  LblMedio.TextSettings.FontColor := TAlphaColors.Blueviolet;

  // Perguntas
  MainController.PopularListaDificuldade(1);
end;

procedure TFMain.ButtonCircleOKMSGClick(Sender: TObject);
begin
  PanelCaixaMensagem.Visible := false;
end;

procedure TFMain.ButtonExitClick(Sender: TObject);
begin
  PainelBloqueio.Visible := true;
  EditNome.Text := '';
  EditSenha.Text := '';
  LblPontos.Text := '0';
  LblName.Text := 'CODE US';
  lv_Notas.Items.Clear;
  PanelCaixaLogin.Visible := true;
end;

procedure TFMain.CaixaDificuldadeDificilClick(Sender: TObject);
var
  Pergunta, Resposta0, Resposta1, Resposta2, Resposta3: String;
begin
  LabelRankingTitle.Visible := false;
  // DIFICIL
  lv_Notas.Items.Clear;
  LblFacil.TextSettings.FontColor := TAlphaColors.Darkgrey;
  LblMedio.TextSettings.FontColor := TAlphaColors.Darkgrey;
  LblDificil.TextSettings.FontColor := TAlphaColors.Blueviolet;

  // Perguntas
  MainController.PopularListaDificuldade(2);
end;

procedure TFMain.CaixaRespostaClick(Sender: TObject);
var
  getRoundName: String;
  getToInt, dificuldade: integer;
begin
  dificuldade := Trunc(PerguntaID / 10);
  if (Sender.ClassType = TRoundRect) then
  begin
    getRoundName := MainController.RemoveChars((Sender as TRoundRect).Name);
    getToInt := StrToInt(getRoundName);
  end;

  PainelBloqueio.Visible := true;
  if RespostaCerta.Equals(getToInt.ToString) then
  begin
    BancoCodeUS.marcarAcertoResposta(UsuarioID, PerguntaID);
    Pontos := BancoCodeUS.retornarTotalPontos(UsuarioID);
    LblPontos.Text := Pontos.ToString;
    LblErrou.TextSettings.FontColor := TAlphaColors.Darkgreen;
    LblErrou.Text := '✓';
    LblErrou.Visible := true;
    TimerErrou.Enabled := true;
    lv_Notas.Items.Clear;
    case dificuldade of
      0:
        CaixaDificuldadeFacilClick(nil);
      1:
        CaixaDificuldadeMedioClick(nil);
      2:
        CaixaDificuldadeDificilClick(nil);
    end;
  end
  else
  begin
    LblErrou.Visible := true;
    TimerErrou.Enabled := true;
  end;
end;

procedure TFMain.FormCreate(Sender: TObject);
begin
  BancoCodeUS := TBancoCodeUs.Create();
  MainController := TMainController.Create();
  MainController.BancoCodeUS := self.BancoCodeUS;
  MainController.ListViewLoad := self.lv_Notas;
  MainController.PanelCaixaMensagem := PanelCaixaMensagem;
  MainController.LabelShowMensagem := LabelShowMensagem;
  MainController.ImagemTarefaCompleta := self.ImagemTarefaCompleta;
  MainController.ImagemTarefaPendente := self.ImagemTarefaPendente;

  PainelBloqueio.Visible := true;
  PanelCaixaLogin.Visible := true;
  PainelPerguntas.Visible := false;

  PainelSplash.Visible := true;
end;

procedure TFMain.FormShow(Sender: TObject);
begin
{$IFDEF ANDROID}
  EditNome.TextSettings.FontColor := TAlphaColors.White;
  EditSenha.TextSettings.FontColor := TAlphaColors.White;
{$ENDIF}
  // SOLICITAR LOGIN
  PanelCaixaLogin.Visible := true;
end;

procedure TFMain.LblDefinirNomeClick(Sender: TObject);
var
  sDocumentos, SenhaUsuario, NomeUsuario: string;
  memo: TStrings;
begin
  NomeUsuario := EditNome.Text;
  SenhaUsuario := EditSenha.Text;
  if ''.IsNullOrEmpty(NomeUsuario.Trim) then begin
    MainController.MostrarMensagem('Login ou Senha Inválidos!');
    Exit;
  end;

  if BancoCodeUS.existeUsuario(NomeUsuario) then
  begin
    UsuarioID := BancoCodeUS.verificarUsuario(NomeUsuario, SenhaUsuario);
    if (UsuarioID > 0) then
    begin
      MainController.UsuarioID := UsuarioID;

      LblName.Text := 'Ola, ' + EditNome.Text + '.';
      Pontos := BancoCodeUS.retornarTotalPontos(UsuarioID);
      LblPontos.Text := IntToStr(Pontos);

      PanelCaixaLogin.Visible := false;
      PainelBloqueio.Visible := false;
      CaixaDificuldadeFacilClick(self);
      MainController.MostrarMensagem('Olá ' + EditNome.Text);
    end
    else
    begin
      MainController.MostrarMensagem('Login ou Senha Incorretos!');
    end;
  end
  else
  begin
    BancoCodeUS.inserirUsuario(NomeUsuario, SenhaUsuario);
    LblName.Text := 'Ola, ' + EditNome.Text + '.';
    Pontos := 0;
    LblPontos.Text := IntToStr(Pontos);

    PanelCaixaLogin.Visible := false;
    PainelBloqueio.Visible := false;

    UsuarioID := BancoCodeUS.verificarUsuario(NomeUsuario, SenhaUsuario);
    MainController.UsuarioID := UsuarioID;
    CaixaDificuldadeFacilClick(self);
    MainController.MostrarMensagem('Olá ' + EditNome.Text);
  end;
end;

procedure TFMain.lv_NotasItemClick(const Sender: TObject;
  const AItem: TListViewItem);
var
  Pergunta: String;
begin
  LblErrou.Visible := false;
  LblErrou.Text := '✗';
  LblErrou.TextSettings.FontColor := TAlphaColors.Darkred;
  Pergunta := TListItemText(AItem.Objects.FindDrawable('TxtNome'))
    .Text.Replace('Pergunta ', '');

  PerguntaID := StrToInt(Pergunta);

  // PERGUNTA
  LblPergunta.Text := TListItemText
    (AItem.Objects.FindDrawable('TxtPergunta')).Text;
  // RESPOSTA
  TextoResposta0.Text := 'A) ' + TListItemText
    (AItem.Objects.FindDrawable('TxtResposta01')).Text;
  TextoResposta1.Text := 'B) ' + TListItemText
    (AItem.Objects.FindDrawable('TxtResposta02')).Text;
  TextoResposta2.Text := 'C) ' + TListItemText
    (AItem.Objects.FindDrawable('TxtResposta03')).Text;
  TextoResposta3.Text := 'D) ' + TListItemText
    (AItem.Objects.FindDrawable('TxtResposta04')).Text;
  RespostaCerta := TListItemText(AItem.Objects.FindDrawable('TxtID')).Text;
  PainelPerguntas.Visible := true;
end;

procedure TFMain.SpeedButtonRankingClick(Sender: TObject);
begin
  // DIFICIL
  lv_Notas.Items.Clear;
  LblFacil.TextSettings.FontColor := TAlphaColors.Darkgrey;
  LblMedio.TextSettings.FontColor := TAlphaColors.Darkgrey;
  LblDificil.TextSettings.FontColor := TAlphaColors.Darkgrey;

  LabelRankingTitle.Visible := true;

  MainController.AddListRanking('1º Fernando - '+ Pontos.ToString +' Pontos');
end;

procedure TFMain.TimerErrouTimer(Sender: TObject);
begin
  PainelPerguntas.Visible := false;
  PainelBloqueio.Visible := false;
  TimerErrou.Enabled := false;
end;

procedure TFMain.TimerSplashTimer(Sender: TObject);
begin
  TimerSplash.Enabled := false;
  PainelSplash.Visible := false;
end;

end.
