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

