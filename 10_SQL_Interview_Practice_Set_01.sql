
/*
==========================================================
Practice Day 10 - SQL Interview Practice Set 01
==========================================================

Topics Covered:
✔️ Aggregate Functions
✔️ GROUP BY & HAVING
✔️ INNER JOIN
✔️ LEFT JOIN
✔️ RIGHT JOIN
✔️ SELF JOIN
✔️ Correlated Subqueries
✔️ DENSE_RANK()
✔️ TOP 1 WITH TIES
✔️ Date Functions
✔️ Business Case-Based SQL Problems

Database Used:
- Employees
- Departments
*/

select * from Employees

--select * from EmployeeSales

select * from [dbo].[Departments]

--1) Find the total salary paid in each department.
select DepartmentID,sum(Salary) [Total Salary] from Employees
group by DepartmentID

--2) Find the average salary of employees in each department.
select DepartmentID,avg(Salary) [Average Salary] from Employees
group by DepartmentID

--3) Find departments having more than 2 employees.
select DepartmentID, count(*) [Total Employees] from Employees
group by DepartmentID
having count(*) > 2

--4) Find the highest salary in each department.
select DepartmentID,max(Salary) [Maximum Salary] from Employees
group by DepartmentID

--5) Find employees whose salary is greater than the average salary of their department.
select * from Employees e where Salary>
(select avg(Salary) from Employees
where DepartmentID=e.DepartmentID)


--6) Find departments where the average salary is greater than 80,000.
select DepartmentID, avg(Salary) from Employees
group by DepartmentID
having avg(Salary)>80000

select DepartmentID,Avg(Salary) from Employees
group by DepartmentID

--7) Find employees earning more than the average salary of all employees.
select FirstName,LastName, Salary from Employees where Salary>
(select avg(Salary) from Employees)

--8) Find employees earning less than the highest salary.
select * from Employees where Salary<
(select max(Salary) from Employees)


--9) Find employees hired after the oldest employee.
select * from Employees where HireDate>(
select min(HireDate) from Employees)


--10) Find employees working in the same department as Jane Doe.
select * from Employees where DepartmentID = (
select DepartmentID from Employees where FirstName='Jane' and LastName='Doe')


--11) Find employees working in a different department than Jane Doe.
select * from Employees where not DepartmentID = (
select DepartmentID from Employees where FirstName='Jane' and LastName='Doe')


--12) Find employees whose salary is equal to the maximum salary in their department.
select * from Employees e where Salary= 
(select max(Salary) from Employees where DepartmentID=e.DepartmentID)

select DepartmentID,max(Salary) from Employees 
group by DepartmentID


--13) Show employee names along with their department names.
select FirstName,LastName,DepartmentName from Employees e 
inner join Departments d on e.DepartmentID=d.DepartmentID


--14) Show all departments and the number of employees in each.
select DepartmentName, count(EmployeeID) [Number of Employees] from Employees e right join Departments d on e.DepartmentID=d.DepartmentID
group by DepartmentName


--15) Find departments that have no employees.
select DepartmentName from Employees e right join Departments d on e.DepartmentID=d.DepartmentID
where EmployeeID is null


--16) Find employees who do not belong to any department.
select FirstName, LastName from Employees e left join Departments d on e.DepartmentID=d.DepartmentID
where DepartmentName is null


--17) Find employees whose department name is 'Finance'.
select FirstName,LastName,DepartmentName from Employees e left join Departments d on e.DepartmentID=d.DepartmentID
where DepartmentName = 'Finance'


--18) Find department names along with total salary paid.
select DepartmentName,sum(Salary) [Total Salary] from Employees e inner join Departments d on e.DepartmentID=d.DepartmentID
group by DepartmentName


--19) Find employees working in the same department as John Smith.
select y.FirstName,y.LastName from Employees x inner join Employees y on x.DepartmentID=y.DepartmentID 
where x.FirstName='John' and x.LastName='Smith' 


--20) Find employees working in the same department as Jane Doe but exclude Jane Doe.
select y.FirstName,y.LastName from Employees x inner join Employees y on x.DepartmentID=y.DepartmentID 
where x.FirstName='Jane' and x.LastName='Doe' and x.EmployeeID<>y.EmployeeID


--21) Find pairs of employees working in the same department.
select x.FirstName,y.FirstName,y.DepartmentID from Employees x inner join Employees y on x.DepartmentID=y.DepartmentID 
where x.EmployeeID<>y.EmployeeID and x.EmployeeID>y.EmployeeID


--22) Find employees who were hired before another employee in the same department.
select distinct x.FirstName,x.LastName,x.HireDate from Employees x inner join Employees y on x.DepartmentID=y.DepartmentID
where x.EmployeeID<>y.EmployeeID and x.HireDate < y.HireDate

--
--23) Find the department with the highest total salary.
select top 1 with ties DepartmentID,sum(Salary) [Highest Salary] from Employees
group by DepartmentID
order by sum(Salary) desc

--or
select DepartmentID from (
select DepartmentID,sum(Salary) [Highest Salary],DENSE_RANK() over(order by sum(Salary) desc) [DR] from Employees
group by DepartmentID)
m where DR=1


--24) Find the department with the highest average salary.
select top 1 with ties DepartmentID,avg(Salary) [Average Salary] from Employees
group by DepartmentID
order by avg(Salary) desc

--or
select DepartmentID from (
select DepartmentID,avg(Salary) [Average Salary], DENSE_RANK() over(order by avg(Salary) desc) [DR] from Employees
group by DepartmentID)
x where DR=1


--25) Find employees who do not belong to the department with the highest average salary.
select * from Employees where DepartmentID not in (
select top 1 with ties DepartmentID from Employees
group by DepartmentID
order by avg(Salary) desc)


--26) Find the department with the lowest average salary.
select top 1 with ties DepartmentID,avg(Salary) [Average Salary] from Employees
group by DepartmentID
order by avg(Salary)


--27) Find employees whose salary is above their department's average salary.
select FirstName,LastName,Salary from Employees e where Salary>(
select avg(Salary) from Employees where DepartmentID=e.DepartmentID)


--28) Find the second-highest salary in the company.
select Salary from (
select *,DENSE_RANK() over(order by Salary desc) [DR] from Employees) m where DR=2

--or 
select max(Salary) [2nd Highest Salary]
from Employees
where Salary <
(
    select max(Salary)
    from Employees
)

--29) Find employees having the second-highest salary.
select FirstName,LastName,Salary from (
select *,DENSE_RANK() over(order by Salary desc) [DR] from Employees) m where DR=2


--30) Find departments whose total salary is greater than the company's average departmental salary.
select DepartmentID,sum(Salary) [Total Salary] from Employees 
group by DepartmentID
having sum(Salary)>(
select avg([Total Salary]) from (
select DepartmentID,sum(Salary) [Total Salary] from Employees 
group by DepartmentID) m )

--
--31) Find duplicate email addresses.
select Email from Employees
group by Email
having count(Email)>1


--32) Find employees having the same salary.
select FirstName, LastName from Employees where Salary in (
select Salary from Employees
group by Salary
having count(Salary)>1)


--33) Find the top 3 highest-paid employees.
select top 3 FirstName,LastName,Salary from Employees
order by Salary desc


--34) Find employees who were hired in the same year as Jane Doe.
select * from Employees where year(HireDate) = (
select Year(HireDate) from Employees where FirstName = 'Jane' and LastName='Doe')


--35) Find employees whose salary is greater than all employees in the Finance department.
select FirstName,LastName,Salary from Employees e join Departments d on e.DepartmentID=d.DepartmentID 
where Salary >
(select max(Salary) from Employees e 
inner join Departments d on e.DepartmentID=d.DepartmentID 
where DepartmentName = 'Finance')