-- Conjunto de Drops para Tipos e Tabelas 

-- Relacionamento multiplo
DROP TABLE tb_possui FORCE;
DROP TYPE tp_possui FORCE;

-- Fornecedor
DROP TYPE tp_fornecedor FORCE;
DROP TYPE tp_fornecedor_evento FORCE;
DROP TYPE tp_fornecedor_transporte FORCE;
DROP TYPE tp_fornecedor_alimentacao FORCE;
DROP TYPE tp_fornecedor_hospedagem FORCE;

DROP TABLE tb_fornecedor_evento FORCE;
DROP TABLE tb_fornecedor_transporte FORCE;
DROP TABLE tb_fornecedor_alimentacao FORCE;
DROP TABLE tb_fornecedor_hospedagem FORCE;

-- Atividade
DROP TABLE tb_atividade FORCE;
DROP TYPE tp_atividade FORCE;
DROP TYPE tp_lista_ativ_tipos FORCE;
DROP TYPE tp_atividade_tipo FORCE;

-- Reserva
DROP TABLE tb_reserva FORCE;
DROP TYPE tp_reserva FORCE;

-- Pacote
DROP TABLE tb_pacote FORCE;
DROP TYPE tp_pacote FORCE;

-- Promocoe
DROP TABLE tb_promocao FORCE;
DROP TYPE tp_promocao FORCE;

-- Cliente
DROP TABLE tb_cliente FORCE;
DROP TYPE tp_clientes_indicados FORCE;
DROP TYPE tp_possui_dep FORCE;
DROP TYPE tp_cliente FORCE;

-- Dependente
DROP TYPE tp_dependente FORCE;

-- Auxiliares
DROP TYPE tp_frotas_transp FORCE;
DROP TYPE tp_frota FORCE;
DROP TYPE tp_lista_contatos FORCE;
DROP TYPE tp_contato FORCE;
DROP TYPE tp_email FORCE;
DROP TYPE tp_telefone FORCE;


-- Tipos Auxiliares
CREATE OR REPLACE TYPE tp_telefone AS OBJECT (
    numero VARCHAR2(15)
);
/

CREATE OR REPLACE TYPE tp_email AS OBJECT (
    email VARCHAR2(80)
);
/

CREATE OR REPLACE TYPE tp_contato AS OBJECT (
    telefone tp_telefone,
    email tp_email
);
/

CREATE OR REPLACE TYPE tp_lista_contatos AS VARRAY(5) OF tp_contato;
/

-- Dependente
CREATE OR REPLACE TYPE tp_dependente AS OBJECT (
    nome VARCHAR2(50),
    data_nascimento DATE,
    parentesco VARCHAR2(15),

    MEMBER FUNCTION get_idade RETURN NUMBER,
    ORDER MEMBER FUNCTION compare_idade(outro tp_dependente) RETURN INT
);
/

CREATE OR REPLACE TYPE BODY tp_dependente AS
    MEMBER FUNCTION get_idade RETURN NUMBER IS
    BEGIN
        RETURN EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM self.data_nascimento);
    END;

    ORDER MEMBER FUNCTION compare_idade (outro tp_dependente) RETURN INT IS
    BEGIN
        RETURN SIGN(self.get_idade - outro.get_idade);
    END;
END;
/
-- fim Dependente


-- Cliente

CREATE OR REPLACE TYPE tp_possui_dep AS TABLE OF tp_dependente;
/

CREATE OR REPLACE TYPE tp_cliente AS OBJECT (
    cpf VARCHAR2(11),
    nome VARCHAR2(50),
    email tp_email,
    telefone tp_telefone,
    data_registro DATE,
    pontos_fidelidade NUMBER,
    cliente_indicador REF tp_cliente,
    dependentes tp_possui_dep, 

    MAP MEMBER FUNCTION get_pontos RETURN NUMBER,
    MEMBER PROCEDURE add_pontos(pontos IN NUMBER),
    MEMBER FUNCTION count_indicados RETURN NUMBER,
    MEMBER FUNCTION get_categoria RETURN VARCHAR2 -- (Platinum, Gold, Silver, Bronze)
) NOT FINAL;
/

CREATE OR REPLACE TYPE tp_clientes_indicados AS TABLE OF REF tp_cliente;
/

-- Alterar cliente para considerar nova tabela de indicados
ALTER TYPE tp_cliente ADD ATTRIBUTE (
    clientes_indicados  tp_clientes_indicados
) CASCADE;
/

CREATE OR REPLACE TYPE BODY tp_cliente AS

    MAP MEMBER FUNCTION get_pontos RETURN NUMBER IS
    BEGIN
        RETURN self.pontos_fidelidade;
    END;
    
    MEMBER PROCEDURE add_pontos(pontos IN NUMBER) IS
    BEGIN
        self.pontos_fidelidade := self.pontos_fidelidade + pontos;
    END;
    
    MEMBER FUNCTION count_indicados RETURN NUMBER IS
    BEGIN
        RETURN clientes_indicados.COUNT;
    END;

    MEMBER FUNCTION get_categoria RETURN VARCHAR2 IS
    BEGIN   
        IF self.pontos_fidelidade >= 1000 THEN
            RETURN 'PLATINUM';
        ELSIF self.pontos_fidelidade >= 500 THEN 
            RETURN 'GOLD';
        ELSIF self.pontos_fidelidade >= 250 THEN
            RETURN 'SILVER';
        ELSE
            RETURN 'BRONZE';
        END IF;
    END;
END;
/

CREATE TABLE tb_cliente OF tp_cliente (
    cpf PRIMARY KEY,
    nome NOT NULL, 
    telefone NOT NULL,
    data_registro NOT NULL, 
    cliente_indicador SCOPE IS tb_cliente,
    CONSTRAINT cliente_cpf_check CHECK (LENGTH(CPF) = 11),
    CONSTRAINT pontos_check CHECK (pontos_fidelidade >= 0)
) 
NESTED TABLE clientes_indicados STORE AS ntab_indicados,
NESTED TABLE dependentes STORE AS ntab_dependentes;

-- fim Cliente


-- Promocao
CREATE OR REPLACE TYPE tp_promocao AS OBJECT (
    codigo INT,
    nome VARCHAR2(40),
    desconto NUMBER(2)
);
/

CREATE TABLE tb_promocao OF tp_promocao (
    codigo PRIMARY KEY,
    desconto NOT NULL,
    CONSTRAINT promcod_gtezero CHECK (codigo >= 0),
    CONSTRAINT desconto_check CHECK (5<=desconto AND Desconto<=90)
);
-- fim Promocao


-- Pacote 
CREATE OR REPLACE TYPE tp_pacote AS OBJECT (
    codigo INT,
    nome VARCHAR2(40),
    preco_base NUMBER(7,2),

    CONSTRUCTOR FUNCTION tp_pacote(
        codigo INT,
        nome VARCHAR2,
        preco_base NUMBER
    ) RETURN SELF AS RESULT,

    MEMBER FUNCTION get_preco_final(promocao IN REF tp_promocao) RETURN NUMBER
);
/

CREATE OR REPLACE TYPE BODY tp_pacote AS
    
    CONSTRUCTOR FUNCTION tp_pacote(codigo INT, nome VARCHAR2, preco_base NUMBER) 
    RETURN SELF AS RESULT IS
    BEGIN
        self.codigo := codigo;
        self.nome := nome;
        self.preco_base := preco_base;
        RETURN;
    END;

    MEMBER FUNCTION get_preco_final(promocao IN REF tp_promocao) RETURN NUMBER IS
        v_preco NUMBER;
        v_promocao tp_promocao;
    BEGIN
        IF promocao IS NULL THEN
            RETURN self.preco_base;
        END IF;

        BEGIN
            SELECT VALUE(p) INTO v_promocao FROM 
            tb_promocao p 
            WHERE p.codigo = DEREF(promocao).codigo;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                return self.preco_base;
        END;
        v_preco := self.preco_base * (1 - v_promocao.desconto/100);
        RETURN v_preco;
    END;
END;
/

CREATE TABLE tb_pacote OF tp_pacote (
    codigo PRIMARY KEY,
    preco_base NOT NULL,
    CONSTRAINT paccode_gtezero CHECK (codigo >= 0)
);
-- fim Pacote


-- Reserva
CREATE OR REPLACE TYPE tp_reserva AS OBJECT (
    cliente REF tp_cliente, 
    pacote REF tp_pacote,
    tem_promo REF tp_promocao,
    Data_hora_reserva DATE,
    Data_Entrada DATE,
    Data_Saida DATE,
    Data_Modificacao DATE,
    Status VARCHAR2(10),

    MAP MEMBER FUNCTION map_data_hora RETURN DATE
);
/

CREATE OR REPLACE TYPE BODY tp_reserva AS
    MAP MEMBER FUNCTION map_data_hora RETURN DATE IS
    BEGIN
        RETURN self.Data_hora_reserva;
    END;
END;
/

CREATE TABLE tb_reserva OF tp_reserva (
    cliente WITH ROWID REFERENCES tb_cliente,
    pacote WITH ROWID REFERENCES tb_pacote,
    tem_promo WITH ROWID REFERENCES tb_promocao,
    Data_hora_reserva NOT NULL,
    Data_Modificacao NOT NULL,
    Data_Entrada NOT NULL,
    Data_Saida NOT NULL,
    Status NOT NULL,
    CONSTRAINT status_check CHECK (Status IN ('Reservado', 'Cancelado', 'Concluido')),
    CONSTRAINT data_valid CHECK (Data_Entrada <= Data_Saida)
);
-- fim Reserva


-- Atividade
CREATE OR REPLACE TYPE tp_atividade_tipo AS OBJECT(
    categoria VARCHAR2(25)
);
/

CREATE OR REPLACE TYPE tp_lista_ativ_tipos AS VARRAY(8) OF tp_atividade_tipo;
/

CREATE OR REPLACE TYPE tp_atividade AS OBJECT (
    codigo INT,
    nome VARCHAR2(40),
    descricao VARCHAR2(70),
    duracao NUMBER,
    tipo tp_lista_ativ_tipos
);
/

CREATE TABLE tb_atividade OF tp_atividade(
    codigo PRIMARY KEY,
    nome NOT NULL,
    duracao NOT NULL,
    tipo NOT NULL
);
-- fim Atividade


-- Tipo base fornecedor
CREATE OR REPLACE TYPE tp_fornecedor AS OBJECT (
    cnpj VARCHAR2(14),
    nome_empresa VARCHAR2(50),
    contatos tp_lista_contatos,

    NOT INSTANTIABLE MAP MEMBER FUNCTION total_capac RETURN INT,
    FINAL MEMBER FUNCTION calc_faturamento_potencial RETURN NUMBER, 
    FINAL MEMBER PROCEDURE add_contato(novo IN tp_contato),
    FINAL MEMBER PROCEDURE rem_contato(telefone IN VARCHAR2) 
) NOT FINAL NOT INSTANTIABLE;
/

--  Possui (Relacionamento N:N:N)
CREATE OR REPLACE TYPE tp_possui AS OBJECT(
    fornecedor REF tp_fornecedor,
    pacote REF tp_pacote,
    atividade REF tp_atividade
);
/

CREATE TABLE tb_possui OF tp_possui(
    pacote SCOPE IS tb_pacote,
    atividade SCOPE IS tb_atividade 
);
--  fim Possui

CREATE OR REPLACE TYPE BODY tp_fornecedor AS

    -- soma dos precos base dos pacotes que incluem atividades desse fornecedor 
    FINAL MEMBER FUNCTION calc_faturamento_potencial RETURN NUMBER IS
        v_total NUMBER := 0;
    BEGIN
        SELECT SUM(p.preco_base) INTO v_total
        FROM tb_pacote p, tb_possui pos
        WHERE REF(p) = pos.pacote
        AND SELF = DEREF(pos.fornecedor);
        
        RETURN NVL(v_total, 0);
    END;

    FINAL MEMBER PROCEDURE add_contato(novo IN tp_contato) IS
    BEGIN
        IF self.contatos.COUNT < self.contatos.LIMIT THEN
            self.contatos.EXTEND;
            self.contatos(self.contatos.LAST) := novo;
        ELSE 
            RAISE_APPLICATION_ERROR(-20002, 'A lista de contatos já está cheia.');
        END IF;
    END; 

    FINAL MEMBER PROCEDURE rem_contato(telefone IN VARCHAR2) IS
        v_index NUMBER := 0;
    BEGIN
        IF self.contatos.COUNT = 0 THEN
            raise_application_error(-20005, 'Não há contatos cadastrados');
        END IF;

        FOR i IN 1..self.contatos.COUNT LOOP
            IF self.contatos(i).telefone.numero = telefone THEN
                v_index := i;
                EXIT;
            END IF;
        END LOOP;
        
        IF v_index > 0 THEN
            FOR j IN v_index..self.contatos.COUNT-1 LOOP
                self.contatos(j) := self.contatos(j+1);
            END LOOP;
            self.contatos.TRIM;
        ELSE
            RAISE_APPLICATION_ERROR(-20003, 'Contato não encontrado.');
        END IF;
    END;
END;
/
-- fim Tipo base fornecedor


-- Especializacoes de fornecedor

--  hospedagem
CREATE OR REPLACE TYPE tp_fornecedor_hospedagem UNDER tp_fornecedor (
    acomodacao VARCHAR2(15),
    classificacao NUMBER(4,3),
    max_hospedes INT,

    OVERRIDING MAP MEMBER FUNCTION total_capac RETURN INT
);
/

CREATE TABLE tb_fornecedor_hospedagem OF tp_fornecedor_hospedagem (
    cnpj PRIMARY KEY,
    max_hospedes NOT NULL,
    acomodacao NOT NULL,
    classificacao NOT NULL,
    CONSTRAINT hosp_class_check CHECK (classificacao BETWEEN 0 AND 5),
    CONSTRAINT acom_check CHECK (acomodacao IN ('Albergue', 'Casa', 'Chale', 'Hotel', 'Pousada'))
);

CREATE OR REPLACE TYPE BODY tp_fornecedor_hospedagem AS
    OVERRIDING MAP MEMBER FUNCTION total_capac RETURN INT IS
    BEGIN
        RETURN self.max_hospedes;
    END;
END;
/
--  fim hospedagem


--  alimentacao
CREATE OR REPLACE TYPE tp_fornecedor_alimentacao UNDER tp_fornecedor (
    servico VARCHAR2(15),
    classificacao NUMBER(4,3),
    clientes_simult INT,

    OVERRIDING MAP MEMBER FUNCTION total_capac RETURN INT
);
/

CREATE TABLE tb_fornecedor_alimentacao OF tp_fornecedor_alimentacao (
    cnpj PRIMARY KEY,
    classificacao NOT NULL,
    clientes_simult NOT NULL,
    servico NOT NULL,
    CONSTRAINT alim_class_check CHECK (classificacao BETWEEN 0 AND 5),
    CONSTRAINT alim_serv_check CHECK (servico IN ('Buffet', 'Bar', 'Fast Food', 'Restaurante', 'Self-Service'))
);

CREATE OR REPLACE TYPE BODY tp_fornecedor_alimentacao AS
    OVERRIDING MAP MEMBER FUNCTION total_capac RETURN INT IS
    BEGIN
        RETURN self.clientes_simult;
    END;
END;
/
--  fim alimentacao


--  evento
CREATE OR REPLACE TYPE tp_fornecedor_evento UNDER tp_fornecedor (
    tipo VARCHAR2(15),
    capacidade_maxima INT,

    OVERRIDING MAP MEMBER FUNCTION total_capac RETURN INT
);
/

CREATE TABLE tb_fornecedor_evento OF tp_fornecedor_evento (
    cnpj PRIMARY KEY,
    capacidade_maxima NOT NULL,
    tipo NOT NULL,
    CONSTRAINT evento_tipo_check 
    CHECK (tipo IN ('Comemorativo', 'Corporativo', 'Cultural', 'Esportivo', 'Religioso', 'Musical', 'Comercial'))
);

CREATE OR REPLACE TYPE BODY tp_fornecedor_evento AS
    OVERRIDING MAP MEMBER FUNCTION total_capac RETURN INT IS
    BEGIN
        RETURN self.capacidade_maxima;
    END;
END;
/
--  fim evento


--  transporte
CREATE OR REPLACE TYPE tp_frota AS OBJECT(
    veiculo VARCHAR2(20),
    quantidade INT
);
/

CREATE OR REPLACE TYPE tp_frotas_transp AS TABLE OF tp_frota;
/

CREATE OR REPLACE TYPE tp_fornecedor_transporte UNDER tp_fornecedor (
    tipo_transporte VARCHAR2(15),
    frotas tp_frotas_transp,
    
    OVERRIDING MAP MEMBER FUNCTION total_capac RETURN INT,
    MEMBER PROCEDURE upsert_frota(v_veiculo VARCHAR2, v_quantidade INT)
);
/

CREATE TABLE tb_fornecedor_transporte OF tp_fornecedor_transporte (
    cnpj PRIMARY KEY,
    tipo_transporte NOT NULL,
    CONSTRAINT trans_tipo_check 
    CHECK (tipo_transporte IN ('Aereo', 'Ferroviario', 'Maritimo', 'Rodoviario'))
) NESTED TABLE frotas STORE AS ntab_frotas;

CREATE OR REPLACE TYPE BODY tp_fornecedor_transporte AS
    OVERRIDING MAP MEMBER FUNCTION total_capac RETURN INT IS
        v_total_vehic INT := 0;
    BEGIN
        SELECT SUM(f.quantidade) INTO v_total_vehic
        FROM TABLE(SELECT t.frotas
            FROM TB_FORNECEDOR_TRANSPORTE t
            WHERE t.cnpj = self.cnpj) f;

        RETURN v_total_vehic;
    END;

    MEMBER PROCEDURE upsert_frota(v_veiculo VARCHAR2, v_quantidade INT) IS
        v_exists NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_exists
        FROM TABLE(SELECT t.frotas
            FROM TB_FORNECEDOR_TRANSPORTE t
            WHERE t.cnpj = self.cnpj) f
        WHERE f.veiculo = v_veiculo;

        IF v_exists > 0 THEN
            UPDATE TABLE(SELECT t.frotas
                FROM TB_FORNECEDOR_TRANSPORTE t
                WHERE t.cnpj = self.cnpj) f
            SET f.quantidade = f.quantidade + v_quantidade
            WHERE f.veiculo = v_veiculo;
        ELSE
            INSERT INTO TABLE(SELECT t.frotas
                FROM TB_FORNECEDOR_TRANSPORTE t
                WHERE t.cnpj = self.cnpj)
            VALUES (tp_frota(v_veiculo, v_quantidade));
        END IF;
    END;
END;
/
--  fim transporte

-- fim Especializacoes de fornecedor
