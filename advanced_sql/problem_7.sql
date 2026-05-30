----- Advanced: Problem 7 --------

/*
Problem 7:

Find the count for the number of remote job postings per skill
    -Display the top 5 skills by their demand in the remote job
    -Include skill ID, name, and count of postings requiring the skill
*/


/*

How to tackle this?

The job_posting_fact table has our job postings but not the skill ids (from skills_job_id)
or the skill name (from skills_dim)

1.So we need to create a CTE that collects the number of job postings perskill. So we will need a join between 
job_postings_fact and skills_job_dim

2. Once we have that results set we need to combine that with our skills_dim table which actually
have the skill names

The join we will use here is Inner join because we want to get a count of jobs that actually exist  
since we don't care about values that don't exist we will use inner join

*/

--First lets look at all the skill ids that exist
-- We can see job ids have multiple skill ids
SELECT 
    job_id,
    skill_id
FROM
    skills_job_dim as skills_to_job;

--Inner Join

SELECT 
    skills_to_job.job_id,
    skill_id
FROM
    skills_job_dim as skills_to_job
INNER JOIN job_postings_fact AS job_postings on job_postings.job_id = skills_to_job.skill_id
WHERE 
    job_postings.job_work_from_home = TRUE; --need to add this to get jsut true results we want


-- We want to aggregate the skills id count

SELECT 
    job_id,
    skill_id
FROM
    skills_job_dim as skills_to_job;

--Inner Join

SELECT 
    skills_to_job.job_id,
    skill_id
FROM
    skills_job_dim as skills_to_job
INNER JOIN job_postings_fact AS job_postings on job_postings.job_id = skills_to_job.skill_id
WHERE 
    job_postings.job_work_from_home = TRUE; --need to add this to get jsut true results we want

--aggrgation of our skill count
-- Remove job_id from select as it will throw off the group by
SELECT 
    skill_id,
    count(*) AS skill_count
FROM
    skills_job_dim as skills_to_job
INNER JOIN job_postings_fact AS job_postings on job_postings.job_id = skills_to_job.skill_id
WHERE 
    job_postings.job_work_from_home = TRUE --need to add this to get jsut true results we want
group by
    skill_id;

-- So our CTE is ready we just need to build it


WITH remote_job_skills AS (
    SELECT 
        skill_id,
        count(*) AS skill_count
    FROM
        skills_job_dim as skills_to_job
    INNER JOIN job_postings_fact AS job_postings on job_postings.job_id = skills_to_job.skill_id
    WHERE 
        job_postings.job_work_from_home = TRUE --need to add this to get jsut true results we want
    group by
        skill_id
)

SELECT *
FROM remote_job_skills;


--Now with the cte we have the job_posting fact info combined with skills_job_dim data
--to get the count of skills we need to do another join to get the skill names from skills_dim


WITH remote_job_skills AS (
    SELECT 
        skill_id,
        count(*) AS skill_count
    FROM
        skills_job_dim as skills_to_job
    INNER JOIN job_postings_fact AS job_postings on job_postings.job_id = skills_to_job.job_id
    WHERE 
        job_postings.job_work_from_home = TRUE --need to add this to get jsut true results we want
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

--specificly for data analysts we add in and to the where statement

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