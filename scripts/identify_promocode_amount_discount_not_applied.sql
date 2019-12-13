select
	o.order_id,
	o.first_name,
	o.last_name,
	sp.price,
	pc.promo_code,
	pcp.amount,
	o.subtotal,
	o.status_date,
	CASE
		WHEN sp.price-round(pcp.amount) < 0 then 0
		ELSE sp.price-round(pcp.amount)
	END as correct_subtotal,
	o.subtotal-(sp.price-round(pcp.amount)) as delta
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
	and (pc.duration = '-1'
	or pc.duration = 'forever'
	or pc.duration is null)
	and pcp.amount is not NULL
	and pcp.plan_id = s.plan_id
	and pcp.amount > 0
	and o.status in ('Active')
	and pc.status = 'active'
having
	round(o.subtotal) <> correct_subtotal
order by
	o.status_date desc;
