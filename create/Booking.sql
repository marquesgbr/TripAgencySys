-- SQLBook: Code
-- Reserva(Data_hora_reserva, CPFConsumidor*, CodPacote*, CodPromocao*, Data Entrada, Data Saida, Data Modificacao, Status)
-- CPFConsumidor referencia Cliente(CPF)
-- CodPacote referencia Pacote(Codigo)
-- CodPromocao referencia Promocao(Codigo)

TRUNCATE TABLE Reserva;

CREATE TABLE Reserva (
    Data_hora_reserva DATE,
    CPFConsumidor VARCHAR2(11),
    CodPacote INT,
    CodPromocao INT,
    Data_Entrada DATE NOT NULL,
    Data_Saida DATE NOT NULL,
    Data_Modificacao DATE NOT NULL,
    Status VARCHAR2(20) NOT NULL,
    CONSTRAINT reserva_pkey PRIMARY KEY (Data_hora_reserva, CPFConsumidor, CodPacote),
    CONSTRAINT reserva_fkey1 FOREIGN KEY (CPFConsumidor) 
        REFERENCES Cliente(CPF),
    CONSTRAINT reserva_fkey2 FOREIGN KEY (CodPacote) 
        REFERENCES Pacote(Codigo),
    CONSTRAINT reserva_fkey3 FOREIGN KEY (CodPromocao) 
        REFERENCES Promocao(Codigo),
    CONSTRAINT status_check CHECK (Status IN ('Reservado', 'Cancelado', 'Modificado')),
    CONSTRAINT data_valid CHECK (Data_Entrada <= Data_Saida)
    CONSTRAINT reserva_check CHECK (LENGTH(CPFConsumidor)=11 AND CodPacote>0 AND CodPromocao>0)
);
