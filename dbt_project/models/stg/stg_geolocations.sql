select
    geolocation_zip_code_prefix as dim_geolocation_zip_code_prefix,
    geolocation_lat as dim_geolocation_lat,
    geolocation_lng as dim_geolocation_lng,
    geolocation_city as dim_geolocation_city,
    geolocation_state as dim_geolocation_state  
from
    {{ source('brazilian_ecommerce', 'raw_geolocations') }}