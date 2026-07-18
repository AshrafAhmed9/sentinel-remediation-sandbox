-- Feature mart for churn_predictor. One row per user.
--
-- `days_since_last_refund` and `refund_count` are the planted leakage
-- features (BUG A): refunds are disproportionately filed right
-- before/around a churn event, so both columns are near-proxies for the
-- label itself, computed from data that would not actually be available
-- at prediction time.
--
-- `total_payment_amount` is affected by the planted schema-drift bug
-- (BUG B) via stg_payments, which stopped ingesting new rows after the
-- upstream rename on 2025-04-15.

with order_stats as (
    select
        user_id,
        count(*) as order_count,
        max(order_date) as last_order_date,
        min(order_date) as first_order_date
    from {{ ref('stg_orders') }}
    group by 1
),

payment_stats as (
    select
        o.user_id,
        sum(p.amount) as total_payment_amount
    from {{ ref('stg_payments') }} p
    join {{ ref('stg_orders') }} o on o.order_id = p.order_id
    group by 1
),

refund_stats as (
    select
        user_id,
        max(refund_date) as last_refund_date,
        count(*) as refund_count
    from {{ ref('stg_refunds') }}
    group by 1
)

select
    u.user_id,
    u.country,
    u.plan,
    coalesce(os.order_count, 0) as order_count,
    coalesce(ps.total_payment_amount, 0) as total_payment_amount,
    coalesce(rs.refund_count, 0) as refund_count,
    date_diff('day', rs.last_refund_date, current_date) as days_since_last_refund,
    date_diff('day', os.last_order_date, current_date) as days_since_last_order,
    cl.churned,
    cl.churn_date
from {{ ref('stg_users') }} u
left join order_stats os on os.user_id = u.user_id
left join payment_stats ps on ps.user_id = u.user_id
left join refund_stats rs on rs.user_id = u.user_id
left join {{ ref('stg_churn_labels') }} cl on cl.user_id = u.user_id
