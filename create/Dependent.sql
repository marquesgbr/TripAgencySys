-- Dependente(Nome, CPFResponsavel*, Idade, Parentesco)
-- CPFResponsavel referencia Cliente(CPF)

DROP TABLE Dependente 

CREATE TABLE Dependente (
    Nome VARCHAR2(50) NOT NULL,
    CPFResponsavel CHAR(11) UNIQUE NOT NULL,
    Idade NUMBER(4,2) NOT NULL,
    Parentesco VARCHAR2(15),
    CONSTRAINT dependente_pkey PRIMARY KEY (Nome, CPFResponsavel),
    CONSTRAINT dependente_fkey FOREIGN KEY (CPFResponsavel) REFERENCES Cliente(CPF),
    CONSTRAINT idade_check CHECK (0<IDADE AND IDADE<18)
);

INSERT INTO Dependente (Nome, CPFResponsavel, Idade, Parentesco)
VALUES(
    'Maria Souza',
    17894563322,
    7.2,
    'Filho(a)'
);

SELECT * FROM Dependente;
