-- Pour répondre à: A QUI VENDRE ET OU?

-- Contient chaque order_id avec 
-- toutes les informations sur le client
-- la date de la commande
-- le montant de la commande, le nombre de mensualité choisi par le client, 
-- le score de la review et la review s'ils existent


-- Join des commandes avec les clients
with cte as(
	select
		wo.dim_order_id,
		wo.dim_customer_id,
		wo.fct_order_purchase_timestamp,
		wc.dim_customer_city,
		wc.dim_customer_state,
		wc.dim_customer_zip_code_prefix
	from wh_orders wo
	join wh_customers wc
		on wo.dim_customer_id = wc.dim_customer_unique_id
	where wo.fct_order_status = 'delivered'
),
-- Join des commandes, des clients et des reviews si elles existent
cte2 as(
	select
		c.*,
		wor.dim_review_id,
		wor.fct_review_score,
		wor.fct_review_comment_title,
		wor.fct_review_answer_timestamp
	from cte c
	left join wh_orders_reviews wor
		on c.dim_order_id = wor.dim_order_id
),
-- Un client peut payer en plusieurs fois donc il faut sommer la valeur des payments par rapport à order_id
-- Agg_payments contient une ligne par order_id
agg_payments as(
	select
		dim_order_id,
		fct_payment_installments,
		sum(fct_payment_value) as fct_payment_value
	from
		wh_orders_payments wop
	group by dim_order_id, fct_payment_installments
),
agg as(
	select
		c.*,
		ap.fct_payment_installments,
		ap.fct_payment_value
	from cte2 c
	join agg_payments ap
		on c.dim_order_id = ap.dim_order_id
)
select *
from agg
		