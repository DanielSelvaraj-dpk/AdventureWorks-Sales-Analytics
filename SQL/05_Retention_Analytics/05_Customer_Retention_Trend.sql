/*
=========================================================
Project: AdventureWorks Sales Analytics
Analysis: Customer Retention Trend
=========================================================

Business Question:
How has customer retention changed between consecutive
years?

Business Definition:
Customer Retention Rate =
Customers who purchased in both consecutive years
divided by customers who purchased in the previous year.

Metrics:
- Previous-Year Customers
- Retained Customers
- Customer Retention Rate

Analysis Period:
- 2023 → 2024
- 2024 → 2025

Key Results:
- 2023 → 2024 Retention: 57.24%
- 2024 → 2025 Retention: 24.96%

Assumptions:
- A customer is considered active if they have at least
  one sales order during the year.
- A retained customer must have purchased in both
  consecutive years.
- 2023 is the base year for the first comparison.
=========================================================
*/

WITH Customers2024 AS
(
    SELECT DISTINCT
        CustomerID
    FROM Sales.SalesOrderHeader
    WHERE YEAR(OrderDate) = 2024
),
Customers2025 AS
(
    SELECT DISTINCT
        CustomerID
    FROM Sales.SalesOrderHeader
    WHERE YEAR(OrderDate) = 2025
),
Customers2023 AS
(
    SELECT DISTINCT
        CustomerID
    FROM Sales.SalesOrderHeader
    WHERE YEAR(OrderDate) = 2023
),
RetainedCustomers2023_2024 AS
(
    SELECT
        C23.CustomerID
    FROM Customers2023 AS C23
    INNER JOIN Customers2024 AS C24
        ON C23.CustomerID = C24.CustomerID
),
RetainedCustomers2024_2025 AS
(
    SELECT
        C24.CustomerID
    FROM Customers2024 AS C24
    INNER JOIN Customers2025 AS C25
        ON C24.CustomerID = C25.CustomerID
),
TotalCustomers2023 AS
(
    SELECT COUNT(*) AS TotalCustomers
    FROM Customers2023
),
TotalCustomers2024 AS
(
    SELECT COUNT(*) AS TotalCustomers
    FROM Customers2024
),
Retained2023_2024 AS
(
    SELECT COUNT(*) AS RetainedCustomers
    FROM RetainedCustomers2023_2024
),
Retained2024_2025 AS
(
    SELECT COUNT(*) AS RetainedCustomers
    FROM RetainedCustomers2024_2025
)

SELECT
    '2023 → 2024' AS RetentionPeriod,
    T23.TotalCustomers AS PreviousYearCustomers,
    R23.RetainedCustomers,
    CAST(
        R23.RetainedCustomers * 100.0
        / T23.TotalCustomers
        AS DECIMAL(10,2)
    ) AS RetentionPercentage
FROM TotalCustomers2023 AS T23
CROSS JOIN Retained2023_2024 AS R23

UNION ALL

SELECT
    '2024 → 2025' AS RetentionPeriod,
    T24.TotalCustomers AS PreviousYearCustomers,
    R24.RetainedCustomers,
    CAST(
        R24.RetainedCustomers * 100.0
        / T24.TotalCustomers
        AS DECIMAL(10,2)
    ) AS RetentionPercentage
FROM TotalCustomers2024 AS T24
CROSS JOIN Retained2024_2025 AS R24;
