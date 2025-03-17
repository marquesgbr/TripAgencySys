
CREATE SEQUENCE seq_codigo_pacote
    START WITH 1
    INCREMENT BY 1;

CREATE SEQUENCE seq_codigo_promocao
    START WITH 1
    INCREMENT BY 1;

CREATE SEQUENCE seq_codigo_atividade
    START WITH 1
    INCREMENT BY 1;


-- Create basic objects
-- First wave of clients (without indicators)
INSERT INTO tb_cliente VALUES (
    tp_cliente(
        '12345678901',
        'João Silva',
        tp_email('joao@email.com'),
        tp_telefone('81999887766'),
        SYSDATE,
        100,
        NULL,
        tp_possui_dep(),
        tp_nt_clientes_indicados()
    )
);

INSERT INTO tb_cliente VALUES (
    tp_cliente(
        '23456789012',
        'Maria Santos',
        tp_email('maria@email.com'),
        tp_telefone('81988776655'),
        SYSDATE,
        150,
        NULL,
        tp_possui_dep(),
        tp_nt_clientes_indicados()
    )
);

INSERT INTO tb_cliente VALUES (
    tp_cliente(
        '34567890123',
        'Pedro Costa',
        tp_email('pedro@email.com'),
        tp_telefone('81977665544'),
        SYSDATE,
        200,
        NULL,
        tp_possui_dep(),
        tp_nt_clientes_indicados()
    )
);

-- Second wave (indicated by first wave)
INSERT INTO tb_cliente VALUES (
    tp_cliente(
        '45678901234',
        'Ana Oliveira',
        tp_email('ana@email.com'),
        tp_telefone('81966554433'),
        SYSDATE,
        50,
        (SELECT REF(c) FROM tb_cliente c WHERE c.cpf = '12345678901'),
        tp_possui_dep(),
        tp_nt_clientes_indicados()
    )
);

INSERT INTO TABLE(
    SELECT c.clientes_indicados 
    FROM tb_cliente c 
    WHERE c.cpf = '12345678901'
) VALUES (
    (SELECT REF(c) FROM tb_cliente c WHERE c.cpf = '45678901234')
);

INSERT INTO tb_cliente VALUES (
    tp_cliente(
        '56789012345',
        'Carlos Lima',
        tp_email('carlos@email.com'),
        tp_telefone('81955443322'),
        SYSDATE,
        75,
        (SELECT REF(c) FROM tb_cliente c WHERE c.cpf = '23456789012'),
        tp_possui_dep(),
        tp_nt_clientes_indicados()
    )
);

INSERT INTO TABLE(
    SELECT c.clientes_indicados 
    FROM tb_cliente c 
    WHERE c.cpf = '23456789012'
) VALUES (
    (SELECT REF(c) FROM tb_cliente c WHERE c.cpf = '56789012345')
);

-- Third wave (indicated by second wave)
INSERT INTO tb_cliente VALUES (
    tp_cliente(
        '67890123456',
        'Mariana Costa',
        tp_email('mari@email.com'),
        tp_telefone('81944332211'),
        SYSDATE,
        25,
        (SELECT REF(c) FROM tb_cliente c WHERE c.cpf = '45678901234'),
        tp_possui_dep(),
        tp_nt_clientes_indicados()
    )
);

INSERT INTO TABLE(
    SELECT c.clientes_indicados 
    FROM tb_cliente c 
    WHERE c.cpf = '45678901234'
) VALUES (
    (SELECT REF(c) FROM tb_cliente c WHERE c.cpf = '67890123456')
);

-- Additional clients
INSERT INTO tb_cliente VALUES (
    tp_cliente(
        '78901234567',
        'Paulo Mendes',
        tp_email('paulo@email.com'),
        tp_telefone('81933221100'),
        SYSDATE,
        300,
        NULL,
        tp_possui_dep(),
        tp_nt_clientes_indicados()
    )
);

INSERT INTO tb_cliente VALUES (
    tp_cliente(
        '89012345678',
        'Julia Santos',
        tp_email('julia@email.com'),
        tp_telefone('81922110099'),
        SYSDATE,
        175,
        NULL,
        tp_possui_dep(),
        tp_nt_clientes_indicados()
    )
);

INSERT INTO tb_cliente VALUES (
    tp_cliente(
        '90123456789',
        'Roberto Silva',
        tp_email('roberto@email.com'),
        tp_telefone('81911009988'),
        SYSDATE,
        125,
        NULL,
        tp_possui_dep(),
        tp_nt_clientes_indicados()
    )
);

INSERT INTO tb_cliente VALUES (
    tp_cliente(
        '01234567890',
        'Sandra Pereira',
        tp_email('sandra@email.com'),
        tp_telefone('81900998877'),
        SYSDATE,
        225,
        NULL,
        tp_possui_dep(),
        tp_nt_clientes_indicados()
    )
);

INSERT INTO tb_cliente VALUES (
    tp_cliente(
        '12340567890',
        'Fernando Alves',
        tp_email('fernando@email.com'),
        tp_telefone('81989898989'),
        SYSDATE,
        275,
        NULL,
        tp_possui_dep(),
        tp_nt_clientes_indicados()
    )
);

-- Query to verify insertions and relationships
SELECT c1.nome as cliente,
    c1.pontos_fidelidade,
    DEREF(c1.cliente_indicador).nome as indicado_por,
    c2.nome as indica
FROM tb_cliente c1
LEFT JOIN TABLE(c1.clientes_indicados) refs
LEFT JOIN tb_cliente c2 ON REF(c2) = refs
ORDER BY c1.pontos_fidelidade DESC;



-- Create activity
INSERT INTO tb_atividades VALUES (
    tp_atividade(
        seq_codigo_atividade.NEXTVAL,
        'Passeio de Buggy',
        'Passeio nas dunas de Porto de Galinhas',
        4,
        'Aventura'
    )
);

-- Create promotion
INSERT INTO tb_promocoes VALUES (
    tp_promocao(
        seq_codigo_promocao.NEXTVAL,
        'Verão 2025',
        15
    )
);

-- Create package
INSERT INTO tb_pacotes VALUES (
    tp_pacote(
        seq_codigo_pacote.NEXTVAL,
        'Porto Weekend',
        500.00,
        tp_atividades_tab(
            (SELECT REF(a) FROM tb_atividades a WHERE a.nome = 'Passeio de Buggy')
        )
    )
);

-- Create fornecedor_transporte with frotas
INSERT INTO tb_fornecedor_transporte VALUES (
    tp_fornecedor_transporte(
        '12345678901234',
        'Transportes SA',
        tp_contato(
            tp_telefone('81988776655'),
            tp_email('contato@transportes.com')
        ),
        'Rodoviario',
        tp_frotas_transp(
            tp_frota('Ônibus', 5),
            tp_frota('Van', 3)
        )
    )
);

-- Create reservation
INSERT INTO tb_reserva VALUES (
    tp_reserva(
        (SELECT REF(c) FROM tb_cliente c WHERE c.cpf = '12345678901'),
        (SELECT REF(p) FROM tb_pacotes p WHERE p.codigo = 1),
        (SELECT REF(pr) FROM tb_promocoes pr WHERE pr.codigo = 1),
        SYSDATE,
        SYSDATE + 5,
        SYSDATE + 7,
        SYSDATE,
        'Reservado'
    )
);

-- Queries to verify inserted data
SELECT c.nome, c.cpf, c.pontos_fidelidade, 
       d.nome as dependente_nome, d.parentesco, 
       VALUE(i).nome as nome_indicado, VALUE(i).cliente_indicador.nome as nome_indicador
FROM tb_cliente c, TABLE(c.dependentes) d, TABLE(c.CLIENTES_INDICADOS) i;

SELECT * from TB_CLIENTE;

SELECT c1.nome as indicador, 
       DEREF(VALUE(i)).nome as indicado
FROM tb_cliente c1, TABLE(c1.clientes_indicados) i;

SELECT p.nome_pacote, 
       DEREF(VALUE(a)).nome as atividade_nome
FROM tb_pacotes p, TABLE(p.atividades) a;

SELECT f.nome_empresa, t.veiculo, t.quantidade
FROM tb_fornecedor_transporte f, TABLE(f.frotas) t;

SELECT r.Data_hora_reserva,
       DEREF(r.cliente).nome as cliente_nome,
       DEREF(r.pacote).nome_pacote as pacote_nome,
       DEREF(r.tem_promo).nome as promocao_nome
FROM tb_reserva r;