SELECT 
    *
FROM
    skills_dim

UNION

SELECT 
    job_title_short,
    company_id,
    job_location
FROM
    january_jobs
UNION

 SELECT 
    job_title_short,
    company_id,
    job_location
FROM
    february_jobs
UNION

SELECT 
    job_title_short,
    company_id,
    job_location
FROM
    march_jobs   



SELECT 
    job_postings_fact.job_id,
    skills_dim.skills AS skill,
    skills_dim.type AS type,
    EXTRACT(MONTH FROM job_postings_fact.job_posted_date) AS month,
    job_postings_fact.salary_year_avg AS salary
FROM
    job_postings_fact
LEFT JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
LEFT JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id

WHERE EXTRACT(MONTH FROM job_posted_date) < 4 AND job_postings_fact.salary_year_avg > 70000

ORDER BY
    salary DESC


SELECT 
    job_postings_fact.job_id,
    skills_dim.skills AS skill,
    skills_dim.type AS type,
    EXTRACT(MONTH FROM job_postings_fact.job_posted_date) AS month,
    job_postings_fact.salary_year_avg AS salary
FROM
    job_postings_fact
LEFT JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
LEFT JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
    EXTRACT(MONTH FROM job_postings_fact.job_posted_date) < 4 
    AND job_postings_fact.salary_year_avg > 70000
ORDER BY
    salary DESC;

SELECT 
    quarter1_job_postings.job_title_short,
    quarter1_job_postings.job_location,
    quarter1_job_postings.job_via,
    quarter1_job_postings.job_posted_date :: DATE,
    quarter1_job_postings.salary_hour_avg
 FROM(
    SELECT*
    FROM january_jobs
    UNION ALL
    SELECT*
    FROM february_jobs
    UNION ALL
    SELECT*
    FROM march_jobs
) AS quarter1_job_postings

WHERE
    quarter1_job_postings.salary_year_avg > 70000 AND
    quarter1_job_postings.job_title_short = 'Data Analyst'

ORDER BY
    salary_year_avg DESC