with date_spine as (
    select 
        -- Generates a continuous sequence of row numbers from 0 upwards
        row_number() over (order by null) - 1 as row_num
    from table(generator(rowcount => 15000)) -- 15,000 rows covers ~41 years (2014 to 2055)
),

calculated_dates as (
    select 
        -- Start at 2014-01-01 and add the row number increment as days
        dateadd(day, row_num, '2014-01-01'::date) as d
    from date_spine
    -- This acts like your upper bound limit ('2050-01-01')
    where d <= '2050-01-01'::date
)

select
  to_char(d, 'YYYYMMDD')                  as id,             -- Good practice for data warehouses
  d                                       as full_date,
  extract(year from d)                    as year,
  extract(week from d)                    as year_week,
  extract(day from d)                     as year_day,
  extract(year from d)                    as fiscal_year,
  to_char(d, 'Q')                         as fiscal_qtr,     -- Extracts quarter (1-4)
  extract(month from d)                   as month,
  to_char(d, 'MMMM')                      as month_name,     -- Full text month name
  to_char(d, 'DE')                        as week_day,       -- Day of week number (1-7)
  dayname(d)                              as day_name,       -- e.g., 'Mon', 'Tue', 'Sat'
  (case when dayname(d) in ('Sat', 'Sun') 
        then 0 else 1 end)                as day_is_weekday  -- Snowflake dayname returns 3-letter abbreviations
from calculated_dates
