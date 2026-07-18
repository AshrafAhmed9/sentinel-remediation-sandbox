select
    refund_id,
    order_id,
    user_id,
    cast(refund_date as date) as refund_date,
    refund_amount
from {{ ref('raw_refunds') }}
