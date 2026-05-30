--Advanced: Case Expressions

/*
These are similar to if statements in python
Where there is a condition you want to test if is true or false
From there you can assign a value for true or false
*/

--Usually case expressions are used in select statements but can also be used in WHERE

--Examples: 

/*
CASE: Begins the case expression
WHEN: Specifies condition we look at 
THEN: What to do when condition is true 
ELSE: (optional) - provides output if none of the when condtions are met
END: Concludes the case expression
AS: You can use aliases to name that new column
*/

--These are listed in written order

--example: want to reclasify where a job location is clasified at

SELECT 
    job_title_short,
    job_location
FROM job_postings_fact;

--we have some scenarios that we want to look at

/*

Label new column as follows:
- 'Anywhere' jobs as 'Remote'
- 'New York, NY' jobs as 'Local'
- Otherwise 'Onsite'

*/

SELECT 
    job_title_short,
    job_location, --you need to add a comma here as you are starting a new column
    CASE 
        WHEN job_location = 'Anywhere'  THEN 'Remote'
        WHEN job_location = 'New York, NY'  THEN 'Local'
        ELSE 'Onsite'
    END AS location_category
FROM job_postings_fact;

-- Can add in more conditions, and number of jobs
-- We need to aggregrate using group by and create sum of job id column

SELECT 
    count(job_id) as number_of_jobs,
    CASE 
        WHEN job_location = 'Anywhere'  THEN 'Remote'
        WHEN job_location = 'New York, NY'  THEN 'Local'
        ELSE 'Onsite'
    END AS location_category
FROM job_postings_fact
WHERE job_title_short = 'Data Analyst'
GROUP BY location_category;


