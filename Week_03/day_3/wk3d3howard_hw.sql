--  Howard Davies Week three Day three homework 15/12/2021

/*
Question 1.
How many employee records are lacking both a grade and salary?
*/
SELECT 
    count(*) AS emps_lacking_grade_salary
FROM employees e 
WHERE grade IS NULL 
AND   salary IS NULL ;

/*
Question 2.
Produce a table with the two following fields (columns):

the department
the employees full name (first and last name)
Order your resulting table alphabetically by department, and then by last name
*/

SELECT 
    department,
    concat(first_name,' ',last_name)  AS full_name
FROM employees e 
ORDER BY department, last_name;

/*
Question 3.
Find the details of the top ten highest paid employees who have a last_name beginning with ‘A’
*/

SELECT 
      department,
      last_name,
      first_name,
      salary
FROM  employees e 
WHERE last_name LIKE 'A%'
AND   salary    IS NOT null
ORDER BY salary DESC 
LIMIT 10;

/*
 Question 4.
Obtain a count by department of the employees who started work with the corporation in 2003.
  */
SELECT 
    department ,
    count(id) AS starters_2003
FROM employees e 
WHERE EXTRACT(YEAR FROM start_date) = '2003'
GROUP BY department;

/*
Question 5.
Obtain a table showing department, fte_hours and the number of employees in each department who work each fte_hours pattern. Order the table alphabetically by department, and then in ascending order of fte_hours.
Hint
You need to GROUP BY two columns here.
*/
SELECT 
    department,
    fte_hours,
    count(*)
FROM employees e 
GROUP BY department,fte_hours 
ORDER BY department;

/*
Question 6.
Provide a breakdown of the numbers of employees enrolled, 
not enrolled, and with unknown enrollment status in the corporation pension scheme.
*/
SELECT 
   pension_enrol,
   count(*)
FROM employees e 
GROUP BY pension_enrol ;

/*
 Question 7.
Obtain the details for the employee with 
the highest salary in the ‘Accounting’ department 
who is not enrolled in the pension scheme?
 */
SELECT 
    last_name ,
    first_name,
    salary
FROM   employees e 
WHERE  department = 'Accounting'
AND    pension_enrol IN (NULL, FALSE)
AND    salary =  (SELECT max(salary) 
                  FROM   employees e2
                  WHERE  department = 'Accounting'
                  AND    pension_enrol IN (NULL, FALSE) )
                  
/*
       Question 8.
Get a table of country, number of employees in that country, and the average salary of employees in that country 
for any countries in which more than 30 employees are based. Order the table by average salary descending.           
*/
                  
SELECT 
    country,
    count(*),
    round(avg(salary)) AS country_salary
FROM employees e 
WHERE country IN (SELECT 
                    country 
                  FROM employees e2
                  GROUP BY country
                  HAVING count(country) > 30) 
GROUP BY country
ORDER BY avg(salary) DESC

/*
Question 9.
Return a table containing each employees first_name, last_name, 
full-time equivalent hours (fte_hours), salary, and a new column 
effective_yearly_salary which should contain fte_hours multiplied by salary. 
Return only rows where effective_yearly_salary is more than 30000.
*/
SELECT 
    first_name ,
    last_name ,
    fte_hours ,
    salary ,
    (fte_hours * salary) AS effective_yearly_salary
FROM employees e 
WHERE fte_hours * salary > 30000
ORDER BY salary;

/*
  Question 10
Find the details of all employees in either Data Team 1 or Data Team 2
Hint
name is a field in table `teams`
 */
SELECT 
    *
FROM employees e 
LEFT JOIN teams t ON e.team_id = t.id
WHERE t.name IN ('Data Team 1', 'Data Team 2')

/*
11. Find the first name and last name of all employees who lack a local_tax_code.
*/
SELECT 
    first_name,
    last_name
FROM employees e 
LEFT JOIN pay_details pd ON e.id = pd.id 
WHERE pd.local_tax_code  IS NULL;

/*
 *   12. The expected_profit of an employee is defined as (48 * 35 * charge_cost - salary) * fte_hours, 
 *   where charge_cost depends upon the team to which the employee belongs. 
 * Get a table showing expected_profit for each employee.
 * 
 * */
 SELECT
    (48 * 35 * CAST(t.charge_cost AS int) - salary) * fte_hours 
 FROM employees e 
 LEFT JOIN teams t ON e.team_id = t.id
 WHERE t.charge_cost Is NOT NULL
AND    salary IS NOT NULL 
AND    fte_hours IS NOT NULL;


/*
 * Question 13. [Tough]
Find the first_name, last_name and salary of the lowest paid employee in Japan who works the least common full-time equivalent hours across the corporation.”

Hint
You will need to use a subquery to calculate the mode
 * 
 */
                          
SELECT *
FROM employees
WHERE country = 'Japan' AND fte_hours IN (
  SELECT fte_hours
  FROM employees
  GROUP BY fte_hours
  HAVING COUNT(*) = (
    SELECT min(count)
    FROM (
      SELECT COUNT(*) AS count
      FROM employees
      GROUP BY fte_hours
    ) AS temp
  )
)
ORDER BY salary 
LIMIT 1;

/*
 * Question 14.
Obtain a table showing any departments in which there are two or 
more employees lacking a stored first name. Order the table in 
descending order of the number of employees lacking a first name, 
and then in alphabetical order by department.
 */

SELECT 
department,
count(*) missing_names
FROM employees e 
WHERE first_name IS NULL 
GROUP BY department 
HAVING count(*) > 2
ORDER BY missing_names DESC, department;

/*
 * Question 15. [Bit tougher]
 * Return a table of those employee first_names shared by more than one employee, together with a count of 
 * the number of times each first_name occurs. Omit employees without a stored first_name from the table. 
 * Order the table descending by count, and then alphabetically by first_name.
 */
SELECT 
   first_name,
   count(first_name)
FROM employees e 
WHERE first_name IS NOT NULL 
GROUP BY first_name 
HAVING count(first_name) > 1
ORDER BY  count(first_name) DESC, first_name;

/*
 * 
 * Question 16. [Tough]
Find the proportion of employees in each department who are grade 1.
Hints
Think of the desired proportion for a given department as the number of employees in that department who are grade 1, divided by the total number of employees in that department.


You can write an expression in a SELECT statement, e.g. grade = 1. This would result in BOOLEAN values.


If you could convert BOOLEAN to INTEGER 1 and 0, you could sum them. The CAST() function lets you convert data types.


In SQL, an INTEGER divided by an INTEGER yields an INTEGER. To get a REAL value, you need to convert the top, bottom or both sides of the division to REAL.
 */


SELECT
    DISTINCT (department),
    CAST( count( CASE WHEN grade = 1 THEN 1 END ) OVER (PARTITION BY department)  -
      count( COALESCE (grade,0)) OVER (PARTITION BY department) AS float ) / (count( COALESCE (grade,0)) OVER (PARTITION BY department)) * 100 +100  AS g1_percent
FROM  employees
; 



