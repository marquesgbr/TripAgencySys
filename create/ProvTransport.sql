-- SQLBook: Code
-- FornecedorTransporte(CNPJ_T*, TipoTransporte)
-- CNPJ_T referencia Fornecedor(CNPJ)

CREATE TABLE FornecedorTransporte (
    CNPJ_T VARCHAR2(14),
    TipoTransporte VARCHAR2(15) NOT NULL,
    CONSTRAINT fornt_pkey PRIMARY KEY (CNPJ_T),
    CONSTRAINT fornt_fkey FOREIGN KEY (CNPJ_T)
        REFERENCES Fornecedor(CNPJ),
    CONSTRAINT tipotransporte_check CHECK (TipoTransporte IN ('Aereo', 'Ferroviario', 'Maritimo', 'Rodoviario')),
    CONSTRAINT cnpj_check CHECK (LENGTH(CNPJ_T) = 14)
);

CREATE SEQUENCE seq_fornt
    START WITH 60000000000000 INCREMENT BY 1;
