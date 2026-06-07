/*

Question: What are the top skills based on salary?
- Look at the average salary associated with each skill for DA jobs
Why? It reveals how different skills impact salary levels

*/

--Like the last query we need the names of the skills from skills_dim
-- and the salary data from job_postings_dim. We previously did a count of 
--skills but now we will do an average of the average

SELECT 
    skills,
    avg(salary_year_avg) as avg_salary
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

--we can use round function on the average to clean up the output

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

