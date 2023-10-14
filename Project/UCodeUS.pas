unit UCodeUS;

interface

uses
    System.SysUtils, System.Types, System.UITypes, System.Classes,
    System.Variants,
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
        Image1: TImage;
        procedure FormCreate(Sender: TObject);
        procedure lv_NotasItemClick(const Sender: TObject;
          const AItem: TListViewItem);
        procedure CaixaResposta0Click(Sender: TObject);
        procedure CaixaResposta1Click(Sender: TObject);
        procedure CaixaResposta2Click(Sender: TObject);
        procedure CaixaResposta3Click(Sender: TObject);
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
        procedure AddList(Completa, IDD, strNome, strPergunta, strResposta01,
          strResposta02, strResposta03, strResposta04: string);
        { Public declarations }
    end;

var
    FCodeUS: TFCodeUS;
    Pontos: Integer;
    RespostaCerta: String;

implementation

{$R *.fmx}

// IDLOCAL 0... //IDD ID DO BANCO //IDNumCupom NUMERO DO CUPOM //strData DATA //strNome NOME //temIcone Icone
procedure TFCodeUS.AddList(Completa, IDD, strNome, strPergunta, strResposta01,
  strResposta02, strResposta03, strResposta04: string);
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
                    TListItemImage(Objects.FindDrawable('ImgSinc')).Bitmap :=
                      ImagemTarefaPendente.Bitmap
                else
                    TListItemImage(Objects.FindDrawable('ImgSinc')).Bitmap :=
                      ImagemTarefaCompleta.Bitmap;

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
      'O que é um "loop infinito" em programação e por que ele deve ser evitado?';
    Resposta0 :=
      'A) Um loop infinito é um tipo de erro que ocorre em linguagens de programação, mas não precisa ser evitado.';
    Resposta1 :=
      'B) Um loop infinito é um tipo de estrutura que executa repetidamente sem uma condição de parada, deve ser evitado pois pode sobrecarregar o sistema.';
    Resposta2 :=
      'C) Um loop infinito é um loop que executa apenas uma vez e, portanto, não precisa ser evitado.';
    Resposta3 :=
      'D) Um loop infinito é uma técnica avançada usada para aumentar o desempenho do código e, portanto, não deve ser evitado.';
    AddList('0', '1', 'Questão 06', Pergunta, Resposta0, Resposta1, Resposta2,
      Resposta3);

    Pergunta :=
      'O que é um "framework" de desenvolvimento de software?';
    Resposta0 :=
      'A) Um framework é um conjunto de bibliotecas, diretrizes e convenções que auxiliam no desenvolvimento de software';//CORRETA
    Resposta1 :=
      'B) Um framework é um tipo de erro de programação.';
    Resposta2 :=
      'C) Um framework é uma linguagem de programação específica para o desenvolvimento web.';
    Resposta3 :=
      'D) Um framework é um programa que executa automaticamente todo o código do desenvolvimento.';
    AddList('0', '0', 'Questão 07', Pergunta, Resposta0, Resposta1, Resposta2,
      Resposta3);

    Pergunta :=
      'O que é "versionamento de software" e por que é importante?';
    Resposta0 :=
      'A) O versionamento de software se refere à atualização de hardware em um sistema e não é importante.';
    Resposta1 :=
      'B) O versionamento de software é a prática de controlar e registrar as alterações em um sistema ao longo do tempo, o que é importante para rastrear o histórico, colaborar com outros desenvolvedores e evitar problemas.';
    Resposta2 :=
      'C) O versionamento de software se refere à criação de versões de um sistema, mas não é importante em desenvolvimento.';
    Resposta3 :=
      'D) O versionamento de software se refere à criação de novos recursos em um sistema e não é importante.';
    AddList('0', '1', 'Questão 08', Pergunta, Resposta0, Resposta1, Resposta2,
      Resposta3);

    Pergunta :=
      'O que é "depuração" no contexto da programação?';
    Resposta0 :=
      'A) Depuração é o processo de esconder erros de código para que o programa funcione sem problemas.';
    Resposta1 :=
      'B) Depuração é o processo de criar código sem testes e verificações.';
    Resposta2 :=
      'C) Depuração é o processo de identificar e corrigir erros (bugs) no código-fonte de um programa.';//CORRETA
    Resposta3 :=
      'D) Depuração é o processo de copiar e colar código de outros programas.';
    AddList('0', '2', 'Questão 09', Pergunta, Resposta0, Resposta1, Resposta2,
      Resposta3);

    Pergunta :=
      'O que é um "algoritmo de ordenação" e por que diferentes algoritmos de ordenação são usados em desenvolvimento de software?';
    Resposta0 :=
      'A) Um algoritmo de ordenação é uma técnica para criar listas de reprodução de músicas em ordem aleatória.';
    Resposta1 :=
      'B) Algoritmos de ordenação não são usados em desenvolvimento de software.';
    Resposta2 :=
      'C) Um algoritmo de ordenação é um conjunto de regras para classificar dados em uma ordem específica, e diferentes são usados para otimizar o desempenho e a eficiência.';//CORRETA
    Resposta3 :=
      'D) Um algoritmo de ordenação é um método para criptografar dados em um sistema de segurança.';
    AddList('0', '2', 'Questão 10', Pergunta, Resposta0, Resposta1, Resposta2,
      Resposta3);

    Pergunta :=
      'O que é "concorrência" e "paralelismo" em programação e qual é a diferença fundamental entre eles?';
    Resposta0 :=
      'A) Concorrência e paralelismo são termos que não se aplicam à programação.';
    Resposta1 :=
      'B) Concorrência refere-se a executar várias tarefas ao mesmo tempo, e o paralelismo é a execução de uma tarefa por vez.';//CORRETA
    Resposta2 :=
      'C) Concorrência e paralelismo são termos intercambiáveis e não têm diferença fundamental.';
    Resposta3 :=
      'D) Concorrência é a execução de um único processo de forma eficiente, enquanto o paralelismo é a execução de várias tarefas independentes ao mesmo tempo.';
    AddList('0', '1', 'Questão 11', Pergunta, Resposta0, Resposta1, Resposta2,
      Resposta3);
end;

procedure TFCodeUS.CaixaDificuldadeFacilClick(Sender: TObject);
var
    Pergunta, Resposta0, Resposta1, Resposta2, Resposta3: String;
begin
    // FACIL
    lv_Notas.Items.Clear;
    LblDificil.TextSettings.FontColor := TAlphaColors.Darkgrey;
    LblFacil.TextSettings.FontColor := TAlphaColors.Blueviolet;

    Pergunta :=
      'O que é um tipo de dado conhecido como "Integer e Int" em programação?';
    Resposta0 := 'A) Um tipo de dado que representa números inteiros.';
    // CORRETA
    Resposta1 := 'B) Um tipo de dado que representa textos.';
    Resposta2 :=
      'C) Um tipo de dado que representa números com casas decimais.';
    Resposta3 :=
      'D) Um tipo de dado que representa valores verdadeiros ou falsos.';
    AddList('1', '0', 'Questão 00', Pergunta, Resposta0, Resposta1, Resposta2,
      Resposta3);

    Pergunta := 'Para que serve o tipo de dado "Boolean" na programação?';
    Resposta0 := 'A) É utilizado para representar datas e horas.';
    Resposta1 := 'B) É utilizado para representar números inteiros.';
    Resposta2 :=
      'C) É utilizado para representar valores verdadeiros/true ou falsos/false em lógica de programação.';
    // CORRETA
    Resposta3 := 'D) É utilizado para representar valores monetários.';
    AddList('0', '2', 'Questão 01', Pergunta, Resposta0, Resposta1, Resposta2,
      Resposta3);

    Pergunta :=
      'O que é um tipo de dado conhecido como "String" em programação?';
    Resposta0 := 'A) Um tipo de dado que representa números inteiros.';
    Resposta1 := 'B) Um tipo de dado que representa textos.'; // CORRETA
    Resposta2 :=
      'C) Um tipo de dado que representa números com casas decimais.';
    Resposta3 :=
      'D) Um tipo de dado que representa valores verdadeiros ou falsos.';
    AddList('0', '1', 'Questão 02', Pergunta, Resposta0, Resposta1, Resposta2,
      Resposta3);

    Pergunta := 'Para que serve o tipo de dado "Char" na programação?';
    Resposta0 := 'A) É utilizado para representar datas e horas.';
    Resposta1 := 'B) É utilizado para representar números inteiros.';
    Resposta2 := 'C) É utilizado para representar caracteres individuais.';
    // CORRETA
    Resposta3 :=
      'D) Um tipo de dado que representa valores verdadeiros ou falsos.';
    AddList('0', '2', 'Questão 03', Pergunta, Resposta0, Resposta1, Resposta2,
      Resposta3);

    Pergunta :=
      'O que é um tipo de dado conhecido como "Double" em programação?';
    Resposta0 :=
      'A) Um tipo de dado que representa números com casas decimais.';
    // CORRETA
    Resposta1 :=
      'B) Um tipo de dado que representa valores verdadeiros ou falsos.';
    Resposta2 := 'C) Um tipo de dado que representa textos.';
    Resposta3 := 'D) Um tipo de dado que representa números inteiros.';
    AddList('0', '0', 'Questão 04', Pergunta, Resposta0, Resposta1, Resposta2,
      Resposta3);

    Pergunta := 'Para que serve o tipo de dado "Array" na programação?';
    Resposta0 := 'A) É utilizado para representar datas e horas.';
    Resposta1 := 'B) É utilizado para representar números inteiros.';
    Resposta2 := 'C) É utilizado para representar valores monetários.';
    Resposta3 := 'D) É utilizado para representar uma coleção de elementos.';
    // CORRETA
    AddList('0', '3', 'Questão 05', Pergunta, Resposta0, Resposta1, Resposta2,
      Resposta3);
end;

procedure TFCodeUS.CaixaResposta0Click(Sender: TObject);
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

procedure TFCodeUS.CaixaResposta1Click(Sender: TObject);
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

procedure TFCodeUS.CaixaResposta2Click(Sender: TObject);
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

procedure TFCodeUS.CaixaResposta3Click(Sender: TObject);
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
    PainelPerguntas.Visible := False;
    if (readTXT('/UserData.txt').Count <= 0) then
    begin
        PainelBloqueio.Visible := true;
        CaixaSeuNome.Visible := true;

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

procedure TFCodeUS.lv_NotasItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
    LblErrou.Visible := False;
    LblErrou.Text := '✗';
    LblErrou.TextSettings.FontColor := TAlphaColors.Darkred;
    // PERGUNTA
    LblPergunta.Text := TListItemText
      (AItem.Objects.FindDrawable('TxtPergunta')).Text;
    // RESPOSTA
    TextoResposta01.Text :=
      TListItemText(AItem.Objects.FindDrawable('TxtResposta01')).Text;
    TextoResposta02.Text :=
      TListItemText(AItem.Objects.FindDrawable('TxtResposta02')).Text;
    TextoResposta03.Text :=
      TListItemText(AItem.Objects.FindDrawable('TxtResposta03')).Text;
    TextoResposta04.Text :=
      TListItemText(AItem.Objects.FindDrawable('TxtResposta04')).Text;
    RespostaCerta := TListItemText(AItem.Objects.FindDrawable('TxtID')).Text;
    PainelPerguntas.Visible := true;
    LblTextoPergunta.Text :=
      TListItemText(AItem.Objects.FindDrawable('TxtNome')).Text;
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
        if FileExists(System.IOUtils.TPath.GetSharedDocumentsPath + sArquivo)
        then
            memo.LoadFromFile(System.IOUtils.TPath.GetSharedDocumentsPath +
              sArquivo);
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
