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

                // Definindo os parâmetros para a consulta SQL
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

                // Definindo os parâmetros para a consulta SQL
                FDQuery.ParamByName('Dificuldade').AsInteger := Dificuldade;

                FDQuery.Open;

                Result := FDQuery.GetClonedDataSet(true);
                FDQuery.Close;
        end;
end;

function TBancoCodeUS.verificarUsuario(Nome, Senha: string): Integer;
begin
        Result := 0; // valor padrão

        with DMBancoDB.FDQuery do
        begin
                SQL.Text :=
                  'SELECT ID FROM Usuario WHERE Nome LIKE :Nome AND Senha = :Senha';
                ParamByName('Nome').AsString := Nome;
                ParamByName('Senha').AsString := Senha;
                Open;

                // Verifica se encontrou algum usuário com o nome e senha
                Result := FieldByName('ID').AsInteger;
                // Retorna o ID do usuário
                Close;
        end;
end;

function TBancoCodeUS.existeUsuario(Nome: string): boolean;
begin
        Result := False; // valor padrão

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
        Result := False; // valor padrão

        // Primeiro, verifica se o usuário já existe
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
                                Result := true; // usuário inserido com sucesso
                        except
                                Result := False; // falha ao inserir o usuário
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
        Pergunta := 'O que é uma String em programação?';
        RespostaCorreta := 'Um tipo de dado que armazena texto.';
        Alternativa1 := 'Um tipo de dado que armazena números inteiros.';
        Alternativa2 := 'Um tipo de dado que armazena valores booleanos.';
        Alternativa3 := 'Um tipo de dado que armazena números decimais.';
        InserirPergunta(0, Pergunta, RespostaCorreta, Alternativa1,
          Alternativa2, Alternativa3);
        // Pergunta 2
        Pergunta := 'O que é uma variável?';
        RespostaCorreta := 'Um espaço na memória para armazenar dados.';
        Alternativa1 := 'Um valor constante.';
        Alternativa2 := 'Uma função que retorna valores.';
        Alternativa3 := 'Um tipo de dado booleano.';
        InserirPergunta(0, Pergunta, RespostaCorreta, Alternativa1,
          Alternativa2, Alternativa3);
        // Pergunta 3
        Pergunta := 'O que representa e armazena True ou False na programação?';
        RespostaCorreta := 'Boolean.';
        Alternativa1 := 'Inteiro.';
        Alternativa2 := 'String.';
        Alternativa3 := 'Char.';
        InserirPergunta(0, Pergunta, RespostaCorreta, Alternativa1,
          Alternativa2, Alternativa3);
        // Pergunta 4
        Pergunta := 'O que é um número inteiro em programação?';
        RespostaCorreta := 'Um número sem casas decimais.';
        Alternativa1 := 'Um número com casas decimais.';
        Alternativa2 := 'Uma letra ou caractere.';
        Alternativa3 := 'Uma sequência de texto.';
        InserirPergunta(0, Pergunta, RespostaCorreta, Alternativa1,
          Alternativa2, Alternativa3);
        // Pergunta 5
        Pergunta := 'O que é um loop em programação?';
        RespostaCorreta := 'Uma estrutura que repete um bloco de código.';
        Alternativa1 := 'Uma função que imprime dados.';
        Alternativa2 := 'Uma variável que armazena texto.';
        Alternativa3 := 'Um operador matemático.';
        InserirPergunta(0, Pergunta, RespostaCorreta, Alternativa1,
          Alternativa2, Alternativa3);
        // Pergunta 6
        Pergunta := 'Qual operador é usado para atribuir valor a uma variável?';
        RespostaCorreta := '=';
        Alternativa1 := '==';
        Alternativa2 := '!=';
        Alternativa3 := '&&';
        InserirPergunta(0, Pergunta, RespostaCorreta, Alternativa1,
          Alternativa2, Alternativa3);
        // Pergunta 7
        Pergunta := 'O que significa a sigla IDE em programação?';
        RespostaCorreta := 'Integrated Development Environment';
        Alternativa1 := 'Internal Development Environment';
        Alternativa2 := 'Internal Data Editor';
        Alternativa3 := 'Integrated Data Environment';
        InserirPergunta(0, Pergunta, RespostaCorreta, Alternativa1,
          Alternativa2, Alternativa3);
        // Pergunta 8
        Pergunta :=
          'Qual das opções abaixo é um exemplo de linguagem de programação?';
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
          'O que faz a função print em muitas linguagens de programação?';
        RespostaCorreta := 'Exibe dados na tela ou console.';
        Alternativa1 := 'Imprime documentos em papel.';
        Alternativa2 := 'Calcula valores matemáticos.';
        Alternativa3 := 'Salva dados em um arquivo.';
        InserirPergunta(0, Pergunta, RespostaCorreta, Alternativa1,
          Alternativa2, Alternativa3);

        // DIFICULDADE MEDIO
        // Pergunta 11
        Pergunta := 'O que é um array?';
        RespostaCorreta :=
          'Uma estrutura de dados que armazena múltiplos valores.';
        Alternativa1 := 'Uma estrutura de dados que armazena um único valor.';
        Alternativa2 := 'Uma função que executa operações matemáticas.';
        Alternativa3 := 'Um tipo de dado booleano.';
        InserirPergunta(1, Pergunta, RespostaCorreta, Alternativa1,
          Alternativa2, Alternativa3);
        // Pergunta 12
        Pergunta :=
          'Qual operador lógico é usado para representar "E" em expressões booleanas?';
        RespostaCorreta := 'AND';
        Alternativa1 := 'OR';
        Alternativa2 := '==';
        Alternativa3 := '!=';
        InserirPergunta(1, Pergunta, RespostaCorreta, Alternativa1,
          Alternativa2, Alternativa3);
        // Pergunta 13
        Pergunta := 'O que é uma função?';
        RespostaCorreta :=
          'Um bloco de código que executa uma tarefa específica e pode retornar um valor.';
        Alternativa1 := 'Um operador matemático.';
        Alternativa2 := 'Uma variável constante.';
        Alternativa3 := 'Um tipo de dado.';
        InserirPergunta(1, Pergunta, RespostaCorreta, Alternativa1,
          Alternativa2, Alternativa3);
        // Pergunta 14
        Pergunta := 'Qual das opções abaixo representa um tipo de loop?';
        RespostaCorreta := 'while';
        Alternativa1 := 'if-else';
        Alternativa2 := 'switch';
        Alternativa3 := 'bool';
        InserirPergunta(1, Pergunta, RespostaCorreta, Alternativa1,
          Alternativa2, Alternativa3);
        // Pergunta 15
        Pergunta := 'O que faz a função return em uma função?';
        RespostaCorreta := 'Finaliza a função e retorna um valor.';
        Alternativa1 := 'Envia um email.';
        Alternativa2 := 'Armazena dados em uma variável.';
        Alternativa3 := 'Imprime um valor na tela.';
        InserirPergunta(1, Pergunta, RespostaCorreta, Alternativa1,
          Alternativa2, Alternativa3);
        // Pergunta 16
        Pergunta := 'O que é um operador relacional?';
        RespostaCorreta := 'Um operador que compara dois valores.';
        Alternativa1 := 'Um operador que realiza operações matemáticas.';
        Alternativa2 := 'Um operador que concatena strings.';
        Alternativa3 := 'Um operador que manipula arrays.';
        InserirPergunta(1, Pergunta, RespostaCorreta, Alternativa1,
          Alternativa2, Alternativa3);
        // Pergunta 17
        Pergunta := 'Como você declararia uma variável inteira chamada idade?';
        RespostaCorreta := 'int idade = 25;';
        Alternativa1 := 'int idade = "25";';
        Alternativa2 := 'String idade = 25;';
        Alternativa3 := 'bool idade = true;';
        InserirPergunta(1, Pergunta, RespostaCorreta, Alternativa1,
          Alternativa2, Alternativa3);
        // Pergunta 18
        Pergunta := 'O que é uma estrutura condicional?';
        RespostaCorreta :=
          'Uma estrutura que permite a execução de código com base em uma condição.';
        Alternativa1 :=
          'Uma estrutura que repete um bloco de código várias vezes.';
        Alternativa2 := 'Um tipo de dado complexo.';
        Alternativa3 := 'Uma função que retorna sempre o mesmo valor.';
        InserirPergunta(1, Pergunta, RespostaCorreta, Alternativa1,
          Alternativa2, Alternativa3);
        // Pergunta 19
        Pergunta :=
          'Qual é o valor final de x após a execução de x = (5 + 2) * 3?';
        RespostaCorreta := '21';
        Alternativa1 := '2';
        Alternativa2 := '11';
        Alternativa3 := '16';
        InserirPergunta(1, Pergunta, RespostaCorreta, Alternativa1,
          Alternativa2, Alternativa3);
        // Pergunta 20
        Pergunta :=
          'Qual das alternativas abaixo representa uma estrutura de dados não linear?';
        RespostaCorreta := 'Árvore';
        Alternativa1 := 'Array';
        Alternativa2 := 'Lista';
        Alternativa3 := 'Fila';
        InserirPergunta(1, Pergunta, RespostaCorreta, Alternativa1,
          Alternativa2, Alternativa3);

        // DIFICULDADE DIFICIL
        // Pergunta 21
        Pergunta := 'O que é recursão em programação?';
        RespostaCorreta := 'Um processo onde uma função chama a si mesma.';
        Alternativa1 := 'Uma estrutura de dados não linear.';
        Alternativa2 := 'Uma técnica de otimização de código.';
        Alternativa3 := 'Uma função que não retorna nenhum valor.';
        InserirPergunta(2, Pergunta, RespostaCorreta, Alternativa1,
          Alternativa2, Alternativa3);
        // Pergunta 22
        Pergunta :=
          'Qual das opções abaixo descreve uma técnica de busca binária?';
        Alternativa1 := 'Busca sequencial em uma lista desordenada.';
        RespostaCorreta := 'Divisão da lista ao meio até encontrar o elemento.';
        Alternativa2 := 'Ordenação de uma lista utilizando comparações.';
        Alternativa3 := 'Busca por aproximação em um conjunto de valores.';
        InserirPergunta(2, Pergunta, RespostaCorreta, Alternativa1,
          Alternativa2, Alternativa3);
        // Pergunta 23
        Pergunta := 'O que é um ponteiro em linguagens como C ou C++?';
        Alternativa1 := 'Um tipo de dado que armazena valores inteiros.';
        Alternativa2 := 'Um tipo de loop que percorre uma coleção.';
        Alternativa3 := 'Um operador lógico que compara dois valores.';
        RespostaCorreta :=
          'Um tipo de dado que armazena o endereço de memória de uma variável.';
        InserirPergunta(2, Pergunta, RespostaCorreta, Alternativa1,
          Alternativa2, Alternativa3);
        // Pergunta 24
        Pergunta :=
          'Qual é a principal diferença entre programação orientada a objetos e programação procedural?';
        Alternativa1 :=
          'Programação orientada a objetos é mais eficiente em termos de tempo de execução do que programação procedural.';
        Alternativa2 :=
          'Programação orientada a objetos utiliza variáveis globais, enquanto programação procedural utiliza apenas variáveis locais.';
        Alternativa3 :=
          'Programação orientada a objetos não permite herança, enquanto programação procedural permite.';
        RespostaCorreta :=
          'Programação orientada a objetos organiza o código em torno de dados e funções, enquanto programação procedural organiza o código em torno de funções e procedimentos.';
        InserirPergunta(2, Pergunta, RespostaCorreta, Alternativa1,
          Alternativa2, Alternativa3);
        // Pergunta 25
        Pergunta := 'O que é um deadlock em sistemas operacionais?';
        Alternativa1 := 'Um processo que termina sua execução sem erros.';
        RespostaCorreta :=
          'Uma condição onde dois ou mais processos ficam eternamente bloqueados.';
        Alternativa2 :=
          'Um estado onde o sistema não consegue alocar mais memória.';
        Alternativa3 := 'Um loop infinito causado por um erro lógico.';
        InserirPergunta(2, Pergunta, RespostaCorreta, Alternativa1,
          Alternativa2, Alternativa3);
        // Pergunta 26
        Pergunta :=
          'Qual é o objetivo principal da normalização em bancos de dados relacionais?';
        Alternativa1 :=
          'Reduzir a redundância e melhorar a integridade dos dados.';
        Alternativa2 :=
          'Aumentar a complexidade das consultas para otimizar o desempenho.';
        Alternativa3 :=
          'Permitir que tabelas tenham múltiplas chaves primárias.';
        RespostaCorreta :=
          'Garantir que todas as tabelas tenham um número igual de colunas.';
        InserirPergunta(2, Pergunta, RespostaCorreta, Alternativa1,
          Alternativa2, Alternativa3);
        // Pergunta 27
        Pergunta :=
          'O que é um sistema de gerenciamento de banco de dados (SGBD)?';
        RespostaCorreta := 'Um conjunto de programas para manipular dados.';
        Alternativa1 := 'Um software que armazena código fonte.';
        Alternativa2 := 'Um sistema de backup de arquivos.';
        Alternativa3 := 'Uma ferramenta de desenvolvimento integrado.';
        InserirPergunta(2, Pergunta, RespostaCorreta, Alternativa1,
          Alternativa2, Alternativa3);
        // Pergunta 28
        Pergunta :=
          'Qual é a principal característica de uma lista ligada (linked list)?';
        Alternativa1 := 'Armazena elementos em índices sequenciais.';
        RespostaCorreta :=
          'Cada elemento aponta para o próximo elemento da lista.';
        Alternativa2 := 'Armazena elementos de forma contínua na memória.';
        Alternativa3 := 'Cada elemento é acessado diretamente pelo índice.';
        InserirPergunta(2, Pergunta, RespostaCorreta, Alternativa1,
          Alternativa2, Alternativa3);
        // Pergunta 29
        Pergunta :=
          'Qual das opções abaixo representa um paradigma de programação funcional?';
        Alternativa1 := 'Programação orientada a objetos.';
        Alternativa2 := 'Programação imperativa.';
        Alternativa3 := 'Programação lógica.';
        RespostaCorreta := 'Programação funcional.';
        InserirPergunta(2, Pergunta, RespostaCorreta, Alternativa1,
          Alternativa2, Alternativa3);
        // Pergunta 30
        Pergunta :=
          'O que é o conceito de polimorfismo em programação orientada a objetos?';
        Alternativa1 :=
          'A capacidade de uma função ter vários nomes diferentes.';
        Alternativa2 :=
          'A capacidade de uma classe herdar de várias classes ao mesmo tempo.';
        RespostaCorreta := 'A capacidade de um objeto assumir várias formas.';
        Alternativa3 :=
          'A capacidade de uma classe ter múltiplos métodos com o mesmo nome.';
        InserirPergunta(2, Pergunta, RespostaCorreta, Alternativa1,
          Alternativa2, Alternativa3);
end;

end.
