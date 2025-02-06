-- SQLBook: Code
-- Fornecedor(CNPJ, NomeEmpresa)

CREATE TABLE Fornecedor (
    CNPJ VARCHAR2(14),
    NomeEmpresa VARCHAR2(50) NOT NULL,
    CONSTRAINT fornecedor_pkey PRIMARY KEY (CNPJ),
    CONSTRAINT cnpj_check CHECK (LENGTH(CNPJ) = 14)
);

CREATE SEQUENCE prov_seq 
START WITH 100 INCREMENT BY 1;
