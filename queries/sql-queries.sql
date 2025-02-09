-- SQLBook: Code


-- Mostra o numero de reservas feitas com o pacote de maior preco
SELECT COUNT(*) AS TotalMaxPreco 
FROM Reservas 
WHERE CodPacote IN (
    SELECT Codigo 
    FROM Pacotes 
    WHERE PrecoBase = (SELECT MAX(PrecoBase) FROM Pacotes)
);

/* Mostra os 3 fornecedores da agencia que mais venderam nos ultimos 3 meses e 
o quanto eles venderam cada um, considerando as promocoes */
SELECT f.NomeEmpresa, f.CNPJ, SUM(NVL(pac.PrecoBase * (1 - promo.Desconto/100), pac.PrecoBase)) AS TotalVendas
FROM Fornecedor f
INNER JOIN Possui po ON f.CNPJ = po.CNPJFornecedor
INNER JOIN Pacote pac ON po.CodPacote = pac.Codigo
INNER JOIN Reserva r ON pac.Codigo = r.CodPacote
LEFT OUTER JOIN Promocao promo ON r.CodPromocao = promo.Codigo
WHERE r.Data_hora_reserva BETWEEN ADD_MONTHS(SYSDATE, -3) AND SYSDATE
GROUP BY f.NomeEmpresa, f.CNPJ
ORDER BY TotalVendas DESC
FETCH FIRST 3 ROWS ONLY;

-- Ticket Medio (1 ano) de vendas de pacotes
SELECT AVG(p.PrecoBase*(1 - promo.Desconto/100)) AS TicketMedio
FROM Reserva r
JOIN Pacote p ON r.CodPacote = p.Codigo
JOIN Promocao promo ON r.CodPromocao = promo.Codigo
WHERE Reserva.Status = 'Concluido' OR Reserva.Status = 'Reservado'
    AND r.Data_hora_reserva BETWEEN ADD_MONTHS(SYSDATE, -12) AND SYSDATE;

-- Atividades com "Tour" no nome ou descricao e que possuem duracao maior que 4 horas
CREATE VIEW Longa_Viagem AS 
SELECT * FROM Atividade
WHERE (Nome LIKE '%Tour%' OR Descricao LIKE '%Tour%') AND Duracao > 4;

-- Fornecedores de hospedagem e alimentacao com classificacao maior que 3
SELECT h.CNPJ_H, h.Classificacao
FROM FornecedorHospedagem h 
INTERSECT 
SELECT a.CNPJ_A, a.Classificacao
FROM FornecedorAlimentacao a
JOIN Fornecedor f ON a.CNPJ_A = f.CNPJ
GROUP BY f.NomeEmpresa
HAVING a.classificacao > 3;

/* Listar as atividades presentes nos 10 pacotes mais vendidos nos ultimos 6 meses e que foram reservados 
por clientes que possuem algum dependente */
SELECT a.Nome, a.Descricao
FROM Atividade a
JOIN Possui p ON a.Codigo = p.CodAtividade
WHERE p.CodPacote = ANY (
    SELECT r.CodPacote FROM Reserva r
    JOIN Cliente c ON r.CPFConsumidor = c.CPF
    JOIN Dependente d ON c.CPF = d.CPFResponsavel
    WHERE r.Data_hora_reserva >= ADD_MONTHS(SYSDATE, -6)
    GROUP BY r.CodPacote
    ORDER BY COUNT(r.CodPacote) DESC
    FETCH FIRST 10 ROWS ONLY
);

/* Clientes que nao indicaram ninguem e 
possuem uma quantidade maior que o minimo de pontos de fidelidade */
SELECT CPF, Nome, Pontos_Fidelidade
FROM Cliente
WHERE CPF NOT IN (
    SELECT DISTINCT CPFIndicadoPor FROM Cliente 
    WHERE CPFIndicadoPor IS NOT NULL)
AND Pontos_Fidelidade > (SELECT MIN(Pontos_Fidelidade) FROM Cliente);


-- Clientes que fizeram mais reservas que qualquer cliente que fez uma indicacao
SELECT c.CPF, c.Nome, COUNT(r.CodPacote) AS TotalReservas
FROM Cliente c
JOIN Reserva r ON c.CPF = r.CPFConsumidor
GROUP BY c.CPF, c.Nome
HAVING COUNT(r.CodPacote) > ALL (
    SELECT COUNT(r2.CodPacote)
    FROM Cliente c2
    JOIN Reserva r2 ON c2.CPF = r2.CPFConsumidor
    WHERE c2.CPF IN (SELECT DISTINCT CPFIndicadoPor FROM Cliente WHERE CPFIndicadoPor IS NOT NULL)
    GROUP BY c2.CPF
);


