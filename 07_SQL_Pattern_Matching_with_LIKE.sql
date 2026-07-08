/*
==========================================================
Practice Day 07 - SQL Pattern Matching with LIKE
==========================================================

Topics Covered:
✔️ LIKE Operator
✔️ Wildcards (%)
✔️ Single Character Wildcard (_)
✔️ String Pattern Matching

Database Used:
- Employees
*/

select * from employees

--1) Write a SQL query to find the names of employees whose first names start with the letter 'J'.
select firstname,lastname from employees where firstname like 'J%'

--2) Write a SQL query to find the names of employees whose last names end with the letter 'n'.
select firstname, lastname from employees where lastname like '%n'

--3) Write a SQL query to find the email addresses of employees that contain the word "john".
select email from employees where email like '%john%'

--4) Write a SQL query to find the names of employees whose first names have exactly 5 characters.
select firstname,lastname from employees where firstname like '_____'

--5) Write a SQL query to find the names of employees whose last names contain the letter 'a' as the second character.
select firstname, lastname from employees where lastname like '_a%'