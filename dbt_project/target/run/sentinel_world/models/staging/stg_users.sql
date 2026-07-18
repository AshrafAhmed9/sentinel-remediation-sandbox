
  
  create view "sentinel_world"."main_staging"."stg_users__dbt_tmp" as (
    select
    user_id,
    cast(signup_date as date) as signup_date,
    country,
    plan
from "sentinel_world"."main_raw"."raw_users"
  );
