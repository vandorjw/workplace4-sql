select
	o.subscription_id, 
	o.order_id,
	o.status as o_status,
	s.status as s_status,
	o.billing_date,
	s.next_billing_date,
	TIMESTAMPDIFF(HOUR, s.next_billing_date, o.billing_date) as difference_in_hours,
	CASE
		WHEN s.next_billing_date > o.billing_date THEN "true"
		ELSE "false"
	END as sub_gt_order
from orders o left join subscriptions s 
on o.subscription_id = s.subscription_id
where
o.order_id in (select order_id from (select MAX(o.billing_date), o.order_id, o.status from orders o 
where o.subscription_id is not NULL
and o.status != 'Active'
group by o.subscription_id) as max_not_active)
and o.billing_date != s.next_billing_date
and s.status='Active'
HAVING sub_gt_order="false";
