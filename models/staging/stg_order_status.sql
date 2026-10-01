with source as (

    select * from {{ source('northwind_db', 'orders_status') }}
)
select 
    *,
    current_timestamp() as ingestion_timestamp
from source