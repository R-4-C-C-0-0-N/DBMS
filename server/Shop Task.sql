SET SERVEROUTPUT ON;

CREATE OR REPLACE PACKAGE shopTask AS

	FUNCTION underStockedProducts
	RETURN NUMBER;

	PROCEDURE restockProducts(AMNT IN INTEGER, UPDTD OUT INTEGER);

	PROCEDURE restockIndividualProduct(PID IN INTEGER, AMNT IN INTEGER);

	PROCEDURE updateShipmentStatus(OID IN INTEGER);

	PROCEDURE delOrder(OID IN INTEGER);
END shopTask;
/

CREATE OR REPLACE PACKAGE BODY shopTask AS

	FUNCTION understockedProducts
	RETURN NUMBER
	IS
	CURSOR prodInfo
	IS
	SELECT id, name, developer, quantityInStock
	FROM Products
	WHERE quantityInStock < 10;
	prodId Products.id%TYPE;
	prodName Products.name%TYPE;
	prodDev Products.developer%TYPE;
	prodQuant Products.quantityInStock%TYPE;
	numOfProd NUMBER := 0;
	BEGIN
		OPEN prodInfo;
		LOOP
			FETCH prodInfo INTO prodId, prodName, prodDev, prodQuant;
				EXIT WHEN prodInfo%NOTFOUND;
			DBMS_OUTPUT.PUT_LINE('PRODUCT ID: ' || prodId || '	NAME: ' || prodName || '	DEVELOPER: ' || prodDev || '	QUANTITY IN STOCK: ' || prodQuant);
			numOfProd := numOfProd + 1;
		END LOOP;
		CLOSE prodInfo;
		IF numOfProd = 0 THEN
			DBMS_OUTPUT.PUT_LINE('No Understocked Products found');
		END IF;
		RETURN numOfProd;
	END underStockedProducts;

	PROCEDURE restockProducts(AMNT IN INTEGER, UPDTD OUT INTEGER)
	IS
	CURSOR prodInfo
	IS
	SELECT id, quantityInStock
	FROM Products;
	prodId Products.id%TYPE;
	crntQuant Products.quantityInStock%TYPE;
	updQuant Products.quantityInStock%TYPE;
	BEGIN
		UPDTD := 0;
		OPEN prodInfo;
		LOOP
			FETCH prodInfo INTO prodId, crntQuant;
				EXIT WHEN prodInfo%NOTFOUND;
			updQuant := crntQuant + AMNT;
			UPDATE Products
				SET quantityInStock = updQuant
			WHERE id = prodId;
			UPDTD := UPDTD + 1;
		END LOOP;
	END restockProducts;
	
	PROCEDURE restockIndividualProduct(PID IN INTEGER, AMNT IN INTEGER)
	IS
	crntQuant Products.quantityInStock%TYPE;
	updQuant Products.quantityInStock%TYPE;
	BEGIN
		SELECT quantityInStock INTO crntQuant
		FROM Products
		WHERE id = PID;
		updQuant := crntQuant + AMNT;
		UPDATE Products
			SET quantityInStock = updQuant
		WHERE id = PID;
	END restockIndividualProduct;

	PROCEDURE updateShipmentStatus(OID IN INTEGER)
	IS
	BEGIN
		UPDATE OrderDetails
			SET shipmentStatus = 'SHIPPED'
		WHERE id = OID;
	END updateShipmentStatus;

	PROCEDURE delOrder(OID IN INTEGER)
	IS
	BEGIN
		DELETE FROM Orders WHERE id = OID;
	END delOrder;
END shopTask;
/
SHOW ERRORS;