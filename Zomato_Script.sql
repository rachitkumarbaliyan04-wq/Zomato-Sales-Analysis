CREATE DATABASE zomato_db;
USE zomato_db;
select * from Zomato;    
SHOW VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 1;

LOAD DATA LOCAL INFILE 'C:/Users/RACHIT/Desktop/Zomato Dashboard/Zomato.csv'
INTO TABLE zomato
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select * from CountryCode;
/*-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

/* Q1: Country Map Table */

SELECT Z.RestaurantID, Z.RestaurantName, Z.City, Z.CountryCode, C.Country
FROM Zomato Z
JOIN CountryCode C ON Z.CountryCode = C.CountryCode;

/*-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

/* Q2: Calendar Table */

CREATE VIEW Calendar AS
SELECT Datekey_Opening, 
YEAR(Datekey_Opening) AS Year, 
MONTH(Datekey_Opening) AS Monthno,
MONTHNAME(Datekey_Opening) AS Monthfullname,
CONCAT('Q', QUARTER(Datekey_Opening)) AS Quarter,
DATE_FORMAT(Datekey_Opening, '%Y-%b') AS YearMonth,
DAYOFWEEK(Datekey_Opening) AS Weekdayno,
DAYNAME(Datekey_Opening) AS Weekdayname,
CASE 
WHEN MONTH(Datekey_Opening) >= 4 THEN MONTH(Datekey_Opening) - 3
ELSE MONTH(Datekey_Opening) + 9
END AS FinancialMonth,
CASE 
WHEN MONTH(Datekey_Opening) BETWEEN 4 AND 6 THEN 'FQ1'
WHEN MONTH(Datekey_Opening) BETWEEN 7 AND 9 THEN 'FQ2'
WHEN MONTH(Datekey_Opening) BETWEEN 10 AND 12 THEN 'FQ3'
ELSE 'FQ4'
END AS FinancialQuarter
FROM Zomato
WHERE Datekey_Opening IS NOT NULL;

select * from Calendar;

/*-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

/* Q3: Number of Restaurants by City & Country */

SELECT C.Country, Z.City,
COUNT(*) AS Num_Restaurants
FROM Zomato Z
JOIN CountryCode C ON Z.CountryCode = C.CountryCode
GROUP BY C.Country, Z.City;

/*-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

/* Q4: Restaurants Opened by Year, Quarter, Month */

SELECT YEAR(Datekey_Opening) AS Year,
QUARTER(Datekey_Opening) AS Quarter,
MONTHNAME(Datekey_Opening) AS Month,
COUNT(*) AS Num_Restaurants
FROM Zomato
WHERE Datekey_Opening IS NOT NULL
GROUP BY YEAR(Datekey_Opening), 
QUARTER(Datekey_Opening), 
MONTHNAME(Datekey_Opening)
ORDER BY Year, Quarter;

/*-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

/* Q5: Count by Average Ratings */

SELECT ROUND(Rating, 1) AS AvgRating,
COUNT(*) AS Num_Restaurants
FROM Zomato
GROUP BY ROUND(Rating, 1)
ORDER BY AvgRating DESC;

/*-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

/* Q6: Price Bucket */

SELECT 
CASE 
WHEN Average_Cost_for_two <= 500 THEN '0–500'
WHEN Average_Cost_for_two BETWEEN 501 AND 1000 THEN '501–1000'
WHEN Average_Cost_for_two BETWEEN 1001 AND 1500 THEN '1001–1500'
WHEN Average_Cost_for_two BETWEEN 1501 AND 2000 THEN '1501–2000'
ELSE '2000+' 
END AS Price_Bucket,
COUNT(*) AS Num_Restaurants
FROM Zomato
GROUP BY Price_Bucket;

/*-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

/* Q7: Table Bookings */

SELECT Has_Table_booking,
COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Zomato) AS Percentage
FROM Zomato
GROUP BY Has_Table_booking;

/*-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

/* Q8: Online Delivery */

SELECT Has_Online_delivery,
COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Zomato) AS Percentage
FROM Zomato
GROUP BY Has_Online_delivery;

/*-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

/* Q9: Cuisines, City and Ratings */

SELECT Cuisines, City,
ROUND(Rating, 1) AS AvgRating,
COUNT(*) AS Num_Restaurants
FROM Zomato
GROUP BY Cuisines, City, ROUND(Rating, 1);