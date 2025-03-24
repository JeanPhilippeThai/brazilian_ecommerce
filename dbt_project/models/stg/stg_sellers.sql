select
    seller_id as dim_seller_id,
    seller_zip_code_prefix as dim_seller_zip_code_prefix,
    seller_city as dim_seller_city,
    seller_state as dim_seller_state
from
    {{ source('brazilian_ecommerce', 'raw_sellers') }}