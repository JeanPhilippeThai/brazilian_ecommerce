select
    order_id as dim_order_id,
    order_item_id as dim_order_item_id,
    product_id as dim_product_id,
    seller_id as dim_seller_id,
    shipping_limit_date as fct_shipping_limit_date,
    price as fct_price,
    freight_value as fct_freight_value
from
    {{ source('brazilian_ecommerce', 'raw_orders_items') }}