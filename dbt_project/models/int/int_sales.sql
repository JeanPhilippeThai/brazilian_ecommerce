-- Pour répondre à: QUOI VENDRE ET QUAND?

-- Contient le chiffre d'affaire mensuel de chaque produit par client
-- Ainsi que les informations de chaque produit

-- Join entre les commandes et les produits
with cte as(
	select
		woi.dim_order_id,
		woi.dim_product_id,
		woi.fct_price,
		extract(year from wo.fct_order_purchase_timestamp) as year,
		extract(month from wo.fct_order_purchase_timestamp) as month,
		wo.dim_customer_id
	from wh_orders_items woi
	join wh_orders wo
		on woi.dim_order_id = wo.dim_order_id
),
-- Ajout des villes et états de résidence des clients
with_customers as(
	select
		c.*,
		wc.dim_customer_state,
		wc.dim_customer_city,
		wc.dim_customer_zip_code_prefix
	from cte c
	join wh_customers wc
		on c.dim_customer_id = wc.dim_customer_unique_id
),
-- Chiffre d'affaire mensuel pour chaque produit
-- Enrichi avec les informations de chaque produit
product_analysis as(
	select
		c.dim_product_id,
		c.year,
		c.month,
		c.dim_customer_zip_code_prefix,
		c.dim_customer_state,
		c.dim_customer_city,
		sum(fct_price),
		count(1) as num_of_orders,
		wp.dim_name_length,
		wp.dim_product_category,
		wp.dim_product_height_cm,
		wp.dim_product_length_cm,
		wp.dim_product_photos_qty,
		wp.dim_product_weight_g,
		wp.dim_product_width_cm
	from with_customers c
	join wh_products wp
		on c.dim_product_id = wp.dim_product_id
	group by
		c.dim_product_id,
		c.year,
		c.month,
		c.dim_customer_zip_code_prefix,
		c.dim_customer_state,
		c.dim_customer_city,
		wp.dim_product_category,
		wp.dim_name_length,
		wp.dim_product_height_cm,
		wp.dim_product_length_cm,
		wp.dim_product_photos_qty,
		wp.dim_product_weight_g,
		wp.dim_product_width_cm
)
select *
from product_analysis