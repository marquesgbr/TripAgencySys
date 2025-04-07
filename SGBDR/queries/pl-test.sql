-- SQLBook: Code
-- Validation Script for Customer Management Package and Related Objects

-- 1. Test Package Creation and Basic Client Operations
DECLARE
    v_client pkg_gestao_clientes.t_cliente_record;
    v_points NUMBER := 100;
BEGIN
    -- Test get_client_info
    v_client := pkg_gestao_clientes.get_client_info('12345678901');
    DBMS_OUTPUT.PUT_LINE('Client Test: ' || v_client.nome || ' Points: ' || v_client.pontos);
    v_client := pkg_gestao_clientes.get_client_info('17894563322');
    DBMS_OUTPUT.PUT_LINE('Client Test: ' || v_client.nome || ' Points: ' || v_client.pontos);
    
    -- Test point update
    pkg_gestao_clientes.atualiza_pontos_cliente('17894563322', v_points);
    DBMS_OUTPUT.PUT_LINE('Updated points: ' || v_points);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in package test: ' || SQLERRM);
END;
/

-- 2. Test Reservation Trigger
INSERT INTO Reserva (
Data_hora_reserva,
CPFConsumidor,
CodPacote,
CodPromocao,
Data_Entrada,
Data_Saida,
Data_Modificacao, Status) 
VALUES (SYSDATE,'17894563322',1,1,SYSDATE,SYSDATE,SYSDATE, 'Reservado');

SELECT CPF, Pontos_Fidelidade FROM Cliente WHERE cpf = '17894563322';

-- 3. Test Package Deletion Protection
DELETE FROM Pacote WHERE Codigo = 1;

-- 4. Test Reservation Analysis
DECLARE
    v_total NUMBER;
BEGIN
    proc_analise_reservas(TO_NUMBER(TO_CHAR(SYSDATE, 'MM')), v_total);
    DBMS_OUTPUT.PUT_LINE('Total reservations this month: ' || v_total);
END;
/

-- 5. Test Points Distribution Function
DECLARE
    v_total_points NUMBER;
BEGIN
    v_total_points := pontos_distribuidos_periodo(
        SYSDATE - 30,
        SYSDATE,
        100
    );
    DBMS_OUTPUT.PUT_LINE('Total points distributed: ' || v_total_points);
END;
/

-- 6. Test Client Categorization
BEGIN
    categoriza_cliente('17894563322');
    
    -- Verify categorization
    FOR c IN (SELECT cpf, categoria FROM cliente WHERE cpf = '17894563322') LOOP
        DBMS_OUTPUT.PUT_LINE('Client category: ' || c.categoria);
    END LOOP;
END;
/