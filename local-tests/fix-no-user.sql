update orders o left join users u on 
(o.first_name=u.first_name and
o.last_name=u.last_name)
set o.user_id=u.user_id
where o.user_id is null;


update invoices i left join orders o on 
i.order_id=o.order_id
set i.user_id=o.user_id
where i.user_id is null;
