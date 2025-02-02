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

