SELECT CASE
           WHEN t.log_id > 1234567890 THEN 'NEW'
           ELSE 'KNOWN'
       END AS alert_status
       ,o.first_name
       ,o.last_name
       ,o.user_id
       ,o.order_id
       ,o.status
       ,o.billing_date
       ,o.receipt_id
    -- ,t.log_id
    -- ,t.log
FROM orders o
LEFT JOIN
  (SELECT max(log_id) AS log_id,
          log,
          SUBSTRING(log, 19, 26) AS order_id
   FROM activity_log
   WHERE TYPE = 'Payment'
     AND log_date >= DATE('2021-01-01')
     AND endpoint = 'order payment'
     AND status = 'success'
   GROUP BY order_id
   HAVING COUNT(DISTINCT log_id) > 1) AS t ON o.order_id=t.order_id
WHERE t.log_id IS NOT NULL
ORDER BY t.log_id DESC;

