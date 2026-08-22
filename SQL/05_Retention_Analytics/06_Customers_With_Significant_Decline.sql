/*
=========================================================
Project: AdventureWorks Sales Analytics
Analysis: Customers With Significant YoY Decline
=========================================================

Business Question:
Which customers experienced a significant decline in
both revenue and order activity compared with the
previous year?

Business Definition:
Significant decline:
- Revenue declined by at least 20%
- Order quantity declined by at least 20%

Metrics:
- Current-Year Revenue
- Previous-Year Revenue
- Revenue Growth %
- Current-Year Order Quantity
- Previous-Year Order Quantity
- Order Growth %

=========================================================
*/

WITH RevenueAndOrder AS
(
    SELECT
        CustomerID,
        YEAR(OrderDate) AS Year,
        SUM(TotalDue) AS CurrentYearRevenue,
        SUM(OrderQty) AS CurrentYearOrderQty
    FROM Sales.SalesOrderHeader AS SOH
    INNER JOIN Sales.SalesOrderDetail AS SOD
        ON SOH.SalesOrderID = SOD.SalesOrderID
    GROUP BY
        CustomerID,
        YEAR(OrderDate)
),
CurrentYearPreviousYear AS
(
    SELECT
        CustomerID,
        Year,
        CurrentYearRevenue,
        LAG(CurrentYearRevenue) OVER
        (
            PARTITION BY CustomerID
            ORDER BY Year
        ) AS PreviousYearRevenue,
        CurrentYearOrderQty,
        LAG(CurrentYearOrderQty) OVER
        (
            PARTITION BY CustomerID
            ORDER BY Year
        ) AS PreviousYearOrderQty
    FROM RevenueAndOrder
),
Growth AS
(
    SELECT
        CustomerID,
        Year,
        CurrentYearRevenue,
        PreviousYearRevenue,
        CurrentYearOrderQty,
        PreviousYearOrderQty,

        (CurrentYearRevenue - PreviousYearRevenue)
            AS RevenueDifference,

        (CurrentYearOrderQty - PreviousYearOrderQty)
            AS OrderDifference,

        (CurrentYearRevenue - PreviousYearRevenue)
            * 100.0 / NULLIF(PreviousYearRevenue, 0)
            AS RevenueGrowth,

        (CurrentYearOrderQty - PreviousYearOrderQty)
            * 100.0 / NULLIF(PreviousYearOrderQty, 0)
            AS OrderGrowth

    FROM CurrentYearPreviousYear
    WHERE PreviousYearRevenue IS NOT NULL
      AND PreviousYearOrderQty IS NOT NULL
)

SELECT
    CustomerID,
    Year,
    CurrentYearRevenue,
    PreviousYearRevenue,
    RevenueDifference,
    RevenueGrowth,
    CurrentYearOrderQty,
    PreviousYearOrderQty,
    OrderDifference,
    OrderGrowth
FROM Growth
WHERE RevenueGrowth <= -20
  AND OrderGrowth <= -20
ORDER BY RevenueGrowth ASC;
