USE food_prices;
CREATE TABLE item_prices (
    item_name   VARCHAR(100),
    month       DATE,
    avg_price   DECIMAL(10,2),       
    PRIMARY KEY (item_name, month)
);

CREATE TABLE zone_prices (
    item_name   VARCHAR(100),
    month       DATE,
    zone        VARCHAR(50),
    avg_price   DECIMAL(10,2),
    PRIMARY KEY (item_name, month, zone)
);

DESCRIBE item_prices;

ALTER TABLE item_prices
ADD COLUMN highest_state VARCHAR(50),
ADD COLUMN highest_price DECIMAL(10,2),
ADD COLUMN lowest_state VARCHAR(50),
ADD COLUMN lowest_price DECIMAL(10,2);

DESCRIBE item_prices; 

DESCRIBE zone_prices;

SELECT COUNT(*) FROM item_prices;
SELECT COUNT(*) FROM zone_prices;

SELECT item_name, avg_price
FROM item_prices
WHERE month = '2025-04-01'
ORDER BY avg_price DESC;

SELECT item_name, avg_price
FROM item_prices
WHERE month = '2024-11-01'
ORDER BY avg_price ASC
LIMIT 5;

SELECT month
FROM item_prices;

SELECT item_name, AVG(avg_price) AS six_month_avg
FROM item_prices
GROUP BY item_name
ORDER BY six_month_avg DESC;

SELECT item_name,
       MAX(avg_price) AS highest_price,
       MIN(avg_price) AS lowest_price
FROM item_prices
GROUP BY item_name;

SELECT item_name, avg_price,
    CASE
        WHEN avg_price < 1000 THEN 'Low'
        WHEN avg_price BETWEEN 1000 AND 5000 THEN 'Medium'
        ELSE 'High'
    END AS price_tier
FROM item_prices
WHERE month = '2025-04-01';

SELECT i.item_name, i.month, i.avg_price AS national_avg,
       z.zone, z.avg_price AS zone_avg
FROM item_prices i
JOIN zone_prices z
  ON i.item_name = z.item_name
 AND i.month = z.month;
 
 SELECT i.item_name, i.month, i.avg_price AS national_avg,
       z.zone, z.avg_price AS zone_avg
FROM item_prices i
JOIN zone_prices z
  ON i.item_name = z.item_name
 AND i.month = z.month
 WHERE z.avg_price > i.avg_price;
 
SELECT zone, AVG(avg_price) AS zone_avg
FROM zone_prices
GROUP BY zone
HAVING AVG(avg_price) > (
    SELECT AVG(avg_price) FROM item_prices
);

SELECT item_name, month, avg_price,
       RANK() OVER (PARTITION BY month ORDER BY avg_price DESC) AS price_rank
FROM item_prices;

SELECT item_name, month, avg_price,
       LAG(avg_price) OVER (PARTITION BY item_name ORDER BY month) AS prev_month_price
FROM item_prices;

SELECT item_name, month, avg_price,
       LAG(avg_price) OVER (PARTITION BY item_name ORDER BY month) AS prev_month_price,
       avg_price - LAG(avg_price) OVER (PARTITION BY item_name ORDER BY month) AS price_change
FROM item_prices;

SELECT highest_state, COUNT(*) AS times_highest
FROM item_prices
WHERE highest_state IS NOT NULL
GROUP BY highest_state
ORDER BY times_highest DESC;

SELECT lowest_state, COUNT(*) AS times_lowest
FROM item_prices
WHERE lowest_state IS NOT NULL
GROUP BY lowest_state
ORDER BY times_lowest DESC;