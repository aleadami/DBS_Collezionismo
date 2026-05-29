DROP VIEW IF EXISTS Classifica;
DROP INDEX idx_risultato;

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

-- Indice query 4
CREATE INDEX idx_risultato ON Risultato(Utente, Punteggio);