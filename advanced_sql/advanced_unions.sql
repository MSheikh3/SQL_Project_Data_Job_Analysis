---- Unions ------

/*

"Very important for combining tables"

What is a damn union?

Def: Combine result sets of two or more SELECT statements into a single result set

UNION: Removes duplicate rows

UNION ALL: Includes all duplicate rows

Note: Each select statement within the Union must have the same number of columns in the results sets with similar
data types

"Opposite of what we do with joins"

Joins are used in cases where we want to combine tables that relate on on a single "value" -e.g id columns

Remember the month tables we created

If we wanted to combine them row wise e.g stack ontop of each other
We can use the union operator

Union example

Select column_name
From table_one

UNION -- combine the two tables

Select column_name
From table_two

Must have same number of columns
*/

--Get jobs and companies in january

SELECT 
    job_title_short,
    company_id,
    job_location
FROM january_jobs;

--Join with feb jobs

SELECT 
    job_title_short,
    company_id,
    job_location
FROM january_jobs

UNION

SELECT 
    job_title_short,
    company_id,
    job_location
FROM february_jobs;


--More commonly used is union all

SELECT 
    job_title_short,
    company_id,
    job_location
FROM january_jobs

UNION ALL

SELECT 
    job_title_short,
    company_id,
    job_location
FROM february_jobs

UNION ALL

SELECT 
    job_title_short,
    company_id,
    job_location
FROM march_jobs;
