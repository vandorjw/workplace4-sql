-- those with promo codes

delete op.* from order_products op
where op.order_id in (
	select distinct(o.order_id) from orders o where 
	(o.promo_code is not NULL or o.promo_code!='')
	and o.status='Active'
);

delete o.* from orders o where 
(o.promo_code is not NULL or o.promo_code!='')
and o.status='Active';


-- everything

delete op.* from order_products op
where op.order_id in (
	select distinct(o.order_id) from orders o
);

delete o.* from orders o;
