use MYDB;

-- DELETE ALL invoice-products
 DELETE
	ip.*
from
	invoice_products ip
join invoices i on
	i.invoice_id = ip.invoice_id
join orders o on
	o.order_id = i.order_id
WHERE
	o.user_id = "01DS3JQK1R6CW66RB1CDJK2RSS";

-- DELETE ALL SHIPPING LABELS
DELETE
	sl.*
from
	shipping_labels sl
join invoices i on
	sl.invoice_id = i.invoice_id
join orders o on
	o.user_id = i.user_id
where
	o.user_id = "01DS3JQK1R6CW66RB1CDJK2RSS";

-- DELETE ALL invoices
 DELETE
	i.*
from
	invoices i
join orders o on
	i.order_id = o.order_id
where
	o.user_id = "01DS3JQK1R6CW66RB1CDJK2RSS";

-- UPDATE ORDERS ---> INVOICE GENERATED=0
UPDATE orders o 
SET invoice_generated=0
where o.user_id = "01DS3JQK1R6CW66RB1CDJK2RSS";



-- #################### SELECT ######

select
	o.order_id,
	o.invoice_generated,
	o.receipt_date,
	o.receipt_id,
	o.status_date,
	o.zone_id,
	o.status,
	i.shipping_date
from
	invoices i 
right join orders o on
	o.order_id = i.order_id
WHERE
	o.user_id = "01DS3JQK1R6CW66RB1CDJK2RSS";


