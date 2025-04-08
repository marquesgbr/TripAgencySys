
------ EE2 23.2
-- Q1 (nao coloquei os atributos triviais, aqui so tem oq eh importante)

-- Tipos

CREATE OR REPLACE TYPE tp_endereco AS OBJECT (
    cep VARCHAR2(9),
    rua VARCHAR(50),
    numero INT,
    complemento VARCHAR(50)
);
/

CREATE OR REPLACE TYPE tp_telefone_pessoa AS OBJECT(
    numero VARCHAR2(15)
);
/

CREATE OR REPLACE TYPE tp_fones_pessoa AS VARRAY(5) of tp_telefone;
/ 

CREATE OR REPLACE TYPE tp_pessoa AS OBJECT(
    endereco tp_endereco,
    telefone tp_fones_pessoa,
    data_nascimento DATE,
    nome VARCHAR2(64),
    cpf VARCHAR2(11)
) NOT FINAL NOT INSTANTIABLE;
/

CREATE OR REPLACE TYPE tp_cargo AS OBJECT (
    cargo_nome VARCHAR2(20),
    salario NUMBER
);
/

CREATE OR REPLACE TYPE tp_funcionario UNDER tp_pessoa (
    cargo REF tp_cargo,
    supervisor REF tp_funcionario
);
/

CREATE OR REPLACE TYPE tp_cliente UNDER tp_pessoa(
    num_atendimentos INT
);
/

CREATE OR REPLACE TYPE tp_carro AS OBJECT (
    proprietario REF tp_cliente,
    placa VARCHAR2(7),
    marca VARCHAR2(30),
    modelo VARCHAR2(30),
    cor VARCHAR2(25)
);
/

CREATE OR REPLACE TYPE tp_telefone_empresa AS OBJECT(
    numero VARCHAR2(15)
);
/

CREATE OR REPLACE TYPE tp_fones_empresa AS VARRAY(6) OF tp_telefone_empresa;
/

CREATE OR REPLACE TYPE tp_fornecedor AS OBJECT(
    telefones tp_fones_empresa,
    cnpj VARCHAR2(14),
    nome_empresa VARCHAR2(30)
);
/

CREATE OR REPLACE TYPE tp_produto AS OBJECT(
    fornecedor REF tp_fornecedor,
    nome VARCHAR2(20),
    preco NUMBER
);
/

CREATE OR REPLACE TYPE tp_nt_produtos AS TABLE OF tp_produto;
/

CREATE OR REPLACE TYPE tp_servico AS OBJECT(
    produtos tp_nt_produtos,
    nome VARCHAR2(30),
    valor NUMBER
);
/

CREATE OR REPLACE TYPE tp_maquina AS OBJECT(
    codigo VARCHAR2(7),
    fabricante VARCHAR2(30),
    nome VARCHAR2(30)
);
/

CREATE OR REPLACE TYPE tp_atendimento AS OBJECT(
    funcionario REF tp_funcionario,
    carro REF tp_carro,
    servico REF tp_servico,
    maquina REF tp_maquina,
    custo_total NUMBER,
    data DATE
);
/


-- Tabelas

CREATE TABLE tb_cargo of tp_cargo (
    cargo_nome PRIMARY KEY,
    CONSTRAINT salario_minimo CHECK (salario >= 1400) 
);

CREATE TABLE tb_funcionario OF tp_funcionario (
    supervisor WITH ROWID REFERENCES tb_funcionario,
    cargo WITH ROWID REFERENCES tb_cargo,
    cpf PRIMARY KEY
);

CREATE TABLE tb_cliente OF tp_cliente (
    cpf PRIMARY KEY 
);

CREATE TABLE tb_carro OF tp_carro (
    proprietario WITH ROWID REFERENCES tb_cliente,
    placa PRIMARY KEY
);


CREATE TABLE tb_fornecedor OF tp_fornecedor (
    cnpj PRIMARY KEY
);

CREATE TABLE tb_servico OF tp_servico (
    codigo PRIMARY KEY
) NESTED TABLE produtos STORE AS nt_produtos;


CREATE TABLE tb_maquina OF tp_maquina (
    codigo PRIMARY KEY
);

CREATE TABLE tb_atendimento OF tp_atendimento (
    funcionario WITH ROWID REFERENCES tb_funcionario,
    carro WITH ROWID REFERENCES tb_carro,
    servico WITH ROWID REFERENCES tb_servico,
    maquina WITH ROWID REFERENCES tb_maquina,
    custo_total NOT NULL,
    data NOT NULL
);


-- Q2

-- a) Qual o serviço mais comum na oficina?
SELECT
    s.nome,
    COUNT(*) as ocorrencias
FROM tb_servico s
JOIN tb_atendimento a ON DEREF(a.servico).codigo = s.codigo
GROUP BY s.nome
ORDER BY ocorrencias DESC
FETCH FIRST 1 ROWS ONLY;


-- b) Qual a média salarial dos funcionários da oficina?
-- Minha resposta
SELECT AVG(c.salario) as salario_medio
FROM tb_cargo c
JOIN tb_funcionario f ON DEREF(f.cargo).cargo_nome = c.cargo_nome;
-- Monitoria
SELECT AVG((DEREF(f.cargo)).salario) as media_salarial
FROM tb_funcionario f
WHERE DEREF(f.cargo) IS NOT NULL;


-- c) Qual o funcionário que efetuou mais serviços?
SELECT f.cpf, f.nome, COUNT(*) as num_servicos
FROM tb_funcionario f
JOIN tb_atendimento a ON DEREF(a.funcionario).cpf = f.cpf
GROUP BY f.cpf, f.nome
ORDER BY num_servicos DESC
FETCH FIRST 1 ROWS ONLY;

-- i) Quais os produtos utilizados no 'Serviço de Freios' e o preço de cada um deles?
-- Consulta a nested table
SELECT p.nome, p.preco FROM TABLE (
    SELECT s.produtos FROM tb_servico s
    WHERE s.nome LIKE 'Serviço de Freios'
) p;

-- j) Mostre quanto cada cliente gastou no total, ou seja, contando 
-- com todos os atendimentos realizados, para cada cliente.

SELECT DEREF(c.proprietario).nome as proprietario, SUM(a.custo_total) as total_gasto
FROM tb_carro c
INNER JOIN tb_atendimento a ON DEREF(a.carro).placa = c.placa
GROUP BY proprietario
ORDER BY total_gasto DESC;

-- k) Qual foi o atendimento mais caro? Selecione o serviço que foi 
-- feito, a data, o funcionário que fez o serviço, além do custo e a 
-- placa e modelo do carro em que esse serviço foi feito.

SELECT 
    DEREF(a.servico).nome as Servico, 
    a.data as DataAtendimento,
    DEREF(a.funcionario).nome as Funcionario,
    a.custo_total as MaiorValor,
    DEREF(a.carro).placa as PlacaCarro,
    DEREF(a.carro).modelo as ModeloCarro 
FROM tb_atendimento a
WHERE a.custo_total = (SELECT MAX(custo_total) FROM tb_atendimento);


-- l) Qual a empresa que fornece 'Bateria' para o serviço de 
-- 'Troca de Bateria' da Oficina? Mostre o nome da empresa e seus telefones.

SELECT 
    DEREF(p.fornecedor).nome_empresa as NomeEmpresa,
    t AS FonesEmpresa
    FROM TABLE (
        SELECT s.produtos FROM tb_servico s
        WHERE s.nome LIKE 'Troca de Bateria'
    ) p, tb_fornecedor F, TABLE(F.telefones) t
WHERE p.nome LIKE 'Bateria'
AND f.nome_empresa = NomeEmpresa;


-- m) Quais os serviços que utilizam a máquina 'Elevador Automotivo'?
-- Minha Resposta (enxuta)
SELECT DISTINCT DEREF(a.servico).nome as NomeServico
FROM tb_atendimento a
WHERE DEREF(a.maquina).nome = 'Elevador Automotivo';
-- Monitoria (redundante, mas correta)
SELECT S.nome
FROM tb_servico S
INNER JOIN tb_atendimento A ON S.codigo = DEREF(A.servico).codigo
INNER JOIN tb_maquina M ON DEREF(A.maquina).codigo = M.codigo
WHERE M.nome = 'Elevador Automotivo'
GROUP BY S.nome;


-- d) Quais os nomes dos funcionários que não possuem supervisores? Quais os cargos deles?
SELECT f.nome as Nome, DEREF(f.cargo).nome_cargo as Cargo
FROM tb_funcionario f
WHERE f.supervisor IS NULL;


-- f) Qual a marca de carro mais frequente na oficina? Qual é a cor mais comum?
SELECT 
    c1.marca as Marca,
    COUNT(*) as CountMarca
FROM tb_carro c1
GROUP BY Marca
HAVING COUNT(*) = (SELECT MAX(COUNT(c2.marca)) FROM tb_carro c2 GROUP BY c2.marca);


-- e) Quais os modelos dos carros que possuem a cor ‘VERMELHO’?
SELECT c.modelo
FROM tb_carro c
WHERE c.cor = 'VERMELHO';

-- h) Consulte o nome, cpf e os números de celular dos funcionários que têm o cargo de ‘Mecânico’.
SELECT f.nome, f.cpf, fones.*
FROM tb_funcionario f, TABLE(f.telefone) fones
WHERE DEREF(f.cargo).cargo_nome = 'Mecânico'; 


-- Q3

-- e) Escreva o TYPE BODY de tp_cliente, escrevendo a função ‘exibirinformacoes’, que deve 
-- exibir as informações de um cliente. 
CREATE OR REPLACE TYPE tp_pessoa AS OBJECT (
    cpf VARCHAR2(14), 
    nome VARCHAR2(30), 
    data_nascimento DATE, 
    MEMBER PROCEDURE exibirInformacoes(SELF tp_pessoa)
) NOT FINAL NOT INSTANTIABLE;
/


CREATE OR REPLACE TYPE tp_cliente UNDER tp_pessoa ( 
    quantidade_de_compras INTEGER, 
    OVERRIDING MEMBER PROCEDURE exibirInformacoes(SELF tp_cliente)
);
/

CREATE OR REPLACE TYPE BODY tp_cliente AS
    OVERRIDING MEMBER PROCEDURE exibirInformacoes(SELF tp_cliente) IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('CPF: ' || SELF.cpf);
        DBMS_OUTPUT.PUT_LINE('Nome: ' || SELF.nome);
        DBMS_OUTPUT.PUT_LINE('Data de Nascimento: ' || SELF.data_nascimento);
        DBMS_OUTPUT.PUT_LINE('Qtde de Compras: ' || SELF.quantidade_de_compras);
    END;
END;


-- f) Crie uma função que, dado o CPF do cliente, retorne quanto ele gastou, levando em 
-- conta todas as compras que ele fez.CREATE OR REPLACE 
CREATE OR REPLACE FUNCTION calcularGasto(cpf IN VARCHAR) RETURN NUMBER IS
    v_total_gasto NUMBER := 0;
BEGIN
    SELECT SUM(DEREF(c.pedido).valor)
    INTO v_total_gasto
    FROM tb_compra c
    WHERE DEREF(c.cliente).cpf = cpf;

    RETURN v_total_gasto;
END calcularGasto;

-- c) Quais os ingredientes do ‘Brownie Recheado’? Informe os nomes dos ingredientes e seus fornecedores.
SELECT i.nome, DEREF(i.empresa).nome as NomeEmpresa 
FROM TABLE (
    SELECT d.ingredientes 
    FROM tb_doces d WHERE d.nome = 'Brownie Recheado'
) i;





-- b) Qual o doce mais vendido pela doceria? Informe o seu código, nome e quantidade vendida.
CREATE TABLE tb_contem OF tp_contem (
    pedido WITH ROWID REFERENCES tb_pedido, 
    doce WITH ROWID REFERENCES tb_doce, 
    quantidade_doces NOT NULL
);

SELECT 
    DEREF(c.doce).codigo_doce as CodigoDoce, 
    DEREF(c.doce).nome as NomeDoce,
    SUM(c.quantidade_doces) as QuantidadeVendida 
FROM tb_contem c 
GROUP BY CodigoDoce, NomeDoce
HAVING SUM(c.quantidade_doces) = (
    SELECT MAX(SUM(c.quantidade_doces)) FROM tb_contem c GROUP BY c.doce
);



-- Infos para c) e d) da 22.2-Q3-L3
CREATE OR REPLACE TYPE tp_hora_aula AS OBJECT( 
    dia_semana VARCHAR(3), 
    hora_inicio INT, 
    hora_fim INT);
/

CREATE OR REPLACE TYPE tp_va_hora_aula AS VARRAY(5) OF tp_hora_aula;
/

CREATE OR REPLACE TYPE tp_disciplina AS OBJECT(
    cod_disc  VARCHAR(5), 
    nome_disc VARCHAR(50), 
    objetivo  VARCHAR(200), 
    horarios tp_va_hora_aula,
    MEMBER FUNCTION checa_choque_horario(cod_disc_check VARCHAR) RETURN VARCHAR);
/

CREATE OR REPLACE TYPE tp_nota AS OBJECT(nota NUMBER(4,2));
/

CREATE OR REPLACE TYPE tp_va_notas AS VARRAY(6) OF tp_nota;
/

CREATE OR REPLACE TYPE tp_cursa_disc AS OBJECT (disc_ref REF tp_disciplina, notas tp_va_notas);
/

CREATE OR REPLACE TYPE tp_nt_bruxo_cursa AS TABLE OF tp_cursa_disc;
/

CREATE OR REPLACE TYPE tp_bruxo AS OBJECT(
    cod_bruxo VARCHAR(5), 
    nome_bruxo VARCHAR(50), 
    idade INTEGER, 
    casa  VARCHAR(15), 
    cursa_disc tp_nt_bruxo_cursa, 
    MEMBER PROCEDURE add_nota(cod_disc_up VARCHAR, nota NUMBER)
);
/

-- c) Escreva o TYPE BODY de tp_bruxo, escrevendo a função add_nota, que deve 
-- adicionar uma nota de uma disciplina no histórico do aluno.
CREATE OR REPLACE TYPE BODY tp_bruxo AS
    MEMBER PROCEDURE add_nota(cod_disc_up VARCHAR, nota NUMBER) IS
        v_notas_aluno tp_va_notas;
        v_len INT;
    BEGIN
        SELECT cd.notas INTO v_notas_aluno
        FROM tb_bruxo b, TABLE(b.cursa_disc) cd
        WHERE b.cod_bruxo = SELF.cod_bruxo AND
        cd.disc_ref.cod_disc = cod_disc_up;
        
        v.notas_aluno.EXTEND;
        v_len := v.notas_aluno.LENGTH;
        v.notas_aluno(v_len) := nota;

        UPDATE TABLE(
            SELECT b.cursa_disc FROM tb_bruxo b WHERE b.cod_bruxo = SELF.cod_bruxo
        ) 
        SET notas = v_notas_aluno
        WHERE DEREF(disc_ref).cod_disc = cod_disc;
    END;
END;


-- d) Escreva o TYPE BODY de tp_disciplina, escrevendo a 
-- função checa_choque_horario, que recebe outra disciplina como parâmetro e 
-- retorna ‘S’ se houver choque de horário e ‘N’ se não houver.
CREATE OR REPLACE TYPE BODY tp_disciplina AS
    MEMBER FUNCTION checa_choque_horario(cod_disc_check VARCHAR) RETURN VARCHAR IS
        v_horarios_outra tp_va_hora_aula;
    BEGIN
        SELECT d.horarios INTO v_horarios_outra
        FROM tb_disciplina d WHERE d.cod_disc = cod_disc_check;

        FOR i in 1..SELF.horarios.LENGTH LOOP
            FOR j in 1..v_horarios_outra.LENGTH LOOP
                IF SELF.horarios(i).dia_semana = v_horarios_outra(j).dia_semana THEN
                    IF (SELF.horarios(i).hora_inicio < v_horarios_outra(j).hora_fim) AND
                        (SELF.horarios(i).hora_fim > v_horarios_outra(j).hora_inicio) THEN
                        RETURN 'S';
                    END IF;
                END IF;
            END LOOP;
        END LOOP;

        RETURN 'N';

    END;
END;