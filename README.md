
# SQL-Pizza-Database-Project


## Project Description

This project involves the creation and analysis of a pizza database using SQL. The database consists of four main tables: pizzas, pizza_types, orders, and order_details. Various SQL queries have been written to answer important business questions such as identifying the most selling pizza and categorizing pizzas.

## Table Descriptions

- orders: Contains information about orders placed. 
    - order_id (Primary Key)
    - date
    - time
    
- order_details: Contains details about each item in an order.
    - order_details_id (Primary Key)
    - order_id (Foreign Key referencing orders)
    - pizza_id (Foreign Key referencing pizzas)
    - quantity
- pizzas: Contains information about the pizzas available.
    - pizza_id (Primary Key)
    - pizza_type_id (Foreign Key referencing pizza_types)
    - size
    - price
- pizza_types: Contains information about the different types of pizzas.
    - pizza_type_id (Primary Key)
    - name
    - category
    - ingredients

You can view the Database diagram which represents an Entity-Relationship (ER) diagram for a pizza sales database. 
![E-R.png](https://raw.githubusercontent.com/Deepak2002kumar/SQL-Pizza-Database-Project/main/E-R.png)

The relationships depicted show that:

- Each order can have multiple order details (one-to-many relationship between orders and order_details).
- Each order detail is associated with one specific pizza (many-to-one relationship between order_details and pizzas).
- Each pizza corresponds to one type of pizza (many-to-one relationship between pizzas and pizza_types).

## Queries and Solutions
### --------------- BASIC ----------------------------
### [1] Retrieve the total number of orders placed.
    SELECT COUNT(*) AS "Total oredrs" FROM orders;

### [2] Calculate the total revenue generated from pizza sales.
    SELECT ROUND(SUM(order_details.quantity * pizzas.price),2) 
    FROM order_details 
    JOIN pizzas 
    ON order_details.pizza_id = pizzas.pizza_id

### [3] Identify the highest-priced pizza.
    SELECT TOP(1) Pizza_types.name,pizzas.price 
    FROM pizza_types 
    JOIN pizzas 
    ON pizza_types.pizza_type_id = pizzas.pizza_type_id 
    ORDER BY pizzas.price DESC;

### [4] Identify the most common pizza size ordered.
    SELECT TOP(1) Pizzas.size, COUNT(order_details.order_details_id) AS "Total orders"
    FROM pizzas 
    JOIN order_details 
    ON pizzas.pizza_id = order_details.pizza_id 
    GROUP BY pizzas.size 
    ORDER BY COUNT(order_details.order_details_id) DESC;

### [5] List the top 5 most ordered pizza types along with their quantities.
    SELECT TOP(5) pizza_types.name, SUM(order_details.quantity) AS "Quantity"
    FROM pizza_types 
    JOIN pizzas 
    ON pizza_types.pizza_type_id = pizzas.pizza_type_id
    JOIN order_details 
    ON pizzas.pizza_id = order_details.pizza_id 
    GROUP BY pizza_types.name 
    ORDER BY SUM(order_details.quantity) DESC;

### --------------- INTERMEDIATE ----------------------------
### [1] Join the necessary tables to find the total quantity of each pizza category ordered.
    SELECT pizza_types.category, SUM(order_details.quantity)AS "Quantity orderd"
    FROM pizza_types
    JOIN pizzas 
    ON pizza_types.pizza_type_id = pizzas.pizza_type_id 
    JOIN order_details 
    ON pizzas.pizza_id = order_details.pizza_id 
    GROUP BY pizza_types.category
    ORDER BY SUM(order_details.quantity) DESC;
### [2] Determine the distribution of orders by hour of the day.
    SELECT DATEPART(HOUR,time) AS "Hours",COUNT(order_id) AS "Orders" 
    FROM orders
    GROUP BY DATEPART(HOUR,time)
    ORDER BY DATEPART(HOUR,time); 

### [3] Join relevant tables to find the category-wise distribution of pizzas.
    SELECT category, COUNT(name) FROM pizza_types 
    GROUP BY category;
### [4] Group the orders by date and calculate the average number of pizzas ordered per day.
    SELECT ROUND(AVG(Pizzas_orderd),0) AS Average_orders_per_day
    FROM 
    (SELECT orders.date, SUM(order_details.quantity) AS "Pizzas_orderd" 
    FROM orders 
    JOIN order_details 
    ON orders.order_id = order_details.order_id 
    GROUP BY orders.date) AS Daily_pizzas_ordered;
### [5] Determine the top 3 most ordered pizza types based on revenue.
    SELECT TOP(3) pizza_types.name, SUM(order_details.quantity * pizzas.price) AS "Revenue"
    FROM pizza_types 
    JOIN pizzas 
    ON pizza_types.pizza_type_id = pizzas.pizza_type_id 
    JOIN order_details 
    ON pizzas.pizza_id = order_details.pizza_id 
    GROUP BY pizza_types.name
    ORDER BY "Revenue" DESC;

### --------------- ADVANCED ----------------------------
### [1] Calculate the percentage contribution of each pizza category to total revenue.
    SELECT pizza_types.category, 
	ROUND(((SUM(order_details.quantity * pizzas.price) / 
	(SELECT SUM(order_details.quantity * pizzas.price) 
	FROM order_details 
	JOIN pizzas ON order_details.pizza_id = pizzas.pizza_id))*100),2) AS "% Contribution_in_Revenue"
    FROM pizzas 
    JOIN pizza_types 
    ON pizzas.pizza_type_id = pizza_types.pizza_type_id 
    JOIN order_details 
    ON pizzas.pizza_id = order_details.pizza_id
    GROUP BY pizza_types.category
    ORDER BY "% Contribution_in_Revenue" DESC;
### [2]	Determine the top 3 most ordered pizza types based on revenue for each pizza category.
    SELECT category,name,Revenue,DENSE_RANK() 
    OVER(Partition by category ORDER BY Revenue DESC) AS "Ranking"
    FROM
    (SELECT pizza_types.category, pizza_types.name,
    ROUND(SUM(order_details.quantity * pizzas.price),2) AS "Revenue" 
    FROM pizza_types 
    JOIN pizzas 
    ON pizza_types.pizza_type_id = pizzas.pizza_type_id 
    JOIN order_details 
    ON pizzas.pizza_id = order_details.pizza_id 
    GROUP BY pizza_types.category, pizza_types.name) AS sub_query;

## Installation
To set up the database and run the queries, follow these steps:

-   Download the file from [here](https://github.com/Deepak2002kumar/SQL-Pizza-Database-Project/blob/main/Pizza_hub.sql)
- Import the SQL script to create tables and insert initial data:



## Conclusion
This project demonstrates the use of SQL for database creation, management, and analysis. It highlights key skills in writing complex SQL queries to derive meaningful insights from the data.

    
