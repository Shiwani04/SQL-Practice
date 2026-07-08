

--1) How do you select all columns from the Employees table?
select * from Employees

--2) How do you select only the FirstName and Last Name columns from the Employees table?
select FirstName, LastName from Employees

--3) How do you find all employees who work in the 'IT' department?
select * from Employees where Department = 'IT'

--or
select * from Employees where Department like 'IT'

--4) How do you select employees with a salary greater than 70,000?
select * from Employees where Salary>70000

--5) How do you sort the results by Last Name in ascending order?
select * from Employees
order by LastName

--6) How do you select distinct departments from the Employees table?
select distinct department from Employees

--7) How do you count the number of employees in each department?
select department, count(EmployeeID) [Total employees] from Employees
group by Department

--or
select department, count(*) [Total employees] from Employees
group by Department


--8) How do you find the maximum salary in the Employees table?
select max(Salary) [Max Salary] from Employees

--9) How do you find the average salary of employees in the 'Finance' department?
select avg(Salary) [Avg Finance Salary] from Employees where Department='Finance'

--or
select avg(Salary) [Avg Finance Salary] from Employees where Department like 'Finance'

--10) How do you select employees whose last name starts with 'M'?
select * from Employees where LastName like 'M%'
