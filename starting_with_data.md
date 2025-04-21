
Question 1: What realtionship do we see between the products which generated revenue and the time spent on the site? 

SQL Queries:

SELECT country,city, SUM(total_transaction_revenue) as TotalTransactionRevenue,
productname,SUM(timeonsite) as timeonsite
FROM (SELECT DISTINCT LOWER(TRIM(country)) as Country, LOWER(TRIM(city)) as City,
ROUND(SUM(totaltransactionrevenue/1000000), 2) as total_transaction_revenue,productsku,
ROUND((productprice/1000000), 2) as Product_Price,productname,SUM(timeonsite) as timeonsite
FROM all_sessions
WHERE totaltransactionrevenue IS NOT NULL AND city NOT LIKE '%not%'
GROUP BY city, country,productsku,productprice,productname
ORDER BY total_transaction_revenue DESC) AS cleaned_alls
GROUP BY country,city,productname
ORDER BY TotalTransactionRevenue DESC

Answer:


Question 2: What is the relationship between the time spend on the site and the revenue generated from the products visitors purchased? 

SQL Queries:

SELECT DISTINCT productname,productsku,ROUND((productprice/1000000),2) AS productprice,
ROUND((totaltransactionrevenue/1000000),2) as totaltransactionrevenue,
analytics.timeonsite,ROUND(((totaltransactionrevenue / analytics.timeonsite)/1000000),2) as Revenue_per_minute_on_site,
LOWER(TRIM(city)) AS City,LOWER(TRIM(country)) AS Country
FROM all_sessions
JOIN analytics
ON all_sessions.visitid = CAST(analytics.visitid AS text)
WHERE productprice = unit_price AND all_sessions.productsku LIKE 'GGO%' AND totaltransactionrevenue IS NOT NULL
AND city NOT LIKE 'not%' AND city NOT LIKE '(not%'

Answer: 

Products with the highest timeonsite are generating the least revenue. 



Question 3: 

SQL Queries:

Answer:




