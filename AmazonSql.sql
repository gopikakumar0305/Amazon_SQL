create database amazon;
use amazon;
select * from products;
select * from customers;
select * from order_details;
select * from orders;
select * from reviews;
select * from suppliers;

-- TASK-3A Retrieve all customers from a specific city
SELECT * FROM customers
WHERE City = 'Patelberg';

-- TASK 3B
SELECT * FROM Products
WHERE Category = 'Fruits';

-- TASK4
CREATE TABLE Customer (
    CustomerID VARCHAR(50) PRIMARY KEY,
    Name VARCHAR(100) UNIQUE,
    Age INT NOT NULL CHECK (Age > 18),
    Gender VARCHAR(20),
    City VARCHAR(100),
    State VARCHAR(100),
    Country VARCHAR(100),
    SignupDate DATE,
    PrimeMember VARCHAR(10) DEFAULT 'No'
);

-- TASK 5 
DROP TABLE Products;
CREATE TABLE Products (
    ProductID VARCHAR(10) PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    SubCategory VARCHAR(50),
    PricePerUnit DECIMAL(10,2),
    StockQuantity INT,
    SupplierID VARCHAR(10)
);
-- Alter table
SHOW CREATE TABLE Products;
ALTER TABLE customers
CHANGE COLUMN `ï»¿CustomerID` CustomerID TEXT;

ALTER TABLE orders
CHANGE COLUMN `ï»¿OrderID` OrderID TEXT;

ALTER TABLE products
CHANGE COLUMN `ï»¿ProductID` ProductID VARCHAR(10);

ALTER TABLE suppliers
CHANGE COLUMN `ï»¿SupplierID` SupplierID TEXT;

ALTER TABLE reviews
CHANGE COLUMN `ï»¿ReviewID` ReviewID TEXT;

ALTER TABLE order_details
CHANGE COLUMN `ï»¿OrderID` OrderID TEXT;

INSERT INTO Products
(ProductID, ProductName, Category, SubCategory, PricePerUnit, StockQuantity, SupplierID)
VALUES
('P101','Apple','Fruits','Fresh Fruits',120,100,'S001'),
('P102','Banana','Fruits','Fresh Fruits',60,150,'S002'),
('P103','Milk','Dairy','Fresh Milk',55,80,'S003');

-- TASK 6
UPDATE Products
SET StockQuantity = 250
WHERE ProductID = 'P101';

-- TASK 7
SET SQL_SAFE_UPDATES = 0;
DELETE FROM Suppliers
WHERE City = 'Chennai';
SET SQL_SAFE_UPDATES = 1;
DESC Suppliers;
SELECT * FROM Products;
DELETE FROM Suppliers
WHERE City = 'Chennai';

-- TASK 8 Rating Constraint
ALTER TABLE Reviews
DROP CHECK chk_rating;
ALTER TABLE Reviews
ADD CONSTRAINT chk_rating
CHECK (Rating BETWEEN 1 AND 5);
-- Prime Member Default
ALTER TABLE Customers
MODIFY COLUMN PrimeMember VARCHAR(10) DEFAULT 'No';
ALTER TABLE Customers
MODIFY COLUMN PrimeMember ENUM('Yes','No') DEFAULT 'No';

-- TASK 9 Orders after 2024-01-01
SELECT *  FROM Orders
WHERE OrderDate > '2024-01-01';

-- Products with Average Rating > 4
SELECT
    ProductID,
    AVG(Rating) AS AvgRating
FROM Reviews
GROUP BY ProductID
HAVING AVG(Rating) > 4;
-- Rank Products by Total Sales
SELECT
    ProductID,
    SUM(Quantity) AS TotalSales
FROM Order_Details
GROUP BY ProductID
ORDER BY TotalSales DESC;

-- TASK 10 High-value customers (₹5000+)

SELECT
    c.CustomersID,
    c.Name,
    SUM(o.OrderAmount) AS TotalSpent
FROM Customers c
JOIN Orders o
ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.Name
HAVING SUM(o.OrderAmount) > 5000
ORDER BY TotalSpent DESC;

SELECT
    c.ID,
    c.Name,
    SUM(o.OrderAmount) AS TotalSpent
FROM Customers c
JOIN Orders o
    ON c.ID = o.CustomerID
GROUP BY c.ID, c.Name
HAVING SUM(o.OrderAmount) > 5000
ORDER BY TotalSpent DESC;

-- TASK 11 Revenue Per Order
SELECT
    od.OrderID,
    SUM((od.UnitPrice - od.Discount) * od.Quantity) AS TotalRevenue
FROM Order_Details od
GROUP BY od.OrderID;
-- Customers with Most Orders
SELECT
    c.CustomerID,
    c.Name,
    COUNT(o.OrderID) AS TotalOrders
FROM Customers c
JOIN Orders o
ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.Name
ORDER BY TotalOrders DESC;
-- Supplier with Most Stock
SELECT
    s.SupplierID,
    s.SupplierName,
    SUM(p.StockQuantity) AS TotalStock
FROM Suppliers s
JOIN Products p
ON s.SupplierID = p.SupplierID
GROUP BY s.SupplierID, s.SupplierName
ORDER BY TotalStock DESC
LIMIT 1;

--  TASK 12
CREATE TABLE Categories(
    CategoryID INT PRIMARY KEY AUTO_INCREMENT,
    CategoryName VARCHAR(100)
);

CREATE TABLE SubCategories(
    SubCategoryID INT PRIMARY KEY AUTO_INCREMENT,
    SubCategoryName VARCHAR(100),
    CategoryID INT,
    FOREIGN KEY(CategoryID) REFERENCES Categories(CategoryID)
);

ALTER TABLE Products
ADD CategoryID INT,
ADD SubCategoryID INT;

ALTER TABLE Products
ADD CONSTRAINT fk_category
FOREIGN KEY(CategoryID)
REFERENCES Categories(CategoryID);

ALTER TABLE Products
ADD CONSTRAINT fk_subcategory
FOREIGN KEY(SubCategoryID)
REFERENCES SubCategories(SubCategoryID);

-- TASK 13 Top 3 Products by Revenue
SELECT
    ProductID,
    SUM((UnitPrice - Discount) * Quantity) AS Revenue
FROM Order_Details
GROUP BY ProductID
ORDER BY Revenue DESC
LIMIT 3;
-- Customers with No Orders
SELECT *
FROM Customers
WHERE CustomerID NOT IN
(
    SELECT CustomerID
    FROM Orders
);

-- TASK 14 Cities with Highest Prime Members
SELECT
    City,
    COUNT(*) AS PrimeMembers
FROM Customers
WHERE PrimeMember = 'Yes'
GROUP BY City
ORDER BY PrimeMembers DESC;
-- Top 3 Ordered Categories
SELECT
    SUM(od.Quantity) AS TotalOrders
FROM Products p
JOIN Order_Details od
ON p.ProductID = od.ProductID
GROUP BY p.Category
ORDER BY TotalOrders DESC
LIMIT 3;
