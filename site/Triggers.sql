CREATE OR REPLACE TRIGGER processingOnOrder
BEFORE INSERT
ON Orders
FOR EACH ROW
DECLARE
	prodQuant Products.quantityInStock%TYPE;
	totalOrderPrice Orders.totalPrice%TYPE;
	pricePerPiece Products.price%TYPE;
	actualPayment Orders.customerPaid%TYPE;
	currSpent Customers.totalSpent%TYPE;
	totSold Products.totalQuantitySold%TYPE;
BEGIN
	SELECT quantityInStock INTO prodQuant FROM Products WHERE id = :NEW.pid;
	IF prodQuant = 0 OR :NEW.quantity > prodQuant THEN
		RAISE_APPLICATION_ERROR(-20001, 'QUANTITY NOT AVAILABLE');
	END IF;
	SELECT price INTO pricePerPiece FROM Products WHERE id = :NEW.pid;
	totalOrderPrice := :NEW.quantity * pricePerPiece;
	:NEW.totalPrice := totalOrderPrice;
	DBMS_OUTPUT.PUT_LINE('TOTAL PRICE OF ORDER: ' || totalOrderPrice);
	actualPayment := totalOrderPrice;
	:NEW.customerPaid := actualPayment;
	SELECT totalSpent INTO currSpent FROM Customers WHERE id = :NEW.cid;
	currSpent := currSpent + actualPayment;
	UPDATE customers SET totalSpent = currSpent WHERE id = :NEW.cid;
	prodQuant := prodQuant - :NEW.QUANTITY;
	UPDATE products SET quantityInStock = prodQuant WHERE id = :NEW.pid;
	UPDATE products@server SET quantityInStock = prodQuant WHERE id = :NEW.pid;
	DBMS_OUTPUT.PUT_LINE('CURRENT PRODUCT QUANTITY ' || prodQuant);
	SELECT totalQuantitySold INTO totSold FROM products WHERE id = :NEW.pid;
	totSold := totSold + :NEW.QUANTITY;
	UPDATE products SET totalQuantitySold = totSold WHERE id = :NEW.pid;
	UPDATE products@server SET totalQuantitySold = totSold WHERE id = :NEW.pid;
	DBMS_OUTPUT.PUT_LINE('TOTAL QUANTITY SOLD : ' || totSold);
	DBMS_OUTPUT.PUT_LINE('ORDER CREATED !!');
END;
/
SHOW ERRORS;

CREATE OR REPLACE TRIGGER fillOrderDetails
AFTER
INSERT
ON Orders
FOR EACH ROW
BEGIN
	INSERT INTO OrderDetails(id, orderDate, shipmentDate, shipmentStatus)
	VALUES(:NEW.id, TO_DATE(TO_CHAR(SYSDATE, 'dd/mm/yyyy'),'dd/mm/yyyy'), TO_DATE(TO_CHAR(SYSDATE + 3, 'dd/mm/yyyy'),'dd/mm/yyyy'), 'Processing');
	DBMS_OUTPUT.PUT_LINE('ORDER DETAILS FILLED');
END;
/
SHOW ERRORS;

CREATE OR REPLACE TRIGGER processingAfterOrderDelete
BEFORE
DELETE
ON Orders
FOR EACH ROW
DECLARE
	prodQuant Products.quantityInStock%TYPE;
	currSpent Customers.totalSpent%TYPE;
	totSold Products.totalQuantitySold%TYPE;
BEGIN
	DELETE FROM orderDetails WHERE id = :OLD.id;
	SELECT quantityInStock INTO prodQuant FROM Products WHERE id = :OLD.pid;
	prodQuant := prodQuant + :OLD.quantity;
	UPDATE products SET quantityInStock = prodQuant WHERE id = :OLD.id;
	UPDATE products@server SET quantityInStock = prodQuant WHERE id = :OLD.id;
	DBMS_OUTPUT.PUT_LINE('CURRENT PRODUCT QUANTITY ' || prodQuant);
	SELECT totalSpent INTO currSpent FROM customers WHERE id = :OLD.cid;
	currSpent := currSpent - :OLD.customerPaid;
	UPDATE customers SET totalSpent = currSpent WHERE id = :OLD.cid;
	DBMS_OUTPUT.PUT_LINE('CUSTOMER TOTAL SPENT ' || currSpent);
	SELECT totalQuantitySold INTO totSold FROM products WHERE id = :OLD.pid;
	totSold := totSold - :OLD.quantity;
	UPDATE products SET totalQuantitySold = totSold WHERE id = :OLD.pid;
	UPDATE products@server SET totalQuantitySold = totSold WHERE id = :OLD.pid;
	DBMS_OUTPUT.PUT_LINE('TOTAL QUANTITY SOLD : ' || totSold);
	DBMS_OUTPUT.PUT_LINE('ORDER DELETED !!');
END;
/
SHOW ERRORS;