-- SQLBook: Code
-- Possui(CodAtividade*, CodPacote*, CNPJFornecedor*)
-- CodAtividade referencia Atividade(Codigo)

CREATE TABLE Possui (
    CodAtividade INT,
    CodPacote INT,
    CNPJFornecedor VARCHAR2(14),
    CONSTRAINT possui_pkey PRIMARY KEY (CodAtividade, CodPacote, CNPJFornecedor),
    CONSTRAINT possui_fkey1 FOREIGN KEY (CodAtividade)
        REFERENCES Atividade(Codigo),
    CONSTRAINT possui_fkey2 FOREIGN KEY (CodPacote)
        REFERENCES Pacote(Codigo),
    CONSTRAINT possui_fkey3 FOREIGN KEY (CNPJFornecedor)
        REFERENCES Fornecedor(CNPJ),
    CONSTRAINT possui_check CHECK (CodAtividade>=0 AND CodPacote>0 AND LENGTH(CNPJFornecedor) = 14)
);

CREATE SEQUENCE possui_seq
START WITH 1 INCREMENT BY 2;
