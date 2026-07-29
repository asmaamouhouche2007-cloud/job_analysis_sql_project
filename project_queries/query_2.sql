-- the second question we will be answering is :
-- what are the skills required for the top 10 paying 
-- data analyst roles ? 
-- this will help job seekers know what are the skills they 
-- need to develop to have the chance to apply for 
-- the top paying roles 

WITH top_10_paying_roles AS (  
SELECT 
jpf.job_id
FROM job_postings_fact jpf
JOIN company_dim cd
ON jpf.company_id=cd.company_id
AND trim(lower(jpf.job_title_short))='data analyst'
AND lower(TRIM(jpf.job_location))='anywhere'
AND jpf.salary_year_avg IS NOT NULL
ORDER BY jpf.salary_year_avg DESC
LIMIT 10
)
SELECT 
DISTINCT
sjd.skill_id,
sd.skills,
sd.type,
count(t10pj.*) AS demands
FROM top_10_paying_roles t10pj
JOIN skills_job_dim sjd 
ON sjd.job_id=t10pj.job_id
JOIN skills_dim sd 
ON sjd.skill_id=sd.skill_id
group by sjd.skill_id,sd.skills,sd.type
ORDER BY count(t10pj.*) DESC;

 