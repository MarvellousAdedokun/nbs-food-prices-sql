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
WHERE month = '2025-11-01'
ORDER BY avg_price ASC
LIMIT 5;

SELECT month
FROM item_prices;
