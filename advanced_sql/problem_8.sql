------ Practice Problem 8 -------

/*

Find job postings from the first quarter that have a salary greater than $70k
- Combine job postings tables from the first quarter of 2023 (Jan-Mar)
- Gets job positngs with an average yearly salary > $70,000

We already have tables from Jan to feb we will use UNion to join them
and then use a subquery to then analyse it
*/

SELECT *
FROM january_jobs
UNION ALL
SELECT *
FROM february_jobs
UNION ALL
SELECT *
FROM march_jobs;

--Build in the subquery

SELECT *
FROM (
SELECT *
FROM january_jobs
UNION ALL
SELECT *
FROM february_jobs
UNION ALL
SELECT *
FROM march_jobs
) as quarter1_job_postings;

--define the columns we want to answer the salary part

SELECT 
    quarter1_job_postings.job_title_short,
    quarter1_job_postings.job_location,
    quarter1_job_postings.job_via,
    quarter1_job_postings.job_posted_date::DATE
FROM (
SELECT *
FROM january_jobs
UNION ALL
SELECT *
FROM february_jobs
UNION ALL
SELECT *
FROM march_jobs
) as quarter1_job_postings
WHERE quarter1_job_postings.salary_year_avg > 70000

--Add more conditions


SELECT 
    quarter1_job_postings.job_title_short,
    quarter1_job_postings.job_location,
    quarter1_job_postings.job_via,
    quarter1_job_postings.job_posted_date::DATE,
    quarter1_job_postings.salary_year_avg
FROM (
SELECT *
FROM january_jobs
UNION ALL
SELECT *
FROM february_jobs
UNION ALL
SELECT *
FROM march_jobs
) as quarter1_job_postings
WHERE 
    quarter1_job_postings.salary_year_avg > 70000 and
    quarter1_job_postings.job_title_short = 'Data Analyst'
ORDER BY
    quarter1_job_postings.salary_year_avg DESC

--Dont need to mention source

SELECT 
    job_title_short,
    job_location,
    job_via,
    job_posted_date::DATE,
    salary_year_avg
FROM (
SELECT *
FROM january_jobs
UNION ALL
SELECT *
FROM february_jobs
UNION ALL
SELECT *
FROM march_jobs
) as quarter1_job_postings
WHERE 
    quarter1_job_postings.salary_year_avg > 70000 and
    quarter1_job_postings.job_title_short = 'Data Analyst'
ORDER BY
    quarter1_job_postings.salary_year_avg DESC







