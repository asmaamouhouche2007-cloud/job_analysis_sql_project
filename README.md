# Introduction 
This project provides an in-depth exploration of the current computer science job market, with a specific focus on Data Analyst roles.

Through this analysis, we aim to answer five key questions about the landscape for data analysts, focusing on the intersection of high demand and high compensation. This investigation will cover:

💰 Top-Paying Data Analyst Roles: Identifying the positions with the highest salary offerings.

🏆 Most In-Demand Skills: Pinpointing the core competencies employers are actively seeking.

🎯 High-Paying Skills: Determining which specific skills command the highest salaries.

By examining these three critical pillars—roles, demand, and compensation—this study seeks to provide actionable insights for both job seekers looking to maximize their earning potential and professionals planning their career development in the data analytics field.
 🔍 To answer the questions , I used SQL queries , you can find them in the following folder  : [project_queries folder](/project_queries/)
# Background 
Motivated by the challenge of navigating the competitive tech job market, this project was developed to identify the highest-paying roles and the most sought-after skills, simplifying the job search process for data professionals.

The data for this analysis is sourced from the [SQL Course](https://www.youtube.com/watch?v=7mz73uXD9DA&t=14295s) of [Luke Barousse](https://www.youtube.com/watch?v=7mz73uXD9DA&t=14295s), providing comprehensive information on job titles, salaries, locations, and in-demand skills.
### Questions I will answer through SQL queries :
1. What are the top-paying data analyst jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for data analysts?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn?
# Tools I used :
In order to conduct this study I used a lot of essential and powerful tools such as :
- **SQL :** this is the backbone of the project since it allows me to query the data base easily
- **PostgreSQL :** the chosen dialect of sql to comunicate with the db ince it is the most popular language for data analysis .
- **Visual Studio Code:** the IDE I often use to write codes and queries 
- **Git and GitHub :** for version control and in order to share this project with others  
# The analysis
Each query aims to answer a specific question regarding the job market of data analyst  to collect insights that may help those who are intrested in this role , here is how I approached each question :
### 1. What are the top-paying data analyst jobs?
To answer this question I joint two diffrent tables 
**job_postings_fact** and **company_dim** based on the the job id , then I ordered the result by salary , I limited the output to only the top 10 paying roles .
 ```sql
SELECT 
jpf.job_id,
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
```
Based on the result of the query I noticed :
- **Wide Salary Range** :Salaries for these top 10 paying jobs vary between $184,000 and $650,000 depending on the role and company, demonstrating significant earning potential in the field.
- **Various Roles**: There is a wide variety of data analyst roles demanded by companies — from Data Analyst Director to Principal Data Analyst — indicating a diverse and dynamic job market.
- **Diversity Of Employers**:Data analysts are needed across multiple industries, including tech, finance, and autonomous vehicles. This is reflected by the presence of major companies like Meta, AT&T, SmartAsset, and Motional in the results.

![Top paying data analyst roles](C:/Users/ACER/Desktop/job_analysis_sql_project/assets/first.png)
*bar graph vizualizing salaries of top paying data analyst roles in 2023*

### 2. What skills are required for these top-paying jobs?
To answer this question I used the previous query inside a cte , then I joined it with the other two tables related to skills in order to , I added the count of each skill after grouping by skill_id .
``` sql
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
```
 Here is the breakdown of the skills needed for the top paying jobs :
- **Variety of Skill Types:** The top-paying jobs require a diverse set of skills, including programming languages like SQL, Python, R, and Go; analytics and visualization tools such as Tableau, Excel, and Power BI; cloud platforms like Snowflake, Azure, AWS, and Oracle; and data science libraries including pandas, NumPy, PySpark, and Jupyter, along with other specialized skills.

- **SQL, Python, and Tableau in High Demand:** Among the most sought-after skills, SQL leads with an 8/10 demand rate, followed closely by Python at 7/10, and Tableau at 6/10.
### 3. What skills are most in demand for data analysts?
To answer this question I created a cte in which I filtered data analyst job titles from the skills_job_dim table then I joined it with the skills_job_dim table then I selected from the result the count of each skill as the demand . then I selected in the final query the skill id, demand and skills and type after joining the cte with the skills_dim table .
``` sql
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
LIMIT 30;
```
Here is the breakdown of the most in demand skills for data analyst roles :
- **SQL** and **excel** are very important , which indicates the importance of having strong foundation in data processing and manipulation .
-**Programming** and **Visualization tools** like **Python**,**Tableau** and **Power bi** are essential pointing to the increase importance of technical skills in data storytelling and decision support .
<div align="center">

| skills  | demands |
|:--------|--------:|
|SQL      |7291     |
|Excel    |4611     |
|Python   |4330     |
|Tableau  |3745     |
|Power bi |2609     |
</div>

**Top 5 Most In-Demand Data Analyst Skills**
### 4. Which skills are associated with higher salaries?
in order to answer this question I joint all the tables then I selected the skills , type as well as the average salary associated with these skills . 
``` sql
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
```
Here's a breakdown of the results for top paying skills for Data Analysts:

* **High Demand for Big Data & ML Skills:** Top salaries are commanded by analysts skilled in big data technologies (Couchbase), machine learning tools (DataRobot, Jupyter), and Python libraries (Pandas, NumPy), reflecting the high valuation of data processing and predictive modeling capabilities.
* **Software Development & Deployment Proficiency:** Knowledge in development and deployment tools (GitLab, Kubernetes, Airflow) indicates a lucrative crossover between data analysis and engineering, with a premium on skills that facilitate automation and efficient data pipeline management.
* **Cloud Computing Expertise:** Familiarity with cloud and data engineering tools (Elasticsearch, Databricks, GCP) underscores the growing importance of cloud-based analytics environments, suggesting that cloud proficiency significantly boosts earning potential in data analytics.

| Skills | Average Salary ($) |
| :--- | ---: |
| pyspark | 208,172 |
| bitbucket | 189,155 |
| couchbase | 160,515 |
| watson | 160,515 |
| datarobot | 155,486 |
| gitlab | 154,500 |
| swift | 153,750 |
| jupyter | 152,777 |
| pandas | 151,821 |
| elasticsearch | 145,000 |

**Table of average salary for the top 10 paying skills for data analysts**
### 5. What are the most optimal skills to learn?
To answer this question I used the result of the previous two queries , and joined both of them based on the skill id (inner join) .
``` sql
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
```
here is the breakdown of the optimal skills to learn ( top paying and highely demanded skills ):
- **Programming, Machine Learning, and Cloud Skills** emerge as the most valuable skills for data analysts to acquire. This highlights the importance of a strong programming foundation, combined with expertise in cloud-based data processing and manipulation.
- **Deployment skills**  are also highly valued, reflecting the growing demand for analysts who can operationalize models and work effectively in production-oriented engineering environments.
# What I learned :
Throughout this project I learned a lot of new things :
- **Inhancing my SQL skills** In this project I learned how to break down the problems into small steps then implement them using sql queries with the help of  ctes , data aggregations.
- **Improving My Analytical Skills** during this journey I leveled up my analytical skills 
- **Exploring the Practical Side of sql and Data vizualisation** since this is my first data science project, I learned how to apply what I learned in a real world project , I also built my first readme file .
# Conclusion :
## Key Insights :
1. Top-Paying Data Analyst Jobs: The highest-paying jobs for data analysts offer a wide range of salaries, the highest at $650,000!

2. Skills for Top-Paying Jobs: High-paying data analyst jobs require advanced proficiency in SQL, suggesting it’s a critical skill for earning a top salary.

3. Most In-Demand Skills: SQL is also the most demanded skill in the data analyst job market, thus making it essential for job seekers.

4. Skills with Higher Salaries: Specialized skills, such as SVN and Solidity, are associated with the highest average salaries, indicating a premium on niche expertise.

5. Optimal Skills for Job Market Value: SQL leads in demand and offers for a high average salary, positioning it as one of the most optimal skills for data analysts to learn to maximize their market value.

## Closing thoughts :
This project was a valuable opportunity to apply my SQL and analytical skills in a real-world context. It was driven by a personal curiosity to understand which skills truly matter most for data analysts—particularly those that are both highly demanded and well-compensated. My goal was to provide job seekers with actionable insights to help them focus their learning and make more informed career decisions.
