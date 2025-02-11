-- Question 1 - Closed Ended
--What are the top 5 brands by receipts scanned among users 21 and over?

WITH users_new AS (
    SELECT *,
        CASE
            WHEN BIRTH_DATE IS NULL OR BIRTH_DATE = '' THEN NULL  -- Skip null or empty values
            ELSE parse_datetime(substr(BIRTH_DATE, 1, 7), 'yyyy-MM') END as birth_year_month
    FROM users
),
tnx_filt AS (
SELECT t.*, un.birth_year_month
FROM transactions as t
INNER JOIN users_new as un
 on coalesce(t.user_id,'Null ID') = coalesce(un.id,'Null ID')
WHERE date_diff('year',un.birth_year_month, TIMESTAMP '2025-02-01 00:00:00') >= 21
),
prod_tnx_filt AS (
SELECT p.brand, count(distinct tf.receipt_id) as receipt_count
FROM tnx_filt as tf
LEFT JOIN products as p
 on coalesce(cast(tf.barcode as varchar),'NULL BARCODE') = coalesce(cast(p.barcode as varchar),'NULL BARCODE')
  -- handling the eventuality of a null value in barcode
WHERE p.brand is not null or p.brand != ''
GROUP BY 1
)
select *
from prod_tnx_filt
where brand != '' or brand is not null or brand != ' '
order by receipt_count desc
limit 5;



-- Question 2 - Closed Ended
-- What are the top 5 brands by sales among users that have had their account for at least six months?

WITH users_new AS (
    SELECT *,
        CASE
            WHEN created_date IS NULL OR created_date = '' THEN NULL  -- Handle null or empty values
            ELSE parse_datetime(substr(created_date, 1, 7), 'yyyy-MM') END as created_year_month
    FROM users
),
tnx_filt AS (
SELECT t.*, un.created_year_month
FROM transactions as t
INNER JOIN users_new as un
 on coalesce(t.user_id,'Null ID') = coalesce(un.id,'Null ID')
WHERE date_diff('month',un.created_year_month, TIMESTAMP '2025-02-01 00:00:00') >= 6
),
prod_tnx_filt AS (
SELECT brand, 
        sum(CASE
                WHEN final_sale = ' ' OR final_sale = '' THEN NULL  
                        -- Handle NaN, null, or empty strings
                ELSE CAST(final_sale AS DOUBLE)
            END) as sales
FROM tnx_filt as tf
LEFT JOIN products as p
 on coalesce(cast(tf.barcode as varchar),'NULL BARCODE') = coalesce(cast(p.barcode as varchar),'NULL BARCODE')
GROUP BY 1
)
select COALESCE(brand,'NULL, which shouldn''t be here but is') as brand, sales
from prod_tnx_filt
where brand != '' or brand is not null or brand != ' '
order by sales desc
limit 6;


-- Question 3 - Open Ended
-- Who are Fetch’s power users?

--I used the first portion, user_hist, in the below query to check user purchase amounts, distinct receipts and distinct scan dates; 
-- using amount is straightforward but I saw it has some outliers, i.e. users that are high spenders but not necessarily frequent scanners or shoppers. 
--I use distinct receipt counts to identify frequent shoppers and distinct scan date counts as a proxy for app usage

with user_hist as (
select t.user_id
       ,u.gender
       ,CASE
            WHEN BIRTH_DATE IS NULL OR BIRTH_DATE = '' THEN NULL  -- Skip null or empty values
            ELSE parse_datetime(substr(BIRTH_DATE, 1, 7), 'yyyy-MM') END as birth_year_month
       ,count(distinct receipt_id) as cnt_rec
       ,count(distinct parse_datetime(substr(scan_date,1,10),'YYYY-MM-DD')) as dist_scan_Date
       -- parsing just the date portion of the datetime field
       ,sum(CASE
                WHEN final_sale = ' ' OR final_sale = '' THEN NULL  
                        -- Handle NaN, null, or empty strings
                ELSE CAST(final_sale AS DOUBLE)
            END) as money_spent
from transactions as t
inner join users as u
 on u.id = t.user_id
group by 1,2,3
order by cnt_rec desc, dist_scan_Date desc, money_spent desc
),
percentiles as (
select approx_percentile(money_spent, 0.75) as money_spent_p,
       approx_percentile(dist_scan_Date, 0.75) as dist_scan_Date_p,
       approx_percentile(cnt_rec, 0.75) as cnt_rec_p
from user_hist
),
frequent_scanners as (
select user_id, gender, birth_year_month
from user_hist
where dist_scan_Date >= (SELECT dist_scan_Date_p from percentiles)
),
multi_item_shoppers as (
select user_id, gender, birth_year_month
from user_hist
where cnt_rec >= (SELECT cnt_rec_p from percentiles)
),
high_spenders as(
select user_id, gender, birth_year_month
from user_hist
where money_spent >= (SELECT money_spent_p from percentiles)
),
power_users as (
select a.user_id, a.gender, date_diff('year',a.birth_year_month, TIMESTAMP '2025-02-01 00:00:00')
from frequent_scanners as a
 inner join multi_item_shoppers as b
  on a.user_id = b.user_id
 inner join high_spenders as c
  on a.user_id = c.user_id
  )
select * from power_users;
  
