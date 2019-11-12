select
	s.subscription_id,
	sf.frequency_id,
	sf.hour_interval
from
	subscriptions s
left join subscription_frequencies sf on
	s.frequency_id = sf.frequency_id
where
	sf.frequency_id in (
	select
		sf.frequency_id
	from
		subscription_frequencies sf
	where
		hour_interval = 0);
