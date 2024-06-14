USE AdventureWorks2019

SELECT * FROM Production.Product

-- zad1
BEGIN transaction;
UPDATE Production.Product
SET ListPrice = ListPrice * 1.10
WHERE ProductID = 680;
COMMIT;

SELECT * FROM Production.Product
WHERE ProductID = 680;


-- zad2
BEGIN transaction;
DELETE FROM Production.Product WHERE ProductID = 707;
ROLLBACK;

SELECT * FROM Production.Product WHERE ProductID = 707;


-- zad3
SET IDENTITY_INSERT Production.Product ON;

BEGIN transaction;
INSERT INTO Production.Product(ProductID,Name,ProductNumber,MakeFlag,
FinishedGoodsFlag,Color,SafetyStockLevel,ReorderPoint,StandardCost,ListPrice,
Size,SizeUnitMeasureCode,WeightUnitMeasureCode,Weight,DaysToManufacture,ProductLine,
Class,Style,ProductSubcategoryID,ProductModelID,SellStartDate,SellEndDate,DiscontinuedDate,rowguid,ModifiedDate)
VALUES (194, 'Namiot', 'KG45RJ7', 1, 3, 
'Zielony', 450, 320, '240,00', '299,99', NULL, 
NULL, NULL, 950, 1, NULL, 'G', NULL, NULL, 
NULL, '2024-05-27', NULL, NULL, NEWID(), '2024-05-27')
COMMIT;

SELECT * FROM Production.Product WHERE ProductID = 194;

-- zad4
BEGIN transaction;
UPDATE Production.Product SET StandardCost = StandardCost *1.10;
IF (SELECT sum(StandardCost) FROM Production.Product) < 5000 
	BEGIN;
	COMMIT;
	END;
ELSE
	BEGIN;
	ROLLBACK;
	END;

-- zad5
BEGIN transaction;

IF EXISTS (SELECT * FROM Production.Product WHERE ProductNumber='KG45RJ7')
	BEGIN
		PRINT 'Ten produkt juz istnieje'
		ROLLBACK;
	END;
	ELSE
	BEGIN
		INSERT INTO Production.Product(ProductID,Name,ProductNumber,MakeFlag,
		FinishedGoodsFlag,Color,SafetyStockLevel,ReorderPoint,StandardCost,ListPrice,
		Size,SizeUnitMeasureCode,WeightUnitMeasureCode,Weight,DaysToManufacture,ProductLine,
		Class,Style,ProductSubcategoryID,ProductModelID,SellStartDate,SellEndDate,DiscontinuedDate,rowguid,ModifiedDate)
		VALUES (194, 'Namiot', 'KG45RJ7', 1, 3, 
		'Zielony', 450, 320, '240,00', '299,99', NULL, 
		NULL, NULL, 950, 1, NULL, 'G', NULL, NULL, 
		NULL, '2024-05-27', NULL, NULL, NEWID(), '2024-05-27')
		COMMIT;
	END;

SELECT * FROM Production.Product;

-- zad6
BEGIN transaction;
 
BEGIN TRY
    IF EXISTS (SELECT * FROM Sales.SalesOrderDetail WHERE OrderQty = 0)
    BEGIN
        ROLLBACK TRANSACTION;
        PRINT 'Wycofano transakcje. Zamowienie z OrderQty równym 0.';
    END
    ELSE
    BEGIN
		UPDATE Sales.SalesOrderDetail
		SET OrderQty = OrderQty + 1
        COMMIT TRANSACTION;
        PRINT 'Zatwierdzono transakcje. OrderQty zaktualizowane.';
	END
END TRY
BEGIN CATCH
    ROLLBACK;
    SELECT ERROR_MESSAGE() AS ErrorMessage;
END CATCH;

SELECT * FROM Sales.SalesOrderDetail ORDER BY OrderQty

-- zad7
BEGIN transaction;

DELETE FROM Production.Product
WHERE StandardCost > (SELECT AVG(StandardCost) FROM Production.Product);
IF @@rowcount > 10
	BEGIN
		PRINT 'Odrzucono transakcje';
		ROLLBACK;
	END;
	ELSE
	BEGIN
		PRINT 'Zatwierdzono transakcje';
		COMMIT;
	END;
	
SELECT * FROM Production.Product;



