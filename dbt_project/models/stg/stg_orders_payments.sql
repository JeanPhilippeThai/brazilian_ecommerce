select
    order_id as dim_order_id,
    payment_sequential as fct_payment_sequential,
    payment_type as fct_payment_type,
    payment_installments as fct_payment_installments,
    payment_value as fct_payment_value
from
    {{ source('brazilian_ecommerce', 'raw_orders_payments') }}