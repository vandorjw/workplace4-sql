select
	o.order_id,
	o.first_name as order_f_name,
	u.first_name,
	o.last_name as order_l_name,
	u.last_name,
	u.email
from
	users u
right join orders o on
	u.user_id = o.user_id
WHERE
	(u.first_name != o.first_name
	or u.last_name != o.last_name);
