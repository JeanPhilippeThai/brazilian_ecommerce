select
    *
from
    {{ source('brazilian_ecommerce', 'stg_products') }}