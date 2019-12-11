SELECT
	u.user_id,
	REPLACE(u.email, ' ', '|') as shitty_email,
	s.status as subscription_status
FROM users u left join subscriptions s on 
	u.user_id=s.user_id
WHERE 
	(u.email NOT REGEXP '^[^@]+@[^@]+\.[^@]{2,}$') or 
	(u.email like '% %')
;
