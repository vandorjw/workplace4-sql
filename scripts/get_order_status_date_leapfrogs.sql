select
	o1.first_name,
	o1.last_name,
	o1.order_id,
	o1.status,
	o1.status_date,
	o1.billing_date,
	o2.order_id,
	o2.status,
	o2.status_date,
	o2.billing_date
from 
	orders o1,
	orders o2
WHERE
	o1.user_id=o2.user_id
and 
  o1.status='Active' 
and
  o1.status_date>DATE('2019-10-30') 
and
  o2.status not in ('Active', 'Cancelled') 
and
  (o2.status_date > o1.status_date);
