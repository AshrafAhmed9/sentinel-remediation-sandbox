select
    user_id,
    cast(churned as boolean) as churned,
    churn_date
from {{ ref('raw_churn_labels') }}
