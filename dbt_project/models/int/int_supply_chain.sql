-- Pour répondre à: QUELS SONT LES DELAIS DE LIVRAISONS ENTRE?

-- Cette vue contient toutes les paires (order_id, customer_id) 
-- ainsi que toutes les informations temporelles et spatiales de la commande

-- Elle permet d'étudier le temps que chaque étape de la supply chain prend
-- en fonction du temps et de l'espace.


-- Calcul du nombre de jour écoulé entre chaque étape de la supply chain et la date du passage de la commande par le client
with daydiff as(
	select
		wo.dim_order_id,
		wo.dim_customer_id as dim_customer_unique_id,
		wc.dim_customer_zip_code_prefix,
		wo.fct_order_purchase_timestamp,
		extract(day from (wo.fct_order_approved_at - wo.fct_order_purchase_timestamp)) as order_approved_day_since_purchase,
		extract(day from (wo.fct_order_estimated_delivery_date - wo.fct_order_purchase_timestamp)) as estimated_delivery_day_since_purchase,
		extract(day from (wo.fct_order_delivered_carrier_date - wo.fct_order_purchase_timestamp)) as delivered_carrier_day_since_purchase,
		extract(day from (wo.fct_order_delivered_customer_date - wo.fct_order_purchase_timestamp)) as delivered_customer_since_purchase
	from wh_orders wo
	join wh_customers wc
		on wo.dim_customer_id = wc.dim_customer_unique_id 
	where
		wo.fct_order_approved_at is not null
		and wo.fct_order_delivered_carrier_date is not null
		and wo.fct_order_delivered_customer_date is not null
		and wo.fct_order_estimated_delivery_date is not null
		and wo.fct_order_purchase_timestamp is not null
		and wo.fct_order_status = 'delivered'
),
-- Récupération des zip code uniques
unique_zip_code as(
	select
		dim_geolocation_zip_code_prefix,
		dim_geolocation_state,
		dim_geolocation_city
	from wh_geolocations
	group by dim_geolocation_zip_code_prefix, dim_geolocation_state, dim_geolocation_city
	having count(*) = 1
),
-- Enrichissement avec la ville et l'Etat dans lesquels la livraison est livrée
daydiff_location as(
	select
		dd.*,
		uzc.dim_geolocation_city,
		uzc.dim_geolocation_state
	from daydiff dd
	join unique_zip_code uzc
		on dd.dim_customer_zip_code_prefix = uzc.dim_geolocation_zip_code_prefix
)
select * 
from daydiff_location