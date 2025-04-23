/*
Question: What are the most optimal skills to leanr (aka it's in high demand and a hig paying skill)?
- Identify skills in high demand and associated with high average salaries for Data Analyst roles
- Concentrates on remote positions with sepcified salaries
- Why? Targets skills that offer job security (high demand) and financial benefits ( high salaries),
    offering strategic insights for career development in data analysis
*/

WITH top_demanding_jobs AS (
    SELECT
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT(skills_job_dim.job_id) AS demand_count
    FROM job_postings_fact    
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst'
        AND salary_year_avg IS NOT NULL
        AND job_work_from_home = TRUE
    GROUP BY
        skills_dim.skill_id, skills_dim.skills
),

top_paying_skills AS (
    SELECT 
        skills_dim.skill_id,
        skills_dim.skills,
        ROUND(AVG(salary_year_avg), 0) AS average_salary_skill
    FROM job_postings_fact    
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst'
        AND salary_year_avg IS NOT NULL
    GROUP BY
        skills_dim.skill_id, skills_dim.skills
)

SELECT 
    top_demanding_jobs.skill_id,
    top_demanding_jobs.skills,
    top_demanding_jobs.demand_count,
    top_paying_skills.average_salary_skill
FROM
    top_demanding_jobs
INNER JOIN
    top_paying_skills ON top_demanding_jobs.skill_id = top_paying_skills.skill_id
WHERE
    demand_count > 10
ORDER BY
    average_salary_skill DESC,
    demand_count DESC
    
LIMIT 25