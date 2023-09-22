-- Drop existing views and tables if needed
DROP VIEW IF EXISTS product_sales_for_2016;
DROP VIEW IF EXISTS products_above_average_price;

-- Drop tables in reverse order to avoid foreign key constraints
DROP TABLE IF EXISTS Deliver_To;
DROP TABLE IF EXISTS Contain;
DROP TABLE IF EXISTS Payment;
DROP TABLE IF EXISTS Manage;
DROP TABLE IF EXISTS Save_to_Shopping_Cart;
DROP TABLE IF EXISTS After_Sales_Service_At;
DROP TABLE IF EXISTS Address;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS OrderItem;
DROP TABLE IF EXISTS CreditCard;
DROP TABLE IF EXISTS DebitCard;
DROP TABLE IF EXISTS BankCard;
DROP TABLE IF EXISTS Seller;
DROP TABLE IF EXISTS Comments;
DROP TABLE IF EXISTS Buyer;
DROP TABLE IF EXISTS Users;
DROP TABLE IF EXISTS Product;
DROP TABLE IF EXISTS Store;
DROP TABLE IF EXISTS ServicePoint;
DROP TABLE IF EXISTS Brand;


-- Create Entities

-- Users table stores user information
CREATE TABLE Users
(
    userid INT NOT NULL,
    name VARCHAR(20),
    phoneNumber VARCHAR(20),
    PRIMARY KEY(userid)
);

-- Buyer table with a foreign key reference to Users
CREATE TABLE Buyer
(
    userid INT NOT NULL,
    PRIMARY KEY(userid),
    FOREIGN KEY(userid) REFERENCES Users(userid)
);

-- Seller table with a foreign key reference to Users
CREATE TABLE Seller
(
    userid INT NOT NULL,
    PRIMARY KEY(userid),
    FOREIGN KEY(userid) REFERENCES Users(userid)
);

-- BankCard table stores bank card information
CREATE TABLE BankCard
(
    cardNumber VARCHAR(25) NOT NULL,
    expiryDate DATE,
    bank VARCHAR(20),
    PRIMARY KEY(cardNumber)
);

-- CreditCard table with foreign key references to BankCard and Users
CREATE TABLE CreditCard
(
    cardNumber VARCHAR(25) NOT NULL,
    userid INT NOT NULL,
    organization VARCHAR(20),
    PRIMARY KEY(cardNumber),
    FOREIGN KEY(cardNumber) REFERENCES BankCard(cardNumber),
    FOREIGN KEY(userid) REFERENCES Users(userid)
);

-- DebitCard table with foreign key references to BankCard and Users
CREATE TABLE DebitCard
(
    cardNumber VARCHAR(25) NOT NULL,
    userid INT NOT NULL,
    PRIMARY KEY(cardNumber),
    FOREIGN KEY(cardNumber) REFERENCES BankCard(cardNumber),
    FOREIGN KEY(userid) REFERENCES Users(userid)
);

-- Address table stores user addresses
CREATE TABLE Address
(
    addrid INT NOT NULL,
    userid INT NOT NULL,
    name VARCHAR(50),
    contactPhoneNumber VARCHAR(20),
    province VARCHAR(100),
    city VARCHAR(100),
    streetaddr VARCHAR(100),
    postCode VARCHAR(12),
    PRIMARY KEY(addrid),
    FOREIGN KEY(userid) REFERENCES Users(userid)
);

-- Store table stores store information
CREATE TABLE Store
(
    sid INT NOT NULL,
    name VARCHAR(20),
    province VARCHAR(20),
    city VARCHAR(20),
    streetaddr VARCHAR(20),
    customerGrade INT,
    startTime DATE,
    PRIMARY KEY(sid)
);

-- Brand table stores brand information
CREATE TABLE Brand
(
    brandName VARCHAR(20) NOT NULL,
    PRIMARY KEY (brandName)
);

-- Product table stores product information with foreign key references to Store and Brand
CREATE TABLE Product
(
    pid INT NOT NULL,
    sid INT NOT NULL,
    brand VARCHAR(50) NOT NULL,
    name VARCHAR(100),
    type VARCHAR(50),
    modelNumber VARCHAR(50),
    color VARCHAR(50),
    amount INT,
    price INT,
    PRIMARY KEY(pid),
    FOREIGN KEY(sid) REFERENCES Store(sid),
    FOREIGN KEY(brand) REFERENCES Brand(brandName)
);

-- OrderItem table stores order item information with a foreign key reference to Product
CREATE TABLE OrderItem
(
    itemid INT NOT NULL,
    pid INT NOT NULL,
    price INT,
    creationTime DATE,
    PRIMARY KEY(itemid),
    FOREIGN KEY(pid) REFERENCES Product(pid)
);

-- Orders table stores order information
CREATE TABLE Orders
(
    orderNumber INT NOT NULL,
    paymentState VARCHAR(12),
    creationTime DATE,
    totalAmount INT,
    PRIMARY KEY (orderNumber)
);

-- Comments table stores product reviews with foreign key references to Buyer and Product
CREATE TABLE Comments
(
    creationTime DATE NOT NULL,
    userid INT NOT NULL,
    pid INT NOT NULL,
    grade FLOAT,
    content VARCHAR(500),
    PRIMARY KEY(creationTime, userid, pid),
    FOREIGN KEY(userid) REFERENCES Buyer(userid),
    FOREIGN KEY(pid) REFERENCES Product(pid)
);

-- ServicePoint table stores service point information
CREATE TABLE ServicePoint
(
    spid INT NOT NULL,
    streetaddr VARCHAR(40),
    city VARCHAR(30),
    province VARCHAR(20),
    startTime VARCHAR(20),
    endTime VARCHAR(20),
    PRIMARY KEY(spid)
);


-- Relationships

-- Save_to_Shopping_Cart table stores items added to the shopping cart
CREATE TABLE Save_to_Shopping_Cart
(
    userid INT NOT NULL,
    pid INT NOT NULL,
    addTime DATE,
    quantity INT,
    PRIMARY KEY (userid, pid),
    FOREIGN KEY(userid) REFERENCES Buyer(userid),
    FOREIGN KEY(pid) REFERENCES Product(pid)
);

-- Contain table stores order items within orders
CREATE TABLE Contain
(
    orderNumber INT NOT NULL,
    itemid INT NOT NULL,
    quantity INT,
    PRIMARY KEY (orderNumber, itemid),
    FOREIGN KEY(orderNumber) REFERENCES Orders(orderNumber),
    FOREIGN KEY(itemid) REFERENCES OrderItem(itemid)
);

-- Payment table stores payment information with foreign key references to Orders and CreditCard
CREATE TABLE Payment
(
    orderNumber INT NOT NULL,
    creditcardNumber VARCHAR(25) NOT NULL,
    payTime DATE,
    PRIMARY KEY(orderNumber, creditcardNumber),
    FOREIGN KEY(orderNumber) REFERENCES Orders(orderNumber),
    FOREIGN KEY(creditcardNumber) REFERENCES CreditCard(cardNumber)
);

-- Deliver_To table stores order delivery information
CREATE TABLE Deliver_To
(
    addrid INT NOT NULL,
    orderNumber INT NOT NULL,
    TimeDelivered DATE,
    PRIMARY KEY(addrid, orderNumber),
    FOREIGN KEY(addrid) REFERENCES Address(addrid),
    FOREIGN KEY(orderNumber) REFERENCES Orders(orderNumber)
);

-- Manage table stores the relationship between sellers and stores
CREATE TABLE Manage
(
    userid INT NOT NULL,
    sid INT NOT NULL,
    SetUpTime DATE,
    PRIMARY KEY(userid, sid),
    FOREIGN KEY(userid) REFERENCES Seller(userid),
    FOREIGN KEY(sid) REFERENCES Store(sid)
);

-- After_Sales_Service_At table stores relationships between brands and service points
CREATE TABLE After_Sales_Service_At
(
    brandName VARCHAR(20) NOT NULL,
    spid INT NOT NULL,
    PRIMARY KEY(brandName, spid),
    FOREIGN KEY(brandName) REFERENCES Brand(brandName),
    FOREIGN KEY(spid) REFERENCES ServicePoint(spid)
);
