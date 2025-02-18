create database pizza;
use pizza;
create table orders
(order_id int primary key,
order_date date not null,
order_time time not null
);

create table order_details
(order_details_id int primary key, 
order_id int not null,
pizza_id text not null,
quantity int not null
);

-- Basic

select *
from order_details;

1. select count(order_id) as total_orders
   from orders;


2. select round(sum((o.quantity*p.price)),2) as revenue
   from order_details as o join
   pizzas as p
   on o.pizza_id=p.pizza_id;

3. select p.name, piz.price
   from pizza_types as p join
   pizzas as piz on
   p.pizza_type_id=piz.pizza_type_id
   order by price desc
   limit 1;


4. select pizzas.size, count(order_details.order_details_id)as order_count
   from pizzas join 
   order_details on
   pizzas.pizza_id=order_details.pizza_id
   group by pizzas.size
   order by order_count desc;


5. select pizza_types.name, sum(order_details.quantity) as quantity
   from pizza_types join pizzas
   on pizza_types.pizza_type_id=pizzas.pizza_type_id join
   order_details on
   pizzas.pizza_id=order_details.pizza_id
   group by pizza_types.name
   order by quantity desc
   limit 5;

-- Intermediate questions 

1. select pt.category, sum(od.quantity) as quantity
   from pizza_types as pt join pizzas as p
   on pt.pizza_type_id=p.pizza_type_id
   join order_details as od
   on od.pizza_id=p.pizza_id
   group by pt.category;

2. select hour(order_time)as hour_of_the_day, count(order_id) as number_of_orders
   from orders
   group by hour_of_the_day;

3. select count(name)as number_of_pizzas, category
   from pizza_types
   group by category;

4. with quantity_sum as(
   select sum(od.quantity)as quantity, o.order_date
   from order_details as od join
   orders as o
   on od.order_id=o.order_id
   group by o.order_date)
  
   select round(avg(quantity),0) as average_orders_per_day
   from quantity_sum;

-- Advanced
1. with revenue_calc as(
   select pt.category, round(sum(p.price*od.quantity),0) as revenue
   from pizzas as p join
   order_details as od
   on p.pizza_id=od.pizza_id
   join pizza_types as pt
   on pt.pizza_type_id=p.pizza_type_id
   group by pt.category),

  revenue_calc2 as(
  select sum(revenue)as revenue,category
  from revenue_calc
  group by category)

select round(revenue_calc2.revenue/ (select sum(revenue) from revenue_calc2)*100,2) as percentage, revenue_calc2.category
from revenue_calc2;

2. with day_rev as(
   select o.order_date, sum(p.price*od.quantity)as revenue
   from pizzas as p join
   order_details as od 
   on p.pizza_id=od.pizza_id join
   orders as o
   on o.order_id=od.order_id
   group by order_date)

select sum(revenue) over(order by order_date)as cummalative_revenue, order_date
from day_rev
group by order_date;

3. with pizza_del as(
   select pt.category, sum(p.price*od.quantity)as revenue,pt.name
   from pizzas as p join 
   order_details as od 
   on p.pizza_id=od.pizza_id join
   pizza_types as pt
   on pt.pizza_type_id=p.pizza_type_id
   group by pt.category,pt.name),
 
pizza_2 as
(select name, category,revenue, rank() over(partition by category order by revenue desc) as rn
from pizza_del)

select *
from pizza_2
where rn<=3;













