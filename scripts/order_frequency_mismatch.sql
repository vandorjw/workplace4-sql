select
	o1.first_name,
	o2.last_name,
	o1.order_id,
	DATE(o1.create_date) as create_date1,
	o1.status,
	DATE(o1.billing_date) as billing_date1,
	o2.order_id,
	DATE(o2.create_date) as create_date2,
	o2.status,
	DATE(o2.billing_date) as billing_date2,
	sf.hour_interval/24 as frequency_in_days,
	MOD(TIMESTAMPDIFF(DAY, o2.billing_date, o1.billing_date), sf.hour_interval/24) as modulo
from
	subscriptions s
join subscription_frequencies sf on
	s.frequency_id = sf.frequency_id
right join orders o1 on
	o1.subscription_id = s.subscription_id
right join orders o2 on
	o2.subscription_id = s.subscription_id
where
	(MOD(TIMESTAMPDIFF(DAY, o2.billing_date, o1.billing_date), sf.hour_interval / 24) > 1
and 
	(sf.hour_interval/24) - MOD(TIMESTAMPDIFF(DAY, o2.billing_date, o1.billing_date), sf.hour_interval / 24) > 1)
AND
	o1.create_date > DATE('2019-1-30')
AND
	o2.create_date > DATE('2019-1-30')
order by
	o1.first_name,
	o1.last_name,
	o1.create_date;
