select
	date(o.billing_date) as date,
	count(*) as amount
	from orders o
where
	o.billing_date < DATE('2020-07-11')
	and o.billing_date > DATE('2020-07-01')
	and o.zone_id = 3
	and o.status = 'Active'
	and legacy_order_id is null
	and o.receipt_id is null
	and o.order_type <> 'Gift Certificate'
group by
	date(o.billing_date);
