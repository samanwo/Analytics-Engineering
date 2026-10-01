with source as (
    select cast(split_part(supplier_ids, ';', 1) as integer) as supplier_id,
           id,
           product_code,
           product_name,
           description,
           standard_cost,
           list_price,
           reorder_level,
           target_level,
           quantity_per_unit,
           discontinued,
           minimum_reorder_quantity,
           category,
           attachments,
    from {{ source('northwind_db', 'products') }}
   -- where supplier_ids not like "%;%"
)
select 
    *,
    current_timestamp() as ingestion_timestamp
from source