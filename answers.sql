# Question 1: Normalize the ProductDetail table
# This query extracts individual products from a comma-separated list in the Products column.
# JSON_TABLE is used to split the Products column into rows, creating a normalized structure.
SELECT 
    OrderID, -- The unique identifier for each order
    CustomerName, -- The name of the customer who placed the order
    TRIM(product) AS Product -- Removes any leading or trailing spaces from the product name
FROM (
    SELECT 
        OrderID, -- The unique identifier for each order
        CustomerName, -- The name of the customer who placed the order
        JSON_TABLE(
            CONCAT('["', REPLACE(Products, ', ', '","'), '"]'), -- Converts the comma-separated list into a JSON array
            '$[*]' COLUMNS(product VARCHAR(100) PATH '$') -- Extracts each product from the JSON array
        ) AS jt
    FROM ProductDetail -- Source table containing order and product details
) AS normalized; -- Alias for the normalized result set

# Question 2: Eliminate partial and transitive dependencies
# Step 1: Create the Orders table to eliminate partial dependency
# This query selects distinct OrderID and CustomerName pairs to create the Orders table.
SELECT DISTINCT OrderID, CustomerName
FROM OrderDetails;

# Step 2: Create the OrderItems table to eliminate transitive dependency
# This query selects OrderID, Product, and Quantity to create the OrderItems table.
SELECT OrderID, Product, Quantity
FROM OrderDetails;

# Create the Orders table
# This table stores unique orders with their corresponding customers.
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY, -- Primary key to uniquely identify each order
    CustomerName VARCHAR(100) -- Name of the customer who placed the order
);

# Create the OrderItems table
# This table stores the products and their quantities for each order.
CREATE TABLE OrderItems (
    OrderID INT, -- Foreign key referencing the Orders table
    Product VARCHAR(100), -- Name of the product
    Quantity INT, -- Quantity of the product in the order
    PRIMARY KEY (OrderID, Product), -- Composite primary key to ensure uniqueness of each product in an order
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID) -- Foreign key constraint to maintain referential integrity
);
