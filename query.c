#include <stdio.h>
#include <stdlib.h>
#include "path/to/libpq-fe.h"

void do_exit(PGconn *conn) {

    PQfinish(conn);
    exit(1);

}

int main() {

    // Connessione al database
    PGconn *conn = PQconnectdb("dbname=testdb");

    // Controllo che la connessione sia andata a buon fine
    if(PQstatus(conn) == CONNECTION_BAD) {
        fprintf(stderr, "Connessione al database fallita: %s", PQerrorMessage(conn));
        do_exit(conn);
    }

    // =================================================================================
    // ESECUZIONE QUERY 1
    // =================================================================================

    // Preparazione della stringa SQL 
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

    for(int i=0; i<numAttributi;i++) {
        printf("%-25s", PQfname(res, i));
    }
    printf("\n------------------------------------------------------------------\n");

    // Ciclo doppio per stampare i dati riga per riga, colonna per colonna
    for(int i=0; i<numTuples; i++) {
        for(int j=0; j<numAttributi; j++) {
            printf("%-25s", PQgetvalue(res, i, j));
        }
        printf("\n"); // A capo alla fine di ogni riga
    }
    printf("------------------------------------------------------------------\n");

    //Pulizia memoria e chiusura connessione
    PQclear(res);

    // =================================================================================
    // ESECUZIONE QUERY 2
    // =================================================================================

    // Sovrascrivo la variabile della query
    query = "SELECT U.Nickname, COUNT(R.Partita) AS Partite_Digitali, AVG(R.Punteggio) AS Punteggio_Medio "
        "FROM Utente U "
        "JOIN Digitale D ON U.Ambiente = D.Ambiente "
        "JOIN Risultato R ON R.Utente = U.Nickname "
        "GROUP BY U.Nickname "
        "HAVING COUNT(R.Partita) > 5 AND AVG(R.Punteggio) > 2.0;";

    //Esecuzione della Query    
    res = PQexec(conn, query);

    if(PQresultStatus(res) != PGRES_TUPLES_OK) {
        fprintf(stderr, "Non è stato restituito un risultato per la Query 2 per via del seguente errore: %s", PQerrorMessage(conn));
        PQclear(res);
        do_exit(conn);
    }

    numTuples = PQntuples(res);
    numAttributi = PQnfields(res);

    printf("\nRisultati della Query 2:\n");
    printf("------------------------------------------------------------------\n");
    
    for(int i=0; i<numAttributi; i++) {
        printf("%-25s", PQfname(res, i));
    }
    printf("\n------------------------------------------------------------------\n");

    for(int i=0; i<numTuples; i++) {
        for(int j=0;j<numAttributi;j++) {
            printf("%-25s", PQgetvalue(res, i, j));
        }
        printf("\n");
    }
    printf("------------------------------------------------------------------\n");

    PQclear(res);


    PQfinish(conn);

    return 0;
}