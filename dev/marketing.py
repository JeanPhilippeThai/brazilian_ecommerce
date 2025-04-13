import seaborn as sns
import matplotlib.pyplot as plt
from connexion_postgresql import get_df

# DETECTION DES CLIENTS A HAUT POTENTIEL
def init_marketing(file_name):
    # Récupérer les données
    df = get_df(file_name)
    return df

def top_customer_by_sales(df):
    customer_by_sale = df[["dim_customer_id", "dim_customer_state", "fct_payment_value"]].copy()
    customer_by_sale = customer_by_sale.groupby(["dim_customer_id", "dim_customer_state"])["fct_payment_value"].sum().reset_index(name="fct_total_amount_spent")
    customer_by_sale = customer_by_sale.sort_values(by=["dim_customer_state", "fct_total_amount_spent"], ascending=[True, False]) 
    
    customer_by_sale["rank_bystate_bysale"] = (
        customer_by_sale.groupby(["dim_customer_state"])["fct_total_amount_spent"]
        .rank(method="first", ascending=False)
    ).astype(int)
    
    customer_by_sale = customer_by_sale[ customer_by_sale["rank_bystate_bysale"].between(1,10) ]
    return customer_by_sale


# POURQUOI GERER LES BAD REVIEW RAPIDEMENT
def insatisfied_customers(df):
    insatisfied = df[["dim_customer_id", "fct_review_score"]].copy()
    
    # Group by customer to calculate average score and count of reviews
    insatisfied = insatisfied.groupby("dim_customer_id").agg(
        fct_avg_review_score=("fct_review_score", "mean"),
        fct_review_count=("fct_review_score", "count"),
        fct_order_count=("dim_customer_id", "count")
    ).reset_index()
    
    # Sort by lowest average score
    insatisfied = insatisfied.sort_values(by="fct_avg_review_score", ascending=True)
    
    # Take the top 100
    insatisfied = insatisfied.head(100)
    
    insatisfied_result = insatisfied.agg({
        "fct_order_count": "mean",
        "fct_review_count": "mean",
        "fct_avg_review_score": "mean"
    }).to_frame().T
    
    insatisfied_result = insatisfied_result.round(0).astype(int)
    
    insatisfied_result.rename(columns={
        "fct_order_count": "Nombre de commande",
        "fct_review_count": "Nombre de review publiées",
        "fct_avg_review_score": "Moyenne de la note donnée"
    }, inplace=True)

    return insatisfied_result

def plot_insatisfied_customers():
    # Transformation du DataFrame pour seaborn
    data = insatisfied_result.melt(var_name="Metric", value_name="Value")
    
    # Création du graphique
    plt.figure(figsize=(8, 5))
    sns.barplot(data=data, x="Metric", y="Value", palette="Set2")
    
    # Titre
    plt.title("Les clients insatisfaits le font savoir et ne reviennent pas", fontsize=12)
    
    # Affichage des valeurs sur les barres (en entier)
    for i, val in enumerate(data["Value"]):
        plt.text(i, val + val * 0.01, f"{int(val)}", ha='center', va='bottom')
    
    plt.ylabel(None)
    plt.xlabel("")
    plt.yticks(range(0, 6, 1))
    plt.ylim(0, 5)
    plt.tight_layout()
    plt.show()
    return 0
