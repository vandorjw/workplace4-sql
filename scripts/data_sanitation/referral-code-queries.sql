-- Update empty string referral codes
UPDATE users SET referral_code = NULL where referral_code = '';

-- Insert referral_codes into promo_codes table
INSERT into promo_codes (promo_code, description, date_created, created_by, redemptions_count,
duration, status, status_date, type)
SELECT 
    referral_code,
    CONCAT('referral_code for ',
            first_name,
            ' ',
            last_name) AS description,
    create_date AS date_created,
    user_id AS created_by,
    0 AS redemptions_count,
    1 AS duration,
    'active' AS status,
    UTC_TIMESTAMP() AS status_date,
    'referral' AS type
FROM
    users
WHERE
    referral_code NOT IN (SELECT DISTINCT
            promo_code
        FROM
            promo_codes);
			
