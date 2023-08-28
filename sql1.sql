-- Add a new product to the table: "chair" with a price of $44.00 and not returnable.
INSERT INTO products
  (name, price, can_be_returned)
VALUES
  ('chair', 44.00, 'f');

-- Insert another product: "stool" priced at $25.99 and is returnable.
INSERT INTO products
  (name, price, can_be_returned)
VALUES
  ('stool', 25.99, 't');

-- Add a product named "table" priced at $124.00, and it's not returnable.
INSERT INTO products
  (name, price, can_be_returned)
VALUES
  ('table', 124.00, 'f');

-- Display all rows and columns in the product table.
SELECT * FROM products;

-- Show the names of all products.
SELECT name FROM products;

-- Display names and prices of products.
SELECT name, price FROM products;

-- Introduce a new product: "hammock" priced at $99.00, and it can be returned.
INSERT INTO products
  (name, price, can_be_returned)
VALUES
  ('hammock', 99.00, 't');

-- Display products that can be returned.
SELECT * FROM products WHERE can_be_returned;

-- Show products with prices below $44.00.
SELECT * FROM products WHERE price < 44.00;

-- Display products priced between $22.50 and $99.99.
SELECT * FROM products WHERE price BETWEEN 22.50 AND 99.99;

-- Apply a $20 discount to all products due to an ongoing sale.
UPDATE products SET price = price - 20;

-- Remove products priced under $25 as they've sold out due to the sale.
DELETE FROM products WHERE price < 25;

-- End the sale and increase prices by $20 for remaining products.
UPDATE products SET price = price + 20;

-- Change company policy: All products are now returnable.
UPDATE products SET can_be_returned = 't';

-- Playstore Queries

-- Fetch all records from the analytics table.
SELECT * FROM analytics;

-- Retrieve details for the app with ID 1880.
SELECT * FROM analytics 
  WHERE id = 1880;

-- Find IDs and app names of apps updated on August 01, 2018.
SELECT id, app_name FROM analytics
   WHERE last_updated = '2018-08-01';

-- Count the apps in each category.
SELECT category, COUNT(*) FROM analytics 
  GROUP BY category;

-- List the top 5 most-reviewed apps and their review counts.
SELECT * FROM analytics 
  ORDER BY reviews DESC 
  LIMIT 5;

-- Fetch information about the most-reviewed app with a rating of 4.8 or higher.
SELECT * FROM analytics 
  WHERE rating >= 4.8 
  ORDER BY reviews DESC
  LIMIT 1;

-- Determine the average rating for each category, sorted from high to low.
SELECT category, AVG(rating) FROM analytics 
  GROUP BY category 
  ORDER BY avg DESC;

-- Display the name, price, and rating of the highest-priced app with a rating below 3.
SELECT app_name, price, rating FROM analytics 
  WHERE rating < 3 
  ORDER BY price DESC 
  LIMIT 1;

-- Retrieve records of apps with min installs under 50 and a rating. Order by rating.
SELECT * FROM analytics 
  WHERE min_installs <= 50 
    AND rating IS NOT NULL 
  ORDER BY rating DESC;

-- List the names of apps rated below 3 with at least 10000 reviews.
SELECT app_name FROM analytics
  WHERE rating < 3 AND reviews >= 10000;

-- Find the top 10 most-reviewed apps priced between 10 cents and a dollar.
SELECT * FROM analytics
  WHERE price BETWEEN 0.1 and 1 
  ORDER BY reviews DESC 
  LIMIT 10;

-- Identify the app with the earliest last update date.
SELECT * FROM analytics 
  WHERE last_updated = (SELECT MIN(last_updated) FROM analytics);

-- Identify the most expensive app.
SELECT * FROM analytics 
  WHERE price = (SELECT MAX(price) FROM analytics);

-- Count all the reviews in the Google Play Store.
SELECT SUM(reviews) AS "Total Reviews" FROM analytics;

-- List categories with more than 300 apps.
SELECT category FROM analytics 
  GROUP BY category 
  HAVING COUNT(*) > 300;

-- Find the app with the highest proportion of reviews to min_installs, for apps with over 100,000 installs.
SELECT app_name, reviews, min_installs,  min_installs / reviews AS proportion
  FROM analytics
  WHERE min_installs >= 100000
  ORDER BY proportion DESC
  LIMIT 1;

-- FURTHER STUDY 

-- List the highest rated apps in each category, among those installed at least 50,000 times.
SELECT app_name, rating, category FROM analytics
  WHERE (rating, category) in (
    SELECT MAX(rating), category FROM analytics
      WHERE min_installs >= 50000
      GROUP BY category
    )
  ORDER BY category;

-- Find apps with names similar to "facebook".
SELECT * FROM analytics 
  WHERE app_name ILIKE '%facebook%';

-- Retrieve apps with more than 1 genre.
SELECT * FROM analytics 
  WHERE  array_length(genres, 1) = 2;

-- Discover apps with "education" as one of their genres.
SELECT * FROM analytics 
  WHERE genres @> '{"Education"}';
