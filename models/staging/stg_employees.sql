with source as (

    select * from {{ source('northwind_db', 'employees') }}
)
select 
    *,
    current_timestamp() as ingestion_timestamp
from source