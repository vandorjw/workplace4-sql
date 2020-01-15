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

DELIMITER $$
CREATE TRIGGER trig_email_check BEFORE INSERT ON users
FOR EACH ROW 
BEGIN 
IF (NEW.email REGEXP '^[^@]+@[^@]+\.[^@]{2,}$' ) = 0 THEN 
  SIGNAL SQLSTATE '12345'
     SET MESSAGE_TEXT = "bad email format";
END IF; 
END$$
DELIMITER ;
