-- •	Aggregate employee counts by department, job level, education, etc.

-- Employee count based on the department

SELECT department, COUNT(EmpID) AS total_employee
FROM hr_data
GROUP BY department
ORDER BY total_employee DESC

-- Employee count based on Job level

SELECT DISTINCT(joblevel) AS job_level_no, 
	CASE
		WHEN joblevel = 1 THEN 'Entry_Level'
		WHEN joblevel = 2 THEN 'Associate'
		WHEN joblevel = 3 THEN 'Senior'
		WHEN joblevel = 4 THEN 'Manager'
		WHEN joblevel = 5 THEN 'Senior_Manager'
		ELSE 'Team_member'
	END AS Job_level,
	COUNT(EmpID) AS total_employee
FROM hr_data
GROUP BY joblevel, job_level

-- Employee count based on the education

SELECT DISTINCT(education) AS edu_count,
	CASE 
		WHEN education = 1 THEN 'High_School'
		WHEN education = 2 THEN 'Diploma'
		WHEN education = 3 THEN 'bachelor'
		WHEN education = 4 THEN 'Master'
		WHEN education = 5 THEN 'PhD'
		ELSE 'Not_Mention'
	END AS Eductation_level,
	COUNT(EmpID) AS total_Employee
FROM hr_data
GROUP BY education, Eductation_level


-- •	Compute average salary, hourly rate, stock options, and work-life balance per department/job level
SELECT * FROM hr_data

-- Compute average salary, hourly rate, stock options, and work-life balance per department

SELECT department,
		COUNT(EmpID) AS total_employes,
		ROUND(AVG(monthlyincome):: NUMERIC ,2) AS Avg_salary,
		ROUND(AVG(hourlyrate):: NUMERIC , 2) AS Avg_Hour_rate,
		ROUND(AVG(stockoptionlevel):: NUMERIC , 2) AS Avg_stock_option,
		ROUND(AVG(worklifebalance):: NUMERIC , 2) AS Avg_work_life_balance
FROM hr_data
GROUP BY department
ORDER BY Avg_work_life_balance DESC

-- Compute average salary, hourly rate, stock options, and work-life balance per job level

SELECT DISTINCT(joblevel) AS job_level_no, 
	CASE
		WHEN joblevel = 1 THEN 'Entry_Level'
		WHEN joblevel = 2 THEN 'Associate'
		WHEN joblevel = 3 THEN 'Senior'
		WHEN joblevel = 4 THEN 'Manager'
		WHEN joblevel = 5 THEN 'Senior_Manager'
		ELSE 'Team_member'
	END AS Job_level,
	COUNT(EmpID) AS total_employee,
		ROUND(AVG(monthlyincome):: NUMERIC ,2) AS Avg_salary,
		ROUND(AVG(hourlyrate):: NUMERIC , 2) AS Avg_Hour_rate,
		ROUND(AVG(stockoptionlevel):: NUMERIC , 2) AS Avg_stock_option,
		ROUND(AVG(worklifebalance):: NUMERIC , 2) AS Avg_work_life_balance
FROM hr_data
GROUP BY joblevel, Job_level
ORDER BY job_level_no 

-- •	Identify high-risk employees (low job involvement, low work-life balance)
SELECT * FROM hr_data

SELECT * 
FROM (
	SELECT COUNT(EmpID) AS toatl_employes, 
		CASE 
			WHEN jobinvolvement = 1 THEN 'Low_involvemen'
			WHEN jobinvolvement = 2 THEN 'Somewhat_involved'
			WHEN jobinvolvement = 3 THEN 'Moderately_involved'
			WHEN jobinvolvement = 4 THEN 'Highly_involved'
			ELSE 'Not_mention'
		END AS Job_Involvement,
	
		CASE
			WHEN worklifebalance = 1 THEN 'Poor'
			WHEN worklifebalance = 2 THEN 'Below_Average'
			WHEN worklifebalance = 3 THEN 'Good'
			WHEN worklifebalance = 4 THEN 'Excellent'
			ELSE 'Not_mention'
		END AS work_life_balance
	FROM hr_data
	GROUP BY job_Involvement, work_life_balance ) AS x
WHERE Job_Involvement = 'Low_involvemen'
	 AND
	  work_life_balance = 'Poor'

-- •	Create salary and benefits distribution tables
SELECT * FROM hr_data

SELECT
    salaryslab,
    COUNT(*) AS total_employees,
    ROUND(AVG(monthlyincome), 2) AS avg_income,
    ROUND(AVG(monthlyrate), 2) AS avg_rate,
    ROUND(AVG(stockoptionlevel), 2) AS avg_stock_options,
    ROUND(AVG(percentsalaryhike), 2) AS avg_hike,
    ROUND((SUM(CASE WHEN overtime='Yes' THEN 1 ELSE 0 END)*100.0/COUNT(*)):: NUMERIC, 2) AS overtime_percentage
FROM hr_data
GROUP BY salaryslab
ORDER BY salaryslab

-- Total_Employee Data 

SELECT
    COUNT(*) AS total_employees,
    MIN(monthlyincome) AS min_income,
    MAX(monthlyincome) AS max_income,
    ROUND(AVG(monthlyincome), 2) AS avg_income,
    MIN(monthlyrate) AS min_rate,
    MAX(monthlyrate) AS max_rate,
    ROUND(AVG(monthlyrate), 2) AS avg_rate,
    MIN (Percentsalaryhike) AS min_hike,
    MAX(percentsalaryhike) AS max_hike,
    ROUND(AVG(percentsalaryhike), 2) AS avg_hike
FROM hr_data

-- Current attrition Ratio
SELECT * FROM hr_data

SELECT 
    COUNT(CASE WHEN attrition = 'Yes' THEN 1 END) AS attrition_yes,
	    ROUND(
        (COUNT(CASE WHEN attrition = 'Yes' THEN 1 END) * 100.0) / COUNT(*), 
        2
    ) AS attrition_yes_percentage,
	
    COUNT(CASE WHEN attrition = 'No' THEN 1 END) AS attrition_no,

    ROUND(
        (COUNT(CASE WHEN attrition = 'No' THEN 1 END) * 100.0) / COUNT(*), 
        2
    ) AS attrition_no_percentage
FROM hr_data


--  Gender Ratio and percentage 

SELECT 
		COUNT(CASE WHEN gender = 'Male' THEN 1 END) AS male_Count,
		
		ROUND(
			(COUNT(CASE WHEN gender = 'Male' THEN 1 END) * 100.0) / COUNT(*),
			2
		) AS Male_percentage,
		
		COUNT(CASE WHEN gender = 'Female' THEN 1 END) AS Female_Count,

		ROUND(
			(COUNT(CASE WHEN gender = 'Female' THEN 1 END) * 100) / count(*),
			2 
		) AS Female_percentage

FROM hr_data


-- MaritalStatus Ratio and percentage 

SELECT MaritalStatus, COUNT(EmpID) AS total_employes,
	ROUND(
		(COUNT(EmpID) * 100.0 / ( SELECT COUNT(*)
							FROM hr_data)):: NUMERIC ,2) AS total_percentage
FROM hr_data
GROUP BY MaritalStatus
		
--  Business Question 

-- 1. Find top 3 departments with the highest average monthly income, but only for employees who have worked at least 5 years in the company.

SELECT 	yearsatcompany AS Year_at_Company, Department, Avg_monthly_income
FROM (
	SELECT *,
	RANK() OVER(PARTITION BY department ORDER BY Avg_monthly_income DESC) Ranking
	FROM (
		SELECT  yearsatcompany,
				department, 
				ROUND(
					AVG(monthlyincome):: NUMERIC , 2) AS Avg_monthly_income
		FROM hr_data
		GROUP BY department, yearsatcompany
		HAVING yearsatcompany > 5
		ORDER BY Avg_monthly_income DESC ) AS x ) AS y
WHERE ranking = 1
ORDER BY Avg_monthly_income DESC

-- 2. List employees who have the same JobRole but different Attrition status and compare their average MonthlyIncome.

SELECT * FROM hr_data

SELECT attrition, COUNT(ranking_compare)
FROM (
	SELECT * , 
	RANK() OVER(PARTITION BY jobrole ORDER BY Monthly_income DESC) AS ranking_compare
	FROM (
		SELECT attrition, JobRole , ROUND(AVG(MonthlyIncome):: NUMERIC , 2) AS Monthly_income
		FROM hr_data
		GROUP BY attrition, JobRole ) AS x ) AS y
GROUP BY attrition, ranking_compare
HAVING ranking_compare = 1

-- 3. Find the department with the highest attrition rate among employees under the age of 30.

SELECT *,
RANK() OVER(PARTITION BY department ORDER BY percentage_count DESC) AS ranking_count
FROM (
	SELECT Department, attrition, COUNT(age) AS total_employes,
		ROUND(
			( COUNT(Age) * 100.0/ ( SELECT COUNT(*) 
								 FROM hr_data )):: NUMERIC , 2) AS percentage_count
	FROM hr_data
	WHERE age < 30
	GROUP BY Department, attrition ) AS x

-- 4. Retrieve employees who have never been promoted (YearsSinceLastPromotion = 0) but still have a high PerformanceRating (≥4).

SELECT * FROM hr_data


SELECT EmpID, YearsSinceLastPromotion, PerformanceRating, department
FROM hr_data
WHERE   YearsSinceLastPromotion = 0
	AND 
		PerformanceRating >= 4 


SELECT Department, COUNT(Department) AS total_employee
FROM (
	SELECT EmpID, YearsSinceLastPromotion, PerformanceRating, department
	FROM hr_data
	WHERE   YearsSinceLastPromotion = 0
		AND 
			PerformanceRating >= 4 ) AS x
GROUP BY department
ORDER BY total_employee DESC

-- 5. Show the percentage of employees in each EducationField who travel frequently (BusinessTravel = 'Travel_Frequently').

SELECT DISTINCT(BusinessTravel) FROM hr_data

SELECT EducationField, COUNT(EmpID) AS total_employes,
	ROUND(
		(COUNT(EmpID) * 100.0 /( SELECT COUNT(*)
									FROM hr_data )):: NUMERIC, 2 ) AS percentage_count
FROM hr_data 
WHERE BusinessTravel = 'Travel_Frequently'
GROUP BY EducationField
ORDER BY percentage_count DESC

-- 6. What is the overall attrition rate, and how does it vary by department?
-- 👉 (Company wants to know where employees are leaving most.)

SELECT * ,
RANK() OVER(PARTITION BY department ORDER BY total_employee DESC ) Ranking_count
FROM (
	SELECT attrition, Department, COUNT(EmpID) AS total_employee,
		ROUND(
			(COUNT(EmpID) * 100.0 / ( SELECT COUNT(*)
										FROM hr_data )):: NUMERIC ,2
		) AS Percentage_count
	FROM hr_data
	GROUP BY attrition, Department ) AS ax

-- 7. What is the relationship between Overtime and Attrition?
-- 👉 (Are employees working overtime more likely to leave?)
SELECT * FROM hr_data

SELECT 
		CASE
			WHEN Attrition = 'Yes' THEN 'Leave'
			WHEN Attrition = 'No' THEN 'Work'
		END AS Working_orLeave,
		
		COUNT(EmpID) AS total_Employes, overtime
FROM hr_data
GROUP BY Attrition, overtime

-- 8. What is the average MonthlyIncome by JobLevel and how does it compare across genders?
-- 👉 (Fair pay analysis.)

SELECT *,
RANK() OVER(PARTITION BY Job_level ORDER BY Avg_Monthly_income DESC) AS ranking_level
FROM (
	SELECT  
		CASE 
			WHEN JobLevel = 1 THEN 'Entry_Level'
			WHEN JobLevel = 2 THEN 'Associate'
			WHEN JobLevel = 3 THEN  'Senior'
			WHEN JobLevel = 4 THEN 'Manager'
			WHEN JobLevel = 5 THEN 'Senior_Manager'
		END AS Job_level,
			gender, ROUND(AVG(MonthlyIncome):: NUMERIC , 2) AS Avg_Monthly_income
	FROM hr_data
	GROUP BY JobLevel, gender ) AS ax
ORDER BY Avg_Monthly_income 

-- 9. Which age group has the highest attrition rate?
-- 👉 (Company wants to target retention programs for that group.)

SELECT agegroup, attrition, COUNT(EmpID) AS total_employes,
	ROUND(
		( COUNT(EmpID) * 100.0 / ( SELECT COUNT(*)
								FROM hr_data )):: NUMERIC ,2
	) AS percentage_count
FROM hr_data 
GROUP BY agegroup, attrition
HAVING attrition = 'Yes'
ORDER BY percentage_count DESC

-- 10. What is the correlation between JobSatisfaction and YearsAtCompany for employees who stayed vs those who left?
-- 👉 (Helps HR design engagement initiatives.)
SELECT * FROM hr_data

SELECT * ,
RANK() OVER(PARTITION BY TenureGroup ORDER BY Total_employes DESC) AS ranking_count
FROM (
	SELECT
		CASE 
			WHEN attrition = 'Yes' THEN 'Left'
			WHEN attrition = 'No' THEN 'Stay'
		END AS attrition,
		CASE JobSatisfaction
	        WHEN 1 THEN 'Very Dissatisfied'
	        WHEN 2 THEN 'Dissatisfied'
	        WHEN 3 THEN 'Satisfied'
	        WHEN 4 THEN 'Very Satisfied'
	        ELSE 'Not Rated'
	    END AS JobSatisfaction_Label,
		CASE 
        WHEN YearsAtCompany BETWEEN 0 AND 10 THEN '0-10 Years'
        WHEN YearsAtCompany BETWEEN 11 AND 20 THEN '11-20 Years'
        WHEN YearsAtCompany BETWEEN 21 AND 30 THEN '21-30 Years' 
        WHEN YearsAtCompany BETWEEN 31 AND 40 THEN '31-40 Years'
        ELSE 'Unknown'
    END AS TenureGroup,
	COUNT(YearsAtCompany) AS total_employes
	FROM hr_data
	GROUP BY attrition, JobSatisfaction_Label, TenureGroup ) AS x
 WHERE attrition = 'Left'
 