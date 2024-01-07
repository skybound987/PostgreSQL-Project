# PostgreSQL-Project
A set of scripts for PostgreSQL that query a film database by extracting data and creating table joins by field type.  Two tables, detailed_table and summary_table, are created and populated.  The detailed_table includes comprehensive rental data, while the summary_table aggregates rental counts by film category.


Section A1 
The specific fields that will be utilized in the creation of a detailed table and summary table are as follows:  The detailed table will include the rental_id and rental_date fields from the rental table, the title field from the film table, the film_id field from the inventory table, and the name field from the category table renamed as film_category.  The summary table will include the newly named film_category field from the category table and a newly created rental_count field that counts the total number of films rented from each film category or genre.   


Section A2  
The types of data fields for the detailed table are presented are as follows:  The rental_id field is an integer datatype and primary key for the rental table that uniquely identifies each row for every instance of a rental.  The rental_date field is a timestamp datatype that identifies when the film was rented and is from the rental table.  The title field is from the film table and is a varchar datatype that allows up to 255 characters that contains the title of the film.  The film_id field is an integer datatype and a primary key that uniquely identifies each film in the film table.  The category_id field is from the film_category table and is an integer datatype that uniquely identifies each film category.  The name field is from the category table and is a varchar datatype that allows up to 25 characters and describes the category or genre of film.  This field has been renamed to film_category. 
The types of data fields for the summary table are presented as follows: The name field is being used again from the category table and is a varchar datatype that allows up to 25 characters and describes the category or genre of film.  This field has been renamed to film_category.  The rental_count field is a newly created field of the integer datatype that counts the total number of films rented from each film category or genre. 


Section A3  
The film table, category table, rental table, inventory table, and film_category table will be utilized from the DVD rental database to provide the data necessary for both the detailed table and summary table.  For the detailed table, the film table is linked to the inventory table through the film_id field and provides the film title.  The category table will provide the name field that will be renamed as film_category.  The rental table provides rental_id and rental_date indicating the primary key for rentals and when the film was rented.  The inventory table functions as a link between the rental and film tables through the film_id field.  The film_category table is joined to the inventory table on the film_id field.
For the summary table,  the rental table provides the rental_id field which is necessary to count the amount of rentals for the newly created rental_count field.  The inventory table functions the same as it does for the detailed table in that it provides the join from the rental table and film table through the film_id field to confirm which films have been rented.  The category table is joined to the film_category table through the category_id primary key to get the film category or genre name.  Below is a chart outlining the structure of the columns for both the detailed and summary tables.

<img alt="Chart" width="50%" src="https://github.com/skybound987/PostgreSQL-Project/assets/100818602/effbd755-1434-471c-97b5-381b58f3aeee"/>

Section A4  
The rental_date field in the detailed table can be transformed from its default timestamp datatype to a varchar datatype to make the date more presentable and readable on a report.  The function is named date_fix and uses the TO_CHAR function to easily convert a timestamp to a simple month, day, year format.  For example, a timestamp date such as ‘2008-05-26 13:30:48’ would be converted to ‘May 26, 2008’ using this function.  When presenting the summary table to management, this will make the table appear more presentable and readable than the default timestamp datatype.   


Section A5 
There are several business uses of the detailed table and the summary table worth mentioning.  The summary table breaks the details down into a simple report and is likely to be presented to management.  Knowing which film categories are the most popular and yields the most amount of rentals would prompt store owners to display these categories of films in their main displays in the store, making them easily accessible for customers and thus increasing profits.  The summary table could also provide insight about which film genres to promote over others based on how often they are being rented.  The detailed table consists of many more data points that may or may not be of interest to management at a given time.  A manager could see the summary table but could request to verify or validate the information with more data.  Another scenario could involve the manager wanting to see exactly what time of the year films were rented to figure out when best to promote certain film categories.  In this situation the detailed table is necessary to either present the information directly to management, or to pull in more data points from the detailed table into the summary.


Section A6  
The report should be refreshed on a weekly basis to keep up with new films becoming available as video rentals.  This will ensure stakeholders that as new films are being released for home video, they will be on the shelves and available for customers as soon as they are available for the company to purchase and stock on their shelves.  Considering the size of the film industry, there would be ample amount of videos becoming available on an almost daily basis, however, refreshing the report on a daily basis wouldn’t be realistic as most stores likely operate their inventory deliveries on a weekly or monthly basis.  This makes refreshing the report on a weekly basis the most logical choice for the business.  


Section B
Below is SQL code for creating a custom transformation described in section A4.  
![B](https://github.com/skybound987/PostgreSQL-Project/assets/100818602/51fc3d17-38a6-4bcf-bc85-5fa05d512b56)




Section C 
Below is SQL code that creates the detailed and summary tables titled detailed_table and summary_table respectively.  




Section D 
Below is a SQL Query that extracts all the data from the database tables and inserts it into the detailed_table and summary_table respectively.




Section E
Below is SQL code that creates a trigger on the detailed_table. 
This will continually update the summary table as data is added to the detailed table.




Section F
Below is a stored procedure titled data_update_refresh() that can be called to refresh the data on both the detailed_table and summary_table.




Section F1
PostgreSQL does not have automation features that can refresh data, so another tool is required to provide automation (Dias, 2020).  
A tool such as Linux crontab in conjunction with PostgreSQL can achieve this function by automatically running in the background, 
and verifying configuration files that are based on scripts written to execute the automation (Dias, 2020).







References

Dias, H. (2020, February 3). An overview of job scheduling tools for PostgreSQL. severalnines. https://severalnines.com/blog/overview-job-scheduling-tools-postgresql/


