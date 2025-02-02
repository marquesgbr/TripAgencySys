-- FornecedorAlimentacao(CNPJ_A*, Classificacao, Servico)
-- CNPJ_A referencia Fornecedor(CNPJ)

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


INSERT INTO FornecedorAlimentacao (CNPJ_A, Classificacao, Servico)
VALUES (LPAD(seq_fornalime.NEXTVAL, 14, '67'), 4.5, 'Restaurante');

INSERT INTO FornecedorAlimentacao (CNPJ_A, Classificacao, Servico)
VALUES ('22222222000111', 3.8, 'Buffet');

INSERT INTO FornecedorAlimentacao (CNPJ_A, Classificacao, Servico)
VALUES ('33333333000122', 5.0, 'Fast Food');

SELECT * FROM FornecedorAlimentacao;
