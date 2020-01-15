-- Delete order_products with a promo code
DELETE FROM order_products 
WHERE
    order_product_id IN (select order_product_id from (SELECT DISTINCT
        order_product_id
    FROM
        order_products op
            LEFT JOIN
        orders o ON o.order_id = op.order_id
    
    WHERE
        op.promo_code IS NOT NULL
        AND o.status = 'Active') t1);


-- Insert order_products with a promo code
INSERT IGNORE INTO order_products (order_id, product_id, addon, promo_code, quantity, date_added,
product_comped, comped_by, note_product_id)
SELECT 
    o.order_id,
    pcp.product_id,
    1 as addon,
    pcp.promo_code,
    pcp.quantity,
    utc_timestamp() as date_added,
    0 as product_comped,
    NULL as comped_by,
    NULL as note_product_id
FROM
    orders o
        JOIN
    subscriptions s ON s.subscription_id = o.subscription_id
        JOIN
    promo_code_products pcp ON pcp.promo_code = o.promo_code
        AND pcp.zone_id = o.zone_id
        AND s.plan_id = pcp.plan_id
        LEFT JOIN
    (SELECT 
        o.subscription_id,
            o.promo_code,
            COUNT(DISTINCT o.order_id) AS redemptions
    FROM
        orders o
    WHERE
        o.status = 'Processed'
            AND o.promo_code IS NOT NULL
            AND o.subscription_id IS NOT NULL
    GROUP BY o.subscription_id , o.promo_code) t1 ON t1.subscription_id = o.subscription_id
        AND t1.promo_code = o.promo_code
WHERE
    o.status = 'Active'
        AND o.order_type = 'Subscription'
        AND ((CAST(pcp.duration AS UNSIGNED) > t1.redemptions)
        OR (pcp.duration IN ('-1' , 'forever'))
        OR (redemptions IS NULL));
