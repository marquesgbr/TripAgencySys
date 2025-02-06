-- SQLBook: Code
-- Atividade(Codigo, Nome, Descricao, Duracao)
-- Duracao -> dias 


CREATE TABLE Atividade (
    Codigo INT,
    Nome VARCHAR2(40) NOT NULL,
    Descricao VARCHAR2(70),
    Duracao NUMBER(3,0),
    CONSTRAINT atividade_pkey PRIMARY KEY (Codigo),
    CONSTRAINT codigo_gtezero CHECK (Codigo >= 0),
    CONSTRAINT duracao_length CHECK (Duracao > 0)
);

CREATE SEQUENCE code_atividade 
START WITH 0 INCREMENT BY 1;
