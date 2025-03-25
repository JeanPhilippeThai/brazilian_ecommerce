-- Contient le chiffre d'affaire mensuel de chaque produit
-- Ainsi que les informations de chaque produit

-- Possibilité de réduire le nombre de ligne en créant une liste du type [(year, month, num_of_orders, monthly_turnover)]
-- Afin de n'avoir qu'une ligne par product_id

-- Join entre les commandes et les produits
with cte as(
	select
		woi.dim_order_id,
		woi.dim_product_id,
		woi.fct_price,
		extract(year from wo.fct_order_purchase_timestamp) as year,
		extract(month from wo.fct_order_purchase_timestamp) as month
	from wh_orders_items woi
	join wh_orders wo
		on woi.dim_order_id = wo.dim_order_id
),
-- Chiffre d'affaire mensuel pour chaque produit
-- Enrichi avec les informations de chaque produit
product_analysis as(
	select
		c.dim_product_id,
		c.year,
		c.month,
		sum(fct_price),
		count(1) as num_of_orders,
		wp.dim_product_category,
		wp.dim_name_length,
		wp.dim_product_category,
		wp.dim_product_height_cm,
		wp.dim_product_length_cm,
		wp.dim_product_photos_qty,
		wp.dim_product_weight_g,
		wp.dim_product_width_cm
	from cte c
	join wh_products wp
		on c.dim_product_id = wp.dim_product_id
	group by
		c.dim_product_id,
		c.year,
		c.month,
		wp.dim_product_category,
		wp.dim_name_length,
		wp.dim_product_category,
		wp.dim_product_height_cm,
		wp.dim_product_length_cm,
		wp.dim_product_photos_qty,
		wp.dim_product_weight_g,
		wp.dim_product_width_cm
)
select *
from product_analysis