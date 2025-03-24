select
	dim_order_id,
	dim_customer_id,
	fct_order_purchase_timestamp,
	extract(day from (fct_order_approved_at - fct_order_purchase_timestamp)) as order_approved_day_since_purchase,
	extract(day from (fct_order_estimated_delivery_date - fct_order_purchase_timestamp)) as estimated_delivery_day_since_purchase,
	extract(day from (fct_order_delivered_carrier_date - fct_order_purchase_timestamp)) as delivered_carrier_day_since_purchase,
	extract(day from (fct_order_delivered_customer_date - fct_order_purchase_timestamp)) as delivered_customer_since_purchase
from wh_orders
where
	fct_order_approved_at is not null
	and fct_order_delivered_carrier_date is not null
	and fct_order_delivered_customer_date is not null
	and fct_order_estimated_delivery_date is not null
	and fct_order_purchase_timestamp is not null
	and fct_order_status = 'delivered'