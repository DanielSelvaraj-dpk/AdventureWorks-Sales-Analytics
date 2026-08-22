
/*
=========================================================
Project: AdventureWorks Sales Analytics
Analysis: High-Value Customers at Churn Risk
=========================================================

Business Question:
Which high-value customers have not purchased
from the company for 200 or more days?

Business Definition:
High-value customer = Lifetime Revenue >= 200,000
Churn risk = No purchase for >= 200 days

Metrics:
- Lifetime Revenue
- Last Order Date
- Days Since Last Order

Assumptions:
- Lifetime Revenue is calculated using TotalDue.
- Churn risk is defined as 200+ days since the last order.
- Analysis uses the current date at query execution time.
=========================================================
*/

WITH CustomerRevenue AS
(
    SELECT
        CustomerID,
        SUM(TotalDue) AS Revenue
    FROM Sales.SalesOrderHeader
    GROUP BY CustomerID
    HAVING SUM(TotalDue) >= 200000
),
DaysSince AS
(
    SELECT
        CustomerID,
        MAX(OrderDate) AS LastOrderDate,
        DATEDIFF(DAY, MAX(OrderDate), GETDATE()) AS DaysSinceOrder
    FROM Sales.SalesOrderHeader
    GROUP BY CustomerID
)
SELECT
    CR.CustomerID,
    CR.Revenue,
    DS.LastOrderDate,
    DS.DaysSinceOrder
FROM CustomerRevenue AS CR
INNER JOIN DaysSince AS DS
    ON DS.CustomerID = CR.CustomerID
WHERE DS.DaysSinceOrder >= 200
ORDER BY CR.Revenue DESC;
