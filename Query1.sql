DROP INDEX idx_partof_mazzo;

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

-- Indice query 1
CREATE INDEX idx_partof_mazzo ON PartOf(Mazzo);