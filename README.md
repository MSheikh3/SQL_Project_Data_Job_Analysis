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

This query identifies the top 5 most in-demand skills for remote Data Analyst roles.

To do this, I joined the job postings table with the skills mapping table and the skills dimension table. This allowed each job posting to be linked to its required skills. I then filtered the dataset to include only Data Analyst roles where working from home was available.

After filtering the relevant job postings, I grouped the results by skill and counted how many job postings mentioned each skill. The results were then ordered by demand count in descending order to highlight the most frequently requested skills.

This analysis helps identify the core skills employers most commonly look for in remote Data Analyst roles, providing a clearer view of which technical skills are most valuable to prioritise.

```sql

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


```


### 4. Which Skills Are Associated with Higher Salaries?

This query investigates the relationship between technical skills and salary by calculating the average salary for Data Analyst roles that require each skill.

To perform the analysis, I joined the job postings table with the skills mapping table and skills dimension table, linking salary information to the skills requested in each job posting. I then filtered the dataset to include only Data Analyst roles with available salary information.

The results were grouped by skill, and the average annual salary was calculated for each one. Finally, the skills were ranked by average salary in descending order to identify which technologies and tools were most commonly associated with higher-paying Data Analyst positions.

This analysis provides insight into the skills that may offer the greatest earning potential and highlights the value of specialised technical expertise within the data analytics field.


```sql
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

```



### 5. What are the most optimal skills?

### 5. What Are the Most Optimal Skills for Data Analysts?

This query combines skill demand and salary data to identify the most optimal skills for Data Analysts. Rather than analysing demand and salary separately, this approach evaluates which skills offer the best balance between market demand and earning potential.

To achieve this, I created two Common Table Expressions (CTEs). The first calculated how frequently each skill appeared in remote Data Analyst job postings, while the second calculated the average salary associated with each skill using only postings that included salary information.

The two datasets were then joined using `skill_id`, allowing demand and salary metrics to be compared side by side. To improve the reliability of the results, skills with very low demand were excluded by applying a minimum demand threshold.

Finally, the results were ranked by average salary and demand count, highlighting skills that are both highly valued by employers and associated with strong compensation. This provides a more balanced view of which skills are most worthwhile for aspiring Data Analysts to develop.

```sql
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


```


# What I learned

### Insights

***1. Top-paying data analyst jobs***: The highest-paying opportunities were generally not entry-level Data Analyst positions. Instead, they were specialist, senior, or leadership-focused roles, suggesting that combining analytical skills with domain expertise and technical specialisation is a key driver of salary growth within the data profession.

Finance and other data-intensive industries appear willing to pay a premium for advanced analytical expertise.



***2. Skills required for top paying jobs***: While SQL emerged as the most universally required skill, the highest-paying opportunities typically demanded a combination of SQL, Python, cloud technologies, and visualisation tools. This suggests that analysts who develop both analytical and data engineering capabilities are likely to be better positioned for higher-paying roles.

***3. Most in demand skills for data analysts***: 

The results show that SQL is the dominant skill in the Data Analyst job market, appearing in substantially more postings than any other technology. However, employers are increasingly seeking analysts who can complement SQL with programming skills such as Python and communicate insights through visualisation tools like Tableau and Power BI. Together, these skills form the core toolkit required for modern Data Analyst roles.


***4. Skills associated with higher salaries***:

The highest-paying skills were generally specialised technologies rather than the core tools most commonly associated with Data Analyst roles. Skills such as Solidity, Terraform, Kafka, Airflow, TensorFlow, PyTorch, and Hugging Face were among those linked to the highest average salaries.

A notable trend was the strong presence of machine learning and data engineering technologies. This suggests that roles requiring expertise in data infrastructure, cloud platforms, and advanced analytics tend to command higher salaries than traditional reporting-focused positions.

The results also indicate that technical depth can significantly increase earning potential. While skills such as SQL, Excel, Tableau, and Power BI remain essential for many Data Analyst roles, employers appear willing to pay a premium for candidates who can work with modern data platforms and machine learning frameworks.

It is important to note that this analysis ranks skills based solely on average salary. Some of the highest-paying skills may appear in a relatively small number of job postings, meaning their averages can be influenced by a limited number of highly paid roles. Therefore, these results should be interpreted as indicators of potential earning power rather than a direct measure of market demand.



***5. Most optimal skills?***:

### Key Findings

This analysis revealed that the most valuable skills are not necessarily the most common skills, but those that combine strong demand with above-average salaries.

Python emerged as one of the strongest overall skills, appearing in 236 job postings while also being associated with an average salary exceeding $100,000. This suggests that Python offers both strong employment opportunities and attractive earning potential.

Several cloud and data platform technologies also stood out, including Snowflake, Azure, AWS, BigQuery, and Redshift. Although these skills appeared less frequently than SQL or Python, they were associated with some of the highest average salaries in the dataset. This indicates that expertise in modern data infrastructure can provide a significant salary advantage.

Business intelligence and reporting tools such as Tableau and Looker also performed strongly. Tableau appeared in 230 job postings with an average salary close to $100,000, demonstrating that data visualisation remains a highly valuable skill for Data Analysts.

A broader trend across the results is the growing importance of combining core analytical skills with cloud and data engineering technologies. While foundational skills such as SQL, Python, and Tableau remain highly sought after, professionals who can also work with platforms such as Snowflake, AWS, and Azure may be better positioned for higher-paying opportunities.

Overall, the findings suggest that the most effective skill strategy is to build a strong foundation in analytics and visualisation while gradually developing expertise in modern cloud and data platform technologies.

# Conclusions

# Conclusions

This analysis explored the Data Analyst job market by examining salary trends, skill demand, and the relationship between technical skills and earning potential.

The results showed that SQL remains the foundational skill for Data Analysts, appearing more frequently than any other technology across job postings. However, employers increasingly seek candidates who can complement SQL with programming languages such as Python and business intelligence tools such as Tableau and Power BI.

While specialised technologies in machine learning, cloud computing, and data engineering were associated with the highest average salaries, these skills often appeared in fewer job postings. By combining salary and demand analysis, it became clear that the most valuable skills are those that balance both strong market demand and attractive compensation. Python, Tableau, AWS, Azure, and Snowflake emerged as particularly strong examples.

Overall, the findings suggest that aspiring Data Analysts should focus on building a strong foundation in SQL, Python, and data visualisation while gradually expanding into cloud and data engineering technologies. This combination provides the best balance of employability, career progression, and earning potential in the modern data analytics job market.

From a technical perspective, this project strengthened my SQL skills through the use of joins, aggregations, Common Table Expressions (CTEs), filtering, grouping, and data-driven analysis. More importantly, it reinforced the importance of translating raw data into actionable insights that can support career and business decision-making.

