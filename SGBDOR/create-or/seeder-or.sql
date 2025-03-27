DROP SEQUENCE seq_codigo_pacote;
DROP SEQUENCE seq_codigo_promocao;
DROP SEQUENCE seq_codigo_atividade;

CREATE SEQUENCE seq_codigo_pacote START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_codigo_promocao START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_codigo_atividade START WITH 1 INCREMENT BY 1;

-- CLIENTES

-- clientes sem indicadores
INSERT INTO tb_cliente VALUES (
    tp_cliente(
        '12345678901',
        'João Silva',
        tp_email('joaosilva87@gmail.com'),
        tp_telefone('5581999887766'), 
        SYSDATE,
        100,
        NULL,
        tp_possui_dep(
            tp_dependente(
                'Maria Silva',
                TO_DATE('01-01-2010', 'DD-MM-YYYY'),
                'Filha'
            )
        ),
        tp_clientes_indicados()
    )
);

INSERT INTO tb_cliente VALUES (tp_cliente('23456789012', 'Maria Santos', tp_email('msantos.prof@outlook.com'), tp_telefone('351912345678'), SYSDATE-10, 1500, NULL, tp_possui_dep(tp_dependente('Miguel Santos', TO_DATE('07-08-2009', 'DD-MM-YYYY'), 'Filho')), tp_clientes_indicados()));
INSERT INTO tb_cliente VALUES (tp_cliente('34567890123', 'Pedro Costa', tp_email('pedro.costa@yahoo.fr'), tp_telefone('33745123456'), SYSDATE-365, 200, NULL, tp_possui_dep(), tp_clientes_indicados())); 

-- indicados pelos anteriores
INSERT INTO tb_cliente VALUES (tp_cliente('45678901234', 'Ana Oliveira', tp_email('aoliveira_arq@hotmail.com'), tp_telefone('5511988776655'), SYSDATE-40, 50, (SELECT REF(c) FROM tb_cliente c WHERE c.cpf = '12345678901'), tp_possui_dep(), tp_clientes_indicados()));
INSERT INTO TABLE(SELECT c.clientes_indicados FROM tb_cliente c WHERE c.cpf = '12345678901') VALUES ((SELECT REF(c) FROM tb_cliente c WHERE c.cpf = '45678901234'));
INSERT INTO tb_cliente VALUES (tp_cliente('56789012345', 'Carlos Lima', tp_email('carloslima_dev@protonmail.com'), tp_telefone('447911223344'), SYSDATE-1096, 75, (SELECT REF(c) FROM tb_cliente c WHERE c.cpf = '23456789012'), tp_possui_dep(), tp_clientes_indicados()));
INSERT INTO TABLE(SELECT c.clientes_indicados FROM tb_cliente c WHERE c.cpf = '23456789012') VALUES ((SELECT REF(c) FROM tb_cliente c WHERE c.cpf = '56789012345'));

-- indicado por anteriores
INSERT INTO tb_cliente VALUES (tp_cliente('67890123456', 'Mariana Costa', tp_email('mari.costa@uol.com.br'), tp_telefone('5521977665544'), SYSDATE-40, 550, (SELECT REF(c) FROM tb_cliente c WHERE c.cpf = '45678901234'), tp_possui_dep(), tp_clientes_indicados())); 
INSERT INTO TABLE(SELECT c.clientes_indicados FROM tb_cliente c WHERE c.cpf = '45678901234') VALUES ((SELECT REF(c) FROM tb_cliente c WHERE c.cpf = '67890123456'));

-- adicionais
INSERT INTO tb_cliente VALUES (tp_cliente('78901234567', 'Paulo Mendes', tp_email('paulomendesarq@gmail.com'), tp_telefone('14159876543'), SYSDATE-200, 300, (SELECT REF(c) FROM tb_cliente c WHERE c.cpf = '12345678901'), tp_possui_dep(), tp_clientes_indicados())); 
INSERT INTO TABLE(SELECT c.clientes_indicados FROM tb_cliente c WHERE c.cpf = '12345678901') VALUES ((SELECT REF(c) FROM tb_cliente c WHERE c.cpf = '78901234567'));
INSERT INTO tb_cliente VALUES (tp_cliente('89012345678', 'Julia Santos', tp_email('julia.santos@terra.com.br'), tp_telefone('5541955443322'), SYSDATE-1, 175, NULL, tp_possui_dep(), tp_clientes_indicados())); 
INSERT INTO tb_cliente VALUES (tp_cliente('90123456789', 'Roberto Silva', tp_email('robertosilva@live.com'), tp_telefone('493012345678'), SYSDATE, 125, NULL, tp_possui_dep(), tp_clientes_indicados()));
INSERT INTO tb_cliente VALUES (tp_cliente('01234567890', 'Sandra Pereira', tp_email('sandrapereira_psi@yahoo.com.br'), tp_telefone('5531944332211'), SYSDATE, 0, NULL, tp_possui_dep(), tp_clientes_indicados())); 


-- DEPENDENTES (adicionar aos clientes existentes)
INSERT INTO TABLE(
    SELECT c.dependentes 
    FROM tb_cliente c 
    WHERE c.cpf = '12345678901'
) VALUES (
    tp_dependente(
        'Lucas Silva',
        TO_DATE('15-03-2012', 'DD-MM-YYYY'),
        'Filho'
    )
);

INSERT INTO TABLE(SELECT c.dependentes FROM tb_cliente c WHERE c.cpf = '23456789012') VALUES (tp_dependente('Ana Santos', TO_DATE('22-06-2011', 'DD-MM-YYYY'), 'Filha'));
INSERT INTO TABLE(SELECT c.dependentes FROM tb_cliente c WHERE c.cpf = '34567890123') VALUES (tp_dependente('Pedro Costa Jr', TO_DATE('10-12-2013', 'DD-MM-YYYY'), 'Filho'));
INSERT INTO TABLE(SELECT c.dependentes FROM tb_cliente c WHERE c.cpf = '45678901234') VALUES (tp_dependente('Julia Oliveira', TO_DATE('05-09-2014', 'DD-MM-YYYY'), 'Filha'));
INSERT INTO TABLE(SELECT c.dependentes FROM tb_cliente c WHERE c.cpf = '56789012345') VALUES (tp_dependente('Marcos Lima', TO_DATE('30-11-2015', 'DD-MM-YYYY'), 'Filho'));


-- PROMOCOES
INSERT INTO tb_promocao VALUES (
    tp_promocao(
        seq_codigo_promocao.NEXTVAL,
        'Férias de Verão',
        25
    )
);

INSERT INTO tb_promocao VALUES (tp_promocao(seq_codigo_promocao.NEXTVAL, 'Black Friday', 40));
INSERT INTO tb_promocao VALUES (tp_promocao(seq_codigo_promocao.NEXTVAL, 'Natal Antecipado', 30));
INSERT INTO tb_promocao VALUES (tp_promocao(seq_codigo_promocao.NEXTVAL, 'Pacote Família', 20));
INSERT INTO tb_promocao VALUES (tp_promocao(seq_codigo_promocao.NEXTVAL, 'Feriado Prolongado', 15));
INSERT INTO tb_promocao VALUES (tp_promocao(seq_codigo_promocao.NEXTVAL, 'Lua de Mel', 35));


-- PACOTES 
INSERT INTO tb_pacote VALUES (
    tp_pacote(
        seq_codigo_pacote.NEXTVAL,
        'Aventura Total',
        1500.00
    )
);

INSERT INTO tb_pacote VALUES (tp_pacote(seq_codigo_pacote.NEXTVAL, 'Relaxamento Spa', 2000.00));
INSERT INTO tb_pacote VALUES (tp_pacote(seq_codigo_pacote.NEXTVAL, 'Tour Cultural', 1200.00));
INSERT INTO tb_pacote VALUES (tp_pacote(seq_codigo_pacote.NEXTVAL, 'Expedição Natural', 1800.00));
INSERT INTO tb_pacote VALUES (tp_pacote(seq_codigo_pacote.NEXTVAL, 'Sabores da Região', 900.00));
INSERT INTO tb_pacote VALUES (tp_pacote(seq_codigo_pacote.NEXTVAL, 'Pacote Romântico', 2500.00));
INSERT INTO tb_pacote VALUES (tp_pacote(seq_codigo_pacote.NEXTVAL, 'Fim de Semana Radical', 1800.00));
INSERT INTO tb_pacote VALUES (tp_pacote(seq_codigo_pacote.NEXTVAL, 'Descoberta Cultural', 1600.00));


-- ATIVIDADES
INSERT INTO tb_atividade VALUES (
    tp_atividade(
        seq_codigo_atividade.NEXTVAL,
        'Tour Histórico',
        'Visita guiada pelos pontos históricos',
        4,
        tp_lista_ativ_tipos(
            tp_atividade_tipo('Cultural'), 
            tp_atividade_tipo('Educativo')
        )
    )
);

INSERT INTO tb_atividade VALUES (tp_atividade(seq_codigo_atividade.NEXTVAL, 'Mergulho', 'Mergulho com instrutor profissional', 3, tp_lista_ativ_tipos(tp_atividade_tipo('Aventura'))));
INSERT INTO tb_atividade VALUES (tp_atividade(seq_codigo_atividade.NEXTVAL, 'Passeio de Barco', 'Passeio pela costa', 2, tp_lista_ativ_tipos(tp_atividade_tipo('Lazer'))));
INSERT INTO tb_atividade VALUES (tp_atividade(seq_codigo_atividade.NEXTVAL, 'Trilha Ecológica', 'Caminhada na natureza', 5, tp_lista_ativ_tipos(tp_atividade_tipo('Aventura'))));
INSERT INTO tb_atividade VALUES (tp_atividade(seq_codigo_atividade.NEXTVAL, 'Workshop Culinário', 'Aula de gastronomia local', 3, tp_lista_ativ_tipos(tp_atividade_tipo('Gastronomia'))));
INSERT INTO tb_atividade VALUES (tp_atividade(seq_codigo_atividade.NEXTVAL, 'Aula de Surfe', 'Instruções básicas de surfe', 4, tp_lista_ativ_tipos(tp_atividade_tipo('Esporte'), tp_atividade_tipo('Aventura'))));
INSERT INTO tb_atividade VALUES (tp_atividade(seq_codigo_atividade.NEXTVAL, 'Tour Fotográfico', 'Passeio com fotógrafo profissional', 3, tp_lista_ativ_tipos(tp_atividade_tipo('Cultural'), tp_atividade_tipo('Lazer'))));
INSERT INTO tb_atividade VALUES (tp_atividade(seq_codigo_atividade.NEXTVAL, 'Festival Gastronômico', 'Degustação de pratos típicos', 4, tp_lista_ativ_tipos(tp_atividade_tipo('Gastronomia'))));


-- FORNECEDORES HOSPEDAGEM
INSERT INTO tb_fornecedor_hospedagem VALUES (
    tp_fornecedor_hospedagem(
        '11111111000199',
        'Four Seasons Tokyo',
        tp_lista_contatos(
            tp_contato(tp_telefone('81345056888'), tp_email('reservations.tokyo@fourseasons.com')),
            tp_contato(tp_telefone('81345056889'), tp_email('events.tokyo@fourseasons.com')),
            tp_contato(tp_telefone('81345056890'), tp_email('concierge.tokyo@fourseasons.com'))
        ),
        'Hotel',
        5.0,
        300
    )
);

INSERT INTO tb_fornecedor_hospedagem VALUES (tp_fornecedor_hospedagem('22222222000188', 'Ritz Paris', tp_lista_contatos(tp_contato(tp_telefone('33143163333'), tp_email('reservations@ritzparis.com')), tp_contato(tp_telefone('33143163334'), tp_email('vip@ritzparis.com'))), 'Hotel', 5.0, 160));
INSERT INTO tb_fornecedor_hospedagem VALUES (tp_fornecedor_hospedagem('33333333000177', 'Burj Al Arab', tp_lista_contatos(tp_contato(tp_telefone('97148882222'), tp_email('bookings@burjalarab.com')), tp_contato(tp_telefone('97148882223'), tp_email('luxury@burjalarab.com'))), 'Hotel', 3.017, 200));
INSERT INTO tb_fornecedor_hospedagem VALUES (tp_fornecedor_hospedagem('44444444000166', 'Copacabana Palace', tp_lista_contatos(tp_contato(tp_telefone('552135252100'), tp_email('reservas@copacabanapalace.com')), tp_contato(tp_telefone('552135252101'), tp_email('eventos@copacabanapalace.com'))), 'Hotel', 4.9, 250));
INSERT INTO tb_fornecedor_hospedagem VALUES (tp_fornecedor_hospedagem('55555555000155', 'The Savoy London', tp_lista_contatos(tp_contato(tp_telefone('442073836000'), tp_email('savoy@fairmont.com')), tp_contato(tp_telefone('442073836001'), tp_email('events.savoy@fairmont.com'))), 'Hotel', 4.567, 280));
INSERT INTO tb_fornecedor_hospedagem VALUES (tp_fornecedor_hospedagem('66666666000144', 'Plaza New York', tp_lista_contatos(tp_contato(tp_telefone('12127593000'), tp_email('concierge@plaza-ny.com')), tp_contato(tp_telefone('12127593001'), tp_email('reservations@plaza-ny.com'))), 'Hotel', 2.49, 220));
INSERT INTO tb_fornecedor_hospedagem VALUES (tp_fornecedor_hospedagem('77777777000133', 'Mandarin Oriental Milan', tp_lista_contatos(tp_contato(tp_telefone('390287323000'), tp_email('momln-reservations@mohg.com')), tp_contato(tp_telefone('390287323001'), tp_email('momln-events@mohg.com'))), 'Pousada', 3.97, 190));
INSERT INTO tb_fornecedor_hospedagem VALUES (tp_fornecedor_hospedagem('88888888000122', 'Peninsula Hong Kong', tp_lista_contatos(tp_contato(tp_telefone('85228666688'), tp_email('phk@peninsula.com')), tp_contato(tp_telefone('85228666689'), tp_email('phkevents@peninsula.com'))), 'Hotel', 3.56, 230));


-- FORNECEDORES ALIMENTACAO
INSERT INTO tb_fornecedor_alimentacao VALUES (
    tp_fornecedor_alimentacao(
        '99999999000111',
        'Osteria Francescana',
        tp_lista_contatos(
            tp_contato(tp_telefone('390592224000'), tp_email('events@osteriafrancescana.it')),
            tp_contato(tp_telefone('390592224001'), tp_email('press@osteriafrancescana.it'))
        ),
        'Restaurante',
        5.0,
        50
    )
);

INSERT INTO tb_fornecedor_alimentacao VALUES (tp_fornecedor_alimentacao('10101010000110', 'El Celler de Can Roca', tp_lista_contatos(tp_contato(tp_telefone('34972222157'), tp_email('restaurant@cellercanroca.com')), tp_contato(tp_telefone('34972222158'), tp_email('events@cellercanroca.com'))), 'Restaurante', 5.0, 55));
INSERT INTO tb_fornecedor_alimentacao VALUES (tp_fornecedor_alimentacao('11111111000121', 'Noma', tp_lista_contatos(tp_contato(tp_telefone('4532963297'), tp_email('noma@noma.dk')), tp_contato(tp_telefone('4532963298'), tp_email('events@noma.dk'))), 'Restaurante', 4.9, 45));
INSERT INTO tb_fornecedor_alimentacao VALUES (tp_fornecedor_alimentacao('12121212000132', 'Le Bernardin', tp_lista_contatos(tp_contato(tp_telefone('12125544000'), tp_email('dining@le-bernardin.com')), tp_contato(tp_telefone('12125544001'), tp_email('private@le-bernardin.com'))), 'Restaurante', 4.08, 85));
INSERT INTO tb_fornecedor_alimentacao VALUES (tp_fornecedor_alimentacao('13131313000143', 'Eleven Madison Park', tp_lista_contatos(tp_contato(tp_telefone('12122889455'), tp_email('info@elevenmadisonpark.com')), tp_contato(tp_telefone('12122889456'), tp_email('events@elevenmadisonpark.com'))), 'Restaurante', 4.8, 80));
INSERT INTO tb_fornecedor_alimentacao VALUES (tp_fornecedor_alimentacao('14141414000154', 'Sukiyabashi Jiro', tp_lista_contatos(tp_contato(tp_telefone('81334317001'), tp_email('contact@sushi-jiro.jp')), tp_contato(tp_telefone('81334317002'), tp_email('reservation@sushi-jiro.jp'))), 'Restaurante', 1.8, 30));
INSERT INTO tb_fornecedor_alimentacao VALUES (tp_fornecedor_alimentacao('15151515000165', 'LArpège', tp_lista_contatos(tp_contato(tp_telefone('33147050906'), tp_email('arpege@alain-passard.com')), tp_contato(tp_telefone('33147050907'), tp_email('events@alain-passard.com'))), 'Restaurante', 4.8, 65));
INSERT INTO tb_fornecedor_alimentacao VALUES (tp_fornecedor_alimentacao('16161616000176', 'Alinea', tp_lista_contatos(tp_contato(tp_telefone('13122676767'), tp_email('hospitality@alinearestaurant.com')), tp_contato(tp_telefone('13122676768'), tp_email('events@alinearestaurant.com'))), 'Restaurante', 4.987, 75));


-- FORNECEDORES EVENTO
INSERT INTO tb_fornecedor_evento VALUES (
    tp_fornecedor_evento(
        '17171717000187',
        'Cannes Festival Events',
        tp_lista_contatos(
            tp_contato(tp_telefone('33493394001'), 
            tp_email('events@festival-cannes.fr'))
        ),
        'Cultural',
        2000
    )
);

INSERT INTO tb_fornecedor_evento VALUES (tp_fornecedor_evento('18181818000198', 'Art Basel', tp_lista_contatos(tp_contato(tp_telefone('41583067733'), tp_email('info@artbasel.com')), tp_contato(tp_telefone('41583067734'), tp_email('vip@artbasel.com'))), 'Cultural', 1500));
INSERT INTO tb_fornecedor_evento VALUES (tp_fornecedor_evento('19191919000109', 'Tomorrowland', tp_lista_contatos(tp_contato(tp_telefone('3228080808'), tp_email('info@tomorrowland.com')), tp_contato(tp_telefone('3228080809'), tp_email('vip@tomorrowland.com'))), 'Musical', 100000));
INSERT INTO tb_fornecedor_evento VALUES (tp_fornecedor_evento('20202020000154', 'Oktoberfest München', tp_lista_contatos(tp_contato(tp_telefone('498923300'), tp_email('info@oktoberfest.de')), tp_contato(tp_telefone('498923301'), tp_email('commercial@oktoberfest.de'))), 'Cultural', 50000));
INSERT INTO tb_fornecedor_evento VALUES (tp_fornecedor_evento('21212121000165', 'Coachella', tp_lista_contatos(tp_contato(tp_telefone('17606985100'), tp_email('info@coachella.com')), tp_contato(tp_telefone('17606985101'), tp_email('vip@coachella.com'))), 'Musical', 125000));
INSERT INTO tb_fornecedor_evento VALUES (tp_fornecedor_evento('22222222000176', 'Venice Carnival', tp_lista_contatos(tp_contato(tp_telefone('390412424'), tp_email('info@carnevale.venezia.it')), tp_contato(tp_telefone('390412425'), tp_email('events@carnevale.venezia.it'))), 'Cultural', 3000));
INSERT INTO tb_fornecedor_evento VALUES (tp_fornecedor_evento('23232323000187', 'Dubai Expo', tp_lista_contatos(tp_contato(tp_telefone('97144380000'), tp_email('info@dubaiexpo.ae')), tp_contato(tp_telefone('97144380001'), tp_email('business@dubaiexpo.ae'))), 'Comercial', 25000));
INSERT INTO tb_fornecedor_evento VALUES (tp_fornecedor_evento('24242424000198', 'Rio Carnival', tp_lista_contatos(tp_contato(tp_telefone('552139726466'), tp_email('contato@carnaval.rio')), tp_contato(tp_telefone('552139726467'), tp_email('tourism@carnaval.rio'))), 'Cultural', 75000));


-- FORNECEDORES TRANSPORTE
INSERT INTO tb_fornecedor_transporte VALUES (
    tp_fornecedor_transporte(
        '25252525000109',
        'Emirates Airlines',
        tp_lista_contatos(
            tp_contato(tp_telefone('97142142111'), tp_email('reservations@emirates.com')),
            tp_contato(tp_telefone('97142142112'), tp_email('cargo@emirates.com')),
            tp_contato(tp_telefone('97142142113'), tp_email('business@emirates.com'))
        ),
        'Aereo',
        tp_frotas_transp()
    )
);

INSERT INTO TABLE(SELECT t.frotas FROM tb_fornecedor_transporte t WHERE t.cnpj = '25252525000109') VALUES (tp_frota('Airbus A380', 115));
INSERT INTO TABLE(SELECT t.frotas FROM tb_fornecedor_transporte t WHERE t.cnpj = '25252525000109') VALUES (tp_frota('Boeing 777', 155));

INSERT INTO tb_fornecedor_transporte VALUES (tp_fornecedor_transporte('26262626000110', 'Singapore Airlines', tp_lista_contatos(tp_contato(tp_telefone('6565458888'), tp_email('booking@singaporeair.com')), tp_contato(tp_telefone('6565458889'), tp_email('cargo@singaporeair.com'))), 'Aereo', tp_frotas_transp()));
INSERT INTO TABLE(SELECT t.frotas FROM tb_fornecedor_transporte t WHERE t.cnpj = '26262626000110') VALUES (tp_frota('Airbus A350', 52));
INSERT INTO TABLE(SELECT t.frotas FROM tb_fornecedor_transporte t WHERE t.cnpj = '26262626000110') VALUES (tp_frota('Boeing 787', 27));

INSERT INTO tb_fornecedor_transporte VALUES (tp_fornecedor_transporte('27272727000121', 'MSC Cruises', tp_lista_contatos(tp_contato(tp_telefone('41227973232'), tp_email('reservations@msccruises.com')), tp_contato(tp_telefone('41227973233'), tp_email('groups@msccruises.com'))), 'Maritimo', tp_frotas_transp()));
INSERT INTO TABLE(SELECT t.frotas FROM tb_fornecedor_transporte t WHERE t.cnpj = '27272727000121') VALUES (tp_frota('Cruise Ship', 19));

INSERT INTO tb_fornecedor_transporte VALUES (tp_fornecedor_transporte('28282828000132', 'SNCF', tp_lista_contatos(tp_contato(tp_telefone('33892353535'), tp_email('contact@sncf.fr')), tp_contato(tp_telefone('33892353536'), tp_email('business@sncf.fr'))), 'Ferroviario', tp_frotas_transp()));
INSERT INTO TABLE(SELECT t.frotas FROM tb_fornecedor_transporte t WHERE t.cnpj = '28282828000132') VALUES (tp_frota('TGV', 400));
INSERT INTO TABLE(SELECT t.frotas FROM tb_fornecedor_transporte t WHERE t.cnpj = '28282828000132') VALUES (tp_frota('Intercités', 300));

INSERT INTO tb_fornecedor_transporte VALUES (tp_fornecedor_transporte('29292929000143', 'Deutsche Bahn', tp_lista_contatos(tp_contato(tp_telefone('4918056996633'), tp_email('service@bahn.de')), tp_contato(tp_telefone('4918056996634'), tp_email('business@bahn.de'))), 'Ferroviario', tp_frotas_transp()));
INSERT INTO TABLE(SELECT t.frotas FROM tb_fornecedor_transporte t WHERE t.cnpj = '29292929000143') VALUES (tp_frota('ICE Train', 245));

INSERT INTO tb_fornecedor_transporte VALUES (tp_fornecedor_transporte('30303030000154', 'Norwegian Cruise Line', tp_lista_contatos(tp_contato(tp_telefone('18665234389'), tp_email('reservations@ncl.com')), tp_contato(tp_telefone('18665234390'), tp_email('groups@ncl.com'))), 'Maritimo', tp_frotas_transp()));
INSERT INTO TABLE(SELECT t.frotas FROM tb_fornecedor_transporte t WHERE t.cnpj = '30303030000154') VALUES (tp_frota('Cruise Ship', 17));
INSERT INTO TABLE(SELECT t.frotas FROM tb_fornecedor_transporte t WHERE t.cnpj = '30303030000154') VALUES (tp_frota('Private Yacht', 5));

INSERT INTO tb_fornecedor_transporte VALUES (tp_fornecedor_transporte('31313131000165', 'Eurostar', tp_lista_contatos(tp_contato(tp_telefone('442078433399'), tp_email('contact@eurostar.com')), tp_contato(tp_telefone('442078433400'), tp_email('business@eurostar.com'))), 'Ferroviario', tp_frotas_transp()));
INSERT INTO TABLE(SELECT t.frotas FROM tb_fornecedor_transporte t WHERE t.cnpj = '31313131000165') VALUES (tp_frota('High Speed Train', 27));


-- POSSUI (relacionamento entre fornecedor, pacote e atividade)
INSERT INTO tb_possui VALUES (
    tp_possui(
        (SELECT REF(f) FROM tb_fornecedor_transporte f WHERE f.cnpj = '25252525000109'), -- Emirates Airlines
        (SELECT REF(p) FROM tb_pacote p WHERE p.codigo = 1), -- Aventura Total
        (SELECT REF(a) FROM tb_atividade a WHERE a.codigo = 1) -- Tour Histórico
    )
);

INSERT INTO tb_possui VALUES (tp_possui((SELECT REF(f) FROM tb_fornecedor_hospedagem f WHERE f.cnpj = '11111111000199'), (SELECT REF(p) FROM tb_pacote p WHERE p.codigo = 2), (SELECT REF(a) FROM tb_atividade a WHERE a.codigo = 2))); -- Four Seasons + Relaxamento Spa + Mergulho
INSERT INTO tb_possui VALUES (tp_possui((SELECT REF(f) FROM tb_fornecedor_alimentacao f WHERE f.cnpj = '99999999000111'), (SELECT REF(p) FROM tb_pacote p WHERE p.codigo = 3), (SELECT REF(a) FROM tb_atividade a WHERE a.codigo = 3))); -- Osteria + Tour Cultural + Passeio Barco
INSERT INTO tb_possui VALUES (tp_possui((SELECT REF(f) FROM tb_fornecedor_evento f WHERE f.cnpj = '17171717000187'), (SELECT REF(p) FROM tb_pacote p WHERE p.codigo = 4), (SELECT REF(a) FROM tb_atividade a WHERE a.codigo = 4))); -- Cannes + Expedição + Trilha
INSERT INTO tb_possui VALUES (tp_possui((SELECT REF(f) FROM tb_fornecedor_transporte f WHERE f.cnpj = '26262626000110'), (SELECT REF(p) FROM tb_pacote p WHERE p.codigo = 5), (SELECT REF(a) FROM tb_atividade a WHERE a.codigo = 5))); -- Singapore Airlines + Sabores + Workshop
INSERT INTO tb_possui VALUES (tp_possui((SELECT REF(f) FROM tb_fornecedor_hospedagem f WHERE f.cnpj = '22222222000188'), (SELECT REF(p) FROM tb_pacote p WHERE p.codigo = 6), (SELECT REF(a) FROM tb_atividade a WHERE a.codigo = 6))); -- Ritz + Romântico + Surfe
INSERT INTO tb_possui VALUES (tp_possui((SELECT REF(f) FROM tb_fornecedor_alimentacao f WHERE f.cnpj = '10101010000110'), (SELECT REF(p) FROM tb_pacote p WHERE p.codigo = 7), (SELECT REF(a) FROM tb_atividade a WHERE a.codigo = 7))); -- El Celler + Fim de Semana + Tour Foto
INSERT INTO tb_possui VALUES (tp_possui((SELECT REF(f) FROM tb_fornecedor_evento f WHERE f.cnpj = '18181818000198'), (SELECT REF(p) FROM tb_pacote p WHERE p.codigo = 8), (SELECT REF(a) FROM tb_atividade a WHERE a.codigo = 8))); -- Art Basel + Descoberta + Festival Gastro
INSERT INTO tb_possui VALUES (tp_possui((SELECT REF(f) FROM tb_fornecedor_transporte f WHERE f.cnpj = '27272727000121'), (SELECT REF(p) FROM tb_pacote p WHERE p.codigo = 1), (SELECT REF(a) FROM tb_atividade a WHERE a.codigo = 2))); -- MSC + Aventura + Mergulho
INSERT INTO tb_possui VALUES (tp_possui((SELECT REF(f) FROM tb_fornecedor_hospedagem f WHERE f.cnpj = '33333333000177'), (SELECT REF(p) FROM tb_pacote p WHERE p.codigo = 2), (SELECT REF(a) FROM tb_atividade a WHERE a.codigo = 3))); -- Burj + Relaxamento + Passeio
INSERT INTO tb_possui VALUES (tp_possui((SELECT REF(f) FROM tb_fornecedor_alimentacao f WHERE f.cnpj = '11111111000121'), (SELECT REF(p) FROM tb_pacote p WHERE p.codigo = 3), (SELECT REF(a) FROM tb_atividade a WHERE a.codigo = 4))); -- Noma + Cultural + Trilha
INSERT INTO tb_possui VALUES (tp_possui((SELECT REF(f) FROM tb_fornecedor_evento f WHERE f.cnpj = '19191919000109'), (SELECT REF(p) FROM tb_pacote p WHERE p.codigo = 4), (SELECT REF(a) FROM tb_atividade a WHERE a.codigo = 5))); -- Tomorrowland + Expedição + Workshop


-- RESERVAS
INSERT INTO tb_reserva VALUES (
    tp_reserva(
        (SELECT REF(c) FROM tb_cliente c WHERE c.cpf = '12345678901'),
        (SELECT REF(p) FROM tb_pacote p WHERE p.codigo = 1),
        (SELECT REF(pr) FROM tb_promocao pr WHERE pr.codigo = 1),
        SYSDATE,
        SYSDATE + 7,
        SYSDATE + 14,
        SYSDATE,
        'Reservado'
    )
);

INSERT INTO tb_reserva VALUES (tp_reserva((SELECT REF(c) FROM tb_cliente c WHERE c.cpf = '23456789012'), (SELECT REF(p) FROM tb_pacote p WHERE p.codigo = 2), NULL, SYSDATE-30, SYSDATE-25, SYSDATE-20, SYSDATE-30, 'Concluido')); 
INSERT INTO tb_reserva VALUES (tp_reserva((SELECT REF(c) FROM tb_cliente c WHERE c.cpf = '34567890123'), (SELECT REF(p) FROM tb_pacote p WHERE p.codigo = 3), (SELECT REF(pr) FROM tb_promocao pr WHERE pr.codigo = 2), SYSDATE-15, SYSDATE + 15, SYSDATE + 20, SYSDATE-10, 'Cancelado')); 
INSERT INTO tb_reserva VALUES (tp_reserva((SELECT REF(c) FROM tb_cliente c WHERE c.cpf = '45678901234'), (SELECT REF(p) FROM tb_pacote p WHERE p.codigo = 4), (SELECT REF(pr) FROM tb_promocao pr WHERE pr.codigo = 3), SYSDATE-45, SYSDATE-40, SYSDATE-35, SYSDATE-45, 'Concluido')); 
INSERT INTO tb_reserva VALUES (tp_reserva((SELECT REF(c) FROM tb_cliente c WHERE c.cpf = '56789012345'), (SELECT REF(p) FROM tb_pacote p WHERE p.codigo = 5), (SELECT REF(pr) FROM tb_promocao pr WHERE pr.codigo = 4), SYSDATE, SYSDATE + 25, SYSDATE + 30, SYSDATE, 'Reservado')); 
INSERT INTO tb_reserva VALUES (tp_reserva((SELECT REF(c) FROM tb_cliente c WHERE c.cpf = '67890123456'), (SELECT REF(p) FROM tb_pacote p WHERE p.codigo = 6), (SELECT REF(pr) FROM tb_promocao pr WHERE pr.codigo = 5), SYSDATE-20, SYSDATE-15, SYSDATE-10, SYSDATE-5, 'Concluido')); 
INSERT INTO tb_reserva VALUES (tp_reserva((SELECT REF(c) FROM tb_cliente c WHERE c.cpf = '78901234567'), (SELECT REF(p) FROM tb_pacote p WHERE p.codigo = 7), (SELECT REF(pr) FROM tb_promocao pr WHERE pr.codigo = 6), SYSDATE-5, SYSDATE + 35, SYSDATE + 40, SYSDATE-1, 'Cancelado')); 
INSERT INTO tb_reserva VALUES (tp_reserva((SELECT REF(c) FROM tb_cliente c WHERE c.cpf = '89012345678'), (SELECT REF(p) FROM tb_pacote p WHERE p.codigo = 8), NULL, SYSDATE-60, SYSDATE-55, SYSDATE-50, SYSDATE-60, 'Concluido')); 
INSERT INTO tb_reserva VALUES (tp_reserva((SELECT REF(c) FROM tb_cliente c WHERE c.cpf = '90123456789'), (SELECT REF(p) FROM tb_pacote p WHERE p.codigo = 1), (SELECT REF(pr) FROM tb_promocao pr WHERE pr.codigo = 1), SYSDATE, SYSDATE + 45, SYSDATE + 50, SYSDATE, 'Reservado')); 
INSERT INTO tb_reserva VALUES (tp_reserva((SELECT REF(c) FROM tb_cliente c WHERE c.cpf = '01234567890'), (SELECT REF(p) FROM tb_pacote p WHERE p.codigo = 2), (SELECT REF(pr) FROM tb_promocao pr WHERE pr.codigo = 2), SYSDATE-10, SYSDATE + 50, SYSDATE + 55, SYSDATE-5, 'Cancelado')); 
INSERT INTO tb_reserva VALUES (tp_reserva((SELECT REF(c) FROM tb_cliente c WHERE c.cpf = '12345678901'), (SELECT REF(p) FROM tb_pacote p WHERE p.codigo = 3), (SELECT REF(pr) FROM tb_promocao pr WHERE pr.codigo = 3), SYSDATE-90, SYSDATE-85, SYSDATE-80, SYSDATE-90, 'Concluido'));
INSERT INTO tb_reserva VALUES (tp_reserva((SELECT REF(c) FROM tb_cliente c WHERE c.cpf = '23456789012'), (SELECT REF(p) FROM tb_pacote p WHERE p.codigo = 4), (SELECT REF(pr) FROM tb_promocao pr WHERE pr.codigo = 4), SYSDATE, SYSDATE + 60, SYSDATE + 65, SYSDATE, 'Reservado')); 


