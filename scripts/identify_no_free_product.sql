select o.order_id, o.promo_code from orders o 
left join subscriptions s on 
o.subscription_id=s.subscription_id
left join promo_code_products pcp on 
(pcp.plan_id=s.plan_id and pcp.promo_code=o.promo_code)
where o.order_id not in 
(select o.order_id from orders o 
left join order_products op on 
o.order_id=op.order_id
where 
o.promo_code is not null
and op.promo_code is not null)
and 
o.promo_code is not null
and o.status='Active'
and pcp.product_id is not null;
