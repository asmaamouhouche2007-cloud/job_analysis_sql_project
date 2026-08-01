--the fourth question we will answer is :
--what are the top paying skills for 
-- data analyst roles regardless of the location ? 
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
GROUP BY
    skills_dim.skill_id
ORDER BY
    avg_salary DESC
LIMIT 30;