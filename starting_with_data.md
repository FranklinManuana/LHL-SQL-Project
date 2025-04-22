
Question 6: What realtionship do we see between the products which generated revenue and the time spent on the site? 

SQL Queries:
```
SELECT country,city, SUM(total_transaction_revenue) as TotalTransactionRevenue,
productname,SUM(timeonsite) as timeonsite
FROM 
	(SELECT DISTINCT fullvisitorid, LOWER(TRIM(country)) as Country, LOWER(TRIM(city)) as City,
	ROUND(SUM(totaltransactionrevenue/1000000), 2) as total_transaction_revenue,productsku,
	ROUND((productprice/1000000), 2) as Product_Price,productname,SUM(timeonsite) as timeonsite
	FROM all_sessions
	WHERE totaltransactionrevenue IS NOT NULL AND city NOT LIKE 'not%' AND city NOT LIKE '(not%' AND productsku LIKE 'GGO%'
	GROUP BY city, country,productsku,productprice,productname,fullvisitorid
	ORDER BY total_transaction_revenue DESC) AS cleaned_alls
GROUP BY country,city,productname
ORDER BY timeonsite DESC
```
Answer: We notice that the top 3 items with the most time onsite are clothing products.


Question 2: Which product generated the most revenue for each minute visitors spent on site?

SQL Queries:
```
SELECT DISTINCT productname,productsku,ROUND((productprice/1000000),2) AS productprice,
ROUND((totaltransactionrevenue/1000000),2) as totaltransactionrevenue,
ROUND((analytics.timeonsite/60)) as timeonesite_minutes,ROUND(((totaltransactionrevenue / (analytics.timeonsite/60))/1000000),2) as Revenue_per_minute_on_site,
LOWER(TRIM(city)) AS City,LOWER(TRIM(country)) AS Country
FROM all_sessions
JOIN analytics
ON all_sessions.visitid = CAST(analytics.visitid AS text)
WHERE productprice = unit_price AND all_sessions.productsku LIKE 'GGO%' AND totaltransactionrevenue IS NOT NULL
AND city NOT LIKE 'not%' AND city NOT LIKE '(not%'
ORDER BY  revenue_per_minute_on_site DESC
```

Answer: SPF lip balm generates the most revenue per minute comapred to other purchased products from visitors.


Question 3: What is the average amount of time spent on the website for completed transactions?

SQL Queries:
```
SELECT DISTINCT ROUND(SUM(analytics.timeonsite/60)) as TotalTime_Minutes,ROUND(AVG(analytics.timeonsite/60),0) as Average_Time_Minutes
FROM all_sessions
JOIN analytics
ON all_sessions.visitid = CAST(analytics.visitid AS text)
WHERE productprice = unit_price AND all_sessions.productsku LIKE 'GGO%' AND totaltransactionrevenue IS NOT NULL
AND city NOT LIKE 'not%' AND city NOT LIKE '(not%'
```

Answer: Takes on average time for a visitor to complete a transaction is 12 minutes.


Question 4: What traffic source is generating the most revenue for the website?

SQL Queries:
```
SELECT productname,alls.productsku, LOWER(TRIM(city)) as city, LOWER(TRIM(country)) as country,
ROUND((totaltransactionrevenue/1000000),2) AS TotalTransactionRevenue,channelgrouping
FROM all_sessions alls
JOIN (SELECT * FROM sales_report WHERE productsku LIKE 'GGO%'AND total_ordered > 0) sr
ON alls.productsku = sr.productsku
WHERE city NOT LIKE 'not%' and city NOT LIKE '(not%' AND totaltransactionrevenue IS NOT NULL AND alls.productsku LIKE 'GGO%'
ORDER BY channelgrouping

SELECT analytics.channelgrouping,SUM(ROUND((totaltransactionrevenue/1000000),2)) as totaltransactionrevenue,
COUNT(analytics.channelgrouping) as number_of_transactions_by_channel_grouping
FROM all_sessions
JOIN analytics
ON all_sessions.visitid = CAST(analytics.visitid AS text)
WHERE productprice = unit_price AND all_sessions.productsku LIKE 'GGO%' AND totaltransactionrevenue IS NOT NULL
AND city NOT LIKE 'not%' AND city NOT LIKE '(not%'
GROUP BY analytics.channelgrouping
ORDER BY totaltransactionrevenue DESC
```
Answer: Referral traffic generated the most revenue whereas paid searches were the least profitable.


