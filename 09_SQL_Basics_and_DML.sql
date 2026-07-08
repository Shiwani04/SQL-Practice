
/*
==========================================================
Practice Day 09 - SQL Basics & DML
==========================================================

Topics Covered:
✔️ SELECT
✔️ WHERE
✔️ COUNT()
✔️ YEAR()
✔️ UPDATE Statement

Database Used:
- Employees
*/

select * from Employees

--1) Write a SQL query to select all columns and rows from the Employees table.
select * from Employees

--2) Write a SQL query to find the names and email addresses of all employees who work in the department with DepartmentID = 101.
select FirstName, LastName, Email from Employees where DepartmentID = 101

--3) Write a SQL query to find the total number of employees in the Employees table.
select count(EmployeeID) [Number of Employees] from Employees

--4) Write a SQL query to find the details of employees who were hired in the year 2020.
select * from Employees where YEAR(HireDate) = 2020

--5) Write a SQL query to update the salary of 'Jane Doe' to 90,000.
Update Employees
Set Salary = 90000
where FirstName='Jane' and LastName='Doe'