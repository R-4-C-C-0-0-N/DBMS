SET SERVEROUTPUT ON;

CREATE OR REPLACE PACKAGE businessReport AS

	FUNCTION totalSales
	RETURN NUMBER;

	PROCEDURE mostSoldProducts;

	PROCEDURE topCustomers;
END businessReport;
/

CREATE OR REPLACE PACKAGE BODY businessReport AS

	FUNCTION totalSales
	RETURN NUMBER
	IS
	totSales Orders.customerPaid%TYPE := 0;
	BEGIN
		SELECT SUM(customerPaid) INTO totSales FROM Orders ;
		IF totSales IS NULL THEN
			totSales := 0;
		END IF;
		RETURN totSales;
	END totalSales;

	PROCEDURE mostSoldProducts
	IS
	CURSOR soldProdInfo 
	IS
	SELECT name, developer, type, totalQuantitySold
	FROM Products
	ORDER BY totalQuantitySold DESC;
	prodName Products.name%TYPE;
	prodDev Products.developer%TYPE;
	prodType Products.type%TYPE;
	prodQuant Products.totalQuantitySold%TYPE;
	counter INTEGER;
	BEGIN
		OPEN soldProdInfo;
		FOR counter IN 0..2
			LOOP 
				FETCH soldProdInfo INTO prodName, prodDev, prodType, prodQuant;
				DBMS_OUTPUT.PUT_LINE('PRODUCT NAME: ' || prodName || ' DEVELOPER: ' || prodDev || ' TYPE: ' || prodType || ' TOTAL QUANTITY: ' || prodQuant );
			END LOOP;
		CLOSE soldProdInfo;
	END mostSoldProducts;

	PROCEDURE topCustomers
	IS
	CURSOR custInfo
	IS
	SELECT name, location, contact, totalSpent
	FROM Customers
	ORDER BY totalSpent DESC;
	custId Customers.id%TYPE;
	custName Customers.name%TYPE;
	custLoc Customers.location%TYPE;
	custCont Customers.contact%TYPE;
	custSpent Customers.totalSpent%TYPE;
	counter INTEGER;
	BEGIN
		OPEN custInfo;
		FOR counter IN 0..2
			LOOP
				FETCH custInfo INTO custName, custLoc, custCont, custSpent;
				DBMS_OUTPUT.PUT_LINE('CUSTOMER NAME: ' || custName || ' LOCATION: ' || custLoc || ' CONTACT: ' || custCont || ' TOTAL SPENT: ' || custSpent );
			END LOOP;
		CLOSE custInfo;
	END topCustomers;
END businessReport;
/
SHOW ERRORS;