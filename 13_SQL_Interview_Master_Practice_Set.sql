
/*
==========================================================
Practice Day 13 - SQL Interview Master Practice Set
==========================================================

Topics Covered:
✔️ Aggregate Functions
✔️ GROUP BY & HAVING
✔️ Correlated Subqueries
✔️ Common Table Expressions (CTEs)
✔️ DENSE_RANK()
✔️ Self Joins
✔️ Manager-Employee Hierarchy
✔️ TOP WITH TIES
✔️ Business Case-Based SQL Problems
✔️ Department-Level Analysis
✔️ Ranking Problems

Database Used:
- Employees
- Departments
- Employees_2
*/

select * from Employees

select * from Departments

--### Part 1 (Warm-up) - 8 Questions

--Should take ~45 min.

--Use the same `Employees` and `Departments` tables.

--### Q1 Find employees whose salary is **below** their department's average salary.
select * from Employees e where Salary<
(select avg(Salary) from Employees
where e.DepartmentID=DepartmentID)


--### Q2 Find employees whose salary is exactly equal to their department's average salary.
select * from Employees e where Salary=
(select avg(Salary) from Employees
where e.DepartmentID=DepartmentID)


--### Q3 Find the department having the **maximum number of employees**. (Ties should appear.)
select top 1 with ties DepartmentID,count(EmployeeID) [Number of Employees] from Employees
group by DepartmentID
order by count(EmployeeID) desc


--### Q4 Find the department having the **minimum number of employees**. (Ties should appear.)
select top 1 with ties DepartmentID,count(EmployeeID) [Number of Employees] from Employees
group by DepartmentID
order by count(EmployeeID)


--### Q5 Find employees whose salary is greater than the salary of **John Smith**.
select * from Employees where Salary >
(select Salary from Employees where FirstName='John' and LastName='Smith')


--### Q6 Find employees hired before **Jane Doe**.
select * from Employees where HireDate<
(select HireDate from Employees where FirstName='Jane' and LastName='Doe')


--### Q7 Find employees working in the same department as **Michael Johnson** but exclude Michael.
select EmployeeID,FirstName,LastName from Employees where DepartmentID=
(select DepartmentID from Employees where FirstName='Michael' and LastName='Johnson')
and not EmployeeID=(select EmployeeID from Employees where FirstName='Michael' and LastName='Johnson')


--### Q8 Find departments where the total salary paid is greater than **150000**.
select DepartmentID,sum(Salary) [Total Salary] from Employees
group by DepartmentID
having sum(Salary)>150000


--# Part 2 (Main Practice) - 10 Questions

--These are where the learning happens.

--### Q9 Find employees whose salary is the **highest in their department**. (No hints. You have solved something very similar.)
select * from Employees e where Salary =
(select max(Salary) from Employees
where DepartmentID=e.DepartmentID)


--### Q10 Find employees whose salary is the **lowest in their department**.
select * from Employees e where Salary =
(select min(Salary) from Employees
where DepartmentID=e.DepartmentID)


--### Q11 Find departments where the average salary is greater than the company's average salary. Read carefully. 
--Not department average > 80000.
--Department average > company average.
select DepartmentID,avg(Salary) [Dept Avg Salary] from Employees
group by DepartmentID 
having avg(Salary)>(select avg(Salary) from Employees)


--### Q12 Find employees who earn more than the average salary of employees hired in 2021.
select * from Employees where Salary>
(select avg(Salary) from Employees where Year(HireDate) = '2021')


--### Q13 Find employees who belong to the department with the highest total salary.
--This is a 2-step problem.
select * from Employees where DepartmentID in (
select top 1 with ties DepartmentID from Employees
group by DepartmentID
order by sum(Salary)desc)


--### Q14 Find employees who belong to the department with the lowest average salary.
select * from Employees where DepartmentID in 
(select top 1 with ties DepartmentID from Employees
group by DepartmentID
order by avg(Salary) asc)


--### Q15 Find departments whose total salary is greater than the total salary of the Finance department.
select DepartmentID,sum(Salary) [Total Salary] from Employees
group by DepartmentID
having sum(Salary)>
(select sum(Salary) from Employees e 
join Departments d on e.DepartmentID=d.DepartmentID 
where DepartmentName = 'Finance')


--### Q16 Find employees who earn the same salary as another employee.(No duplicate rows in output.)
select a.EmployeeID,a.FirstName,a.LastName,a.Salary from Employees a inner join Employees b on a.Salary=b.Salary
where a.EmployeeID<>b.EmployeeID

--or
select EmployeeID,FirstName,LastName,Salary from (
select *,DENSE_RANK() over(order by Salary desc)[DR] from Employees) x
where DR=3


--### Q17 Find employees hired in the same year as another employee. (Self-join thinking.)
select a.FirstName,a.LastName from Employees a inner join Employees b on Year(a.HireDate)=Year(b.HireDate)
where a.EmployeeID<>b.EmployeeID


--### Q18 Find pairs of employees earning the same salary. (Self join.)
select * from Employees a inner join Employees b on a.Salary=b.Salary
where a.EmployeeID<>b.EmployeeID and a.EmployeeID>b.EmployeeID


--# Part 3 (Thinking Practice) - 7 Questions These are slightly trickier.

--### Q19 Find the third-highest salary in the company.
select Salary as [3rd Highest Salary] from (
select *,DENSE_RANK() over(order by Salary desc) [DR] from Employees) x where DR=3

--or

select max(Salary) [3rd Highest Salary] from Employees where Salary<(
select max(Salary) from Employees where Salary<(
select max(Salary) from Employees))

--or

select top 1 with ties Salary [3rd Highest Salary] from (
select top 3 with ties Salary from Employees
order by Salary desc) x
order by Salary


--### Q20 Find employees having the third-highest salary.
select FirstName,LastName from (
select *,DENSE_RANK() over(order by Salary desc) [DR] from Employees) x where DR=3

--or
select FirstName,LastName from Employees where Salary=(
select max(Salary) [3rd Highest Salary] from Employees where Salary<(
select max(Salary) from Employees where Salary<(
select max(Salary) from Employees)))

--or
select top 1 with ties FirstName,LastName from (
select top 3 with ties * from Employees
order by Salary desc) x
order by Salary


--### Q21 Find departments whose average salary is between the highest and lowest department averages. Read this 2-3 times before coding.
select* from (select departmentID,avg(Salary) [Average Salary] from Employees
group by DepartmentID) y
where [Average Salary] <
(select max([Average Salary]) [Max Avg Salary] from (
select departmentID,avg(Salary) [Average Salary] from Employees
group by DepartmentID) x)
and 
[Average Salary] >
(select min([Average Salary]) [Min Avg Salary] from (
select departmentID,avg(Salary) [Average Salary] from Employees
group by DepartmentID) x)


select * from (
select DepartmentID,avg(Salary) [Avg Salary],
DENSE_RANK() over(order by avg(Salary)) [DR Max], 
DENSE_RANK() over(order by avg(Salary) desc) [DR Min] from Employees
group by DepartmentID) x where [DR Max]>1 and [DR Min]>1

--or
with CTE as (
select DepartmentID,avg(Salary) [Average Salary] from Employees
group by DepartmentID
)
Select * from CTE where 
[Average Salary]<(select max([Average Salary]) from CTE) 
and [Average Salary]>(select min([Average Salary]) from CTE)


--### Q22 Find employees who are not the highest-paid employee in their department.
select FirstName,LastName,Salary,DepartmentID from Employees e where Salary<(
select max(Salary) from Employees
where DepartmentID=e.DepartmentID)


--### Q23 Find employees who are not the lowest-paid employee in their department.
select FirstName,LastName,Salary,DepartmentID from Employees e where Salary>(
select min(Salary) from Employees
where DepartmentID=e.DepartmentID)


--### Q24 Find departments that have more employees than the average department size. This is an interview favourite.
select DepartmentID,count(EmployeeID) [Number of Employees] from Employees
group by DepartmentID
having count(EmployeeID)>
(select avg([Number of Employees]) [Average Department Size] from (
select DepartmentID,count(EmployeeID) [Number of Employees] from Employees
group by DepartmentID) x)


--### Q25 Find employees whose salary is greater than **all employees in the IT department**. You already did the Finance version.
select EmployeeID,FirstName,LastName,Salary from Employees where Salary>
(select max(Salary) from Employees e inner join Departments d on e.DepartmentID=d.DepartmentID where DepartmentName='IT')


--# Stretch Questions (Only if you finish early)

--### Q26 Find the second-highest salary in each department.
select DepartmentID,max(Salary) [2nd Highest Salary] from Employees e where Salary<(
select max(Salary) from Employees
where DepartmentID=e.DepartmentID)
group by DepartmentID


--### Q27 Find employees having the second-highest salary in their department.
select FirstName,LastName,Salary,DepartmentID from Employees a where Salary =
(select max(Salary) [2nd Highest Salary] from Employees b where Salary<(
select max(Salary) from Employees
where DepartmentID=b.DepartmentID) and DepartmentID=a.DepartmentID)


--### Q28 Find departments where every employee earns more than 70000. Think carefully.
select distinct DepartmentID from Employees where DepartmentID not in (
select DepartmentID from Employees where Salary<=70000)


--### Q29 Find departments where at least one employee earns more than 90000.
select distinct DepartmentID from Employees where DepartmentID in (
select DepartmentID from Employees where Salary>90000)


--### Q30 Find employees who earn more than their manager. (No manager table exists. Create one yourself and practice.)
CREATE TABLE Employees_2 (
    EmployeeID INT,
    EmployeeName VARCHAR(50),
    Salary INT,
    ManagerID INT
);

INSERT INTO Employees_2
VALUES
(1, 'Amit', 120000, NULL),
(2, 'Priya', 90000, 1),
(3, 'Rahul', 130000, 1),
(4, 'Neha', 85000, 2),
(5, 'Arjun', 95000, 2),
(6, 'Karan', 80000, 3);

select a.EmployeeName,a.Salary,b.EmployeeName [Manager Name],b.Salary from Employees_2 a 
inner join Employees_2 b on a.ManagerID=b.EmployeeID where a.Salary>b.Salary

select * from Employees_2
