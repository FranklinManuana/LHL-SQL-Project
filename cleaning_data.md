What issues will you address by cleaning the data?

1.Cleaning the all_sessions table will require:
-Standardizing city and country names
-Filter out duplicates values
-Fix revenue units and round to the nearest cent.
-Filter out any NULL values
-Filter out rows with incomplete city and country values
-Filter out any rows in which the productsku that aren't following the GGOXXXXXXX format

2.Cleaning the analytics table will require:
-changing the visitid data type to text in order to match with visitid in all_sessions

3.Cleaning the sales_report talbe will require:
-Filter out any rows in which the productsku that aren't following the GGOXXXXXXX format
-Only using products in which the total_ordered is above 0

Queries:

1.Cleaning all_sessions table for revenue related questions.

(SELECT DISTINCT fullvisitorid,LOWER(TRIM(country)) as Country, LOWER(TRIM(city)) as City,
	ROUND(SUM(totaltransactionrevenue/1000000), 2) as total_transaction_revenue,productsku,
	ROUND((productprice/1000000), 2) as Product_Price,productname
FROM all_sessions
WHERE totaltransactionrevenue IS NOT NULL AND city NOT LIKE 'not%' AND city NOT LIKE '(not%' AND productsku LIKE 'GGO%'
GROUP BY city, country,productsku,productprice,productname,fullvisitorid
ORDER BY total_transaction_revenue DESC) AS cleaned_alls

2.Cleaning the analytics table for JOINs to answer time questions:
JOIN analytics
ON all_sessions.visitid = CAST(analytics.visitid AS text)

3.Cleaning the sales_report table for traffic source inquiry:
(SELECT * FROM sales_report WHERE productsku LIKE 'GGO%'AND total_ordered > 0) sr
