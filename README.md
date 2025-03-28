# Netflix Movies and TV Shows Data Analysis using SQL
![Netflix Logo](https://github.com/ristasubedi/Netflix_analysis_SQL_Project/blob/main/Netflix.jpeg)


## Overview
This project focuses on an in-depth analysis of Netflix's movies and TV shows data using SQL. The aim is to derive meaningful insights and address key business questions related to the dataset. This README outlines the project's objectives, business challenges, solutions, key findings, and conclusions.

## Objectives

-Examine the distribution between movies and TV shows.
-Determine the most frequent ratings for both movies and TV shows.
-Analyze content based on release years, countries, and durations.
-Classify and explore content using specific keywords and criteria.

## Dataset

The data for this project is sourced from the Kaggle dataset:

- **Dataset Link:** [Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

## Schema

```sql
ROP TABLE IF EXISTS netflix;
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

```

## Business Problems and Solutions

### 1. Count the Number of Movies vs TV Shows

```sql
SELECT
	type, COUNT(*) as total_content
FROM netflix
GROUP BY type;
```

**Objective:** Determine the distribution of content types on Netflix.

### 2. Find the Most Common Rating for Movies and TV Shows

```sql
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
```

**Objective:** Identify the most frequently occurring rating for each type of content.

### 3. List All Movies Released in a Specific Year (e.g., 2020)

```sql
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

```

**Objective:** Retrieve all movies released in a specific year.

### 4. Find the Top 5 Countries with the Most Content on Netflix

```sql
SELECT
	UNNEST(STRING_TO_ARRAY(country,',')) as new_country,
	COUNT(show_id) as total_content
FROM netflix
WHERE country IS NOT NULL
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;
```

**Objective:** Identify the top 5 countries with the highest number of content items.

### 5. Identify the Longest Movie

```sql
SELECT
	*
FROM netflix
WHERE type='Movie' and duration=(SELECT MAX(duration) FROM netflix);
```

**Objective:** Find the movie with the longest duration.

### 6. Find Content Added in the Last 5 Years

```sql
SELECT
	*
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY')>=CURRENT_DATE - INTERVAL '5 years';
```

**Objective:** Retrieve content added to Netflix in the last 5 years.

### 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

```sql
SELECT
	title,
	director
FROM netflix
WHERE director LIKE '%Rajiv Chilaka%';
```

**Objective:** List all content directed by 'Rajiv Chilaka'.

### 8. List All TV Shows with More Than 5 Seasons

```sql
SELECT
	*
From netflix
WHERE 
	type='TV Show'
	AND
	SPLIT_PART(duration,  ' ', 1)::numeric > 5;
```

**Objective:** Identify TV shows with more than 5 seasons.

### 9. Count the Number of Content Items in Each Genre

```sql
SELECT
	UNNEST(STRING_TO_ARRAY(listed_in, ',')),
	COUNT(show_id)as total_content
FROM netflix
GROUP BY 1;
```

**Objective:** Count the number of content items in each genre.

### 10.Find each year and the average numbers of content release in India on netflix. 
return top 5 year with highest avg content release!

```sql
SELECT
	EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) as year, 
	COUNT(*) as content_released,
	ROUND(
	COUNT(*)::numeric/(SELECT COUNT(*) FROM netflix where country='India')::numeric * 100, 2)
	as Averaged
FROM netflix
WHERE country='India'
GROUP BY 1;
```

**Objective:** Calculate and rank years by the average number of content releases by India.

### 11. List All Movies that are Documentaries

```sql
SELECT 
	show_id,
	listed_in
FROM netflix
WHERE 
	type='Movie'
	AND
	listed_in LIKE '%Documentaries%'
;
```

**Objective:** Retrieve all movies classified as documentaries.

### 12. Find All Content Without a Director

```sql
SELECT * FROM netflix
WHERE director IS NOT NULL;

```

**Objective:** List content that does not have a director.

### 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

```sql
SELECT
	*
FROM netflix
WHERE casts ILIKE '%Salman Khan%'
AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;
```

**Objective:** Count the number of movies featuring 'Salman Khan' in the last 10 years.

### 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India

```sql
SELECT
	UNNEST(STRING_TO_ARRAY(casts, ',')) as actors,
	COUNT(*) as num
FROM netflix
WHERE country ILIKE '%India%'
GROUP BY 1
ORDER BY num DESC
LIMIT 10;
```

**Objective:** Identify the top 10 actors with the most appearances in Indian-produced movies.

### 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords

```sql
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
```

**Objective:** Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.

## Findings and Conclusion

- **Content Classification: The dataset includes a diverse selection of movies and TV shows spanning different genres and ratings.
- **Rating Trends: Identifying the most frequent ratings offers insight into the primary audience demographics.
- **Regional Analysis: The prominence of India in content production and release patterns highlights geographical distribution trends.
- **Content Filtering: Categorizing content based on specific keywords such as 'kill' or 'violence' aids in assessing the nature of available content on Netflix.

This analysis provides a well-rounded perspective on Netflix's content landscape, supporting strategic content planning and decision-making.


## Author - Rista Subedi

