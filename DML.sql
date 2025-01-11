               ---PROJECT NAME E-COMMERCE---
				  ---CREATED BY KOHINUR KHATUN---

USE E_Commerce
GO 
-- Insert into Users
INSERT INTO Users
VALUES
('Kohinur Khatun', 'Kohinur@123', 'kohi9312248@gmail.com', '2024-11-28'),
('Umme Habiba', 'Habiba@123', 'habiba12248@gmail.com', '2024-10-28'),
('S.M Sezan Rahman', 'Sezan@123', 'Sezan48@gmail.com', '2024-11-29'),
('Abu Sayed', 'Sayed@123', 'Sayed12248@gmail.com', '2024-11-22')
GO

-- Insert into Categories
INSERT INTO Categories
VALUES
(1, 'Electronics'),
(2, 'Clothing'),
(3, 'Books'),
(4, 'Home & Kitchen'),
(5, 'Toys'),
(6, 'SportsKit'),
(7, 'Shoes'),
(8, 'Light'),
(9, 'Fan'),
(10, 'Vegetables')
GO

-- Insert into Products
INSERT INTO Products
VALUES
('SmartPhone', 15000.00, 1, '2024-09-28'),
('Laptop', 30000.00, 2, '2024-10-28'),
('T-Shirt', 1500.00, 3, '2024-11-28'),
('SQL Server Book', 100.00, 4, '2024-10-28'),
('Blender', 500.00, 5, '2024-12-28'),
('Fan', 2000.00, 6, '2024-10-28')
GO

-- Insert into Orders
INSERT INTO Orders
VALUES
(1, 1, '2024-11-28', 1000.00),
(2, 2, '2024-11-29', 2000.00),
(3, 3, '2024-12-30', 600.00),
(4, 4, '2023-12-22', 800.00)
GO

     -- Insert into OrderItems
INSERT INTO OrderItems
VALUES
(1, 1, 1, 15000.00, 2, 0.05, '2024-09-08'),
(2, 2, 2, 30000.00, 3, 0.05, '2024-12-09'),
(3, 3, 3, 1500.00, 5, 0.05, '2024-12-10'),
(4, 4, 4, 100.00, 15, 0.05, '2024-11-11')
GO

-- Insert into Reviews
INSERT INTO Reviews
VALUES
(NULL, 1, 1, 5, '2024-11-28'),
(NULL, 2, 2, 4, '2024-11-28'),
(NULL, 3, 3, 3, '2024-12-28'),
(NULL, 4, 4, 5, '2024-12-28')
GO

-- Update Users
UPDATE Users
SET UserName = 'Kabiya Jannat'
WHERE UserId = 4
GO

UPDATE Users
SET UserName = 'Al Kiyas'
WHERE UserId = 4
GO
-- Select from Users
SELECT * FROM Users
GO

-- Select from Categories
SELECT * FROM Categories
GO

-- Select from OrderItems
SELECT * FROM OrderItems
GO

-- Select from Orders
SELECT * FROM Orders
GO

-- Select from Products
SELECT * FROM Products
GO

-- Select from Reviews
SELECT * FROM Reviews
GO

-- Use CTE with UNION ALL
WITH USERCTE AS (
    SELECT * FROM Users WHERE Email = 'ah9312248@gmail.com'
),
USERCTE2 AS (
    SELECT * FROM Users WHERE UserName = 'Jaber Hossain'
)
SELECT * FROM USERCTE
UNION ALL
SELECT * FROM USERCTE2
GO

-- Use GROUP BY for OrderItemId
SELECT OrderItemId, SUM(UnitPrice * Quantity) AS 'TOTAL AMOUNT'
FROM OrderItems
GROUP BY OrderItemId
GO

-- Use HAVING to find OrderItemId=2
SELECT OrderItemId, SUM(UnitPrice * Quantity) AS 'TOTAL AMOUNT'
FROM OrderItems
GROUP BY OrderItemId
HAVING OrderItemId = 2
GO

-- Use INNER JOIN between OrderItems and Products
SELECT Products.ProductId,
       OrderItems.UnitPrice * Quantity * (1 - DiscountPercent) AS 'CurrentPrice'
FROM Products
INNER JOIN OrderItems
ON Products.ProductId = OrderItems.ProductId
GO

-- Use LEFT JOIN between OrderItems and Products
SELECT Products.ProductId, 
       OrderItems.UnitPrice * Quantity * (1 - DiscountPercent) AS 'CurrentPrice',
       OrderItems.ProductId, OrderItems.UnitPrice * Quantity * (1 - DiscountPercent) AS 'CurrentPrice'
FROM Products
LEFT JOIN OrderItems
ON Products.ProductId = OrderItems.ProductId
GO

-- Use RIGHT JOIN between OrderItems and Products
SELECT Products.ProductId, 
       OrderItems.UnitPrice * Quantity * (1 - DiscountPercent) AS 'CurrentPrice',
       OrderItems.ProductId, OrderItems.Date
FROM Products
RIGHT JOIN OrderItems
ON Products.ProductId = OrderItems.ProductId
GO

-- Use FULL OUTER JOIN between OrderItems and Products
SELECT Products.ProductId, 
       OrderItems.UnitPrice * Quantity * (1 - DiscountPercent) AS 'CurrentPrice',
       OrderItems.Quantity, OrderItems.ProductId, OrderItems.Date
FROM Products
FULL OUTER JOIN OrderItems
ON Products.ProductId = OrderItems.ProductId
GO

-- Alter Table to Add Column
ALTER TABLE OrderItems
ADD LoseProduct VARCHAR(30) DEFAULT 'N/A'
GO

-- Check Max with Subquery
SELECT * FROM OrderItems
WHERE Quantity = (SELECT MAX(Quantity) FROM OrderItems)
GO

-- Use NOT EXISTS to find uncommon data
SELECT * FROM OrderItems
WHERE NOT EXISTS (
    SELECT * FROM Products
    WHERE Products.ProductId = OrderItems.OrderItemId
)
GO

-- Check SOME
IF 4 >= SOME (SELECT ProductId FROM Products)
PRINT 'AVAILABLE'
ELSE
PRINT 'NOT AVAILABLE'
GO

-- Check ANY
IF 4 >= ANY (SELECT ProductId FROM Products)
PRINT 'AVAILABLE'
ELSE
PRINT 'NOT AVAILABLE'
GO

-- Check ALL
IF 4 >= ALL (SELECT ProductId FROM Products)
PRINT 'AVAILABLE'
ELSE
PRINT 'NOT AVAILABLE'
GO

-- Use ROLLUP for SUM of RecentPrice
SELECT COALESCE(OrderItemId, '') AS 'OrderItemId',
       SUM(Quantity * UnitPrice * (1 - DiscountPercent)) AS 'RecentPrice'
FROM OrderItems
GROUP BY ROLLUP(OrderItemId)
GO

-- TABLE VALUE FUNCTION FOR ORDERITEMS--
 SELECT * FROM dbo.OrderItemsFUNCTIONS(2024,09,08)
    SELECT * FROM dbo.OrderItemsFUNCTIONS(2024,12,09)
	    SELECT * FROM dbo.OrderItemsFUNCTIONS(2024,12,10)
			    SELECT * FROM dbo.OrderItemsFUNCTIONS(2024,11,11)
-- Stored Procedure with Return READ
				DECLARE @RETURN INT
EXEC @RETURN= SP_Returns @ProductId=1
--TRANSACTION READ
 EXEC SP_Category '10','Sport','SELECT'
 GO
  EXEC SP_Category '2','DEVICE','UPDATE'
 GO

-- Update Reviews Table with Sequence
UPDATE Reviews
SET ReviewId = NEXT VALUE FOR S_Reviews
GO

-- View Encryption and Schema Binding
EXEC sp_helptext 'V_loger'
GO




