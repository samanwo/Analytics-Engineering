with source as (

    select * from {{ source('northwind_db', 'customer') }}
)
select 
    *,
    current_timestamp() as ingestion_timestamp
from source
