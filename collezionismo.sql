--legata a Risultato, Piattaforma, Mazzo, Carta
CREATE TABLE Utente (
    Nickname VARCHAR(10) PRIMARY KEY,
    Email VARCHAR(20),
    Data_Iscrizione DATE,
    FOREIGN KEY (Sede) REFERENCES Sede_Legale(Nome_Piattaforma),
    FOREIGN KEY (Mazzo) REFERENCES Mazzo(Codice_Mazzo)
);

--sottotipo di Utente
--legato a Biglietto
CREATE TABLE Solitario (
    Utente VARCHAR() PRIMARY KEY,
    Nome VARCHAR(),
    Cognome VARCHAR()
    FOREIGN KEY (Biglietto) REFERENCES Biglietto(Codice_Seriale)
);

--sottotipo di Utente
--legato a Organizzazione_Esports
CREATE TABLE Squadra (
    Utente VARCHAR() PRIMARY KEY,
    Tag_Squadra VARCHAR(),
    Numero_Membri VARCHAR()
    FOREIGN KEY (Esports) REFERENCES Organizzazione_Esports(Partita_IVA)
);

--legata a Espansione, Restrizione, Utente, Mazzo
CREATE TABLE Carta (
    Codice_Carta VARCHAR(10) PRIMARY KEY,
    Nome VARCHAR(20),
    Testo_Descrizione TEXT
    FOREIGN KEY (Espansione) REFERENCES Espansione(Codice_Espansione)
    FOREIGN KEY (Restrizione) REFERENCES Restrizione(Nome_Lista)
);

--sottotipo di Carta
--legato a Abilità
CREATE TABLE Pokemon (
    Carta VARCHAR(8) PRIMARY KEY,
    Elemento VARCHAR,
    Punti_Salute INT,
    Fase_Evolutiva VARCHAR,
    Debolezza VARCHAR,
    Costo_Ritirata INT
);

--sottotipo di Carta
--legato a Meccanica Torneo
CREATE TABLE Aiuto (
    Carta VARCHAR(8) PRIMARY KEY,
    Effetto TEXT,
    Sottotipo VARCHAR()
);

--legata a Pokemon
CREATE TABLE Abilità (
    Nome_Abilità VARCHAR(8) PRIMARY KEY,
    Descrizione_Effetto TEXT,
    Condizione VARCHAR
);

--legata a Aiuto
CREATE TABLE Meccanica_Torneo (
    Nome_Meccanica VARCHAR(8) PRIMARY KEY,
    Limite_Nel_Mazzo INT,
    --serve per dire dove va la carta dopo che ha usato quella meccanica
    --Zona_Perduta VARCHAR()
    FOREIGN KEY (Aiuto) REFERENCES Aiuto(Carta)
);

--legato a Carta
CREATE TABLE Espansione (
    Codice_Espansione VARCHAR(6) PRIMARY KEY,
    Nome_Espansione VARCHAR()
);

--legato a Carta
CREATE TABLE Restrizione (
    Nome_Lista VARCHAR(8) PRIMARY KEY,
    Limitazione INT,
    Bannato VARCHAR()
);

--legato a Utente
CREATE TABLE Sede_Torneo (
    Nome_Piattaforma VARCHAR() PRIMARY KEY,
    .
);

--sottotipo di piattaforma
CREATE TABLE Fisica (
    Piattaforma VARCHAR() PRIMARY KEY,
    Indirizzo_Sede VARCHAR(),
    Capienza_Massima INT
);

--sottotipo di piattaforma
CREATE TABLE Digitale (
    Piattaforma VARCHAR PRIMARY KEY,
    Account_Torneo VARCHAR()
);

--legata a Carta, Utente
CREATE TABLE Mazzo (
    Codice_Mazzo VARCHAR(8) PRIMARY KEY,
    Nome_Mazzo VARCHAR(),
    Data_Validazione DATE
);

--legato a Utente e Risultato
CREATE TABLE Risultato (
    Utente VARCHAR(),
    Partita VARCHAR(),
    --ha senso metterlo ma in questo modo non è più un'entità debole
    --Codice_Risultato VARCHAR(),
    Punteggio VARCHAR(3),
    Bonus_Assegnati TEXT,
    Penalità_Assegante TEXT,
    PRIMARY KEY (Utente, Partita, Punteggio)
    FOREIGN KEY (Utente) REFERENCES Utente(Nickname)
);

--legato a Risultato
CREATE TABLE Partita (
    Codice_Partita VARCHAR()
    Ora_Inizio TIMESTAMP,
    Fase_Torneo VARCHAR(),
    FOREIGN KEY (Risultato) REFERENCES Risultato(Codice_Risultato)
);

--legato a Singolo
CREATE TABLE Biglietto (
    Codice_Seriale VARCHAR() PRIMARY KEY,
    Prezzo DECIMAL
);

--legato a Squadra
CREATE TABLE Organizzazione_Esports (
    Partita_IVA VARCHAR() PRIMARY KEY,
    Sede_Legale VARCHAR(),
    Budget_Sponsorizzazione DECIMAL
    FOREIGN KEY (Squadra) REFERENCES Squadra(Nickname)
);