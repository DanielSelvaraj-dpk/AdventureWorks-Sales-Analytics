/*
=========================================================
Project: AdventureWorks Sales Analytics
Analysis: Customer Retention Rate
=========================================================

Business Question:
What percentage of customers who purchased in 2024
also purchased in 2025?

Business Definition:
Retention Rate = Customers who purchased in both 2024
                 and 2025 / Total customers in 2024

Metrics:
- Total 2024 Customers
- Retained Customers
- Customer Retention Rate

Assumptions:
- A retained customer must have at least one purchase
  in both 2024 and 2025.
- 2024 is treated as the customer base year.
=========================================================
*/

WITH Customers2024 AS
(
    SELECT DISTINCT CustomerID
    FROM Sales.SalesOrderHeader
    WHERE YEAR(OrderDate) = 2024
),
Customers2025 AS
(
    SELECT DISTINCT CustomerID
    FROM Sales.SalesOrderHeader
    WHERE YEAR(OrderDate) = 2025
),
RetainedCustomers AS
(
    SELECT C24.CustomerID
    FROM Customers2024 AS C24
    INNER JOIN Customers2025 AS C25
        ON C24.CustomerID = C25.CustomerID
),
Total2024 AS
(
    SELECT COUNT(*) AS TotalCustomers2024
    FROM Customers2024
),
TotalRetained AS
(
    SELECT COUNT(*) AS RetainedCustomers
    FROM RetainedCustomers
)
SELECT
    RetainedCustomers,
    TotalCustomers2024,
    CAST(
        RetainedCustomers * 100.0 / TotalCustomers2024
        AS DECIMAL(8,2)
    ) AS RetentionRate
FROM TotalRetained
CROSS JOIN Total2024;
