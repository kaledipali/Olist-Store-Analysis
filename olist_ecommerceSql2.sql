-- Most in-demand product
-- 6) Top 5 product category by orders

create view Top5Productby_orders as
SELECT 
    product_category, COUNT(order_id) AS Total_orders
FROM
    olist_order_items_dataset i
        JOIN
    (SELECT 
        product_id,
            PC.product_category_name_english AS product_category
    FROM
        olist_products_dataset1 P
    JOIN product_category_name_translation PC ON P.product_category_name = PC.product_category_name) Category ON i.product_id = Category.product_id
GROUP BY product_category
ORDER BY Total_orders DESC
LIMIT 5;

select * from Top5Productby_orders;

-- least in demand
-- 7) Bottom 5 product category by orders

Create view Bottom5Productby_orders as
SELECT 
    product_category, COUNT(order_id) AS Total_orders
FROM
    olist_order_items_dataset i
        JOIN
    (SELECT 
        product_id,
            PC.product_category_name_english AS product_category
    FROM
        olist_products_dataset1 P
    JOIN product_category_name_translation PC ON P.product_category_name = PC.product_category_name) Category ON i.product_id = Category.product_id
GROUP BY product_category
ORDER BY Total_orders asc
LIMIT 5;

select * from Bottom5Productby_orders;


-- top 5 product by revenue

Create view Top5_product_by_revenue as
SELECT 
    product_category, concat(round(sum(payment_value)/1000000,1),"M") total_revenue
FROM olist_order_payments_dataset P
join
    olist_order_items_dataset i
on P.order_id = i.order_id
JOIN
    (SELECT 
	 product_id,
	 PC.product_category_name_english AS product_category
    FROM
	olist_products_dataset1 P
    JOIN product_category_name_translation PC ON P.product_category_name = PC.product_category_name) 
    Category
ON i.product_id = Category.product_id
GROUP BY product_category
ORDER BY total_revenue  DESC
LIMIT 5;

select * from Top5_product_by_revenue;

-- Top 5 cities by customers

Create View  Top5_cities_by_customers as
select customer_city, count(customer_city) as Total_customers 
from olist_customers_dataset
group by customer_city
order by Total_customers desc
limit 5;

select * from Top5_cities_by_customers;

-- Bottom 5 cities by customers

Create View  Bottom5_cities_by_customers as
select customer_city, count(customer_city) as Total_customers 
from olist_customers_dataset
group by customer_city
order by Total_customers asc
limit 10;

select * from Bottom5_cities_by_customers;

 -- Which payment methods are most commonly used by Olist customers
 
 create view payment_methods_Orders as
 select payment_type, count(*) as total from olist_order_payments_dataset
 group by payment_type;
 
 select * from payment_methods_Orders;
 
 
 -- Total freight by Year

SELECT CONCAT(ROUND(SUM(freight_value)/1000000,2),'M') TOTAL_freight_value  FROM olist_order_items_dataset;

create view total_freight_by_Year as 
select YEAR(O.order_purchase_timestamp) AS 'YEAR', ROUND(SUM(price),1) as Total_Price, 
ROUND(SUM(freight_value),1) TOTAL_freight_value from olist_order_items_dataset I
join olist_orders_dataset O
ON I.order_id= O.order_id
GROUP BY YEAR(O.order_purchase_timestamp)
ORDER BY YEAR(O.order_purchase_timestamp) DESC ;

select * from total_freight_by_Year;