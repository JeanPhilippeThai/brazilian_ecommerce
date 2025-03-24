select
    review_id as dim_review_id,
    order_id as dim_order_id,
    review_creation_date as dim_review_creation_date,
    review_score as fct_review_score,
    review_comment_title as fct_review_comment_title,
    review_answer_timestamp as fct_review_answer_timestamp
from
    {{ source('brazilian_ecommerce', 'raw_orders_reviews') }}