-- SQLBook: Code

-- 1. `pkg_gestao_clientes` (Package): 
-- Gerencia informações de clientes com funções para consulta e atualização de pontos, usando records personalizados.
CREATE OR REPLACE PACKAGE pkg_gestao_clientes AS
    TYPE t_cliente_record IS RECORD (
        cpf cliente.cpf%TYPE,
        nome cliente.nome%TYPE,
        pontos cliente.pontos_fidelidade%TYPE
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
                SELECT cpf, nome, pontos_fidelidade FROM cliente WHERE cpf = p_cpf;
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
        SELECT pontos_fidelidade INTO v_pontos 
        FROM cliente 
        WHERE cpf = p_cpf;

        p_pontos := p_pontos + v_pontos;

        UPDATE cliente 
        SET pontos_fidelidade = p_pontos 
        WHERE cpf = p_cpf;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'Cliente não encontrado');
    END atualiza_pontos_cliente;
END pkg_gestao_clientes;


-- 4. `trg_reserva_completa` (Trigger): 
-- Monitora inserções/atualizações em Reservas, atualizando pontos do cliente (+100 para reservas, -100 para cancelamentos).
CREATE OR REPLACE TRIGGER trg_reserva_completa
AFTER INSERT OR UPDATE ON Reserva
FOR EACH ROW
DECLARE
    v_cliente_row cliente%ROWTYPE;
    v_pontos NUMBER;
BEGIN
    SELECT * INTO v_cliente_row 
    FROM cliente 
    WHERE cpf = :NEW.CPFConsumidor;

    CASE
        WHEN :NEW.status = 'Reservado' THEN
            v_pontos := 100;
        WHEN :NEW.status = 'Cancelado' THEN
            v_pontos :=-100;
        ELSE
            v_pontos := 10;
    END CASE;
    pkg_gestao_clientes.atualiza_pontos_cliente(:NEW.CPFConsumidor, v_pontos);
END trg_reserva_completa;


-- 5. `trg_bloquear_exclusao_pacote` (Trigger): 
-- Impede a exclusão de pacotes que possuem reservas associadas, usando uma contagem de registros.

CREATE TYPE t_codDelet_tab AS TABLE OF NUMBER; -- Rodar essa linha 1 vez antes de compilar o trigger abaixo
CREATE OR REPLACE TRIGGER trg_bloquear_exclusao_pacote
FOR DELETE ON Pacote
COMPOUND TRIGGER

    cod_delet t_codDelet_tab := t_codDelet_tab(); 

    BEFORE STATEMENT IS 
    BEGIN
        cod_delet.DELETE; 
    END BEFORE STATEMENT;

    AFTER EACH ROW IS
    BEGIN
        cod_delet.EXTEND;
        cod_delet(cod_delet.LAST) := :OLD.Codigo;
    END AFTER EACH ROW;

    AFTER STATEMENT IS
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count
        FROM Reserva
        WHERE CodPacote IN (SELECT COLUMN_VALUE FROM TABLE(cod_delet));

        IF v_count > 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Erro: Não é possível excluir pacotes que possuem reservas associadas.');
        END IF;
    END AFTER STATEMENT;
END trg_bloquear_exclusao_pacote;


-- 6. `trg_impedir_delete_allpacks` (Trigger): 
-- Impedir que haja zero pacotes depois que for inserido ao menos um pacote
CREATE OR REPLACE TRIGGER trg_impedir_delete_allpacks
AFTER DELETE ON Pacote
DECLARE
    v_total NUMBER;
BEGIN

    SELECT COUNT(*) INTO v_total FROM Pacote;

    IF v_total = 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Erro: Não é permitido excluir todos os pacotes de uma vez.');
    END IF;
END;


-- 7. `proc_analise_reservas` (Procedure):
-- Analisa reservas em um mês específico, contando total de reservas com status 'Reservado'.
CREATE OR REPLACE PROCEDURE proc_analise_reservas(
    p_mes IN NUMBER,
    p_total_reservas OUT NUMBER
) IS
    CURSOR c_reservas IS 
        SELECT * FROM Reserva 
        WHERE EXTRACT(MONTH FROM data_hora_reserva) = p_mes;
    v_reserva_row Reserva%ROWTYPE;
BEGIN
    p_total_reservas := 0;
    FOR reserva IN c_reservas LOOP
        IF reserva.status = 'Reservado' THEN
            p_total_reservas := p_total_reservas + 1;
        END IF;
    END LOOP;
END proc_analise_reservas;


-- 8. `pontos_distribuidos_periodo` (Function): 
-- Calcula pontos distribuídos em um período, limitado por contador máximo, usando WHILE LOOP.
CREATE OR REPLACE FUNCTION pontos_distribuidos_periodo(
    p_inicio DATE,
    p_fim DATE,
    p_contador_maximo IN NUMBER
) RETURN NUMBER IS
    v_total NUMBER := 0;
    v_contador NUMBER := 0;
    v_reserva_row Reserva%ROWTYPE;
    CURSOR c_reservas IS 
        SELECT * FROM Reserva 
        WHERE data_hora_reserva BETWEEN p_inicio AND p_fim AND status = 'Reservado';
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
END pontos_distribuidos_periodo;


-- 9. `categoriza_cliente` (Procedure): 
-- Classifica clientes em categorias (PLATINUM/GOLD/SILVER) baseado em pontos, com DDL dinâmico para criar coluna se necessário.

-- ALTER TABLE: necessário executar 1 vez antes de compilar procedure abaixo
ALTER TABLE CLIENTE ADD categoria VARCHAR2(20);

CREATE OR REPLACE PROCEDURE categoriza_cliente(
    p_cpf IN VARCHAR2
) IS
    v_pontos NUMBER;
BEGIN
    BEGIN
        SELECT pontos_fidelidade INTO v_pontos 
        FROM Cliente 
        WHERE cpf = p_cpf;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'Erro: Cliente não encontrado.');
    END;

    IF v_pontos > 1000 THEN
        UPDATE Cliente SET categoria = 'PLATINUM';
    ELSIF v_pontos > 500 THEN
        UPDATE Cliente SET categoria = 'GOLD';
    ELSE
        UPDATE Cliente SET categoria = 'SILVER';
    END IF;
END categoriza_cliente;


-- 10. Bloco Anônimo
-- Simula um programa de bônus de pontos de fidelidade para os clientes
DECLARE
    TYPE t_pontos_table IS TABLE OF Cliente.Pontos_Fidelidade%TYPE INDEX BY BINARY_INTEGER;
    v_pontos t_pontos_table;
    v_cpf Cliente.CPF%TYPE;
    i NUMBER := 1;
BEGIN
    FOR cliente_rec IN (SELECT CPF, Pontos_Fidelidade FROM Cliente) LOOP
        v_pontos(i) := cliente_rec.Pontos_Fidelidade * 1.2; -- 20% de bônus
        v_cpf := cliente_rec.CPF;
        DBMS_OUTPUT.PUT_LINE('Cliente: ' || v_cpf || ' terá ' || v_pontos(i) || ' pontos após o bônus.');
        i := i + 1;
    END LOOP;
END;
