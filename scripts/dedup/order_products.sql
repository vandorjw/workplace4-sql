DELETE
	n1.*
FROM
	order_products n1,
	order_products n2
WHERE
	n1.order_id in (
	select
		DISTINCT(order_id)
	from
		(
		SELECT
			order_id,
			product_id,
			addon,
			promo_code,
			quantity,
			date_added,
			product_comped,
			comped_by,
			note_product_id,
			count(*) as a
		FROM
			order_products
		group by
			order_id,
			product_id,
			addon,
			promo_code,
			quantity,
			date_added,
			product_comped,
			comped_by,
			note_product_id
		having
			a > 1) as dups )
	AND n1.order_product_id > n2.order_product_id
	AND n1.order_id = n2.order_id
	AND n1.product_id = n2.product_id
	AND n1.addon = n2.addon
	AND ((n1.promo_code = n2.promo_code) or (n1.promo_code is Null and n2.promo_code is null))
	AND n1.quantity = n2.quantity
	AND n1.date_added = n2.date_added
	AND ((n1.product_comped = n2.product_comped) or (n1.product_comped is null and n2.product_comped is null))
	AND ((n1.comped_by = n2.comped_by) or (n1.comped_by IS NULL and n2.comped_by IS NULL))
	AND ((n1.note_product_id = n2.note_product_id) or (n1.note_product_id is NULL and n2.note_product_id is NULL));
