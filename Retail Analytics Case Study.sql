/* Question 1. "Total Sales Summary"
Write a SQL query to summarize the total sales and quantities sold per product by the company.*/

select 
Productid, SUM(Quantitypurchased) as TotalUnitsSold, 
round(sum(Quantitypurchased*price),2) as TotalSales 
from sales_transaction 
group by productid 
order by totalsales desc 
limit 10;
/* 		OUTPUT:
					+-----------+----------------+------------+
					| Productid | TotalUnitsSold | TotalSales |
					+-----------+----------------+------------+
					|        17 |            100 |       9450 |
					|        87 |             92 |    7817.24 |
					|       179 |             86 |    7388.26 |
					|        96 |             72 |    7132.32 |
					|        54 |             86 |    7052.86 |
					|       187 |             82 |    6915.88 |
					|       156 |             76 |    6827.84 |
					|        57 |             78 |     6622.2 |
					|       200 |             69 |    6479.79 |
					|       127 |             68 |     6415.8 |
					+-----------+----------------+------------+
*/

/* Question 2. "Customer Purchase Frequency"
Write a SQL query to count the number of transactions per customer to understand purchase frequency.*/

select 
customerid, 
count(transactionid) as NumberOfTransactions 
from sales_transaction 
group by customerid 
order by NumberOfTransactions desc
limit 10;
/*		OUTPUT:
						+------------+----------------------+
						| customerid | NumberOfTransactions |
						+------------+----------------------+
						|        664 |                   14 |
						|        670 |                   12 |
						|        958 |                   12 |
						|         99 |                   12 |
						|        936 |                   12 |
						|        929 |                   12 |
						|        113 |                   12 |
						|         39 |                   12 |
						|        727 |                   11 |
						|        648 |                   11 |
						+------------+----------------------+
*/

/* Question 3. "Product Categories Performance"
Write a SQL query to evaluate the performance of the product categories based on the total sales 
which help us understand the product categories which needs to be promoted in the marketing campaigns.*/

select p.category,
SUM(s.Quantitypurchased) as TotalUnitsSold, 
sum(s.Quantitypurchased* s.price) as TotalSales
 from sales_transaction s 
 join product_inventory p 
 on s.productid= p.productid 
 group by p.category 
 order by TotalSales desc;
/*		OUTPUT:
					+-----------------+----------------+--------------------+
					| category        | TotalUnitsSold | TotalSales         |
					+-----------------+----------------+--------------------+
					| Home & Kitchen  |           3477 | 217755.94000000026 |
					| Electronics     |           3037 | 177548.48000000007 |
					| Clothing        |           2810 | 162874.21000000005 |
					| Beauty & Health |           3001 | 143824.98999999947 |
					+-----------------+----------------+--------------------+
*/

/* Question 4. "Hgh Sales Products"
	Write a SQL query to find the top 10 products with the highest total sales revenue from the sales transactions. 
	This will help the company to identify the High sales products which needs to be focused to increase the revenue of the company.*/
 
 SELECT 
    ProductID,
    round (SUM(Price * QuantityPurchased),2) AS TotalRevenue 
    FROM Sales_transaction
    GROUP BY ProductID
    ORDER BY TotalRevenue DESC
    LIMIT 10;
/*		OUTPUT:
						+-----------+--------------+
						| ProductID | TotalRevenue |
						+-----------+--------------+
						|        17 |         9450 |
						|        87 |      7817.24 |
						|       179 |      7388.26 |
						|        96 |      7132.32 |
						|        54 |      7052.86 |
						|       187 |      6915.88 |
						|       156 |      6827.84 |
						|        57 |       6622.2 |
						|       200 |      6479.79 |
						|       127 |       6415.8 |
						+-----------+--------------+
*/

/* Question 5. "Low Sales Products"
 Write a SQL query to find the ten products with the least amount of units sold from the sales transactions, 
 provided that at least one unit was sold for those products.*/
 
 select Productid, 
 SUM(Quantitypurchased) as TotalUnitsSold 
 from Sales_transaction 
 group by Productid 
 order by TotalUnitsSold ASC
 limit 10;
/*		OUTPUT:
						+-----------+----------------+
						| Productid | TotalUnitsSold |
						+-----------+----------------+
						|       142 |             27 |
						|        33 |             31 |
						|       174 |             33 |
						|        41 |             35 |
						|        91 |             35 |
						|        60 |             35 |
						|       159 |             35 |
						|       198 |             36 |
						|       163 |             39 |
						|       124 |             39 |
						+-----------+----------------+
*/

/* Question 6. "Sales Trend"
Write a SQL query to identify the sales trend to understand the revenue pattern of the company.
The resulting table must have DATETRANS in date format, count the number of transaction on that particular date, total units sold and the total sales took place.*/

Select 
    TransactionDate as Datetrans,
    COUNT(*) as Transaction_count,
    SUM(QuantityPurchased) as TotalUnitsSold,
    Round(SUM(Price * QuantityPurchased),2) as TotalSales
From Sales_transaction
Group by Datetrans
Order by Datetrans DESC
limit 10;
/*		OUTPUT:
						+------------+-------------------+----------------+------------+
						| Datetrans  | Transaction_count | TotalUnitsSold | TotalSales |
						+------------+-------------------+----------------+------------+
						| 2031-05-23 |                24 |             64 |       3569 |
						| 2031-03-23 |                24 |             55 |    3468.15 |
						| 2031-01-23 |                24 |             68 |     4089.9 |
						| 2030-06-23 |                24 |             67 |    3908.77 |
						| 2030-05-23 |                24 |             58 |    3528.65 |
						| 2030-04-23 |                24 |             63 |    3451.67 |
						| 2030-03-23 |                24 |             54 |    3249.25 |
						| 2030-01-23 |                24 |             51 |    2614.33 |
						| 2029-06-23 |                24 |             59 |    3471.26 |
						| 2029-05-23 |                24 |             54 |    2840.61 |
						+------------+-------------------+----------------+------------+
*/

/* Question 7. "Growth Rate of Sales"
Write a SQL query to understand the month on month growth rate of sales of the company which will help understand the growth trend of the company.*/

WITH Monthly_sales AS (
SELECT
EXTRACT(MONTH FROM TransactionDate) As month,
ROUND(SUM(QuantityPurchased * Price),2) AS total_sales
FROM sales_transaction
GROUP BY EXTRACT(MONTH FROM TransactionDate))
SELECT month,
total_sales,
LAG(total_sales) OVER (Order BY Month) AS previous_month_sales,
ROUND(((total_sales - LAG(total_sales) OVER (Order BY Month))/
LAG(total_sales) OVER (Order By Month)) * 100,2) AS mom_growth_percentage
FROM Monthly_sales
ORDER BY Month;
/*		OUTPUT:
					+-------+-------------+----------------------+-----------------------+
					| month | total_sales | previous_month_sales | mom_growth_percentage |
					+-------+-------------+----------------------+-----------------------+
					|     1 |   104289.18 |                 NULL |                  NULL |
					|     2 |    96690.99 |            104289.18 |                 -7.29 |
					|     3 |   103271.49 |             96690.99 |                  6.81 |
					|     4 |   101561.09 |            103271.49 |                 -1.66 |
					|     5 |   102998.84 |            101561.09 |                  1.42 |
					|     6 |   102210.28 |            102998.84 |                 -0.77 |
					|     7 |    90981.75 |            102210.28 |                -10.99 |
					+-------+-------------+----------------------+-----------------------+
*/

/* Question 8.  "High Purchase Frequency"
Write a SQL query that describes the number of transaction along with the total amount spent by each customer 
which are on the higher side and will help us understand the customers who are the high frequency purchase customers in the company.*/

select CustomerID, 
count(transactionid)as NumberOfTransactions, 
sum(quantitypurchased*price)as totalspent 
from sales_transaction
group by customerID
having count(transactionid)>10 and sum(quantitypurchased*price)>1000
order by totalspent desc;
/*		OUTPUT:
						+------------+----------------------+--------------------+
						| CustomerID | NumberOfTransactions | totalspent         |
						+------------+----------------------+--------------------+
						|        936 |                   12 | 2834.4700000000003 |
						|        664 |                   14 |            2519.04 |
						|        670 |                   12 |            2432.15 |
						|         39 |                   12 |            2221.29 |
						|        958 |                   12 |            2104.71 |
						|         75 |                   11 | 1862.7299999999998 |
						|        476 |                   11 | 1821.4399999999998 |
						|        929 |                   12 |            1798.42 |
						|        881 |                   11 | 1713.2300000000002 |
						|        704 |                   11 |            1628.34 |
						+------------+----------------------+--------------------+
*/

/* Question 9. "Occasional Customers"
Write a SQL query that describes the number of transaction along with the total amount spent by each customer, 
which will help us understand the customers who are occasional customers or have low purchase frequency in the company.*/

select CustomerID, count(transactionid)as NumberOfTransactions, 
Round(sum(quantitypurchased*price),2)as Totalspent 
from sales_transaction
group by customerID
having count(transactionid)<=2
order by NumberOfTransactions asc, Totalspent desc;
/*		OUTPUT:
						+------------+----------------------+--------------------+
						| CustomerID | NumberOfTransactions | Totalspent         |
						+------------+----------------------+--------------------+
						|         94 |                    1 |             360.64 |
						|        181 |                    1 |             298.23 |
						|        979 |                    1 |             265.16 |
						|        317 |                    1 |             257.73 |
						|        479 |                    1 |             254.91 |
						|        799 |                    1 |             254.70 |
						|         45 |                    1 |             241.35 |
						|        110 |                    1 |             236.16 |
						|        169 |                    1 |             230.37 |
						|        706 |                    1 |             224.49 |
						+------------+----------------------+--------------------+
*/

/* Question 10. "Repeat Purchases"
Write a SQL query that describes the total number of purchases made by each customer against each productID to understand the repeat customers in the company.*/

select 
CustomerID, 
ProductID, 
count(quantitypurchased) as TimesPurchased
from sales_transaction
group by CustomerID, ProductID
having count(quantitypurchased)>1
order by TimesPurchased desc;
/*		OUTPUT:
						+------------+-----------+----------------+
						| CustomerID | ProductID | TimesPurchased |
						+------------+-----------+----------------+
						|        685 |       192 |              3 |
						|        467 |       181 |              2 |
						|        215 |        13 |              2 |
						|        492 |        74 |              2 |
						|        242 |       172 |              2 |
						|        822 |       165 |              2 |
						|        296 |       196 |              2 |
						|        613 |        44 |              2 |
						|        225 |        75 |              2 |
						|        710 |       156 |              2 |
						+------------+-----------+----------------+
*/

/* Question 11. "Loyality Indicators"
Write a SQL query that describes the duration between the first and the last purchase of the customer in that particular company to understand the loyalty of the customer.*/

Select 
CustomerID,
MIN(TransactionDate) AS FirstPurchase,
MAX(TransactionDate) AS LastPurchase,
    DATEDIFF(MAX(TransactionDate), MIN(TransactionDate)) AS DaysBetweenPurchases
From Sales_transaction
Group by CustomerID
Having DaysBetweenPurchases > 0
Order by DaysBetweenPurchases desc ;
/* OUTPUT:
						+------------+---------------+--------------+----------------------+
						| CustomerID | FirstPurchase | LastPurchase | DaysBetweenPurchases |
						+------------+---------------+--------------+----------------------+
						|        122 | 2001-01-23    | 2031-05-23   |                11077 |
						|        780 | 2001-02-23    | 2031-05-23   |                11046 |
						|         99 | 2001-02-23    | 2031-03-23   |                10985 |
						|        689 | 2001-02-23    | 2031-03-23   |                10985 |
						|        497 | 2001-05-23    | 2031-05-23   |                10957 |
						|        917 | 2001-05-23    | 2031-05-23   |                10957 |
						|        617 | 2001-04-23    | 2031-01-23   |                10867 |
						|        605 | 2001-05-23    | 2031-01-23   |                10837 |
						|         62 | 2001-07-23    | 2031-03-23   |                10835 |
						|        776 | 2001-07-23    | 2031-01-23   |                10776 |
						+------------+---------------+--------------+----------------------+
*/

/* Question 12. "Customer Segmentation"
Write an SQL query that segments customers based on the total quantity of products they have purchased. 
Also, count the number of customers in each segment which will help us target a particular segment for marketing.
To segment customers based on their purchasing behavior for targeted marketing campaigns. Create Customer segments on the following criteria-
                        +------------------------------------------+------------------+
						| Total quantity of the purchased products | Customer_segment |
						+------------------------------------------+------------------+
						|                 1-10                     |       LOW        |
						|                11-30                     |       MID        |
						|                  >30                     |       HIGH       |
						+------------------------------------------+------------------+           */

SELECT
  CASE
    WHEN TotalQuantity BETWEEN 1 AND 10 THEN 'Low'
    WHEN TotalQuantity BETWEEN 11 AND 30 THEN 'Med'
    WHEN TotalQuantity > 30 THEN 'High'
  END AS CustomerSegment,
  COUNT(*)
FROM (
    SELECT 
      s.CustomerID,
      SUM(s.QuantityPurchased) AS TotalQuantity
    FROM 
      Sales_transaction s
    JOIN 
      Customer_profiles c ON s.CustomerID = c.CustomerID
    GROUP BY 
      s.CustomerID
) AS totalcustomers
GROUP BY 
  CustomerSegment;
  /*		OUTPUT:
									+-----------------+----------+
									| CustomerSegment | COUNT(*) |
									+-----------------+----------+
									| Med             |      559 |
									| Low             |      423 |
									| High            |        7 |
									+-----------------+----------+
  */
  



