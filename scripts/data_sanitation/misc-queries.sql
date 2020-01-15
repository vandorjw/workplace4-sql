-- Promo codes not in the promo codes table
SELECT 
    *
FROM
    orders o
        LEFT JOIN
    promo_codes pc ON pc.promo_code = o.promo_code
WHERE
    o.status = 'Active'
        AND o.order_type = 'Subscription'
        AND o.promo_code IS NOT NULL
        AND pc.promo_code IS NULL;
		
		
-- Get promo code products with no product for zone/plan combo
SELECT 
    t1.promo_code,
    sp.title,
    z.name
FROM
    (SELECT DISTINCT
        o.promo_code, s.plan_id, o.zone_id
    FROM
        orders o
    LEFT JOIN subscriptions s ON s.subscription_id = o.subscription_id
    JOIN promo_codes pc ON pc.promo_code = o.promo_code
    WHERE
        o.status = 'Active'
            AND o.order_type = 'Subscription'
            AND o.promo_code IS NOT NULL
            AND pc.promo_code IS NOT NULL
            AND o.promo_code IN (SELECT DISTINCT
                promo_code
            FROM
                promo_code_products)) t1
        LEFT JOIN
    promo_code_products pcp ON pcp.promo_code = t1.promo_code
        AND pcp.zone_id = t1.zone_id
		AND pcp.plan_id = t1.plan_id
        LEFT JOIN
    zones z ON z.zone_id = t1.zone_id
        LEFT JOIN
    subscription_plans sp ON sp.plan_id = t1.plan_id
WHERE
    promo_code_product_id IS NULL;
