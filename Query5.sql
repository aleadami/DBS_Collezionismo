-- Query 5: Trova i dettagli di tutti i giocatori (Nome, Cognome, Email) che hanno utilizzato almeno una volta un ambiente di gioco 'Fisico' (ovvero che hanno giocato un match dal vivo, escludendo chi ha giocato solo online)
SELECT S.Nome_Reale, S.Cognome_Reale, U.Email
FROM Solitario S JOIN Utente U ON S.Utente = U.Nickname
WHERE U.Nickname IN (
    SELECT R.Utente
    FROM Risultato R
    JOIN Utente U ON R.Utente = U.Nickname
    JOIN Fisico F ON U.Ambiente = F.Ambiente
);