DELETE
	n1.*
FROM
	promo_code_products n1,
	promo_code_products n2
WHERE
	n1.promo_code_product_id > n2.promo_code_product_id
	AND n1.promo_code = n2.promo_code
	AND n1.product_id = n2.product_id
	AND n1.quantity = n2.quantity
	AND n1.duration = n2.duration
	AND ((n1.plan_id = n2.plan_id) OR (n1.plan_id is NULL and n2.plan_id is NULL))
	AND n1.zone_id = n2.zone_id;
  
  
  -- CHECK
  
select
	pcp.promo_code,
	pcp.product_id,
	pcp.quantity,
	pcp.duration,
	pcp.plan_id,
	pcp.zone_id,
	count(*) as amount
from
	promo_code_products pcp
group by
	pcp.promo_code,
	pcp.product_id,
	pcp.quantity,
	pcp.duration,
	pcp.plan_id,
	pcp.zone_id
having
	amount>1
order by
	amount desc;
