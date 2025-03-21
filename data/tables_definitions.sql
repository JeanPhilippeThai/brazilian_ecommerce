CREATE TABLE dw_customer (
    customer_unique_id TEXT PRIMARY KEY,  -- Identifiant unique du client
    customer_id TEXT,			          -- Chaque commande est liée à un unique customer_id
    customer_zip_code_prefix CHAR(5),     -- ZIP code à 5 chiffres
    customer_city VARCHAR(50),            -- Nom de la ville du client
    customer_state CHAR(2)		          -- Nom de l'Etat du client
);
CREATE TABLE dw_geolocations (
    geolocation_zip_code_prefix CHAR(5),  -- Code postal à 5 caractères
    geolocation_lat DOUBLE PRECISION,     -- Latitude (utilise DOUBLE PRECISION pour plus de précision)
    geolocation_lng DOUBLE PRECISION,     -- Longitude (utilise DOUBLE PRECISION pour plus de précision)
    geolocation_city VARCHAR(255),        -- Ville (chaîne de caractères, longueur 255 si nécessaire)
    geolocation_state CHAR(2)             -- État (code de 2 caractères)
);
CREATE TABLE dw_orders_items (
    order_id TEXT,            -- Identifiant unique de la commande (chaîne alphanumérique)
    order_item_id INTEGER,                -- Identifiant de l'article dans la commande (entier)
    product_id TEXT,                      -- Identifiant du produit (chaîne alphanumérique)
    seller_id TEXT,                       -- Identifiant du vendeur (chaîne alphanumérique)
    shipping_limit_date TIMESTAMP,        -- Date et heure limite d'expédition
    price NUMERIC(10, 2),                 -- Prix de l'article (avec 2 décimales)
    freight_value NUMERIC(10, 2)          -- Valeur du fret (avec 2 décimales)
);
CREATE TABLE dw_orders_payments (
    order_id TEXT,                       -- Identifiant unique de la commande
    payment_sequential INTEGER,          -- Séquence du paiement (entier)
    payment_type TEXT,                   -- Type de paiement (chaîne)
    payment_installments INTEGER,        -- Nombre d'installments (entier)
    payment_value NUMERIC(10, 2)         -- Montant du paiement (décimal avec 2 décimales)
);
CREATE TABLE dw_orders_reviews (
    review_id TEXT PRIMARY KEY,                        -- Identifiant unique de la révision
    order_id TEXT,                                     -- Identifiant de la commande
    review_score INTEGER,                              -- Note de la révision (entier)
    review_comment_title TEXT,                         -- Titre du commentaire de la révision
    review_comment_message TEXT,                       -- Message du commentaire de la révision
    review_creation_date TIMESTAMP,                    -- Date de création de la révision (avec heure)
    review_answer_timestamp TIMESTAMP                  -- Date et heure de la réponse à la révision
);
CREATE TABLE dw_orders (
    order_id TEXT PRIMARY KEY,                         -- Identifiant unique de la commande
    customer_id TEXT,                                  -- Identifiant du client
    order_status TEXT,                                 -- Statut de la commande (chaîne)
    order_purchase_timestamp TIMESTAMP,                -- Horodatage de l'achat
    order_approved_at TIMESTAMP,                       -- Horodatage de l'approbation
    order_delivered_carrier_date TIMESTAMP,            -- Horodatage de la remise au transporteur
    order_delivered_customer_date TIMESTAMP,           -- Horodatage de la livraison au client
    order_estimated_delivery_date TIMESTAMP            -- Date estimée de livraison
);
CREATE TABLE dw_products (
    product_id TEXT PRIMARY KEY,                     -- Identifiant unique du produit
    product_category_name TEXT,                       -- Nom de la catégorie du produit
    product_name_length INTEGER,                      -- Longueur du nom du produit (en caractères)
    product_description_length INTEGER,               -- Longueur de la description du produit (en caractères)
    product_photos_qty INTEGER,                       -- Quantité de photos du produit
    product_weight_g INTEGER,                         -- Poids du produit en grammes
    product_length_cm INTEGER,                        -- Longueur du produit en centimètres
    product_height_cm INTEGER,                        -- Hauteur du produit en centimètres
    product_width_cm INTEGER                          -- Largeur du produit en centimètres
);
CREATE TABLE dw_sellers (
    seller_id TEXT PRIMARY KEY,               -- Identifiant unique du vendeur
    seller_zip_code_prefix TEXT,              -- Code postal du vendeur
    seller_city TEXT,                         -- Ville du vendeur
    seller_state TEXT                         -- État du vendeur
);
CREATE TABLE dw_products_category_name (
    product_category_name TEXT PRIMARY KEY,         -- Nom de la catégorie de produit (en langue d'origine)
    product_category_name_english TEXT              -- Nom de la catégorie de produit en anglais
);


