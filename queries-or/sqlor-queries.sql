
-- Gerar um relatorio de clientes exibindo seu todo historico de reservas e o total gasto 
SELECT 
    c.nome as cliente,
    c.get_categoria() as categoria_cliente,
    SUM(p.get_preco_final(r.tem_promo)) as total_gasto,
    LISTAGG(p.nome, ', ') 
    WITHIN GROUP (ORDER BY r.data_hora_reserva) as historico_pacotes
FROM tb_cliente c
LEFT JOIN tb_reserva r ON REF(c) = r.cliente
LEFT JOIN tb_pacote p ON REF(p) = r.pacote
WHERE r.status != 'Cancelado'
GROUP BY c.nome, c.get_categoria()
ORDER BY total_gasto DESC NULLS LAST;


-- Relatorio de clientes: sumariza numero de pacotes, dependentes e categoria por cliente
SELECT 
    c.nome,
    c.pontos_fidelidade,
    COUNT(r.pacote) as total_pacotes,
    COUNT(VALUE(d)) as total_dependentes,
    c.get_categoria() as categoria
FROM tb_cliente c
LEFT JOIN tb_reserva r ON REF(c) = r.cliente
LEFT JOIN TABLE(c.dependentes) d ON 1=1
GROUP BY c.nome, c.pontos_fidelidade, c.get_categoria()
ORDER BY c.pontos_fidelidade;

