with source as (

    select * from {{ source('northwind_db', 'purchase_orders') }}
)
select 
    *,
    current_timestamp() as ingestion_timestamp
from source