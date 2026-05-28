-- Query 2: Quali giocatori hanno disputato più di 5 partite totali in ambienti digitali ottenendo una media di punteggio superiore a 30 punti
SELECT U.Nickname, COUNT(R.Partita) AS Partite_Digitali , AVG(R.Punteggio) AS Punteggio_Medio
FROM Utente U 
JOIN Digitale D ON U.Ambiente = D.Ambiente
JOIN Risultato R ON R.Utente = U.Nickname
GROUP BY U.Nickname
HAVING COUNT(R.Partita) > 5 AND AVG(R.Punteggio) > 2.0
ORDER BY Punteggio_Medio DESC;

-- Indice query 2
CREATE INDEX idx_risultato ON Risultato(Utente, Punteggio);