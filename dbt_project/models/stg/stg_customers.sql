select
    customer_unique_id as dim_customer_unique_id,
    customer_id as dim_customer_id,
    customer_zip_code_prefix as dim_customer_zip_code_prefix,
    customer_city as dim_customer_city,
    customer_state as dim_customer_state
from
    {{ source('brazilian_ecommerce', 'raw_customers') }}