-- SQLBook: Code
-- FornecedorAlimentacao(CNPJ_A*, Classificacao, Servico)
-- CNPJ_A referencia Fornecedor(CNPJ)

CREATE TABLE FornecedorAlimentacao (
    CNPJ_A VARCHAR2(14),
    Classificacao NUMBER(4,3) NOT NULL,
    Servico VARCHAR2(15) NOT NULL,
    CONSTRAINT fornalim_pkey PRIMARY KEY (CNPJ_A),
    CONSTRAINT fornalim_fkey FOREIGN KEY (CNPJ_A)
        REFERENCES Fornecedor(CNPJ),
    CONSTRAINT classificacao_check CHECK (0<=Classificacao AND Classificacao<=5),
    CONSTRAINT servico_check CHECK (Servico IN ('Buffet', 'Bar', 'Fast Food', 'Restaurante', 'Self-Service')),
    CONSTRAINT cnpj_check CHECK (LENGTH(CNPJ_A) = 14)
);

CREATE SEQUENCE seq_fornalim
    START WITH 10 INCREMENT BY 1;

