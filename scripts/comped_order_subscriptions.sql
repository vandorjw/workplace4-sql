select
	s.subscription_id,
	o.order_id
from
	subscriptions s
left join orders o on
	s.subscription_id = o.subscription_id
where
	o.comped_order = 1
	and s.status='Active'
	and o.subscription_id not in (
	select
		o.subscription_id
	from
		orders o
	where
		o.status = 'Active'
		and o.subscription_id is not null);
