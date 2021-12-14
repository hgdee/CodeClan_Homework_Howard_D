/*
   D12 Cohort Howard Davies homework
*/


/*
Question 1.
(a). Find the first name, last name and team name of employees who are members of teams.

Hint


(b). Find the first name, last name and team name of employees who are members of teams and are enrolled in the pension scheme.



(c). Find the first name, last name and team name of employees who are members of teams, where their team has a charge cost greater than 80.

*/
SELECT 
      e.first_name, 
      e.last_name , 
      e.team_id,
      t.name
FROM employees e 
INNER JOIN  teams  t ON (t.id = e.id)
ORDER BY team_id, last_name
;

SELECT 
      e.first_name, 
      e.last_name , 
      e.team_id,
      t.name
FROM employees e 
INNER JOIN  teams  t ON (t.id = e.id)
WHERE e.pension_enrol IS NOT NULL 
ORDER BY team_id, last_name
;

SELECT * FROM teams;
SELECT 
      e.first_name, 
      e.last_name , 
      e.team_id
FROM employees e 
INNER JOIN  teams  t ON (t.id = e.id)
WHERE to_number(t.charge_cost, '999999.99') > 80
ORDER BY team_id, last_name
;

/*
Question 2.
(a). Get a table of all employees details, together with their local_account_no and local_sort_code, if they have them.

Hints
local_account_no and local_sort_code are fields in pay_details, and employee details are held in employees, so this query requires a JOIN.

What sort of JOIN is needed if we want details of all employees, even if they don’t have stored local_account_no and local_sort_code?


(b). Amend your query above to also return the name of the team that each employee belongs to.

Hint
The name of the team is in the teams table, so we will need to do another join.


*/

SELECT 
     e.*,
     p.local_account_no ,
     p.local_sort_code,
     t.name 
FROM employees e 
LEFT JOIN pay_details p ON e.id  = p.id
LEFT JOIN teams t ON e.id = t.id;


/*

Question 3.
(a). Make a table, which has each employee id along with the team that employee belongs to.



(b). Breakdown the number of employees in each of the teams.

Hint
You will need to add a group by to the table you created above.


(c). Order the table above by so that the teams with the least employees come first.

*/

SELECT 
      e.id,
      e.last_name ,
      t.name
FROM employees e 
INNER JOIN teams t ON e.team_id = t.id
ORDER BY last_name;




/*
Question 4.
(a). Create a table with the team id, team name and the count of the number of employees in each team.



(b). The total_day_charge of a team is defined as the charge_cost of the team multiplied by the number of employees in the team. Calculate the total_day_charge for each team.

Hint


(c). How would you amend your query from above to show only those teams with a total_day_charge greater than 5000?

*/

SELECT 
      t.id,
      t.name,
      count(e.id) AS emp_nos
FROM employees e 
INNER JOIN teams t ON e.team_id = t.id
GROUP BY (t.id, t.name)
ORDER BY t.name;



SELECT 
      t.id,
      t.name,
      count(e.id) AS emp_nos,
      cast(t.charge_cost AS int) * count(e.id) total_day_charge
FROM employees e 
INNER JOIN teams t ON e.team_id = t.id
GROUP BY (t.id, t.name)
ORDER BY t.name;

SELECT 
      t.id,
      t.name,
      count(e.id) AS emp_nos,
      cast(t.charge_cost AS int) * count(e.id) total_day_charge
FROM employees e 
INNER JOIN teams t ON e.team_id = t.id
GROUP BY (t.id, t.name)
HAVING cast(t.charge_cost AS int) * count(e.id) > 5000
ORDER BY t.name;



/*

2 Extension


Question 5.
How many of the employees serve on one or more committees?

*/

SELECT 
    DISTINCT committee_id, 
    count(ec.employee_id ) AS num_committee_emps
FROM employees_committees ec 
GROUP BY committee_id 
;


/*
Question 6.
How many of the employees do not serve on a committee?


Hints
This requires joining over only two tables

Could you use a join and find rows without a match in the join?

*/

-- Not sure this is a join???
SELECT 
    count(e.id)
FROM employees e 
WHERE e.id NOT IN (SELECT ec.employee_id FROM employees_committees ec)

