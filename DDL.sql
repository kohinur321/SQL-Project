                  ---PROJECT NAME E-COMMERCE---
				  ---CREATED BY KOHINUR KHATUN---
---CREATE DATABASE

DROP DATABASE E_Commerce
GO 
CREATE Database E_Commerce
ON PRIMARY 
(Name='E_Commerce',
FileName='C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\E_Commerce.mdf',
Size=10MB,
MaxSize=100MB,
FileGrowth=10%)
LOG ON 
(Name='E_Commerce1',
FileName='C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\E_Commerce1.ldf',
Size=10MB,
MaxSize=25MB,
FileGrowth=10%)
GO
        --1. CREATE USER TABLE
USE E_Commerce 
CREATE table Users(
    UserId INT PRIMARY KEY IDENTITY NOT NULL,
    UserName VARCHAR(40) NOT NULL,
    PassWord VARCHAR(285) NOT NULL,
    Email VARCHAR(40) NOT NULL CHECK (Email LIKE'%[@]%'),
    CreatedAt DATETIME DEFAULT GETDATE()
)
GO
     --2. Categories Table
CREATE TABLE Categories(
    CategoryId INT PRIMARY KEY,
    CategoryName VARCHAR(50)
)
GO
      --3. Products Table
CREATE TABLE Products(
    ProductId INT PRIMARY KEY IDENTITY NOT NULL,
    Name VARCHAR(30) NOT NULL,
    Price MONEY NOT NULL,
    CategoryId INT,
    FOREIGN KEY(CategoryId) REFERENCES Categories(CategoryId),
    Createdat DATETIME DEFAULT GETDATE() NOT NULL
)
GO
        -- 4. Orders Table 
       create table Orders(
    OrderId INT PRIMARY KEY NOT NULL,
    UserId INT,
    OrderDate DATETIME NOT NULL,
    Total MONEY NOT NULL,
    FOREIGN KEY (UserId) REFERENCES Users(UserId)
)
GO

      --5. OrderItems Table
   create table OrderItems(
    OrderItemId INT PRIMARY KEY NOT NULL,
    OrderId INT,
    ProductId INT,
    UnitPrice MONEY NOT NULL,
    Quantity INT NOT NULL,
    DiscountPercent FLOAT DEFAULT .05,
    Date DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (OrderId) REFERENCES Orders(OrderId),
    FOREIGN KEY (ProductId) REFERENCES Products(ProductId)
)
GO
      --6.  Reviews Table
CREATE TABLE Reviews (
    ReviewId INT,
    ProductId INT,
    UserId INT,
    Rating INT CHECK (Rating >= 1 AND Rating <= 5),
    ReviewDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (ProductId) REFERENCES Products(ProductId),
    FOREIGN KEY (UserId) REFERENCES Users(UserId)
)
GO
SELECT * FROM Reviews
         --7. Sequence Reviews Table
CREATE SEQUENCE S_Reviews
AS INT
START WITH 1
INCREMENT BY 1
MINVALUE 1
MAXVALUE 4
CYCLE
GO
     -- Clustered Index(Rating) 
CREATE CLUSTERED INDEX MYREVIEWS
ON Reviews(Rating)
GO
       --Clustered Index  (UserId)
CREATE NONCLUSTERED INDEX USERINDEX
ON Reviews(UserId)
GO
      -- Create View for Reviews
CREATE VIEW V_Review
AS 
SELECT UserId, Rating
FROM Reviews
GO
    --Encryption
CREATE VIEW V_TRAINEE
WITH ENCRYPTION
AS 
SELECT UserId, Rating
FROM dbo.Reviews
GO
    --Encryption and Schema Binding
CREATE VIEW V_loger
WITH ENCRYPTION, SCHEMABINDING
AS 
SELECT UserId, Rating
FROM dbo.Reviews
GO
   --TABLE VALUE FUNCTION FOR ORDERITEMS--
  CREATE FUNCTION OrderItemsFUNCTIONS
  (@Year INT,
  @Month INT,
  @Day INT)
  RETURNS TABLE 
  AS 
  RETURN
  (SELECT SUM(UnitPrice*Quantity)AS'TOTALSALE',
  SUM(Unitprice*Quantity*DiscountPercent)AS'TOTAL DISCOUNT',
  SUM(UnitPrice*Quantity*(1-DiscountPercent))AS'NET AMOUNT'
  FROM OrderItems
  WHERE YEAR(DATE)=@Year AND MONTH(DATE)=@Month AND DAY(DATE)=@Day)
  GO
 
-- Trigger with RAISEERROR in Categories Table
CREATE TABLE AccountlogIN
(
logID INT IDENTITY(1,1),
CategoryId INT,
CategoryName VARCHAR(100)
)
GO
    ---CREATE TRIGGERS
CREATE TRIGGER Tr_Categories
ON Categories
INSTEAD OF DELETE
AS
BEGIN
    DECLARE @CategoryId INT
    SELECT @CategoryId = DELETED.CategoryId FROM DELETED
    IF @CategoryId = 1
    BEGIN
        RAISERROR ('Deleted not granted by owner', 16, 1)
        ROLLBACK
        INSERT INTO AccountlogIN 
        VALUES (@CategoryId, 'INVALID')
    END
    ELSE
    BEGIN
        DELETE  Categories
        WHERE @CategoryId = CategoryId
        INSERT INTO Categories 
        VALUES (@CategoryId, 'DELETE')
    END
END
GO

-- Stored Procedure with Output
CREATE PROCEDURE SP_IN
    (@ProductId INT OUTPUT)
AS
BEGIN
    SELECT COUNT(@ProductId)
    FROM Products
END
GO

-- Stored Procedure with Return
CREATE PROCEDURE SP_Returns
    (@ProductId INT)
AS
BEGIN
    SELECT ProductId
    FROM Products
    WHERE ProductId = @ProductId
END
GO

-- Stored Procedure with INSERT, UPDATE, DELETE Transactions
CREATE PROCEDURE SP_Category
    (@CategoryId INT,
    @CategoryName VARCHAR(30),
    @StatementType VARCHAR(100))
AS
BEGIN
    IF @StatementType = 'SELECT'
    BEGIN
        SELECT * FROM Categories
    END
    ELSE IF @StatementType = 'INSERT'
    BEGIN
        INSERT INTO Categories(CategoryId, CategoryName)
        VALUES(@CategoryId, @CategoryName)
    END
    ELSE IF @StatementType = 'UPDATE'
    BEGIN
        UPDATE Categories
        SET CategoryName = @CategoryName 
        WHERE CategoryId = @CategoryId
    END
    ELSE IF @StatementType = 'DELETE'
    BEGIN
        DELETE FROM Categories
        WHERE CategoryId = @CategoryId
    END
END
GO
