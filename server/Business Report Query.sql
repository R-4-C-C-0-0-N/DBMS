SET SERVEROUTPUT ON;
SET LINESIZE 200;

DECLARE
	totSales NUMBER;
BEGIN
	totSales := businessReport.totalSales;
	DBMS_OUTPUT.PUT_LINE('Total Sales : ' || totSales);
	businessReport.mostSoldProducts;
	businessReport.topCustomers;
END;
/