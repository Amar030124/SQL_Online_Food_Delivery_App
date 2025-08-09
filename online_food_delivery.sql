-- CREATE DATABASE ONLINE FOOD DEVLVERY

-- DAY 1

create database online_food_delivery;
use online_food_delivery ;

-- CREATE CUSTOMER TABLE IN THESE DATABASE 

create table customers
( customer_id int primary key,
customer_name varchar(30) not null,
email varchar(30) not null,
city varchar(10) not null ,
signup_date date 
);

-- CREATE RESTURANTS TABLE IN THESE DATABASE 

create table resturants
( resturant_id int primary key,
resturant_name varchar(30) not null ,
city varchar(20) not null,
registration_date date 
);

-- CREATE MENU ITEM TABLE IN THESE DATABASE 

create table menu_item
( item_id int primary key,
resturant_id int ,
item_menu varchar(30), 
price decimal(10,2),
constraint fk_menu_rest
foreign key (resturant_id)
references resturants(resturant_id)
);

-- CREATE ORDER TABLE IN THE DATABASE 

create table orders
(orders_id int primary key,
customer_id int ,
resturant_id int,
order_date date,
 CONSTRAINT fk_orders_customer
foreign key (customer_id)
references customers(customer_id),
 CONSTRAINT fk_orders_resturant
 foreign key (resturant_id)
 references resturants(resturant_id)
);

-- CREATE ORDER DETAILS TABLE IN THE DATABASE 

create table order_details
(order_detail_id int primary key,
orders_id int ,
item_id int,
quantity int, 
constraint fk_order_details_orders
foreign key (orders_id)
references orders(orders_id),
constraint fk_order_details_menu_item
foreign key (item_id)
references menu_item(item_id)
);

	-- Day 2 
    
-- 1. find name and price for all food items costing more than 300/-

select item_menu , price 
from menu_item
where price>300;

-- 2. list the top 5 cheapest food items

select item_menu , price 
from menu_item
order by  price asc
limit  5 ; 

-- 3. list all the resturant located in delhi

select resturant_name , city
from resturants
where city = 'delhi'; 


-- 4. show top three most expensive menu items

select item_menu, price
from menu_item
order by price desc
limit 3; 

-- 5. list order IDs where quanity is greater than 2

select orders_id, quantity
from order_details
where quantity >2;
 
 
 -- DAY 3 
 
 -- 1 . show all orders along with the resturant name from they which placed
 
 select o.orders_id , r.resturant_name
 from orders o join resturants r
 on o.resturant_id = r.resturant_id ; 
 
 -- 2. show customers names and orders dates for orders placed in january 2023
 
SELECT c.customer_name, o.order_date, o.orders_id
from 
customers c join orders o
on
c.customer_id = o.customer_id
 where o.order_date between '2023-01-01' AND '2023-01-31'; 
 
 
 /*  3. List all Customers along with their city 
 who placed an order on or after  ‘2023-01-01’ …? */
 
 select c.customer_name, c.city , o.order_date
 from customers c join orders o
 on c.customer_id  = o.orders_id
 where o.order_date >= '2023-01-01';
 
 /*  4. show resturants name and order ids 
 for order placed from resturants  mumbai */
 
 select r.resturant_name, r.city , o.orders_id
 from resturants r join orders o
 on r.resturant_id = o.resturant_id
 where  city = 'mumbai';
 
 -- 5 . Customers who have ordered from specific resturants  ( - any name of choice ) 
 
 select c.customer_name , r.resturant_name 
 from customers c join resturants r
 on c.city= r.city
 where resturant_name = 'Big Diner';
 
 -- DAY 4 
 
 -- 1. Count how many order each customer has placed 
 
 select count(o.orders_id) as Total_orders , c.customer_name
 from customers c join orders o
 on c.customer_id = o.customer_id
 group by customer_name ;
 
 -- 2. show total revenue earned from each city
 
SELECT
  SUM(m.price * od.quantity) AS Total_revenue,
  r.city
FROM resturants r
JOIN menu_item m
  ON r.resturant_id = m.resturant_id
JOIN order_details od
  ON od.item_id = m.item_id
JOIN orders o
  ON o.orders_id = od.orders_id
GROUP BY r.city;

-- 3. find the total number of times each food items was ordered

select count(item_menu) as Number_food_items, item_menu
from menu_item
group by item_menu ;


-- 4. Calculate the average order value for each customer city

SELECT
  c.city,
  ROUND(AVG(order_total), 2) AS avg_order_value
FROM (
  SELECT
    o.orders_id,
    o.customer_id,
    SUM(m.price * od.quantity) AS order_total
  FROM orders o
  INNER JOIN order_details od
    ON od.orders_id = o.orders_id
  INNER JOIN menu_item m
    ON m.item_id = od.item_id
  GROUP BY o.orders_id, o.customer_id
) AS per_order
JOIN customers c
  ON c.customer_id = per_order.customer_id
GROUP BY c.city
ORDER BY c.city;

-- 4. Find how many different food items were ordered per restaurant

SELECT
  r.resturant_name,
  COUNT(DISTINCT od.item_id) AS distinct_items_ordered
FROM resturants r
JOIN orders o
  ON o.resturant_id = r.resturant_id
JOIN order_details od
  ON od.orders_id = o.orders_id
GROUP BY r.resturant_name
ORDER BY r.resturant_name;

-- DAY 5

-- 1. find cities with more than 5 total orders

select r.city , count(o.orders_id) as Total_orders
from resturants r join orders o
on o.resturant_id = r.resturant_id
group by r.city
having count(orders_id)>5;

-- 2. show food items that earned more than 1000/- in total_revenue 

select m.item_menu , sum(m.price*od.quantity) as revenue
from menu_item m join order_details od
on m.item_id = od.item_id
group by m.item_menu 
having sum(m.price*od.quantity) >1000;

-- 3. List customers who placed more than 3 orders 

select c.customer_name, count(o.orders_id) as Total_order
from customers c join orders o
on c.customer_id = o.customer_id
group by customer_name
having count(o.orders_id) > 3;

-- 4. display menu items that were ordered more than 2 times

select m.item_menu , count(o.orders_id) as more_than_once
from menu_item m join orders o
on m.resturant_id = o.resturant_id
group by m.item_menu
having  count(o.orders_id) > 2;

-- 5. Find categories where the average item price is greater than 300/-

SELECT item_menu , ROUND(AVG(price), 2) AS avg_price
FROM menu_item 
GROUP BY item_menu
HAVING AVG(price) > 300
ORDER BY avg_price DESC;


-- DAY 6

-- 1.	Show each food item and below how much more it costs than the average..? 

select item_menu , price,
(select avg(price) from menu_item )  as Average_price 
from menu_item ;

-- 2. show customers who placed atleast one orders 

select customer_name , customer_id
from customers
where customer_id  in (select customer_id from orders);

-- 3. Show each food item and below how much more it costs than the average..?

select item_menu , price,
price - (select avg(price) from menu_item )  as Diff_price_than_avg
from menu_item ;

-- 4. List Food items that cost more than the average price

select item_menu , price
from menu_item
where price > (select avg(price) from menu_item ) ;

-- 5. Show Customer who haven’t placed any order 

select customer_name, customer_id
from customers
where customer_id   not in (select customer_id from orders);

alter table menu_item 
rename column item_menu to item_name;

-- DAY 7

-- 1. Total orders per city 

select r.city , count(o.orders_id) as total_order
from orders  o join resturants r
on o.resturant_id = r.resturant_id 
group by r.city
order by total_order  desc;  

-- 2. revenue generated by each food items

select sum(m.price * od.quantity) as Total_Revenue , m.item_name
from menu_item m join order_details od
on m.item_id = od.item_id 
group by m.item_name
order by Total_Revenue desc;

-- 3. Top 5 Spending customers 

select c.customer_name , sum(o.orders_id) as Total_spend
from customers c join orders o
on c.customer_id = o.customer_id 
group by c.customer_name
order by Total_spend desc
limit 5 ;  

-- Insights 
/*
	-- Targetted Audience for we target continously
    -- Building Customers relations for more postive productive profits
    -- providing offers them but in low cost profit margin to these customer 
*/

-- 4. Resturant wise order count

select  count(o.orders_id),  resturant_name as resturant_name
from resturants r join orders o
on r.resturant_id = o.resturant_id
group by r.resturant_name 
order by count(o.orders_id) desc;

-- Insights 

/*
	-- identify which resturants give more count of order
    -- Targetting resturants For Building the proper understanding Bussiness relationship
    -- improve the Business from those Resturants which needs to improve the Count of orders
*/

-- 5. Average Order Value by  City

select c.city , avg(o.orders_id)  as Average_order_value
from customers c join orders o 
on c.customer_id = o.customer_id
group by c.city
order by Average_order_value desc;  

-- Insights

/*
	-- Average order Value for targetting cities which needs to improve 
    -- to those underperforming cities need to improve the tie-up with more resturants
    --indentify the problemms in those cities which factor affects the Averge order value like delivery , cost or etc
*/

-- DAY 8

-- 1. Monthly Orders Trends 

select month(order_date) as No_of_Month ,monthname(order_date) as Name_of_Month, count(orders_id) as No_of_Orders
from orders
group by month(order_date) , monthname(order_date)
order by No_of_Month ;

-- Insights 

/*
	- Tracking the Monthly Growth in the orders
    - observed peak orders Months 
    - Impacts of Weather , Holidays and Festivals 
    - Plan time Sensitive discounts amd campaign 
*/

-- 2. Top 3 Cities By Revenue 

 select c.city , sum(m.price*od.quantity) as Total_Revenue
 from customers c join orders o
 on c.customer_id = o.customer_id
 join order_details od 
 on o.orders_id = od.orders_id 
 join menu_item m 
 on m.item_id = od.item_id 
 group by c.city
 order by Total_Revenue desc
 limit 3 ;
 
-- Insights 

/*

*/

-- 3. number of unique customers per city

select city,  count(distinct customer_id) as unique_customers 
from customers 
group by city 
order by unique_customers  desc ;

-- Insights

/*
	-- Targetting customers which we needs to focus on them by providing offers
    -- gains the loyality of Customers by  rewards and loyality program 
    -- Resouces Allocations to those particular cities  
*/

-- 4. Most frequents Order items

select m.item_name , count(o.orders_id) as No_of_order_count
from  menu_item m join orders o
on m.resturant_id = o.resturant_id 
group by m.item_name 
order by count(o.orders_id) desc;

-- Insights 

/*
	-- Top selling Item and customers preferences
    -- cross selling the food Items based on the preferences
    -- profitability Analysis which food items is in depands and increases your profits
*/

-- 5. Resturants with Low orders Counts (less than 30)

select r.resturant_name , r.resturant_id , count(o.orders_id) as No_of_Orders
from  resturants r  join orders o
on r.resturant_id = o.resturant_id  
group by r.resturant_id , r.resturant_name 
having count(o.orders_id)< 30;

-- Insights

/*
	-- UnderPerforming resturants 
    -- marketing and promotion gaps where we needs to starts the offer campaign 
    -- identify the cause of low order counts 
*/

-- DAY 9
/* 
 -- Creation of Charts Done
*/

-- DAY 10

-- 14 DAYS Pro Challenge Begineer To Advanced 

-- Day 1

-- 1. Get the Top 5 customers Based on the Total Order Placed 

select c.customer_name , c.customer_id , count(o.orders_id) as Total_Order
from customers c join orders o
on c.customer_id = o.customer_id
group by c.customer_name , c.customer_id
order by Total_Order desc
limit 5; 

-- 2. show the total amount spend by each customers 

 