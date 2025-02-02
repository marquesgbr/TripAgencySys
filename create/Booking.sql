-- Reserva(Data_hora_reserva, CPFConsumidor*, CodPacote*, CodPromocao*, Data Entrada, Data Saida, Data Modificacao, Status)
-- CPFConsumidor referencia Cliente(CPF)
-- CodPacote referencia Pacote(Codigo)
-- CodPromocao referencia Promocao(Codigo)

TRUNCATE TABLE Reserva;

CREATE TABLE Reserva (
    Data_hora_reserva DATE,
    CPFConsumidor CHAR(11),
    CodPacote INTEGER,
    CodPromocao INTEGER,
    Data_Entrada DATE NOT NULL,
    Data_Saida DATE NOT NULL,
    Data_Modificacao DATE NOT NULL,
    Status VARCHAR2(20) NOT NULL,
    CONSTRAINT reserva_pkey PRIMARY KEY (Data_hora_reserva, CPFConsumidor, CodPacote),
    CONSTRAINT reserva_fkey1 FOREIGN KEY (CPFConsumidor) REFERENCES Cliente(CPF),
    CONSTRAINT reserva_fkey2 FOREIGN KEY (CodPacote) REFERENCES Pacote(Codigo),
    CONSTRAINT reserva_fkey3 FOREIGN KEY (CodPromocao) REFERENCES Promocao(Codigo),
    CONSTRAINT status_check CHECK (Status IN ('Reservado', 'Cancelado', 'Modificado'))
);

INSERT INTO Reserva (
    Data_hora_reserva, 
    CPFConsumidor, 
    CodPacote, 
    CodPromocao,
    Data_Entrada, 
    Data_Saida, 
    Data_Modificacao,
    Status
) VALUES (
    TO_DATE('20/11/2024 14:01:30', 'DD/MM/YYYY HH24:MI:SS'),
    17894563322,
    11,
    5,
    TO_DATE('23/12/2024', 'DD/MM/YYYY'),
    TO_DATE('02/01/2025', 'DD/MM/YYYY'),
    TO_DATE('20/11/2024', 'DD/MM/YYYY'),
    'Reservado'
);

SELECT * FROM Reserva;
