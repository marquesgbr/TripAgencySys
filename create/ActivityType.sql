-- SQLBook: Code
-- TipoAtividade(Tipo, CodAtividade*)
-- CodAtividade referencia Atividade(Codigo)

CREATE TABLE TipoAtividade (
    Tipo VARCHAR2(25),
    CodAtividade INT,
    CONSTRAINT tipoatividade_pkey PRIMARY KEY (Tipo, CodAtividade),
    CONSTRAINT tipoatividade_fkey FOREIGN KEY (CodAtividade0)
        REFERENCES Atividade(Codigo),
    CONSTRAINT CodAtividade_gtezero CHECK (CodAtividade >= 0)
);

CREATE SEQUENCE code_atividade
START WITH 0 INCREMENT BY 1;
