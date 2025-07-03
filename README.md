
# 🛒 Retail Analytics SQL Case Study

This project showcases a collection of SQL queries designed to analyze and derive insights from a retail sales dataset. It highlights various business-critical metrics such as customer behavior, product performance, sales trends, and loyalty indicators.

## 📁 File
- `Retail Analytics Case Study.sql`: Contains 12 SQL queries with outputs, each designed to solve a specific retail analytics problem.

---

# 📊 Case Study with Insights

Each question below includes the business problem, the SQL query, and the corresponding insights derived from the results.

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

**Insight**: Products with the highest revenue are Product IDs 17, 87, and 179.  
**Interpretation**: Focus on stock optimization, marketing, and bundling strategies around these products.

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

**Insight**: Customers such as 664, 670, and 958 made 12–14 purchases.  
**Interpretation**: These high-frequency buyers are potentially loyal customers.

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

**Insight**: 'Home & Kitchen' and 'Electronics' are top-performing categories.  
**Interpretation**: Prioritize these in promotions and inventory planning.

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

**Insight**: Top revenue contributors mirror those in Q1.  
**Interpretation**: Continue promoting these revenue-driving products.

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

**Insight**: Products like 142, 33, and 174 had the lowest sales.  
**Interpretation**: Review for possible discontinuation or repositioning.

---

### 6. Sales Trend

**Problem**: Identify the sales trend based on daily data.

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

**Insight**: Revenue is stable across high-transaction days.  
**Interpretation**: Useful for inventory planning and forecasting.

---

### 7. Growth Rate of Sales

**Problem**: Calculate month-on-month growth rate of sales.

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

**Insight**: Monthly growth fluctuates significantly.  
**Interpretation**: Indicates the need for stable seasonal promotions.

---

### 8. High Purchase Frequency

**Problem**: Describe high-frequency, high-spend customers.

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

**Insight**: 10+ loyal customers spent over ₹1000 each.  
**Interpretation**: Prime candidates for retention and rewards programs.

---

### 9. Occasional Customers

**Problem**: Identify customers with 1–2 transactions.

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

**Insight**: Many are one-time buyers.  
**Interpretation**: Consider re-engagement campaigns or surveys.

---

### 10. Repeat Purchases

**Problem**: Identify repeated product purchases by customers.

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

**Insight**: Repeat buys show brand/product loyalty.  
**Interpretation**: Recommend similar products or bundles.

---

### 11. Loyalty Indicators

**Problem**: Calculate duration between first and last purchase.

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

**Insight**: Some customers have over 30 years of purchase history.  
**Interpretation**: These are highly loyal customers – treat them as VIPs.

---

### 12. Customer Segmentation

**Problem**: Segment customers based on quantity purchased.

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

**Insight**: Majority are in 'Med' segment, followed by 'Low'.  
**Interpretation**: Focus upselling on 'Med' group and convert 'Low' to 'Med'.

---

## 🧠 Skills Demonstrated

- SQL Aggregations & Window Functions
- Joins and Subqueries
- Customer Segmentation Logic
- Business-Oriented Data Analysis
- Growth Rate Calculation with `LAG()`

---

## 🛠 Tech Stack

- SQL (PostgreSQL / MySQL)
- Retail Dataset (hypothetical)

---

## 🧾 License

This project is open-source and available under the MIT License.

---

## 🙋‍♂️ Author

**Akash Chowdhary**  
[LinkedIn](#) | [GitHub](#) | Portfolio (Add your links)
