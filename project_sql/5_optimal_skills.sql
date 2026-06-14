/*

Question: What are the most optimal skills?

This query identifies the most optimal skills for Data Analysts by combining
two key measures: demand and salary.

Query 3 showed which skills appear most often in job postings, while Query 4
showed which skills are associated with the highest average salaries. However,
looking at either measure in isolation can be misleading. A highly demanded
skill may not offer the highest salary, while a high-paying skill may only
appear in a small number of postings.

To create a more realistic view, this query uses CTEs to calculate both demand
count and average salary for each skill, then joins the results together using
skill_id. A minimum demand threshold is applied to reduce the impact of rare
skills and outliers.

The final output highlights skills that offer a stronger balance between job
market demand and earning potential.

*/

--We start with defining the cte for q3 and 4

--Q3 SKills demand
WITH skills_demand as (
    SELECT 
        skills,
        count(skills_job_dim.job_id) AS demand_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
    where
        job_title_short = 'Data Analyst' and--this needs to be after the join 
        job_work_from_home = TRUE
    group by
        skills
    order by
        demand_count desc
    LIMIT 5
)

--Q4 Salary demand
with average_salary as (
SELECT 
    skills,
    round(avg(salary_year_avg),0) as avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
where
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL
    -- and job_work_from_home = TRUE
group by
    skills
order by
    avg_salary desc
LIMIT 25
)

--Now we need to combine them on a key/column
--Best practice is to use a Primary or foreign key like skill_id
--Remove the limits and order by
--Change the order by to use skill_id instead of skill (this is best practice)
-- You need to group the 2 ctes together e.g share same with statement
--Looks like the source table needs to be consistent

WITH skills_demand as (
    SELECT 
        skills_dim.skill_id,
        skills_dim.skills,
        count(skills_job_dim.job_id) AS demand_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
    where
        job_title_short = 'Data Analyst' and--this needs to be after the join 
        job_work_from_home = TRUE AND
        salary_year_avg IS NOT NULL
    group by
        skills_dim.skill_id

), average_salary as (
SELECT 
    skills_dim.skill_id,
    round(avg(salary_year_avg),0) as avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
where
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL
    -- and job_work_from_home = TRUE
group by
    skills_dim.skill_id
)

select
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    avg_salary
from
    skills_demand
inner join  average_salary on skills_demand.skill_id = average_salary.skill_id-- we only want the intercept between results sets
order by
    demand_count desc, --we mention this first as we priorites the demand for a skill
    avg_salary desc -- we can also add in another order by condition, “Sort by this first… and if there’s a tie, then sort by something else.”
limit 25

-- We notice if you order on avg_salary first the higer paying skills
-- Have quite low demand
--We can add in a where command to remove lower demand skills   

WITH skills_demand as (
    SELECT 
        skills_dim.skill_id,
        skills_dim.skills,
        count(skills_job_dim.job_id) AS demand_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
    where
        job_title_short = 'Data Analyst' and--this needs to be after the join 
        job_work_from_home = TRUE AND
        salary_year_avg IS NOT NULL
    group by
        skills_dim.skill_id

), average_salary as (
SELECT 
    skills_dim.skill_id,
    round(avg(salary_year_avg),0) as avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
where
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL
    and job_work_from_home = TRUE
group by
    skills_dim.skill_id
)

select
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    avg_salary
from
    skills_demand
inner join  average_salary on skills_demand.skill_id = average_salary.skill_id-- we only want the intercept between results sets
where
    demand_count > 10
order by
    avg_salary desc,
    demand_count desc 
limit 25

-- we can make this more concise by essentially 
--combining the select statements 











