-- (Exemplo) 
-- Teste de insercao de um novo tipo de frota para algum fornecedor de transporte  
DECLARE
    v_fornecedor tp_fornecedor_transporte;
BEGIN
    SELECT VALUE(f) INTO v_fornecedor 
    FROM tb_fornecedor_transporte f 
    WHERE ROWNUM = 1;
    
    v_fornecedor.upsert_frota('Novo Veículo', 5);
END;
/

