select o.order_id, o.subtotal, broken_subtotal.correct_subtotal, o.promo_code, broken_subtotal.percentage, broken_subtotal.amount from orders o join (select
	o.order_id,
	o.status,
	o.first_name,
	o.last_name,
	sp.price,
	pc.promo_code,
	pc.duration,
	pcp.amount,
	pcp.percentage,
	o.subtotal,
	o.create_date,
	o.status_date,
	o.billing_date,
	CASE
		WHEN (pcp.amount is not null and pcp.amount > 0)
		THEN
			CASE
				WHEN sp.price-round(pcp.amount) < 0 THEN 0
				ELSE sp.price-round(pcp.amount)
			END
		WHEN (pcp.percentage is not null and pcp.percentage > 0)
		THEN
			CASE
				WHEN sp.price - sp.price*(pcp.percentage/100) < 0 THEN 0
				ELSE sp.price - sp.price*(pcp.percentage/100)
			END
	END as correct_subtotal
from
	orders o
left join promo_codes pc on
	o.promo_code = pc.promo_code
left join promo_code_plans pcp on
	pc.promo_code = pcp.promo_code
left join subscriptions s on
	o.subscription_id = s.subscription_id
left join subscription_plans sp on
	s.plan_id = sp.plan_id
where
	pc.tier is not null
	and (pcp.amount is not NULL or pcp.percentage is not NULL)
	and pcp.plan_id = s.plan_id
	and o.status in ('Active')
	and pc.status = 'active'
having
	round(o.subtotal) <> correct_subtotal) as broken_subtotal on 
o.order_id=broken_subtotal.order_id;
