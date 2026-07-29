-- the third question we will answer is :
-- what  are the most in demande skills for the 
-- role of a data analyst :

WITH remote_job_skills AS (   
SELECT sjd.skill_id,
count(*) as demands
FROM skills_job_dim sjd
join job_postings_fact jpf
ON jpf.job_id=sjd.job_id
WHERE job_work_from_home=TRUE
AND LOWER(TRIM(job_title_short))='data analyst'
GROUP BY sjd.skill_id
)
SELECT 
sd.skill_id,sd.skills,sd.type,rjs.demands 
FROM skills_dim sd
JOIN remote_job_skills rjs
ON sd.skill_id=rjs.skill_id
order by rjs.demands DESC
LIMIT 10;
