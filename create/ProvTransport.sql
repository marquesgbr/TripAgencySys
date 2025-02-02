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

INSERT INTO FornecedorTransporte (CNPJ_T, TipoTransporte)
VALUES (LPAD(seq_fornt.NEXTVAL, 14, '0'), 'Rodoviario');

INSERT INTO FornecedorTransporte (CNPJ_T, TipoTransporte)
VALUES ('11111111000199', 'Aereo');

INSERT INTO FornecedorTransporte (CNPJ_T, TipoTransporte)
VALUES ('22222222111222', 'Maritimo');

SELECT * FROM FornecedorTransporte;
