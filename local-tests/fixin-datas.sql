update orders o left join users u on 
(o.first_name=u.first_name and
o.last_name=u.last_name)
set o.user_id=u.user_id
where o.user_id is null;

update invoices i left join orders o on 
i.order_id=o.order_id
set i.user_id=o.user_id
where i.user_id is null
and o.user_id is not null;

update users u set u.phone_number='5555555555' where u.phone_number is null;

update addresses a set preferred_shipper='Fedex' where preferred_shipper is null;

update orders o left join users u on 
o.user_id=u.user_id
set o.billing_address=u.billing_address
where o.billing_address is null and u.billing_address is not null;
