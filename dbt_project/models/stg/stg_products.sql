select
    p.product_id as dim_product_id,
    n.product_category_name_english as dim_product_category,
    p.product_name_length as dim_name_length,
    p.product_description_length as dim_description_length,
    p.product_photos_qty as dim_product_photos_qty,
    p.product_weight_g as dim_product_weight_g,
    p.product_length_cm as dim_product_length_cm,
    p.product_height_cm as dim_product_height_cm,
    p.product_width_cm as dim_product_width_cm
from
    {{ source('brazilian_ecommerce', 'raw_products') }} as p
join
    {{ source('brazilian_ecommerce', 'raw_products_category_name') }} as n
on p.product_category_name = n.product_category_name
