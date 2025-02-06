-- SQLBook: Code
-- Pacote(Codigo, NomePacote, PrecoBase)
TRUNCATE TABLE Pacote;

CREATE TABLE Pacote (
    Codigo INT,
    NomePacote VARCHAR2(40),
    PrecoBase NUMBER(7,2),
    CONSTRAINT pacote_pkey PRIMARY KEY (Codigo),
    CONSTRAINT codigo_gtzero CHECK (Codigo > 0),
    CONSTRAINT preco_check CHECK (PrecoBase >= 100)
)

CREATE SEQUENCE code_pacote
START WITH 1 INCREMENT BY 1;
