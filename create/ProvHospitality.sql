-- FornecedorHospedagem(CNPJ_H*, Classificacao, Acomodacao)
-- CNPJ_H referencia Fornecedor(CNPJ)

CREATE TABLE FornecedorHospedagem (
    CNPJ_H VARCHAR2(14),
    Classificacao NUMBER(4,3) NOT NULL,
    Acomodacao VARCHAR2(15) NOT NULL,
    CONSTRAINT fornhosp_pkey PRIMARY KEY (CNPJ_H),
    CONSTRAINT fornhosp_fkey FOREIGN KEY (CNPJ_H)
        REFERENCES Fornecedor(CNPJ),
    CONSTRAINT classificacao_check CHECK (0<=Classificacao AND Classificacao<=5),
    CONSTRAINT acomodacao_check CHECK (Acomodacao IN ('Albergue', 'Casa', 'Chale', 'Hotel', 'Pousada')),
    CONSTRAINT cnpj_check CHECK (LENGTH(CNPJ_H) = 14)
);

CREATE SEQUENCE seq_fornhosp
    START WITH 30 INCREMENT BY 1;

INSERT INTO FornecedorHospedagem (CNPJ_H, Classificacao, Acomodacao)
VALUES (LPAD(seq_fornhosp.NEXTVAL, 14, '0'), 3.9, 'Hotel');

INSERT INTO FornecedorHospedagem (CNPJ_H, Classificacao, Acomodacao)
VALUES ('66666666000155', 4.7, 'Pousada');

INSERT INTO FornecedorHospedagem (CNPJ_H, Classificacao, Acomodacao)
VALUES ('77777777000166', 2.5, 'Albergue');

SELECT * FROM FornecedorHospedagem;
