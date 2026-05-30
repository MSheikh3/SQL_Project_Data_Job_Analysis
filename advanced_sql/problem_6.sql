
--Practice Problem 6: Creat tables from other tables

SELECT * 
FROM job_postings_fact
LIMIT 10;

-- Next we want to get the jan table we neeed to filter for just jan data
SELECT *
FROM job_postings_fact
WHERE EXTRACT(MONTH from job_posted_date) = 1

--To actually create the table 
CREATE TABLE january_jobs AS
SELECT *
FROM job_postings_fact
WHERE EXTRACT(MONTH from job_posted_date) = 1;

CREATE TABLE february_jobs AS
SELECT *
FROM job_postings_fact
WHERE EXTRACT(MONTH from job_posted_date) = 2;

CREATE TABLE march_jobs AS
SELECT *
FROM job_postings_fact
WHERE EXTRACT(MONTH from job_posted_date) = 3;

--quick check
select job_posted_date
from march_jobs;


