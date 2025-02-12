-- SQLBook: Code

-- Fornecedor
INSERT INTO Fornecedor (CNPJ, NomeEmpresa) VALUES ('22222222000111', 'Buffet Delícias LTDA');
INSERT INTO Fornecedor VALUES ('33333333000122', 'Fast Food Express');
INSERT INTO Fornecedor VALUES ('44444444000133', 'Eventos Especiais SA');
INSERT INTO Fornecedor VALUES ('55555555000144', 'Sports Events LTDA');
INSERT INTO Fornecedor VALUES ('11111111000199', 'Aero Transportes');
INSERT INTO Fornecedor VALUES ('22222222111222', 'Marítima Transportes');
INSERT INTO Fornecedor VALUES ('88888888000177', 'Auto Frota LTDA');
INSERT INTO Fornecedor VALUES ('99999999000188', 'Aero Frota SA');
INSERT INTO Fornecedor VALUES ('17190555670023', 'CInDivirta');
INSERT INTO Fornecedor VALUES (LPAD(seq_codfornecedor.nextval, 14, '0'), 'nomedeempresaumpoucomaislongo');
INSERT INTO Fornecedor VALUES (LPAD(seq_codfornecedor.nextval, 14, '0'), 'Tour Sem Erros LTDA');
INSERT INTO Fornecedor VALUES ('12345678901234', 'Viagens Express');
INSERT INTO Fornecedor VALUES ('23456789012345', 'Hotel Panorama');
INSERT INTO Fornecedor VALUES ('34567890123456', 'Transportes Rapidos');
INSERT INTO Fornecedor VALUES ('45678901234567', 'Eventos Premium');
INSERT INTO Fornecedor VALUES ('56789012345678', 'Buffet Delicia');
INSERT INTO Fornecedor VALUES ('67890123456789', 'Pousada Serena');
INSERT INTO Fornecedor VALUES ('78901234567890', 'Turismo Total');


-- FornecedorHospedagem
-- Create Fornecedor entries first
INSERT INTO Fornecedor VALUES (LPAD(seq_codfornecedor.nextval, 14, '0'), 'Casa Temporada');
INSERT INTO Fornecedor VALUES (LPAD(seq_codfornecedor.nextval, 14, '0'), 'Chalé Montanha');
INSERT INTO Fornecedor VALUES (LPAD(seq_codfornecedor.nextval, 14, '0'), 'Hotel Central');
INSERT INTO Fornecedor VALUES (LPAD(seq_codfornecedor.nextval, 14, '0'), 'Pousada Vista Mar');
INSERT INTO Fornecedor VALUES (LPAD(seq_codfornecedor.nextval, 14, '0'), 'Albergue Jovem');
-- FornecedorHospedagem entries
INSERT INTO FornecedorHospedagem (CNPJ_H, Classificacao, Acomodacao) VALUES ('23456789012345', 4.2, 'Hotel');
INSERT INTO FornecedorHospedagem VALUES ('67890123456789', 4.8, 'Pousada');
INSERT INTO FornecedorHospedagem VALUES ('17190555670023', 2.5, 'Albergue');
INSERT INTO FornecedorHospedagem VALUES (LPAD(seq_codfornecedor.currval-5, 14, '0'), 3.9, 'Hotel');
INSERT INTO FornecedorHospedagem VALUES (LPAD(seq_codfornecedor.currval-4, 14, '0'), 3.5, 'Casa');
INSERT INTO FornecedorHospedagem VALUES (LPAD(seq_codfornecedor.currval-3, 14, '0'), 4.1, 'Chale');
INSERT INTO FornecedorHospedagem VALUES (LPAD(seq_codfornecedor.currval-2, 14, '0'), 3.8, 'Hotel');
INSERT INTO FornecedorHospedagem VALUES (LPAD(seq_codfornecedor.currval-1, 14, '0'), 4.5, 'Pousada');
INSERT INTO FornecedorHospedagem VALUES (LPAD(seq_codfornecedor.currval, 14, '0'), 3.2, 'Albergue');


-- FornecedorAlimentacao
-- Create Fornecedor entries first
INSERT INTO Fornecedor VALUES (LPAD(seq_codfornecedor.nextval, 14, '0'), 'Restaurante Sabor');
INSERT INTO Fornecedor VALUES (LPAD(seq_codfornecedor.nextval, 14, '0'), 'Bar do Chef');
INSERT INTO Fornecedor VALUES (LPAD(seq_codfornecedor.nextval, 14, '0'), 'Self Service Express');
INSERT INTO Fornecedor VALUES (LPAD(seq_codfornecedor.nextval, 14, '0'), 'Fast n Fresh');
INSERT INTO Fornecedor VALUES (LPAD(seq_codfornecedor.nextval, 14, '0'), 'Restaurante Gourmet');
INSERT INTO Fornecedor VALUES (LPAD(seq_codfornecedor.nextval, 14, '0'), 'Buffet Premium');
-- FornecedorAlimentacao entries
INSERT INTO FornecedorAlimentacao (CNPJ_A, Classificacao, Servico) VALUES ('22222222000111', 3.8, 'Buffet');
INSERT INTO FornecedorAlimentacao VALUES ('33333333000122', 5.0, 'Fast Food');
INSERT INTO FornecedorAlimentacao VALUES ('56789012345678', 4.6, 'Buffet');
INSERT INTO FornecedorAlimentacao VALUES ('67890123456789', 4.1, 'Self-Service');
INSERT INTO FornecedorAlimentacao VALUES ('17190555670023', 3.1, 'Buffet');
INSERT INTO FornecedorAlimentacao VALUES ('23456789012345', 4.8, 'Restaurante');
INSERT INTO FornecedorAlimentacao VALUES (LPAD(seq_codfornecedor.currval-5, 14, '0'), 4.3, 'Restaurante');
INSERT INTO FornecedorAlimentacao VALUES (LPAD(seq_codfornecedor.currval-4, 14, '0'), 3.9, 'Bar');
INSERT INTO FornecedorAlimentacao VALUES (LPAD(seq_codfornecedor.currval-3, 14, '0'), 4.0, 'Self-Service');
INSERT INTO FornecedorAlimentacao VALUES (LPAD(seq_codfornecedor.currval-2, 14, '0'), 3.7, 'Fast Food');
INSERT INTO FornecedorAlimentacao VALUES (LPAD(seq_codfornecedor.currval-1, 14, '0'), 4.4, 'Restaurante');
INSERT INTO FornecedorAlimentacao VALUES (LPAD(seq_codfornecedor.currval, 14, '0'), 4.2, 'Buffet');


-- FornecedorEvento
-- Create Fornecedor entries first
INSERT INTO Fornecedor VALUES (LPAD(seq_codfornecedor.nextval, 14, '0'), 'Eventos Culturais');
INSERT INTO Fornecedor VALUES (LPAD(seq_codfornecedor.nextval, 14, '0'), 'Igreja Eventos');
INSERT INTO Fornecedor VALUES (LPAD(seq_codfornecedor.nextval, 14, '0'), 'Corporativo Plus');
INSERT INTO Fornecedor VALUES (LPAD(seq_codfornecedor.nextval, 14, '0'), 'Esportes Pro');
INSERT INTO Fornecedor VALUES (LPAD(seq_codfornecedor.nextval, 14, '0'), 'Centro Cultural');
INSERT INTO Fornecedor VALUES (LPAD(seq_codfornecedor.nextval, 14, '0'), 'Festas n Eventos');
INSERT INTO Fornecedor VALUES (LPAD(seq_codfornecedor.nextval, 14, '0'), 'Eventos Religiosos');
-- FornecedorEvento entries 
INSERT INTO FornecedorEvento (CNPJ_E, Tipo, CapacidadeMaxima) VALUES ('44444444000133', 'Comemorativo', 250);
INSERT INTO FornecedorEvento VALUES ('55555555000144', 'Esportivo', 1000);
INSERT INTO FornecedorEvento VALUES ('45678901234567', 'Cultural', 300);
INSERT INTO FornecedorEvento VALUES (LPAD(seq_codfornecedor.currval-6, 14, '0'), 'Religioso', 200);
INSERT INTO FornecedorEvento VALUES (LPAD(seq_codfornecedor.currval-5, 14, '0'), 'Corporativo', 150);
INSERT INTO FornecedorEvento VALUES (LPAD(seq_codfornecedor.currval-4, 14, '0'), 'Esportivo', 800);
INSERT INTO FornecedorEvento VALUES (LPAD(seq_codfornecedor.currval-3, 14, '0'), 'Cultural', 250);
INSERT INTO FornecedorEvento VALUES (LPAD(seq_codfornecedor.currval-2, 14, '0'), 'Comemorativo', 400);
INSERT INTO FornecedorEvento VALUES (LPAD(seq_codfornecedor.currval-1, 14, '0'), 'Religioso', 350);

-- FornecedorTransporte
-- Create Fornecedor entries first
INSERT INTO Fornecedor VALUES (LPAD(seq_codfornecedor.nextval, 14, '0'), 'Transportes Ferroviários');
INSERT INTO Fornecedor VALUES (LPAD(seq_codfornecedor.nextval, 14, '0'), 'Navios Express');
INSERT INTO Fornecedor VALUES (LPAD(seq_codfornecedor.nextval, 14, '0'), 'Aero Express');
INSERT INTO Fornecedor VALUES (LPAD(seq_codfornecedor.nextval, 14, '0'), 'Ônibus Brasil');
INSERT INTO Fornecedor VALUES (LPAD(seq_codfornecedor.nextval, 14, '0'), 'Navios Turismo');
INSERT INTO Fornecedor VALUES (LPAD(seq_codfornecedor.nextval, 14, '0'), 'Voos Express');
-- FornecedorTransporte entries
INSERT INTO FornecedorTransporte (CNPJ_T, TipoTransporte) VALUES ('11111111000199', 'Aereo');
INSERT INTO FornecedorTransporte VALUES ('22222222111222', 'Maritimo');
INSERT INTO FornecedorTransporte VALUES (LPAD(seq_codfornecedor.currval-5, 14, '0'), 'Ferroviario');
INSERT INTO FornecedorTransporte VALUES (LPAD(seq_codfornecedor.currval-4, 14, '0'), 'Maritimo');
INSERT INTO FornecedorTransporte VALUES (LPAD(seq_codfornecedor.currval-3, 14, '0'), 'Aereo');
INSERT INTO FornecedorTransporte VALUES (LPAD(seq_codfornecedor.currval-2, 14, '0'), 'Rodoviario');
INSERT INTO FornecedorTransporte VALUES (LPAD(seq_codfornecedor.currval-1, 14, '0'), 'Maritimo');
INSERT INTO FornecedorTransporte VALUES (LPAD(seq_codfornecedor.currval, 14, '0'), 'Aereo');

-- FrotaTransportadora entries
INSERT INTO FrotaTransportadora (CNPJTransportadora, Veiculo, Quantidade) VALUES ('11111111000199', 'Aviao', 50);
INSERT INTO FrotaTransportadora VALUES ('22222222111222', 'Navio', 10);
INSERT INTO FrotaTransportadora VALUES (LPAD(seq_codfornecedor.currval-5, 14, '0'), 'Trem', 5);
INSERT INTO FrotaTransportadora VALUES (LPAD(seq_codfornecedor.currval-4, 14, '0'), 'Navio', 3);
INSERT INTO FrotaTransportadora VALUES (LPAD(seq_codfornecedor.currval-3, 14, '0'), 'Aviao', 2);

-- ContatoFornecedor
INSERT INTO ContatoFornecedor (CodFornecedor, Telefone, Email) VALUES ('11111111000199', '21987654321', 'suporte@empresa88.com.br');
INSERT INTO ContatoFornecedor VALUES ('22222222111222', '31999998888', 'atendimento@empresa2.com');
INSERT INTO ContatoFornecedor VALUES (LPAD(seq_codfornecedor.currval-6, 14, '0'), '11999887766', 'contato@viagens.com');
INSERT INTO ContatoFornecedor VALUES (LPAD(seq_codfornecedor.currval-5, 14, '0'), '11988776655', 'reservas@panorama.com');
INSERT INTO ContatoFornecedor VALUES (LPAD(seq_codfornecedor.currval-4, 14, '0'), '11977665544', 'info@rapidos.com');
INSERT INTO ContatoFornecedor VALUES (LPAD(seq_codfornecedor.currval-3, 14, '0'), '11966554433', 'eventos@premium.com');
INSERT INTO ContatoFornecedor VALUES (LPAD(seq_codfornecedor.currval-2, 14, '0'), '11955443322', 'buffet@delicia.com');
INSERT INTO ContatoFornecedor VALUES (LPAD(seq_codfornecedor.currval-1, 14, '0'), '11944332211', 'pousada@serena.com');
INSERT INTO ContatoFornecedor VALUES (LPAD(seq_codfornecedor.currval, 14, '0'), '11933221100', 'contato@turismo.com');

-- Cliente
INSERT INTO Cliente (CPF, CPFIndicadoPor, Nome, Telefone, Email, Data_Registro, Pontos_Fidelidade)
VALUES ('17894563322', NULL, 'Luiza Souza', '14085990321', 'souzalu05@gmail.com', TO_DATE('30/06/2024 00:12:28', 'DD/MM/YYYY HH24:MI:SS'), 0);
INSERT INTO Cliente VALUES (LPAD(cliente_seq.NEXTVAL, 11, '0'), NULL, 'João Silva', '1234567890', 'joao.silva@exemplo.com', TO_DATE('04/10/2023, 15:44:32', 'DD/MM/YYYY, HH24:MI:SS'), 0);
INSERT INTO Cliente VALUES (LPAD(cliente_seq.NEXTVAL, 11, '0'), LPAD(cliente_seq.NEXTVAL-1, 11, '0'), 'Maria Julia', '9876543210987', 'maria.julia@exemplo.com', SYSDATE, 10);
INSERT INTO Cliente VALUES (LPAD(cliente_seq.NEXTVAL, 11, '0'), LPAD(cliente_seq.NEXTVAL-2, 11, '0'), 'Ana Clara de Lima', '5581988887777', 'anfl@cin.ufpe.br', SYSDATE, 10);
INSERT INTO Cliente VALUES (LPAD(cliente_seq.NEXTVAL, 11, '0'), NULL, 'Pedro Santos', '11955443322', 'pedro@email.com', SYSDATE, 50);
INSERT INTO Cliente VALUES (LPAD(cliente_seq.NEXTVAL, 11, '0'), NULL, 'Ana Oliveira', '11966554433', 'ana@email.com', SYSDATE, 30);
INSERT INTO Cliente VALUES (LPAD(cliente_seq.NEXTVAL, 11, '0'), NULL, 'Carlos Lima', '11977665544', 'carlos@email.com', SYSDATE, 20);
INSERT INTO Cliente VALUES (LPAD(cliente_seq.NEXTVAL, 11, '0'), NULL, 'Mariana Costa', '11988776655', 'mari@email.com', SYSDATE, 40);
INSERT INTO Cliente VALUES (LPAD(cliente_seq.NEXTVAL, 11, '0'), NULL, 'Paulo Mendes', '11999887766', 'paulo@email.com', SYSDATE, 60);
INSERT INTO Cliente VALUES (LPAD(cliente_seq.NEXTVAL, 11, '0'), NULL, 'Julia Santos', '11900998877', 'julia@email.com', SYSDATE, 25);
INSERT INTO Cliente VALUES (LPAD(cliente_seq.NEXTVAL, 11, '0'), NULL, 'Roberto Silva', '11911223344', 'roberto@email.com', SYSDATE, 35);

-- Dependente 
INSERT INTO Dependente (Nome, CPFResponsavel, Idade, Parentesco) VALUES ('Maria Souza', '17894563322', 7.2, 'Filho(a)');
INSERT INTO Dependente VALUES ('Lucas Santos', LPAD(cliente_seq.currval-6, 11, '0'), 10.5, 'Filho(a)');
INSERT INTO Dependente VALUES ('Marina Oliveira', LPAD(cliente_seq.currval-5, 11, '0'), 8.3, 'Filho(a)');
INSERT INTO Dependente VALUES ('Pedro Lima', LPAD(cliente_seq.currval-4, 11, '0'), 12.7, 'Filho(a)');
INSERT INTO Dependente VALUES ('Sofia Costa', LPAD(cliente_seq.currval-3, 11, '0'), 6.1, 'Filho(a)');
INSERT INTO Dependente VALUES ('Thiago Mendes', LPAD(cliente_seq.currval-2, 11, '0'), 15.8, 'Filho(a)');
INSERT INTO Dependente VALUES ('Clara Santos', LPAD(cliente_seq.currval-1, 11, '0'), 4.9, 'Filho(a)');
INSERT INTO Dependente VALUES ('Gabriel Silva', LPAD(cliente_seq.currval, 11, '0'), 9.4, 'Filho(a)');

-- Atividade
INSERT INTO Atividade (Codigo, Nome, Descricao, Duracao) VALUES (code_atividade.nextval, 'Passeio de Barco', 'Passeio de barco pela orla de Recife', 1);
INSERT INTO Atividade VALUES (90, 'Jantar Garantido!', 'Inclui janta no restaurante do resort CInDivirta por 3 noites', 3);
INSERT INTO Atividade VALUES (code_atividade.nextval, 'Degustaçao de Vinhos', NULL, 1);
INSERT INTO Atividade VALUES (60, 'City Tour', 'Tour pela cidade', 4);
INSERT INTO Atividade VALUES (code_atividade.nextval, 'Festival Gastronômico', 'Degustação de comidas típicas', 3);
INSERT INTO Atividade VALUES (100, 'Cruzeiro Familiar', 'Viagem de navio com atividades para família', 7);
INSERT INTO Atividade VALUES (code_atividade.nextval, 'Museu Tour', 'Visita guiada a museus', 2);
INSERT INTO Atividade VALUES (code_atividade.nextval, 'Expedição Amazônica', 'Exploração pela floresta', 5);
INSERT INTO Atividade VALUES (code_atividade.nextval, 'Tour Europa', 'Viagem internacional', 15);
INSERT INTO Atividade VALUES (code_atividade.nextval, 'Escalada', 'Aventura em montanhas', 1);
INSERT INTO Atividade VALUES (code_atividade.nextval, 'Campeonato Esportivo', 'Competições esportivas', 2);
INSERT INTO Atividade VALUES (code_atividade.nextval, 'Tour Histórico', 'Visita a pontos históricos', 3);
INSERT INTO Atividade VALUES (code_atividade.nextval, 'Tour Histórico', 'Visita aos pontos históricos', 4);
INSERT INTO Atividade VALUES (code_atividade.nextval, 'Mergulho', 'Mergulho com instrutor', 2);
INSERT INTO Atividade VALUES (code_atividade.nextval, 'Trilha Ecológica', 'Caminhada na natureza', 3);
INSERT INTO Atividade VALUES (code_atividade.nextval, 'Workshop Culinário', 'Aula de gastronomia local', 2);
INSERT INTO Atividade VALUES (code_atividade.nextval, 'Passeio de Bicicleta', 'Tour pela cidade', 3);
INSERT INTO Atividade VALUES (code_atividade.nextval, 'Observação de Aves', 'Tour com guia especializado', 4);
INSERT INTO Atividade VALUES (code_atividade.nextval, 'Aula de Surfe', 'Curso básico de surfe', 2);

-- TipoAtividade
INSERT INTO TipoAtividade (Tipo, CodAtividade) VALUES ('Passeio', 60);
INSERT INTO TipoAtividade VALUES ('Gastronomia', code_atividade.currval-7);
INSERT INTO TipoAtividade VALUES ('Viagem', 100);
INSERT INTO TipoAtividade VALUES ('Familia', 100);
INSERT INTO TipoAtividade VALUES ('Cultural', 60);
INSERT INTO TipoAtividade VALUES ('Longo Prazo', code_atividade.currval-3);
INSERT INTO TipoAtividade VALUES ('Curto Prazo', code_atividade.currval-2);
INSERT INTO TipoAtividade VALUES ('Nacional', 60);
INSERT INTO TipoAtividade VALUES ('Internacional', code_atividade.currval-3);
INSERT INTO TipoAtividade VALUES ('Aventura', code_atividade.currval-2);
INSERT INTO TipoAtividade VALUES ('Cultural', code_atividade.currval-1);
INSERT INTO TipoAtividade VALUES ('Esporte', code_atividade.currval);
INSERT INTO TipoAtividade VALUES ('Educativo', code_atividade.currval);
INSERT INTO TipoAtividade VALUES ('Aventura', code_atividade.currval-1);
INSERT INTO TipoAtividade VALUES ('Natureza', code_atividade.currval-2);
INSERT INTO TipoAtividade VALUES ('Gastronomia', code_atividade.currval-3);
INSERT INTO TipoAtividade VALUES ('Esporte', code_atividade.currval-4);
INSERT INTO TipoAtividade VALUES ('Cultural', code_atividade.currval-5);
INSERT INTO TipoAtividade VALUES ('Lazer', code_atividade.currval-6);

-- Pacote
INSERT INTO Pacote (Codigo, NomePacote, PrecoBase) VALUES (code_pacote.nextval, 'Pacote de Carnaval', 689.99);
INSERT INTO Pacote VALUES (code_pacote.nextval, 'Resort CInDivirta All-inclusive', 2278.00);
INSERT INTO Pacote VALUES (code_pacote.nextval, 'Aventura Radical', 1500.00);
INSERT INTO Pacote VALUES (code_pacote.nextval, 'Relaxamento Total', 2000.00);
INSERT INTO Pacote VALUES (code_pacote.nextval, 'Descoberta Cultural', 1800.00);
INSERT INTO Pacote VALUES (code_pacote.nextval, 'Expedição Natural', 1600.00);
INSERT INTO Pacote VALUES (code_pacote.nextval, 'Sabores Locais', 1200.00);
INSERT INTO Pacote VALUES (code_pacote.nextval, 'Cidade Histórica', 1400.00);
INSERT INTO Pacote VALUES (code_pacote.nextval, 'Praia e Sol', 1700.00);

-- Promocao
INSERT INTO Promocao (Codigo, Nome, Desconto) VALUES (code_promo.nextval, 'Promocao de Carnaval', 30);
INSERT INTO Promocao VALUES (code_promo.nextval, 'MegaPromo VERAO', 40);
INSERT INTO Promocao VALUES (code_promo.nextval, 'Ferias em Familia', 15);
INSERT INTO Promocao VALUES (code_promo.nextval, 'Fim de Ano', 20);
INSERT INTO Promocao VALUES (code_promo.nextval, 'Páscoa Feliz', 25);
INSERT INTO Promocao VALUES (code_promo.nextval, 'Black Friday', 35);
INSERT INTO Promocao VALUES (code_promo.nextval, 'Férias de Julho', 20);
INSERT INTO Promocao VALUES (code_promo.nextval, 'Primavera', 15);
INSERT INTO Promocao VALUES (code_promo.nextval, 'Dia dos Namorados', 10);
INSERT INTO Promocao VALUES (code_promo.nextval, 'Feriado Prolongado', 25);
INSERT INTO Promocao VALUES (code_promo.nextval, 'Baixa Temporada', 30);

-- Possui
INSERT INTO Possui (CodAtividade, CodPacote, CNPJFornecedor) VALUES (code_atividade.currval-6, code_pacote.currval-6, LPAD(seq_codfornecedor.currval-6, 14, '0'));
INSERT INTO Possui VALUES (code_atividade.currval-5, code_pacote.currval-5, LPAD(seq_codfornecedor.currval-5, 14, '0'));
INSERT INTO Possui VALUES (code_atividade.currval-4, code_pacote.currval-4, LPAD(seq_codfornecedor.currval-4, 14, '0'));
INSERT INTO Possui VALUES (code_atividade.currval-3, code_pacote.currval-3, LPAD(seq_codfornecedor.currval-3, 14, '0'));
INSERT INTO Possui VALUES (code_atividade.currval-2, code_pacote.currval-2, LPAD(seq_codfornecedor.currval-2, 14, '0'));
INSERT INTO Possui VALUES (code_atividade.currval-1, code_pacote.currval-1, LPAD(seq_codfornecedor.currval-1, 14, '0'));
INSERT INTO Possui VALUES (code_atividade.currval, code_pacote.currval, LPAD(seq_codfornecedor.currval, 14, '0'));

-- Reserva
INSERT INTO Reserva (Data_hora_reserva, CPFConsumidor, CodPacote, CodPromocao, Data_Entrada, Data_Saida, Data_Modificacao, Status) 
VALUES (TO_DATE('20/11/2024 14:01:30', 'DD/MM/YYYY HH24:MI:SS'), '17894563322', code_pacote.currval - 1, code_promo.currval - 1, TO_DATE('23/12/2024', 'DD/MM/YYYY'), TO_DATE('02/01/2025', 'DD/MM/YYYY'), TO_DATE('20/11/2024', 'DD/MM/YYYY'), 'Concluido');
INSERT INTO Reserva VALUES (SYSDATE-7, '00000000010', code_pacote.currval - 7, code_promo.currval - 6, SYSDATE+30, SYSDATE+35, SYSDATE-7, 'Reservado');
INSERT INTO Reserva VALUES (SYSDATE-6, '00000000009', code_pacote.currval - 5, code_promo.currval - 5, SYSDATE+40, SYSDATE+45, SYSDATE-6, 'Reservado');
INSERT INTO Reserva VALUES (SYSDATE-5, '00000000008', code_pacote.currval - 4, code_promo.currval - 4, SYSDATE+50, SYSDATE+55, SYSDATE-5, 'Reservado');
INSERT INTO Reserva VALUES (SYSDATE-4, '00000000007', code_pacote.currval - 3, code_promo.currval - 3, SYSDATE+60, SYSDATE+65, SYSDATE-4, 'Reservado');
INSERT INTO Reserva VALUES (SYSDATE-3, '00000000006', code_pacote.currval - 2, code_promo.currval - 2, SYSDATE+70, SYSDATE+75, SYSDATE-3, 'Concluido');
INSERT INTO Reserva VALUES (SYSDATE-2, '00000000005', code_pacote.currval - 1, code_promo.currval - 1, SYSDATE+80, SYSDATE+85, SYSDATE-2, 'Concluido');
INSERT INTO Reserva VALUES (SYSDATE-1, '00000000004', code_pacote.currval, code_promo.currval, SYSDATE+90, SYSDATE+95, SYSDATE-1, 'Concluido');
INSERT INTO Reserva VALUES (SYSDATE, '00000000003', code_pacote.currval-7, code_promo.currval, SYSDATE+100, SYSDATE+105, SYSDATE, 'Cancelado');
























