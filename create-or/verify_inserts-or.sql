
/* mostrar infos de clientes que tem dependentes e indicados 
e as informacoes que provam isso
*/  
SELECT c.nome, c.cpf, c.pontos_fidelidade, 
       d.nome as dependente_nome, d.parentesco, 
       VALUE(i).nome as nome_indicado, VALUE(i).cliente_indicador.nome as nome_indicador
FROM tb_cliente c, TABLE(c.dependentes) d, TABLE(c.CLIENTES_INDICADOS) i;

-- verificar informacoes de clientes e por quem foi indicado
SELECT c1.nome as cliente, c1.pontos_fidelidade,
    DEREF(c1.cliente_indicador).nome as indicado_por
FROM tb_cliente c1
ORDER BY c1.pontos_fidelidade DESC;

-- SELECT * from TB_CLIENTE;

-- SELECT c1.nome as indicador, 
--        DEREF(VALUE(i)).nome as indicado
-- FROM tb_cliente c1, TABLE(c1.clientes_indicados) i;

-- SELECT p.nome_pacote, 
--        DEREF(VALUE(a)).nome as atividade_nome
-- FROM tb_pacotes p, TABLE(p.atividades) a;

-- SELECT f.nome_empresa, t.veiculo, t.quantidade
-- FROM tb_fornecedor_transporte f, TABLE(f.frotas) t;

-- SELECT r.Data_hora_reserva,
--        DEREF(r.cliente).nome as cliente_nome,
--        DEREF(r.pacote).nome_pacote as pacote_nome,
--        DEREF(r.tem_promo).nome as promocao_nome
-- FROM tb_reserva r;

-- SELECT c1.nome as cliente, c1.pontos_fidelidade,
--     DEREF(c1.cliente_indicador).nome as indicado_por
-- FROM tb_cliente c1
-- ORDER BY c1.pontos_fidelidade DESC;