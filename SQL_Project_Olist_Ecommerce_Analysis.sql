--Customer Overview

-- Sual: Ümumi neçə müştəri qeydi və neçə unikal müştəri var?
-- Question: How many total customer records and unique customers are there?

select count(customer_id) as total_customer_records,
       count(distinct customer_unique_id) as unique_customers
from olist_customers_dataset;




-- Sual: Birdən çox dəfə qeyd olunan müştərilər hansılardır?
-- Question: Which customers appear more than once in the dataset?

select customer_unique_id,
       count(*) as customer_record_count
from olist_customers_dataset
group by customer_unique_id 
having count(*)>1
order by customer_record_count desc;



-- Sual: Hər ştat üzrə ümumi müştəri qeydlərinin sayı neçədir?
-- Question: What is the total number of customer records in each state?

select customer_state,
       count(customer_id) as total_customers_records_for_state
from olist_customers_dataset 
group by customer_state;


-- Sual: Hər ştat üzrə neçə unikal müştəri var?
-- Question: How many unique customers are there in each state?

select customer_state,
       count(distinct customer_unique_id) as customer_count
from olist_customers_dataset 
group by customer_state;



-- Sual: Ən çox unikal müştərisi olan ilk 10 ştat hansılardır?
-- Question: Which are the top 10 states with the highest number of unique customers?

select customer_state,
       count(distinct customer_unique_id) as customer_count
from olist_customers_dataset 
group by customer_state
order by customer_count DESC 
limit 10;


-- Sual: Ən çox unikal müştərisi olan ilk 5 şəhər hansılardır?
-- Question: Which are the top 5 cities with the highest number of unique customers?

select customer_city,
       count(distinct customer_unique_id) as customer_count
from olist_customers_dataset 
group by customer_city 
order by customer_count desc
limit 5;
 

-- Sual: Hər ştatda neçə fərqli şəhər var?
-- Question: How many distinct cities are there in each state?

select customer_state,
       count(distinct customer_city) as city_count
from olist_customers_dataset
group by customer_state
order by city_count desc;


-- Sual: Müştəri qeydlərinin neçə faizi təkrarlanan qeydlərdir?
-- Question: What percentage of customer records are duplicate records?

select count(customer_id) as total_customer_count,
       count(distinct customer_unique_id) as distinct_customer_count,
       Round((count(customer_id)-count(distinct customer_unique_id))*100.0/count(customer_id),2) as duplicate_customer_record_percent
from olist_customers_dataset;


-- Sual: Hər ştat və şəhər üzrə neçə unikal müştəri var?
-- Question: How many unique customers are there by state and city?

select customer_state,
       customer_city,
       count(distinct customer_unique_id) as customer_count
from olist_customers_dataset
group by customer_state,customer_city
order by customer_state,customer_count desc;



-- Sual: Hər ştat üzrə ümumi sifariş sayı neçədir?
-- Question: What is the total number of orders in each state?

select c.customer_state,
       count(o.order_id) as total_orders
from olist_customers_dataset c join olist_orders_dataset o
on c.customer_id=o.customer_id
group by c.customer_state;

 
-- Sual: Ən çox sifariş verilən ilk 10 şəhər hansılardır?
-- Question: Which are the top 10 cities with the highest number of orders?

select c.customer_city ,
       count(o.order_id) as orders_count 
from olist_customers_dataset c join olist_orders_dataset o
on c.customer_id=o.customer_id 
group by c.customer_city
order by orders_count desc
limit 10;




--Payment Analysis

-- Sual: Ödəniş növlərinin istifadə sayı necə paylanır?
-- Question: How is the usage count distributed across payment types?

select payment_type,
       count(*) as payment_count 
from olist_order_payments_dataset 
group by payment_type 
order by payment_count desc;



-- Sual: Orta qiymətdən aşağı olan məhsulların ən yüksək qiymətindən daha baha olan məhsullar hansılardır?
-- Question: Which products are more expensive than the highest-priced product below the average price?

select o.product_id,o.price
from olist_order_items_dataset o
where o.price> (select max(price)
                   from olist_order_items_dataset 
                   where price<(select avg(price) 
                   from olist_order_items_dataset ));





--Order Analysis 

-- Sual: Sifariş statuslarının paylanması necədir?
-- Question: What is the distribution of order statuses?

select order_status,
       count(order_id) as order_status_count
from olist_orders_dataset
group by order_status
order by order_status_count desc;



-- Sual: Ən çox görülən sifariş statusu hansıdır?
-- Question: What is the most common order status?

select order_status,
       count(order_id) as order_status_count
from olist_orders_dataset
group by order_status
order by order_status_count desc
limit 1;


-- Sual: Ən çox sifariş verilən ilk 10 şəhər hansılardır?
-- Question: Which are the top 10 cities with the highest number of orders?

select c.customer_city,
       count(o.order_id) as order_count 
from olist_customers_dataset c join olist_orders_dataset o
on c.customer_id=o.customer_id 
group by c.customer_city 
order by order_count desc
limit 10;



-- Sual: Ən çox sifariş verən ilk 10 müştəri kimdir?
-- Question: Who are the top 10 customers with the highest number of orders?

select c.customer_unique_id,
	   count(o.order_id) as order_count
from olist_customers_dataset c join olist_orders_dataset o
on c.customer_id=o.customer_id 
group  by c.customer_unique_id 
order by order_count desc
limit 10;


-- Sual: Aylar üzrə sifariş sayı necə dəyişir?
-- Question: How does the number of orders vary by month?

select
case strftime('%m', order_purchase_timestamp)
    when '01' then 'January'
    when '02' then 'February'
    when '03' then 'March'
    when '04' then 'April'
    when '05' then 'May'
    when '06' then 'June'
    when '07' then 'July'
    when '08' then 'August'
    when '09' then 'September'
    when '10' then 'October'
    when '11' then 'November'
    when '12' then 'December'
end as month_name,
       count(order_id) as order_count
from olist_orders_dataset
group by  strftime('%m', order_purchase_timestamp);



-- Sual: İllər üzrə sifariş sayı necə dəyişir?
-- Question: How does the number of orders vary by year?

select strftime('%Y', order_purchase_timestamp) as years,
       count(order_id) as orders_count
from olist_orders_dataset 
group by years;



-- Sual: Çatdırılmış sifarişlərin sayı neçədir?
-- Question: How many delivered orders are there?

select order_status,
       count(order_id) as order_count
from olist_orders_dataset
where order_status='delivered'
group by order_status;




-- Sual: Ləğv olunmuş sifarişlərin sayı neçədir?
-- Question: How many canceled orders are there?

select order_status,
       count(order_id) as order_count
from olist_orders_dataset 
where order_status='canceled'
group by order_status;


-- Sual: Ən çox sifariş verilən ilk 3 həftə günü hansılardır?
-- Question: Which are the top 3 weekdays with the highest number of orders?

select strftime('%w',order_purchase_timestamp) as weekdays,
       count(order_id) as orders_count
from olist_orders_dataset 
group by weekdays 
order by orders_count desc
limit 3;




-- Sual: Gündəlik orta sifariş sayı neçədir?
-- Question: What is the average number of orders per day?

select count(order_id)/
count(distinct date(order_purchase_timestamp)) as avg_per_days_orders
from olist_orders_dataset;


-- Sual: Müştəri başına orta sifariş sayı neçədir?
-- Question: What is the average number of orders per customer?

select avg(order_count) 
from ( select customer_unique_id as customers ,count(order_id) as order_count 
from olist_customers_dataset c join  olist_orders_dataset o
on c.customer_id=o.customer_id 
group by customers
);


-- Sual: Sifarişlər cədvəlində neçə fərqli customer_id mövcuddur?
-- Question: How many distinct customer IDs exist in the orders table?

select count(distinct (customer_id)) 
from olist_orders_dataset;
       



--Revenue Analysis

-- Sual: Ümumi gəlir nə qədərdir?
-- Question: What is the total revenue?

select sum(payment_value)  as total_revenue
from olist_order_payments_dataset;



-- Sual: Orta ödəniş məbləği nə qədərdir?
-- Question: What is the average payment value?

SELECT AVG(payment_value) AS avg_payment_value
FROM olist_order_payments_dataset;



-- Sual: Ən yüksək gəlir gətirən ilk 10 sifariş hansılardır?
-- Question: Which are the top 10 orders with the highest total revenue?

select order_id,sum(payment_value) as total_revenue
from olist_order_payments_dataset 
group by order_id
order by total_revenue desc
limit 10;




-- Sual: Ən çox gəlir gətirən ilk 10 şəhər hansılardır?
-- Question: Which are the top 10 cities generating the highest revenue?

select c.customer_city,sum(p.payment_value) as revenue
from olist_customers_dataset c join olist_orders_dataset o 
on c.customer_id=o.customer_id join olist_order_payments_dataset p
on o.order_id=p.order_id 
group by c.customer_city 
order by revenue desc
limit 10;




-- Sual: Ən çox ümumi dəyər yaradan ödəniş növü hansıdır?
-- Question: Which payment type generates the highest total payment value?

select payment_type,sum(payment_value) as total_value 
from olist_order_payments_dataset 
group by payment_type 
order by total_value desc 
limit 1;



-- Sual: Hər ştat üzrə orta ödəniş məbləği nə qədərdir?
-- Question: What is the average payment value in each state?

select customer_state,avg(payment_value) as avg_payment_value
from olist_customers_dataset c join olist_orders_dataset o
on c.customer_id=o.customer_id join olist_order_payments_dataset p 
on o.order_id=p.order_id 
group by customer_state 
order by avg_payment_value desc;




-- Sual: Sifariş başına orta gəlir nə qədərdir?
-- Question: What is the average revenue per order?

select avg(revenue) as avg_order_revenue
from(select order_id,sum(payment_value) as revenue
from olist_order_payments_dataset 
group by order_id);


-- Sual: Ən çox gəlir gətirən ilk 10 məhsul hansılardır?
-- Question: Which are the top 10 products generating the highest revenue?

select  product_id,sum(price + freight_value) as revenue
from olist_order_items_dataset 
group by product_id
order by revenue desc
limit 10;





--Product Analysis


-- Sual: Hər kateqoriya üzrə gəlirə görə ilk 3 məhsul hansılardır?
-- Question: Which are the top 3 products by revenue in each category?

with product_revenue as (select p.product_category_name as category,
					     o.product_id,
					     sum(o.price+o.freight_value) as total_revenue
					     from olist_order_items_dataset o join olist_products_dataset p
					     on o.product_id=p.product_id 
					     group by p.product_category_name, o.product_id),
ranked_products as (select category,
						   product_id,
						   total_revenue ,
						   row_number() over (partition by category order by total_revenue desc) as revenue_rank 
						   from product_revenue)
select *
from ranked_products 
where revenue_rank<=3
order by category,revenue_rank;

		
-- Sual: Kateqoriya üzrə orta qiymətin 1.5 qatından baha olan məhsullar hansılardır?
-- Question: Which products are priced more than 1.5 times the average price of their category?

with category_avg as (select p.product_category_name as category,
					  avg(o.price) as category_avg_price
					  from olist_order_items_dataset o join olist_products_dataset p
					  on o.product_id=p.product_id 
					  group by category)
select p.product_category_name as category,
       o.product_id,
       o.price as product_price,
       category_avg_price
from olist_order_items_dataset o join olist_products_dataset p 
on o.product_id=p.product_id 
join category_avg ca on p.product_category_name=ca.category

where o.price>ca.category_avg_price*1.5;
						   

-- Sual: Ən çox satılan ilk 10 məhsul hansılardır?
-- Question: Which are the top 10 best-selling products by units sold?

select product_id,
       count(*) as units_sold
from olist_order_items_dataset
group by product_id
order by units_sold desc
limit 10;



-- Sual: Orta çatdırılma xərci ən yüksək olan ilk 10 məhsul kateqoriyası hansılardır?
-- Question: Which are the top 10 product categories with the highest average freight cost?

select product_category_name,avg(freight_value) as freight_avg_cost
from olist_order_items_dataset  o join olist_products_dataset p
on o.product_id=p.product_id 
group by product_category_name 
order by freight_avg_cost desc
limit 10;




-- Sual: Ən çox fərqli sifarişdə görünən ilk 10 məhsul hansılardır?
-- Question: Which are the top 10 products appearing in the highest number of distinct orders?

select product_id,count(distinct order_id) as orders_count
from olist_order_items_dataset 
group by product_id
order by orders_count desc
limit 10;



-- Sual: Məhsullar qiymətə görə cheap, medium və expensive qruplarında necə bölünür?
-- Question: How are products classified into cheap, medium, and expensive price buckets?

SELECT
    p.product_category_name AS category,
    oi.product_id,
    oi.price,
    
    CASE 
        WHEN oi.price < 50 THEN 'cheap'
        WHEN oi.price BETWEEN 50 AND 150 THEN 'medium'
        ELSE 'expensive'
    END AS price_bucket

FROM olist_order_items_dataset oi
JOIN olist_products_dataset p
    ON oi.product_id = p.product_id

ORDER BY category, oi.price DESC;


-- Sual: Adında "casa" sözü olan məhsul kateqoriyaları hansılardır?
-- Question: Which product categories contain the word "casa" in their name?

select distinct product_category_name
from olist_products_dataset 
where product_category_name like '%casa%';






--Seller Analysis

-- Sual: Orta gəlirdən yüksək, amma orta review score-dan aşağı nəticəsi olan seller-lər hansılardır?
-- Question: Which sellers have above-average revenue but below-average review scores?

with sellers as (select seller_id, 
					 sum(oi.price+oi.freight_value ) as total_revenue,
					 avg(r.review_score) as avg_review_score
					 from  olist_order_items_dataset oi
					 join  olist_orders_dataset o
					 on oi.order_id=o.order_id
					 join olist_order_reviews_dataset r
					 on o.order_id=r.order_id
					 group by oi.seller_id)
select seller_id ,
        total_revenue,
        avg_review_score
from sellers 
where total_revenue>(select avg(total_revenue) from sellers )
      and avg_review_score<(select avg(avg_review_score) from sellers)
order by total_revenue desc;



-- Sual: Orta review score-u 3 ilə 4 arasında olan seller-lər hansılardır?
-- Question: Which sellers have an average review score between 3 and 4?

select o.seller_id,avg(r.review_score) as avg_review_score
from olist_order_items_dataset o join olist_order_reviews_dataset r
on o.order_id=r.order_id
group by o.seller_id 
having avg(r.review_score) between 3 and 4;


-- Sual: Heç review-si olmayan order-larda görünən seller-lər hansılardır?
-- Question: Which sellers appear in orders that have no reviews?

select distinct o.seller_id
from olist_order_items_dataset o
where not exists ( select 1 from olist_order_reviews_dataset r
                    WHERE  o.order_id=r.order_id);


-- Sual: Ən azı bir delivered order-da görünən seller-lər hansılardır?
-- Question: Which sellers appear in at least one delivered order?

select distinct o.seller_id
from olist_order_items_dataset o
where exists (select 1 
               from olist_orders_dataset d
               where o.order_id=d.order_id 
                     and d.order_status='delivered');


-- Sual: Şəhəri 'sao%' ilə başlayan müştərilərin sifarişlərinə görə seller-lərin orta review score-u nə qədərdir?
-- Question: What is the average review score of sellers for orders placed by customers from cities starting with 'sao%'?

SELECT o.seller_id,
       AVG(r.review_score) AS avg_review_score
FROM olist_order_items_dataset o
JOIN olist_orders_dataset d
     ON o.order_id = d.order_id
JOIN olist_customers_dataset c
     ON d.customer_id = c.customer_id
JOIN olist_order_reviews_dataset r
     ON o.order_id = r.order_id
WHERE c.customer_city LIKE 'sao%'
GROUP BY o.seller_id;


-- Sual: 2-dən çox fərqli order statusunda görünən seller-lər hansılardır?
-- Question: Which sellers appear in more than 2 distinct order statuses?

select distinct o.seller_id,count(distinct order_status) as status_count
from olist_order_items_dataset o join olist_orders_dataset d 
on o.order_id=d.order_id 
group by o.seller_id
having status_count>2;


-- Sual: Öz şəhərinin orta sifariş sayından çox sifariş verən müştərilər hansılardır?
-- Question: Which customers have placed more orders than the average order count in their city?

with customer_orders as (select c.customer_unique_id,c.customer_city,
                          count(o.order_id) as order_count
						  from olist_customers_dataset c join olist_orders_dataset o
					      on c.customer_id=o.customer_id
						  group by c.customer_unique_id,c.customer_city),

city_avg_orders as (select customer_city,
                    avg(order_count) as avg_order_count
                    from customer_orders
                    group by customer_city)
select co.customer_unique_id,
       co.customer_city,
       co.order_count,
       round(ca.avg_order_count,2) as city_avg_order_count
from customer_orders co
join city_avg_orders ca 
     on co.customer_city=ca.customer_city
where co.order_count > ca.avg_order_count
order by co.customer_city,co.order_count desc;
					 

--Delivery Date Analysis 

-- Sual: Delivered sifarişlər üçün orta çatdırılma müddəti neçə gündür?
-- Question: What is the average delivery time in days for delivered orders?

select avg( julianday(order_delivered_customer_date)-
       julianday(order_purchase_timestamp))as avg_delivery_days
from olist_orders_dataset
where order_status='delivered';




-- Sual: Hər ştat üzrə delivered sifarişlərin orta çatdırılma müddəti neçə gündür?
-- Question: What is the average delivery time in days for delivered orders in each state?

select c.customer_state,round(avg(julianday(o.order_delivered_customer_date)-
                                  julianday(o.order_purchase_timestamp)),2) as avg_delivery_days
from olist_orders_dataset o 
join olist_customers_dataset c
     on o.customer_id=c.customer_id 
where o.order_status='delivered'
group by c.customer_state
order by avg_delivery_days desc;


--Null values

-- Sual: Orders cədvəlində neçə null delivery date və null estimated delivery date var?
-- Question: How many null delivery dates and null estimated delivery dates exist in the orders table?

SELECT 
COUNT(*) AS total_orders,
SUM(CASE WHEN order_delivered_customer_date IS NULL THEN 1 ELSE 0 END) AS null_delivery_date,
SUM(CASE WHEN order_estimated_delivery_date IS NULL THEN 1 ELSE 0 END) AS null_estimated_date
FROM olist_orders_dataset;



-- Sual: Delivery date-i null və ya boş olan sifarişlər hansı statuslarda toplanır?
-- Question: Under which order statuses do orders with null or empty delivery dates appear?

SELECT
order_status,
COUNT(*) AS orders_count
FROM olist_orders_dataset
WHERE order_delivered_customer_date IS NULL
      OR order_delivered_customer_date =''
GROUP BY order_status;


       	       
-- Order Status Analysis

-- Sual: Delivered, shipped və canceled statusları üzrə sifariş sayı neçədir?
-- Question: How many orders are there for delivered, shipped, and canceled statuses?

select order_status,count(*) as order_count 
from olist_orders_dataset 
where order_status in ('delivered','shipped','canceled')
group by order_status;




-- Sual: SP, RJ və MG ştatlarında neçə unikal müştəri var?
-- Question: How many unique customers are there in the states SP, RJ, and MG?

select customer_state,count(distinct customer_unique_id)   as customer_count
from olist_customers_dataset 
where customer_state in ('SP','RJ','MG')
group by customer_state;





           





