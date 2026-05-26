--legata a Risultato, Piattaforma, Mazzo, Carta
CREATE TABLE Utente (
    Nickname VARCHAR(20) PRIMARY KEY,
    Email VARCHAR(20) NOT NULL,
    Data_Iscrizione DATE NOT NULL,
    Ambiente VARCHAR(20),
    Mazzo VARCHAR(8),
    FOREIGN KEY (Ambiente) REFERENCES Ambiente_Gioco(Nome_Ambiente),
    FOREIGN KEY (Mazzo) REFERENCES Mazzo(Codice_Mazzo)
);

--sottotipo di Utente
--legato a Biglietto
CREATE TABLE Solitario (
    Utente VARCHAR(20) PRIMARY KEY,
    Nome_Reale VARCHAR(20) NOT NULL,
    Cognome_Reale VARCHAR(10) NOT NULL,
    Biglietto VARCHAR(15),
    FOREIGN KEY (Biglietto) REFERENCES Biglietto(Codice_Seriale)
);

--sottotipo di Utente
--legato a Organizzazione_Esports
CREATE TABLE Squadra (
    Utente VARCHAR(20) PRIMARY KEY,
    Tag_Squadra VARCHAR(3) NOT NULL,
    Numero_Membri INT,
    Esports VARCHAR(11),
    FOREIGN KEY (Esports) REFERENCES Organizzazione_Esports(Partita_IVA)
);

--legato a Singolo
CREATE TABLE Biglietto (
    Codice_Seriale VARCHAR(15) PRIMARY KEY,
    Prezzo DECIMAL 
);

--legato a Squadra
CREATE TABLE Organizzazione_Esports (
    Partita_IVA VARCHAR(11) PRIMARY KEY,
    Sede_Legale VARCHAR(20) NOT NULL,
    Budget_Sponsorizzazione DECIMAL NOT NULL,
    Squadra VARCHAR(20)
);

--legata a Espansione, Restrizione, Utente, Mazzo
CREATE TABLE Carta (
    Codice_Carta VARCHAR(10) PRIMARY KEY,
    Nome_Carta VARCHAR(20) NOT NULL,
    Testo_Descrizione TEXT NOT NULL,
    Effetto TEXT,
    Espansione VARCHAR(6),
    Restrizione VARCHAR(8),
    FOREIGN KEY (Espansione) REFERENCES Espansione(Codice_Espansione),
    FOREIGN KEY (Restrizione) REFERENCES Restrizione(Nome_Lista)
);

--sottotipo di Carta
--legato a Abilità
CREATE TABLE Pokemon (
    Carta VARCHAR(15) PRIMARY KEY,
    Elemento_Pokemon VARCHAR(10) NOT NULL,
    Punti_Salute INT NOT NULL,
    Fase_Evolutiva INT NOT NULL,
    Debolezza VARCHAR(10) NOT NULL,
    Costo_Ritirata INT NOT NULL
);

--sottotipo di Carta
CREATE TABLE Trainer (
    Carta VARCHAR(8) PRIMARY KEY,
    Massimo_Utilizzi INT,
    Sottotipo VARCHAR(15) NOT NULL,
    Durata INT NOT NULL
);

--sottotipo di Carta
CREATE TABLE Energia(
    Carta VARCHAR(8) PRIMARY KEY
    Bersaglio VARCHAR(20) NOT NULL,
    Elemento VARCHAR(10) NOT NULL
)

--legata a Pokemon
CREATE TABLE Abilità (
    Nome_Abilità VARCHAR(20) PRIMARY KEY,
    Descrizione_Effetto TEXT NOT NULL,
    Danni INT,
    Costo_Energia INT,
    Pokemon VARCHAR(15),
    FOREIGN KEY (Pokemon) REFERENCES Pokemon(Carta)
);

--legato a Carta
CREATE TABLE Espansione (
    Codice_Espansione VARCHAR(6),
    Nome_Espansione VARCHAR(20) NOT NULL,
    Data_Rilascio DATE NOT NULL,
    PRIMARY KEY (Codice_Espansione, Nome_Espansione)
);

--legato a Carta
CREATE TABLE Restrizione (
    Nome_Lista VARCHAR(8) PRIMARY KEY,
    Limitazione INT NOT NULL,
    Bannato INT NOT NULL
);

--legato a Utente
CREATE TABLE Ambiente_Gioco (
    Nome_Ambiente VARCHAR(20) PRIMARY KEY,
    Organizzatore VARCHAR(20) NOT NULL
);

--sottotipo di AmbienteGioco
CREATE TABLE Fisico (
    Ambiente VARCHAR(20) PRIMARY KEY,
    Indirizzo_Sede VARCHAR(30) NOT NULL,
    Capienza_Massima INT NOT NULL
);

--sottotipo di AmbienteGioco
CREATE TABLE Digitale (
    Ambiente VARCHAR(20) PRIMARY KEY,
    Indirizzo_IP VARCHAR(15) NOT NULL,
    Regione_Server VARCHAR(20) NOT NULL
);

--legata a Carta, Utente
CREATE TABLE Mazzo (
    Codice_Mazzo VARCHAR(8) PRIMARY KEY,
    Nome_Mazzo VARCHAR(15) NOT NULL,
    Data_Validazione DATE,
    -- Attributo per la ridondanza
    --Leggere un attributo locale a Mazzo costa 1 solo accesso al disco. 
    --Se non ci fosse stato, il database avrebbe dovuto fare una JOIN con PartOf e un SUM(Quantità) ogni singola volta, 
    --effettuando decine di accessi in più per ogni mazzo
    Numero_Carte INT NOT NULL
);

--legato a Utente e Risultato
CREATE TABLE Risultato (
    Utente VARCHAR(20) NOT NULL,
    Partita VARCHAR(8) NOT NULL,
    Punteggio VARCHAR(3) NOT NULL,
    Bonus_Assegnati TEXT,
    Penalità_Assegnate TEXT,
    Utente VARCHAR(20),
    Partita VARCHAR(8),
    PRIMARY KEY (Utente, Partita),
    FOREIGN KEY (Utente) REFERENCES Utente(Nickname),
    FOREIGN KEY (Partita) REFERENCES Partita(Codice_Partita)
);

--legato a Risultato
CREATE TABLE Partita (
    Codice_Partita VARCHAR(8) PRIMARY KEY,
    Ora_Inizio TIMESTAMP,
    Fase_Torneo VARCHAR(10) NOT NULL
);

--relazione N:N Collezione tra Utente e Carta
CREATE TABLE Collezione (
    Utente VARCHAR(20),
    Carta VARCHAR(10),
    Lingua VARCHAR(15) NOT NULL,
    Numero_Copie INT NOT NULL,
    PRIMARY KEY (Utente, Carta),
    FOREIGN KEY (Utente) REFERENCES Utente(Nickname),
    FOREIGN KEY (Carta) REFERENCES Carta(Codice_Carta)
);

--relazione N:N PartOf tra Carta e Mazzo
CREATE TABLE PartOf (
    Carta VARCHAR(10),
    Mazzo VARCHAR(8),
    Quantità INT NOT NULL, -- indica quante carte doppie ci sono in uno stesso mazzo, ad esempio due 'Ricerche accademiche' in uno stesso mazzo
    PRIMARY KEY (Carta, Mazzo),
    FOREIGN KEY (Carta) REFERENCES Carta(Codice_Carta),
    FOREIGN KEY (Mazzo) REFERENCES Mazzo(Codice_Mazzo)
);

--relazione N:N Corrispondenza tra Pokemon e Abilità
CREATE TABLE Corrispondenza (
    Pokemon VARCHAR(15),
    Abilità VARCHAR(20),
    PRIMARY KEY (Pokemon, Abilità)
    FOREIGN KEY (Pokemon) REFERENCES Pokemon(Carta),
    FOREIGN KEY (Abilità) REFERENCES Abilità(Nome_Abilità)
);


-- Query 1: Elenca a che espansione appartengono le carte più giocate
SELECT C.Nome_Carta, E.Nome_Espansione, COUNT(DISTINCT M.Codice_Mazzo) AS Conteggio 
FROM Espansione E 
JOIN Carta C ON E.Codice_Espansione = C.Espansione
JOIN PartOf P ON C.Codice_Carta = P.Carta
JOIN Mazzo M ON P.Mazzo = M.Codice_Mazzo
JOIN Utente U ON U.Mazzo = M.Codice_Mazzo
GROUP BY C.Nome_Carta, E.Nome_Espansione
HAVING COUNT(DISTINCT M.Codice_Mazzo) >= 15
ORDER BY Conteggio DESC;
 

-- Query 2: Quali giocatori hanno disputato più di 5 partite totali in ambienti digitali ottenendo una media di punteggio superiore a 30 punti
-- AVG(CAST(R.Punteggio) AS UNSIGNED) > 30 che veniva consigliato non serve perchè punteggio è 3 o 1 o 0
SELECT U.Nickname, COUNT(R.Risultati) AS Partite_Digitali , AVG(R.Punteggio) > 30 AS Punteggio_Medio
FROM Utente U 
JOIN Digitale D ON U.Ambiente = D.Ambiente
JOIN Risultato R ON R.Utente = U.Nickname
GROUP BY U.Nickname
HAVING COUNT(R.Risultati), AVG(R.Punteggio) > 30;

-- TROPPO SEMPLICE
-- Query 3: Quali mazzi salvati nel database violano la regola del torneo, ovvero contengono un numero di carte totali diverso da 60
SELECT M.Codice_Mazzo, U.Nickname, M.Numero_Carte
FROM Mazzo M JOIN Utente U ON U.Mazzo = M.Codice_Mazzo
WHERE M.Numero_Carte <> 60;
-- Query 3 MODIFICATA: Quali mazzi nel database presentano un'incoerenza tra il valore ridondante 'Numero_Carte' e il conteggio effettivo delle carte fisicamente presenti nella tabella 'PartOf'
SELECT M.Codice_Mazzo, M.Nome_Mazzo, M.Numero_Carte AS Valore_Ridondanza, SUM(P.Quantità) AS Valore_Quantità
FROM Mazzo M JOIN PartOf P ON M.Codice_Mazzo = P.Mazzo
GROUP BY M.Codice_Mazzo, M.Nome_Mazzo, M.Numero_Carte
HAVING M.Numero_Carte <> SUM(P.Quantità);

-- Query 4: Creiamo una vista permanente che calcoli la classifica live del torneo (somma dei punti di ogni giocatore). Dopodiché, interroghiamo la vista per estrarre solo la 'Top 3' dei giocatori del torneo
CREATE VIEW Classifica AS (
    SELECT
);
SELECT 
FROM 
GROUP BY 

-- Query 5: Trova i dettagli di tutti i giocatori (Nome, Cognome, Email) che hanno utilizzato almeno una volta un ambiente di gioco 'Fisico' (ovvero che hanno giocato un match dal vivo, escludendo chi ha giocato solo online)
SELECT 
FROM 
GROUP BY 

-- Query 6: Vogliamo creare una vista che mostri la 'Carta d'Identità' di ogni mazzo (Nome mazzo, autore, numero di carte e quando è stato creato) in modo da non dover rifare la JOIN ogni volta
SELECT 
FROM 
GROUP BY 

-- Indice query
CREATE INDEX idx_ ON y;