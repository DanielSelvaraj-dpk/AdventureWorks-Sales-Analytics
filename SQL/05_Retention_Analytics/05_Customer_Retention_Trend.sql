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
Retained customers / Previous-year customers × 100

Metrics:
- Previous-Year Customers
- Retained Customers
- Retention Rate

Analysis Period:
- 2023 → 2024
- 2024 → 2025

Key Results:
- 2023 → 2024: 57.24%
- 2024 → 2025: 24.96%
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
RetainedCustomers2024 AS
(
    SELECT
        C24.CustomerID
    FROM Customers2024 AS C24
    INNER JOIN Customers2025 AS C25
        ON C24.CustomerID = C25.CustomerID
),
RetainedCustomers2023 AS
(
    SELECT
        C23.CustomerID
    FROM Customers2023 AS C23
    INNER JOIN Customers2024 AS C24
        ON C23.CustomerID = C24.CustomerID
),
Total2024 AS
(
    SELECT COUNT(*) AS TotalCustomers2024
    FROM Customers2024
),
Total2023 AS
(
    SELECT COUNT(*) AS TotalCustomers2023
    FROM Customers2023
),
RetainedCustomers2024_2025 AS
(
    SELECT COUNT(*) AS RetainedCustomers2024
    FROM RetainedCustomers2024
),
RetainedCustomers2023_2024 AS
(
    SELECT COUNT(*) AS RetainedCustomers2023
    FROM RetainedCustomers2023
)

SELECT
    RetainedCustomers2024,
    RetainedCustomers2023,
    TotalCustomers2024,
    TotalCustomers2023,

    CAST(
        RetainedCustomers2023 * 100.0 / TotalCustomers2023
        AS DECIMAL(10,2)
    ) AS RetentionRate2023_2024,

    CAST(
        RetainedCustomers2024 * 100.0 / TotalCustomers2024
        AS DECIMAL(10,2)
    ) AS RetentionRate2024_2025

FROM RetainedCustomers2024_2025
CROSS JOIN Total2024
CROSS JOIN Total2023
CROSS JOIN RetainedCustomers2023_2024;
