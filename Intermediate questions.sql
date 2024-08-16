create database pizzahutorder_details;

-- Join the necessary tables to find the total quantity of each pizza category ordered.
select pizza_types.category, sum(order_details.quantity) as quantity from pizza_types join pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id join order_details 
on order_details.pizza_id = pizzas.pizza_id group by pizza_types.category order by quantity asc;

-- Determine the distribution of orders by hour of the day 
select hour(time), count(order_id) as order_count from orders group by hour(time) order by hour(time) asc;

-- Find the category-wise distribution of pizzas.
select category, count(name) from pizza_types group by category;

-- Group the orders by date and calculate the average number of pizzas ordered per day.
select avg(quantity) from 
(select orders.date, sum(quantity) as quantity from orders join order_details on orders.order_id = order_details.order_id group by orders.date ) as order_quantity; 

-- Determine the top 3 most ordered pizza types based on revenue.
select pizza_types.name, round(sum(order_details.quantity * pizzas.price)) as revenue from pizza_types join pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id 
join order_details on order_details.pizza_id = pizzas.pizza_id group by pizza_types.name order by revenue desc limit 3