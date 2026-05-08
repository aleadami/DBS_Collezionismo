CREATE TABLE Utente (
    Codice VARCHAR(20) PRIMARY KEY,

);

--rappresenta l'oggetto base
CREATE TABLE Oggetto (
    Codice VARCHAR(8),
);

--Serve dividere un oggetto in oggetto fisico e virtuale
CREATE TABLE CopiaPosseduta (

);

--per classificare gli oggetti
CREATE TABLE Categoria (
    Codice VARCHAR(8),
);

--ogni oggetti appartiene ad una collezione
CREATE TABLE Collezioni (
    Codice VARCHAR(8),
);

CREATE TABLE Rarita (
    Codice VARCHAR(8),
);

CREATE TABLE Valutazioni (
    Codice VARCHAR(8),
);

--sistema di scambio tra utenti
CREATE TABLE Scambio (
    Codice VARCHAR(8),
);

--oggetti che vengono scambiati (va messo un attributo: scambiabile?)
CREATE TABLE OggettoScambio (
    Codice VARCHAR(8),
);

--oggetto desiderato dall'utente
CREATE TABLE WishList (
    Codice VARCHAR(8),
);

--oggetti desiderati sono diversi dalla copia posseduta perchè è qualcosa di virtuale
CREATE TABLE WishListItem (
    Codice VARCHAR(8),
);

--reputazione e feedback
CREATE TABLE RecensioneUtente (
    Codice VARCHAR(8),
);

--per un'eventuale compravendita (non la metterei)
marketplace
