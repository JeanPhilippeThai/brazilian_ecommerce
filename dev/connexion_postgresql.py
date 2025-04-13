import psycopg2
import pandas as pd
import os

# Informations de connexion
DB_NAME = os.getenv("DB_NAME")
DB_USER = os.getenv("DB_USER")
DB_PASSWORD = os.getenv("DB_PASSWORD")
DB_HOST = os.getenv("DB_HOST")
DB_PORT = os.getenv("DB_PORT")


# Récupère table_name sous forme de dataframe
def get_df(table_name):
    try:
        # Vérification du nom de la table pour éviter l'injection SQL
        if not table_name.isidentifier():
            raise ValueError(f"Nom de table invalide : {table_name}")

        # Connexion à postgres en local
        with psycopg2.connect(
            dbname=DB_NAME,
            user=DB_USER,
            password=DB_PASSWORD,
            host=DB_HOST,
            port=DB_PORT
        ) as conn:

            # Creation du dataframe pandas
            query = f"SELECT * FROM {table_name}"
            df = pd.read_sql(query, conn)
            return df

    except Exception as e:
        print(f"Erreur de récupération de donnée : {e}")
        return None
