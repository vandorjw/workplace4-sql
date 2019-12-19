select
	distinct(o.order_id),
	o.status,
	o.first_name,
	o.last_name,
	o.promo_code
from
	orders o
left join subscriptions s on
	o.subscription_id = s.subscription_id
left join promo_code_products pcp on
	(pcp.plan_id = s.plan_id
	and pcp.promo_code = o.promo_code)
left join promo_codes pc on
	o.promo_code = pc.promo_code
where
	o.order_id not in (
	select
		DISTINCT(o.order_id)
	from
		orders o
	left join order_products op on
		o.order_id = op.order_id
	where
		o.promo_code is not null
		and op.promo_code is not null)
	and o.promo_code is not null
	and o.legacy_order_id is NULL
	and o.status in ('Active', 'Processed')
	and pc.status = 'Active'
	and pc.tier = 'orders'
	and pc.`type` = 'promo_code'
	and not (pcp.product_id is null);
