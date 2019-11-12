select
	s.subscription_id,
	o.order_id,
	o.first_name,
	o.last_name,
	s.next_billing_date,
	o.billing_date,
	TIMESTAMPDIFF(MICROSECOND, o.billing_date, s.next_billing_date) as delta
from
	subscriptions s
right join orders o on
	s.subscription_id = o.subscription_id
where
	s.subscription_id is not NULL
	and o.status='Active'
having delta != 0;
