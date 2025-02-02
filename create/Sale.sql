-- Promocao(Codigo, Nome, Desconto)
TRUNCATE TABLE Promocao;
DROP SEQUENCE code_promo;

CREATE TABLE Promocao (
    Codigo INT,
    Nome VARCHAR2(40) NOT NULL,
    Desconto NUMBER(2) NOT NULL,
    CONSTRAINT promocao_pkey PRIMARY KEY (Codigo),
    CONSTRAINT codigo_gtezero CHECK (Codigo >= 0),
    CONSTRAINT desconto_check CHECK (5<Desconto AND Desconto<90)
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
    5,
    'Fim de Ano',
    20
);

SELECT * FROM Promocao;

