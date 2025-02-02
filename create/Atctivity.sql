-- Atividade(Codigo, Nome, Descricao, Duracao)
-- Duracao -> dias 
CREATE TABLE Atividade (
    Codigo INT,
    Nome VARCHAR2(40) NOT NULL,
    Descricao VARCHAR2(70),
    Duracao NUMBER(3,0) NOT NULL,
    CONSTRAINT atividade_pkey PRIMARY KEY (Codigo),
    CONSTRAINT codigo_gtezero CHECK (Codigo >= 0),
    CONSTRAINT duracao_length CHECK (Duracao > 0)
);

CREATE SEQUENCE code_atividade 
START WITH 0 INCREMENT BY 1;

INSERT INTO Atividade (Codigo, Nome, Descricao, Duracao)
VALUES(
    code_atividade.nextval,
    'Passeio de Barco',
    'Passeio de barco pela orla de Recife',
    1
)

INSERT INTO Atividade (Codigo, Nome, Descricao, Duracao)
VALUES(
    90,
    'Jantar Garantido!',
    'Inclui janta no restaurante do resort CInDivirta por 3 noites',
    3
)

INSERT INTO Atividade (Codigo, Nome, Descricao, Duracao)
VALUES(
    code_atividade.nextval,
    'Degustaçao de Vinhos',
    NULL,
    1
)



SELECT * FROM Atividade;