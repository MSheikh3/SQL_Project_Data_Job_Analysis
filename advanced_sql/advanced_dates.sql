-- You can actually run a query without a FROM statement
SELECT '2023-02-19'; -- this gives us a column with a string

SELECT '2023-02-19'::DATE; -- BY using '::' you can cast the string as a DATE

-- From this query we can see that that the dates are timestamp data type
SELECT 
    job_title_short AS title,
    job_location AS location,
    job_posted_date AS date
FROM
    job_postings_fact;

-- If we just want the date  element and not the time we can specify using '::'

SELECT 
    job_title_short AS title,
    job_location AS location,
    job_posted_date::DATE AS date
FROM
    job_postings_fact;

--If we also want to include timezone in the date
-- Here we must specify time zone we are in and the new 
--timezone that we want to convert into

SELECT 
    job_title_short AS title,
    job_location AS location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS date_time
FROM
    job_postings_fact
LIMIT 5;

-- Next we will use the EXTRACT key word to things
--Out of the date, such as year, month,etc.
-- This needs to be in the select function

-- TO GET MONTH

SELECT 
    job_title_short AS title,
    job_location AS location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS date_time,
    EXTRACT(MONTH FROM job_posted_date) AS date_month
FROM
    job_postings_fact
LIMIT 5;

-- This is usefull for trend analysis as it will
-- allow me to look at data from month to month across years
-- by using the group by function

-- We will start off with a simple query and then build on it
-- This gives us job ids and the month of job posting
SELECT 
    job_id,
    EXTRACT(MONTH from job_posted_date) as month
From
    job_postings_fact
LIMIT 5;

--Now we want to aggregate
--So we want a count of these job by ids by each month
-- start with a count arounf job_id
-- specify group by on new month column

SELECT 
    count(job_id) AS job_count,
    EXTRACT(MONTH from job_posted_date) as month
From
    job_postings_fact
GROUP BY 
    month
LIMIT 5;

-- You can add some extras to the query like this

    SELECT 
        count(job_id) AS job_count,
        EXTRACT(MONTH from job_posted_date) as month
    From
        job_postings_fact
    WHERE
        job_title_short = 'Data Analyst'
    GROUP BY 
        month
    ORDER BY
        job_count DESC;  








