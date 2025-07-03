
# 🛒 Retail Analytics SQL Case Study

This project showcases a collection of SQL queries designed to analyze and derive insights from a retail sales dataset. It highlights various business-critical metrics such as customer behavior, product performance, sales trends, and loyalty indicators.

## 📁 File
- `Retail Analytics Case Study.sql`: Contains 12 SQL queries with outputs, each designed to solve a specific retail analytics problem.

---

## 📊 Case Study Overview

The SQL scripts cover the following business questions with their respective queries:

---

### 1. Total Sales Summary

**Problem**: Summarize the total sales and quantities sold per product by the company.

```sql
SELECT 
    ProductID, 
    SUM(QuantityPurchased) AS TotalUnitsSold, 
    ROUND(SUM(QuantityPurchased * Price), 2) AS TotalSales 
FROM Sales_transaction 
GROUP BY ProductID 
ORDER BY TotalSales DESC 
LIMIT 10;
```

---

### 2. Customer Purchase Frequency

**Problem**: Count the number of transactions per customer to understand purchase frequency.

```sql
SELECT 
    CustomerID, 
    COUNT(TransactionID) AS NumberOfTransactions 
FROM Sales_transaction 
GROUP BY CustomerID 
ORDER BY NumberOfTransactions DESC 
LIMIT 10;
```

---

### 3. Product Categories Performance

**Problem**: Evaluate product categories based on total sales to guide marketing strategies.

```sql
SELECT 
    p.Category,
    SUM(s.QuantityPurchased) AS TotalUnitsSold, 
    SUM(s.QuantityPurchased * s.Price) AS TotalSales
FROM Sales_transaction s 
JOIN Product_inventory p ON s.ProductID = p.ProductID 
GROUP BY p.Category 
ORDER BY TotalSales DESC;
```

---

### 4. High Sales Products

**Problem**: Identify the top 10 products with the highest total sales revenue.

```sql
SELECT 
    ProductID,
    ROUND(SUM(Price * QuantityPurchased), 2) AS TotalRevenue 
FROM Sales_transaction
GROUP BY ProductID
ORDER BY TotalRevenue DESC
LIMIT 10;
```

---

### 5. Low Sales Products

**Problem**: Find the ten products with the least amount of units sold (at least 1 unit sold).

```sql
SELECT 
    ProductID, 
    SUM(QuantityPurchased) AS TotalUnitsSold 
FROM Sales_transaction 
GROUP BY ProductID 
ORDER BY TotalUnitsSold ASC 
LIMIT 10;
```

---

### 6. Sales Trend

**Problem**: Identify the sales trend based on daily data (transactions, units sold, and sales).

```sql
SELECT 
    TransactionDate AS DateTrans,
    COUNT(*) AS Transaction_count,
    SUM(QuantityPurchased) AS TotalUnitsSold,
    ROUND(SUM(Price * QuantityPurchased), 2) AS TotalSales
FROM Sales_transaction
GROUP BY DateTrans
ORDER BY DateTrans DESC 
LIMIT 10;
```

---

### 7. Growth Rate of Sales

**Problem**: Calculate month-on-month growth rate of sales to understand trends.

```sql
WITH Monthly_sales AS (
    SELECT
        EXTRACT(MONTH FROM TransactionDate) AS month,
        ROUND(SUM(QuantityPurchased * Price), 2) AS total_sales
    FROM Sales_transaction
    GROUP BY EXTRACT(MONTH FROM TransactionDate)
)
SELECT 
    month,
    total_sales,
    LAG(total_sales) OVER (ORDER BY month) AS previous_month_sales,
    ROUND(((total_sales - LAG(total_sales) OVER (ORDER BY month)) / 
        LAG(total_sales) OVER (ORDER BY month)) * 100, 2) AS mom_growth_percentage
FROM Monthly_sales
ORDER BY month;
```

---

### 8. High Purchase Frequency Customers

**Problem**: Describe customers with high transaction count and total spending.

```sql
SELECT 
    CustomerID, 
    COUNT(TransactionID) AS NumberOfTransactions, 
    SUM(QuantityPurchased * Price) AS TotalSpent 
FROM Sales_transaction
GROUP BY CustomerID
HAVING COUNT(TransactionID) > 10 AND SUM(QuantityPurchased * Price) > 1000
ORDER BY TotalSpent DESC;
```

---

### 9. Occasional Customers

**Problem**: Identify customers with very few purchases (1-2 transactions).

```sql
SELECT 
    CustomerID, 
    COUNT(TransactionID) AS NumberOfTransactions, 
    ROUND(SUM(QuantityPurchased * Price), 2) AS TotalSpent 
FROM Sales_transaction
GROUP BY CustomerID
HAVING COUNT(TransactionID) <= 2
ORDER BY NumberOfTransactions ASC, TotalSpent DESC;
```

---

### 10. Repeat Purchases

**Problem**: Identify customers who bought the same product more than once.

```sql
SELECT 
    CustomerID, 
    ProductID, 
    COUNT(QuantityPurchased) AS TimesPurchased
FROM Sales_transaction
GROUP BY CustomerID, ProductID
HAVING COUNT(QuantityPurchased) > 1
ORDER BY TimesPurchased DESC;
```

---

### 11. Loyalty Indicators

**Problem**: Calculate days between the first and last purchase for each customer.

```sql
SELECT 
    CustomerID,
    MIN(TransactionDate) AS FirstPurchase,
    MAX(TransactionDate) AS LastPurchase,
    DATEDIFF(MAX(TransactionDate), MIN(TransactionDate)) AS DaysBetweenPurchases
FROM Sales_transaction
GROUP BY CustomerID
HAVING DaysBetweenPurchases > 0
ORDER BY DaysBetweenPurchases DESC;
```

---

### 12. Customer Segmentation

**Problem**: Segment customers based on quantity purchased and count them by segment.

```sql
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
    FROM Sales_transaction s
    JOIN Customer_profiles c ON s.CustomerID = c.CustomerID
    GROUP BY s.CustomerID
) AS totalcustomers
GROUP BY CustomerSegment;
```

---

## 🧠 Skills Demonstrated

- SQL Aggregations & Window Functions
- Joins and Subqueries
- Customer Segmentation Logic
- Business-Oriented Data Analysis
- Growth Rate Calculation with `LAG()`

---

## 🛠 Tech Stack

- SQL (MySQL)
- Retail Dataset

---

## 🙋‍♂️ Author

**Akash Chowdhary**  
[LinkedIn](www.linkedin.com/in/achowdhary) | [GitHub](#) 
