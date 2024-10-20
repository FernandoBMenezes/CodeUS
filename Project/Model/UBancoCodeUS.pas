unit UBancoCodeUS;

interface

uses
        UBancoDAO, Data.DB;

type
        TBancoCodeUS = class
        public
                constructor Create;
                destructor Destroy; override;
                procedure PreencherQuiz;
                procedure InserirPergunta(Dificuldade: Integer;
                  Pergunta, Resposta, Alternativa1, Alternativa2,
                  Alternativa3: string);
                function RetornarListaDeQuiz(Dificuldade: Integer): TDataSet;
                function verificarUsuario(Nome, Senha: string): Integer;
                function existeUsuario(Nome: string): boolean;
                function inserirUsuario(Nome, Senha: string): boolean;
                procedure marcarAcertoResposta(IDUsuario, IDPergunta: Integer);
                function retornarTotalPontos(IDUsuario: Integer): Integer;
                function acertouResposta(IDUsuario,
                  IDPergunta: Integer): boolean;
        end;

implementation

uses
        System.SysUtils;

{ TBancoCodeUS }

constructor TBancoCodeUS.Create;
begin
        inherited Create;
        DMBancoDB := TDMBancoDB.Create(nil); // Cria o objeto DMBancoDB
        PreencherQuiz;
end;

destructor TBancoCodeUS.Destroy;
begin
        DMBancoDB.Free; // Libera o objeto DMBancoDB
        inherited Destroy;
end;

procedure TBancoCodeUS.InserirPergunta(Dificuldade: Integer;
  Pergunta, Resposta, Alternativa1, Alternativa2, Alternativa3: string);
begin
        with DMBancoDB.FDQuery do
        begin
                SQL.Text :=
                  'INSERT INTO Quiz (Dificuldade, Pergunta, RespostaCorreta, Alternativa1, Alternativa2, Alternativa3) '
                  + 'VALUES (:Dificuldade, :Pergunta, :RespostaCorreta, :Alternativa1, :Alternativa2, :Alternativa3)';

                // Definindo os par�metros para a consulta SQL
                ParamByName('Dificuldade').AsInteger := Dificuldade;
                ParamByName('Pergunta').AsString := Pergunta;
                ParamByName('RespostaCorreta').AsString := Resposta;
                ParamByName('Alternativa1').AsString := Alternativa1;
                ParamByName('Alternativa2').AsString := Alternativa2;
                ParamByName('Alternativa3').AsString := Alternativa3;

                // Executando a consulta
                ExecSQL;
                Close;
        end;
end;

function TBancoCodeUS.RetornarListaDeQuiz(Dificuldade: Integer): TDataSet;
begin
        with DMBancoDB do
        begin
                FDQuery.SQL.Text :=
                  'SELECT * FROM Quiz WHERE Dificuldade = :Dificuldade ORDER BY ID ASC';

                // Definindo os par�metros para a consulta SQL
                FDQuery.ParamByName('Dificuldade').AsInteger := Dificuldade;

                FDQuery.Open;

                Result := FDQuery.GetClonedDataSet(true);
                FDQuery.Close;
        end;
end;

function TBancoCodeUS.verificarUsuario(Nome, Senha: string): Integer;
begin
        Result := 0; // valor padr�o

        with DMBancoDB.FDQuery do
        begin
                SQL.Text :=
                  'SELECT ID FROM Usuario WHERE Nome LIKE :Nome AND Senha = :Senha';
                ParamByName('Nome').AsString := Nome;
                ParamByName('Senha').AsString := Senha;
                Open;

                // Verifica se encontrou algum usu�rio com o nome e senha
                Result := FieldByName('ID').AsInteger;
                // Retorna o ID do usu�rio
                Close;
        end;
end;

function TBancoCodeUS.existeUsuario(Nome: string): boolean;
begin
        Result := False; // valor padr�o

        with DMBancoDB.FDQuery do
        begin
                SQL.Text := 'SELECT ID FROM Usuario WHERE Nome LIKE :Nome';
                ParamByName('Nome').AsString := Nome;
                Open;

                Result := RecordCount > 0;
                Close;
        end;
end;

function TBancoCodeUS.inserirUsuario(Nome, Senha: string): boolean;
begin
        Result := False; // valor padr�o

        // Primeiro, verifica se o usu�rio j� existe
        if verificarUsuario(Nome, Senha) = 0 then
        begin
                with DMBancoDB.FDQuery do
                begin
                        SQL.Text :=
                          'INSERT INTO Usuario (Nome, Senha) VALUES (:Nome, :Senha)';
                        ParamByName('Nome').AsString := Nome;
                        ParamByName('Senha').AsString := Senha;

                        try
                                ExecSQL;
                                Result := true; // usu�rio inserido com sucesso
                        except
                                Result := False; // falha ao inserir o usu�rio
                        end;
                        Close;
                end;
        end;
end;

procedure TBancoCodeUS.marcarAcertoResposta(IDUsuario, IDPergunta: Integer);
begin
        with DMBancoDB.FDQuery do
        begin
                SQL.Text :=
                  'INSERT INTO Respostas (IDUsuario, IDPergunta) VALUES (:IDUsuario, :IDPergunta)';
                ParamByName('IDUsuario').AsInteger := IDUsuario;
                ParamByName('IDPergunta').AsInteger := IDPergunta;
                ExecSQL;
                Close;
        end;
end;

function TBancoCodeUS.acertouResposta(IDUsuario, IDPergunta: Integer): boolean;
begin
        with DMBancoDB.FDQuery do
        begin
                SQL.Text :=
                  'SELECT ID FROM Respostas WHERE IDUsuario = :IDUsuario AND IDPergunta = :IDPergunta';
                ParamByName('IDUsuario').AsInteger := IDUsuario;
                ParamByName('IDPergunta').AsInteger := IDPergunta;
                Open;
                Result := RecordCount > 0;
                Close;
        end;
end;

function TBancoCodeUS.retornarTotalPontos(IDUsuario: Integer): Integer;
begin
        Result := 0;
        with DMBancoDB.FDQuery do
        begin
                SQL.Text :=
                  'SELECT (COUNT(ID)* 5) as Pontos FROM Respostas WHERE IDUsuario = :IDUsuario GROUP BY IDPergunta;';
                ParamByName('IDUsuario').AsInteger := IDUsuario;
                try
                        Open;
                        Result := RecordCount * 5;
                except
                        on E: Exception do
                                Result := 0;
                end;
                Close;
        end;
end;

procedure TBancoCodeUS.PreencherQuiz;
var
        Pergunta, RespostaCorreta, Alternativa1, Alternativa2,
          Alternativa3: String;
begin
        // DIFICULDADE FACIL
        // Pergunta 1
        Pergunta := 'O que � uma String em programa��o?';
        RespostaCorreta := 'Um tipo de dado que armazena texto.';
        Alternativa1 := 'Um tipo de dado que armazena n�meros inteiros.';
        Alternativa2 := 'Um tipo de dado que armazena valores booleanos.';
        Alternativa3 := 'Um tipo de dado que armazena n�meros decimais.';
        InserirPergunta(0, Pergunta, RespostaCorreta, Alternativa1,
          Alternativa2, Alternativa3);
        // Pergunta 2
        Pergunta := 'O que � uma vari�vel?';
        RespostaCorreta := 'Um espa�o na mem�ria para armazenar dados.';
        Alternativa1 := 'Um valor constante.';
        Alternativa2 := 'Uma fun��o que retorna valores.';
        Alternativa3 := 'Um tipo de dado booleano.';
        InserirPergunta(0, Pergunta, RespostaCorreta, Alternativa1,
          Alternativa2, Alternativa3);
        // Pergunta 3
        Pergunta := 'O que representa e armazena True ou False na programa��o?';
        RespostaCorreta := 'Boolean.';
        Alternativa1 := 'Inteiro.';
        Alternativa2 := 'String.';
        Alternativa3 := 'Char.';
        InserirPergunta(0, Pergunta, RespostaCorreta, Alternativa1,
          Alternativa2, Alternativa3);
        // Pergunta 4
        Pergunta := 'O que � um n�mero inteiro em programa��o?';
        RespostaCorreta := 'Um n�mero sem casas decimais.';
        Alternativa1 := 'Um n�mero com casas decimais.';
        Alternativa2 := 'Uma letra ou caractere.';
        Alternativa3 := 'Uma sequ�ncia de texto.';
        InserirPergunta(0, Pergunta, RespostaCorreta, Alternativa1,
          Alternativa2, Alternativa3);
        // Pergunta 5
        Pergunta := 'O que � um loop em programa��o?';
        RespostaCorreta := 'Uma estrutura que repete um bloco de c�digo.';
        Alternativa1 := 'Uma fun��o que imprime dados.';
        Alternativa2 := 'Uma vari�vel que armazena texto.';
        Alternativa3 := 'Um operador matem�tico.';
        InserirPergunta(0, Pergunta, RespostaCorreta, Alternativa1,
          Alternativa2, Alternativa3);
        // Pergunta 6
        Pergunta := 'Qual operador � usado para atribuir valor a uma vari�vel?';
        RespostaCorreta := '=';
        Alternativa1 := '==';
        Alternativa2 := '!=';
        Alternativa3 := '&&';
        InserirPergunta(0, Pergunta, RespostaCorreta, Alternativa1,
          Alternativa2, Alternativa3);
        // Pergunta 7
        Pergunta := 'O que significa a sigla IDE em programa��o?';
        RespostaCorreta := 'Integrated Development Environment';
        Alternativa1 := 'Internal Development Environment';
        Alternativa2 := 'Internal Data Editor';
        Alternativa3 := 'Integrated Data Environment';
        InserirPergunta(0, Pergunta, RespostaCorreta, Alternativa1,
          Alternativa2, Alternativa3);
        // Pergunta 8
        Pergunta :=
          'Qual das op��es abaixo � um exemplo de linguagem de programa��o?';
        RespostaCorreta := 'JavaScript';
        Alternativa1 := 'HTML';
        Alternativa2 := 'CSS';
        Alternativa3 := 'JSON';
        InserirPergunta(0, Pergunta, RespostaCorreta, Alternativa1,
          Alternativa2, Alternativa3);
        // Pergunta 9
        Pergunta := 'Qual das alternativas abaixo representa uma condicional?';
        RespostaCorreta := 'if-else';
        Alternativa1 := 'for';
        Alternativa2 := 'while';
        Alternativa3 := 'switch';
        InserirPergunta(0, Pergunta, RespostaCorreta, Alternativa1,
          Alternativa2, Alternativa3);
        // Pergunta 10
        Pergunta :=
          'O que faz a fun��o print em muitas linguagens de programa��o?';
        RespostaCorreta := 'Exibe dados na tela ou console.';
        Alternativa1 := 'Imprime documentos em papel.';
        Alternativa2 := 'Calcula valores matem�ticos.';
        Alternativa3 := 'Salva dados em um arquivo.';
        InserirPergunta(0, Pergunta, RespostaCorreta, Alternativa1,
          Alternativa2, Alternativa3);

        // DIFICULDADE MEDIO
        // Pergunta 11
        Pergunta := 'O que � um array?';
        RespostaCorreta :=
          'Uma estrutura de dados que armazena m�ltiplos valores.';
        Alternativa1 := 'Uma estrutura de dados que armazena um �nico valor.';
        Alternativa2 := 'Uma fun��o que executa opera��es matem�ticas.';
        Alternativa3 := 'Um tipo de dado booleano.';
        InserirPergunta(1, Pergunta, RespostaCorreta, Alternativa1,
          Alternativa2, Alternativa3);
        // Pergunta 12
        Pergunta :=
          'Qual operador l�gico � usado para representar "E" em express�es booleanas?';
        RespostaCorreta := 'AND';
        Alternativa1 := 'OR';
        Alternativa2 := '==';
        Alternativa3 := '!=';
        InserirPergunta(1, Pergunta, RespostaCorreta, Alternativa1,
          Alternativa2, Alternativa3);
        // Pergunta 13
        Pergunta := 'O que � uma fun��o?';
        RespostaCorreta :=
          'Um bloco de c�digo que executa uma tarefa espec�fica e pode retornar um valor.';
        Alternativa1 := 'Um operador matem�tico.';
        Alternativa2 := 'Uma vari�vel constante.';
        Alternativa3 := 'Um tipo de dado.';
        InserirPergunta(1, Pergunta, RespostaCorreta, Alternativa1,
          Alternativa2, Alternativa3);
        // Pergunta 14
        Pergunta := 'Qual das op��es abaixo representa um tipo de loop?';
        RespostaCorreta := 'while';
        Alternativa1 := 'if-else';
        Alternativa2 := 'switch';
        Alternativa3 := 'bool';
        InserirPergunta(1, Pergunta, RespostaCorreta, Alternativa1,
          Alternativa2, Alternativa3);
        // Pergunta 15
        Pergunta := 'O que faz a fun��o return em uma fun��o?';
        RespostaCorreta := 'Finaliza a fun��o e retorna um valor.';
        Alternativa1 := 'Envia um email.';
        Alternativa2 := 'Armazena dados em uma vari�vel.';
        Alternativa3 := 'Imprime um valor na tela.';
        InserirPergunta(1, Pergunta, RespostaCorreta, Alternativa1,
          Alternativa2, Alternativa3);
        // Pergunta 16
        Pergunta := 'O que � um operador relacional?';
        RespostaCorreta := 'Um operador que compara dois valores.';
        Alternativa1 := 'Um operador que realiza opera��es matem�ticas.';
        Alternativa2 := 'Um operador que concatena strings.';
        Alternativa3 := 'Um operador que manipula arrays.';
        InserirPergunta(1, Pergunta, RespostaCorreta, Alternativa1,
          Alternativa2, Alternativa3);
        // Pergunta 17
        Pergunta := 'Como voc� declararia uma vari�vel inteira chamada idade?';
        RespostaCorreta := 'int idade = 25;';
        Alternativa1 := 'int idade = "25";';
        Alternativa2 := 'String idade = 25;';
        Alternativa3 := 'bool idade = true;';
        InserirPergunta(1, Pergunta, RespostaCorreta, Alternativa1,
          Alternativa2, Alternativa3);
        // Pergunta 18
        Pergunta := 'O que � uma estrutura condicional?';
        RespostaCorreta :=
          'Uma estrutura que permite a execu��o de c�digo com base em uma condi��o.';
        Alternativa1 :=
          'Uma estrutura que repete um bloco de c�digo v�rias vezes.';
        Alternativa2 := 'Um tipo de dado complexo.';
        Alternativa3 := 'Uma fun��o que retorna sempre o mesmo valor.';
        InserirPergunta(1, Pergunta, RespostaCorreta, Alternativa1,
          Alternativa2, Alternativa3);
        // Pergunta 19
        Pergunta :=
          'Qual � o valor final de x ap�s a execu��o de x = (5 + 2) * 3?';
        RespostaCorreta := '21';
        Alternativa1 := '2';
        Alternativa2 := '11';
        Alternativa3 := '16';
        InserirPergunta(1, Pergunta, RespostaCorreta, Alternativa1,
          Alternativa2, Alternativa3);
        // Pergunta 20
        Pergunta :=
          'Qual das alternativas abaixo representa uma estrutura de dados n�o linear?';
        RespostaCorreta := '�rvore';
        Alternativa1 := 'Array';
        Alternativa2 := 'Lista';
        Alternativa3 := 'Fila';
        InserirPergunta(1, Pergunta, RespostaCorreta, Alternativa1,
          Alternativa2, Alternativa3);

        // DIFICULDADE DIFICIL
        // Pergunta 21
        Pergunta := 'O que � recurs�o em programa��o?';
        RespostaCorreta := 'Um processo onde uma fun��o chama a si mesma.';
        Alternativa1 := 'Uma estrutura de dados n�o linear.';
        Alternativa2 := 'Uma t�cnica de otimiza��o de c�digo.';
        Alternativa3 := 'Uma fun��o que n�o retorna nenhum valor.';
        InserirPergunta(2, Pergunta, RespostaCorreta, Alternativa1,
          Alternativa2, Alternativa3);
        // Pergunta 22
        Pergunta :=
          'Qual das op��es abaixo descreve uma t�cnica de busca bin�ria?';
        Alternativa1 := 'Busca sequencial em uma lista desordenada.';
        RespostaCorreta := 'Divis�o da lista ao meio at� encontrar o elemento.';
        Alternativa2 := 'Ordena��o de uma lista utilizando compara��es.';
        Alternativa3 := 'Busca por aproxima��o em um conjunto de valores.';
        InserirPergunta(2, Pergunta, RespostaCorreta, Alternativa1,
          Alternativa2, Alternativa3);
        // Pergunta 23
        Pergunta := 'O que � um ponteiro em linguagens como C ou C++?';
        Alternativa1 := 'Um tipo de dado que armazena valores inteiros.';
        Alternativa2 := 'Um tipo de loop que percorre uma cole��o.';
        Alternativa3 := 'Um operador l�gico que compara dois valores.';
        RespostaCorreta :=
          'Um tipo de dado que armazena o endere�o de mem�ria de uma vari�vel.';
        InserirPergunta(2, Pergunta, RespostaCorreta, Alternativa1,
          Alternativa2, Alternativa3);
        // Pergunta 24
        Pergunta :=
          'Qual � a principal diferen�a entre programa��o orientada a objetos e programa��o procedural?';
        Alternativa1 :=
          'Programa��o orientada a objetos � mais eficiente em termos de tempo de execu��o do que programa��o procedural.';
        Alternativa2 :=
          'Programa��o orientada a objetos utiliza vari�veis globais, enquanto programa��o procedural utiliza apenas vari�veis locais.';
        Alternativa3 :=
          'Programa��o orientada a objetos n�o permite heran�a, enquanto programa��o procedural permite.';
        RespostaCorreta :=
          'Programa��o orientada a objetos organiza o c�digo em torno de dados e fun��es, enquanto programa��o procedural organiza o c�digo em torno de fun��es e procedimentos.';
        InserirPergunta(2, Pergunta, RespostaCorreta, Alternativa1,
          Alternativa2, Alternativa3);
        // Pergunta 25
        Pergunta := 'O que � um deadlock em sistemas operacionais?';
        Alternativa1 := 'Um processo que termina sua execu��o sem erros.';
        RespostaCorreta :=
          'Uma condi��o onde dois ou mais processos ficam eternamente bloqueados.';
        Alternativa2 :=
          'Um estado onde o sistema n�o consegue alocar mais mem�ria.';
        Alternativa3 := 'Um loop infinito causado por um erro l�gico.';
        InserirPergunta(2, Pergunta, RespostaCorreta, Alternativa1,
          Alternativa2, Alternativa3);
        // Pergunta 26
        Pergunta :=
          'Qual � o objetivo principal da normaliza��o em bancos de dados relacionais?';
        Alternativa1 :=
          'Reduzir a redund�ncia e melhorar a integridade dos dados.';
        Alternativa2 :=
          'Aumentar a complexidade das consultas para otimizar o desempenho.';
        Alternativa3 :=
          'Permitir que tabelas tenham m�ltiplas chaves prim�rias.';
        RespostaCorreta :=
          'Garantir que todas as tabelas tenham um n�mero igual de colunas.';
        InserirPergunta(2, Pergunta, RespostaCorreta, Alternativa1,
          Alternativa2, Alternativa3);
        // Pergunta 27
        Pergunta :=
          'O que � um sistema de gerenciamento de banco de dados (SGBD)?';
        RespostaCorreta := 'Um conjunto de programas para manipular dados.';
        Alternativa1 := 'Um software que armazena c�digo fonte.';
        Alternativa2 := 'Um sistema de backup de arquivos.';
        Alternativa3 := 'Uma ferramenta de desenvolvimento integrado.';
        InserirPergunta(2, Pergunta, RespostaCorreta, Alternativa1,
          Alternativa2, Alternativa3);
        // Pergunta 28
        Pergunta :=
          'Qual � a principal caracter�stica de uma lista ligada (linked list)?';
        Alternativa1 := 'Armazena elementos em �ndices sequenciais.';
        RespostaCorreta :=
          'Cada elemento aponta para o pr�ximo elemento da lista.';
        Alternativa2 := 'Armazena elementos de forma cont�nua na mem�ria.';
        Alternativa3 := 'Cada elemento � acessado diretamente pelo �ndice.';
        InserirPergunta(2, Pergunta, RespostaCorreta, Alternativa1,
          Alternativa2, Alternativa3);
        // Pergunta 29
        Pergunta :=
          'Qual das op��es abaixo representa um paradigma de programa��o funcional?';
        Alternativa1 := 'Programa��o orientada a objetos.';
        Alternativa2 := 'Programa��o imperativa.';
        Alternativa3 := 'Programa��o l�gica.';
        RespostaCorreta := 'Programa��o funcional.';
        InserirPergunta(2, Pergunta, RespostaCorreta, Alternativa1,
          Alternativa2, Alternativa3);
        // Pergunta 30
        Pergunta :=
          'O que � o conceito de polimorfismo em programa��o orientada a objetos?';
        Alternativa1 :=
          'A capacidade de uma fun��o ter v�rios nomes diferentes.';
        Alternativa2 :=
          'A capacidade de uma classe herdar de v�rias classes ao mesmo tempo.';
        RespostaCorreta := 'A capacidade de um objeto assumir v�rias formas.';
        Alternativa3 :=
          'A capacidade de uma classe ter m�ltiplos m�todos com o mesmo nome.';
        InserirPergunta(2, Pergunta, RespostaCorreta, Alternativa1,
          Alternativa2, Alternativa3);
end;

end.
