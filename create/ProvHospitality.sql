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
    CONSTRAINT acomodacao_check CHECK (Acomodacao IN ('Albergue', 'Casa', 'Chale', 'Hotel', 'Pousada'))
    CONSTRAINT cnpj_check CHECK (LENGTH(CNPJ_H) = 14)
);