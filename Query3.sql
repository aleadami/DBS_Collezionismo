-- Query 3: Quali mazzi nel database presentano un'incoerenza tra il valore ridondante 'Numero_Carte' e il conteggio effettivo delle carte fisicamente presenti nella tabella 'PartOf'
SELECT M.Codice_Mazzo, M.Nome_Mazzo, M.Numero_Carte AS Valore_Atteso, SUM(P.Quantità) AS Valore_Quantità
FROM Mazzo M JOIN PartOf P ON M.Codice_Mazzo = P.Mazzo
GROUP BY M.Codice_Mazzo, M.Nome_Mazzo, M.Numero_Carte
HAVING M.Numero_Carte <> SUM(P.Quantità);

-- Indice query 3
CREATE INDEX idx_partof_mazzo ON PartOf(Mazzo);