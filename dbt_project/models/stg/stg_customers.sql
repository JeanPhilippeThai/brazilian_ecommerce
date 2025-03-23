select
    *
from
    {{ source('brazilian_ecommerce', 'stg_customers') }}