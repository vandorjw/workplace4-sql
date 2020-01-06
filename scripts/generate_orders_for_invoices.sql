-- roughly how many orders are missing
select sum(multi_invs) from (select o.order_id, count(*) as multi_invs from orders o left join invoices i on 
o.order_id=i.order_id
where i.invoice_id is not null
group by o.order_id
having multi_invs > 1) as dups;


-- Generate orders from invoices
INSERT INTO orders
(order_id, legacy_order_id, user_id, subscription_id, first_name, last_name, shipping_address, billing_address, order_type, zone_id, 
create_date, status, status_date, payment_processor, payment_processor_id, receipt_id, subtotal, 
shipping_amount, tax_amount, credit_applied, promo_code, billing_date, invoice_generated,
receipt_date, reminder_email_sent, reminder_email_date, comped_order, refunded, projected_shipper_id, projected_shipping_date)
select
	ULID(),
	NULL,
	o.user_id,
	o.subscription_id,
	o.first_name,
	o.last_name,
	o.shipping_address,
	o.billing_address,
	o.order_type,
	o.zone_id,
	o.create_date,
	CASE
		WHEN i.status='Cancelled' then 'Cancelled'
		WHEN i.status='Skipped' then 'Skipped'
		ELSE 'Processed'
	END as status,
	i.status_date,
	o.payment_processor,
	o.payment_processor_id,
	i.invoice_id,
	o.subtotal,
	o.shipping_amount,
	o.tax_amount,
	o.credit_applied,
	o.promo_code,
	o.billing_date,
	1,
	o.receipt_date,
	1,
	o.reminder_email_date,
	o.comped_order,
	o.refunded,
	o.projected_shipper_id,
	o.projected_shipping_date
from
	invoices i
left join orders o on 
	i.order_id=o.order_id
join (select order_id from (select o.order_id, count(*) as multi_invs from orders o left join invoices i on 
o.order_id=i.order_id
where i.invoice_id is not null
group by o.order_id
having multi_invs > 1) as inner_dups) as dups on
i.order_id=dups.order_id
where 
i.order_id=dups.order_id
and
	i.create_date < (
	select
		max(i.create_date)
	from
		invoices i
	where
		i.order_id = dups.order_id);
