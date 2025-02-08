isso é uma quote
> oi carai
``` sql
aaaa
```


# Consultas SQL e Estruturas PL/SQL Sugeridas

### SQL Básico
- [x] SELECT-FROM-WHERE
- [x] ALTER TABLE
- [x] CREATE INDEX (Índice em CPF: CREATE INDEX idx_client_cpf ON clients(cpf))
- [x] INSERT INTO (Inserir novo cliente: INSERT INTO clients(cpf, nome) VALUES('123', 'João'))
- [x] UPDATE
- [x] DELETE (Remover reservas antigas: DELETE FROM reservas WHERE data < SYSDATE - 365)
- [x] BETWEEN (Buscar reservas do mês: SELECT * FROM reservas WHERE data_reserva BETWEEN '01-JAN-23' AND '31-JAN-23')
- [x] IN
- [x] LIKE (Buscar clientes por nome: SELECT * FROM clients WHERE nome LIKE 'João%')
- [x] IS NULL/IS NOT NULL (Verificar dependentes: SELECT * FROM dependentes WHERE responsavel_cpf IS NOT NULL)

### Joins e Funções
- [x] INNER JOIN (SELECT c.nome, r.data FROM clients c INNER JOIN reservas r ON c.cpf = r.client_cpf)
- [x] MAX/MIN/AVG/COUNT (SELECT MAX(pontos) FROM clients)
- [x] LEFT/RIGHT/FULL OUTER JOIN (SELECT c.nome, d.nome FROM clients c LEFT JOIN dependentes d ON c.cpf = d.responsavel_cpf)

### Subconsultas
- [x] Subconsulta com operador relacional (SELECT * FROM clients WHERE pontos > (SELECT AVG(pontos) FROM clients))
- [x] Subconsulta com IN (SELECT * FROM reservas WHERE client_cpf IN (SELECT cpf FROM clients WHERE pontos > 1000))
- [x] Subconsulta com ANY (SELECT * FROM pacotes WHERE valor < ANY (SELECT valor FROM promocoes))
- [x] Subconsulta com ALL (SELECT * FROM clients WHERE pontos > ALL (SELECT pontos FROM clients WHERE categoria = 'SILVER'))

### Agrupamento e Ordenação
- [x] ORDER BY (SELECT * FROM clients ORDER BY pontos DESC)
- [x] GROUP BY
- [x] HAVING (SELECT client_cpf, COUNT(*) FROM reservas GROUP BY client_cpf HAVING COUNT(*) > 5)
- [x] UNION/INTERSECT/MINUS (SELECT cpf FROM clients UNION SELECT responsavel_cpf FROM dependentes)

### Controle de Acesso
- [x] CREATE VIEW (CREATE VIEW v_clientes_vip AS SELECT * FROM clients WHERE pontos > 1000)
- [x] GRANT/REVOKE (GRANT SELECT ON v_clientes_vip TO analista_vendas)

### PL/SQL Básico
- [x] RECORD (Usado em pkg_gestao_clientes)
- [x] TABLE (Usado no bloco anônimo)
- [x] Bloco anônimo (Exemplo 6)
- [x] CREATE PROCEDURE (Vários exemplos)
- [x] CREATE FUNCTION (Vários exemplos)

### Tipos e Estruturas
- [x] %TYPE (Usado em pkg_gestao_clientes)
- [x] %ROWTYPE (Usado em trg_reserva_completa)
- [x] IF ELSIF (Usado em categoriza_cliente)
- [x] CASE WHEN (Usado em trg_reserva_completa)
- [x] LOOP EXIT WHEN (Usado em calc_pontos_periodo)
- [x] WHILE LOOP (Usado em calc_pontos_periodo)
- [x] FOR IN LOOP (Usado em proc_analise_reservas)

### Cursores e Exceções
- [x] SELECT INTO (Usado em vários exemplos)
- [x] CURSOR (OPEN, FETCH, CLOSE) (Usado em get_client_info)
- [x] EXCEPTION WHEN (Usado no package body)
- [x] Parâmetros (IN, OUT, IN OUT) (Usado em vários procedimentos)

### Packages e Triggers
- [x] CREATE PACKAGE (Exemplo 1)
- [x] CREATE PACKAGE BODY (Exemplo 2)
- [x] Trigger de comando
- [x] Trigger de linha (Exemplo 3)
