/*
==========================================================
Practice Day 05 - SQL Aggregations & Date Functions
==========================================================

Topics Covered:
✔️ SUM()
✔️ COUNT()
✔️ AVG()
✔️ GROUP BY
✔️ HAVING
✔️ MONTH()
✔️ YEAR()

Database Used:
- EmployeeSales
*/

select * from EmployeeSales

--1) Write a query to calculate the total sales amount for each department in the EmployeeSales table.
select Department, sum(SaleAmount) [Total Sale Amount] from EmployeeSales
group by Department

--2) Write a query to count the number of sales made by each employee.
select EmployeeID, count(SaleID) [Number of sales] from EmployeeSales -- need to use saleID because count does not consider null value, since here saleiD is primary key and it cannot be null that is why saleID needs to be added
group by EmployeeID

--3) Write a query to calculate the average sale amount for each department.
select Department, avg(SaleAmount) [Average Sales Amount] from EmployeeSales
group by Department

--4) Write a query to find the total sales amount for each employee, but only include employees who have made more than one sale.
select EmployeeID, sum(SaleAmount) [Total Sale Amount] from EmployeeSales
group by EmployeeID
having count(SaleID)>1 -- need to use saleID because count does not consider null value, since here saleiD is primary key and it cannot be null that is why saleID needs to be added

--5) Write a query to find the total sales for each month in 2023.
select Month(SaleDate) [Month],sum(SaleAmount) [Total Sale Amount] from EmployeeSales
where Year(SaleDate)=2023
group by Month(SaleDate)
