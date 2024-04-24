select
    id as payment_id,
    orderid as order_id,
    paymentmethod as payment_method,
    status,
    -- amount is stored in cents, convert it to dollars
    created as created_at,
    amount / 100 as amount
from {{ source('stripe', 'payment') }}
