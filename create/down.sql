-- SQLBook: Code
-- Drop tables with foreign keys first
DROP TABLE FrotaTransportadora;
DROP TABLE Possui;
DROP TABLE TipoAtividade;
DROP TABLE FornecedorHospedagem;
DROP TABLE FornecedorAlimentacao;
DROP TABLE FornecedorTransporte;
DROP TABLE FornecedorEvento;
DROP TABLE ContatoFornecedor;
DROP TABLE Reserva;
DROP TABLE Dependente;

-- Drop tables with only primary keys
DROP TABLE Atividade;
DROP TABLE Pacote;
DROP TABLE Promocao;
DROP TABLE Fornecedor;
DROP TABLE Cliente;

-- Drop sequences
DROP SEQUENCE cliente_seq;
DROP SEQUENCE code_pacote;
DROP SEQUENCE code_atividade;
DROP SEQUENCE code_promo;
DROP SEQUENCE seq_codfornecedor;