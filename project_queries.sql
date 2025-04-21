/*Q1. Which cities and countries have the highest level of transaction revenues on the site?*/

WITH cleaned_alls AS (SELECT DISTINCT fullvisitorid,LOWER(TRIM(country)) as Country, LOWER(TRIM(city)) as City,
	ROUND(SUM(totaltransactionrevenue/1000000), 2) as total_transaction_revenue,productsku,
	ROUND((productprice/1000000), 2) as Product_Price,productname,productquantity,productcategory
	FROM all_sessions
	WHERE totaltransactionrevenue IS NOT NULL AND city NOT LIKE 'not%' AND city NOT LIKE '(not%' AND productsku LIKE 'GGO%'
	GROUP BY city, country,productsku,productprice,productname,fullvisitorid,productquantity,productcategory
	ORDER BY total_transaction_revenue DESC)

SELECT Country,City, SUM(total_transaction_revenue) as TotalTransactionRevenue
FROM cleaned_alls
GROUP BY country,city
ORDER BY TotalTransactionRevenue DESC

/*Q2. What is the average number of products ordered from visitors in each city and country?*/
WITH cleaned_alls AS (SELECT DISTINCT fullvisitorid,LOWER(TRIM(country)) as Country, LOWER(TRIM(city)) as City,
	ROUND(SUM(totaltransactionrevenue/1000000), 2) as total_transaction_revenue,productsku,
	ROUND((productprice/1000000), 2) as Product_Price,productname,productquantity,productcategory
	FROM all_sessions
	WHERE totaltransactionrevenue IS NOT NULL AND city NOT LIKE 'not%' AND city NOT LIKE '(not%' AND productsku LIKE 'GGO%'
	GROUP BY city, country,productsku,productprice,productname,fullvisitorid,productquantity,productcategory
	ORDER BY total_transaction_revenue DESC)

SELECT LOWER(TRIM(city)) as city,LOWER(TRIM(country)) as country, 
ROUND(AVG(visitor_total_quantity), 2) as avg_products_ordered_per_visitor
FROM (
	SELECT DISTINCT fullvisitorid, city, country, SUM(productquantity) as visitor_total_quantity
	FROM cleaned_alls
	WHERE productquantity IS NOT NULL
	GROUP BY fullvisitorid, city, country) AS visitor_orders
WHERE city NOT LIKE '%not%'
GROUP BY city, country
ORDER BY avg_products_ordered_per_visitor DESC;

/*Q3. Is there any pattern in the types(product categories) of products ordered
from visitors in each city and country?*/

SELECT alls.productcategory, COUNT(alls.productcategory) as number_products_in_category, alls.country
FROM all_sessions alls
JOIN (SELECT DISTINCT fullvisitorid, productcategory,city,country FROM all_sessions
WHERE productcategory NOT LIKE '(not%') allss
ON alls.productcategory = allss.productcategory
WHERE alls.city NOT LIKE '%not%' AND alls.totaltransactionrevenue IS NOT NULL 
AND alls.productsku LIKE 'GGO%'
GROUP BY alls.productcategory, alls.country
ORDER BY alls.country, number_products_in_category DESC


/*Q4. What is the top-selling product from each city/country? Can we find 
any pattern worthy of noting in the products sold?*/
SELECT DISTINCT productname,LOWER(TRIM(city)) as city,LOWER(TRIM(country)) as country,
ROUND(SUM(totaltransactionrevenue / 1000000), 2) as total_product_revenue
FROM all_sessions
WHERE totaltransactionrevenue IS NOT NULL AND city NOT LIKE 'not%' AND city NOT LIKE '(not%' AND productsku LIKE 'GGO%'
GROUP by productname,country,city
ORDER BY total_product_revenue DESC

/*Q5. Can we summary the impact of revene generated from each city/country?*/
SELECT productname,alls.productsku, LOWER(TRIM(city)) as city, LOWER(TRIM(country)) as country,
ROUND((totaltransactionrevenue/1000000),2) AS TotalTransactionRevenue,channelgrouping
FROM all_sessions alls
JOIN (SELECT * FROM sales_report WHERE productsku LIKE 'GGO%'AND total_ordered > 0) sr
ON alls.productsku = sr.productsku
WHERE city NOT LIKE 'not%' and city NOT LIKE '(not%' AND totaltransactionrevenue IS NOT NULL AND alls.productsku LIKE 'GGO%'
ORDER BY channelgrouping

/*Q6. Timespent on site and purchase amount*/

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


/* Q7 Which product generated the most revenue for each minute visitors spent on site? */
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


/*Q8. What is the average amount of time spent on the website for completed transactions?  */
SELECT DISTINCT ROUND(SUM(analytics.timeonsite/60)) as TotalTime_Minutes,ROUND(AVG(analytics.timeonsite/60),0) as Average_Time_Minutes
FROM all_sessions
JOIN analytics
ON all_sessions.visitid = CAST(analytics.visitid AS text)
WHERE productprice = unit_price AND all_sessions.productsku LIKE 'GGO%' AND totaltransactionrevenue IS NOT NULL
AND city NOT LIKE 'not%' AND city NOT LIKE '(not%'


/*Q9. What traffic source is generating the most revenue for the website */
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
