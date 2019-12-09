-- FIND subs without active orders that are not picked up by generator

select
	s.subscription_id
from
	subscriptions s
left join orders o on
	s.subscription_id = o.subscription_id
left join invoices i on
	o.order_id = i.order_id
where
	s.status = 'Active'
	and o.status = 'Processed'
	and i.status in ('Fulfilled', 'Packed')
	and s.subscription_id is not null
	and s.subscription_id not in (
	select
		o.subscription_id
	from
		orders o
	where o.status = 'Active'
	and o.subscription_id is not null)
	
	and s.subscription_id not in (
	
	SELECT
	`subscriptions`.`subscription_id`
FROM
	`subscriptions`
WHERE
	(`subscriptions`.`status` = 'Active'
	AND NOT (`subscriptions`.`subscription_id` IN (
	SELECT
		U0.`subscription_id`
	FROM
		`orders` U0
	WHERE
		(U0.`status` IN ('Active',
		'Failed Payment 1',
		'Failed Payment 2',
		'Declined')
		AND U0.`subscription_id` IS NOT NULL)))
	AND NOT (`subscriptions`.`subscription_id` IN (
	SELECT
		V0.`subscription_id`
	FROM
		`orders` V0
	WHERE
		(V0.`status` = 'Processed'
		AND V0.`subscription_id` IS NOT NULL
		AND V0.`order_id` IN (
		SELECT
			U0.`order_id`
		FROM
			`invoices` U0
		WHERE
			(U0.`order_id` IS NOT NULL
			AND U0.`status` IN ('Unfulfilled',
			'InProgress'))))))
	AND `subscriptions`.`subscription_id` IN (
	SELECT
		U0.`subscription_id`
	FROM
		`orders` U0
	WHERE
		U0.`subscription_id` IS NOT NULL)
	AND NOT (`subscriptions`.`subscription_id` IN (
	SELECT
		V0.`subscription_id`
	FROM
		`orders` V0
	WHERE
		(V0.`status` = 'Processed'
		AND V0.`subscription_id` IS NOT NULL
		AND NOT (V0.`order_id` IN (
		SELECT
			U0.`order_id`
		FROM
			`invoices` U0
		WHERE
			U0.`order_id` IS NOT NULL))))))
		)	
group by
	s.subscription_id;
