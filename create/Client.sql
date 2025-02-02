-- Cliente(CPF, CPFIndicadoPor*, Nome, Telefone, Email, Data_Registro, Pontos_Fidelidade)
-- CPFIndicadoPor referencia Cliente(CPF)

TRUNCATE TABLE cliente cascade CONSTRAINTS;
DROP SEQUENCE cliente_seq;

CREATE TABLE Cliente (
    CPF CHAR(11),
    CPFIndicadoPor CHAR(11),
    Nome VARCHAR2(50) NOT NULL,
    Telefone VARCHAR2(15) UNIQUE NOT NULL,
    Email VARCHAR2(100) UNIQUE NOT NULL,
    Data_Registro DATE NOT NULL,
    Pontos_Fidelidade INT NOT NULL,
    CONSTRAINT cliente_pkey PRIMARY KEY (CPF),
    CONSTRAINT indicado_diff CHECK (CPF != CPFIndicadoPor),
    CONSTRAINT cliente_fkey FOREIGN KEY 
        (CPFIndicadoPor) REFERENCES Cliente(CPF),
    CONSTRAINT Pontos_Fidelidade_check CHECK (Pontos_fidelidade>=0) 
);

CREATE SEQUENCE cliente_seq
    START WITH 1
    INCREMENT BY 1;


INSERT INTO Cliente (CPF, CPFIndicadoPor, Nome, Telefone, Email, Data_Registro, Pontos_Fidelidade)
VALUES (
    17894563322, 
    NULL,   
    'Luiza Souza',                        
    '14085990321',                    
    'souzalu05@gmail.com',           
    TO_DATE('30/06/2024 00:12:28', 'DD/MM/YYYY HH24:MI:SS'),                             
    0                                   
);


INSERT INTO Cliente (CPF, CPFIndicadoPor, Nome, Telefone, Email, Data_Registro, Pontos_Fidelidade)
VALUES (
    LPAD(cliente_seq.NEXTVAL, 11, '0'), 
    NULL,   
    'João Silva',                        
    '1234567890',                    
    'joao.silva@exemplo.com',           
    TO_DATE('04/10/2023, 15:44:32', 'DD/MM/YYYY, HH24:MI:SS'),                             
    0                                   
);

INSERT INTO Cliente (CPF, CPFIndicadoPor, Nome, Telefone, Email, Data_Registro, Pontos_Fidelidade)
VALUES (
    LPAD(cliente_seq.NEXTVAL, 11, '0'),
    LPAD(cliente_seq.NEXTVAL-1, 11, '0'),    
    'Maria Julia',                       
    '9876543210987',                     
    'maria.julia@exemplo.com',          
    SYSDATE,                            
    10                                  
);

INSERT INTO Cliente (CPF, CPFIndicadoPor, Nome, Telefone, Email, Data_Registro, Pontos_Fidelidade)
VALUES (
    LPAD(cliente_seq.NEXTVAL, 11, '0'),
    LPAD(cliente_seq.NEXTVAL-2, 11, '0'),    
    'Ana Clara de Lima',                       
    '5581988887777',                     
    'anfl@cin.ufpe.br',          
    SYSDATE,                            
    10                                   
);

-- Show all data
SELECT * FROM cliente;