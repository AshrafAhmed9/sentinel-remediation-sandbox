
  
  create view "sentinel_world"."main_staging"."stg_orders__dbt_tmp" as (
    select
    order_id,
    user_id,
    cast(order_date as date) as order_date,
    amount
from "sentinel_world"."main_raw"."raw_orders"
  );
