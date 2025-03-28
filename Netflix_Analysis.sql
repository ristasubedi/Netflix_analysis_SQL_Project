DROP TABLE IF EXISTS netflix_try;
CREATE TABLE netflix(
	show_id	VARCHAR(5),
	type VARCHAR(7),
	title VARCHAR(104),
	director VARCHAR(208),
	casts VARCHAR(1000),	
	country VARCHAR(123),
	date_added VARCHAR(19),	
	release_year INT,
	rating VARCHAR(10),
	duration VARCHAR(15),	
	listed_in VARCHAR(100),	
	description VARCHAR(250)
);

SELECT * FROM netflix;

--Check if we have imported all the data correctly
SELECT 
	COUNT(*) as total_count
FROM netflix;

--Show distinct type of the content
SELECT DISTINCT type FROM netflix;

--Solving business problems

--1. Count the the number of movies vs TV shows
SELECT
	type, COUNT(*) as total_content
FROM netflix
GROUP BY type;


--2. Find the most common rating for movies and TV shows

SELECT
	type, 
	rating
FROM
(
	SELECT 
		type,
		rating,
		COUNT(*),
		RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) as ranking
	FROM netflix
	GROUP BY 1, 2
) as t1
WHERE
	ranking=1;

--3. List all the movies released in a specefic year(eg 2008)
SELECT
	title, release_year
FROM netflix
WHERE release_year=2020;
-------------or
SELECT
	*
FROM netflix
WHERE type='Movie' and
release_year=2008;

--5 Top 5 countries with most content on Netflix
SELECT
	UNNEST(STRING_TO_ARRAY(country,',')) as new_country,
	COUNT(show_id) as total_content
FROM netflix
WHERE country IS NOT NULL
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;


--4. Longest movie or TV Show duration
SELECT
	*
FROM netflix
WHERE type='Movie' and duration=(SELECT MAX(duration) FROM netflix);

--5. Content added in the last 5 years
SELECT
	*
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY')>=CURRENT_DATE - INTERVAL '5 years';

--6 Find all movies/TV shows by director 'Rajiv Chikala'
SELECT
	title,
	director
FROM netflix
WHERE director LIKE '%Rajiv Chilaka%';

--7 List all the TV Shows with more than 5 seasons
SELECT
	*
From netflix
WHERE 
	type='TV Show'
	AND
	SPLIT_PART(duration,  ' ', 1)::numeric > 5;

--8. Count the number of content data in each genre
SELECT
	UNNEST(STRING_TO_ARRAY(listed_in, ',')),
	COUNT(show_id)as total_content
FROM netflix
GROUP BY 1;

--9 Each year and average number of content released by India on netflix
--Return top 5 year with highest average content release
SELECT
	EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) as year, 
	COUNT(*) as content_released,
	ROUND(
	COUNT(*)::numeric/(SELECT COUNT(*) FROM netflix where country='India')::numeric * 100, 2)
	as Averaged
FROM netflix
WHERE country='India'
GROUP BY 1;

--10. List all movies that are documentries

SELECT 
	show_id,
	listed_in
FROM netflix
WHERE 
	type='Movie'
	AND
	listed_in LIKE '%Documentaries%'
;

--11. Find all content without director
SELECT * FROM netflix
WHERE director IS NOT NULL;

--12. Find how many movies actor'Salman Khan' appeared in in Last 10 years
SELECT
	*
FROM netflix
WHERE casts ILIKE '%Salman Khan%'
AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;

--13. Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India
 
SELECT
	UNNEST(STRING_TO_ARRAY(casts, ',')) as actors,
	COUNT(*) as num
FROM netflix
WHERE country ILIKE '%India%'
GROUP BY 1
ORDER BY num DESC
LIMIT 10;

--14. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords

SELECT *,
	CASE
		WHEN description ILIKE '%Kill%'
		OR description ILIKE '%violence%' THEN 'Bad Content'
		ELSE 'Good Content'
	END Category
FROM netflix;

WITH new_netflix as
(SELECT *,
	CASE
		WHEN description ILIKE '%Kill%'
		OR description ILIKE '%violence%' THEN 'Bad Content'
		ELSE 'Good Content'
	END Category
FROM netflix)
SELECT
	Category,
	COUNT(*)
FROM new_netflix
GROUP BY category;