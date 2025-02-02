-- Dependente(Nome, CPFResponsavel*, Idade, Parentesco)
-- CPFResponsavel referencia Cliente(CPF)

TRUNCATE TABLE Dependente 

CREATE TABLE Dependente (
    Nome VARCHAR2(50),
    CPFResponsavel VARCHAR2(11),
    Idade NUMBER(4,2) NOT NULL,
    Parentesco VARCHAR2(15),
    CONSTRAINT dependente_pkey PRIMARY KEY (Nome, CPFResponsavel),
    CONSTRAINT dependente_fkey FOREIGN KEY (CPFResponsavel) 
        REFERENCES Cliente(CPF),
    CONSTRAINT idade_check CHECK (0<IDADE AND IDADE<18),
    CONSTRAINT cpf_check CHECK (LENGTH(CPFResponsavel) = 11)
);

INSERT INTO Dependente (Nome, CPFResponsavel, Idade, Parentesco)
VALUES(
    'Maria Souza',
    17894563322,
    7.2,
    'Filho(a)'
);

SELECT * FROM Dependente;
