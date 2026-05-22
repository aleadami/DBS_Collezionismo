--legata a Risultato, Piattaforma, Mazzo, Carta
CREATE TABLE Utente (
    Nickname VARCHAR(20) PRIMARY KEY,
    Email VARCHAR(20) NOT NULL,
    Data_Iscrizione DATE NOT NULL,
    FOREIGN KEY (Ambiente) REFERENCES Ambiente_Gioco(Nome_Ambiente),
    FOREIGN KEY (Mazzo) REFERENCES Mazzo(Codice_Mazzo)
);

--sottotipo di Utente
--legato a Biglietto
CREATE TABLE Solitario (
    Utente VARCHAR(20) PRIMARY KEY,
    Nome_Reale VARCHAR(20) NOT NULL,
    Cognome_Reale VARCHAR(10) NOT NULL,
    FOREIGN KEY (Biglietto) REFERENCES Biglietto(Codice_Seriale)
);

--sottotipo di Utente
--legato a Organizzazione_Esports
CREATE TABLE Squadra (
    Utente VARCHAR(20) PRIMARY KEY,
    Tag_Squadra VARCHAR(3) NOT NULL,
    Numero_Membri INT
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
    Budget_Sponsorizzazione DECIMAL NOT NULL
    FOREIGN KEY (Squadra) REFERENCES Squadra(Nickname)
);

--legata a Espansione, Restrizione, Utente, Mazzo
CREATE TABLE Carta (
    Codice_Carta VARCHAR(10) PRIMARY KEY,
    Nome VARCHAR(20) NOT NULL,
    Testo_Descrizione TEXT NOT NULL,
    Effetto TEXT,
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
    Nome_Abilità VARCHAR(8) PRIMARY KEY,
    Descrizione_Effetto TEXT NOT NULL,
    Danni INT,
    Costo_Energia INT
);

--legato a Carta
CREATE TABLE Espansione (
    Codice_Espansione VARCHAR(6) PRIMARY KEY,
    Nome_Espansione VARCHAR(20) NOT NULL,
    Data_Rilascio DATE NOT NULL
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
    Ambiente VARCHAR PRIMARY KEY,
    Indirizzo_IP VARCHAR(15) NOT NULL,
    Regione_Server VARCHAR(20) NOT NULL
);

--legata a Carta, Utente
CREATE TABLE Mazzo (
    Codice_Mazzo VARCHAR(8) PRIMARY KEY,
    Nome_Mazzo VARCHAR(15) NOT NULL,
    Data_Validazione DATE
);

--legato a Utente e Risultato
CREATE TABLE Risultato (
    Utente VARCHAR(20) NOT NULL,
    Partita VARCHAR(8) NOT NULL,
    Punteggio VARCHAR(3) NOT NULL,
    Bonus_Assegnati TEXT,
    Penalità_Assegnate TEXT,
    PRIMARY KEY (Utente, Partita)
    FOREIGN KEY (Utente) REFERENCES Utente(Nickname)
    FOREIGN KEY (Partita) REFERENCES Partita(Codice_Partita)
);

--legato a Risultato
CREATE TABLE Partita (
    Codice_Partita VARCHAR(8) PRIMARY KEY,
    Ora_Inizio TIMESTAMP,
    Fase_Torneo VARCHAR(10) NOT NULL,
    FOREIGN KEY (Risultato) REFERENCES Risultato(Codice_Risultato)
);