def main():
    df_procurement_monthly = init_procurement_monthly()
    top_supplier = ytoy_ca_fournisseur(df_procurement_monthly)
    
    # Table des 10000 fournisseurs avec la meilleure croissance de CA année après année, avec un minimum de 10000 R$ de CA.
    # On peut ainsi les repérer et les accompagner pour continuer leur croissance
    # Ou bien récupérer leurs bonnes pratiques pour les partager aux autres fournisseurs afin de les aider à se lancer
    turnover_treshhold = 10000
    top_supplier[top_supplier['turnover_previous_year']>turnover_treshhold].sort_values(by=["percent_ytoy_growth"], ascending=[False]).head(100)

    return 0
    
if __name__ == "__main__":
    main()
