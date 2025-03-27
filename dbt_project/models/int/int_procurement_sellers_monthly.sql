-- Pour répondre à: CHEZ QUI ET QUAND SE FOURNIR?

-- Vue qui réunie chaque seller_id avec sa localisation avec
-- Le montant total et la moyenne des ventes qu'il a fait MENSUELLEMENT
-- Le montant total et la moyen

-- Séparation du timestamp en année et mois
with orders as(
	select
		dim_seller_id,
		dim_order_id,
		extract(year from fct_shipping_limit_date) as year_shipping_date,
		extract(month from fct_shipping_limit_date) as month_shipping_date,
		fct_freight_value,
		fct_price
	from
		wh_orders_items
),
-- Calcul des valeurs qui nous intéressent
agg_order_items as(
	select
		dim_seller_id,
		dim_order_id,
		year_shipping_date,
		month_shipping_date,
		count(1) as cnt_orders,
		sum(fct_freight_value) as sum_freight_value,
		round(avg(fct_freight_value), 2) as avg_freight_value,
		sum(fct_price) as sum_price,
		round(avg(fct_price), 2) as avg_price
	from
		orders
	group by dim_seller_id, dim_order_id, year_shipping_date, month_shipping_date 
),
-- Enrichissement avec les reviews
review_on_time as(
	select
		r.dim_order_id,
		r.fct_review_score,
		case 
			when (o.fct_order_estimated_delivery_date > o.fct_order_delivered_customer_date) then 1
			else 0
		end as on_time
	from wh_orders_reviews as r
	join wh_orders as o
		on r.dim_order_id = o.dim_order_id
),
-- Calcul des valeurs qui nous intéressent liées au reviews
agg as(
	select
		aoi.dim_seller_id, 
		aoi.year_shipping_date,
		aoi.month_shipping_date,
		aoi.cnt_orders,
		aoi.sum_freight_value,
		aoi.avg_freight_value,
		aoi.sum_price,
		aoi.avg_price,
		round(avg(rot.fct_review_score), 2) as avg_review_score,
		round(100.0 * sum(on_time) / count(on_time), 2) as prct_delivery_on_time
	from agg_order_items as aoi
	join review_on_time as rot
		on aoi.dim_order_id = rot.dim_order_id
	group by 
		aoi.dim_seller_id,
		aoi.year_shipping_date,
		aoi.month_shipping_date, 
		aoi.sum_freight_value,
		aoi.sum_price,
		aoi.avg_freight_value,
		aoi.avg_price,
		aoi.cnt_orders
)
select
	agg.dim_seller_id,
	ws.dim_seller_state,
	ws.dim_seller_city,
	ws.dim_seller_zip_code_prefix,
	agg.year_shipping_date,
	agg.month_shipping_date,
	agg.cnt_orders,
	agg.sum_price,
	agg.avg_price,
	agg.sum_freight_value,
	agg.avg_freight_value,
	agg.prct_delivery_on_time,
	agg.avg_review_score
from agg
join wh_sellers ws
	on agg.dim_seller_id = ws.dim_seller_id
