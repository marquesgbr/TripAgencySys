-- FornecedorEvento(CNPJ_E*, Tipo, CapacidadeMaxima)
-- CNPJ_E referencia Fornecedor(CNPJ)

CREATE TABLE FornecedorEvento (
    CNPJ_E VARCHAR2(14),
    Tipo VARCHAR2(15) NOT NULL,
    CapacidadeMaxima NUMBER(5) NOT NULL,
    CONSTRAINT fornevent_pkey PRIMARY KEY (CNPJ_E),
    CONSTRAINT fornevent_fkey FOREIGN KEY (CNPJ_E)
        REFERENCES Fornecedor(CNPJ),
    CONSTRAINT tipo_check CHECK (Tipo IN ('Comemorativo', 'Corporativo', 'Cultural', 'Esportivo', 'Religioso'))
    CONSTRAINT cnpj_check CHECK (LENGTH(CNPJ_E) = 14)
);