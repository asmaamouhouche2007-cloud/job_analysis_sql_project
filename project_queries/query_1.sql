-- the first question we will answer is :
-- what are the top 10 highest-paying data 
--analyst roles that are available remotely ?

SELECT 
cd.name AS company_name,
jpf.job_title,
jpf.job_title,
jpf.job_schedule_type,
jpf.salary_year_avg,
jpf.job_posted_date
FROM job_postings_fact jpf
JOIN company_dim cd
ON jpf.company_id=cd.company_id
AND trim(lower(jpf.job_title_short))='data analyst'
AND lower(TRIM(jpf.job_location))='anywhere'
AND jpf.salary_year_avg IS NOT NULL
ORDER BY jpf.salary_year_avg DESC
LIMIT 10;