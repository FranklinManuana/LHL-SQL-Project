--1. Remove Duplicates
-- 2. standardize the data
-- 3. Null values or blank values
-- 4. Remove Any Columns 



/* all_sessions data discrepancies*/
SELECT * FROM all_sessions --> 15134 rows
SELECT DISTINCT fullvisitorid FROM all_sessions --> 14223 rows
SELECT DISTINCT productsku FROM all_sessions --> 536 rows
SELECT * FROM all_sessions WHERE totaltransactionrevenue IS NOT NULL


/*
NULL columns(
-totaltransactionrevenue,
-transcations,
-productrefundamount,
-productquantity,
-productrevenue
-itemquantity
-itemrevenue
-transactionrevenue
-transactionid)


Not set or not available rows in city and country columns
*/




/*---------------------------------------------------------------------*/
/* analytics data discrepancies*/
SELECT * FROM analytics --> 4301122 rows
SELECT DISTINCT fullvisitorid FROM analytics --> 120018 rows
SELECT DISTINCT fullvisitorid, (unit_price/1000000) AS unit_prices, units_sold 
FROM analytics WHERE units_sold IS NOT NULL -->42747 rows

/* NULL columns( userid, units_sold, timeonsite, revenue)*/
/* unit_price needs to be divided by 1,000,000 and rounded to two decimal places*/
/* duplicated data for fullvisitorid/visitnumber */
/*date format incorrect(numeric instead of timestamp)*/

/* products data discrepancies*/
SELECT * FROM products ORDER BY orderedquantity -- 1092 rows
SELECT * FROM products WHERE orderedquantity > 0 --> 901 rows



/*sales_by_sku data discrepancies*/
SELECT * FROM sales_by_sku --> 462 rows
SELECT * FROM sales_by_sku WHERE total_ordered > 0 --> 306 rows
SELECT productSKU FROm sales_by_sku

/* sales_report*/
SELECT * FROM sales_report --> 454 rows
SELECT * FROM sales_report WHERE total_ordered > 0 --> 304 rows


/* analytics and all_sessions test to calculate alternate total revenue*/
SELECT DISTINCT fullvisitorid, (unit_price/1000000) AS unit_prices, units_sold 
FROM analytics WHERE units_sold IS NOT NULL -->42747 rows
-------------------------------------------------------------------------------------------
/* explore pricing relationship between all_sessions and analytics*/ 
SELECT DISTINCT productname,productsku,productprice,unit_price,totaltransactionrevenue,
pagetitle,LOWER(TRIM(city)) AS City,LOWER(TRIM(country)) AS Country
FROM all_sessions
JOIN analytics
ON all_sessions.visitid = CAST(analytics.visitid AS text)
WHERE productprice = unit_price AND all_sessions.productsku LIKE 'GGO%' AND totaltransactionrevenue IS NOT NULL

--------------------------------------------------------------------------------------------
/* further explore pricing relationship in the context of revenue calculated from price and order.*/
SELECT DISTINCT productname,all_sessions.productsku,productprice,unit_price,units_sold,totaltransactionrevenue,
pagetitle,LOWER(TRIM(city)) AS City,LOWER(TRIM(country)) AS Country
FROM all_sessions
JOIN analytics
ON all_sessions.visitid = CAST(analytics.visitid AS text)
JOIN sales_report
ON all_sessions.productsku = sales_report.productsku
WHERE productprice = unit_price AND all_sessions.productsku LIKE 'GGO%'

--------------------------------------------------------------------------------------------------------------
/* explore pricing relationship between all_sessions and analytics*/ 
SELECT DISTINCT productname,productsku,ROUND((productprice/1000000),2) AS productprice,
ROUND((totaltransactionrevenue/1000000),2) as totaltransactionrevenue,
analytics.timeonsite,ROUND(((totaltransactionrevenue / analytics.timeonsite)/1000000),2) as Revenue_per_minute_on_site,
LOWER(TRIM(city)) AS City,LOWER(TRIM(country)) AS Country
FROM all_sessions
JOIN analytics
ON all_sessions.visitid = CAST(analytics.visitid AS text)
WHERE productprice = unit_price AND all_sessions.productsku LIKE 'GGO%' AND totaltransactionrevenue IS NOT NULL
AND city NOT LIKE 'not%' AND city NOT LIKE '(not%'
-----------------------------------------------------------------------------------------------------
SELECT DISTINCT productname,productsku,ROUND((productprice/1000000),2) AS productprice,
ROUND((totaltransactionrevenue/1000000),2) as totaltransactionrevenue,
analytics.timeonsite,ROUND(((totaltransactionrevenue / analytics.timeonsite)/1000000),2) as Revenue_per_minute_on_site,
LOWER(TRIM(city)) AS City,LOWER(TRIM(country)) AS Country
FROM all_sessions
JOIN analytics
ON all_sessions.visitid = CAST(analytics.visitid AS text)
WHERE productprice = unit_price AND all_sessions.productsku LIKE 'GGO%' AND totaltransactionrevenue IS NOT NULL
AND city NOT LIKE 'not%' AND city NOT LIKE '(not%'


------------------------- All Sessions and Analytics View---------------------------------------------
SELECT alls.fullvisitorid,productname,productsku, revenue,LOWER(TRIM(city)) AS city, LOWER(TRIM(country)) AS country
FROM all_sessions alls
JOIN(
SELECT DISTINCT fullvisitorid,SUM((revenue/1000000)) AS revenue
FROM analytics
WHERE revenue IS NOT NULL
GROUP BY fullvisitorid) analytics
ON alls.fullvisitorid = CAST(analytics.fullvisitorid as text)
WHERE productsku LIKE 'GGO%' AND city NOT LIKE 'not%' AND city NOT LIKE '(not%'

/* idead query */
-------------Viewing the amount of time spent on the site based off of product category--------
SELECT alls.productcategory, COUNT(alls.productcategory) as number_products_in_category, alls.country,
SUM(alls.timeonsite) as timeonsite,
ROUND(SUM(alls.totaltransactionrevenue/1000000),2) as Category_Revenue 
FROM all_sessions alls
JOIN (SELECT DISTINCT fullvisitorid, productcategory,city,country FROM all_sessions) allss
ON alls.productcategory = allss.productcategory
WHERE alls.city NOT LIKE '%not%' AND alls.totaltransactionrevenue IS NOT NULL
GROUP BY alls.productcategory, alls.country
ORDER BY number_products_in_category,timeonsite ASC

----------------------------------- All sessions and sales report ------------------------------
SELECT productname,alls.productsku, LOWER(TRIM(city)) as city, LOWER(TRIM(country)) as country,
ROUND((totaltransactionrevenue/1000000),2) AS TotalTransactionRevenue
FROM all_sessions alls
JOIN (SELECT * FROM sales_report WHERE productsku LIKE 'GGO%'AND total_ordered > 0) sr
ON alls.productsku = sr.productsku
WHERE city NOT LIKE 'not%' and city NOT LIKE '(not%' AND totaltransactionrevenue IS NOT NULL


SELECT fullvisitorid FROM all_sessions
