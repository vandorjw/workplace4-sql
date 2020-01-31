select o.subtotal, op.promo_code from orders o left join order_products op on
o.order_id=op.order_id
where o.order_type='Gift Certificate' 
order by o.create_date desc limit 1;
