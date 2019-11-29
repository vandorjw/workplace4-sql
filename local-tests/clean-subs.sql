delete op.* from order_products op
where op.order_id in (
select distinct(o.order_id) from subscriptions s left join orders o on 
s.subscription_id=o.subscription_id
where s.status in ('Cancelled', 'Skipped', 'Pending/Failed', 'Payment Failed'));


delete o.* from subscriptions s left join orders o on 
s.subscription_id=o.subscription_id
where s.status in ('Cancelled', 'Skipped', 'Pending/Failed', 'Payment Failed');


delete sa.* from subscriptions s left join subscription_addons sa on 
s.subscription_id=sa.subscription_id
where s.status in ('Cancelled', 'Skipped', 'Pending/Failed', 'Payment Failed');


delete sa.* from subscriptions s left join surveys on 
s.subscription_id=surveys.subscription_id
left join survey_answers sa on
surveys.survey_id=sa.survey_id
where s.status in ('Cancelled', 'Skipped', 'Pending/Failed', 'Payment Failed');


delete surveys.* from subscriptions s left join surveys on 
s.subscription_id=surveys.subscription_id
where s.status in ('Cancelled', 'Skipped', 'Pending/Failed', 'Payment Failed');

delete s.* from subscriptions s where s.status in ('Cancelled', 'Skipped', 'Pending/Failed', 'Payment Failed');
