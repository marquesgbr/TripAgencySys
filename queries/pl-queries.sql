
-- 1. `pkg_gestao_clientes` (Package): 
-- Gerencia informações de clientes com funções para consulta e atualização de pontos, usando records personalizados.
CREATE OR REPLACE PACKAGE pkg_gestao_clientes AS
    TYPE t_cliente_record IS RECORD (
        cpf clients.cpf%TYPE,
        nome clients.nome%TYPE,
        pontos clients.pontos%TYPE
    );
    
    FUNCTION get_client_info(p_cpf IN VARCHAR2) 
        RETURN t_cliente_record;
        
    PROCEDURE atualiza_pontos_cliente(
        p_cpf IN VARCHAR2,
        p_pontos IN OUT NUMBER
    );
END pkg_gestao_clientes;

CREATE OR REPLACE PACKAGE BODY pkg_gestao_clientes AS
-- 2. `get_client_info` (Function): 
-- Recupera informações do cliente usando cursor, retornando um record customizado com CPF, nome e pontos.
    FUNCTION get_client_info(p_cpf IN VARCHAR2) 
    RETURN t_cliente_record IS
        v_cliente t_cliente_record;
        CURSOR c_cliente IS 
            SELECT * FROM clients WHERE cpf = p_cpf;
    BEGIN
        OPEN c_cliente;
        FETCH c_cliente INTO v_cliente;
        CLOSE c_cliente;
        RETURN v_cliente;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'Cliente não encontrado');
    END get_client_info;

-- 3. `atualiza_pontos_cliente` (Procedure): 
-- Atualiza a pontuação de um cliente no sistema, somando novos pontos ao saldo existente.
    PROCEDURE atualiza_pontos_cliente(
        p_cpf IN VARCHAR2,
        p_pontos IN OUT NUMBER
    ) IS
        v_pontos NUMBER;
    BEGIN
        SELECT pontos INTO v_pontos 
        FROM clients 
        WHERE cpf = p_cpf;

        p_pontos := p_pontos + v_pontos;

        UPDATE clients 
        SET pontos = p_pontos 
        WHERE cpf = p_cpf;
    END atualiza_pontos_cliente;
END pkg_gestao_clientes;


-- 4. `trg_reserva_completa` (Trigger): 
-- Monitora inserções/atualizações em Reservas, atualizando pontos do cliente (+100 para reservas, -50 para cancelamentos).
CREATE OR REPLACE TRIGGER trg_reserva_completa
BEFORE INSERT OR UPDATE ON Reservas
FOR EACH ROW
DECLARE
    v_cliente_row clients%ROWTYPE;
BEGIN
    SELECT * INTO v_cliente_row 
    FROM clients 
    WHERE cpf = :NEW.client_cpf;

    CASE
        WHEN :NEW.status = 'Reservado' THEN
            pkg_gestao_clientes.atualiza_pontos_cliente(:NEW.client_cpf, 100);
        WHEN :NEW.status = 'Cancelado' THEN
            pkg_gestao_clientes.atualiza_pontos_cliente(:NEW.client_cpf, -50);
    END CASE;
END;

-- 5. `trg_bloquear_exclusao_pacote` (Trigger): 
-- Impede a exclusão de pacotes que possuem reservas associadas, usando uma contagem de registros.
CREATE OR REPLACE TRIGGER trg_bloquear_exclusao_pacote
BEFORE DELETE ON Pacote
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count 
    FROM Reserva
    WHERE CodPacote IN (SELECT Codigo FROM DELETED);

    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Erro: Não é possível excluir pacotes que possuem reservas associadas.');
    END IF;
END;

-- 6. `proc_analise_reservas` (Procedure):
-- Analisa reservas em um mês específico, contando total de reservas com status 'Reservado'.
CREATE OR REPLACE PROCEDURE proc_analise_reservas(
    p_mes IN NUMBER,
    p_total_reservas OUT NUMBER
) IS
    CURSOR c_reservas IS 
        SELECT * FROM reservas 
        WHERE EXTRACT(MONTH FROM data_reserva) = p_mes;
    v_reserva_row reservas%ROWTYPE;
BEGIN
    p_total_reservas := 0;
    FOR reserva IN c_reservas LOOP
        IF reserva.status = 'Reservado' THEN
            p_total_reservas := p_total_reservas + 1;
        END IF;
    END LOOP;
END;

-- 7. `calc_pontos_distribuidos_periodo` (Function): 
-- Calcula pontos distribuídos em um período, limitado por contador máximo, usando WHILE LOOP.
CREATE OR REPLACE FUNCTION calc_pontos_distribuidos_periodo(
    p_inicio DATE,
    p_fim DATE,
    p_contador_maximo IN NUMBER
) RETURN NUMBER IS
    v_total NUMBER := 0;
    v_contador NUMBER := 0;
    v_reserva_row reservas%ROWTYPE;
    CURSOR c_reservas IS 
        SELECT * FROM reservas 
        WHERE data_reserva BETWEEN p_inicio AND p_fim AND status = 'Reservado';
BEGIN
    IF p_inicio > p_fim THEN
        RAISE_APPLICATION_ERROR(-20002, 'Data de início maior que data de fim');
    END IF;
    OPEN c_reservas;
    WHILE v_contador < p_contador_maximo LOOP
        v_contador := v_contador + 1;
        EXIT WHEN c_reservas%NOTFOUND;
        FETCH c_reservas INTO v_reserva_row;
        v_total := v_total + 100;
    END LOOP;
    CLOSE c_reservas;
    RETURN v_total;
END;

DECLARE
    TYPE t_pontos_table IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;
    v_pontos t_pontos_table;
BEGIN
    FOR i IN 1..10 LOOP
        v_pontos(i) := i * 100;
    END LOOP;
END;

-- 8. `categoriza_cliente` (Procedure): 
-- Classifica clientes em categorias (PLATINUM/GOLD/SILVER) baseado em pontos, com DDL dinâmico para criar coluna se necessário.
CREATE OR REPLACE PROCEDURE categoriza_cliente(
    p_cpf IN VARCHAR2
) IS
    v_pontos NUMBER;
    v_dummy VARCHAR2(20);
BEGIN
    SELECT pontos INTO v_pontos 
    FROM clients 
    WHERE cpf = p_cpf;

    BEGIN
        SELECT column_name INTO v_dummy
        FROM all_tab_columns
        WHERE table_name = 'CLIENTE' 
        AND column_name = 'CATEGORIA';
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            EXECUTE IMMEDIATE 'ALTER TABLE CLIENTE ADD categoria VARCHAR2(20)';
    END;

    IF v_pontos > 1000 THEN
        UPDATE clients SET categoria = 'PLATINUM';
    ELSIF v_pontos > 500 THEN
        UPDATE clients SET categoria = 'GOLD';
    ELSE
        UPDATE clients SET categoria = 'SILVER';
    END IF;
END;