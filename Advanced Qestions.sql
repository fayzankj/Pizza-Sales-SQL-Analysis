-- Calculate the percentage contribution of each pizza type to total revenue.
WITH category_revenue AS (
    SELECT 
        pizza_types.category, 
        ROUND(SUM(order_details.quantity * pizzas.price)) AS revenue
    FROM 
        pizza_types
    JOIN 
        pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id 
    JOIN 
        order_details ON order_details.pizza_id = pizzas.pizza_id 
    GROUP BY 
        pizza_types.category
)
SELECT 
    category,
    revenue,
    ROUND((revenue / total_revenue) * 100, 2) AS percentage_contribution
FROM 
    category_revenue,
    (SELECT SUM(revenue) AS total_revenue FROM category_revenue) AS total
ORDER BY 
    revenue DESC;
    
    
-- Analyze the cumulative revenue generated over time.
select date,revenue,sum(revenue) over (order by date) as Cum_Revenue
from
(select orders.date, round(SUM(order_details.quantity * pizzas.price)) AS revenue  
from order_details join pizzas on order_details.pizza_id = pizzas.pizza_id
join orders on orders.order_id = order_details.order_id group by  orders.date) as sales;


-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.
select category,name,revenue
from
(select category,name,revenue , rank() over (partition by category order by revenue desc ) as rn 
from
(select pizza_types.category, pizza_types.name, round(SUM(order_details.quantity * pizzas.price)) AS revenue  
from order_details join pizzas on order_details.pizza_id = pizzas.pizza_id
join pizza_types on pizza_types.pizza_type_id = pizzas.pizza_type_id group by pizza_types.category, pizza_types.name) as a) as b
where rn <= 3