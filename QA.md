What are your risk areas? Identify and describe them.

The biggest risk areas with the CSV files provided for the database were:
- Irrelevant data 
- Lack of standardization 
- Redundancies/Duplications
- Missing values
- Data entry errors.


QA Process:
Describe your QA process and include the SQL queries used to execute it.


The risk of using irrelevant data was overcame by doing an initial overview of the data provided to see which tables had the columns of interest for the exploration.

SQL query:
<!--
SELECT * FROM all_sessions
SELECT * FROM analytics
SELECT * FROM products
SELECT * FROM sales_by_sku
SELECT * FROM sales_report
-->

The overview showed that out of the five tables generated, these three were of the most use.

1. all_sessions would be the main table for the exploration as it had multiple columns that were both revelent to the project inqueries and was present across the other tables which would facilitate any joining demands to explore relationships.

2. The analytics table was large but had a lot of duplications, entries errors and null values. However it possesed visitid, timeonsite, and channelgrouping columns which would prove useful for exploring the relationships between revenue,retention, and traffic-flow.

3. The sales_report table had columns with order details that could be used to validate transaction amounts. 

The following step was to standardize the values across the tables of interest in order to run accurate aggregations of the data. Standardization for location values by lowercasing and removing space ensured that queries don't treat one location as multiple because of key entry variation.

SQL query:
<!-- LOWER(TRIM(country)) as Country, LOWER(TRIM(city)) as City -->

From there value units needed to be clarified due to the time and price values being expoenentially larger than the order numbers. The unit price in analytics needed to be divided by 1,000,000 providing a more grounded dollar value. This division was applied to price parameters across the different tables whenever a query requires revenue data. The values were also rounded to 2 decimal points to have the nearest cent value.

SQL query: 
<!-- ROUND((totaltransactionrevenue/1000000),2) -->

timeonsite values were manipulated under the assumption that they would have been entered in seconds.

From there the following text parmeter that needed to be standardized was the productsku. Viewing the productsku across the different tables revealed a pattern of 'GGOXXXXXXXXX'. Lastly any rows containing either NULL or incorrect values from columns of interest were then filtered out through the WHERE statement. 

The above quality assurance enables exploring the relationship between the three tables of interest while building the foundation for different cleaning queries implemented in the project.

SQL queries:
<!-- /*All sessions and analytics relationship*/

SELECT alls.fullvisitorid,productname,productsku, revenue,LOWER(TRIM(city)) AS city, LOWER(TRIM(country)) AS country
FROM all_sessions alls
JOIN(
SELECT DISTINCT fullvisitorid,SUM((revenue/1000000)) AS revenue
FROM analytics
WHERE revenue IS NOT NULL
GROUP BY fullvisitorid) analytics
ON alls.fullvisitorid = CAST(analytics.fullvisitorid as text)
WHERE productsku LIKE 'GGO%' AND city NOT LIKE 'not%' AND city NOT LIKE '(not%'


-->
 
<!-- /*All sessions and sales report relationship*/


SELECT productname,alls.productsku, LOWER(TRIM(city)) as city, LOWER(TRIM(country)) as country,
ROUND((totaltransactionrevenue/1000000),2) AS TotalTransactionRevenue
FROM all_sessions alls
JOIN (SELECT * FROM sales_report WHERE productsku LIKE 'GGO%'AND total_ordered > 0) sr
ON alls.productsku = sr.productsku
WHERE city NOT LIKE 'not%' and city NOT LIKE '(not%' AND totaltransactionrevenue IS NOT NULL

-->




