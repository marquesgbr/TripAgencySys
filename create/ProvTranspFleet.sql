-- FrotaTransportadora(CNPJTransportadora*, Veiculo, Quantidade)
-- CNPJTransportadora referencia Fornecedor_Transporte(CNPJ_T)
-- Veiculo -> tipo

CREATE TABLE FrotaTransportadora (
    CNPJTransportadora VARCHAR2(14),
    Veiculo VARCHAR2(20),
    Quantidade NUMBER(5) NOT NULL,
    CONSTRAINT frota_pkey PRIMARY KEY (CNPJTransportadora),
    CONSTRAINT frota_fkey FOREIGN KEY (CNPJTransportadora)
        REFERENCES FornecedorTransporte(CNPJ_T),
    CONSTRAINT vehicletype_check CHECK (Veiculo IN (
        'Aviao', 'Helicoptero', 'Carro', 'Onibus', 'Van', 'Navio', 'Lancha', 'Trem', 'Metro'
            )
        ),
    CONSTRAINT cnpj_check CHECK (LENGTH(CNPJTransportadora) = 14)
);

CREATE SEQUENCE seq_frotatransp
    START WITH 50 INCREMENT BY 1;

INSERT INTO FrotaTransportadora (CNPJTransportadora, Veiculo, Quantidade)
VALUES (LPAD(seq_frotatransp.NEXTVAL, 14, '0'), 'Onibus', 25);

INSERT INTO FrotaTransportadora (CNPJTransportadora, Veiculo, Quantidade)
VALUES ('88888888000177', 'Carro', 50);

INSERT INTO FrotaTransportadora (CNPJTransportadora, Veiculo, Quantidade)
VALUES ('99999999000188', 'Aviao', 10);

SELECT * FROM FrotaTransportadora;
