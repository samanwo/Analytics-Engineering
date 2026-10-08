with source as (
    select
        id as employee_id,
        company,
        last_name,
        first_name,
        email_address,
        job_title,
        business_phone,
        home_phone,
        mobile_phone,
        fax_number,
        address,
        city,
        state_province,
        zip_postal_code,
        country_region,
        web_page,
        notes,
        attachments,
        current_timestamp() as insertion_timestamp,
    from {{ ref('stg_employees') }}
),
unique_source as (
    select *,
           row_number() over (partition by employee_id order by insertion_timestamp desc) as rn_col
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