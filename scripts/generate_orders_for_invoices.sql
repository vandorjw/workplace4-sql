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

-- run `Generate orders from invoices` again...
-- run `update the invoices ` again ...

-- updates 1075 historic records
update *******_client.invoices new_i 
join *******.order_invoice old_i on
new_i.legacy_invoice_id=old_i.order_invoice_id
join *******_client.users u on 
TRIM(u.email)=TRIM(old_i.order_invoice_email)
set new_i.user_id=u.user_id
where new_i.order_id is null and new_i.user_id is null
and u.user_id is not null;


-- delete useless invoices
create TEMPORARY table delete_invoice_id
select
	distinct(i.invoice_id)
from
	invoices i
join (select order_id from (select o.order_id, count(*) as multi_invs from orders o left join invoices i on 
o.order_id=i.order_id
where i.invoice_id is not null
group by o.order_id
having multi_invs > 1) as inner_dups) as dups on
i.order_id=dups.order_id
where 
i.order_id=dups.order_id
and i.status <> 'Fulfilled'
and
	i.status_date < (
	select
		max(i.status_date)
	from
		invoices i
	where
		i.order_id = dups.order_id);
	
select * from delete_invoice_id;

delete from invoice_products where invoice_id in (select * from delete_invoice_id);
delete from shipping_labels where invoice_id in (select * from delete_invoice_id);
delete from invoices where invoice_id in (select * from delete_invoice_id);
drop table delete_invoice_id;


-- delete more useless invoices
create TEMPORARY table delete_invoice_id
SELECT 
	i1.invoice_id
FROM
    invoices i1,
    invoices i2
WHERE
    i1.order_id IN (SELECT 
            o.order_id
        FROM
            invoices i
                LEFT JOIN
            orders o ON o.order_id = i.order_id
        WHERE
            i.order_id IS NOT NULL
        GROUP BY o.order_id
        HAVING COUNT(DISTINCT invoice_id) > 1)
and 
	i2.order_id IN (SELECT 
            o.order_id
        FROM
            invoices i
                LEFT JOIN
            orders o ON o.order_id = i.order_id
        WHERE
            i.order_id IS NOT NULL
        GROUP BY o.order_id
        HAVING COUNT(DISTINCT invoice_id) > 1)
and
i1.invoice_id < i2.invoice_id
AND
i1.order_id=i2.order_id
and 
i1.user_id=i2.user_id
and 
i1.create_date=i2.create_date;

select * from delete_invoice_id;
delete from invoice_products where invoice_id in (select * from delete_invoice_id);
delete from shipping_labels where invoice_id in (select * from delete_invoice_id);
delete from invoices where invoice_id in (select * from delete_invoice_id);
drop table delete_invoice_id;


-- generate more orders
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
invoices i join orders o on o.order_id=i.order_id where o.invoice_generated=0 and o.status in ('Active', 'Declined', 'Cancelled', 'Failed Payment 1', 'Failed Payment 2') and i.invoice_id is not null;

update invoices i left join orders o on 
i.invoice_id=o.receipt_id
set i.order_id=o.order_id
where o.order_id is not null;
