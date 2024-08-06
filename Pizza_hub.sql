-- BASIC --

-- Q1) Retrieve the total number of orders placed ??
SELECT COUNT(*) AS "Total oredrs" FROM orders;

-- Q2) Calculate the total revenue generated from pizza sales. ??
SELECT ROUND(SUM(order_details.quantity*pizzas.price),2) 
FROM order_details 
JOIN pizzas 
ON order_details.pizza_id = pizzas.pizza_id

-- Q3) Identify the highest-priced pizza ??
SELECT TOP(1) Pizza_types.name,pizzas.price 
FROM pizza_types 
JOIN pizzas 
ON pizza_types.pizza_type_id = pizzas.pizza_type_id 
ORDER BY pizzas.price DESC;

-- Q4) Identify the most common pizza size ordered ??
SELECT TOP(1) Pizzas.size, COUNT(order_details.order_details_id) AS "Total orders"
FROM pizzas 
JOIN order_details 
ON pizzas.pizza_id = order_details.pizza_id 
GROUP BY pizzas.size 
ORDER BY COUNT(order_details.order_details_id) DESC;

-- Q5) List the top 5 most ordered pizza types along with their quantities ??
SELECT TOP(5) pizza_types.name, SUM(order_details.quantity) AS "Quantity"
FROM pizza_types 
JOIN pizzas 
ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN order_details 
ON pizzas.pizza_id = order_details.pizza_id 
GROUP BY pizza_types.name 
ORDER BY SUM(order_details.quantity) DESC;

-- INTERMEDIATE --

-- Q1) Join the necessary tables to find the total quantity of each pizza category ordered ??
SELECT pizza_types.category, SUM(order_details.quantity)AS "Quantity orderd"
FROM pizza_types
JOIN pizzas 
ON pizza_types.pizza_type_id = pizzas.pizza_type_id 
JOIN order_details 
ON pizzas.pizza_id = order_details.pizza_id 
GROUP BY pizza_types.category
ORDER BY SUM(order_details.quantity) DESC;

-- Q2) Determine the distribution of orders by hour of the day ??
SELECT DATEPART(HOUR,time) AS "Hours",COUNT(order_id) AS "Orders" 
FROM orders
GROUP BY DATEPART(HOUR,time)
ORDER BY DATEPART(HOUR,time); 

-- Q3) Join relevant tables to find the category-wise distribution of pizzas ??
SELECT category, COUNT(name) FROM pizza_types 
GROUP BY category;

-- Q4) Group the orders by date and calculate the average number of pizzas ordered per day.
SELECT ROUND(AVG(Pizzas_orderd),0) AS Average_orders_per_day
FROM 
(SELECT orders.date, SUM(order_details.quantity) AS "Pizzas_orderd" 
FROM orders 
JOIN order_details 
ON orders.order_id = order_details.order_id 
GROUP BY orders.date) AS Daily_pizzas_ordered;

--Q5) Determine the top 3 most ordered pizza types based on revenue ??
SELECT TOP(3) pizza_types.name, SUM(order_details.quantity * pizzas.price) AS "Revenue"
FROM pizza_types 
JOIN pizzas 
ON pizza_types.pizza_type_id = pizzas.pizza_type_id 
JOIN order_details 
ON pizzas.pizza_id = order_details.pizza_id 
GROUP BY pizza_types.name
ORDER BY "Revenue" DESC;

-- ADVANCED --

-- Q1) Calculate the percentage contribution of each pizza category to total revenue ??
SELECT pizza_types.category, 
	ROUND(((SUM(order_details.quantity*pizzas.price) / 
	(SELECT SUM(order_details.quantity*pizzas.price) 
	FROM order_details 
	JOIN pizzas ON order_details.pizza_id = pizzas.pizza_id))*100),2) AS "% Contribution_in_Revenue"
FROM pizzas 
JOIN pizza_types 
ON pizzas.pizza_type_id = pizza_types.pizza_type_id 
JOIN order_details 
ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizza_types.category
ORDER BY "% Contribution_in_Revenue" DESC;

-- Q2) Determine the top 3 most ordered pizza types based on revenue for each pizza category.??
SELECT category,name,Revenue,DENSE_RANK() 
OVER(Partition by category ORDER BY Revenue DESC) AS "Ranking"
FROM
(SELECT pizza_types.category, pizza_types.name,
ROUND(SUM(order_details.quantity*pizzas.price),2) AS "Revenue" 
FROM pizza_types 
JOIN pizzas 
ON pizza_types.pizza_type_id = pizzas.pizza_type_id 
JOIN order_details 
ON pizzas.pizza_id = order_details.pizza_id 
GROUP BY pizza_types.category, pizza_types.name) AS sub_query;





SELECT * FROM orders;
SELECT * FROM order_details;
SELECT * FROM pizzas;
SELECT * FROM pizza_types;


