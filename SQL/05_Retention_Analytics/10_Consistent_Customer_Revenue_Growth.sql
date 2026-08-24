/*
=========================================================
Project: AdventureWorks Sales Analytics
Analysis: Consistent Customer Revenue Growth
=========================================================

Business Question:
Which customers have consistently increased their revenue
every year from 2022 through 2025?

Business Definition:
Consistent Revenue Growth = Customer revenue increased
in every consecutive year from 2022 to 2025.

Analysis Period:
2022 → 2025

Metrics:
- CustomerID
- Revenue 2022
- Revenue 2023
- Revenue 2024
- Revenue 2025
- Revenue Growth Status

Business Purpose:
Identify customers showing sustained revenue growth over
multiple years and provide insight into customers who may
have increasing long-term value.

Assumptions:
- The analysis covers 2022–2025.
- A customer with no purchase in a given year is assigned
  revenue of 0 for that year.
- Revenue is calculated using TotalDue.
- Consistent growth requires revenue to increase strictly
  every year.

=========================================================
*/

-- =====================================================
-- SQL Analysis
-- =====================================================

WITH Year AS
(
    SELECT DISTINCT
        YEAR(OrderDate) AS Year
    FROM Sales.SalesOrderHeader
),

Customer AS
(
    SELECT DISTINCT
        CustomerID AS Customers
    FROM Sales.SalesOrderHeader
),

CustomersYear AS
(
    SELECT
        Customers,
        Year
    FROM Customer
    CROSS JOIN Year
),

CustomerRevenue AS
(
    SELECT
        CustomerID,
        SUM(TotalDue) AS Revenue,
        YEAR(OrderDate) AS Year
    FROM Sales.SalesOrderHeader
    GROUP BY
        CustomerID,
        YEAR(OrderDate)
),

CustomerTable AS
(
    SELECT
        CY.Customers,
        CY.Year,
        COALESCE(CR.Revenue, 0) AS Revenue
    FROM CustomersYear AS CY
    LEFT JOIN CustomerRevenue AS CR
        ON CY.Customers = CR.CustomerID
        AND CY.Year = CR.Year
),

Final AS
(
    SELECT
        Customers,

        SUM(
            CASE
                WHEN Year = 2022 THEN Revenue
            END
        ) AS Revenue2022,

        SUM(
            CASE
                WHEN Year = 2023 THEN Revenue
            END
        ) AS Revenue2023,

        SUM(
            CASE
                WHEN Year = 2024 THEN Revenue
            END
        ) AS Revenue2024,

        SUM(
            CASE
                WHEN Year = 2025 THEN Revenue
            END
        ) AS Revenue2025

    FROM CustomerTable
    GROUP BY Customers
)

SELECT
    Customers,
    Revenue2022,
    Revenue2023,
    Revenue2024,
    Revenue2025,

    CASE
        WHEN Revenue2022 < Revenue2023
         AND Revenue2023 < Revenue2024
         AND Revenue2024 < Revenue2025
        THEN 'Increasing'
        ELSE 'Not Increasing'
    END AS RevenueTrend

FROM Final

ORDER BY
    CASE
        WHEN Revenue2022 < Revenue2023
         AND Revenue2023 < Revenue2024
         AND Revenue2024 < Revenue2025
        THEN 1
        ELSE 2
    END,
    Revenue2025 DESC;


/*
=========================================================
Results
=========================================================

Approximately 140 customers showed consistent revenue
growth across all four years from 2022 through 2025.

=========================================================
Business Insight
=========================================================

Approximately 140 customers demonstrated sustained
year-over-year revenue growth from 2022 through 2025.

These customers represent a segment with consistently
increasing purchasing value and may have strong potential
for long-term customer development.

=========================================================
CEO Action
=========================================================

The business should identify the characteristics and
purchasing behavior of consistently growing customers.

These customers can be prioritized for:
- Customer relationship development
- Cross-selling and upselling
- Loyalty programs
- Premium product recommendations
- Long-term account management

The business can also investigate what factors are
driving their sustained revenue growth and apply those
strategies to similar customers.

=========================================================
Important Interpretation
=========================================================

Consistent revenue growth does not necessarily mean that
these customers are currently the highest-value customers.

This analysis identifies customers with a positive and
consistent revenue trend, rather than customers ranked
only by total lifetime revenue.

=========================================================
*/
