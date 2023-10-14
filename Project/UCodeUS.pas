unit UCodeUS;

interface

uses
    System.SysUtils, System.Types, System.UITypes, System.Classes,
    System.Variants,
    FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
    FMX.DateTimeCtrls, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects,
    FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
    FMX.Edit, FMX.ListView, System.IOUtils, Data.DB, Data.SqlExpr;

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
        PainelAlerta: TPanel;
        LabelPainelAlerta: TLabel;
        TimerAlerta: TTimer;
        RoundRectZerarPontos: TRoundRect;
        Label2: TLabel;
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
        procedure TimerAlertaTimer(Sender: TObject);
        procedure RoundRectZerarPontosClick(Sender: TObject);
    private
        { Private declarations }
    public
        procedure AddList(Completa, IDD, strNome, strPergunta,
          strRespostaCorreta, strResposta0, strResposta1, strResposta2: string);
        { Public declarations }
    end;

var
    FCodeUS: TFCodeUS;
    Pontos, AlternativaCerta: Integer;
    RespostaID: String;

implementation

{$R *.fmx}

// IDLOCAL 0... //IDD ID DO BANCO //IDNumCupom NUMERO DO CUPOM //strData DATA //strNome NOME //temIcone Icone
procedure TFCodeUS.AddList(Completa, IDD, strNome, strPergunta,
  strRespostaCorreta, strResposta0, strResposta1, strResposta2: string);
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
                txt := TListItemText
                  (Objects.FindDrawable('TxtRespostaCorreta'));
                txt.Text := 'A) ' + strRespostaCorreta;
                // RESPOSTA 02
                txt := TListItemText(Objects.FindDrawable('TxtResposta0'));
                txt.Text := 'B) ' + strResposta0;
                // RESPOSTA 03
                txt := TListItemText(Objects.FindDrawable('TxtResposta1'));
                txt.Text := 'C) ' + strResposta1;
                // RESPOSTA 04
                txt := TListItemText(Objects.FindDrawable('TxtResposta2'));
                txt.Text := 'D) ' + strResposta2;

                if NOT(IDD.ToInteger * 5 < Pontos) OR (Pontos = 0) then
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
    Pergunta, RespostaCorreta, Resposta0, Resposta1, Resposta2: String;
begin
    if Pontos >= 30 then
    begin
        // DIFICIL
        lv_Notas.Items.Clear;
        LblDificil.TextSettings.FontColor := TAlphaColors.Blueviolet;
        LblFacil.TextSettings.FontColor := TAlphaColors.Darkgrey;

        Pergunta :=
          'O que é um "loop infinito" em programação e por que ele deve ser evitado?';
        RespostaCorreta :=
          'Um loop infinito é um tipo de estrutura que executa repetidamente sem uma condição de parada, deve ser evitado pois pode sobrecarregar o sistema.';
        // CORRETA
        Resposta0 :=
          'Um loop infinito é um tipo de erro que ocorre em linguagens de programação, mas não precisa ser evitado.';
        Resposta1 :=
          'Um loop infinito é um loop que executa apenas uma vez e, portanto, não precisa ser evitado.';
        Resposta2 :=
          'Um loop infinito é uma técnica avançada usada para aumentar o desempenho do código e, portanto, não deve ser evitado.';
        AddList('0', '6', 'Questão 06', Pergunta, RespostaCorreta, Resposta0,
          Resposta1, Resposta2);

        Pergunta := 'O que é um "framework" de desenvolvimento de software?';
        RespostaCorreta :=
          'Um framework é um conjunto de bibliotecas, diretrizes e convenções que auxiliam no desenvolvimento de software';
        // CORRETA
        Resposta0 := 'Um framework é um tipo de erro de programação.';
        Resposta1 :=
          'Um framework é uma linguagem de programação específica para o desenvolvimento web.';
        Resposta2 :=
          'Um framework é um programa que executa automaticamente todo o código do desenvolvimento.';
        AddList('0', '7', 'Questão 07', Pergunta, RespostaCorreta, Resposta0,
          Resposta1, Resposta2);

        Pergunta :=
          'O que é "versionamento de software" e por que é importante?';
        RespostaCorreta :=
          'O versionamento de software é a prática de controlar e registrar as alterações em um sistema ao longo do tempo, importante para rastrear o histórico de edições de cada colaborador.';
        // Correta
        Resposta0 :=
          'O versionamento de software se refere à atualização de hardware em um sistema e não é importante.';
        Resposta1 :=
          'O versionamento de software se refere à criação de versões de um sistema, mas não é importante em desenvolvimento.';
        Resposta2 :=
          'O versionamento de software se refere à criação de novos recursos em um sistema e não é importante.';
        AddList('0', '8', 'Questão 08', Pergunta, RespostaCorreta, Resposta0,
          Resposta1, Resposta2);

        Pergunta := 'O que é "depuração" no contexto da programação?';
        RespostaCorreta :=
          'Depuração é o processo de identificar e corrigir erros (bugs) no código-fonte de um programa.';
        // CORRETA
        Resposta0 :=
          'Depuração é o processo de esconder erros de código para que o programa funcione sem problemas.';
        Resposta1 :=
          'Depuração é o processo de criar código sem testes e verificações.';
        Resposta2 :=
          'Depuração é o processo de copiar e colar código de outros programas.';
        AddList('0', '9', 'Questão 09', Pergunta, RespostaCorreta, Resposta0,
          Resposta1, Resposta2);

        Pergunta :=
          'O que é um "algoritmo de ordenação" e por que diferentes algoritmos de ordenação são usados em desenvolvimento de software?';
        RespostaCorreta :=
          'Um algoritmo de ordenação é um conjunto de regras para classificar dados em uma ordem específica, e diferentes são usados para otimizar o desempenho e a eficiência.';
        // CORRETA
        Resposta0 :=
          'Um algoritmo de ordenação é uma técnica para criar listas de reprodução de músicas em ordem aleatória.';
        Resposta1 :=
          'Algoritmos de ordenação não são usados em desenvolvimento de software.';
        Resposta2 :=
          'Um algoritmo de ordenação é um método para criptografar dados em um sistema de segurança.';
        AddList('0', '10', 'Questão 10', Pergunta, RespostaCorreta, Resposta0,
          Resposta1, Resposta2);

        Pergunta :=
          'O que é "concorrência" e "paralelismo" em programação e qual é a diferença fundamental entre eles?';
        RespostaCorreta :=
          'Concorrência refere-se a executar várias tarefas ao mesmo tempo, e o paralelismo é a execução de uma tarefa por vez.';
        // CORRETA
        Resposta0 :=
          'Concorrência e paralelismo são termos que não se aplicam à programação.';
        Resposta1 :=
          'Concorrência e paralelismo são termos intercambiáveis e não têm diferença fundamental.';
        Resposta2 :=
          'Concorrência é a execução de um único processo de forma eficiente, enquanto o paralelismo é a execução de várias tarefas independentes ao mesmo tempo.';
        AddList('0', '11', 'Questão 11', Pergunta, RespostaCorreta, Resposta0,
          Resposta1, Resposta2);
    end
    else
    begin
        LabelPainelAlerta.Text := 'Mínimo de 30 pontos!';
        PainelAlerta.Visible := true;
        TimerAlerta.Enabled := true;
    end;
end;

procedure TFCodeUS.CaixaDificuldadeFacilClick(Sender: TObject);
var
    Pergunta, RespostaCorreta, Resposta0, Resposta1, Resposta2: String;
begin
    if Pontos < 30 then
    begin
        // FACIL
        lv_Notas.Items.Clear;
        LblDificil.TextSettings.FontColor := TAlphaColors.Darkgrey;
        LblFacil.TextSettings.FontColor := TAlphaColors.Blueviolet;

        Pergunta :=
          'O que é um tipo de dado conhecido como "Integer e Int" em programação?';
        RespostaCorreta := 'Um tipo de dado que representa números inteiros.';
        // CORRETA
        Resposta0 := 'Um tipo de dado que representa textos.';
        Resposta1 :=
          'Um tipo de dado que representa números com casas decimais.';
        Resposta2 :=
          'Um tipo de dado que representa valores verdadeiros ou falsos.';
        AddList('0', '0', 'Questão 00', Pergunta, RespostaCorreta, Resposta0,
          Resposta1, Resposta2);

        Pergunta := 'Para que serve o tipo de dado "Boolean" na programação?';
        RespostaCorreta :=
          'É utilizado para representar valores verdadeiros/true ou falsos/false em lógica de programação.';
        // CORRETA
        Resposta0 := 'É utilizado para representar datas e horas.';
        Resposta1 := 'É utilizado para representar números inteiros.';
        Resposta2 := 'É utilizado para representar valores monetários.';
        AddList('0', '1', 'Questão 01', Pergunta, RespostaCorreta, Resposta0,
          Resposta1, Resposta2);

        Pergunta :=
          'O que é um tipo de dado conhecido como "String" em programação?';
        RespostaCorreta := 'Um tipo de dado que representa textos.'; // CORRETA
        Resposta0 := 'Um tipo de dado que representa números inteiros.';
        Resposta1 :=
          'Um tipo de dado que representa números com casas decimais.';
        Resposta2 :=
          'Um tipo de dado que representa valores verdadeiros ou falsos.';
        AddList('0', '2', 'Questão 02', Pergunta, RespostaCorreta, Resposta0,
          Resposta1, Resposta2);

        Pergunta := 'Para que serve o tipo de dado "Char" na programação?';
        RespostaCorreta :=
          'É utilizado para representar caracteres individuais.';
        // CORRETA
        Resposta0 := 'É utilizado para representar datas e horas.';
        Resposta1 := 'É utilizado para representar números inteiros.';
        Resposta2 :=
          'Um tipo de dado que representa valores verdadeiros ou falsos.';
        AddList('0', '3', 'Questão 03', Pergunta, RespostaCorreta, Resposta0,
          Resposta1, Resposta2);

        Pergunta :=
          'O que é um tipo de dado conhecido como "Double" em programação?';
        RespostaCorreta :=
          'Um tipo de dado que representa números com casas decimais.';
        // CORRETA
        Resposta0 :=
          'Um tipo de dado que representa valores verdadeiros ou falsos.';
        Resposta1 := 'Um tipo de dado que representa textos.';
        Resposta2 := 'Um tipo de dado que representa números inteiros.';
        AddList('0', '4', 'Questão 04', Pergunta, RespostaCorreta, Resposta0,
          Resposta1, Resposta2);

        Pergunta := 'Para que serve o tipo de dado "Array" na programação?';
        RespostaCorreta :=
          'É utilizado para representar uma coleção de elementos.';
        // CORRETA
        Resposta0 := 'É utilizado para representar datas e horas.';
        Resposta1 := 'É utilizado para representar números inteiros.';
        Resposta2 := 'É utilizado para representar valores monetários.';
        AddList('0', '5', 'Questão 05', Pergunta, RespostaCorreta, Resposta0,
          Resposta1, Resposta2);
    end
    else
        CaixaDificuldadeDificilClick(self);
end;

procedure TFCodeUS.CaixaResposta0Click(Sender: TObject);
begin
    PainelBloqueio.Visible := true;
    if AlternativaCerta.ToString.Equals('0') then
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
    CaixaDificuldadeFacilClick(self);
end;

procedure TFCodeUS.CaixaResposta1Click(Sender: TObject);
begin
    PainelBloqueio.Visible := true;
    if AlternativaCerta.ToString.Equals('1') then
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
    CaixaDificuldadeFacilClick(self);
end;

procedure TFCodeUS.CaixaResposta2Click(Sender: TObject);
begin
    PainelBloqueio.Visible := true;
    if AlternativaCerta.ToString.Equals('2') then
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
    CaixaDificuldadeFacilClick(self);
end;

procedure TFCodeUS.CaixaResposta3Click(Sender: TObject);
begin
    PainelBloqueio.Visible := true;
    if AlternativaCerta.ToString.Equals('3') then
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
    CaixaDificuldadeFacilClick(self);
end;

procedure TFCodeUS.FormCreate(Sender: TObject);
begin
    PainelPerguntas.Visible := false;
    RoundRectZerarPontos.Visible := false;
    PainelAlerta.Visible := false;
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
    CaixaSeuNome.Visible := false;
    PainelBloqueio.Visible := false;
end;

procedure TFCodeUS.lv_NotasItemClick(const Sender: TObject;
  const AItem: TListViewItem);
var
    txtTemp: String;
begin
    RespostaID := TListItemText(AItem.Objects.FindDrawable('TxtID')).Text;
    if (RespostaID.ToInteger * 5 = Pontos) then
    begin
        AlternativaCerta := random(3);

        LblErrou.Visible := false;
        LblErrou.Text := '✗';
        LblErrou.TextSettings.FontColor := TAlphaColors.Darkred;

        // PERGUNTA
        LblPergunta.Text :=
          TListItemText(AItem.Objects.FindDrawable('TxtPergunta')).Text;
        // RESPOSTA
        TextoResposta0.Text :=
          TListItemText(AItem.Objects.FindDrawable('TxtRespostaCorreta')).Text;
        TextoResposta1.Text :=
          TListItemText(AItem.Objects.FindDrawable('TxtResposta0')).Text;
        TextoResposta2.Text :=
          TListItemText(AItem.Objects.FindDrawable('TxtResposta1')).Text;
        TextoResposta3.Text :=
          TListItemText(AItem.Objects.FindDrawable('TxtResposta2')).Text;

        if AlternativaCerta = 1 then
        begin
            txtTemp := TextoResposta1.Text;
            TextoResposta1.Text := TextoResposta0.Text;
            TextoResposta0.Text := txtTemp;
        end;

        if AlternativaCerta = 2 then
        begin
            txtTemp := TextoResposta2.Text;
            TextoResposta2.Text := TextoResposta0.Text;
            TextoResposta0.Text := txtTemp;
        end;

        if AlternativaCerta = 3 then
        begin
            txtTemp := TextoResposta3.Text;
            TextoResposta3.Text := TextoResposta0.Text;
            TextoResposta0.Text := txtTemp;
        end;

        PainelPerguntas.Visible := true;
        LblTextoPergunta.Text :=
          TListItemText(AItem.Objects.FindDrawable('TxtNome')).Text;

    end
    else if (RespostaID.ToInteger * 5 < Pontos) then
    begin
        LabelPainelAlerta.Text := 'Respondida corretamente!';
        RoundRectZerarPontos.Visible := true;
        PainelAlerta.Visible := true;
        TimerAlerta.Enabled := true;
    end
    else
    begin
        LabelPainelAlerta.Text := 'Mínimo de ' + (RespostaID.ToInteger * 5)
          .ToString + ' pontos!';
        PainelAlerta.Visible := true;
        TimerAlerta.Enabled := true;
    end;
end;

procedure TFCodeUS.TimerAlertaTimer(Sender: TObject);
begin
    TimerAlerta.Enabled := false;
    PainelAlerta.Visible := false;
    RoundRectZerarPontos.Visible := false;
end;

procedure TFCodeUS.TimerErrouTimer(Sender: TObject);
begin
    PainelPerguntas.Visible := false;
    PainelBloqueio.Visible := false;
    TimerErrou.Enabled := false;
end;

procedure TFCodeUS.TimerSplashTimer(Sender: TObject);
begin
    TimerSplash.Enabled := false;
    PainelSplash.Visible := false;
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

procedure TFCodeUS.RoundRectZerarPontosClick(Sender: TObject);
begin
    updateScore('0');
    CaixaDificuldadeFacilClick(self);
    PainelAlerta.Visible := false;
end;

procedure TFCodeUS.updateScore(userPoints: string);
var
    sDocumentos: string;
    memo: TStrings;
begin
    LblPontos.Text := userPoints;
    try
        Pontos := userPoints.ToInteger();
    except
        on E: Exception do
            Pontos := 0;
    end;
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
