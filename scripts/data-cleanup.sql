-- constrain product-zones
select
	product_id,
	zone_id,
	count(*) as amount
from
	product_zones
group by
	product_id,
	zone_id
having
	amount > 1;

ALTER TABLE product_zones ADD UNIQUE unique_rows( `product_id`,
`zone_id` );

-- dedup and constrain promo_code_plans

SELECT
	promo_code,
	plan_id,
	amount,
	percentage,
	count(*) as a
FROM
	promo_code_plans
group by
	promo_code,
	plan_id,
	amount,
	percentage
having
	a>1
order by
	a desc;

DELETE
	n1.*
FROM
	promo_code_plans n1,
	promo_code_plans n2
WHERE
	n1.promo_code_plan_id > n2.promo_code_plan_id
	AND n1.promo_code = n2.promo_code
	AND n1.plan_id = n2.plan_id
	AND n1.amount = n2.amount
	AND n1.percentage = n2.percentage;
	

ALTER TABLE promo_code_plans ADD UNIQUE unique_rows( `promo_code`,
`plan_id`, `amount`, `percentage` );

-- dedup and constrain postal_codes
SELECT postal_code, zone_id, shipper, count(*) as a
FROM postal_codes
group by postal_code, zone_id, shipper
having a > 1
order by a desc;

DELETE
	n1.*
FROM
	postal_codes n1,
	postal_codes n2
WHERE
	n1.postal_code_id > n2.postal_code_id
	AND n1.postal_code = n2.postal_code
	AND n1.zone_id = n2.zone_id
	AND n1.shipper = n2.shipper;

ALTER TABLE postal_codes ADD UNIQUE unique_rows( `postal_code`,
`zone_id`, `shipper` );

-- Remove Weirdess in POSTALCODE
update addresses a set a.postal=TRIM(
REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(UPPER(a.postal), " ", ""), "-", ""), ",", ""), "\t", ""), "\n", ""), "\r", ""), ".", ""));

-- Check left-over strangeness in postal/zipcodes
select address_id, address_1, postal, city, state from addresses where postal in (
select distinct(postal) from addresses a where not ((postal REGEXP '^[A-Z][0-9][A-Z][0-9][A-Z][0-9]$') or (postal REGEXP '^[0-9][0-9][0-9][0-9][0-9]$')));


-- delete nonsense activity logs
DELETE al.* from activity_log al where user_id in
(SELECT
	u.user_id
FROM
	users u
LEFT JOIN orders o ON
	o.user_id = u.user_id
LEFT JOIN subscriptions s ON
	s.user_id = u.user_id
LEFT JOIN invoices i ON
	i.user_id = u.user_id
WHERE
	o.order_id IS NULL
	AND s.subscription_id IS NULL
	AND i.invoice_id IS NULL
	AND u.password='no password');

-- remove dead user accounts
DELETE
	u.*
FROM
	users u
LEFT join orders o1 on
	u.referral_code=o1.promo_code
LEFT JOIN orders o ON
	o.user_id = u.user_id
LEFT JOIN subscriptions s ON
	s.user_id = u.user_id
LEFT JOIN invoices i ON
	i.user_id = u.user_id
LEFT JOIN leads l on 
	l.user_id = u.user_id
WHERE
	o.order_id IS NULL
	and o1.order_id is null
	AND s.subscription_id IS NULL
	AND i.invoice_id IS NULL
	AND l.lead_id IS NULL
	AND u.password='no password';									   

													   
-- delete useless addresses
delete a.* from addresses a
left join users u1 on 
u1.billing_address=a.address_id
left join users u2 on 
u2.shipping_address=a.address_id
left join subscriptions s1 on 
s1.billing_address=a.address_id
left join subscriptions s2 on 
s2.shipping_address=a.address_id
left join orders o1 on
o1.billing_address=a.address_id
left join orders o2 on 
o2.shipping_address=address_id
WHERE
u1.user_id is null 
and u2.user_id is null
and s1.subscription_id is null
and s2.subscription_id is null
and o1.order_id is null
and o2.order_id is null;
