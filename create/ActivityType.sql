-- TipoAtividade(Tipo, CodAtividade*)
-- CodAtividade referencia Atividade(Codigo)

CREATE TABLE TipoAtividade (
    Tipo VARCHAR2(25) NOT NULL,
    CodAtividade INT NOT NULL,
    CONSTRAINT tipoatividade_pkey PRIMARY KEY (Tipo, CodAtividade),
    CONSTRAINT tipoatividade_fkey FOREIGN KEY (CodAtividade0)
        REFERENCES Atividade(Codigo),
    CONSTRAINT CodAtividade_gtezero CHECK (CodAtividade >= 0)
);

CREATE SEQUENCE code_atividade
START WITH 0 INCREMENT BY 1;

INSERT INTO TipoAtividade (Tipo, CodAtividade) 
VALUES(
    'Passeio',
    60
);
INSERT INTO TipoAtividade (Tipo, CodAtividade) 
VALUES(
    'Gastronomia',
    code_atividade.nextval
);
INSERT INTO TipoAtividade (Tipo, CodAtividade) 
VALUES(
    'Viagem',
    100
);
INSERT INTO TipoAtividade (Tipo, CodAtividade) 
VALUES(
    'Familia',
    100
);
INSERT INTO TipoAtividade (Tipo, CodAtividade) 
VALUES(
    'Cultural',
    code_atividade.nextval
);
INSERT INTO TipoAtividade (Tipo, CodAtividade) 
VALUES(
    'Longo Prazo',
    100
);
INSERT INTO TipoAtividade (Tipo, CodAtividade) 
VALUES(
    'Curto Prazo',
    code_atividade.nextval
);
INSERT INTO TipoAtividade (Tipo, CodAtividade) 
VALUES(
    'Nacional',
    60
);
INSERT INTO TipoAtividade (Tipo, CodAtividade) 
VALUES(
    'Internacional',
    code_atividade.nextval
);
INSERT INTO TipoAtividade (Tipo, CodAtividade) 
VALUES(
    'Aventura',
    code_atividade.nextval
);
INSERT INTO TipoAtividade (Tipo, CodAtividade) 
VALUES(
    'Esporte',
    code_atividade.nextval
);


SELECT * FROM TipoAtividade;