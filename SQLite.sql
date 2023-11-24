CREATE TABLE appleStore_description_combined as

SELECT * FROM appleStore_description1

UNION ALL

SELECT * FROM appleStore_description2

UNION ALL

SELECT * FROM appleStore_description3

UNION ALL

SELECT * FROM appleStore_description4


**EDA**

-- CHECK THE NUMBER OF UNIQUE APPS IN BOTH TABLESAPPLESTOREAppleStore

SELECT COUNT(DISTINCT id) AS UniqueAppsIDs
from AppleStore

SELECT COUNT(DISTINCT id) AS UniqueAppsIDs
from appleStore_description_combined

-- CHECK FOR ANY NULL VALUES IN KEY FIELDSAPPLETABLES

SELECT COUNT(*) AS MissingValues
FROM AppleStore
WHERE track_name is null or user_rating is null or prime_genre is NULL

SELECT COUNT(*) AS MissingValues
FROM appleStore_description_combined
WHERE app_desc is NULL

-- FIND OUT THE NUMBER OF APPS PER GENRE

SELECT prime_genre, COUNT(DISTINCT id) as AppsNumber from AppleStore
GROUP by prime_genre
ORDER by 2 DESC

-- GET AN OVERVIEW OF APPS RATING

SELECT min(user_rating) as MinRating,
       max(user_rating) as MaxRating,
       avg(user_rating) as AvgRating
FROM AppleStore

**DATA ANALYSIS**

-- DETRMINE WETHER PAID APPS HAVE HIGHER RATINGS THAN FREE APPS 

SELECT CASE
           WHEN price > 0 THEN 'Paid'
           ELSE 'Free'
         End as App_Type,
         avg(user_rating) as avg_rating
FROM AppleStore
GROUP by App_Type

-- CHECK IF APPS WITH MORE SUPPORTED LANGUAGES HAVE HIGHER RATINGS

SELECT CASE
          WHEN lang_num < 10 THEN '<10 Languages'
          WHEN lang_num BETWEEN 10 and 30 THEN '10-30 Languages'
          ELSE '>30 Languages'
      end as Lang_Bucket,
        avg(user_rating) as avg_rating
from AppleStore
GROUP by Lang_Bucket
ORDER by avg_rating DESC


--CHECK GENRE WITH LOW RATINGS

SELECT prime_genre, AVG(user_rating) as avg_Rating
FROM AppleStore
GROUP by prime_genre
ORDER by avg_Rating ASC
LIMIT 10


-- CHECK OF THERE IS CORRELATION BETWEEN THE LENGTH OF THE APP DESCRIPTION AND THE USER RATING

SELECT CASE
           WHEN length(b.app_desc) < 500 then 'Short'
            WHEN length(b.app_desc) BETWEEN 500 and 1000 then 'Medium'
            else 'Long'
         End as Desc_length,
         avg(a.user_rating) as avg_rating

FROM
AppleStore AS A
JOIN
appleStore_description_combined AS B 
ON
A.id = B.id
GROUP by Desc_length
order by avg_rating DESC


-- CHECKING THE TOP RATED APPS FOR EACH GENRE

SELECT prime_genre, track_name, user_rating
FROM (
  SELECT
  prime_genre,
   track_name,
   user_rating,
  RANK() OVER(PARTITION BY prime_genre ORDER BY user_rating DESC, rating_count_tot DESC) AS rank
  from AppleStore) as a
  where a.rank = 1



