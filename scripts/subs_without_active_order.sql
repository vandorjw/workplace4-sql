select
	s.subscription_id
from
	subscriptions s
left join orders o on
	s.subscription_id = o.subscription_id
left join invoices i on
	o.order_id = i.order_id
where
	s.status = 'Active'
	and o.status = 'Processed'
	and i.status in ('Fulfilled', 'Packed')
	and s.subscription_id is not null
	and s.subscription_id not in (
	select
		o.subscription_id
	from
		orders o
	where o.status = 'Active'
	and o.subscription_id is not null)
group by
	s.subscription_id;
