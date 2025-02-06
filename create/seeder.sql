-- SQLBook: Code
-- Fornecedor
INSERT INTO Fornecedor (CNPJ, NomeEmpresa) 
VALUES ('17190555670023', 'CInDivirta');
INSERT INTO Fornecedor (CNPJ, NomeEmpresa) 
VALUES (LPAD(prov_seq.nextval, 14, '12'), 'nomedeempresaumpoucomaislongo');
INSERT INTO Fornecedor (CNPJ, NomeEmpresa) 
VALUES (LPAD(prov_seq.nextval, 14, '404'), 'Tour Sem Erros LTDA');

-- FornecedorHospedagem
INSERT INTO FornecedorHospedagem (CNPJ_H, Classificacao, Acomodacao)
VALUES (LPAD(seq_fornhosp.NEXTVAL, 14, '0'), 3.9, 'Hotel');
INSERT INTO FornecedorHospedagem (CNPJ_H, Classificacao, Acomodacao)
VALUES ('66666666000155', 4.7, 'Pousada');
INSERT INTO FornecedorHospedagem (CNPJ_H, Classificacao, Acomodacao)
VALUES ('77777777000166', 2.5, 'Albergue');

-- FornecedorAlimentacao
INSERT INTO FornecedorAlimentacao (CNPJ_A, Classificacao, Servico)
VALUES (LPAD(seq_fornalime.NEXTVAL, 14, '67'), 4.5, 'Restaurante');
INSERT INTO FornecedorAlimentacao (CNPJ_A, Classificacao, Servico)
VALUES ('22222222000111', 3.8, 'Buffet');
INSERT INTO FornecedorAlimentacao (CNPJ_A, Classificacao, Servico)
VALUES ('33333333000122', 5.0, 'Fast Food');

-- FornecedorEvento
INSERT INTO FornecedorEvento (CNPJ_E, Tipo, CapacidadeMaxima)
VALUES (LPAD(seq_fornevent.NEXTVAL, 14, '0'), 'Corporativo', 500);
INSERT INTO FornecedorEvento (CNPJ_E, Tipo, CapacidadeMaxima)
VALUES ('44444444000133', 'Comemorativo', 250);
INSERT INTO FornecedorEvento (CNPJ_E, Tipo, CapacidadeMaxima)
VALUES ('55555555000144', 'Esportivo', 1000);

-- FornecedorTransporte
INSERT INTO FornecedorTransporte (CNPJ_T, TipoTransporte)
VALUES (LPAD(seq_fornt.NEXTVAL, 14, '0'), 'Rodoviario');
INSERT INTO FornecedorTransporte (CNPJ_T, TipoTransporte)
VALUES ('11111111000199', 'Aereo');
INSERT INTO FornecedorTransporte (CNPJ_T, TipoTransporte)
VALUES ('22222222111222', 'Maritimo');

-- FrotaTransportadora
INSERT INTO FrotaTransportadora (CNPJTransportadora, Veiculo, Quantidade)
VALUES (LPAD(seq_frotatransp.NEXTVAL, 14, '0'), 'Onibus', 25);
INSERT INTO FrotaTransportadora (CNPJTransportadora, Veiculo, Quantidade)
VALUES ('88888888000177', 'Carro', 50);
INSERT INTO FrotaTransportadora (CNPJTransportadora, Veiculo, Quantidade)
VALUES ('99999999000188', 'Aviao', 10);

-- ContatoFornecedor
INSERT INTO ContatoFornecedor (CodFornecedor, Telefone, Email)
VALUES (LPAD(seq_codfornecedor.NEXTVAL, 14, '21'), '11987654321', 'contato@empresa1.com.us');
INSERT INTO ContatoFornecedor (CodFornecedor, Telefone, Email)
VALUES ('12345678000195', '21987654321', 'suporte@empresa88.com.br');
INSERT INTO ContatoFornecedor (CodFornecedor, Telefone, Email)
VALUES ('98765432000187', '31999998888', 'atendimento@empresa2.com');

-- Cliente
INSERT INTO Cliente (CPF, CPFIndicadoPor, Nome, Telefone, Email, Data_Registro, Pontos_Fidelidade)
VALUES (17894563322, NULL, 'Luiza Souza', '14085990321', 'souzalu05@gmail.com', TO_DATE('30/06/2024 00:12:28', 'DD/MM/YYYY HH24:MI:SS'), 0);
INSERT INTO Cliente (CPF, CPFIndicadoPor, Nome, Telefone, Email, Data_Registro, Pontos_Fidelidade)
VALUES (LPAD(cliente_seq.NEXTVAL, 11, '0'), NULL, 'João Silva', '1234567890', 'joao.silva@exemplo.com', TO_DATE('04/10/2023, 15:44:32', 'DD/MM/YYYY, HH24:MI:SS'), 0);
INSERT INTO Cliente (CPF, CPFIndicadoPor, Nome, Telefone, Email, Data_Registro, Pontos_Fidelidade)
VALUES (LPAD(cliente_seq.NEXTVAL, 11, '0'), LPAD(cliente_seq.NEXTVAL-1, 11, '0'), 'Maria Julia', '9876543210987', 'maria.julia@exemplo.com', SYSDATE, 10);
INSERT INTO Cliente (CPF, CPFIndicadoPor, Nome, Telefone, Email, Data_Registro, Pontos_Fidelidade)
VALUES (LPAD(cliente_seq.NEXTVAL, 11, '0'), LPAD(cliente_seq.NEXTVAL-2, 11, '0'), 'Ana Clara de Lima', '5581988887777', 'anfl@cin.ufpe.br', SYSDATE, 10);

-- Dependente
INSERT INTO Dependente (Nome, CPFResponsavel, Idade, Parentesco)
VALUES ('Maria Souza', 17894563322, 7.2, 'Filho(a)');

-- Atividade
INSERT INTO Atividade (Codigo, Nome, Descricao, Duracao)
VALUES (code_atividade.nextval, 'Passeio de Barco', 'Passeio de barco pela orla de Recife', 1);
INSERT INTO Atividade (Codigo, Nome, Descricao, Duracao)
VALUES (90, 'Jantar Garantido!', 'Inclui janta no restaurante do resort CInDivirta por 3 noites', 3);
INSERT INTO Atividade (Codigo, Nome, Descricao, Duracao)
VALUES (code_atividade.nextval, 'Degustaçao de Vinhos', NULL, 1);

-- TipoAtividade
INSERT INTO TipoAtividade (Tipo, CodAtividade) 
VALUES ('Passeio', 60);
INSERT INTO TipoAtividade (Tipo, CodAtividade) 
VALUES ('Gastronomia', code_atividade.nextval);
INSERT INTO TipoAtividade (Tipo, CodAtividade) 
VALUES ('Viagem', 100);
INSERT INTO TipoAtividade (Tipo, CodAtividade) 
VALUES ('Familia', 100);
INSERT INTO TipoAtividade (Tipo, CodAtividade) 
VALUES ('Cultural', code_atividade.nextval);
INSERT INTO TipoAtividade (Tipo, CodAtividade) 
VALUES ('Longo Prazo', 100);
INSERT INTO TipoAtividade (Tipo, CodAtividade) 
VALUES ('Curto Prazo', code_atividade.nextval);
INSERT INTO TipoAtividade (Tipo, CodAtividade) 
VALUES ('Nacional', 60);
INSERT INTO TipoAtividade (Tipo, CodAtividade) 
VALUES ('Internacional', code_atividade.nextval);
INSERT INTO TipoAtividade (Tipo, CodAtividade) 
VALUES ('Aventura', code_atividade.nextval);
INSERT INTO TipoAtividade (Tipo, CodAtividade) 
VALUES ('Esporte', code_atividade.nextval);
INSERT INTO TipoAtividade (Tipo, CodAtividade) 
VALUES ('Tour Turistico', code_atividade.nextval);

-- Pacote
INSERT INTO Pacote (Codigo, NomePacote, PrecoBase) 
VALUES (code_pacote.nextval, 'Pacote de Carnaval', 689.99);
INSERT INTO Pacote (Codigo, NomePacote, PrecoBase) 
VALUES (11, 'Resort CInDivirta All-inclusive', 2278.00);

-- Promocao
INSERT INTO Promocao (Codigo, Nome, Desconto) 
VALUES (code_promo.nextval, 'Promocao de Carnaval', 30);
INSERT INTO Promocao (Codigo, Nome, Desconto) 
VALUES (code_promo.nextval, 'MegaPromo VERAO', 40);
INSERT INTO Promocao (Codigo, Nome, Desconto) 
VALUES (code_promo.nextval, 'Ferias em Familia', 15);
INSERT INTO Promocao (Codigo, Nome, Desconto) 
VALUES (5, 'Fim de Ano', 20);

-- Reserva
INSERT INTO Reserva (Data_hora_reserva, CPFConsumidor, CodPacote, CodPromocao, Data_Entrada, Data_Saida, Data_Modificacao, Status) 
VALUES (TO_DATE('20/11/2024 14:01:30', 'DD/MM/YYYY HH24:MI:SS'), 17894563322, 11, 5, TO_DATE('23/12/2024', 'DD/MM/YYYY'), TO_DATE('02/01/2025', 'DD/MM/YYYY'), TO_DATE('20/11/2024', 'DD/MM/YYYY'), 'Reservado');


-- Generated
-- Possui
INSERT INTO Possui VALUES (1, 1, '12345678901234');
INSERT INTO Possui VALUES (90, 11, '17190555670023');
INSERT INTO Possui VALUES (2, possui_seq.nextval, '50787852849859');
INSERT INTO Possui VALUES (4, 11, '45559011626759');
INSERT INTO Possui VALUES (possui_seq.nextval, 3, '17190555670023');

-- More Fornecedor entries
INSERT INTO Fornecedor VALUES ('12345678901234', 'Viagens Express');
INSERT INTO Fornecedor VALUES ('23456789012345', 'Hotel Panorama');
INSERT INTO Fornecedor VALUES ('34567890123456', 'Transportes Rapidos');
INSERT INTO Fornecedor VALUES ('45678901234567', 'Eventos Premium');
INSERT INTO Fornecedor VALUES ('56789012345678', 'Buffet Delicia');
INSERT INTO Fornecedor VALUES ('67890123456789', 'Pousada Serena');
INSERT INTO Fornecedor VALUES ('78901234567890', 'Turismo Total');

-- More FornecedorHospedagem entries
INSERT INTO FornecedorHospedagem VALUES ('23456789012345', 4.2, 'Hotel');
INSERT INTO FornecedorHospedagem VALUES ('67890123456789', 4.8, 'Pousada');
INSERT INTO FornecedorHospedagem VALUES (LPAD(seq_fornhosp.NEXTVAL, 14, '0'), 3.5, 'Casa');
INSERT INTO FornecedorHospedagem VALUES (LPAD(seq_fornhosp.NEXTVAL, 14, '0'), 4.1, 'Chale');
INSERT INTO FornecedorHospedagem VALUES (LPAD(seq_fornhosp.NEXTVAL, 14, '0'), 3.8, 'Hotel');
INSERT INTO FornecedorHospedagem VALUES (LPAD(seq_fornhosp.NEXTVAL, 14, '0'), 4.5, 'Pousada');
INSERT INTO FornecedorHospedagem VALUES (LPAD(seq_fornhosp.NEXTVAL, 14, '0'), 3.2, 'Albergue');

-- More FornecedorAlimentacao entries
INSERT INTO FornecedorAlimentacao VALUES ('56789012345678', 4.6, 'Buffet');
INSERT INTO FornecedorAlimentacao VALUES (LPAD(seq_fornalim.NEXTVAL, 14, '0'), 4.3, 'Restaurante');
INSERT INTO FornecedorAlimentacao VALUES (LPAD(seq_fornalim.NEXTVAL, 14, '0'), 3.9, 'Bar');
INSERT INTO FornecedorAlimentacao VALUES (LPAD(seq_fornalim.NEXTVAL, 14, '0'), 4.0, 'Self-Service');
INSERT INTO FornecedorAlimentacao VALUES (LPAD(seq_fornalim.NEXTVAL, 14, '0'), 3.7, 'Fast Food');
INSERT INTO FornecedorAlimentacao VALUES (LPAD(seq_fornalim.NEXTVAL, 14, '0'), 4.4, 'Restaurante');
INSERT INTO FornecedorAlimentacao VALUES (LPAD(seq_fornalim.NEXTVAL, 14, '0'), 4.2, 'Buffet');

-- More FornecedorEvento entries
INSERT INTO FornecedorEvento VALUES ('45678901234567', 'Cultural', 300);
INSERT INTO FornecedorEvento VALUES (LPAD(seq_fornevent.NEXTVAL, 14, '0'), 'Religioso', 200);
INSERT INTO FornecedorEvento VALUES (LPAD(seq_fornevent.NEXTVAL, 14, '0'), 'Corporativo', 150);
INSERT INTO FornecedorEvento VALUES (LPAD(seq_fornevent.NEXTVAL, 14, '0'), 'Esportivo', 800);
INSERT INTO FornecedorEvento VALUES (LPAD(seq_fornevent.NEXTVAL, 14, '0'), 'Cultural', 250);
INSERT INTO FornecedorEvento VALUES (LPAD(seq_fornevent.NEXTVAL, 14, '0'), 'Comemorativo', 400);
INSERT INTO FornecedorEvento VALUES (LPAD(seq_fornevent.NEXTVAL, 14, '0'), 'Religioso', 350);

-- More FornecedorTransporte entries
INSERT INTO FornecedorTransporte VALUES ('34567890123456', 'Rodoviario');
INSERT INTO FornecedorTransporte VALUES (LPAD(seq_fornt.NEXTVAL, 14, '0'), 'Ferroviario');
INSERT INTO FornecedorTransporte VALUES (LPAD(seq_fornt.NEXTVAL, 14, '0'), 'Maritimo');
INSERT INTO FornecedorTransporte VALUES (LPAD(seq_fornt.NEXTVAL, 14, '0'), 'Aereo');
INSERT INTO FornecedorTransporte VALUES (LPAD(seq_fornt.NEXTVAL, 14, '0'), 'Rodoviario');
INSERT INTO FornecedorTransporte VALUES (LPAD(seq_fornt.NEXTVAL, 14, '0'), 'Maritimo');
INSERT INTO FornecedorTransporte VALUES (LPAD(seq_fornt.NEXTVAL, 14, '0'), 'Aereo');

-- More FrotaTransportadora entries
INSERT INTO FrotaTransportadora VALUES ('34567890123456', 'Van', 15);
INSERT INTO FrotaTransportadora VALUES (LPAD(seq_frotatransp.NEXTVAL, 14, '0'), 'Trem', 5);
INSERT INTO FrotaTransportadora VALUES (LPAD(seq_frotatransp.NEXTVAL, 14, '0'), 'Navio', 3);
INSERT INTO FrotaTransportadora VALUES (LPAD(seq_frotatransp.NEXTVAL, 14, '0'), 'Helicoptero', 2);
INSERT INTO FrotaTransportadora VALUES (LPAD(seq_frotatransp.NEXTVAL, 14, '0'), 'Metro', 8);
INSERT INTO FrotaTransportadora VALUES (LPAD(seq_frotatransp.NEXTVAL, 14, '0'), 'Lancha', 6);
INSERT INTO FrotaTransportadora VALUES (LPAD(seq_frotatransp.NEXTVAL, 14, '0'), 'Van', 12);

-- More ContatoFornecedor entries
INSERT INTO ContatoFornecedor VALUES ('12345678901234', '11999887766', 'contato@viagens.com');
INSERT INTO ContatoFornecedor VALUES ('23456789012345', '11988776655', 'reservas@panorama.com');
INSERT INTO ContatoFornecedor VALUES ('34567890123456', '11977665544', 'info@rapidos.com');
INSERT INTO ContatoFornecedor VALUES ('45678901234567', '11966554433', 'eventos@premium.com');
INSERT INTO ContatoFornecedor VALUES ('56789012345678', '11955443322', 'buffet@delicia.com');
INSERT INTO ContatoFornecedor VALUES ('67890123456789', '11944332211', 'pousada@serena.com');
INSERT INTO ContatoFornecedor VALUES ('78901234567890', '11933221100', 'contato@turismo.com');

-- More Cliente entries
INSERT INTO Cliente VALUES (LPAD(cliente_seq.NEXTVAL, 11, '0'), NULL, 'Pedro Santos', '11955443322', 'pedro@email.com', SYSDATE, 50);
INSERT INTO Cliente VALUES (LPAD(cliente_seq.NEXTVAL, 11, '0'), NULL, 'Ana Oliveira', '11966554433', 'ana@email.com', SYSDATE, 30);
INSERT INTO Cliente VALUES (LPAD(cliente_seq.NEXTVAL, 11, '0'), NULL, 'Carlos Lima', '11977665544', 'carlos@email.com', SYSDATE, 20);
INSERT INTO Cliente VALUES (LPAD(cliente_seq.NEXTVAL, 11, '0'), NULL, 'Mariana Costa', '11988776655', 'mari@email.com', SYSDATE, 40);
INSERT INTO Cliente VALUES (LPAD(cliente_seq.NEXTVAL, 11, '0'), NULL, 'Paulo Mendes', '11999887766', 'paulo@email.com', SYSDATE, 60);
INSERT INTO Cliente VALUES (LPAD(cliente_seq.NEXTVAL, 11, '0'), NULL, 'Julia Santos', '11900998877', 'julia@email.com', SYSDATE, 25);
INSERT INTO Cliente VALUES (LPAD(cliente_seq.NEXTVAL, 11, '0'), NULL, 'Roberto Silva', '11911223344', 'roberto@email.com', SYSDATE, 35);

-- More Dependente entries
INSERT INTO Dependente VALUES ('Lucas Santos', '12345678901', 10.5, 'Filho(a)');
INSERT INTO Dependente VALUES ('Marina Oliveira', '23456789012', 8.3, 'Filho(a)');
INSERT INTO Dependente VALUES ('Pedro Lima', '34567890123', 12.7, 'Filho(a)');
INSERT INTO Dependente VALUES ('Sofia Costa', '45678901234', 6.1, 'Filho(a)');
INSERT INTO Dependente VALUES ('Thiago Mendes', '56789012345', 15.8, 'Filho(a)');
INSERT INTO Dependente VALUES ('Clara Santos', '67890123456', 4.9, 'Filho(a)');
INSERT INTO Dependente VALUES ('Gabriel Silva', '78901234567', 9.4, 'Filho(a)');

-- More Atividade entries
INSERT INTO Atividade VALUES (code_atividade.nextval, 'Tour Histórico', 'Visita aos pontos históricos', 4);
INSERT INTO Atividade VALUES (code_atividade.nextval, 'Mergulho', 'Mergulho com instrutor', 2);
INSERT INTO Atividade VALUES (code_atividade.nextval, 'Trilha Ecológica', 'Caminhada na natureza', 3);
INSERT INTO Atividade VALUES (code_atividade.nextval, 'Workshop Culinário', 'Aula de gastronomia local', 2);
INSERT INTO Atividade VALUES (code_atividade.nextval, 'Passeio de Bicicleta', 'Tour pela cidade', 3);
INSERT INTO Atividade VALUES (code_atividade.nextval, 'Observação de Aves', 'Tour com guia especializado', 4);
INSERT INTO Atividade VALUES (code_atividade.nextval, 'Aula de Surfe', 'Curso básico de surfe', 2);

-- More TipoAtividade entries
INSERT INTO TipoAtividade VALUES ('Educativo', code_atividade.currval);
INSERT INTO TipoAtividade VALUES ('Aventura', code_atividade.currval-1);
INSERT INTO TipoAtividade VALUES ('Natureza', code_atividade.currval-2);
INSERT INTO TipoAtividade VALUES ('Gastronomia', code_atividade.currval-3);
INSERT INTO TipoAtividade VALUES ('Esporte', code_atividade.currval-4);
INSERT INTO TipoAtividade VALUES ('Cultural', code_atividade.currval-5);
INSERT INTO TipoAtividade VALUES ('Lazer', code_atividade.currval-6);

-- More Pacote entries
INSERT INTO Pacote VALUES (code_pacote.nextval, 'Aventura Radical', 1500.00);
INSERT INTO Pacote VALUES (code_pacote.nextval, 'Relaxamento Total', 2000.00);
INSERT INTO Pacote VALUES (code_pacote.nextval, 'Descoberta Cultural', 1800.00);
INSERT INTO Pacote VALUES (code_pacote.nextval, 'Expedição Natural', 1600.00);
INSERT INTO Pacote VALUES (code_pacote.nextval, 'Sabores Locais', 1200.00);
INSERT INTO Pacote VALUES (code_pacote.nextval, 'Cidade Histórica', 1400.00);
INSERT INTO Pacote VALUES (code_pacote.nextval, 'Praia e Sol', 1700.00);

-- More Promocao entries
INSERT INTO Promocao VALUES (code_promo.nextval, 'Páscoa Feliz', 25);
INSERT INTO Promocao VALUES (code_promo.nextval, 'Black Friday', 35);
INSERT INTO Promocao VALUES (code_promo.nextval, 'Férias de Julho', 20);
INSERT INTO Promocao VALUES (code_promo.nextval, 'Primavera', 15);
INSERT INTO Promocao VALUES (code_promo.nextval, 'Dia dos Namorados', 10);
INSERT INTO Promocao VALUES (code_promo.nextval, 'Feriado Prolongado', 25);
INSERT INTO Promocao VALUES (code_promo.nextval, 'Baixa Temporada', 30);

-- More Reserva entries
INSERT INTO Reserva VALUES (SYSDATE-7, '12345678901', 11, 5, SYSDATE+30, SYSDATE+35, SYSDATE-7, 'Reservado');
INSERT INTO Reserva VALUES (SYSDATE-6, '23456789012', 12, 6, SYSDATE+40, SYSDATE+45, SYSDATE-6, 'Reservado');
INSERT INTO Reserva VALUES (SYSDATE-5, '34567890123', 13, 7, SYSDATE+50, SYSDATE+55, SYSDATE-5, 'Reservado');
INSERT INTO Reserva VALUES (SYSDATE-4, '45678901234', 14, 8, SYSDATE+60, SYSDATE+65, SYSDATE-4, 'Reservado');
INSERT INTO Reserva VALUES (SYSDATE-3, '56789012345', 15, 9, SYSDATE+70, SYSDATE+75, SYSDATE-3, 'Reservado');
INSERT INTO Reserva VALUES (SYSDATE-2, '67890123456', 16, 10, SYSDATE+80, SYSDATE+85, SYSDATE-2, 'Reservado');
INSERT INTO Reserva VALUES (SYSDATE-1, '78901234567', 17, 11, SYSDATE+90, SYSDATE+95, SYSDATE-1, 'Reservado');

-- More Possui entries
INSERT INTO Possui VALUES (60, 11, '12345678901234');
INSERT INTO Possui VALUES (61, 12, '23456789012345');
INSERT INTO Possui VALUES (62, 13, '34567890123456');
INSERT INTO Possui VALUES (63, 14, '45678901234567');
INSERT INTO Possui VALUES (64, 15, '56789012345678');
INSERT INTO Possui VALUES (65, 16, '67890123456789');
INSERT INTO Possui VALUES (66, 17, '78901234567890');