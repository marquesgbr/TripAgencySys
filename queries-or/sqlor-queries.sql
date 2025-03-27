
-- Mostrar historico de reservas canceladas de clientes 
-- e o que foi deixado de gastar (total_ngasto), agrupando por categoria
SELECT 
    c.nome as cliente,
    c.get_categoria() as categoria,
    SUM(p.get_preco_final(r.tem_promo)) as total_ngasto,
    LISTAGG(p.nome, ', ') 
    WITHIN GROUP (ORDER BY VALUE(r)) as historico_pacotes
FROM tb_cliente c
LEFT JOIN tb_reserva r ON REF(c) = r.cliente
LEFT JOIN tb_pacote p ON REF(p) = r.pacote
WHERE r.status = 'Cancelado'
GROUP BY c.nome, categoria
ORDER BY total_ngasto DESC NULLS LAST;


-- Relatorio geral de clientes:
-- sumariza reservas ativas totais, dependentes, indicados, categoria e pontos por cliente
SELECT 
    c.nome,
    c.get_categoria() as categoria,
    c.get_pontos() as pontos_atuais,
    COUNT(DISTINCT r.pacote) as total_pacotes,
    SUM(p.get_preco_final(r.tem_promo)) as valor_total_gasto,

    (SELECT COUNT(VALUE(d)) 
     FROM tb_cliente c3, TABLE(c3.dependentes) d
     WHERE c3.cpf = c.cpf) as total_dependentes,

    (SELECT LISTAGG(VALUE(i).nome, ', ') 
     WITHIN GROUP (ORDER BY VALUE(i) DESC)
     FROM tb_cliente c2, TABLE(c2.clientes_indicados) i 
     WHERE c2.cpf = c.cpf) as lista_indicados

FROM tb_cliente c
LEFT JOIN tb_reserva r ON REF(c) = r.cliente
LEFT JOIN tb_pacote p ON REF(p) = r.pacote
WHERE r.status != 'Cancelado'
GROUP BY c.nome, pontos_atuais, categoria, c.cpf
ORDER BY pontos_atuais DESC; 

-------------
-- Gerar um relatório de Fornecedor que exibe para cada fornecedor os Pacotes que ele fornece algum serviço para

CREATE OR REPLACE VIEW v_fornecedores_todos AS
WITH fornecedores AS (
    SELECT VALUE(fa) AS fornecedor FROM tb_fornecedor_alimentacao fa
    UNION ALL
    SELECT VALUE(fh) FROM tb_fornecedor_hospedagem fh
    UNION ALL
    SELECT VALUE(ft) FROM tb_fornecedor_transporte ft
    UNION ALL
    SELECT VALUE(fe) FROM tb_fornecedor_evento fe
)
SELECT 
    fs.fornecedor.cnpj AS cnpj,
    fs.fornecedor.nome_empresa AS nome_empresa
FROM fornecedores fs;

SELECT
    f.nome_empresa,
    f.cnpj,
    p.nome AS Pacote,
    p.preco_base as Preco_Pacote
FROM
    v_fornecedores_todos f
JOIN tb_pacote p ON 1=1
JOIN tb_possui ps ON ps.pacote = REF(p)
WHERE
    ps.fornecedor IN (
        SELECT REF(fa) FROM tb_fornecedor_alimentacao fa WHERE fa.cnpj = f.cnpj
        UNION ALL
        SELECT REF(fh) FROM tb_fornecedor_hospedagem fh WHERE fh.cnpj = f.cnpj
        UNION ALL
        SELECT REF(ft) FROM tb_fornecedor_transporte ft WHERE ft.cnpj = f.cnpj
        UNION ALL
        SELECT REF(fe) FROM tb_fornecedor_evento fe WHERE fe.cnpj = f.cnpj
    );


----------------

SELECT 
    h.acomodacao,
    h.nome_empresa,
    VALUE(h).calc_faturamento_potencial() as fat_pots
FROM tb_fornecedor_hospedagem h
WHERE (h.acomodacao, VALUE(h).calc_faturamento_potencial()) IN (
    SELECT 
        h2.acomodacao,
        MAX(VALUE(h2).calc_faturamento_potencial())
    FROM tb_fornecedor_hospedagem h2
    GROUP BY h2.acomodacao
)
ORDER BY VALUE(h) DESC;

----


DECLARE
    v_forn_transp tp_fornecedor_transporte;
    v_frota tp_frota;
    v_nome VARCHAR2(100);
    CURSOR c_fornec_transp IS SELECT VALUE(t) FROM tb_fornecedor_transporte t;
BEGIN
    OPEN c_fornec_transp;
    LOOP
        FETCH c_fornec_transp INTO v_forn_transp;
        EXIT WHEN c_fornec_transp%NOTFOUND;
        
        -- Print the fornecedor_transporte details
        DBMS_OUTPUT.PUT_LINE('Fornecedor: ' || v_forn_transp.tipo_transporte);
        
        -- Iterate over the frotas collection
        FOR i IN 1 .. v_forn_transp.frotas.COUNT LOOP
            v_frota := v_forn_transp.frotas(i);
            DBMS_OUTPUT.PUT_LINE('  Veículo: ' || v_frota.veiculo || ', Quantidade: ' || v_frota.quantidade);
        END LOOP;
    END LOOP;
    CLOSE c_fornec_transp;
END;
/

SELECT 
    a.servico,
    a.nome_empresa,
    a.classificacao
FROM tb_fornecedor_alimentacao a
WHERE (a.servico, a.classificacao) IN (
    SELECT 
        a2.servico,
        MAX(a2.classificacao)
    FROM tb_fornecedor_alimentacao a2
    GROUP BY a2.servico
)
ORDER BY VALUE(a) DESC;
-- 

SELECT 
    t.nome_empresa,
    t.tipo_transporte,
    f.veiculo,
    f.quantidade
FROM tb_fornecedor_transporte t,
     TABLE(t.frotas) f
WHERE (t.cnpj, f.quantidade) IN (
    SELECT 
        t2.cnpj,
        MAX(f2.quantidade)
    FROM tb_fornecedor_transporte t2,
         TABLE(t2.frotas) f2
    GROUP BY t2.cnpj
)
ORDER BY VALUE(t) DESC;

SELECT 
    e.tipo,
    e.nome_empresa,
    e.capacidade_maxima
FROM tb_fornecedor_evento e
WHERE (e.tipo, e.capacidade_maxima) IN (
    SELECT 
        e2.tipo,
        MAX(e2.capacidade_maxima)
    FROM tb_fornecedor_evento e2
    GROUP BY e2.tipo
)
ORDER BY VALUE(e) DESC;


-- Atividades que têm o tipo 'Cultural' e que têm mais de um tipo

SELECT
    a.codigo,
    a.nome,
    (SELECT t.categoria FROM TABLE(a.tipo) t WHERE ROWNUM = 1) AS tipo_principal,
    (SELECT LISTAGG(t.categoria, ', ') WITHIN GROUP (ORDER BY t.categoria)FROM TABLE(a.tipo) t) AS tipos_atividade,
    (SELECT COUNT(*) FROM TABLE(a.tipo) t) AS quantidade_tipos
FROM
    tb_atividade a
WHERE
    EXISTS (
        SELECT 1 
        FROM TABLE(a.tipo) t
        WHERE t.categoria = 'Cultural'
    )
    AND (SELECT COUNT(*) FROM TABLE(a.tipo) t) > 1
;

-- Veículos de cada empresa de transportes 

SELECT
    ft.nome_empresa,
    f.veiculo,
    ft.tipo_transporte,
    f.quantidade,
    ft.total_capac() AS capacidade_total
FROM
    tb_fornecedor_transporte ft,
    TABLE(ft.frotas) f
WHERE
    f.quantidade > 0
ORDER BY
    ft.nome_empresa,
    f.veiculo;


-- Relatório das promoções que cada cliente teve nos pacotes que ele comprou e quanto ele economizou

SELECT
    DEREF(r.cliente).nome AS cliente,
    p.nome AS nome_pacote,
    p.preco_base,    
    DEREF(r.tem_promo).nome AS nome_promocao,
    p.get_preco_final(r.tem_promo) AS preco_final,
    DEREF(r.tem_promo).desconto || '%' AS desconto,
    p.preco_base - p.get_preco_final(r.tem_promo) AS economia,
    p.codigo AS codigo_pacote,
    DEREF(r.tem_promo).codigo AS codigo_promocao
FROM tb_pacote p
JOIN tb_reserva r ON r.pacote = REF(p)
WHERE r.tem_promo IS NOT NULL
ORDER BY (p.preco_base - p.get_preco_final(r.tem_promo)) DESC;


