select
	lower(REPLACE(sl.shipper, " ", "")) as courier,
	count(sl.shipper) as deliveries,
	round(avg(shipping_cost), 2) as avg_cost,
	round(max(shipping_cost), 2) as max_cost,
	round(min(shipping_cost), 2) as min_cost,
	round(sum(shipping_cost), 2) as total_costs
from
	invoices i
left join shipping_labels sl on
	i.invoice_id = sl.invoice_id 
where 
	sl.label_id is not NULL 
	and sl.status <> 'Cancelled'
group by lower(REPLACE(sl.shipper, " ", ""))
order by deliveries DESC;
