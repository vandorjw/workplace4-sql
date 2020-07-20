select
	o.order_id,
	o.status as order_status,
	o.receipt_id,
	pc.promo_code,
	pc.status as gift_card_status,
	pc.amount,
	o.create_date
from
	orders o
left join order_products op on
	op.order_id = o.order_id
inner join promo_codes pc on
	op.promo_code = pc.promo_code
where
	o.order_type = 'Gift Certificate'
  and (o.receipt_id is null or o.receipt_id = 'comped')
	and op.product_id = '01DW07R4S8CSGK4D1PCGR34DHJ'
	order by o.create_date desc
limit 100;
