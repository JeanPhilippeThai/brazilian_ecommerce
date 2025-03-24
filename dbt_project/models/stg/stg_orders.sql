select
    order_id as dim_order_id,
    customer_id as dim_customer_id,
    order_status as fct_order_status,
    order_purchase_timestamp as fct_order_purchase_timestamp,
    order_approved_at as fct_order_approved_at,
    order_delivered_carrier_date as fct_order_delivered_carrier_date,
    order_delivered_customer_date as fct_order_delivered_customer_date,
    order_estimated_delivery_date as fct_order_estimated_delivery_date
from
    {{ source('brazilian_ecommerce', 'raw_orders') }}