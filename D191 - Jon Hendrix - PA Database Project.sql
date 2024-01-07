/* Which film categories or genres have the highest amount of rentals? */ 

-- Part B - Custom Function for changing timestamp datatype to varchar
CREATE OR REPLACE FUNCTION date_fix(rental_date timestamp)
RETURNS varchar(25)
LANGUAGE plpgsql
AS $$
BEGIN
RETURN TO_CHAR(rental_date, 'FMMonth DD, YYYY'); --"FM" stands for Fill Mode and eliminates the extra spaces to better justify the text
END;
$$
-- Part B - Function Call for date_fix, to be used with manual timestamp input or with an entire column
SELECT date_fix(rental.rental_date)
FROM rental;

-- Part C - Detailed Table Creation
CREATE TABLE detailed_table (
rental_id INT,
rental_date TIMESTAMP,
title VARCHAR(255),
film_id INT,
film_category VARCHAR(25)
);
-- Part C - Summary Table Creation
CREATE TABLE summary_table (
film_category VARCHAR(25),
rental_count INT
);


-- Part D - This will extract the data for the detailed_table and populate it
INSERT INTO detailed_table (rental_id, rental_date, title, film_id, film_category)
SELECT rental.rental_id, rental.rental_date, film.title, inventory.film_id, category.name AS film_category
FROM rental
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
JOIN film_category ON inventory.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
ORDER BY rental.rental_id;
-- Part D - This will extract data for the summary_table and populate it
INSERT INTO summary_table (film_category, rental_count)
SELECT category.name AS film_category, COUNT(*) AS rental_count
FROM rental
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film_category ON inventory.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
GROUP BY category.name
ORDER BY COUNT(*) DESC;


-- Part E - This is the trigger that calls the function for updating the summary table
CREATE TRIGGER summary_table_update_trigger
AFTER INSERT ON detailed_table FOR EACH ROW
EXECUTE FUNCTION summary_table_update();
-- Part E - Function that will be called by the trigger to update detailed_table
CREATE OR REPLACE FUNCTION summary_table_update() 
RETURNS TRIGGER
LANGUAGE plpgsql 
AS $$
BEGIN -- This section recreates the summary table when the trigger is executed
DROP TABLE IF EXISTS summary_table;
CREATE TABLE summary_table AS  
SELECT category.name AS film_category, COUNT(*) AS rental_count
FROM rental
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film_category ON inventory.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
GROUP BY category.name
ORDER BY COUNT(*) DESC;
END;
$$ 

-- Part F - Stored Procedure for refreshing the data on detailed and summary tables 
CREATE OR REPLACE PROCEDURE data_update_refresh()
LANGUAGE plpgsql
AS $$
BEGIN
-- Clear the contents of both tables
DROP TABLE IF EXISTS detailed_table;
DROP TABLE IF EXISTS summary_table;
-- Recreates detailed_table
CREATE TABLE detailed_table AS
SELECT rental.rental_id, rental.rental_date, film.title, inventory.film_id, category.name AS film_category
FROM rental
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
JOIN film_category ON inventory.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
ORDER BY rental.rental_id;
-- Recreates summary_table
CREATE TABLE summary_table AS
SELECT category.name AS film_category, COUNT(*) AS rental_count
FROM rental
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film_category ON inventory.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
GROUP BY category.name
ORDER BY COUNT(*) DESC;
END;
$$;
-- Part F - Call execution for the stored procedure data_update_refresh()
CALL data_update_refresh;