-- NOTE (planted bug B): the payments team renamed `amount` -> `amount_usd`
-- and started writing new rows into `raw_payments_v2` on 2025-04-15. This
-- staging model was never updated to point at the new table, so payment
-- volume here silently stops growing after the cutover -- everything
-- downstream (total_payment_amount, churn_predictor) is now working off
-- stale/incomplete data without a single error being thrown.
select
    payment_id,
    order_id,
    amount,
    method
from {{ ref('raw_payments') }}
