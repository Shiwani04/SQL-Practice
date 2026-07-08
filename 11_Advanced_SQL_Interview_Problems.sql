/*
==========================================================
Practice Day 11 - Advanced SQL Interview Problems
==========================================================

Topics Covered:
✔️ Common Table Expressions (CTEs)
✔️ DENSE_RANK()
✔️ ROW_NUMBER()
✔️ TOP
✔️ Duplicate Record Removal
✔️ Temporary Tables
✔️ TRUNCATE
✔️ INSERT INTO ... SELECT
✔️ Manager-Reportee Hierarchy
✔️ Business Case-Based SQL Problems

Database Used:
- Employees
- ReportingStructure
- EmployeeRecords
*/

select * from Employees

--2nd Highest Salary
select max(salary) [2nd Highest Salary] from employees where salary <
(select max(Salary) from Employees)

--3rd Highest Salary
select max(salary) [3rd Highest Salary] from Employees where salary <
(select max(salary) from employees where salary <
(select max(Salary) from Employees))

--CTE
With cte as(
select *,DENSE_RANK() over(order by Salary desc) [DR] from Employees
)
select Salary [2nd Highest Salary] from CTE where DR=2

--3rd Highest Salary
With cte as(
select *,DENSE_RANK() over(order by Salary desc) [DR] from Employees
)
select Salary [2nd Highest Salary] from CTE where DR=3


--Sub Query along with DENSE_RANK()
select Salary [2nd Highest Salary] from
(select *, DENSE_RANK() over(order by Salary desc) [DR] from Employees) x where DR = 2

--3rd Highest Salary
select Salary [3rd Highest Salary] from
(select *, DENSE_RANK() over(order by Salary desc) [DR] from Employees) x where DR = 3


--Sub Query
select top 1 salary [2nd Highest Salary] from
(select distinct top 2 salary from Employees 
order by Salary desc) x 
order by Salary asc

--3rd Highest Salary
select top 1 salary [3rd Highest Salary] from
(select distinct top 3 Salary from Employees
order by Salary desc) y
order by Salary asc

----------------------------------------------------REPORTEE & MANAGER QUESTION---------------------------------------------------------

select * from ReportingStructure

select b.EmployeeName [Reportee], a.EmployeeName [Manager] from ReportingStructure a join ReportingStructure b 
on a.EmployeeID=b.ManagerID

union all

select employeeName,null from reportingstructure 
where managerid is null


----------------------------------------------------DELETING DUPLICATES (All record was duplicate)---------------------------------------------------------

select * from EmployeeRecords
order by EmployeeID,EmployeeName,ManagerID

With CTE as (
select *,ROW_NUMBER() over(partition by EmployeeID,EmployeeName,ManagerID order by EmployeeID) [Row Number] FROM EmployeeRecords
)
--select * from CTE
Delete from CTE where [Row Number] = 2

select * into emprecords_bkp from EmployeeRecords

select * from emprecords_bkp

select distinct * into #1 from emprecords_bkp

truncate table emprecords_bkp

insert into emprecords_bkp select* from #1

----------------------------------------------------DELETING DUPLICATES (Certain Values are duplicate)---------------------------------------------------------

select * from EmployeeRecords_1
order by EmployeeID,email

select distinct * into #1 from EmployeeRecords_1

truncate table EmployeeRecords_1
insert into EmployeeRecords_1 select * from #1

---Records with lower employeeID should remain
with CTE as (
select *,DENSE_RANK() over(partition by email order by EmployeeID) [DR] from EmployeeRecords_1
)
delete from CTE where DR=2

select * into EmployeeRecords_2 from #1

select * from EmployeeRecords_2
order by email

---Records with higher employeeID should remain
with CTE2 as (
select *,DENSE_RANK() over(partition by email order by EmployeeID desc) [DR] from EmployeeRecords_2
)
delete from CTE2 where DR=2

select * from EmployeeRecords_1 -- Employeeid=5 was retained

select * from EmployeeRecords_2 -- Employeeid=6 was retained