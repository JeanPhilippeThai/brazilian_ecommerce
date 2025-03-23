select
    *
from
    {{ source('brazilian_ecommerce', 'stg_products_category_name') }}