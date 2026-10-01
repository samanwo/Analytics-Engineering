with source as (

    select * from {{ source('northwind_db', 'employee_privileges') }}
)
select 
    *,
    current_timestamp() as ingestion_timestamp
from source