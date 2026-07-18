
  
  create view "sentinel_world"."main_staging"."stg_churn_labels__dbt_tmp" as (
    select
    user_id,
    cast(churned as boolean) as churned,
    churn_date
from "sentinel_world"."main_raw"."raw_churn_labels"
  );
