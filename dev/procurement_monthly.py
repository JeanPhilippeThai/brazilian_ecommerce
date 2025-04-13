import pandas as pd
from connexion_postgresql import get_df

# RECUPERATION DES DONNEES DU FICHIER
def init_procurement_monthly(file_name):
    # Récupérer les données  
    columns_names = ["dim_seller_id", "dim_seller_state", "dim_seller_city", "dim_seller_zip_code_prefix",\
                     "year_shipping_date", "month_shipping_date", "cnt_orders", "sum_price", "avg_price",\
                     "sum_freight_value", "avg_freight_value", "prct_delivery_on_time", "avg_review_score"]
    df = pd.read_csv(file_name, names = columns_names, header=None)
    
    # Garder seulement les colonnes qui nous intéressent
    df_copy = df[["dim_seller_id", "dim_seller_state", "year_shipping_date", "month_shipping_date", "sum_price", "sum_freight_value", "prct_delivery_on_time", "avg_review_score"]].copy()
    
    df_copy = df_copy[(df_copy["year_shipping_date"] >=2016) & (df_copy["year_shipping_date"] <=2018)]
    return df_copy


## EVOLUTION YtoY du CA fournisseur
def ytoy_ca_fournisseur(df_copy):
    # Calcul du CA de chaque fournisseur, chaque année
    ytoy_turnover = df_copy.groupby(["dim_seller_id", "year_shipping_date"])["sum_price"].sum().reset_index()

    # Jointure previous year / current year pour pouvoir les comparer
    ytoy_turnover['previous_year'] = ytoy_turnover['year_shipping_date'] - 1
    ytoy_turnover = ytoy_turnover.merge(
        ytoy_turnover, left_on=["dim_seller_id", "previous_year"],
        right_on=["dim_seller_id", "year_shipping_date"], how="inner"
    )
    ytoy_turnover = ytoy_turnover[["dim_seller_id", "year_shipping_date_x", "sum_price_x",
                                   "previous_year_x", "sum_price_y"]] # garder seulement les bonnes colonnes
    ytoy_turnover.rename(
        columns={"dim_seller_id_x":"dim_seller_id", "year_shipping_date_x":"current_year", 
                 "sum_price_x":"turnover_current_year", "previous_year_x":"previous_year", 
                 "sum_price_y":"turnover_previous_year"},
        inplace=True
    )
    
    # Calcul du YtoY growth en pourcentage
    ytoy_turnover["percent_ytoy_growth"] = (100*ytoy_turnover["turnover_current_year"] / ytoy_turnover["turnover_previous_year"])
    
    # Gestion des erreurs
    ytoy_turnover["percent_ytoy_growth"] = ytoy_turnover["percent_ytoy_growth"].replace([float('inf'), -float('inf')], 0)
    ytoy_turnover["percent_ytoy_growth"] = ytoy_turnover["percent_ytoy_growth"].fillna(0)
    ytoy_turnover["turnover_current_year"] = ytoy_turnover["turnover_current_year"].replace([float('inf'), -float('inf')], 0)
    ytoy_turnover["turnover_current_year"] = ytoy_turnover["turnover_current_year"].fillna(0)
    ytoy_turnover["turnover_previous_year"] = ytoy_turnover["turnover_previous_year"].replace([float('inf'), -float('inf')], 0)
    ytoy_turnover["turnover_previous_year"] = ytoy_turnover["turnover_previous_year"].fillna(0)
    
    # Pour la clarté de lecture
    ytoy_turnover["percent_ytoy_growth"] = ytoy_turnover["percent_ytoy_growth"].astype(int)
    ytoy_turnover["turnover_current_year"] = ytoy_turnover["turnover_current_year"].astype(int)
    ytoy_turnover["turnover_previous_year"] = ytoy_turnover["turnover_previous_year"].astype(int)
    ytoy_turnover["current_year"] = ytoy_turnover["current_year"].astype(int)
    
    ytoy_turnover = ytoy_turnover[["dim_seller_id", "current_year", "turnover_current_year", "turnover_previous_year", "percent_ytoy_growth"]]
    
    top_supplier = ytoy_turnover.sort_values(by=["turnover_current_year"], ascending=[False])
    top_supplier = top_supplier.head(int(top_supplier.shape[0]*0.2))

    # Ajout du % de livraison à temps et la moyenne des reviews reçues chaque année par chaque fournisseur
    temp = df_copy.groupby(["dim_seller_id", "year_shipping_date"])[["prct_delivery_on_time", "avg_review_score"]].mean().reset_index()
    temp["prct_delivery_on_time"] = temp["prct_delivery_on_time"].round(2)
    temp["avg_review_score"] = temp["avg_review_score"].round(2)
    temp = temp.rename(columns={"prct_delivery_on_time":"percent_delivery_on_time"})

    # Résultat final avec toutes les métriques
    top_supplier = top_supplier.merge(temp, left_on=["dim_seller_id", "current_year"], right_on=["dim_seller_id", "year_shipping_date"], how="inner")
    top_supplier = top_supplier[["dim_seller_id", "current_year", "turnover_current_year",
                                 "turnover_previous_year", "percent_ytoy_growth", "percent_delivery_on_time",
                                 "avg_review_score"]]
    return top_supplier
