# Introduction

This project explores the data analyst job market using SQL to analyse real-world job posting data. The aim was to investigate salary trends, identify the most in-demand skills, and uncover the qualifications associated with higher-paying data analyst roles.

As someone currently working in marketing analytics and modelling, I completed this project to strengthen my SQL skills and gain more hands-on experience with exploratory data analysis. Through a series of SQL queries, I examined relationships between job titles, salaries, locations, remote work opportunities, and technical skills to generate actionable insights from the dataset.

The project demonstrates key SQL concepts including joins, common table expressions (CTEs), subqueries, aggregations, window functions, and data cleaning techniques. Beyond technical implementation, the focus was on translating data into meaningful business insights and presenting findings in a clear and structured way.

Check out the SQL queries here: [project_sql folder](/project_sql/)

# Background

The Data was provided by Luke Barousse. It's packed with insights on Job titles, salaries, locations, and essential skills.

### The questions I wanted to answer through my SQL queries were:

1. What are the top-paying data analyst jobs?

2. What skills are required for these top paying jobs?

3. What skills are most in demand for data analysts?

4. Which skills are associated with higher salaries?

5. What are the most optimal skills?

# Tools I used

For this deep dive into the data analyst job market, I used several tools:

- **SQL:** The backbone of the analysis, allowing me to query the database and unearth critical insights. 
- **PostgresSQL:** The chosen database management system, ideal for handling the job posting data.
- **Visual Studio Code:** My go-to database management and SQL queries.
- **Git and GitHub:** Essential for version control and sharing my SQL scripts and analysis, ensuring collaboration and project tracking.


# The Analysis

### 1. What are the top-paying data analyst jobs?
This query identifies the top 10 highest-paying Data Analyst roles based in the United Kingdom, focusing only on job postings where salary information is available.

I started by selecting the key job posting fields, including the job title, location, schedule type, average yearly salary, and posting date. I then filtered the data to focus specifically on Data Analyst roles in the United Kingdom and removed any records where the salary was missing. To make the results more informative, I joined the job postings table with the company table so that each role could be linked to the company name.

Finally, I ordered the results by average yearly salary in descending order and limited the output to the top 10 roles. This helps highlight the highest-paying Data Analyst opportunities and provides a foundation for further analysis into the skills associated with these roles.

```sql
SELECT 
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name as company_name
FROM 
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'United Kingdom' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;

```
### 2. What skills are required for these top paying jobs?

After identifying the highest-paying Data Analyst roles, I extended the analysis to investigate which skills were required for these positions.

Using a Common Table Expression (CTE), I first isolated the top 10 highest-paying remote Data Analyst jobs based on average annual salary. I then joined this subset of jobs to the skills mapping tables to retrieve the individual skills associated with each role.

This analysis allowed me to examine the technical requirements of high-paying positions and identify recurring skills across multiple employers. By linking salary information with skill requirements, I was able to determine which tools, programming languages, and technologies are most commonly requested in top-paying Data Analyst roles.

```sql
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

```


### 3. What skills are most in demand for data analysts?




### 4. Which skills are associated with higher salaries?




### 5. What are the most optimal skills?

# What I learned



```sql


```


# Conclusions

### Insights

***1. Top-paying data analyst jobs***: The highest-paying opportunities were generally not entry-level Data Analyst positions. Instead, they were specialist, senior, or leadership-focused roles, suggesting that combining analytical skills with domain expertise and technical specialisation is a key driver of salary growth within the data profession.

Finance and other data-intensive industries appear willing to pay a premium for advanced analytical expertise.



***2. Skills required for top paying jobs***: While SQL emerged as the most universally required skill, the highest-paying opportunities typically demanded a combination of SQL, Python, cloud technologies, and visualisation tools. This suggests that analysts who develop both analytical and data engineering capabilities are likely to be better positioned for higher-paying roles.

***3. Most in demand skills for data analysts***: 

***4. Skills associated with higher salaries***:

***5. Most optimal skills?***:


