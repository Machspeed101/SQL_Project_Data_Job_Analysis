
# 💼 Data Analyst Job Market Insights (2023)

This project explores the **top-paying and most in-demand skills** for Data Analysts using job posting data. It answers strategic career questions like:
- What are the best-paying remote roles?
- Which skills command high salaries?
- Which are the most in-demand skills in the job market?
- What skills offer the best mix of salary and demand?

---

## 📊 Dataset Overview

All queries use job data from a simulated job market dataset that includes:
- Job title, location, company, salary, and posting date
- Required technical skills
- Job schedule and remote eligibility

---

## 🥇 Query 1: Top Paying Remote Data Analyst Jobs

> **Goal:** Identify the top 10 highest-paying remote Data Analyst positions with listed salaries.

```sql
SELECT job_id, job_title, job_location, job_schedule_type, salary_year_avg, job_posted_date, name AS company_name
FROM job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE job_title_short = 'Data Analyst' 
  AND job_location = 'Anywhere' 
  AND salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC
LIMIT 10;
```

📊 **Visualization:**  
![Top 10 Most High Paying Jobs](assets\pic1.png)

---

## 🧠 Query 2: Skills Required for the Top-Paying Roles

> **Goal:** Attach required skills to the top 10 highest-paying Data Analyst roles.

```sql
WITH top_paying_jobs AS (
  SELECT job_id, job_title, salary_year_avg, name AS company_name
  FROM job_postings_fact
  LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
  WHERE job_title_short = 'Data Analyst' 
    AND job_location = 'Anywhere' 
    AND salary_year_avg IS NOT NULL
  ORDER BY salary_year_avg DESC
  LIMIT 10
)
SELECT top_paying_jobs.*, skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY salary_year_avg DESC;
```

📊 **Visualization:**  
![Top 10 Most Common Skills](assets\pic2.png)

---

## 📈 Query 3: Top 5 Most In-Demand Skills

> **Goal:** Find the top 5 most requested skills for Data Analyst roles in general.

```sql
SELECT skills, COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact    
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_title_short = 'Data Analyst'
GROUP BY skills
ORDER BY demand_count DESC
LIMIT 5;
```



---

## 💸 Query 4: Top Skills by Average Salary

> **Goal:** Identify which skills are associated with the highest-paying roles.

```sql
SELECT skills, ROUND(AVG(salary_year_avg), 0) AS average_salary_skill
FROM job_postings_fact    
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_title_short = 'Data Analyst'
  AND salary_year_avg IS NOT NULL
GROUP BY skills
ORDER BY average_salary_skill DESC
LIMIT 25;
```


---

## 🎯 Query 5: Optimal Skills to Learn (High Demand + High Salary)

> **Goal:** Find the best combination of in-demand and high-paying skills for remote Data Analysts.

```sql
WITH top_demanding_jobs AS (
  SELECT skills_dim.skill_id, skills_dim.skills, COUNT(skills_job_dim.job_id) AS demand_count
  FROM job_postings_fact    
  INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
  INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
  WHERE job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = TRUE
  GROUP BY skills_dim.skill_id, skills_dim.skills
),
top_paying_skills AS (
  SELECT skills_dim.skill_id, skills_dim.skills, ROUND(AVG(salary_year_avg), 0) AS average_salary_skill
  FROM job_postings_fact    
  INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
  INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
  WHERE job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
  GROUP BY skills_dim.skill_id, skills_dim.skills
)
SELECT 
  top_demanding_jobs.skill_id,
  top_demanding_jobs.skills,
  top_demanding_jobs.demand_count,
  top_paying_skills.average_salary_skill
FROM top_demanding_jobs
INNER JOIN top_paying_skills ON top_demanding_jobs.skill_id = top_paying_skills.skill_id
WHERE demand_count > 10
ORDER BY average_salary_skill DESC, demand_count DESC
LIMIT 25;
```



---

## 🔚 Conclusion

This project offers a **strategic roadmap** for aspiring or current Data Analysts by showing:
- Where the money is 💰
- What skills employers value most 🔧
- Which skills give the best ROI (Return on Investment) 🧠💸

---



---

## 👤 Author

*Created by Adewole Oyekunle.*

