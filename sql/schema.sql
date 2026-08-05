-- schema.sql
-- Run this first, after CREATE DATABASE food_prices; USE food_prices;

CREATE TABLE item_prices (
    item_name       VARCHAR(100),
    month           DATE,
    avg_price       DECIMAL(10,2),
    highest_state   VARCHAR(50),
    highest_price   DECIMAL(10,2),
    lowest_state    VARCHAR(50),
    lowest_price    DECIMAL(10,2),
    PRIMARY KEY (item_name, month)
);

CREATE TABLE zone_prices (
    item_name   VARCHAR(100),
    month       DATE,
    zone        VARCHAR(50),
    avg_price   DECIMAL(10,2),
    PRIMARY KEY (item_name, month, zone)
);
