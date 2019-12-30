-- This selects all orders that are being billed at an improper interval.
-- I am not sure how to filter out those orders which are purposefully skipped.

select
	o1.subscription_id,
	o1.order_id,
	o1.billing_date,
	o1.status,
	o2.order_id,
	o2.billing_date,
	o2.status,
	-- 
	-- There are 2 cases. The difference is billing dates can be small (less than 24 hours)
	-- or can be large. If it is large I subtract this value from the hour_interval, and if its differnce is small( less than 24 hours)
	-- I will exclude it in the having statement
	CASE 
		WHEN MOD(ABS(TIMESTAMPDIFF(HOUR, o1.billing_date, o2.billing_date)), sf.hour_interval) < 24 then 
			MOD(ABS(TIMESTAMPDIFF(HOUR, o1.billing_date, o2.billing_date)), sf.hour_interval)
		ELSE
			sf.hour_interval - MOD(ABS(TIMESTAMPDIFF(HOUR, o1.billing_date, o2.billing_date)), sf.hour_interval)
	END as large_hour_difference
from
	orders o1
inner join orders o2 on
	o1.subscription_id = o2.subscription_id
left join subscriptions s on
	o1.subscription_id = s.subscription_id
left join subscription_frequencies sf on
	s.frequency_id = sf.frequency_id
where
	o1.subscription_id = o2.subscription_id  -- orders must belong to same subscription
	and o1.order_id <> o2.order_id -- don't do a self comparison
	and o1.status != 'Cancelled'  -- order A must not be cancelled
	and o2.status != 'Cancelled'  -- order B must not be cancelled
	and s.status = 'Active'  -- subscriptions must still be active
	and o1.billing_date > o2.billing_date  -- prevents duplicate rows
	and MOD(ABS(TIMESTAMPDIFF(HOUR, o1.billing_date, o2.billing_date)), sf.hour_interval) <> 0 -- billing dates doesn't match frequency
having large_hour_difference > 24  -- I am not interested in small hour differences.
order by s.subscription_id desc;
