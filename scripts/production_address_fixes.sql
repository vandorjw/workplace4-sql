-- Update users with no shipping address with Subscription shipping_address
UPDATE
    users u
        JOIN
    subscriptions s ON s.user_id = u.user_id
	SET u.shipping_address = s.shipping_address
WHERE
    u.shipping_address IS NULL
        AND s.shipping_address IS NOT NULL;
		
-- Update users with no billing address with Subscription billing_address
UPDATE
    users u
        JOIN
    subscriptions s ON s.user_id = u.user_id
	SET u.billing_address = s.billing_address
WHERE
    u.billing_address IS NULL
        AND s.billing_address IS NOT NULL;
		
		
-- Update users with no shipping address with order shipping_address
UPDATE
    users u
        JOIN
    orders o ON o.user_id = u.user_id
	SET u.shipping_address = o.shipping_address
WHERE
    u.shipping_address IS NULL
        AND o.shipping_address IS NOT NULL;
		
-- Update users with no billing address with order billing_address
UPDATE
    users u
        JOIN
    orders o ON o.user_id = u.user_id
	SET u.billing_address = o.billing_address
WHERE
    u.billing_address IS NULL
        AND o.billing_address IS NOT NULL;
		
-- Set string NA postal codes to truLOCAL office address 		
UPDATE addresses SET 
	address_1 = '151 Charles Street West',
	address_2 = NULL,
	building_type = 'Office',
	city = 'Kitchener',
	state = 'ON',
	postal = 'N2G1H6'
WHERE postal = 'N/A';


-- Update users with no first name and last name
UPDATE users u
        JOIN
    (SELECT 
        *
    FROM
        orders
    GROUP BY user_id
    HAVING COUNT(DISTINCT first_name, last_name) = 1) o ON o.user_id = u.user_id 
SET 
    u.first_name = o.first_name,
    u.last_name = o.last_name
WHERE
    u.first_name = '' AND u.last_name = '';
	
	
-- Update users with different first name and last name on order
UPDATE users u
        JOIN
    (SELECT 
        *
    FROM
        orders
    GROUP BY user_id
    HAVING COUNT(DISTINCT first_name, last_name) = 1) o ON o.user_id = u.user_id 
SET 
    u.first_name = o.first_name,
    u.last_name = o.last_name
WHERE
    u.first_name <> o.first_name AND u.last_name <> o.last_name;
	
