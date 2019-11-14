subscriptions s

-- PART 1
SET
    s.next_billing_date =
    CASE
        -- EST --
        WHEN s.zone_id IN ('1','4') 
            THEN IF(TIME(s.next_billing_date) < '18:00:00',
                TIMESTAMP(DATE(s.next_billing_date), TIME('10:00')),
                TIMESTAMP(DATE_ADD(DATE(s.next_billing_date), INTERVAL 1 DAY), TIME('10:00'))
                )
        WHEN s.zone_id IN ('5') 
            THEN IF(TIME(s.next_billing_date) < '19:00:00',
                TIMESTAMP(DATE(s.next_billing_date), TIME('10:00')),
                TIMESTAMP(DATE_ADD(DATE(s.next_billing_date), INTERVAL 1 DAY), TIME('10:00'))
                )
        -- MST --
        WHEN s.zone_id IN ('2') 
            THEN IF(TIME(s.next_billing_date) < '20:00:00',
                TIMESTAMP(DATE(s.next_billing_date), TIME('10:00')),
                TIMESTAMP(DATE_ADD(DATE(s.next_billing_date), INTERVAL 1 DAY), TIME('10:00'))
                )
        -- PST --
        WHEN s.zone_id IN ('3') 
            THEN IF(TIME(s.next_billing_date) < '21:00:00',
                TIMESTAMP(DATE(s.next_billing_date), TIME('10:00')),
                TIMESTAMP(DATE_ADD(DATE(s.next_billing_date), INTERVAL 1 DAY), TIME('10:00'))
                )
    END
WHERE s.status IN ('Active', 'Skipped')
and s.next_billing_date is not NULL
and s.next_billing_date != '0000-00-00 00:00:00';

-- PART 2
UPDATE 
	orders o
left join subscriptions s on o.subscription_id=s.subscription_id
SET 
	o.billing_date = s.next_billing_date
WHERE o.subscription_id=s.subscription_id
AND o.status='Active'
AND o.subscription_id is not NULL;
