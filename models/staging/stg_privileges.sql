with source as (

    select * from {{ source('northwind_db', 'privileges') }}
)
select 
    *,
    current_timestamp() as ingestion_timestamp
from source