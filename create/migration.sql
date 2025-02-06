-- SQLBook: Code
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

CREATE TABLE Promocao (
    Codigo INT,
    Nome VARCHAR2(40) NOT NULL,
    Desconto NUMBER(2) NOT NULL,
    CONSTRAINT promocao_pkey PRIMARY KEY (Codigo),
    CONSTRAINT codigo_gtezero CHECK (Codigo >= 0),
    CONSTRAINT desconto_check CHECK (5<Desconto AND Desconto<90)
);


CREATE TABLE Pacote (
    Codigo INT,
    NomePacote VARCHAR2(40),
    PrecoBase NUMBER(7,2),
    CONSTRAINT pacote_pkey PRIMARY KEY (Codigo),
    CONSTRAINT codigo_gtzero CHECK (Codigo > 0),
    CONSTRAINT preco_check CHECK (PrecoBase >= 100)
)

CREATE SEQUENCE code_pacote
START WITH 1 INCREMENT BY 1;

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

CREATE TABLE Atividade (
    Codigo INT,
    Nome VARCHAR2(40) NOT NULL,
    Descricao VARCHAR2(70),
    Duracao DECIMAL(3,0),
    CONSTRAINT atividade_pkey PRIMARY KEY (Codigo),
    CONSTRAINT codigo_gtezero CHECK (Codigo >= 0),
    CONSTRAINT duracao_length CHECK (Duracao > 0)
);

CREATE TABLE TipoAtividade (
    Tipo VARCHAR2(25),
    CodAtividade INT,
    CONSTRAINT tipoatividade_pkey PRIMARY KEY (Tipo, CodAtividade),
    CONSTRAINT tipoatividade_fkey FOREIGN KEY (CodAtividade0)
        REFERENCES Atividade(Codigo),
    CONSTRAINT CodAtividade_gtezero CHECK (CodAtividade >= 0)
);

CREATE SEQUENCE code_atividade
START WITH 0 INCREMENT BY 1;


CREATE TABLE Fornecedor (
    CNPJ VARCHAR2(14),
    NomeEmpresa VARCHAR2(50) NOT NULL,
    CONSTRAINT fornecedor_pkey PRIMARY KEY (CNPJ),
    CONSTRAINT cnpj_check CHECK (LENGTH(CNPJ) = 14)
);

CREATE TABLE ContatoFornecedor (
    CodFornecedor VARCHAR2(14),
    Telefone VARCHAR2(15) NOT NULL,
    Email VARCHAR2(100) NOT NULL,
    CONSTRAINT contatofornecedor_pkey PRIMARY KEY (CodFornecedor, Telefone, Email),
    CONSTRAINT contatofornecedor_fkey FOREIGN KEY (CodFornecedor)
        REFERENCES Fornecedor(CNPJ),
    CONSTRAINT cnpj_check CHECK (LENGTH(CodFornecedor) = 14)
);

CREATE SEQUENCE seq_codfornecedor
    START WITH 100 INCREMENT BY 1;

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

CREATE TABLE FornecedorHospedagem (
    CNPJ_H VARCHAR2(14),
    Classificacao NUMBER(4,3) NOT NULL,
    Acomodacao VARCHAR2(15) NOT NULL,
    CONSTRAINT fornhosp_pkey PRIMARY KEY (CNPJ_H),
    CONSTRAINT fornhosp_fkey FOREIGN KEY (CNPJ_H)
        REFERENCES Fornecedor(CNPJ),
    CONSTRAINT classificacao_check CHECK (0<=Classificacao AND Classificacao<=5),
    CONSTRAINT acomodacao_check CHECK (Acomodacao IN ('Albergue', 'Casa', 'Chale', 'Hotel', 'Pousada')),
    CONSTRAINT cnpj_check CHECK (LENGTH(CNPJ_H) = 14)
);

CREATE SEQUENCE seq_fornhosp
    START WITH 30 INCREMENT BY 1;

CREATE TABLE FornecedorAlimentacao (
    CNPJ_A VARCHAR2(14),
    Classificacao NUMBER(4,3) NOT NULL,
    Servico VARCHAR2(15) NOT NULL,
    CONSTRAINT fornalim_pkey PRIMARY KEY (CNPJ_A),
    CONSTRAINT fornalim_fkey FOREIGN KEY (CNPJ_A)
        REFERENCES Fornecedor(CNPJ),
    CONSTRAINT classificacao_check CHECK (0<=Classificacao AND Classificacao<=5),
    CONSTRAINT servico_check CHECK (Servico IN ('Buffet', 'Bar', 'Fast Food', 'Restaurante', 'Self-Service')),
    CONSTRAINT cnpj_check CHECK (LENGTH(CNPJ_A) = 14)
);

CREATE SEQUENCE seq_fornalim
    START WITH 10 INCREMENT BY 1;


CREATE TABLE FornecedorTransporte (
    CNPJ_T VARCHAR2(14),
    TipoTransporte VARCHAR2(15) NOT NULL,
    CONSTRAINT fornt_pkey PRIMARY KEY (CNPJ_T),
    CONSTRAINT fornt_fkey FOREIGN KEY (CNPJ_T)
        REFERENCES Fornecedor(CNPJ),
    CONSTRAINT tipotransporte_check CHECK (TipoTransporte IN ('Aereo', 'Ferroviario', 'Maritimo', 'Rodoviario')),
    CONSTRAINT cnpj_check CHECK (LENGTH(CNPJ_T) = 14)
);

CREATE SEQUENCE seq_fornt
    START WITH 60000000000000 INCREMENT BY 1;

CREATE TABLE FornecedorEvento (
    CNPJ_E VARCHAR2(14),
    Tipo VARCHAR2(15) NOT NULL,
    CapacidadeMaxima NUMBER(5) NOT NULL,
    CONSTRAINT fornevent_pkey PRIMARY KEY (CNPJ_E),
    CONSTRAINT fornevent_fkey FOREIGN KEY (CNPJ_E)
        REFERENCES Fornecedor(CNPJ),
    CONSTRAINT tipo_check CHECK (Tipo IN ('Comemorativo', 'Corporativo', 'Cultural', 'Esportivo', 'Religioso')),
    CONSTRAINT cnpj_check CHECK (LENGTH(CNPJ_E) = 14)
);

CREATE SEQUENCE seq_fornevent
    START WITH 25 INCREMENT BY 1;

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