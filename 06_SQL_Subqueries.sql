/*
==========================================================
Practice Day 06 - SQL Subqueries
==========================================================

Topics Covered:
✔️ Scalar Subqueries
✔️ Aggregate Functions with Subqueries
✔️ Nested Queries
✔️ Business Case-Based SQL Problems
✔️ TOP 1

Database Used:
- Employees
*/

select * from Employees


--1) Write a SQL query to find the names of employees who have a salary higher than the average salary of all employees.
select FirstName, LastName from Employees 
where Salary>(
select avg(Salary) from Employees
)

--2) Write a SQL query to list the employee names and their departments for employees who were hired after the oldest employee in the company.
select FirstName, LastName, DepartmentID, HireDate from Employees where HireDate>(
select min(HireDate) from Employees
)
order by HireDate

--3) Write a SQL query to find the details of the employee(s) with the highest salary.
select * from Employees where Salary=(
select max(Salary) from Employees
)

--4) Write a SQL query to find the names of employees who work in the same department as 'John Smith'.
select FirstName, LastName from Employees where DepartmentID = (
select DepartmentID from Employees where FirstName ='John' and LastName = 'Smith')

--5) Write a SQL query to find the names of employees who do not belong to the department with the highest average salary.
select FirstName, LastName from Employees 
where DepartmentID Not in (
select top 1 DepartmentID from Employees
group by DepartmentID
order by avg(Salary) desc)
