create database practicalQue
use practicalQue

-- DROP TABLES IF THEY EXIST
DROP TABLE IF EXISTS Employees, Customers, Orders, Products, Temp, Students;

-- 1. Create Employees table
CREATE TABLE Employees (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    department_id INT,
    salary DECIMAL(10, 2),
    hire_date DATE,
    manager_id INT
);

-- Insert sample employees
INSERT INTO Employees (id, name, department_id, salary, hire_date, manager_id) VALUES
(1, 'Alice', 1, 80000, '2025-06-01', NULL),
(2, 'Bob', 2, 75000, '2025-03-15', 1),
(3, 'Charlie', 1, 50000, '2024-12-10', 1),
(4, 'David', 3, 65000, '2023-09-20', 2),
(5, 'Eva', 2, 85000, '2025-07-10', NULL),
(6, 'Frank', 2, 47000, '2024-01-05', 2),
(7, 'Grace', 3, 30000, '2022-11-11', NULL);

-- 2. Create Customers table
CREATE TABLE Customers (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);

-- Insert sample customers
INSERT INTO Customers (id, name, email) VALUES
(1, 'Customer A', 'a@example.com'),
(2, 'Customer B', 'b@example.com'),
(3, 'Customer C', 'c@example.com'),
(4, 'Customer D', 'a@example.com'),  -- Duplicate email
(5, 'Customer E', 'e@example.com');

-- 3. Create Orders table
CREATE TABLE Orders (
    id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    product_id INT,
    quantity INT
);

-- 4. Create Products table
CREATE TABLE Products (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    price DECIMAL(10, 2)
);

-- Insert sample products
INSERT INTO Products (id, name, price) VALUES
(1, 'Laptop', 1200.00),
(2, 'Mouse', 25.00),
(3, 'Keyboard', 45.00),
(4, 'Monitor', 300.00),
(5, 'Desk', 150.00);

-- Insert sample orders
INSERT INTO Orders (id, customer_id, order_date, product_id, quantity) VALUES
(1, 1, '2025-08-01', 1, 1), -- Laptop
(2, 1, '2025-08-02', 2, 2), -- Mouse
(3, 2, '2025-06-05', 3, 1),
(4, 3, '2025-01-10', 4, 1),
(5, 1, '2025-05-15', 2, 1), -- Mouse
(6, 4, '2025-03-03', 1, 1), -- Laptop
(7, 5, '2024-12-25', 5, 1),
(8, 2, '2024-10-11', 2, 1), -- Mouse
(9, 1, '2025-08-25', 1, 1); -- Laptop

-- 5. Create Temp table (for temporary records)
CREATE TABLE Temp (
    id INT PRIMARY KEY,
    description VARCHAR(100),
    created_at DATE
);

-- Insert temp data (some older than 30 days, some recent)
INSERT INTO Temp (id, description, created_at) VALUES
(1, 'Old record', '2025-07-01'),
(2, 'Recent record', '2025-08-25'),
(3, 'Very old record', '2025-06-01');

-- 6. Create Students table
CREATE TABLE Students (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    age INT,
    grade CHAR(1)
);

-- Insert sample students (at least 5 rows)
INSERT INTO Students (id, name, age, grade) VALUES
(1, 'John', 20, 'A'),
(2, 'Sara', 22, 'B'),
(3, 'Mike', 21, 'C'),
(4, 'Linda', 23, 'A'),
(5, 'Tom', 20, 'B');

-- SQL Server Practical Questions
-- 1. Write a SQL query to select top 5 highest paid employees from the Employees table.
select top 5 salary from Employees order by salary desc;

-- 2. Create a SQL query to find the total number of orders placed by each customer.
select c.id,c.name,count(o.product_id) as total_orders 
from Customers c join Orders o on c.id=o.customer_id
group by c.id,c.name

-- 3. Write a query to display department-wise average salary from the Employees table.
select department_id,avg(salary) as avg_salary from Employees
group by department_id


-- 4. Create a SQL query to fetch employees who joined in the last 6 months.
select * from Employees 
where DATEDIFF(MONTH,hire_date,GETDATE())<=6

-- 5. Write a query to find duplicate email addresses in a Customers table.
select email,count(*) as dup from Customers
group by email
having count(*) > 1

-- 6. Write a query to join Orders and Customers tables to display order id, customer name, and order date.
select o.id,c.name,o.order_date 
from Orders o join Customers c on o.customer_id=c.id

-- 7. Create a query using GROUP BY to find total sales per product.
select p.id,p.name, sum(o.quantity*o.product_id*p.price) as sales_per_product
from Products p join Orders o on p.id=o.product_id
group by p.id,p.name

-- 8. Write a SQL query using a subquery to find employees whose salary is above the average salary.
select * from Employees
where salary > (select AVG(salary) from Employees)

-- 9. Create a query using a window function to rank products based on sales quantity.
select o.id,sum(o.quantity*o.product_id) as sales,
RANK () OVER (ORDER BY sum(o.quantity*o.product_id) Desc) rank_no
from Orders o join Products p on o.product_id=p.id
group by o.id

-- 10. Write a query to delete all records from a Temp table older than 30 days.
delete from Temp 
where DATEDIFF(DAY,created_at,GETDATE()) > 30

-- 11. Write a query to create a new table Students with columns (id, name, age, grade).
CREATE TABLE Students (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    age INT,
    grade CHAR(1)
);

-- 12. Insert at least 5 rows into the Students table using a single INSERT statement.
INSERT INTO Students (id, name, age, grade) VALUES
(1, 'John', 20, 'A'),
(2, 'Sara', 22, 'B'),
(3, 'Mike', 21, 'C'),
(4, 'Linda', 23, 'A'),
(5, 'Tom', 20, 'B');

-- 13. Update the salary of all employees in the IT department by 10%.
-- department_id = 2 is IT dept
update Employees
set salary=salary*1.10
where department_id = 2 

select * from Employees

-- 14. Delete all orders from the Orders table where the order date is older than 2015.
delete from Orders
where order_date < '01-01-2015'; 
select * from Orders

-- 15. Write a query to fetch the second highest salary from the Employees table.
select max(salary) from Employees
where salary <(select max(salary) from Employees)

-- 16. Create a SQL query to display customers who have placed more than 3 orders.
select c.name,c.email,o.quantity
from Customers c join Orders o on c.id=o.customer_id
where o.quantity >3

-- 17. Write a query to fetch the maximum, minimum, and average salary from Employees.
select	max(salary) as max_salary,
		min(salary) as min_salary,
		AVG(salary) as avg_salary
from Employees

-- 18. Create a query to list employees who do not have a manager (NULL manager_id).
select id,name,salary
from Employees
where manager_id is Null

-- 19. Write a query to fetch all employees whose names start with 'A'.
select * from Employees
where name like 'A%'

-- 20. Create a query to count the number of employees in each department.
select department_id,count(name) numOfEmp from Employees
group by department_id

-- 21. Write a query to create a view named HighSalaryEmployees showing employees with salary > 60000.
create view HighSalaryEmployees 
as 
select * from Employees
where salary>60000;
select * from HighSalaryEmployees

-- 22. Write a query to display products with no sales in the last 6 months.
select p.id,p.name 
from Products p 
where not exists(select 1 from Orders o 
where o.product_id=p.id and o.order_date >= dateadd(month,-6,GETDATE()))

-- 23. Create a stored procedure that accepts a department id and returns all employees in that department.
create procedure deptID
@department_id int
as 
begin
select * from Employees 
where department_id=@department_id
end;

exec deptID @department_id=2

-- 24*. Write a SQL query to calculate running totals of sales by date.
WITH DailySales AS (
  SELECT
    o.order_date,
    SUM(o.quantity * p.price) AS daily_total
  FROM
    Orders o
  JOIN
    Products p ON o.product_id = p.id
  GROUP BY
    o.order_date
)
SELECT
  order_date,
  daily_total,
  SUM(daily_total) OVER (ORDER BY order_date) AS running_total
FROM
  DailySales
ORDER BY
  order_date;

-- 25. Create a query to find customers who ordered both 'Laptop' and 'Mouse'.
select o.customer_id
from Orders o join Products p on o.product_id=p.id
where p.name in ('laptop','mouse')
group by o.customer_id
having COUNT(distinct p.name)=2
