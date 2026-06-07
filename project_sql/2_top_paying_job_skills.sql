/*

Question: What skills are required for the top paying DA Jobs?
-Use the top-10 paying data analyst roles from the first query
-Add specific skills required for these roles
-Why? Provides a detailed look at the skills demanded for high paying jobs, helping
job seekers understand which skills to develop that allign with top salaries


Since we have a pre build query that we need to use, we can use a subquery or cte
Since this query is abit more complex we will use a CTE
*/


WITH top_paying_jobs as (
    SELECT 
        job_id,
        job_title,
        salary_year_avg,
        name as company_name
    FROM 
        job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title_short = 'Data Analyst' AND
        job_location = 'Anywhere' AND
        salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)

SELECT *
from top_paying_jobs

/*
-We need to join to 2 tables skills_job_dim for the skill_id and also
to skills_dim for the skill_name e.g skill

-What join method will we use?

-We typically only use left join or inner join. In our case the A would be the job_posting_fact
table. Since we only care about skills that are associated with a salary. So left join is not applicable
as it will give us every job (even if no skill id is associated to the job id)

-So we will use inner join

*/


WITH top_paying_jobs as (
    SELECT 
        job_id,
        job_title,
        salary_year_avg,
        name as company_name
    FROM 
        job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title_short = 'Data Analyst' AND
        job_location = 'Anywhere' AND
        salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)

SELECT 
    top_paying_jobs.*,--we can select all the columns from a specific source table
    skills
FROM top_paying_jobs
INNER JOIN skills_job_dim on top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
ORDER  BY 
    salary_year_avg desc;

-- We could pull this result as a csv create a visualisation
/*
What are findinfs would be are:

SQL is leading with a count of 8
Python with 7
Tablue with 6
R, snowflake, pandas and excel show varying level of demand
*/