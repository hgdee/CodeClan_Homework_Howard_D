-- Howard Davies week 3 day 1 homework 13/12/2021

/* MVP
   Q1 Find all the employees who work in the ‘Human Resources’ department.
*/

SELECT * 
FROM  employees e  
WHERE department  = 'Human Resources'
ORDER BY (team_id , last_name , first_name );

/*

Question 2.
Get the first_name, last_name, and country of the employees who work in the ‘Legal’ department.
*/

SELECT  first_name, last_name, country
FROM  employees e 
WHERE department  = 'Legal'
ORDER BY (country, last_name, first_name);

/*
 Q3 count the number of employees  based in Portugal
*/

SELECT count(id) AS Portugese_employees_tot
FROM  employees e 
WHERE lower(country) = lower('Portugal');

/*
 Question 4.
Count the number of employees based in either Portugal or Spain.
*/
SELECT country, count(id) AS country_employees
FROM  employees e 
WHERE lower(country) IN (lower('Portugal'), lower('Spain'))
GROUP BY country
ORDER BY (country);

/*
Question 5.
Count the number of pay_details records lacking a local_account_no.

*/

SELECT count(id) AS no_local_account_no
FROM  pay_details pd 
WHERE local_account_no  IS NULL;

/*
Question 6.
Are there any pay_details records lacking both a local_account_no and iban number?
*/

SELECT count(id) AS no_iban_or_account -- records_lacking_local_account_no_and_iban_number
FROM  pay_details pd 
WHERE local_account_no  IS NULL
AND   iban IS NULL
AND   id IS NOT NULL;

/*
Q7 Get a table with employees first_name and last_name ordered alphabetically by last_name (put any NULLs last).
*/
SELECT  last_name, first_name 
FROM  employees e 
ORDER BY last_name ASC NULLS LAST, first_name ASC NULLS LAST ;


/*
Question 8.
Get a table of employees first_name, last_name and country, 
ordered alphabetically first by country and then by last_name (put any NULLs last).
*/

SELECT  country, last_name, first_name 
FROM  employees e 
ORDER BY country ASC NULLS LAST, last_name ASC NULLS LAST, first_name ASC NULLS LAST ;


/*
Question 9.
Find the details of the top ten highest paid employees in the corporation.
*/
SELECT  salary, last_name, first_name, country, department, team_id 
FROM  employees e 
ORDER BY salary DESC NULLS LAST, last_name ASC NULLS LAST, first_name ASC NULLS LAST,
         country ASC NULLS LAST, department ASC NULLS LAST, team_id ASC NULLS LAST
LIMIT 10;

/*
 Question 10.
Find the first_name, last_name and salary of the lowest paid employee in Hungary.
*/
SELECT first_name, 
       last_name,
       salary
FROM employees e  
WHERE e.salary = (SELECT min(e2.salary) 
                  FROM employees e2)
                  
/*
 How many employees have a first_name beginning with ‘F’?
 */
SELECT count(first_name) AS first_name_begins_with_F
FROM employees e 
WHERE upper(first_name) LIKE 'F%';

/*
 Q12 Find all the details of any employees with a ‘yahoo’ email address?
*/
SELECT * 
FROM employees e 
WHERE upper(email)LIKE upper('%YAHOO%')
ORDER BY email;

/*
 Q13 Count the number of pension enrolled employees not based in either France or Germany.
*/
SELECT count(id) 
FROM employees e 
WHERE pension_enrol IS NOT NULL 
AND country NOT IN ('Germany', 'France');

/*
Q14 What is the maximum salary among those employees in the ‘Engineering’ 
    department who work 1.0 full-time equivalent hours (fte_hours)?
*/
SELECT max(salary)
FROM employees e 
WHERE fte_hours = 1.0
AND department  = 'Engineering';

/*
  Return a table containing each employees first_name, last_name, full-time equivalent hours (fte_hours), salary, and 
  a new column effective_yearly_salary which should contain fte_hours multiplied by salary.
*/
SELECT first_name, 
       last_name, 
       fte_hours, 
       salary, 
       (salary * fte_hours) AS effective_salary
FROM employees e
ORDER BY effective_salary DESC NULLS LAST, last_name, first_name ;


/*  2 Extension
 *   
 */

/*
 Q16 The corporation wants to make name badges for a forthcoming conference. 
      Return a column badge_label showing employees’ first_name and last_name 
      joined together with their department in the following style: 
      ‘Bob Smith - Legal’. Restrict output to only those employees 
     with stored first_name, last_name and department.
*/

SELECT concat(first_name,' ',last_name,' - ',department) AS column_badge_label
FROM employees e 
ORDER BY last_name, first_name, department;

/*
 Q17 One of the conference organisers thinks 
     it would be nice to add the year of the employees’ 
     start_date to the badge_label to celebrate long-standing colleagues, 
     in the following style ‘Bob Smith - Legal (joined 1998)’. 
     Further restrict output to only those employees with a stored start_date.

     [If you’re really keen - try adding the month as a string: ‘Bob Smith - Legal 
         (joined July 1998)’]
*/ 
SELECT concat(first_name,' ',last_name,' - ',department,
              '( joined ',lower(substring(to_char(start_date,'YYYYMON'),5,7)),' ', 
              substring(to_char(start_date,'YYYY'),1,4),' )') AS column_badge_label
FROM employees e 
ORDER BY last_name, first_name, department;

/*
Q18  Return the first_name, last_name and salary of all employees 
     together with a new column called salary_class with a value 'low' where salary 
      is less than 40,000 and value 'high' 
      where salary is greater than or equal to 40,000.
*/
SELECT first_name,
       last_name,
       salary,
       CASE  WHEN salary <   40000 THEN  'low'
             WHEN salary  >= 40000 THEN  'high'  
       END AS salary_class
FROM employees e ;