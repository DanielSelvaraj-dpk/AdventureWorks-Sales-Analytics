/*
=========================================================
Project: AdventureWorks Sales Analytics
Analysis: Lost Customers
=========================================================

Business Question:
Which customers purchased in 2024 but did not purchase
in 2025?

Business Definition:
Lost Customer = Customer purchased in 2024
                but had no purchase in 2025.

Metrics:
- CustomerID
- 2024 Purchase Status
- 2025 Purchase Status

Assumptions:
- A customer is considered purchased if they have at
  least one SalesOrderHeader record in the given year.
- The analysis compares 2024 with 2025.
=========================================================
*/

WITH Customer2024 AS
(
    SELECT
        CustomerID,
        'Purchased' AS Order2024
    FROM Sales.SalesOrderHeader
    WHERE YEAR(OrderDate) = 2024
    GROUP BY CustomerID
),

Customer2025 AS
(
    SELECT
        CustomerID,
        'Purchased' AS Order2025
    FROM Sales.SalesOrderHeader
    WHERE YEAR(OrderDate) = 2025
    GROUP BY CustomerID
)

SELECT
    C24.CustomerID,
    C24.Order2024,
    C25.Order2025
FROM Customer2024 AS C24
LEFT JOIN Customer2025 AS C25
    ON C24.CustomerID = C25.CustomerID
WHERE C25.CustomerID IS NULL
ORDER BY C24.CustomerID;
