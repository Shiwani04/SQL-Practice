
/*
==========================================================
Practice Day 12 - SQL Interview Practice Set 02
==========================================================

Topics Covered:
✔️ Aggregate Functions
✔️ GROUP BY & HAVING
✔️ Correlated Subqueries
✔️ Common Table Expressions (CTEs)
✔️ DENSE_RANK()
✔️ Self Joins
✔️ Business Case-Based SQL Problems

Database Used:
- Employees
*/

select * from Employees

--# Today's SQL Challenge Set (Q31–Q40)

--Assume same `Employees` table.

--## Q1 Find employees whose salary is greater than the average salary of all employees.
select FirstName,LastName,Salary from Employees where Salary>(
select avg(Salary) from Employees)


--## Q2 Find employees whose salary is greater than the average salary of their department. *(Easy revision of correlated subquery)*
select * from Employees x where salary>
(select avg(Salary) from Employees
where DepartmentID=x.DepartmentID)


--## Q3 Find departments having more than 3 employees.
select DepartmentID,count(EmployeeID) [No. of Employees] from Employees 
group by DepartmentID
having count(EmployeeID)>3


--## Q4 Find the department with the highest average salary. **Challenge:** Return department details, not just average salary.
select top 1 with ties DepartmentID,avg(Salary) [Average Salary] from Employees
group by DepartmentID
order by avg(Salary)desc


--## Q5 Find employees who earn the highest salary in their department. (Q27 ka reverse version)*
select FirstName,LastName,DepartmentID,Salary from Employees x where Salary = (
select max(Salary) from Employees
where DepartmentID=x.DepartmentID)


--## Q6 Find employees whose salary is above the company average but below their department's highest salary. This one requires careful thinking.
select * from Employees a where Salary < (
select max(Salary) from Employees
where DepartmentID=a.DepartmentID)
and
Salary>(
select avg(Salary) from Employees)


--## Q7 Find departments where the difference between highest and lowest salary is greater than 30000.Hint:MAX(Salary) - MIN(Salary)
select distinct DepartmentID from Employees e where (
select max(Salary) from Employees
where DepartmentID=e.DepartmentID) - (
select min(Salary) from Employees
where DepartmentID=e.DepartmentID) > 30000

--or
select a.DepartmentID from (select DepartmentID,max(Salary) [Max Salary] from Employees
group by DepartmentID) a inner join (select DepartmentID,min(Salary) [Min Salary] from Employees b
group by DepartmentID) b on a.DepartmentID=b.DepartmentID where [Max Salary]-[Min Salary]>30000

--or
with CTE as (
select DepartmentID,max(Salary) [Max Salary],min(Salary) [Min Salary] from Employees
group by DepartmentID
)
select DepartmentID from CTE where [Max Salary] - [Min Salary] > 30000


--## Q8 Find employees who have the same salary as someone else.
select distinct a.EmployeeID,a.FirstName,a.LastName,a.Salary from Employees a inner join Employees b on a.Salary=b.Salary where a.EmployeeID<>b.EmployeeID


--## Q9 Find the department that has the maximum number of employees. Don't use TOP 1 initially. Try with subqueries.
select DepartmentID from
(select DepartmentID,count(EmployeeID) [No. of Employees], DENSE_RANK() over(order by count(EmployeeID) desc) [DR] from Employees
group by DepartmentID) x where DR=1


--## Q10 Find employees whose salary is greater than **all employees** in Department 102.Think carefully.
select FirstName,LastName,Salary from Employees where Salary >(
select max(Salary) from Employees where DepartmentID=102)
