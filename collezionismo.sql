CREATE TABLE Utente (
    Codice VARCHAR(20) PRIMARY KEY,
);

--Serve dividere un oggetto in oggetto fisico e virtuale
CREATE TABLE CopiaPosseduta (
    VARCHAR() PRIMARY KEY,
);

--rappresenta l'oggetto base
CREATE TABLE OggettoCollezione (
    Codice VARCHAR(8) PRIMARY KEY,
);

--ogni oggetti appartiene ad una collezione
CREATE TABLE Collezione (
    Codice VARCHAR(8) PRIMARY KEY,
);

--sistema di scambio tra utenti
CREATE TABLE Scambio (
    Codice VARCHAR(8) PRIMARY KEY,
);

--oggetti che vengono scambiati (va messo un attributo: scambiabile?)
CREATE TABLE ScambioItem (
    Codice VARCHAR(8) PRIMARY KEY,
);

--oggetto desiderato dall'utente
CREATE TABLE WishList (
    Codice VARCHAR(8) PRIMARY KEY,
);

--oggetti desiderati sono diversi dalla copia posseduta perchè è qualcosa di virtuale
CREATE TABLE WishListItem (
    Codice VARCHAR(8) PRIMARY KEY,
);

--emilinabile?
--reputazione e feedback
CREATE TABLE Recensione (
    Codice VARCHAR(8) PRIMARY KEY,
);


--ELIMINABILE
--per un'eventuale vendita al posto dello scambio
CREATE TABLE marketplace (
);
--ELIMINABILE
--per classificare gli oggetti
CREATE TABLE Categoria (
);