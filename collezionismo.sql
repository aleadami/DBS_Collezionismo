--legato a Utente
CREATE TABLE Ambiente_Gioco (
    Nome_Ambiente VARCHAR(20) PRIMARY KEY,
    Organizzatore VARCHAR(20) NOT NULL
);

--legata a Carta, Utente
CREATE TABLE Mazzo (
    Codice_Mazzo VARCHAR(8) PRIMARY KEY,
    Nome_Mazzo VARCHAR(15) NOT NULL,
    Data_Validazione DATE,
    Numero_Carte INT NOT NULL
);

--legato a Singolo
CREATE TABLE Biglietto (
    Codice_Seriale VARCHAR(15) PRIMARY KEY,
    Prezzo DECIMAL(5,2) NOT NULL
);

--legato a Squadra
CREATE TABLE Organizzazione_Esports (
    Partita_IVA VARCHAR(11) PRIMARY KEY,
    Sede_Legale VARCHAR(20) NOT NULL,
    Budget_Sponsorizzazione DECIMAL(10,2) NOT NULL
);

--legato a Carta
CREATE TABLE Espansione (
    Codice_Espansione VARCHAR(6),
    Nome_Espansione VARCHAR(20),
    Data_Rilascio DATE NOT NULL,
    PRIMARY KEY (Codice_Espansione, Nome_Espansione)
);

--legato a Carta
CREATE TABLE Restrizione (
    Nome_Lista VARCHAR(8) PRIMARY KEY,
    Limitazione INT NOT NULL,
    Bannato INT NOT NULL
);

--legato a Risultato
CREATE TABLE Partita (
    Codice_Partita VARCHAR(8) PRIMARY KEY,
    Ora_Inizio TIMESTAMP,
    Fase_Torneo VARCHAR(20) NOT NULL
);

--legata a Pokemon
CREATE TABLE Abilità (
    Nome_Abilità VARCHAR(20) PRIMARY KEY,
    Descrizione_Effetto TEXT NOT NULL,
    Danni INT,
    Costo_Energia INT
);

--legata a Risultato, Piattaforma, Mazzo, Carta
CREATE TABLE Utente (
    Nickname VARCHAR(20) PRIMARY KEY,
    Email VARCHAR(20) NOT NULL,
    Data_Iscrizione DATE NOT NULL,
    Ambiente VARCHAR(20) NOT NULL,
    Mazzo VARCHAR(8),
    FOREIGN KEY (Ambiente) REFERENCES Ambiente_Gioco(Nome_Ambiente),
    FOREIGN KEY (Mazzo) REFERENCES Mazzo(Codice_Mazzo)
);

--legata a Espansione, Restrizione, Utente, Mazzo
CREATE TABLE Carta (
    Codice_Carta VARCHAR(15) PRIMARY KEY,
    Nome_Carta VARCHAR(20) NOT NULL,
    Testo_Descrizione TEXT NOT NULL,
    Effetto TEXT,
    Codice_Espansione VARCHAR(6) NOT NULL,
    Nome_Espansione VARCHAR(20) NOT NULL,
    Restrizione VARCHAR(8),
    FOREIGN KEY (Codice_Espansione, Nome_Espansione) REFERENCES Espansione(Codice_Espansione, Nome_Espansione),
    FOREIGN KEY (Restrizione) REFERENCES Restrizione(Nome_Lista)
);

--sottotipo di Utente
--legato a Biglietto
CREATE TABLE Solitario (
    Utente VARCHAR(20) PRIMARY KEY,
    Nome_Reale VARCHAR(20) NOT NULL,
    Cognome_Reale VARCHAR(10) NOT NULL,
    Biglietto VARCHAR(15) NOT NULL,
    FOREIGN KEY (Utente) REFERENCES Utente(Nickname),
    FOREIGN KEY (Biglietto) REFERENCES Biglietto(Codice_Seriale)
);

--sottotipo di Utente
--legato a Organizzazione_Esports
CREATE TABLE Squadra (
    Utente VARCHAR(20) PRIMARY KEY,
    Tag_Squadra VARCHAR(3) NOT NULL,
    Numero_Membri INT NOT NULL,
    Esports VARCHAR(11),
    FOREIGN KEY (Utente) REFERENCES Utente(Nickname),
    FOREIGN KEY (Esports) REFERENCES Organizzazione_Esports(Partita_IVA)
);

--sottotipo di AmbienteGioco
CREATE TABLE Fisico (
    Ambiente VARCHAR(20) PRIMARY KEY,
    Indirizzo_Sede VARCHAR(30) NOT NULL,
    Capienza_Massima INT NOT NULL,
    FOREIGN KEY (Ambiente) REFERENCES Ambiente_Gioco(Nome_Ambiente)
);

--sottotipo di AmbienteGioco
CREATE TABLE Digitale (
    Ambiente VARCHAR(20) PRIMARY KEY,
    Indirizzo_IP VARCHAR(15) NOT NULL,
    Regione_Server VARCHAR(20) NOT NULL,
    FOREIGN KEY (Ambiente) REFERENCES Ambiente_Gioco(Nome_Ambiente)
);

--sottotipo di Carta
--legato a Abilità
CREATE TABLE Pokemon (
    Carta VARCHAR(15) PRIMARY KEY,
    Elemento_Pokemon VARCHAR(10) NOT NULL,
    Punti_Salute INT NOT NULL,
    Fase_Evolutiva INT NOT NULL,
    Debolezza VARCHAR(10) NOT NULL,
    Costo_Ritirata INT NOT NULL,
    FOREIGN KEY (Carta) REFERENCES Carta(Codice_Carta)
);

--sottotipo di Carta
CREATE TABLE Trainer (
    Carta VARCHAR(15) PRIMARY KEY,
    Massimo_Utilizzi INT,
    Sottotipo VARCHAR(15) NOT NULL,
    Durata INT NOT NULL,
    FOREIGN KEY (Carta) REFERENCES Carta(Codice_Carta)
);

--sottotipo di Carta
CREATE TABLE Energia(
    Carta VARCHAR(15) PRIMARY KEY,
    Bersaglio VARCHAR(20) NOT NULL,
    Elemento VARCHAR(10) NOT NULL,
    FOREIGN KEY (Carta) REFERENCES Carta(Codice_Carta)
);

--legato a Utente e Risultato
CREATE TABLE Risultato (
    Utente VARCHAR(20),
    Partita VARCHAR(8),
    Punteggio INT NOT NULL,
    Bonus_Assegnati TEXT,
    Penalità_Assegnate TEXT,
    PRIMARY KEY (Utente, Partita),
    FOREIGN KEY (Utente) REFERENCES Utente(Nickname),
    FOREIGN KEY (Partita) REFERENCES Partita(Codice_Partita)
);

--relazione N:N Collezione tra Utente e Carta
CREATE TABLE Collezione (
    Utente VARCHAR(20),
    Carta VARCHAR(15),
    Lingua VARCHAR(15) NOT NULL,
    Numero_Copie INT NOT NULL,
    PRIMARY KEY (Utente, Carta),
    FOREIGN KEY (Utente) REFERENCES Utente(Nickname),
    FOREIGN KEY (Carta) REFERENCES Carta(Codice_Carta)
);

--relazione N:N PartOf tra Carta e Mazzo
CREATE TABLE PartOf (
    Carta VARCHAR(15),
    Mazzo VARCHAR(8),
    Quantità INT NOT NULL,
    PRIMARY KEY (Carta, Mazzo),
    FOREIGN KEY (Carta) REFERENCES Carta(Codice_Carta),
    FOREIGN KEY (Mazzo) REFERENCES Mazzo(Codice_Mazzo)
);

--relazione N:N Corrispondenza tra Pokemon e Abilità
CREATE TABLE Corrispondenza (
    Pokemon VARCHAR(15),
    Abilità VARCHAR(20),
    PRIMARY KEY (Pokemon, Abilità),
    FOREIGN KEY (Pokemon) REFERENCES Pokemon(Carta),
    FOREIGN KEY (Abilità) REFERENCES Abilità(Nome_Abilità)
);


-- Popolamento DB
INSERT INTO Ambiente_Gioco (Nome_Ambiente, Organizzatore) VALUES
('Fumetteria KissaShop', 'Marco Rossi'),
('Palasport Roma', 'Federazione TCG'),
('TCG Live Server 1', 'The Pokemon Co'),
('Discord Arena', 'Community IT'),
('Padiglione Fiera', 'Lucca Comics'),
('Lega TCG Milano', 'Associazione PlayIT'),
('PTCGL Server 2', 'The Pokemon Co');

INSERT INTO Fisico (Ambiente, Indirizzo_Sede, Capienza_Massima) VALUES
('Fumetteria KissaShop', 'Via Roma 12, Milano', 32),
('Palasport Roma', 'Viale dell''Europa, Roma', 500),
('Padiglione Fiera', 'Via della Fiera 1, Lucca', 150),
('Lega TCG Milano', 'Via Torino 10, Milano', 60);

INSERT INTO Digitale (Ambiente, Indirizzo_IP, Regione_Server) VALUES
('TCG Live Server 1', '192.168.1.100', 'Europe-West'),
('Discord Arena', '10.0.0.45', 'Global'),
('PTCGL Server 2', '192.168.1.101', 'US-East');

INSERT INTO Mazzo (Codice_Mazzo, Nome_Mazzo, Data_Validazione, Numero_Carte) VALUES 
('MZZ-0001', 'Charizard ex', '2023-11-01', 60),
('MZZ-0002', 'Lost Zone Box', '2023-11-02', 60),
('MZZ-0003', 'Lugia VSTAR', '2023-11-03', 60),
('MZZ-0004', 'Snorlax Stall', '2023-11-04', 60),
('MZZ-0005', 'Mew VMAX', '2023-11-05', 60),
('MZZ-0006', 'Gardevoir ex', '2023-11-06', 60),
('MZZ-0007', 'Chien-Pao', '2023-11-07', 60);

INSERT INTO Biglietto (Codice_Seriale, Prezzo) VALUES 
('TCK-2023-00001', 15.50),
('TCK-2023-00002', 20.00),
('TCK-2023-00003', 15.50),
('TCK-2023-00004', 35.00),
('TCK-2023-00005', 0.00),
('TCK-2023-00006', 25.00),
('TCK-2023-00007', 25.00);

INSERT INTO Organizzazione_Esports (Partita_IVA, Sede_Legale, Budget_Sponsorizzazione) VALUES 
('12345678901', 'Milano', 50000.00),
('10987654321', 'Roma', 12500.50),
('11223344556', 'Torino', 75000.00),
('99887766554', 'Napoli', 5000.00),
('55566677788', 'Bologna', 30000.00),
('33344455566', 'Firenze', 15000.00);

INSERT INTO Espansione (Codice_Espansione, Nome_Espansione, Data_Rilascio) VALUES 
('PAR', 'Paradossal Scarlatto', '2023-11-03'),
('OBF', 'Ossidiana Infuocata', '2023-08-11'),
('PAL', 'Evoluzioni a Paldea', '2023-06-09'),
('SVI', 'Scarlatto e Violetto', '2023-03-31'),
('CRZ', 'Zenit Regale', '2023-01-20');

INSERT INTO Restrizione (Nome_Lista, Limitazione, Bannato) VALUES 
('Standard', 4, 0), -- Regola base: max 4 copie, non bannata
('Expanded', 4, 0), -- Formato esteso: max 4 copie, non bannata
('Limitata', 1, 0), -- Carta limitata: se ne può usare solo 1 per mazzo
('Banlist', 0, 1),  -- Carta bannata: 0 copie, flag "Bannato" attivo (1)
('Storico', 4, 0);  -- Formato storico: max 4 copie, non bannata

INSERT INTO Partita (Codice_Partita, Ora_Inizio, Fase_Torneo) VALUES 
('PRT-0001', '2023-11-10 09:00:00', 'Gironi'),
('PRT-0002', '2023-11-10 10:30:00', 'Gironi'),
('PRT-0003', '2023-11-10 14:00:00', 'Top 8'),
('PRT-0004', '2023-11-10 16:00:00', 'Semifinale'),
('PRT-0005', '2023-11-10 18:00:00', 'Finale'),
('PRT-0006', '2023-11-11 10:00:00', 'Gironi'),
('PRT-0007', '2023-11-11 11:30:00', 'Gironi'),
('PRT-0008', '2023-11-11 14:00:00', 'Gironi'),
('PRT-0009', '2023-11-11 15:30:00', 'Gironi'),
('PRT-0010', '2023-11-11 17:00:00', 'Gironi'),
('PRT-0011', '2023-11-11 18:30:00', 'Gironi'),
('PRT-0012', '2023-11-11 20:00:00', 'Quarti di Finale'),
('PRT-0013', '2023-11-11 21:30:00', 'Semifinale'),
('PRT-0014', '2023-11-12 10:00:00', 'Gironi'),
('PRT-0015', '2023-11-12 11:30:00', 'Gironi'),
('PRT-0016', '2023-11-12 14:00:00', 'Gironi'),
('PRT-0017', '2023-11-12 15:30:00', 'Gironi'),
('PRT-0018', '2023-11-12 17:00:00', 'Gironi'),
('PRT-0019', '2023-11-12 18:30:00', 'Gironi'),
('PRT-0020', '2023-11-13 10:00:00', 'Gironi'),
('PRT-0021', '2023-11-13 11:30:00', 'Gironi'),
('PRT-0022', '2023-11-13 14:00:00', 'Gironi');

INSERT INTO Abilità (Nome_Abilità, Descrizione_Effetto, Danni, Costo_Energia) VALUES 
('Lanciafiamme', 'Scarta un''Energia assegnata a questo Pokémon.', 130, 3),
('Cura Totale', 'Rimuove tutte le condizioni speciali.', NULL, 1),
('Morso', 'Nessun effetto aggiuntivo.', 30, 1),
('Iper Raggio', 'Il Pokémon non può attaccare durante il prossimo turno.', 150, 4),
('Fuga Rapida', 'Scambia questo Pokémon con uno in panchina.', NULL, 0),
('Abbraccio Psichico', 'Assegna a piacere energie Psico dalla pila degli scarti.', NULL, 0),
('Lama di Ghiaccio', 'Lancia una moneta, se esce testa infligge danni extra.', 120, 2),
('Genoma Hacker', 'Scegli 1 attacco del Pokémon attivo dell''avversario e usalo come questo attacco.', NULL, 3),
('Astro Evocazione', 'Puoi mettere 2 Pokémon Incolore dalla tua pila degli scarti nella tua panchina.', NULL, 0),
('Scelta Floreale', 'Guarda le prime 2 carte del tuo mazzo. Mettine 1 in mano e l''altra nell''Area Perduta.', NULL, 0);

INSERT INTO Utente (Nickname, Email, Data_Iscrizione, Ambiente, Mazzo) VALUES 
('AshKetchum', 'ash@poke.com', '2023-01-15', 'Fumetteria KissaShop', 'MZZ-0001'),
('ProGamer_IT', 'pro@mail.it', '2023-02-20', 'TCG Live Server 1', 'MZZ-0002'),
('PokeMaster', 'master@mail.com', '2023-03-10', 'Palasport Roma', 'MZZ-0003'),
('SnorlaxFan', 'sleep@mail.it', '2023-04-05', 'Discord Arena', 'MZZ-0004'),
('MewTwoBoss', 'mew@mail.com', '2023-05-12', 'Padiglione Fiera', 'MZZ-0005'),
('GardeQueen', 'garde@mail.it', '2023-06-01', 'Lega TCG Milano', 'MZZ-0006'),
('IceKing', 'ice@mail.com', '2023-06-15', 'PTCGL Server 2', 'MZZ-0007');

INSERT INTO Carta (Codice_Carta, Nome_Carta, Testo_Descrizione, Effetto, Codice_Espansione, Nome_Espansione, Restrizione) VALUES 
('SVI-001', 'Pikachu ex', 'Un topo elettrico molto potente.', 'Se lanci testa, paralizza il difensore.', 'SVI', 'Scarlatto e Violetto', 'Standard'),
('OBF-006', 'Charizard ex', 'Sputa fiamme roventi in grado di sciogliere la roccia.', 'Quando lo giochi, puoi assegnargli 3 energie.', 'OBF', 'Ossidiana Infuocata', 'Standard'),
('SVI-150', 'Caramella Rara', 'Un dolcetto misterioso che accelera la crescita.', 'Fai evolvere un Pokémon Base saltando la fase 1.', 'SVI', 'Scarlatto e Violetto', 'Limitata'),
('PAL-200', 'Arbitro', 'Un giudice inflessibile che ristabilisce l''ordine.', 'Entrambi i giocatori rimescolano la mano e pescano 4 carte.', 'PAL', 'Evoluzioni a Paldea', 'Standard'),
('SVI-099', 'Energia Fuoco', 'Fornisce energia di tipo fuoco.', NULL, 'SVI', 'Scarlatto e Violetto', 'Standard'),
('SVI-050', 'Gardevoir ex', 'Un Pokémon elegante con forti poteri psichici.', NULL, 'SVI', 'Scarlatto e Violetto', 'Standard'),
('PAL-010', 'Chien-Pao ex', 'Il padrone delle nevi.', NULL, 'PAL', 'Evoluzioni a Paldea', 'Standard'),
('SVI-160', 'Ricerca Accademica', 'Un professore ti aiuta con la ricerca.', 'Scarta la tua mano e pesca 7 carte.', 'SVI', 'Scarlatto e Violetto', 'Standard'),
('SVI-100', 'Energia Psico', 'Fornisce energia di tipo psico.', NULL, 'SVI', 'Scarlatto e Violetto', 'Standard'),
('SVI-151', 'Mew ex', 'Un Pokémon mitico con DNA versatile.', 'Pesca carte fino ad averne 3 in mano.', 'SVI', 'Scarlatto e Violetto', 'Standard'),
('CRZ-138', 'Lugia VSTAR', 'Signore dei mari e delle tempeste.', NULL, 'CRZ', 'Zenit Regale', 'Standard'),
('CRZ-050', 'Comfey', 'Raccoglie fiori per fare ghirlande.', NULL, 'CRZ', 'Zenit Regale', 'Standard'),
('SVI-170', 'Scambio', 'Oggetto rapido per il riposizionamento.', 'Scambia il tuo Pokémon in posizione attiva con uno nella tua panchina.', 'SVI', 'Scarlatto e Violetto', 'Standard'),
('PAL-250', 'Ordini del Capo', 'Un ordine inequivocabile dal capo del Team.', 'Scambia uno dei Pokémon in panchina del tuo avversario con il suo Pokémon in posizione attiva.', 'PAL', 'Evoluzioni a Paldea', 'Standard'),
('SVI-101', 'Energia Acqua', 'Fornisce energia di tipo acqua.', NULL, 'SVI', 'Scarlatto e Violetto', 'Standard');

INSERT INTO Pokemon (Carta, Elemento_Pokemon, Punti_Salute, Fase_Evolutiva, Debolezza, Costo_Ritirata) VALUES 
('SVI-001', 'Elettro', 200, 0, 'Lotta', 1), 
('OBF-006', 'Fuoco', 330, 2, 'Acqua', 2),
('SVI-050', 'Psico', 310, 2, 'Buio', 2),
('PAL-010', 'Acqua', 220, 0, 'Metallo', 2),
('SVI-151', 'Psico', 180, 0, 'Buio', 0),
('CRZ-138', 'Incolore', 280, 1, 'Elettro', 2),
('CRZ-050', 'Psico', 70, 0, 'Metallo', 1);

INSERT INTO Trainer (Carta, Massimo_Utilizzi, Sottotipo, Durata) VALUES 
('SVI-150', NULL, 'Strumento', 0), 
('PAL-200', 1, 'Aiuto', 1),
('SVI-160', 1, 'Aiuto', 1),
('SVI-170', NULL, 'Strumento', 0),
('PAL-250', 1, 'Aiuto', 1);

INSERT INTO Energia (Carta, Bersaglio, Elemento) VALUES 
('SVI-099', 'Qualsiasi', 'Fuoco'),
('SVI-100', 'Qualsiasi', 'Psico'),
('SVI-101', 'Qualsiasi', 'Acqua');

INSERT INTO Solitario (Utente, Nome_Reale, Cognome_Reale, Biglietto) VALUES 
('AshKetchum', 'Satoshi', 'Tajiri', 'TCK-2023-00001'),
('PokeMaster', 'Mario', 'Rossi', 'TCK-2023-00003'),
('MewTwoBoss', 'Giovanni', 'Rocket', 'TCK-2023-00005'),
('GardeQueen', 'Sofia', 'Bianchi', 'TCK-2023-00006');

INSERT INTO Squadra (Utente, Tag_Squadra, Numero_Membri, Esports) VALUES 
('ProGamer_IT', 'PRO', 5, '12345678901'),
('SnorlaxFan', 'SNX', 3, '11223344556'),
('IceKing', 'ICE', 4, '33344455566');

INSERT INTO Collezione (Utente, Carta, Lingua, Numero_Copie) VALUES 
('AshKetchum', 'OBF-006', 'Italiano', 4),
('AshKetchum', 'SVI-099', 'Inglese', 12),
('AshKetchum', 'SVI-150', 'Italiano', 2),
('ProGamer_IT', 'SVI-001', 'Giapponese', 2),
('ProGamer_IT', 'PAL-200', 'Italiano', 6),
('PokeMaster', 'OBF-006', 'Inglese', 1),
('PokeMaster', 'SVI-150', 'Inglese', 4),
('GardeQueen', 'SVI-050', 'Italiano', 3),
('IceKing', 'PAL-010', 'Inglese', 4),
('IceKing', 'SVI-160', 'Inglese', 8);

INSERT INTO Corrispondenza (Pokemon, Abilità) VALUES 
('SVI-001', 'Fuga Rapida'),
('SVI-001', 'Morso'),
('OBF-006', 'Lanciafiamme'),
('OBF-006', 'Iper Raggio'), 
('SVI-050', 'Abbraccio Psichico'),
('PAL-010', 'Lama di Ghiaccio'),
('SVI-151', 'Genoma Hacker'),
('CRZ-138', 'Astro Evocazione'),
('CRZ-050', 'Scelta Floreale');

INSERT INTO PartOf (Carta, Mazzo, Quantità) VALUES 
('OBF-006', 'MZZ-0001', 3),
('SVI-099', 'MZZ-0001', 4),
('SVI-150', 'MZZ-0001', 2),
('SVI-001', 'MZZ-0002', 2),
('PAL-200', 'MZZ-0002', 4),
('SVI-150', 'MZZ-0002', 1),
('SVI-150', 'MZZ-0003', 4),
('SVI-050', 'MZZ-0006', 3),
('SVI-100', 'MZZ-0006', 10),
('SVI-160', 'MZZ-0006', 4),
('PAL-010', 'MZZ-0007', 4),
('SVI-160', 'MZZ-0007', 4),
('SVI-160', 'MZZ-0001', 2),
('PAL-200', 'MZZ-0004', 3),
('PAL-200', 'MZZ-0005', 2);

INSERT INTO Risultato (Utente, Partita, Punteggio, Bonus_Assegnati, Penalità_Assegnate) VALUES 
('AshKetchum', 'PRT-0001', 3, NULL, NULL),
('ProGamer_IT', 'PRT-0001', 0, NULL, 'Warning: Gioco lento durante il turno 3.'),
('PokeMaster', 'PRT-0002', 1, NULL, NULL),
('SnorlaxFan', 'PRT-0002', 1, NULL, NULL),
('MewTwoBoss', 'PRT-0003', 3, 'Vittoria assegnata d''ufficio (Bye) per numero dispari di giocatori al turno.', NULL),
('SnorlaxFan', 'PRT-0004', 3, NULL, NULL),
('AshKetchum', 'PRT-0004', 0, NULL, NULL),
('ProGamer_IT', 'PRT-0006', 3, NULL, NULL),
('ProGamer_IT', 'PRT-0007', 3, NULL, NULL),
('ProGamer_IT', 'PRT-0008', 3, NULL, NULL),
('ProGamer_IT', 'PRT-0009', 3, NULL, NULL),
('ProGamer_IT', 'PRT-0010', 3, NULL, NULL),
('ProGamer_IT', 'PRT-0011', 3, NULL, NULL),
('GardeQueen', 'PRT-0012', 3, NULL, NULL),
('IceKing', 'PRT-0012', 0, NULL, NULL),
('GardeQueen', 'PRT-0013', 1, NULL, NULL),
('AshKetchum', 'PRT-0013', 1, NULL, 'Warning: Errore di rimescolamento del mazzo.'),
('SnorlaxFan', 'PRT-0014', 3, NULL, NULL),
('SnorlaxFan', 'PRT-0015', 3, NULL, NULL),
('SnorlaxFan', 'PRT-0016', 3, NULL, NULL),
('SnorlaxFan', 'PRT-0017', 3, NULL, NULL),
('IceKing', 'PRT-0018', 3, NULL, NULL),
('IceKing', 'PRT-0019', 3, NULL, NULL),
('IceKing', 'PRT-0020', 3, NULL, NULL),
('IceKing', 'PRT-0021', 3, NULL, NULL),
('IceKing', 'PRT-0022', 3, NULL, NULL);


-- Query 1: Elenca a che espansione appartengono le carte più giocate
SELECT C.Nome_Carta, E.Nome_Espansione, COUNT(DISTINCT M.Codice_Mazzo) AS Conteggio 
FROM Espansione E 
JOIN Carta C ON E.Codice_Espansione = C.Codice_Espansione AND E.Nome_Espansione = C.Nome_Espansione
JOIN PartOf P ON C.Codice_Carta = P.Carta
JOIN Mazzo M ON P.Mazzo = M.Codice_Mazzo
JOIN Utente U ON U.Mazzo = M.Codice_Mazzo
GROUP BY C.Nome_Carta, E.Nome_Espansione
HAVING COUNT(DISTINCT M.Codice_Mazzo) >= 3
ORDER BY Conteggio DESC;

-- Query 2: Elenca quali giocatori hanno disputato più di 5 partite totali in ambienti digitali ottenendo una media di punteggio superiore a 2 punti
SELECT U.Nickname, COUNT(R.Partita) AS Partite_Digitali , AVG(R.Punteggio) AS Punteggio_Medio
FROM Utente U 
JOIN Digitale D ON U.Ambiente = D.Ambiente
JOIN Risultato R ON R.Utente = U.Nickname
GROUP BY U.Nickname
HAVING COUNT(R.Partita) > 5 AND AVG(R.Punteggio) > 2.0
ORDER BY Punteggio_Medio DESC;

-- Query 3: Elenca quali mazzi nel database presentano un'incoerenza tra il valore ridondante 'Numero_Carte' e il conteggio effettivo delle carte fisicamente presenti nella tabella 'PartOf'
SELECT M.Codice_Mazzo, M.Nome_Mazzo, M.Numero_Carte AS Valore_Ridondanza, SUM(P.Quantità) AS Valore_Quantità
FROM Mazzo M JOIN PartOf P ON M.Codice_Mazzo = P.Mazzo
GROUP BY M.Codice_Mazzo, M.Nome_Mazzo, M.Numero_Carte
HAVING M.Numero_Carte <> SUM(P.Quantità);

-- Query 4: Creiamo una vista permanente che calcoli la classifica live del torneo (nickname, somma dei punti e partite disputate). Dopodiché, interroghiamo la vista per estrarre solo la i primi tre giocatori e il rispettivo punteggio
CREATE VIEW Classifica AS (
    SELECT Utente, SUM(Punteggio) AS Punti_Totali, COUNT(Partita) AS Partite_Giocate
    FROM Risultato
    GROUP BY Utente
);
SELECT Utente, Punti_Totali
FROM Classifica
ORDER BY Punti_Totali DESC
LIMIT 3;

-- Query 5: Trova i dettagli di tutti i giocatori (Nome, Cognome, Email) che hanno utilizzato almeno una volta un ambiente di gioco 'Fisico' (ovvero che hanno giocato un match dal vivo, escludendo chi ha giocato solo online)
SELECT S.Nome_Reale, S.Cognome_Reale, U.Email
FROM Solitario S JOIN Utente U ON S.Utente = U.Nickname
WHERE U.Nickname IN (
    SELECT R.Utente
    FROM Risultato R
    JOIN Utente U ON R.Utente = U.Nickname
    JOIN Fisico F ON U.Ambiente = F.Ambiente
);

-- Indice query 1 e 3
CREATE INDEX idx_partof_mazzo ON PartOf(Mazzo);
-- Indice query 2 e 4
CREATE INDEX idx_risultato ON Risultato(Utente, Punteggio);