#include <stdio.h>
#include <stdlib.h>
#include <libpq-fe.h>

void do_exit(PGconn *conn) {

    PQfinish(conn);
    exit(1);

}

int main() {

    // Connessione al database
    PGconn *conn = PQconnectdb("dbname=postgres");

    // Controllo che la connessione sia andata a buon fine
    if(PQstatus(conn) == CONNECTION_BAD) {
        fprintf(stderr, "Connessione al database fallita: %s", PQerrorMessage(conn));
        do_exit(conn);
    }

    // =================================================================================
    // ESECUZIONE QUERY 1
    // =================================================================================

    // Preparazione della stringa per la Query SQL 
    const char *query =
        "SELECT C.Nome_Carta, E.Nome_Espansione, COUNT(DISTINCT M.Codice_Mazzo) AS Conteggio "
        "FROM Espansione E "
        "JOIN Carta C ON E.Codice_Espansione = C.Codice_Espansione AND E.Nome_Espansione = C.Nome_Espansione "
        "JOIN PartOf P ON C.Codice_Carta = P.Carta "
        "JOIN Mazzo M ON P.Mazzo = M.Codice_Mazzo "
        "JOIN Utente U ON U.Mazzo = M.Codice_Mazzo "
        "GROUP BY C.Nome_Carta, E.Nome_Espansione "
        "HAVING COUNT(DISTINCT M.Codice_Mazzo) >= 3 "
        "ORDER BY Conteggio DESC;";

    // Esecuzione della Query    
    PGresult *res = PQexec(conn, query);

    if(PQresultStatus(res) != PGRES_TUPLES_OK) {
        fprintf(stderr, "Non è stato restituito un risultato per la Query 1 per via del seguente errore: %s", PQerrorMessage(conn));
        PQclear(res);
        do_exit(conn);
    }

    int numTuples = PQntuples(res);
    int numAttributi = PQnfields(res);

    printf("\nRisultati della Query 1:\n");
    printf("------------------------------------------------------------------\n");

    for(int i = 0; i < numAttributi; i++) {
        printf("%-25s", PQfname(res, i));
    }

    printf("\n------------------------------------------------------------------\n");

    // Ciclo doppio per stampare i dati riga per riga, colonna per colonna
    for(int i = 0; i < numTuples; i++) {
        for(int j = 0; j < numAttributi; j++) {
            printf("%-25s", PQgetvalue(res, i, j));
        }
        printf("\n"); // A capo alla fine di ogni riga
    }

    printf("------------------------------------------------------------------\n");

    //Pulizia memoria e chiusura connessione
    PQclear(res);

    // =================================================================================
    // ESECUZIONE QUERY 2 (PARAMETRICA)
    // =================================================================================

    printf("\n==================================================================\n");
    printf(" IMPOSTAZIONE PARAMETRI - QUERY 2 \n");
    printf("==================================================================\n");
    
    // Variabili per raccogliere l'input
    char minPartite[10];
    char minPunteggio[10];

    printf("Inserisci il numero minimo di partite digitali (es. 5): ");
    scanf("%9s", minPartite);
    
    printf("Inserisci il punteggio medio minimo (es. 2.0): ");
    scanf("%9s", minPunteggio);

    // Array di puntatori che conterrà i parametri
    const char *paramValues[2];
    paramValues[0] = minPartite;
    paramValues[1] = minPunteggio;

    // Query parametrica utilizzando $1 e $2
    query = "SELECT U.Nickname, COUNT(R.Partita) AS Partite_Digitali, AVG(R.Punteggio) AS Punteggio_Medio "
            "FROM Utente U "
            "JOIN Digitale D ON U.Ambiente = D.Ambiente "
            "JOIN Risultato R ON R.Utente = U.Nickname "
            "GROUP BY U.Nickname "
            "HAVING COUNT(R.Partita) > $1 AND AVG(R.Punteggio) > $2 "
            "ORDER BY Punteggio_Medio DESC;";

    // Esecuzione della Query con i parametri
    res = PQexecParams(conn, query, 2, NULL, paramValues, NULL, NULL, 0);

    if(PQresultStatus(res) != PGRES_TUPLES_OK) {
        fprintf(stderr, "Non è stato restituito un risultato per la Query 2 per via del seguente errore: %s\n", PQerrorMessage(conn));
        PQclear(res);
        do_exit(conn);
    }

    numTuples = PQntuples(res);
    numAttributi = PQnfields(res);

    // Stampa dei parametri
    printf("\nRisultati della Query 2 (Partite > %s, Media > %s):\n", minPartite, minPunteggio);
    printf("------------------------------------------------------------------\n");
    
    for(int i = 0; i < numAttributi; i++) {
        printf("%-25s", PQfname(res, i));
    }

    printf("\n------------------------------------------------------------------\n");

    for(int i = 0; i < numTuples; i++) {
        for(int j = 0; j < numAttributi; j++) {
            printf("%-25s", PQgetvalue(res, i, j));
        }
        printf("\n");
    }

    printf("------------------------------------------------------------------\n");

    PQclear(res);

    // =================================================================================
    // ESECUZIONE QUERY 3
    // =================================================================================

    // Sovrascrivo la variabile della Query
    query = "SELECT M.Codice_Mazzo, M.Nome_Mazzo, M.Numero_Carte AS Valore_Ridondanza, SUM(P.Quantità) AS Valore_Quantità "
    "FROM Mazzo M "
    "JOIN PartOf P ON M.Codice_Mazzo = P.Mazzo "
    "GROUP BY M.Codice_Mazzo, M.Nome_Mazzo, M.Numero_Carte "
    "HAVING M.Numero_Carte <> SUM(P.Quantità);";

    //Esecuzione della Query    
    res = PQexec(conn, query);

    if(PQresultStatus(res) != PGRES_TUPLES_OK) {
        fprintf(stderr, "Non è stato restituito un risultato per la Query 3 per via del seguente errore: %s", PQerrorMessage(conn));
        PQclear(res);
        do_exit(conn);
    }

    numTuples = PQntuples(res);
    numAttributi = PQnfields(res);

    printf("\nRisultati della Query 3:\n");
    printf("------------------------------------------------------------------\n");

    for(int i = 0; i < numAttributi; i++) {
        printf("%-25s", PQfname(res, i));
    }

    printf("\n------------------------------------------------------------------\n");

    for(int i = 0; i < numTuples; i++) {
        for(int j = 0; j < numAttributi; j++) {
            printf("%-25s", PQgetvalue(res, i, j));
        }
        printf("\n");
    }

    printf("------------------------------------------------------------------\n");

    PQclear(res);

    // =================================================================================
    // ESECUZIONE QUERY 4
    // =================================================================================

    // Sovrascrivo la variabile della Query. Uso CREATE OR REPLACE VIEW per evitare crash se il programma viene avviato più volte
    query = "CREATE OR REPLACE VIEW Classifica AS ("
    "   SELECT Utente, SUM(Punteggio) AS Punti_Totali, COUNT(Partita) AS Partite_Giocate "
    "   FROM Risultato "
    "   GROUP BY Utente"
    "); "
    "SELECT Utente, Punti_Totali "
    "FROM Classifica "
    "ORDER BY Punti_Totali DESC "
    "LIMIT 3;";

    //Esecuzione della Query    
    res = PQexec(conn, query);

    if(PQresultStatus(res) != PGRES_TUPLES_OK) {
        fprintf(stderr, "Non è stato restituito un risultato per la Query 4 per via del seguente errore: %s", PQerrorMessage(conn));
        PQclear(res);
        do_exit(conn);
    }

    numTuples = PQntuples(res);
    numAttributi = PQnfields(res);

    printf("\nRisultati della Query 4:\n");
    printf("------------------------------------------------------------------\n");

    for(int i = 0; i < numAttributi; i++) {
        printf("%-25s", PQfname(res, i));
    }

    printf("\n------------------------------------------------------------------\n");

    for(int i = 0; i < numTuples; i++) {
        for(int j = 0; j < numAttributi; j++) {
            printf("%-25s", PQgetvalue(res, i, j));
        }
        printf("\n");
    }

    printf("------------------------------------------------------------------\n");

    PQclear(res);
    
    // =================================================================================
    // ESECUZIONE QUERY 5
    // =================================================================================

    // Sovrascrivo la variabile della Query
    query = "SELECT S.Nome_Reale, S.Cognome_Reale, U.Email "
    "FROM Solitario S JOIN Utente U ON S.Utente = U.Nickname "
    "WHERE U.Nickname IN ( "
    "   SELECT R.Utente "
    "   FROM Risultato R "
    "   JOIN Utente U ON R.Utente = U.Nickname "
    "   JOIN Fisico F ON U.Ambiente = F.Ambiente "
    ");";

    res = PQexec(conn, query);

    if(PQresultStatus(res) != PGRES_TUPLES_OK) {
        fprintf(stderr, "Non è stato restituito un risultato per la Query 5 per via del seguente errore: %s", PQerrorMessage(conn));
        PQclear(res);
        do_exit(conn);
    }

    numTuples = PQntuples(res);
    numAttributi = PQnfields(res);

    printf("\nRisultati della Query 5:\n");
    printf("------------------------------------------------------------------\n");

    for(int i = 0; i < numAttributi; i++) {
        printf("%-25s", PQfname(res, i));
    }

    printf("\n------------------------------------------------------------------\n");

    for(int i = 0; i < numTuples; i++) {
        for(int j = 0; j < numAttributi; j++) {
            printf("%-25s", PQgetvalue(res, i, j));
        }
        printf("\n");
    }

    printf("------------------------------------------------------------------\n");

    PQclear(res);

    PQfinish(conn);

    return 0;

}