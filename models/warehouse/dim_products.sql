with source as(
    select
        p.id as product_id,
        p.product_code,
        p.product_name,
        p.description,
        s.company as supplier_company,
        p.standard_cost,
        p.list_price,
        p.reorder_level,
        p.target_level,
        p.quantity_per_unit,
        p.discontinued,
        p.minimum_reorder_quantity,
        p.category,
        p.attachments,
        current_timestamp() as insertion_timestamp,
    from {{ ref('stg_products') }} p
    left join {{ ref('stg_suppliers') }} s
    on s.id = p.supplier_id
),

-- row_number was placed here to flag duplicates
unique_source as (
    select *,
           row_number() over (partition by product_id order by insertion_timestamp desc) as rn_col
    from source
),

filtered_unique as (
    select * 
    from unique_source
    where rn_col = 1
)

-- In Snowflake, use EXCLUDE instead of EXCEPT
select * exclude (rn_col)
from filtered_unique