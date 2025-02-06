-- SQLBook: Code
-- Cliente(CPF, CPFIndicadoPor*, Nome, Telefone, Email, Data_Registro, Pontos_Fidelidade)
-- CPFIndicadoPor referencia Cliente(CPF)

TRUNCATE TABLE cliente cascade CONSTRAINTS;
DROP SEQUENCE cliente_seq;

CREATE TABLE Cliente (
    CPF VARCHAR2(11),
    CPFIndicadoPor VARCHAR2(11),
    Nome VARCHAR2(50) NOT NULL,
    Telefone VARCHAR2(15) UNIQUE NOT NULL,
    Email VARCHAR2(100) UNIQUE NOT NULL,
    Data_Registro DATE NOT NULL,
    Pontos_Fidelidade INT NOT NULL,
    CONSTRAINT cliente_pkey PRIMARY KEY (CPF),
    CONSTRAINT cliente_fkey FOREIGN KEY 
        (CPFIndicadoPor) REFERENCES Cliente(CPF),
    CONSTRAINT cpf_check CHECK 
        (LENGTH(CPF) = 11 AND (CPFIndicadoPor = NULL OR LENGTH(CPFIndicadoPor) = 11)),
    CONSTRAINT indicado_diff CHECK (CPF != CPFIndicadoPor),
    CONSTRAINT Pontos_Fidelidade_check CHECK (Pontos_fidelidade>=0) 
);

CREATE SEQUENCE cliente_seq
    START WITH 1
    INCREMENT BY 1;

