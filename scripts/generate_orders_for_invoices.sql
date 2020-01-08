-- roughly how many orders are missing
select sum(multi_invs) from (select o.order_id, count(*) as multi_invs from orders o left join invoices i on 
o.order_id=i.order_id
where i.invoice_id is not null
group by o.order_id
having multi_invs > 1) as dups;


-- Generate orders from invoices
INSERT IGNORE INTO orders
(order_id, legacy_order_id, user_id, subscription_id, first_name, last_name, shipping_address, billing_address, order_type, zone_id, 
create_date, status, status_date, payment_processor, payment_processor_id, receipt_id, subtotal, 
shipping_amount, tax_amount, credit_applied, promo_code, billing_date, invoice_generated,
receipt_date, reminder_email_sent, reminder_email_date, comped_order, refunded)
SELECT
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
		WHEN i.status='Skipped' then 'Cancelled'
		ELSE 'Processed'
	END as status,
	i.status_date,
	o.payment_processor,
	o.payment_processor_id,
	i.invoice_id,
	i.order_total as subtotal,
	i.shipping_cost as shipping_amount,
	o.tax_amount,
	o.credit_applied,
	i.legacy_promo_code as promo_code,
	i.create_date as billing_date,
	1,
	i.create_date as receipt_date,
	1,
	o.reminder_email_date,
	i.comped_order as comped_order,
	o.refunded
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


-- update the invoices
update invoices i left join orders o on 
i.invoice_id=o.receipt_id
set i.order_id=o.order_id
where o.order_id is not null;
