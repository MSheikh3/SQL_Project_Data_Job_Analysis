/*

Question: What are the most in demand skills fo DA?
- Join job postings to inner join table similar to query 2
- Identify top 5 in demand skills for DA
- Focus on all job postings

We already have a count of the most most in demand skills for DA in a query
But we will create a refined version here
*/

--Previous query that we built

WITH remote_job_skills AS (
    SELECT 
        skill_id,
        count(*) AS skill_count
    FROM
        skills_job_dim as skills_to_job
    INNER JOIN job_postings_fact AS job_postings on job_postings.job_id = skills_to_job.job_id
    WHERE 
        job_postings.job_work_from_home = TRUE AND
        job_postings.job_title_short = 'Data Analyst'
    group by
        skill_id
)

SELECT -- we need to add what we want to see here
    skills.skill_id,
    skills as skill_name, --I assume I dont need to specify the table as it's only in the skills/skill_id table
    skill_count
FROM remote_job_skills
INNER JOIN skills_dim as skills on remote_job_skills.skill_id = skills.skill_id
ORDER BY skill_count DESC
LIMIT 5;

-- Take what we need from query 2

SELECT *
FROM job_postings_fact
INNER JOIN skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
LIMIT 5

--We want an aggregation of the skills, so we need a count

SELECT 
    skills,
    count(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
group by
    skills
order by
    demand_count desc
LIMIT 5

--Add in condition for DA

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




