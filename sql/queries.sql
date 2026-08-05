-- queries.sql
-- Every analysis query used in this project, in the order they were built.

-- ============================================================
-- Basic filtering and sorting
-- ============================================================

-- 5 cheapest items in November 2024
SELECT item_name, avg_price
FROM item_prices
WHERE month = '2024-11-01'
ORDER BY avg_price ASC
LIMIT 5;

-- All items in April 2025, priciest first
SELECT item_name, avg_price
FROM item_prices
WHERE month = '2025-04-01'
ORDER BY avg_price DESC;


-- ============================================================
-- Aggregates
-- ============================================================

-- Highest and lowest price each item hit across the 6 months
SELECT item_name,
       MAX(avg_price) AS highest_price,
       MIN(avg_price) AS lowest_price
FROM item_prices
GROUP BY item_name;

-- 6-month average price per item, most expensive first
SELECT item_name, AVG(avg_price) AS six_month_avg
FROM item_prices
GROUP BY item_name
ORDER BY six_month_avg DESC;


-- ============================================================
-- CASE — affordability tiers
-- ============================================================

SELECT item_name, avg_price,
    CASE
        WHEN avg_price < 1000 THEN 'Low'
        WHEN avg_price BETWEEN 1000 AND 5000 THEN 'Medium'
        ELSE 'High'
    END AS price_tier
FROM item_prices
WHERE month = '2025-04-01';


-- ============================================================
-- JOIN — item vs zone comparison
-- ============================================================

-- Zone prices above the national average for that item/month
SELECT i.item_name, i.month, i.avg_price AS national_avg,
       z.zone, z.avg_price AS zone_avg
FROM item_prices i
JOIN zone_prices z
  ON i.item_name = z.item_name
 AND i.month = z.month
WHERE z.avg_price > i.avg_price;


-- ============================================================
-- Subquery — zones above the overall national average
-- ============================================================

SELECT zone, AVG(avg_price) AS zone_avg
FROM zone_prices
GROUP BY zone
HAVING AVG(avg_price) > (
    SELECT AVG(avg_price) FROM item_prices
);

-- All 6 zone averages, ranked (used for the zone chart)
SELECT zone, AVG(avg_price) AS zone_avg
FROM zone_prices
GROUP BY zone
ORDER BY zone_avg DESC;


-- ============================================================
-- Window functions
-- ============================================================

-- Rank items by price within each month
SELECT item_name, month, avg_price,
       RANK() OVER (PARTITION BY month ORDER BY avg_price DESC) AS price_rank
FROM item_prices;

-- Month-over-month price change per item
SELECT item_name, month, avg_price,
       LAG(avg_price) OVER (PARTITION BY item_name ORDER BY month) AS prev_month_price,
       avg_price - LAG(avg_price) OVER (PARTITION BY item_name ORDER BY month) AS price_change
FROM item_prices;


-- ============================================================
-- State-level extremes (highest/lowest text columns)
-- ============================================================

-- States that hit the highest price most often
SELECT highest_state, COUNT(*) AS times_highest
FROM item_prices
WHERE highest_state IS NOT NULL
GROUP BY highest_state
ORDER BY times_highest DESC;

-- States that hit the lowest price most often
SELECT lowest_state, COUNT(*) AS times_lowest
FROM item_prices
WHERE lowest_state IS NOT NULL
GROUP BY lowest_state
ORDER BY times_lowest DESC;
