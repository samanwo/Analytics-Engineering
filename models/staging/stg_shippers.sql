with source as (

    select * from {{ source('northwind_db', 'shippers') }}
)
select 
    *,
    current_timestamp() as ingestion_timestamp
from source