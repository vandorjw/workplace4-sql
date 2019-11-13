-- get the subscription ID for all subscriptions that need to re-create an active order object
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
			U0.`order_id` IS NOT NULL))))));
