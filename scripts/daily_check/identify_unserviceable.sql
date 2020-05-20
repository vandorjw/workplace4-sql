select * from 
subscriptions s 
left join addresses a on 
s.shipping_address=a.address_id 
left join 
(select 
	s_pc.code, sum(is_serviced) as total_couriers
from 
	shipping_postalcode s_pc 
left join shipping_servicearea s_sa on 
	s_pc.id = s_sa.postal_code_id 
inner join shipping_servicehistory s_sh on
	s_sa.id = s_sh.service_area_id
inner join (select
	s_sh.service_area_id, 
	MAX(s_sh.`timestamp`) as newestRecord
from
	shipping_servicehistory s_sh
group by s_sh.service_area_id) as histories on 
s_sh.service_area_id=histories.service_area_id
and
s_sh.`timestamp`=histories.newestRecord
group by s_pc.code 
having total_couriers=0) as unserviceable on 
a.postal=unserviceable.code
where s.status='Active'
and unserviceable.total_couriers is not null;
