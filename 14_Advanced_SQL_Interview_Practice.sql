
/*
==========================================================
Practice Day 14 - Advanced SQL Interview Practice
==========================================================

Topics Covered:
✔️ Correlated Subqueries
✔️ Aggregate Functions
✔️ GROUP BY & HAVING
✔️ Common Table Expressions (CTEs)
✔️ Self Joins
✔️ Window Functions
✔️ DENSE_RANK()
✔️ Manager-Employee Hierarchy
✔️ Business Case-Based SQL Problems
✔️ Department-Level Analysis

Database Used:
- Employees
- Departments
- Employees_2
*/

--Section A: Correlated Subquery Mastery

--Q1 Find employees whose salary is less than the highest salary in their department.
select FirstName,LastName,Salary from Employees e where Salary<(
select max(Salary) from Employees
where DepartmentID=e.DepartmentID)

select e.FirstName,e.LastName,e.Salary from Employees e
inner join (select DepartmentID,max(Salary) [Max Salary] from Employees group by DepartmentID) x on e.DepartmentID=x.DepartmentID
where Salary<[Max Salary]


--Q2 Find employees whose salary is greater than the lowest salary in their department.
select FirstName,LastName,Salary from Employees e where Salary>(
select min(Salary) from Employees
where DepartmentID=e.DepartmentID) 

select e.FirstName,e.LastName,e.Salary from Employees e
inner join (select DepartmentID,min(Salary) [Min Salary] from Employees group by DepartmentID) x on e.DepartmentID=x.DepartmentID
where Salary>[Min Salary]


--Q3 Find employees who earn exactly the average salary of their department.
select * from Employees e where Salary=(
select avg(Salary) from Employees
where DepartmentID=e.DepartmentID)

select e.FirstName,e.LastName,e.Salary from (select DepartmentID,avg(Salary) [Average Salary] from Employees group by DepartmentID) x 
inner join Employees e on e.DepartmentID=x.DepartmentID where Salary=[Average Salary]


--Q4 Find departments where the highest salary is greater than the company average salary.
select DepartmentID,max(Salary) from Employees
group by DepartmentID
having max(Salary)>(
select avg(Salary) from Employees)

with CTE as(
select DepartmentID,max(Salary) [Max Salary] from Employees
group by DepartmentID
)
select DepartmentID from CTE where [Max Salary]>(select avg(Salary) from Employees)


--Q5 Find employees who belong to the department having the highest average salary.
select EmployeeID,FirstName,LastName,DepartmentID from Employees where DepartmentID in (
select DepartmentID from (
select top 1 with ties DepartmentID,avg(Salary) [Avg Salary] from Employees
group by DepartmentID
order by avg(Salary) desc) x)

--or
with CTE as (
select top 1 with ties DepartmentID,avg(Salary) [Avg Salary] from Employees
group by DepartmentID
order by avg(Salary) desc
)
select EmployeeID,FirstName,LastName,DepartmentID from Employees where DepartmentID in (select DepartmentID from CTE)


--Section B: Aggregate Thinking

--Q6 Find departments whose total salary is less than the company's average departmental salary. (Reverse of what you already solved.)
select DepartmentID from (
select DepartmentID,sum(Salary) [Total Salary] from Employees 
group by DepartmentID
having sum(Salary)<(
select avg([Total Salary]) from (
select DepartmentID,sum(Salary) [Total Salary] from Employees
group by DepartmentID) x)) y

--or
with CTE as (
select DepartmentID,sum(Salary) [Total Salary] from Employees
group by DepartmentID
)
select DepartmentID from CTE where [Total Salary]<(select avg([Total Salary]) from CTE)


--Q7 Find departments whose employee count is below the average department size.
select DepartmentID from (
select DepartmentID, count(EmployeeID) [Number of Employees] from Employees
group by DepartmentID
having count(EmployeeID)<(
select avg([Number of Employees]) from (
select DepartmentID,count(EmployeeID) [Number of Employees] from Employees
group by DepartmentID) x)) y

with CTE as (
select DepartmentID,count(EmployeeID) [No. of Employees] from Employees
group by DepartmentID
)
select DepartmentID from CTE where [No. of Employees]<(select avg([No. of Employees]) from CTE)


--Q8 Find the department with the second-highest average salary.
select DepartmentID from (
select DepartmentID,avg(Salary) [Avg Salary],DENSE_RANK() over(order by avg(Salary) desc) [DR] from Employees
group by DepartmentID
) x where DR=2


--Q9 Find the department with the second-highest total salary.
select DepartmentID from (
select DepartmentID,sum(Salary) [Total Salary],DENSE_RANK() over(order by sum(Salary) desc) [DR] from Employees
group by DepartmentID
) x where DR=2


--Q10 Find departments where the highest salary exceeds the department average by more than 20000.
select DepartmentID,max(Salary) [Highest Salary],avg(Salary) [Avg Salary] from Employees
group by DepartmentID
having max(Salary)-avg(Salary) > 20000

select distinct a.DepartmentID from (select DepartmentID,max(Salary) [Max Salary] from Employees group by DepartmentID) a inner join
(select DepartmentID,avg(Salary) [Avg Salary] from Employees group by DepartmentID) b on a.DepartmentID=b.DepartmentID 
where a.[Max Salary]-b.[Avg Salary]>20000

with CTE_1 as (
select DepartmentID,max(Salary) [Max Salary] from Employees
group by DepartmentID),
CTE_2 as (select DepartmentID,avg(Salary) [Avg Salary] from Employees
group by DepartmentID)
select distinct a.DepartmentID from CTE_1 a inner join CTE_2 b on a.DepartmentID=b.DepartmentID 
where a.[Max Salary]-b.[Avg Salary]>20000


--Section C: Self Join Practice

--Q11 Find pairs of employees hired in the same year.
select distinct a.EmployeeID, a.FirstName,a.LastName,b.EmployeeID,b.FirstName,b.LastName from Employees a inner join Employees b on Year(a.HireDate)=Year(b.HireDate) 
where a.EmployeeID<>b.EmployeeID and a.EmployeeID>b.EmployeeID


--Q12 Find pairs of employees earning the same salary.
select distinct a.EmployeeID,a.FirstName,a.LastName,b.EmployeeID,b.FirstName,b.LastName from Employees a 
inner join Employees b on a.Salary=b.Salary
where a.EmployeeID<>b.EmployeeID and a.EmployeeID>b.EmployeeID


--Q13 Find pairs of employees working in different departments. (Avoid duplicate pairs.)
select distinct a.EmployeeID,a.FirstName,a.DepartmentID,b.EmployeeID,b.FirstName,b.DepartmentID from Employees a 
inner join Employees b on a.DepartmentID<>b.DepartmentID 
where a.EmployeeID>b.EmployeeID


--Q14 Find employees hired before every other employee in their department. Think carefully.
select distinct a.* from Employees a 
left join Employees b on a.DepartmentID=b.DepartmentID and a.HireDate>b.HireDate where b.EmployeeID is Null

--or
select * from Employees e where HireDate=(
select min(HireDate) from Employees
where DepartmentID=e.DepartmentID)


--Q15 Find employees hired after at least one employee in their department.
select distinct a.FirstName,a.LastName,a.DepartmentID,a.HireDate,b.FirstName,b.LastName,b.DepartmentID,b.Salary from Employees a 
inner join Employees b on a.DepartmentID=b.DepartmentID 
where a.EmployeeID<>b.EmployeeID and a.HireDate>b.HireDate


--Section D: Ranking

--Q16 Find the third-highest salary in each department. (This is today's hardest ranking question.)
select DepartmentID,Salary from (
select *,DENSE_RANK() over(partition by DepartmentID order by Salary desc) [DR] from Employees) x where DR=3


--Q17 Find employees having the third-highest salary in their department.
select FirstName,LastName,Salary from (
select *,DENSE_RANK() over(partition by DepartmentID order by Salary desc) [DR] from Employees) x where DR=3


--Q18 Find the second-lowest salary in the company.
select min(Salary) [2nd Lowest Salary] from Employees where Salary>(
select min(Salary) from Employees)

--or
select Salary as [2nd Lowest Salary] from (
select *,DENSE_RANK() over(order by Salary) [DR] from Employees) x where DR=2


--Q19 Find employees having the second-lowest salary.
select FirstName,LastName,Salary as [2nd Lowest Salary] from (
select *,DENSE_RANK() over(order by Salary) [DR] from Employees) x where DR=2


--Q20 Find departments whose average salary ranks in the top 2. Ties should appear.
select top 2 with ties DepartmentID,avg(Salary) [Average Salary] from Employees
group by DepartmentID
order by avg(Salary) desc

--or
select * from (
select DepartmentID,avg(Salary) [Avg Salary],DENSE_RANK() over(order by avg(Salary) desc) [DR] from Employees
group by DepartmentID) x where DR in (1,2)


--Bonus Interview Set (Only if time remains)

--Q21 Find employees who earn more than their manager. Use the ManagerID table.
select a.EmployeeID,a.EmployeeName,a.Salary from Employees_2 a 
inner join Employees_2 b on a.ManagerID=b.EmployeeID 
where a.Salary>b.Salary


--Q22 Find managers who earn less than at least one of their subordinates.
select a.EmployeeID,a.EmployeeName,a.Salary from Employees_2 a 
inner join Employees_2 b on a.EmployeeID=b.ManagerID 
where a.Salary<b.Salary


--Q23 Find the manager with the highest-paid subordinate.
select EmployeeName from Employees_2 where EmployeeID in
(select top 1 with ties ManagerID from Employees_2
where not ManagerID is null
order by Salary desc)


--Q24 Find departments where every employee earns above the company average salary.Very good interview question.
select DepartmentID from Employees
group by DepartmentID
having min(Salary)>
(select avg(Salary) from Employees)


--Q25 Find departments where no employee earns above 90000. 
select distinct DepartmentID from Employees where DepartmentID not in (
select DepartmentID from Employees
group by DepartmentID
having max(Salary)>90000)

