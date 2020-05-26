-- This nested query does the following:
-- a) grabs all serviced postal_codes by doing a self-join on shipping_servicehistory to get the most up-to-date service record.
-- b) Join these history records with service-area records and filtering down to postal_codes where the only courier is COURIER. (shipper_id=4)
-- c) join those postal_code records on the shipping_address of a subscription. (This should get only those subscription where COURIER is the only courier.
-- d) subscription must be active.
-- e) join with user table to retreive the email address.

select
	s.subscription_id,
	a.postal,
	a.city,
	a.state,
	CONCAT(a.first_name, " ", a.last_name) as full_name,
	u.email
from
	subscriptions s
left join addresses a on
	s.shipping_address = a.address_id
inner join (
	select
		code
	from
		workplace_shipping.shipping_postalcode sp
	inner join (
		select
			postal_code_id, shipper_id
		from
			(
			select
				s_sa.postal_code_id, s_sa.shipper_id
			from
				workplace_shipping.shipping_servicehistory s_sh
			inner join (
				select
					s_sh.service_area_id, MAX(s_sh.`timestamp`) as newestRecord
				from
					workplace_shipping.shipping_servicehistory s_sh
				group by
					s_sh.service_area_id) as histories on
				s_sh.service_area_id = histories.service_area_id
				and s_sh.`timestamp` = histories.newestRecord
			inner join workplace_shipping.shipping_servicearea s_sa on
				s_sh.service_area_id = s_sa.id
			where
				s_sh.is_serviced = 1) as serviced_postal_codes
		group by
			serviced_postal_codes.postal_code_id
		having
			shipper_id = 31337) as COURIER_only_codes on  -- REPLACE ID with the ID of courier we are looking for!
		sp.id = COURIER_only_codes.postal_code_id) as shipping on
	a.postal = shipping.code
left join users u on
	s.user_id = u.user_id
where
	s.status = 'Active'
order by
	a.state,
	u.email;
