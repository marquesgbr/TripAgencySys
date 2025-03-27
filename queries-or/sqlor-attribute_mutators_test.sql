-- Aqui serao testados os metodos que modificam algum atributo de um objeto 
-- Metodos de migration-or:
--      add_contato(tp_contato)
--      rem_contato(tp_telefone)
--      add_pontos(number)
--      upsert_frota(VARCHAR2, INT) 


-- Teste de insercao de um novo tipo de frota para algum fornecedor de transporte  
-- DECLARE
--     v_fornecedor tp_fornecedor_transporte;
-- BEGIN
--     SELECT VALUE(f) INTO v_fornecedor 
--     FROM tb_fornecedor_transporte f 
--     WHERE ROWNUM = 1;
    
--     v_fornecedor.upsert_frota('Novo Veículo', 5);
-- END;
-- /


-- Adicionar contatos dedicados para fornecedores 5 estrelas
DECLARE
    v_fornec_hosp tp_fornecedor_hospedagem;
    v_fornec_alim tp_fornecedor_alimentacao;
    v_novo_contato tp_contato;
    v_obj_hosp tp_fornecedor_hospedagem;
    v_obj_alim tp_fornecedor_alimentacao;
    
    CURSOR c_hosp_favorito IS 
        SELECT VALUE(h) as obj_hosp
        FROM tb_fornecedor_hospedagem h 
        WHERE h.classificacao = 5;
        
    CURSOR c_alim_favorito IS 
        SELECT VALUE(a) as obj_alim
        FROM tb_fornecedor_alimentacao a 
        WHERE a.classificacao = 5;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Adicionando canais de atendimento premium para fornecedores 5 estrelas...');
    
    -- Processa fornecedores de hospedagem
    FOR hosp_rec IN c_hosp_favorito LOOP
        v_obj_hosp := hosp_rec.obj_hosp;
        
        v_novo_contato := tp_contato(
            tp_telefone('11946880' || SUBSTR(v_obj_hosp.cnpj, -4)),
            tp_email('reservas.premium.' || 
                    LOWER(REGEXP_REPLACE(v_obj_hosp.nome_empresa, '[^a-zA-Z]', '')) || 
                    '@concierge.com.br')
        );
        
        v_obj_hosp.add_contato(v_novo_contato);
        
        UPDATE tb_fornecedor_hospedagem h
        SET h = v_obj_hosp
        WHERE h.cnpj = v_obj_hosp.cnpj;
        
        DBMS_OUTPUT.PUT_LINE('Hospedagem - ' || v_obj_hosp.nome_empresa || 
                           CHR(10) || 'Telefone Premium: ' || v_novo_contato.telefone.numero ||
                           CHR(10) || 'Email Premium: ' || v_novo_contato.email.email ||
                           CHR(10));
    END LOOP;
    
    -- Processa fornecedores de alimentação
    FOR alim_rec IN c_alim_favorito LOOP
        v_obj_alim := alim_rec.obj_alim;
        
        v_novo_contato := tp_contato(
            tp_telefone('11957990' || SUBSTR(v_obj_alim.cnpj, -4)),
            tp_email('gourmet.' || 
                    LOWER(REGEXP_REPLACE(v_obj_alim.nome_empresa, '[^a-zA-Z]', '')) || 
                    '@chefexperience.com.br')
        );
        
        v_obj_alim.add_contato(v_novo_contato);
        
        UPDATE tb_fornecedor_alimentacao a
        SET a = v_obj_alim
        WHERE a.cnpj = v_obj_alim.cnpj;
        
        DBMS_OUTPUT.PUT_LINE('Gastronomia - ' || v_obj_alim.nome_empresa || 
                           CHR(10) || 'Telefone Gourmet: ' || v_novo_contato.telefone.numero ||
                           CHR(10) || 'Email Gourmet: ' || v_novo_contato.email.email ||
                           CHR(10));
    END LOOP;
END;
/



-- Remove um contato de fornecedores (hospedagem e alimentação) com classificação abaixo de 3.0
DECLARE
    v_fornec_hosp tp_fornecedor_hospedagem;
    v_fornec_alim tp_fornecedor_alimentacao;
    v_telefone VARCHAR2(20);
    v_obj_hosp tp_fornecedor_hospedagem;
    v_obj_alim tp_fornecedor_alimentacao;
    
    CURSOR c_hosp_baixa_class IS 
        SELECT VALUE(h) as obj_hosp
        FROM tb_fornecedor_hospedagem h 
        WHERE h.classificacao < 3.0;
        
    CURSOR c_alim_baixa_class IS 
        SELECT VALUE(a) as obj_alim
        FROM tb_fornecedor_alimentacao a 
        WHERE a.classificacao < 3.0;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Removendo contatos de fornecedores com baixa classificação...');
    
    -- Processa fornecedores de hospedagem
    FOR hosp_rec IN c_hosp_baixa_class LOOP
        v_obj_hosp := hosp_rec.obj_hosp;
        BEGIN
            SELECT c.telefone.numero INTO v_telefone
            FROM TABLE(v_obj_hosp.contatos) c
            WHERE ROWNUM = 1;
            
            v_obj_hosp.rem_contato(v_telefone);
            
            UPDATE tb_fornecedor_hospedagem h
            SET h = v_obj_hosp
            WHERE h.cnpj = v_obj_hosp.cnpj;
            
            DBMS_OUTPUT.PUT_LINE('Hospedagem - Removido contato ' || v_telefone || 
                               ' do fornecedor ' || v_obj_hosp.nome_empresa || 
                               ' (classificação: ' || v_obj_hosp.classificacao || ')');
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('Hospedagem - Sem contatos para remover de: ' || v_obj_hosp.nome_empresa);
        END;
    END LOOP;
    
    -- Processa fornecedores de alimentação
    FOR alim_rec IN c_alim_baixa_class LOOP
        v_obj_alim := alim_rec.obj_alim;
        BEGIN
            SELECT c.telefone.numero INTO v_telefone
            FROM TABLE(v_obj_alim.contatos) c
            WHERE ROWNUM = 1;
            
            v_obj_alim.rem_contato(v_telefone);
            
            UPDATE tb_fornecedor_alimentacao a
            SET a = v_obj_alim
            WHERE a.cnpj = v_obj_alim.cnpj;
            
            DBMS_OUTPUT.PUT_LINE('Alimentação - Removido contato ' || v_telefone || 
                               ' do fornecedor ' || v_obj_alim.nome_empresa || 
                               ' (classificação: ' || v_obj_alim.classificacao || ')');
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('Alimentação - Sem contatos para remover de: ' || v_obj_alim.nome_empresa);
        END;
    END LOOP;
END;
/