delete l.* from leads l where l.email is Null or l.email='';

delete l.* from leads l left join users u on 
l.user_id=u.user_id
where u.password='no password';
