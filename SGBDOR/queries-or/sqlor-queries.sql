-- Alem das queries, aqui sao testadas/usadas todas as functions de migration-or:
--      get_idade()
--      compare_idade() (Order -> uso implicito para ordenar tp_dependente)
--      get_pontos() (Map -> uso explicito em select e implicito para agrupar/ordenar tp_cliente)
--      count_indicados()
--      get_categoria()
--      get_preco_final()
--      map_data_hora() (Map -> uso implicito para ordenar tp_reserva)
--      calc_faturamento_potencial()
--      total_capac() (Map -> uso implicito para ordenar tp_fornecedor; para todos os tipos)



-- Mostrar histórico de reservas canceladas de clientes 
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


-- Relatório geral de clientes:
-- sumariza reservas ativas totais, dependentes, indicados, categoria e pontos por cliente
SELECT 
    c.nome,
    c.get_categoria() as categoria,
    c.get_pontos() as pontos_atuais,
    COUNT(DISTINCT r.pacote) as total_pacotes,
    SUM(p.get_preco_final(r.tem_promo)) as valor_total_gasto,

    (SELECT COUNT(VALUE(d)) 
     FROM tb_cliente c2, TABLE(c2.dependentes) d
     WHERE c2.cpf = c.cpf) as total_dependentes,

    c.count_indicados() as num_indicados,
    (SELECT LISTAGG(VALUE(i).nome, ', ') 
     WITHIN GROUP (ORDER BY VALUE(i) DESC)
     FROM tb_cliente c3, TABLE(c3.clientes_indicados) i 
     WHERE c3.cpf = c.cpf) as lista_indicados

FROM tb_cliente c
LEFT JOIN tb_reserva r ON REF(c) = r.cliente
LEFT JOIN tb_pacote p ON REF(p) = r.pacote
WHERE r.status != 'Cancelado'
GROUP BY c.nome, pontos_atuais, categoria, num_indicados, c.cpf
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


-- Fornecedores de hospedagem que têm o maior faturamento potencial
-- em cada categoria de acomodação, ordenados (desc) pela quantidade hospedes que podem atender
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


-- Encontra estabelecimentos de alta classificação (>4) e sua participação em pacotes 
-- com preço base alto (>1000) mostrando a média de preço dos pacotes que 
-- atendem e quantos clientes já os buscaram (inclui reservas canceladas)
SELECT 
    a.nome_empresa,
    a.servico,
    a.classificacao,
    COUNT(DISTINCT p.codigo) as total_pacotes_premium,
    ROUND(AVG(p.preco_base), 2) as ticket_medio_pacote,
    COUNT(DISTINCT r.cliente) as total_clientes_atendidos,
    (SELECT LISTAGG(DEREF(r2.cliente).nome, ', ')
     WITHIN GROUP (ORDER BY DEREF(r2.cliente).get_pontos() DESC)
     FROM tb_reserva r2
     WHERE REF(p) = r2.pacote
     FETCH FIRST 3 ROWS ONLY) as top3_clientes
FROM tb_fornecedor_alimentacao a
JOIN tb_possui pos ON REF(a) = pos.fornecedor
JOIN tb_pacote p ON REF(p) = pos.pacote
LEFT JOIN tb_reserva r ON REF(p) = r.pacote
WHERE a.classificacao > 4
AND p.preco_base > 1000
GROUP BY a.nome_empresa, a.servico, a.classificacao, REF(p)
HAVING COUNT(DISTINCT r.cliente) > 0
ORDER BY a.classificacao DESC, total_clientes_atendidos DESC;


-- Encontra, para cada fornecedor de transporte, o veículo em
-- maior quantidade em sua frota
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


-- Mostra distribuição de capacidade por tipo de evento, destacando maior 
-- e menor espaço de cada tipo
SELECT 
    e.tipo,
    COUNT(*) as total_espacos,
    MIN(e.capacidade_maxima) as menor_espaco,
    MAX(e.capacidade_maxima) as maior_espaco,
    ROUND(AVG(e.capacidade_maxima)) as media_capacidade,
    LISTAGG(e.nome_empresa, ', ') 
    WITHIN GROUP (ORDER BY VALUE(e) DESC) as espacos_ordenados
FROM tb_fornecedor_evento e
GROUP BY e.tipo
HAVING COUNT(*) > 1
ORDER BY media_capacidade DESC;


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

-- Frotas de cada empresa de transportes e sua capacidade total
-- Ordenadas da que possui maior quantidade de veÍculos para a menor 

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
    VALUE(ft) DESC, ft.nome_empresa, f.veiculo;


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


-- Consulta promoções ativas, seu uso e economia média por promoção
SELECT 
    p.codigo,
    p.nome,
    p.desconto,
    COUNT(r.cliente) as total_uso,
    AVG(pac.preco_base * (p.desconto/100)) as economia_media
FROM tb_promocao p
LEFT JOIN tb_reserva r ON REF(p) = r.tem_promo
LEFT JOIN tb_pacote pac ON REF(pac) = r.pacote
GROUP BY p.codigo, p.nome, p.desconto
ORDER BY total_uso DESC;

-- Análise de famílias por categoria de responsável
SELECT 
    c.nome as titular,
    c.get_categoria() as categoria,
    d.nome as dependente,
    d.get_idade() as idade_dependente,
    d.parentesco,

    (SELECT COUNT(r.pacote) 
     FROM tb_reserva r 
     WHERE REF(c) = r.cliente) as total_pacotes_familia
FROM tb_cliente c
CROSS APPLY TABLE(c.dependentes) d
ORDER BY VALUE(c) DESC, VALUE(d);  

