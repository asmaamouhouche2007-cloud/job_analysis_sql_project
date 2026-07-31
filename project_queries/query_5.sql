--The last question will be answering is :
--what are the optimal skills to learn for the
--role of data analyst 'highly demanded and highly paid'
with highly_demanded as (  
    WITH remote_job_skills AS (   
SELECT sjd.skill_id,
count(*) as demands
FROM skills_job_dim sjd
join job_postings_fact jpf
ON jpf.job_id=sjd.job_id
AND LOWER(TRIM(job_title_short))='data analyst'
GROUP BY sjd.skill_id
)
SELECT 
sd.skill_id,sd.skills,sd.type,rjs.demands 
FROM skills_dim sd
JOIN remote_job_skills rjs
ON sd.skill_id=rjs.skill_id
order by rjs.demands DESC
LIMIT 50
 ), 
 highly_paid as (
SELECT
    skills_dim.skill_id,
    ROUND(AVG(salary_year_avg),0) AS avg_salary,
    skills_dim.skills,
    skills_dim.type
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = True
GROUP BY
    skills_dim.skill_id
ORDER BY
    avg_salary DESC
LIMIT 50
 )
 select hd.skills,
 hd.demands,
 hp.avg_salary
 from highly_demanded hd 
 join highly_paid hp
 on hd.skill_id=hp.skill_id;