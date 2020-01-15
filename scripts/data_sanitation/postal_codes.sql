-- identify sad postal codes
select distinct(postal) 
from addresses a 
where not (
	(postal REGEXP '^[A-Z][0-9][A-Z][0-9][A-Z][0-9]$') or 
	(postal REGEXP '^[0-9][0-9][0-9][0-9][0-9]$')
);

-- identify sad postal codes
select
	distinct(postal_code)
from
	postal_codes pc
where not (
	(postal_code REGEXP '^[A-Z][0-9][A-Z][0-9][A-Z][0-9]$') or
	(postal_code REGEXP '^[0-9][0-9][0-9][0-9][0-9]$')
);


-- fix dudes with space, tabs, newlines, linereturns, hypens and other sadness 
update addresses a set a.postal=TRIM(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(UPPER(a.postal), " ", ""), "-", ""), ",", ""), "\t", ""), "\n", ""), "\r", ""));
