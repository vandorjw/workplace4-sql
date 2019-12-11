-- identify shitty emails
SELECT
	u.user_id,
	REPLACE(REPLACE(REPLACE(REPLACE(u.email, ' ', '[SPACE]'), '\t', '[TAB]'), '\n', '[NEWLINE]'), ',', '[COMMA]')  as shitty_email
FROM users u 
WHERE 
	u.email NOT REGEXP '^[^@]+@[^@]+\.[^@]{2,}$' or 
	u.email like '% %' or
	u.email like '%\t%' or
	u.email like '%\n%' or
	u.email like '%#%' or 
	u.email like '%,%'
;
