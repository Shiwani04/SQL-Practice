
/*
==========================================================
Practice Day 08 - Advanced SQL Joins
==========================================================

Topics Covered:
✔️ INNER JOIN
✔️ LEFT JOIN
✔️ SELF JOIN
✔️ Aggregate Functions
✔️ GROUP BY
✔️ TOP 1
✔️ Business Case-Based SQL Problems

Database Used:
- Employees
- Departments
*/

select * from Employees

select * from Departments

--1) Write a SQL query to list the names of employees along with the names of the departments they work in.
select FirstName, LastName, d.DepartmentID, DepartmentName 
from Employees e 
inner join Departments d 
on e.DepartmentID=d.DepartmentID 

--2) Write a SQL query to list all the departments and the employees working in them, including departments with no employees.
select d.DepartmentID, DepartmentName, FirstName, LastName from Departments d 
left join Employees e on e.DepartmentID=d.DepartmentID

--3) Write a SQL query to find the names of employees who do not belong to any department (i.e., no matching department ID).
select FirstName,LastName 
from Employees e 
left join Departments d 
on e.DepartmentID=d.DepartmentID where departmentname is null

--4) Write a SQL query to list the names of employees who work in the same department as 'Jane Doe'.
select x.FirstName,y.FirstName from Employees x 
inner join Employees y on x.DepartmentID=y.DepartmentID 
where x.FirstName='Jane' and x.LastName='Doe' and x.EmployeeID<>y.EmployeeID

--5) Write a SQL query to find the department with the highest total salary paid to its employees.
select top 1 DepartmentName from Departments d 
inner join Employees e on e.departmentID=d.DepartmentID
group by DepartmentName
order by sum(Salary) desc