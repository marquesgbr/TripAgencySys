-- Promocao(Codigo, Nome, Desconto)

CREATE TABLE Promocao (
    Codigo INTEGER,
    Nome VARCHAR2(40) NOT NULL,
    Desconto NUMBER(2) NOT NULL,
    CONSTRAINT promocao_pkey PRIMARY KEY (Codigo)
);
CREATE SEQUENCE code_promo
START WITH 1 INCREMENT BY 1;

INSERT INTO Promocao (Codigo, Nome, Desconto) 
VALUES (
    code_promo.nextval,
    'Promocao de Carnaval',
    30
);

INSERT INTO Promocao (Codigo, Nome, Desconto) 
VALUES (
    code_promo.nextval,
    'MegaPromo VERAO',
    40
);

INSERT INTO Promocao (Codigo, Nome, Desconto) 
VALUES (
    code_promo.nextval,
    'Ferias em Familia',
    15
);

INSERT INTO Promocao (Codigo, Nome, Desconto) 
VALUES (
    4,
    'Fim de Ano',
    20
);

SELECT * FROM Promocao;

