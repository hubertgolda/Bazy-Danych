-- zad1:

USE AdventureWorks2019;
SELECT * FROM AdventureWorks2022.Person.Person
SELECT * FROM AdventureWorks2022.HumanResources.EmployeePayHistory

WITH query1 AS
(
	SELECT p.BusinessEntityID, p.FirstName, p.MiddleName, p.LastName, r.Rate
	FROM AdventureWorks2019.Person.Person p
	JOIN AdventureWorks2019.HumanResources.EmployeePayHistory r
	ON p.BusinessEntityID = r.BusinessEntityID
)
SELECT * INTO TempEmployeeInfo
FROM query1;

SELECT * FROM TempEmployeeInfo;

-- zad2:

SELECT *FROM AdventureWorksLT2019.SalesLT.SalesOrderHeader;
SELECT *FROM AdventureWorksLT2019.SalesLT.Customer;

WITH query2(CompanyContact, Revenue) AS 
(
	SELECT CONCAT( CompanyName, ' (', FirstName, ' ', LastName, ')' ), TotalDue
	FROM SalesLT.Customer c
	INNER JOIN SalesLT.SalesOrderHeader s
	ON c.CustomerID=s.CustomerID
)

SELECT * FROM query2
ORDER BY CompanyContact

-- zad3:

SELECT * FROM AdventureWorksLT2019.SalesLT.ProductCategory;
SELECT * FROM AdventureWorksLT2019.SalesLT.SalesOrderDetail;
SELECT * FROM AdventureWorksLT2019.SalesLT.Product;

WITH query3(Category,SalesValue) AS
(
	SELECT pc.Name, SUM(s.UnitPrice*s.OrderQty) AS SalesValue
	FROM AdventureWorksLT2019.SalesLT.ProductCategory pc
	JOIN AdventureWorksLT2019.SalesLT.Product p
	ON pc.ProductCategoryID = p.ProductCategoryID
	JOIN AdventureWorksLT2019.SalesLT.SalesOrderDetail s
	ON p.ProductID = s.ProductID	
	GROUP BY pc.Name
)
SELECT * FROM query3

