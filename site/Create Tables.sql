DROP TABLE OrderDetails;
DROP TABLE Orders;
DROP TABLE Customers;
DROP TABLE Products;

CREATE TABLE Customers
(
	id INTEGER,
	name VARCHAR(30) NOT NULL,
	location VARCHAR(30) NOT NULL,
	contact NUMBER(11) NOT NULL UNIQUE,
	totalSpent NUMBER(8,2) DEFAULT 0,
	PRIMARY KEY(id)
);

CREATE TABLE Products
(
	id INTEGER,
	name VARCHAR(30) NOT NULL,
	developer VARCHAR(30) NOT NULL,
	type VARCHAR(20) NOT NULL,
	platform VARCHAR(20) NOT NULL,
	price NUMBER(8,2) NOT NULL CHECK(price >= 0),
	quantityInStock INTEGER CHECK(quantityInStock >= 0),
	totalQuantitySold INTEGER DEFAULT 0,
	PRIMARY KEY(id)
);

CREATE TABLE Orders
(
	id INTEGER,
	cid INTEGER NOT NULL,
	pid INTEGER NOT NULL,
	quantity INTEGER CHECK(quantity > 0),
	totalPrice NUMBER(8,2) CHECK(totalPrice > 0),
	customerPaid NUMBER(8,2),
	PRIMARY KEY(id),
	FOREIGN KEY(cid) REFERENCES customers(id),
	FOREIGN key(pid) REFERENCES products(id)
);

CREATE TABLE OrderDetails
(
	id INTEGER,
	orderDate DATE NOT NULL,
	shipmentDate DATE NOT NULL,
	shipmentStatus varchar(20) DEFAULT 'PROCESSING',
	PRIMARY KEY(id),
	FOREIGN KEY(id) REFERENCES orders(id)
);

COMMIT;