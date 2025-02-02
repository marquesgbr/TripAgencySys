-- ContatoFornecedor(CodFornecedor*, Telefone, Email)
-- CodFornecedor referencia Fornecedor(CNPJ)

CREATE TABLE ContatoFornecedor (
    CodFornecedor VARCHAR2(14),
    Telefone VARCHAR2(15) NOT NULL,
    Email VARCHAR2(100) NOT NULL,
    CONSTRAINT contatofornecedor_pkey PRIMARY KEY (CodFornecedor, Telefone, Email),
    CONSTRAINT contatofornecedor_fkey FOREIGN KEY (CodFornecedor)
        REFERENCES Fornecedor(CNPJ),
    CONSTRAINT cnpj_check CHECK (LENGTH(CodFornecedor) = 14)
);

CREATE SEQUENCE seq_codfornecedor
    START WITH 100 INCREMENT BY 1;

INSERT INTO ContatoFornecedor (CodFornecedor, Telefone, Email)
VALUES (LPAD(seq_codfornecedor.NEXTVAL, 14, '21'), '11987654321', 'contato@empresa1.com.us');

INSERT INTO ContatoFornecedor (CodFornecedor, Telefone, Email)
VALUES ('12345678000195', '21987654321', 'suporte@empresa88.com.br');

INSERT INTO ContatoFornecedor (CodFornecedor, Telefone, Email)
VALUES ('98765432000187', '31999998888', 'atendimento@empresa2.com');

SELECT * FROM ContatoFornecedor;

