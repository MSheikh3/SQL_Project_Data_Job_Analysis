-------- subqueries and CTEs--------

/*

Definitions:

Subqueries and Common Table Expressions (CTEs): Used for organising and simplifying complex queries.

-They help break down queries into smaller, more manageable parts

When to use one over the other:
-Subqueries are for simpler queries
-CTEs are for more complex ones

"They will allow us to create temporary tables for us to be able to perform 
some analysis on. Which will be useful when we have more complex queries. These
will allow us to break the queries up in to section"

-Looking back at when we created the jan- march tables
-These are in our database, to remove them we must drop them
-Instead we can use make temp tables

*/

--Def Subquerie: A querie nested inside a larger querie
-- You can use Select, From and Where clauses

--Using Subquerie to make a temp month table

-- In perenthasis () you specify the subquerie

SELECT *
FROM job_postings_fact
LIMIT 10;

--Add in the subqurie to the above querie

SELECT *
FROM ( --subquerie starts here
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
) AS january_jobs; --here we rename the table january_jobs
--Subquerie ends here

--Def CTEs: Define a temp result set that you can reference
--These can be used in even more locations like SELECT, INSERT, UPDATE or DELETE
--Defined first with WITH

WITH january_jobs AS ( --CTE defintion starts here
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
) --CTE definition ends here

SELECT *
FROM january_jobs; --need to specify the temp table you just defined

---------Harder example for Subqueries---------

--Subqueries 
--The order of operations. The () will be executed first and then everything around it is done after

--We want a list of companies offering jobs that don't require a degree

select 
        company_id,
        job_no_degree_mention
from    
        job_postings_fact
where
        job_no_degree_mention = true;

/*
-we don't have the company name information inside the 
job_posting_fact table. What we need is in the company_id table

-Using a subquery will be useful here as we will be able to 
filter for job ids that don't require a degree and then also
filter in the company_dim table to get the company names
for the job_ids that we want
*/

select 
    company_id,
    name as company_name
from 
    company_dim
where company_id in ( --subquery starts here
    select
            company_id
    from
            job_postings_fact
    where
            job_no_degree_mention = true
ORDER BY
            company_id
);--subquery ends here



/*

--------Harder example for CTEs---------

The results from the temp results set from the CTE can be used 
in things like SELECT, UPDATE, INSERT and DELETE

-We want to find the companies with the most job openings
-We need to break this up into 2 parts (hence why CTEs are perfect for this)

1. We need to get the total number of job postings per company_id

2. Then we need to combine this with the company name which is in the company_dim table

*/

-- want to aggtegate the company ids

Select
        company_id,
        count(*)-- this will count the number of rows
From
        job_postings_fact
GROUP BY --every time we aggregrate we need to specify what we are grouping by
        company_id;

--The above is the core statement that we will be using inside our CTE


with company_job_count as (
Select
        company_id,
        count(*)-- this will count the number of rows
From
        job_postings_fact
GROUP BY --every time we aggregrate we need to specify what we are grouping by
        company_id
) -- we dont want to add a semicolon here gives error

select *
FROM company_job_count; -- this will just query the temp result set that we just created above

/*
-Remeber the schema, we need info from the company_dim table
So will need to use a join function
We will use a Left Join. We will have job_postings_fact = B this will give us everything from A
and what ever is common in B (job_posting_fact) using the company_id column

A benefit to using left join is that. Maybe some companies don't have job postings. When aggregating
we only get a count of job postings that have a row for a job posting
By using company_dim table as A in out list we should also have compabies with a count of 0 e.g no 
job postings

!! This explanation from luke doesnt make sense to me as i expect A table to be company_dim table
but this isnt the case here :left join company_job_count on company_job_count.company_id = company_dim.company_id
*/

--no we can join using the temp results set that we defined

with company_job_count as (
Select
        company_id,
        count(*) as total_jobs-- this will count the number of rows
From
        job_postings_fact
GROUP BY --every time we aggregrate we need to specify what we are grouping by
        company_id
) -- we dont want to add a semicolon here gives error

select 
    company_dim.name as company_name,
    company_job_count.total_jobs
from company_dim
left join company_job_count on company_job_count.company_id = company_dim.company_id
ORDER BY 
    total_jobs DESC;


