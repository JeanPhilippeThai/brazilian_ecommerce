# Analyse et recommandation d'axes de développement commercial pour l'entreprise Olist
**Stack:** Python, PostgreSQL, DBT, Tableau, Ubuntu, Github  
**Source de données:** https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce/data

Olist est une “plateforme d'intégration de marketplaces”, c’est-à-dire une plateforme qui aide des fournisseurs à vendre leurs produits sur des grandes marketplaces existantes comme Amazon.  
**Le but est d’analyser et de proposer des axes de croissance à l’entreprise Olist en analysant leurs ventes.**

Le projet est composé d'un ELT principalement géré avec DBT (dossier "dbt_project" dans le repo).  
**Les principales transformation sont dans dbt_project/model/int**
Dans un second temps, l'analyse et la visualisation des données se font sur Tableau, pandas+seaborn, Excel (dossier "dev" dans le repo).

|![data schema](https://github.com/user-attachments/assets/d9587c1c-0e97-4d36-9e25-7746e64fb1e4)|
|:--:|
| *Image 1 - Schéma des données sources* |

## Processus ELT

![schema](https://github.com/user-attachments/assets/df31817a-fbf3-469f-b7df-cdda7b897f90)
|:--:|
| *Image 2 - Schéma ELT* |

L’environnement conda est exécuté sous Ubuntu.  
L’extraction se fait via Python, depuis Kaggle vers la base de donnée locale PostgreSQL.  
Les données sont d’abord matérialisées dans des tables de staging.  
Le nettoyage et la transformation des tables d’origine en data marts se fait sur DBT.  
Les data marts sont renvoyés sous PostgreSQL.  
Les données sont ensuite analysées avec Tableau, pandas+seaborn ou bien Excel.  

## Analyse des résultats concernant les fournisseurs avec Tableau

### Où soutenir et développer l'implémentation de nouveaux fournisseurs?
Le Brésil est composé de plusieurs Etats, comme aux Etats Unis.
Tout d'abord il faut donc se rendre compte de la répartition de la population brésilienne au Brésil afin de la comparer à la répartition des ventes ou des fournisseurs sur le territoire.  

|![map bresil](https://github.com/user-attachments/assets/063551b3-3fb7-4453-91d3-b98e4bfbe94b)|
|:--:|
| *Image 3 - Répartition de la population brésilienne au Brésil (source: Wikipédia)* |

Voici la répartition du CA fournisseur en barre.
![TDB Fournisseur - CA par etat](https://github.com/user-attachments/assets/aa4cdeeb-14e2-4fe9-a17c-292965a4c698)
|:--:|
| *Image 4 - Prédominance de l'Etat Sao Paulo en terme de CA fournisseur* |

Sachant que la région de **Sao Paulo (SP) est la région principale avec 45M d'habitants** cette répartition n'est pas étonnante.  
Juste après, ce sont les régions de Minas Gerais (MG, 21M d'habitants) et Rio de Janeiro (RJ, 17M d'habitants) qui sont les plus peuplées.  
Néanmoins nous voyons déjà que **Paranà (PR)** attire légèrement plus de CA fournisseur que ces deux derniers. 
C'est notamment expliqué par la ville de Curitiba, qui **propose une fiscalité généreuse pour les commerçants**.  
  
![TDB Fournisseur - CA par etat (2)](https://github.com/user-attachments/assets/eb2a1315-fd9f-48e0-9405-0cf782fc46ca)
|:--:|
| *Image 5 - Répartition géographique des commerçant générant un CA supérieur à la moyenne* |

Les fournisseurs principaux se trouvent bien dans les régions à grande population.  
Cependant les deux régions en rouge pâle sont relativement sous-développées en terme de chiffre d'affaires fournisseurs générés comparés à leur population (15M à Bahia BA au nord, et 11M à Rio Grande do Sul RS au sud) 

  ### Quelles sont les tendances côté fournisseur?

![TDB Fournisseur - Moyennes des reviews par etat](https://github.com/user-attachments/assets/0911ea76-e3b7-4eba-8d28-b006abaa99f2)
|:--:|
| *Image 6 - Les notes de retours clients sont majoritairement stables à travers les régions du Brésil* |

![Fournisseur TDB - Moyennes des ventes par etat](https://github.com/user-attachments/assets/b99e959a-ae5d-4eba-b98e-05fd33f3731a)
|:--:|
| *Image 7 - Les Etats les plus consommateurs ont un panier moyen situé entre 100R$ et 200R$ (Equivaut à 1 semaine de courses pour une personne)* |

**Au vu de ce graphique, l'Etat de Bahia (BH) semble d'autant plus intéressante à développer au vu de son prix moyen de vente.**

![Fournisseur TDB - Frais de transports élevés](https://github.com/user-attachments/assets/433b6441-fc66-4241-9dca-8dddf43c7ff9)
|:--:|
| *Image 8 - Les 17 fournisseurs générant le plus de CA affichent des frais de transport très variables* |

### Conclusions concernant les fournisseurs

**Les premières recommandations business concernant les fournisseurs sont donc:**
* **Points à approfondir:**
  * **Etudier pourquoi moins de fournisseurs sont implantés dans les Etats de Bahia (BH) et de Rio Grande do Sul (RS) (rouge pâle)**
  * **Etudier pourquoi l'Etat de Bahia (BH) a un panier moyen élevé**
    * **Si les raisons soulevées sont très propices au business, accentuer l'effort de développement des fournisseurs à Bahia (BH)**
  * **Etudier pourquoi les frais de transports des fournisseurs sont autant disparates**
    * **Si les raisons soulevées sont améliorables à travers de bonnes pratiques, lister ces bonnes pratiques et inciter les fournisseurs à les mettre en place**
* **Dans tous les cas, pour générer plus de CA et peut-être stabiliser les frais de transports disparates:**
  * **Consolider l'implantation fournisseurs dans les régions déjà développés (rouge vif) car la demande du marché est réelle**
  * **Développer l'implantation fournisseurs à Bahia (BH) et Rio Grande do Sul (RS)**

## Analyse des résultats concernant les clients finaux avec Tableau

### Où sont les clients finaux?

La répartition du CA client par région (d'où vient l'argent) est légèrement différente du CA fournisseur (où va l'argent)

![commande par region](https://github.com/user-attachments/assets/f39c2a92-bcbf-4354-9774-30174f08b9f5)
|:--:|
| *Image 9 - Prédominance de l'Etat Sao Paulo en terme de CA client* |

Avec la couleur rouge du CA fournisseurs vu précédemment cela donne:

![commande par region couleur fournisseur](https://github.com/user-attachments/assets/08b4adaf-2cd5-467b-bacd-887f4aba8989)
|:--:|
| *Image 9 - Les clients de Rio Grande do Sul consomment autant que ceux de Paranà (PR) avec un vivier de fournisseurs locaux "à développer"* |

![commande par region map](https://github.com/user-attachments/assets/b984add2-14da-4b0d-82ad-d51eb26fae73)
|:--:|
| *Image 10 - Répartition géographique du CA client* |

 **L'Etat de Rio Grande do Sul RS (RS) au sud est effectivement un hub de clients.**  
 **Le manque de fournisseurs implantés ici est donc d'autant plus une opportunité business.**  

L'Etat de Bahia (BH) est encore mis en avant, ce qui confirme le potentiel de cette région.

### Quels sont les catégories de produits d'appels et ceux qui génèrent le plus de CA?

![categorie nb commandes](https://github.com/user-attachments/assets/7ab414e6-38cf-4086-b84b-63a92188126a)
|:--:|
| *Image 11 - Catégories de produits d'appel par ordre de nombre de commande* |

![categorie CA](https://github.com/user-attachments/assets/717cebf4-1461-4846-a570-de7a42c40d74)
|:--:|
| *Image 12 - Catégories de produits générant le plus de CA* |

### Conclusions concernant les clients

**Les recommandations business concernant les clients finaux sont donc:**
* **Développer l'implantation fournisseurs à Bahia (BH) et Rio Grande do Sul (RS) (idem qu'à la première conclusion)**
* **Partager aux fournisseurs la liste des catégories de produits d'appels et la liste des catégories qui génèrent le plus de CA**
* **afin d'encourager les fournisseurs à proposer ces produits** 

## Analyses complémentaires avec pandas et seaborn

### Marketing
Le code correspondant est dans dev/marketing.py.  

**Au Brésil, une note inférieure à 4 donnée à une commande reçue signifie que le client n'a presque aucune chance de revenir passer commande.**

![clients insatisfaits](https://github.com/user-attachments/assets/b3313f92-c2d6-4edf-be8f-25fa3c2a1ec0)
|:--:|
| *Image 13 - Les mauvais retours clients doivent être adressés rapidement* |

D'autres requêtes pandas peuvent également fournir à l'équipe marketing une liste de clients "à haut potentiel" pour chaque Etat.

![top client par etat](https://github.com/user-attachments/assets/b599e2d0-1c45-4a24-aca0-eb79d0ef214b)
|:--:|
| *Image 14 - Top 10 des clients par CA par Etat* |

### Fournisseur
Le code correspondant est dans dev/procurement_monthly.py

Idem pour des fournisseurs "à haut potentiel" qui ont fait une croissance remarquable et qu'il serait intéressant de soutenir.

![top fournisseur a potentiel](https://github.com/user-attachments/assets/286b6d53-b08f-4cc8-9a52-f06661e8336d)
|:--:|
| *Image 15 - Top 10 des fournisseurs avec la meilleure croissance entre 2017 et 2018* |

## Conclusion globale:

**L'agrégation des recommandations business est donc:**

* **Points à approfondir:**
  * **Etudier pourquoi moins de fournisseurs sont implantés dans les Etats de Bahia (BH) et de Rio Grande do Sul (RS) (rouge pâle)**
  * **Etudier pourquoi l'Etat de Bahia (BH) a un panier moyen élevé**
    * **Si les raisons soulevées sont très propices au business, accentuer l'effort de développement des fournisseurs à Bahia (BH)**
  * **Etudier pourquoi les frais de transports des fournisseurs sont aussi disparates**
    * **Si les raisons soulevées sont améliorables à travers de bonnes pratiques, lister ces bonnes pratiques et inciter les fournisseurs à les mettre en place**

* **Dans tous les cas, pour générer plus de CA et peut être stabiliser les frais de transports disparates:**
  * **Consolider l'implantation fournisseurs dans les régions déjà développées (rouge vif) car la demande du marché est réelle**
  * **Développer l'implantation fournisseurs à Bahia (BH) et Rio Grande do Sul (RS)**
  * **Sensibiliser les fournisseurs à la gestion des retours négatifs**

