
  
  create view "sentinel_world"."main_staging"."stg_refunds__dbt_tmp" as (
    select
    refund_id,
    order_id,
    user_id,
    cast(refund_date as date) as refund_date,
    refund_amount
from "sentinel_world"."main_raw"."raw_refunds"
  );
