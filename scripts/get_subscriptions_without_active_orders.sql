-- get the subscription ID for all subscriptions that need to re-create an active order object
SELECT
	s.subscription_id
FROM
	subscriptions s
WHERE
	s.status = 'Active'
AND NOT 
	s.subscription_id IN (
		SELECT
			o.subscription_id
		FROM
			orders o
		WHERE o.status IN ('Active', 'Failed Payment 1', 'Failed Payment 2', 'Declined')
		AND o.subscription_id IS NOT NULL
	)
AND NOT
	s.subscription_id IN (
		SELECT
			o.subscription_id
		FROM
			orders o
		WHERE o.status = 'Processed'
		AND o.subscription_id IS NOT NULL
		AND o.order_id IN (
			SELECT
				i.order_id
			FROM
				invoices i
			WHERE i.order_id IS NOT NULL
			AND i.status IN ('Unfulfilled', 'InProgress')
		)
	)
AND s.subscription_id IN (
	SELECT
		o.subscription_id
	FROM
		orders o
	WHERE
		o.subscription_id IS NOT NULL);
