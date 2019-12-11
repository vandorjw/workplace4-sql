select
	i.invoice_id,
	count(*) as invoice_product_count,
	opc.order_product_count as order_product_count
from
	invoices i
left join invoice_products ip on
	i.invoice_id = ip.invoice_id
left join (
	select
		o.order_id,
		count(*) as order_product_count
	from
		orders o
	left join order_products op on
		o.order_id = op.order_id
	where
		o.status != 'cancelled'
	group by
		o.order_id ) as opc on
	opc.order_id = i.order_id
where
	i.order_id is not null
	and i.status != 'cancelled'
	and i.legacy_invoice_id is null
	and i.status_date > SUBDATE(NOW(), 7)
group by
	i.invoice_id
having
	invoice_product_count <> order_product_count
order by
	i.status_date desc;
