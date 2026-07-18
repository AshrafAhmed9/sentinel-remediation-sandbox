select
    user_id,
    cast(signup_date as date) as signup_date,
    country,
    plan
from "sentinel_world"."main_raw"."raw_users"