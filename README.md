# Final-Project-Transforming-and-Analyzing-Data-with-SQL

## Project/Goals
This exploratory query analysis aims to find patterns in the e-commerce website data collected thus far. The objective is broken down into overall revenue generation and lead products generating the most revenue. Upon filtering for things such as city and country, we can see trends in purchasing preferences in different regions and which products are worth keeping.
With the database compiled from the provided data, we will also see if the website inventory should become specialized to reflect customers' shopping preferences.

## Process
Before proceeding with any exploratory data analysis, an overview of the current situation needs to be done to gauge the database's limitations and identify the main tables of interest. The limitations would be any incongruence that prevents data consolidation, such as duplicates, missing values, incorrect data entry, or typing.
When examining the tables for the e-commerce database, we see that all_sessions has the largest column count, and many of its columns are found in other tables. The analytics table is the largest table based on row count, yet it has the most duplicates and many columns unnecessary for our inquiries. All_ sessions designated as the nexus table for our analytical foray will need to undergo the most cleaning.
After outlining the cleaning issues for all sessions, the investigation was subdivided into two parts: 1) an overview of product revenue, popularity, and region preferences, and 2) the insights from part 1 spurred further investigation into the website visit duration and website traffic sources.

## Results
The first part of the investigation around revenue generated by the website provided three key observations that stuck out: 1) Most of the website's revenue came from the United States, 2) NEST products accounted for a significant portion of sales, and 3) Low production cost items such as the reusable bags and lip balm were the highest single revenue items.
Insights generated from the revenue exploration led to a supplementary examination of website visit length and traffic flow. This exploration path showed that most of the website's revenue traffic was funnelled by direct and referral channels. This means that a certain level of intentionality on the customer's part was present in their purchases with particular interest in smart home appliences.

## Challenges 
The biggest challenge for this exploration was filtering the all_sessions and analytics tables for analysis, as they had the most duplicates and null values spanning multiple columns. The second challenge was making sense of the units of measurement for both temporal and prices, leading to some assumptions. Regarding the time value, the assumption was that the data was entered for seconds.

## Future Goals
A future goal would be to explore how many products can be removed from inventory based on customer purchases and site engagement. This would lead to the possibility of specializing the website store to reduce losses incurred from holding onto products that don't sell.
