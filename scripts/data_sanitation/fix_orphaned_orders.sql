update orders o left join users u on 
o.billing_address=u.billing_address
set o.user_id=u.user_id 
where o.user_id is NULL
and u.user_id is not NULL;


select * from orders o left join users u on 
o.billing_address=u.billing_address
where o.user_id is NULL
and u.user_id is not NULL
