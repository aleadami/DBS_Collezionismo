--legata a Risultato, Piattaforma, Mazzo, Carta
CREATE TABLE Utente (
    Nickname VARCHAR(10) PRIMARY KEY,
    Email VARCHAR(20),
    Data_Iscrizione DATE,
    FOREIGN KEY (Ambiente) REFERENCES Ambiente_Gioco(Nome_Ambiente),
    FOREIGN KEY (Mazzo) REFERENCES Mazzo(Codice_Mazzo)
);

--sottotipo di Utente
--legato a Biglietto
CREATE TABLE Solitario (
    Utente VARCHAR() PRIMARY KEY,
    Nome_Reale VARCHAR(),
    Cognome_Reale VARCHAR(),
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

--legata a Espansione, Restrizione, Utente, Mazzo
CREATE TABLE Carta (
    Codice_Carta VARCHAR(10) PRIMARY KEY,
    Nome VARCHAR(20),
    Testo_Descrizione TEXT,
    Effetto TEXT,
    FOREIGN KEY (Espansione) REFERENCES Espansione(Codice_Espansione),
    FOREIGN KEY (Restrizione) REFERENCES Restrizione(Nome_Lista)
);

--sottotipo di Carta
--legato a Abilità
CREATE TABLE Pokemon (
    Carta VARCHAR(8) PRIMARY KEY,
    Elemento_Pokemon VARCHAR,
    Punti_Salute INT,
    Fase_Evolutiva VARCHAR,
    Debolezza VARCHAR,
    Costo_Ritirata INT
);

--sottotipo di Carta
CREATE TABLE Trainer (
    Carta VARCHAR(8) PRIMARY KEY,
    Massimo_Utilizzi TEXT,
    Sottotipo VARCHAR(),
    Durata INT
);

--sottotipo di Carta
CREATE TABLE Energia(
    Carta VARCHAR(8) PRIMARY KEY
    Bersaglio VARCHAR(),
    Elemento VARCHAR()
)

--legata a Pokemon
CREATE TABLE Abilità (
    Nome_Abilità VARCHAR(8) PRIMARY KEY,
    Descrizione_Effetto TEXT,
    Danni INT,
    Costo_Energia INT
);

--legato a Carta
CREATE TABLE Espansione (
    Codice_Espansione VARCHAR(6) PRIMARY KEY,
    Nome_Espansione VARCHAR(),
    Data_Rilascio DATE
);

--legato a Carta
CREATE TABLE Restrizione (
    Nome_Lista VARCHAR(8) PRIMARY KEY,
    Limitazione INT,
    Bannato VARCHAR()
);

--legato a Utente
CREATE TABLE Ambiente_Gioco (
    Nome_Ambiente VARCHAR() PRIMARY KEY,
    Organizzatore VARCHAR()
);

--sottotipo di AmbienteGioco
CREATE TABLE Fisico (
    Ambiente VARCHAR() PRIMARY KEY,
    Indirizzo_Sede VARCHAR(),
    Capienza_Massima INT
);

--sottotipo di AmbienteGioco
CREATE TABLE Digitale (
    Ambiente VARCHAR PRIMARY KEY,
    Indirizzo_IP VARCHAR(),
    Regione_Server VARCHAR()
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
    Punteggio VARCHAR(3),
    Bonus_Assegnati TEXT,
    Penalità_Assegante TEXT,
    PRIMARY KEY (Utente, Partita)
    FOREIGN KEY (Utente) REFERENCES Utente(Nickname)
    FOREIGN KEY (Utente) REFERENCES Utente(Nickname)
);

--legato a Risultato
CREATE TABLE Partita (
    Codice_Partita VARCHAR() PRIMARY KEY,
    Ora_Inizio TIMESTAMP,
    Fase_Torneo VARCHAR(),
    FOREIGN KEY (Risultato) REFERENCES Risultato(Codice_Risultato)
);