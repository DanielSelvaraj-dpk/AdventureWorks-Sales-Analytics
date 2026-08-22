/*
=========================================================
Project: AdventureWorks Sales Analytics
Analysis: Reactivated Customer Revenue
=========================================================

Business Question:
How much revenue did customers generate after returning
to the business following a year without purchasing?

Business Definition:
Reactivated Customer = Customer made no purchase in 2024
                       but made at least one purchase in 2025.

Analysis Period:
2024 → 2025

Metrics:
- Reactivated Customer Count
- 2025 Revenue Generated
- 2025 Order Count
- Average Revenue per Reactivated Customer

=========================================================
*/

WITH Customer2024 AS
(
    SELECT CustomerID
    FROM Sales.SalesOrderHeader
    WHERE YEAR(OrderDate) = 2024
    GROUP BY CustomerID
),
Customer2025 AS
(
    SELECT CustomerID
    FROM Sales.SalesOrderHeader
    WHERE YEAR(OrderDate) = 2025
    GROUP BY CustomerID
),
ReactivatedCustomers AS
(
    SELECT C25.CustomerID
    FROM Customer2025 AS C25
    LEFT JOIN Customer2024 AS C24
        ON C25.CustomerID = C24.CustomerID
    WHERE C24.CustomerID IS NULL
),
ReactivatedCustomerRevenue AS
(
    SELECT
        RC.CustomerID,
        SUM(SOH.TotalDue) AS Revenue2025
    FROM ReactivatedCustomers AS RC
    INNER JOIN Sales.SalesOrderHeader AS SOH
        ON RC.CustomerID = SOH.CustomerID
    WHERE YEAR(SOH.OrderDate) = 2025
    GROUP BY RC.CustomerID
)

SELECT
    COUNT(CustomerID) AS TotalReactivatedCustomers,
    SUM(Revenue2025) AS TotalReactivatedRevenue
FROM ReactivatedCustomerRevenue;
