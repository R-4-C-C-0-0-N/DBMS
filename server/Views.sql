DROP VIEW areaAvgSale;
DROP VIEW orderStatus;

CREATE VIEW areaAvgSale AS
	SELECT AVG(totalSpent) AS AVERAGE_SALE, Location, COUNT(Location) AS NUMBER_OF_CUSTOMERS FROM Customers GROUP BY Location;

CREATE VIEW orderStatus AS
	SELECT O.id AS OID, C.name AS CUSTOMER_NAME, P.name AS PRODUCT_NAME, O.quantity AS QUANTITY, O.totalPrice AS TOTAL_PRICE, 
		OD.shipmentDate AS ESTIMATED, OD.shipmentStatus AS SHIPMENT_STATUS
	FROM OrderDetails OD
	JOIN Orders O ON OD.id = O.id
	JOIN Customers C ON O.cid = C.id
	JOIN Products P ON O.pid = P.id; 