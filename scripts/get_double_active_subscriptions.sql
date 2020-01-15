-- DOUBLE ACTIVE SUBSCRIPTIONS
select
	s.subscription_id,
	o.order_id,
	s.next_billing_date as sub_billing_date,
	o.billing_date as order_billing_date,
	o.status as order_status,
	s.status as subscription_status,
	o.first_name,
	o.last_name
from
	subscriptions s
right join orders o on
	s.subscription_id = o.subscription_id
where
	s.subscription_id in (
	select
		double_active.subscription_id
	from
		(
		select
			s.subscription_id,
			count(*) as amount
		from
			orders o
		left join subscriptions s on
			o.subscription_id = s.subscription_id
		where
			o.status = 'Active'
			and s.subscription_id is not NULL
		group by
			s.subscription_id
		having
			amount > 1) as double_active)
order by s.subscription_id;
