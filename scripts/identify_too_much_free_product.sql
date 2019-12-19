select o.order_id, o.status, o.promo_code, promo_product_count.order_promo_product_count, should_have.promo_product_count from orders o 
inner join subscriptions s on 
o.subscription_id=s.subscription_id
inner join (
select order_id, count(*) as order_promo_product_count from order_products op
where op.promo_code is not null
group by order_id) as promo_product_count on 
o.order_id=promo_product_count.order_id
inner join (
select
	pcp.plan_id,
	pcp.promo_code,
	count(*) as promo_product_count
from
	promo_code_products pcp
group by
	pcp.plan_id,
	pcp.promo_code) as should_have on 
(should_have.promo_code=o.promo_code and s.plan_id=should_have.plan_id)
where promo_product_count.order_promo_product_count > should_have.promo_product_count
and s.status='Active'
and o.status in ('Active', 'Processed');
