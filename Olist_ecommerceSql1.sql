-- 1) Weekday Vs Weekend (order_purchase_timestamp) Payment Statistics

Create View  Weekday_Weekend_Payment as
select
case
	when weekday(order_purchase_timestamp) in (5,6) then "Weekend"
    else "Weekday" 
end as Day_Type,
concat(round(sum(p.payment_value)/1000000,1),"M") as Total_Payment_Value
from olist_orders_dataset O
join olist_order_payments_dataset P
on O.order_id = P.order_id
group by Day_Type;

Select * from Weekday_Weekend_Payment;


-- 2)Number of Orders with review score 5 and payment type as credit card.

select * from olist_order_reviews_dataset;
select * from olist_order_payments_dataset;

create view TotalOrders_credit_card_score5 as
select P.payment_type,R_S.review_score,count(P.order_id) as Total_order
from olist_order_reviews_dataset R_S 
join olist_order_payments_dataset P
on R_S.order_id =P.order_id
where R_S.review_score = 5 and P.payment_type ='credit_card'
group by P.payment_type;

select * from TotalOrders_credit_card_score5;


-- 3)Average number of days taken for order_delivered_customer_date for pet_shop


Create view Avg_number_of_days_for_pet_shop as
select product_category_name, 
concat(Round(avg(datediff(order_delivered_customer_date,order_purchase_timestamp)))," Days") as Avg_Shipping_Days
from olist_orders_dataset O
join olist_order_items_dataset I
on O.order_id = I.order_id
join olist_products_dataset1 P 
on I.product_id = P.product_id
where P.product_category_name ='pet_shop';


select * from Avg_number_of_days_for_pet_shop;


 -- 4) Average price and payment values from customers of sao paulo city


select round(Avg(i.price),2) as Average_Price, 
       Round(Avg(p.payment_value),2) as Average_payment
from olist_order_items_dataset i 
join
olist_order_payments_dataset P
on i.order_id = P.order_id
join olist_orders_dataset O 
on P.order_id = o.order_id
join olist_customers_dataset c 
on O.customer_id = C.customer_id
where c.customer_city = 'sao paulo';


Create view Avg_price_and_payment_of_customers_SaoPaulo as
with Average_Price as 
	(select round(Avg(i.price),2) as Average_Price
	from olist_order_items_dataset i
	join olist_orders_dataset o 
	on i.order_id = o.order_id
	join olist_customers_dataset c
	on o.customer_id = c.customer_id
	where c.customer_city = 'sao paulo')
select 
(select Average_Price from Average_Price) as Average_Price,
(select round(Avg(p.payment_value),2) as Average_Price
from olist_order_payments_dataset P
join olist_orders_dataset o 
on p.order_id = o.order_id
join olist_customers_dataset c
on o.customer_id = c.customer_id
where c.customer_city = 'sao paulo') as Average_payment;

select * from Avg_price_and_payment_of_customers_SaoPaulo;


-- 5)Relationship between shipping days (order_delivered_customer_date - order_purchase_timestamp) Vs review scores.

Create view  shipping_days_Vs_review_scores as
select  R.review_score,
concat(Round(avg(datediff(order_delivered_customer_date,order_purchase_timestamp)))," Days") as Avg_Shipping_Days
from olist_orders_dataset O
join olist_order_reviews_dataset R
on O.order_id = R.order_id 
Group by R.review_score
order by R.review_score desc;


select * from shipping_days_Vs_review_scores;


-- Total Revenue

select 
	concat(round(sum(payment_value)/1000000,2),"M") as Total_Revenue
from 
	olist_order_payments_dataset;
    
-- REVENUE BY YEAR
select min(date(order_purchase_timestamp)) as start_date,max(date(order_purchase_timestamp)) as end_date from olist_orders_dataset;

select 
	  year(o. order_estimated_delivery_date) as 'year',
	  concat(round(sum(payment_value)/1000000,2),"M") as Total_Revenue
from 
	olist_order_payments_dataset P
join olist_orders_dataset O
on P.order_id = O.order_id 
group by  year(order_estimated_delivery_date)
order by  year(order_estimated_delivery_date) desc;

-- canceled orders

select order_status, count(*) as Canceled_order from olist_orders_dataset
where order_status = 'canceled'
group by order_status;




