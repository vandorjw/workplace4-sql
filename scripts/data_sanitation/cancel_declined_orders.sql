BEGIN TRANSACTION;

INSERT INTO activity_log(user_id, `type`, log_date, status, log, endpoint)
select
	'01DRVEZNW40Z4N27K3RRK9Q3KX' as user_id,
	'sql script'as `type`,
	now() as `log_date`,
	'cancelled' as `status`,
	CONCAT('Cancelled subscription ', o.subscription_id, ' because the status of the latest order has been in declined state since before 2019-10-31') as `log`,
	'custom' as `endpoint`
from orders o 
where 
	o.status='Declined'
	and date(o.status_date) < '2019-10-31'
and o.subscription_id is not null
and o.subscription_id not in (
	select subscription_id from (
	select o.subscription_id, max(o.create_date) 
	from orders o
	where o.status <> 'Declined' 
	and o.subscription_id is not null
	group by o.subscription_id) as latest_order_not_declined
)
group by o.subscription_id;

update subscriptions s set s.status='Cancelled', s.status_date=now() where s.subscription_id in (
	select o.subscription_id from orders o 
	where 
		o.status='Declined'
		and date(o.status_date) < '2019-10-31'
	and o.subscription_id is not null
	and o.subscription_id not in (
		select subscription_id from (
		select o.subscription_id, max(o.create_date) 
		from orders o
		where o.status <> 'Declined' 
		and o.subscription_id is not null
		group by o.subscription_id) as latest_order_not_declined
	)
	group by o.subscription_id
);

INSERT INTO activity_log(user_id, `type`, log_date, status, log, endpoint)
select
	'01DRVEZNW40Z4N27K3RRK9Q3KX' as user_id,
	'sql script'as `type`,
	now() as `log_date`,
	'cancelled' as `status`,
	CONCAT('Cancelled Order ', o.order_id, ' because the subscription has been cancelled') as `log`,
	'custom' as `endpoint`
from subscriptions s left join orders o on 
s.subscription_id=o.subscription_id
where s.status='Cancelled'
and o.status not in ('Processed', 'Cancelled')
group by o.order_id;


update orders o set s.status='Cancelled', o.status_date=now() where o.order_id in (
	select o.order_id from subscriptions s left join orders o on 
	s.subscription_id=o.subscription_id
	where s.status='Cancelled'
	and o.status not in ('Processed', 'Cancelled')
	group by o.order_id
);

COMMIT;

