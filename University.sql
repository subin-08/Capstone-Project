use University

select * from country;
select * from ranking_criteria;
select * from ranking_system;
select * from university;
select * from university_ranking_year;
select * from university_year;



--1 total score with respect to ranking system id
SELECT 
	a.id, 
	SUM(c.score) AS scores
FROM ranking_system a
JOIN 
	ranking_criteria b ON a.id = b.ranking_system_id
JOIN 
	university_ranking_year c ON b.id = c.ranking_criteria_id
GROUP BY 
	a.id
ORDER BY 
	SUM(c.score) DESC;


--2 How has the number of universities changed over the years in each country
select 
	c.year as years, 
	b.country_name, 
	count(a.id) as number_of_Universities 
from university a
	join 
		country b on a.country_id = b.id
	join 
		university_ranking_year c on b.id = c.university_id
group by 
	b.country_name, c.year
order by 
	c.year, b.country_name

--3  calculate number of international students according to the ranking system

SELECT 
    a.year, 
    d.id AS ranking_system_id, 
    SUM((a.num_students * a.pct_international_students) / 100) AS int_students
FROM 
    university_year a
JOIN 
    university_ranking_year b ON b.university_id = a.university_id
JOIN 
    ranking_criteria c ON b.ranking_criteria_id = c.id
JOIN 
    ranking_system d ON d.id = c.ranking_system_id
GROUP BY 
    a.year, d.id
ORDER BY 
    a.year, d.id;


--4.	Are there any common criteria used by different ranking systems?



--5 What is the trend in university rankings over the years according to each system?

SELECT 
	c.system_name, 
	a.university_id, 
	a.year as years,
	sum(a.score) AS scores
FROM university_ranking_year a
JOIN 
	ranking_criteria b ON a.ranking_criteria_id = b.id
join 
	ranking_system c ON b.ranking_system_id = c.id
GROUP BY 
	c.system_name,
	a.university_id,
	a.year
ORDER BY 
	a.university_id,
	a.year,
	sum(a.score) desc

--6 How does the choice of ranking system affect a university's international student enrolment?

SELECT 
	a.university_id, 
	d.id,a.year ,
	SUM(b.score) as scores 
FROM university_year a
JOIN 
	university_ranking_year b on a.university_id = b.university_id
JOIN 
	ranking_criteria c on b.ranking_criteria_id = c.id
JOIN 
	ranking_system d on c.ranking_system_id = d.id
GROUP BY 
	a.year, 
	a.university_id, 
	d.id
ORDER BY 
	scores desc;




--7.	Are there any criteria that have different weights in different ranking systems?

--8.	How have the weights of ranking criteria changed over time?


--9.	Is there a relationship between a university's score and the student-staff ratio?



--10 How does the number of female students differ among universities?

SELECT
    B.id,
    B.university_name,
    ROUND(SUM(A.num_students * A.pct_female_students / 100), 0) AS female_students
FROM
    university_year A
JOIN
    university B ON A.university_id = B.id
GROUP BY
    B.id, B.university_name
ORDER BY
    female_students DESC;

--11 What is the distribution of universities across different countries?


select b.country_name, COUNT(a.id) number_of_universities from university a
join country b on a.country_id = b.id
group by b.country_name
order by 1;


--12.	How has the ranking of universities changed over the years?

select * from university_ranking_year
where year = 2011
order by university_id;

--13.	What is the trend in the percentage of female students over time?

SELECT
    year,
    Round(AVG(pct_female_students),2) AS avg_female_percentage
FROM
    university_year
GROUP BY
    year
ORDER BY
    year;

--14.	How has the ranking score of universities evolved over the years?

select 
year, 
round(avg(score),2) as average_score
from university_ranking_year
group by year
order by year;




--15.	Is there a relationship between a university's ranking score and the number of students over time?


SELECT
    a.year,
    a.University_id,
    a.num_students,
    b.score AS ranking_score
FROM
    university_year a
JOIN
    university_ranking_year b ON a.University_id = b.University_id
WHERE
    b.score IS NOT NULL
    AND a.num_students IS NOT NULL
ORDER BY
    a.year, a.University_id;





------------------------------------------------------EDA Analysis Self----------------------------------------------------------------------------------

--- 1 Number of Universities that comes under different tanking system
select d.system_name, COUNT(distinct(a.university_id)) from university_year a
join university_ranking_year b on a.university_id = b.university_id
join ranking_criteria c on b.ranking_criteria_id = c.id
join ranking_system d on c.ranking_system_id = d.id
group by d.system_name;



-- 2 calculate number of female students with respect to ranking system and criteria for each year
	SELECT 
    a.id, 
    a.system_name,
    c.year, 
    b.id AS criteria_id,
    b.criteria_name, 
    SUM((d.num_students) * (d.pct_female_students) / 100) AS female_students
FROM 
    ranking_system a
JOIN 
    ranking_criteria b ON a.id = b.ranking_system_id
JOIN 
    university_ranking_year c ON b.id = c.ranking_criteria_id
JOIN 
    university_year d ON c.university_id = d.university_id
GROUP BY 
    a.id, c.year, a.system_name, b.id, b.criteria_name
ORDER BY 
    a.id, c.year;


--3 calculate number of international students with respect to ranking system and criteria for each year
SELECT 
    a.id, 
    a.system_name,
    c.year, 
    b.id AS criteria_id,
    b.criteria_name, 
    SUM((d.num_students) * (d.pct_international_students) / 100) AS international_students
FROM 
    ranking_system a
JOIN 
    ranking_criteria b ON a.id = b.ranking_system_id
JOIN 
    university_ranking_year c ON b.id = c.ranking_criteria_id
JOIN 
    university_year d ON c.university_id = d.university_id
GROUP BY 
    a.id, c.year, a.system_name, b.id, b.criteria_name
ORDER BY 
    a.id, c.year;



-- 4 total score with respect to ranking system id in each year
SELECT 
	a.id, 
	a.system_name, 
	c.year, 
	SUM(c.score) AS scores
FROM ranking_system a
JOIN 
	ranking_criteria b ON a.id = b.ranking_system_id
JOIN 
	university_ranking_year c ON b.id = c.ranking_criteria_id
GROUP BY 
	a.id, 
	c.year, 
	a.system_name
ORDER BY 
	a.id, 
	c.year;



-- 5  total score with respect to ranking system id
SELECT 
	a.id, 
	SUM(c.score) AS scores
FROM ranking_system a
JOIN 
	ranking_criteria b ON a.id = b.ranking_system_id
JOIN 
	university_ranking_year c ON b.id = c.ranking_criteria_id
GROUP BY 
	a.id
ORDER BY 
	SUM(c.score) DESC;