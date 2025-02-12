
-- Mostra o numero de reservas feitas com o pacote de maior preco 
SELECT COUNT(*) AS TotalMaxPreco 
FROM Reserva r
WHERE CodPacote IN (
    SELECT Codigo 
    FROM Pacote 
    WHERE PrecoBase = (SELECT MAX(PrecoBase) FROM Pacote)
)
AND r.Status IN ('Reservado');

/* Mostra os 3 fornecedores da agencia que mais venderam nos ultimos 3 meses e 
o quanto eles venderam cada um, considerando as promocoes */ 
SELECT f.NomeEmpresa, f.CNPJ, SUM(NVL(pac.PrecoBase * (1 - promo.Desconto/100), pac.PrecoBase)) AS TotalVendas
FROM Fornecedor f
INNER JOIN Possui po ON f.CNPJ = po.CNPJFornecedor
INNER JOIN Pacote pac ON po.CodPacote = pac.Codigo
INNER JOIN Reserva r ON pac.Codigo = r.CodPacote
LEFT OUTER JOIN Promocao promo ON r.CodPromocao = promo.Codigo
WHERE r.Data_hora_reserva BETWEEN ADD_MONTHS(SYSDATE, -3) AND SYSDATE
AND r.Status IN ('Concluido', 'Reservado')
GROUP BY f.NomeEmpresa, f.CNPJ
ORDER BY TotalVendas DESC
FETCH FIRST 3 ROWS ONLY;

-- Ticket Medio (1 ano) de vendas de pacotes 
SELECT AVG(NVL(p.PrecoBase*(1 - promo.Desconto/100), p.PrecoBase)) AS TicketMedio
FROM Reserva r
JOIN Pacote p ON r.CodPacote = p.Codigo
JOIN Promocao promo ON r.CodPromocao = promo.Codigo
WHERE r.Status IN ('Concluido','Reservado')
AND r.Data_hora_reserva BETWEEN ADD_MONTHS(SYSDATE, -12) AND SYSDATE;

-- Atividades com "Tour" no nome ou descricao e que possuem duracao maior que 4 horas 
CREATE VIEW Longa_Viagem AS 
SELECT * FROM Atividade
WHERE (Nome LIKE '%Tour%' OR Descricao LIKE '%Tour%') AND Duracao > 4;

-- Para visualizar a view criada anteriormente 
SELECT * FROM Longa_viagem; 

-- Fornecedores de hospedagem e alimentacao com classificacao maior que 3 
SELECT f.CNPJ, f.NomeEmpresa
FROM Fornecedor f
JOIN FornecedorHospedagem fh ON f.CNPJ = fh.CNPJ_H
WHERE fh.Classificacao > 3
INTERSECT
SELECT f.CNPJ, f.NomeEmpresa
FROM Fornecedor f
JOIN FornecedorAlimentacao fa ON f.CNPJ = fa.CNPJ_A
WHERE fa.Classificacao > 3;


/* Listar as atividades presentes nos 5 pacotes mais vendidos nos ultimos 6 meses e que foram reservados 
por clientes que possuam algum dependente */ 
SELECT a.Nome, a.Descricao, p.CodPacote, familiaReservas.TotalReservas
FROM Atividade a
JOIN Possui p ON a.Codigo = p.CodAtividade
JOIN (
    SELECT r.CodPacote, COUNT(r.CodPacote) AS TotalReservas
    FROM Reserva r
    JOIN Cliente c ON r.CPFConsumidor = c.CPF
    WHERE c.CPF = ANY (
        SELECT DISTINCT CPFResponsavel FROM Dependente
        )
    AND r.Data_hora_reserva >= ADD_MONTHS(SYSDATE, -6)
    AND r.Status IN ('Concluido', 'Reservado')
    GROUP BY r.CodPacote
    ORDER BY TotalReservas DESC
    FETCH FIRST 5 ROWS ONLY
) familiaReservas ON p.CodPacote = familiaReservas.CodPacote
ORDER BY familiaReservas.TotalReservas DESC;

/* Clientes que nao indicaram ninguem e 
possuem uma quantidade maior que o minimo existente de pontos de fidelidade somado de 10
( pontos > min_pontos+10 ) */ 
SELECT CPF, Nome, Pontos_Fidelidade
FROM Cliente
WHERE CPF NOT IN (
    SELECT DISTINCT CPFIndicadoPor FROM Cliente 
    WHERE CPFIndicadoPor IS NOT NULL)
AND Pontos_Fidelidade - 10 > (SELECT MIN(Pontos_Fidelidade) FROM Cliente);


-- Clientes que nao fizeram uma indicacao E têm mais reservas que qualquer outro cliente que fez uma indicacao
SELECT c.CPF, c.Nome, COUNT(r.CodPacote) AS TotalReservas
FROM Cliente c
JOIN Reserva r ON c.CPF = r.CPFConsumidor
WHERE c.CPF NOT IN (SELECT DISTINCT CPFIndicadoPor FROM Cliente WHERE CPFIndicadoPor IS NOT NULL)
GROUP BY c.CPF, c.Nome
HAVING COUNT(r.CodPacote) > ALL (
    SELECT COUNT(r2.CodPacote)
    FROM Cliente c2
    JOIN Reserva r2 ON c2.CPF = r2.CPFConsumidor
    WHERE c2.CPF IN (SELECT DISTINCT CPFIndicadoPor FROM Cliente WHERE CPFIndicadoPor IS NOT NULL)
);

--  Atualiza todas as reservas que estao com status reservado para concluido 
-- se a data de saída for menor que a data atual
UPDATE Reservas
SET status = 'Concluido'
WHERE status = 'Reservado' AND Data_Saida < SYSDATE;

-- CREATE INDEX: Criar um índice na coluna 'Data_hora_reserva' da tabela 'Reserva'
CREATE INDEX idx_reserva_data ON Reserva(Data_hora_reserva);

-- Inserir cliente com e-mail invalido
INSERT INTO Cliente (CPF, Nome, Telefone, Email, Data_Registro, Pontos_Fidelidade)
VALUES (99999999999, 'Novo Cliente', '11987654321', 'novocliente@example.com.br.us.net', SYSDATE, 100);

-- DELETE para cliente com e-mail invalido
DELETE FROM Cliente WHERE CPF = 99999999999;

-- Exemplos de GRANT e REVOKE (Nao executavel)
GRANT SELECT ON Reserva TO funcionario;
REVOKE DELETE ON Reserva FROM funcionario;


