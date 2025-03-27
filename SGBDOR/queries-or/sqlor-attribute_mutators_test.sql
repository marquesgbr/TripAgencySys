-- Aqui serao testados os metodos que modificam algum atributo de um objeto 
-- Metodos de migration-or:
--      add_contato(tp_contato)
--      rem_contato(tp_telefone)
--      add_pontos(number)
--      upsert_frota(VARCHAR2, INT) 


-- (add_contato) Adicionar contatos dedicados para fornecedores 5 estrelas
DECLARE
    v_novo_contato tp_contato;
    v_fornec_hosp tp_fornecedor_hospedagem;
    v_fornec_alim tp_fornecedor_alimentacao;
    
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
        v_fornec_hosp := hosp_rec.obj_hosp;
        
        v_novo_contato := tp_contato(
            tp_telefone('11946880' || SUBSTR(v_fornec_hosp.cnpj, -4)),
            tp_email('reservas.premium.' || 
                    LOWER(REGEXP_REPLACE(v_fornec_hosp.nome_empresa, '[^a-zA-Z]', '')) || 
                    '@concierge.com.br')
        );
        
        v_fornec_hosp.add_contato(v_novo_contato);
        
        UPDATE tb_fornecedor_hospedagem h
        SET h = v_fornec_hosp
        WHERE h.cnpj = v_fornec_hosp.cnpj;
        
        DBMS_OUTPUT.PUT_LINE('Hospedagem - ' || v_fornec_hosp.nome_empresa || 
                            CHR(10) || 'Telefone Premium: ' || v_novo_contato.telefone.numero ||
                            CHR(10) || 'Email Premium: ' || v_novo_contato.email.email ||
                            CHR(10));
    END LOOP;
    
    -- Processa fornecedores de alimentacao
    FOR alim_rec IN c_alim_favorito LOOP
        v_fornec_alim := alim_rec.obj_alim;
        
        v_novo_contato := tp_contato(
            tp_telefone('11957990' || SUBSTR(v_fornec_alim.cnpj, -4)),
            tp_email('gourmet.' || 
                    LOWER(REGEXP_REPLACE(v_fornec_alim.nome_empresa, '[^a-zA-Z]', '')) || 
                    '@chefexperience.com.br')
        );
        
        v_fornec_alim.add_contato(v_novo_contato);
        
        UPDATE tb_fornecedor_alimentacao a
        SET a = v_fornec_alim
        WHERE a.cnpj = v_fornec_alim.cnpj;
        
        DBMS_OUTPUT.PUT_LINE('Gastronomia - ' || v_fornec_alim.nome_empresa || 
                            CHR(10) || 'Telefone Gourmet: ' || v_novo_contato.telefone.numero ||
                            CHR(10) || 'Email Gourmet: ' || v_novo_contato.email.email ||
                            CHR(10));
    END LOOP;
END;
/


-- (rem_contato) Remove um contato de fornecedores (hospedagem e alimentacao) com classificacao abaixo de 3.0
DECLARE
    v_telefone VARCHAR2(20);
    v_fornec_hosp tp_fornecedor_hospedagem;
    v_fornec_alim tp_fornecedor_alimentacao;
    
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
        v_fornec_hosp := hosp_rec.obj_hosp;
        BEGIN
            SELECT c.telefone.numero INTO v_telefone
            FROM TABLE(v_fornec_hosp.contatos) c
            WHERE ROWNUM = 1;
            
            v_fornec_hosp.rem_contato(v_telefone);
            
            UPDATE tb_fornecedor_hospedagem h
            SET h = v_fornec_hosp
            WHERE h.cnpj = v_fornec_hosp.cnpj;
            
            DBMS_OUTPUT.PUT_LINE('Hospedagem - Removido contato ' || v_telefone || 
                               ' do fornecedor ' || v_fornec_hosp.nome_empresa || 
                               ' (classificação: ' || v_fornec_hosp.classificacao || ')');
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('Hospedagem - Sem contatos para remover de: ' || v_fornec_hosp.nome_empresa);
        END;
    END LOOP;
    
    -- Processa fornecedores de alimentacao
    FOR alim_rec IN c_alim_baixa_class LOOP
        v_fornec_alim := alim_rec.obj_alim;
        BEGIN
            SELECT c.telefone.numero INTO v_telefone
            FROM TABLE(v_fornec_alim.contatos) c
            WHERE ROWNUM = 1;
            
            v_fornec_alim.rem_contato(v_telefone);
            
            UPDATE tb_fornecedor_alimentacao a
            SET a = v_fornec_alim
            WHERE a.cnpj = v_fornec_alim.cnpj;
            
            DBMS_OUTPUT.PUT_LINE('Alimentação - Removido contato ' || v_telefone || 
                               ' do fornecedor ' || v_fornec_alim.nome_empresa || 
                               ' (classificação: ' || v_fornec_alim.classificacao || ')');
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('Alimentação - Sem contatos para remover de: ' || v_fornec_alim.nome_empresa);
        END;
    END LOOP;
END;
/


-- (add_pontos) Bonificacao de pontos baseada no valor dos pacotes reservados
DECLARE
    v_cliente tp_cliente;
    v_bonus_points NUMBER;
    
    CURSOR c_clientes_ativos IS
        WITH pontos_por_reserva AS (
            SELECT 
                c.cpf,
                VALUE(c) as obj_cliente,
                p.preco_base,
                CASE 
                    WHEN p.preco_base >= 1500 THEN 100
                    ELSE 50
                END as pontos_ganhos
            FROM tb_cliente c
            JOIN tb_reserva r ON REF(c) = r.cliente
            JOIN tb_pacote p ON REF(p) = r.pacote
            WHERE r.status != 'Cancelado'
        )
        SELECT 
            obj_cliente,
            SUM(pontos_ganhos) as total_bonus
        FROM pontos_por_reserva
        GROUP BY cpf, obj_cliente
        HAVING SUM(pontos_ganhos) > 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Iniciando programa de bonificação por valor de pacote...');
    DBMS_OUTPUT.PUT_LINE('Regras: 100 pontos para pacotes >= R$1500');
    DBMS_OUTPUT.PUT_LINE('        50 pontos para pacotes < R$1500');
    DBMS_OUTPUT.PUT_LINE('----------------------------------------');
    
    FOR cliente IN c_clientes_ativos LOOP
        v_cliente := cliente.obj_cliente;
        
        v_cliente.add_pontos(cliente.total_bonus);
        
        UPDATE tb_cliente c
        SET c = v_cliente
        WHERE c.cpf = v_cliente.cpf;
        
        DBMS_OUTPUT.PUT_LINE('Cliente: ' || v_cliente.nome || 
                            CHR(10) || 'Pontos adicionados: ' || cliente.total_bonus ||
                            CHR(10) || 'Novo total: ' || v_cliente.get_pontos() ||
                            CHR(10));
    END LOOP;
END;
/


-- (upsert_frota) Atualizacao da frota apenas para fornecedores de transporte 
-- que participam de algum pacote 
DECLARE
    v_obj_transp tp_fornecedor_transporte;
    
    CURSOR c_transp_com_pacotes IS
        SELECT 
            t.cnpj, 
            COUNT(DISTINCT p.codigo) AS total_pacotes
        FROM tb_fornecedor_transporte t
        JOIN tb_possui pos ON REF(t) = pos.fornecedor
        JOIN tb_pacote p ON REF(p) = pos.pacote
        JOIN tb_reserva r ON REF(p) = r.pacote
        WHERE t.tipo_transporte = 'Aereo'
        GROUP BY t.cnpj
        HAVING COUNT(DISTINCT p.codigo) > 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Atualizando frota apenas para fornecedores com pacotes ativos...');

    FOR transp IN c_transp_com_pacotes LOOP

        SELECT VALUE(t) INTO v_obj_transp
        FROM tb_fornecedor_transporte t
        WHERE t.cnpj = transp.cnpj;

        DBMS_OUTPUT.PUT_LINE('Fornecedor: ' || v_obj_transp.nome_empresa ||
                            CHR(10) || 'Capacidade antiga: ' || v_obj_transp.total_capac() ||
                            CHR(10) || 'Pacotes ativos: ' || transp.total_pacotes);
        
        -- Calcula quantidade baseada no numero de pacotes
        v_obj_transp.upsert_frota('Boeing 737', GREATEST(25, 20*transp.total_pacotes));
        v_obj_transp.upsert_frota('Airbus A320', CEIL(transp.total_pacotes*15));
        
        UPDATE tb_fornecedor_transporte t
        SET t = v_obj_transp
        WHERE t.cnpj = v_obj_transp.cnpj;
        
        DBMS_OUTPUT.PUT_LINE('Frota atualizada:' ||
                            CHR(10) || 'Nova capacidade total: ' || v_obj_transp.total_capac() ||
                            CHR(10));
    END LOOP;
END;
/

