-- Joined 4 tables because I would like to see all this data  in one table --

Create Table Business
(with a as
(select sa.customer_id,cu.name as customer_name,age,gender,city,loyalty_points,sa.product_id,
pd.name as product_name,category,cost_price,selling_price,quantity,discount,
(selling_price*quantity) as total_gross_sale,st.name as store_name,location,manager,open_date,sale_id,sa.store_id,`date` as date_
from sales as sa
join products as pd
on sa.product_id=pd.product_id
join customers as cu
on sa.customer_id=cu.customer_id
join stores as st
on sa.store_id=st.store_id),
b as
(select*,substring_index(date_,"-",1) as years,
substring_index(substring_index(substring_index(date_," ",1),"-",2),"-",-1)as months,
substring_index(substring_index(date_," ",1),"-",-1) as days
from a)
select*
from b);

-- create new  table due to I to want to know  revenue and profit -- 

Create Table Business_project
(with a as
(select*, total_gross_sale-(total_gross_sale*(discount/100)) as revenue
from business),
b as
(select*,revenue-(cost_price*quantity) as profit  
from a)
select customer_id,customer_name,age,gender,city,loyalty_points,product_id,product_name,category, cost_price,selling_price,quantity,
discount,total_gross_sale,revenue,profit,store_name,location,manager,open_date,sale_id,store_id,date_,years,months,days
from b);

-- 1 Find the total revenue and total sales by year --

select years,sum(total_gross_sale) as total_gross_sale,sum(revenue) as total_revenue
from business_project
group by years;

-- 2 Find the total profit by year --

select years,sum(profit) as total_profit
from business_project
group by years;

-- 3 Show the sales amount, revenue, and profit by year and month --

select months,years,sum(total_gross_sale) as total_sale,sum(revenue) as total_revenue,sum(profit) as total_profit 
from business_project
group by months,years
order by months asc;

-- 4 Show the highest revenue by month for each year --

with a as
(select months,years,sum(revenue) as total_revenue
from business_project
group by months,years),
b as
(select*,dense_rank()over(partition by years order by total_revenue desc ) as d_rank
from a)
select*
from b
where d_rank=1;

-- 5 Calculate the cumulative profit by store ID --

select*,sum(profit)over(partition by store_id,store_name order by years,months,days asc  ) as cumulative_profit
from  business_project;

-- 6 Find total purchase frequency and total spend for each customer --

select customer_id,customer_name,count(total_gross_sale) as frequency_purchase,sum(total_gross_sale) as total_spend
from business_project
group by customer_id,customer_name
order by frequency_purchase desc, total_spend desc;

-- 7 Find average customer order value for each customer --

with a as
(select customer_id,customer_name,sum(total_gross_sale) as total_spending
from business_project
group by customer_id,customer_name)
select avg(total_spending) as avg_spending
from a;

-- 8 Find top 10  customers who spend  the most --

select customer_id,customer_name,sum(total_gross_sale) as total_spend_amount,sum(revenue) as total_revenue
from business_project
group by customer_id,customer_name
order by total_spend_amount desc, total_revenue desc
limit 10;

-- 9 Find the last purchase year for each customer --

select customer_id,customer_name,max(years) as last_purchase_year,count(total_gross_sale) as total_orders, sum(revenue) as total_revenue
from business_project
group by customer_id,customer_name
order by last_purchase_year desc,total_revenue desc;

-- 10 Find customers who purchased products from every category --

with a as
(select customer_id,customer_name,category
from business_project
group by customer_id,customer_name,category),
b as
(select*,row_number()over(partition by customer_id order by category) as row_n
from a)
select*
from b 
where row_n= (select  count(category)
from (select category
from business
group by category)
category);

-- 11 Find customers whose spending falls in the top 15% --

with a as
(select customer_id,sum(total_gross_sale) as total_amount
from business_project
group by customer_id),
b as
(select*,row_number()over( order by total_amount desc ) as row_n
from a)
select*
from b
where row_n <=(with a as
(select customer_id
from business_project
group by customer_id)
select count(customer_id)
from a)*0.15;

-- 12 Ranking customers by total spending within each city --

with a as
(select city,customer_id,sum(total_gross_sale) as sts
from business_project
group by city,customer_id),
b as
(select*,dense_rank()over(partition by city order by sts desc) as d_rank
from a)
select*
from b
where d_rank <=3;

-- 13 Find the first and last purchase dates for customers --

with a  as
(select *,row_number()over(partition by customer_id order by years ASC,months ASC,days asc) as min_c
from business_project),
b as
(select*
from a
where min_c = 1),
c as(
select customer_id,date_ as min_date
from b),
d as(
select *,row_number()over(partition by customer_id order by years DESC,months DESC,days desc) as max_c
from business_project),
e as (
select customer_id,date_ as max_date
from d
where max_c = 1)
SELECT c.customer_id, min_date,max_date
FROM c
JOIN e
on c.customer_id=e.customer_id;

-- 14 Categorize customers into Platinum, Gold, Silver and Bronze tiers based on total spending --

with a as
(select customer_id,sum(total_gross_sale) as ss
from business_project
group by customer_id),
b as 
(select*,
case
when ss > (select avg(ss)from a) then "Gold"
else "Silver"
end as first_step
from a),
gold_table as
(select*
from b
where first_step ="Gold"),
Plat_Gold_Table as
(select*,
case
when ss>(select avg(ss) from gold_table) then "Platinum"
else "Gold"
end as second_step
from gold_table),
silver_table as
(select*
from b
where first_step="Silver"),
Sil_Broz_Table as
(select*,
case 
when ss >(select avg(ss)from silver_table) then "Silver"
else "Bronze"
end as final_step
from silver_table),
final as
(select * from Plat_Gold_Table
union
select* from Sil_Broz_Table)
select second_step,count(second_step)
from final
group by second_step;

-- 15 Find top 10 total revenue and total sales for each product by year with ranking -- 

with a as
(select product_id,product_name,years,sum(total_gross_sale) as total_sale,sum(revenue) as total_revenue
from business_project
group by product_id,product_name,years),
b as
(select*,row_number()over(partition by years order by total_revenue desc) as r_n
from a)
select*
from b
where r_n <=10;

-- 16 Find top 10 revenue the total profit for each product by year --

with a as
(select years,product_id,product_name,sum(profit) as total_profit 
from business_project
group by years,product_id,product_name),
b as 
(select*,row_number()over(partition by years order by total_profit desc) as r_n
from a)
select*
from b
where r_n<=10;

-- 17 Find the top 3 popular products and show their total revenue and total sales by citites --

with a as
(select city,product_id,sum(total_gross_sale) as total_sale,sum(revenue) as total_revenue
from business_project
group by city,product_id),
b as
(select*,row_number()over(partition by city order by total_sale desc,total_revenue desc)row_n
from a)
select*
from b
where row_n <= 3 ;

-- 18 Find the top 3 popular products and show their total profit by years -- 

with a as
(select years,product_id,sum(profit) as total_profit
from business_project
group by years,product_id),
b as
(select*,row_number()over(partition by years order by total_profit desc )row_n
from a)
select*
from b
where row_n <= 3 ;

-- 19 Find top 2 products by revenue in each category --

with a as
(select category,product_id,product_name,sum(revenue) as total_revenue
from business_project
group by category,product_id,product_name)
select*
from(select*,dense_rank() over(partition by category order by total_revenue desc) d_rank
from a) as hi
where d_rank<=2;

-- 20 Show the top 10 products with the lowest revenue --

select product_id,product_name,sum(revenue) as total_revenue
from business_project
group by product_id,product_name
order by total_revenue asc
limit 10;

-- 21 Find the top 15% best-selling products based on total sales amount --

with a as
(select product_id,product_name,sum(total_gross_sale) as total_amount
from business_project
group by product_id,product_name
order by total_amount),
b as
(select*,row_number()over(order by total_amount desc ) as r_n
from a)
select*
from b
where r_n<=(with a as
(select product_id
from business_project
group by product_id)
select count(product_id)
from a)*0.15;

-- 22 Find the top 10 stores and managers, and show their total revenue and total sales by year --

with a as
(select years,store_id,store_name,manager,sum(total_gross_sale) as total_sale,sum(revenue) as total_revenue
from business_project
group by years,store_id,store_name,manager),
b as
(select*,dense_rank()over(partition by years order by total_revenue desc,total_sale desc) as dense_n
from a)
select*
from b
where dense_n <=10;

-- 23 Find the top 10 stores and managers, and show their total profit by year --

with a as
(select store_id,store_name,manager,years,sum(profit) as total_profit
from business_project
group by store_id,store_name,manager,years),
b as
(select*,row_number()over(partition by years order by total_profit desc)as row_n
from a)
select*
from b
where row_n<=10;

-- 24 Show the top 10 products with the highest remaining inventory stock -- 

with a as 
(select product_id,sum(quantity) as total_quantity
from sales
group by product_id),
b as 
(select product_id,sum(stock_quantity) as total_stock_quantity
from inventory
group by product_id),
c as 
(select b.product_id,total_stock_quantity,total_quantity,(total_stock_quantity-total_quantity) as  remaining_quantity
from b
join a
on b.product_id=a.product_id)
select*
from c
order by remaining_quantity desc
limit 10;

-- 25 Show the top 10 products with the lowest left quantity in inventory -- 

with a as 
(select product_id,sum(quantity) as total_quantity
from sales
group by product_id),
b as 
(select product_id,sum(stock_quantity) as total_stock_quantity
from inventory
group by product_id),
c as 
(select b.product_id,total_stock_quantity,total_quantity,(total_stock_quantity-total_quantity) as  remaining_quantity
from b
join a
on b.product_id=a.product_id)
select*
from c
order by remaining_quantity asc
limit 10;

-- 26 Use a stored procedure to find any  stores of  and total sales and total revenue --

create procedure store(a int)
(select store_id,store_name,sum(total_gross_sale) as total_sale, sum(revenue) as total_revenue
from business_project
group by store_id,store_name
having store_id=a);

call store (1);

-- 27 Finding  the first and last sale date for each store -- 

with a  as
(select *,row_number()over(partition by store_id,store_name order by years ASC,months ASC,days ASC) as min_c
from business_project),
b as
(select*
from a
where min_c = 1),
c as(
select store_id,store_name,date_ as min_date
from b),
d as(
select *,row_number()over(partition by store_id,store_name order by years DESC,months DESC,days DESC) as max_c
from business_project),
e as (
select store_id,store_name,date_ as max_date
from d
where max_c = 1)
SELECT c.store_id,c.store_name, min_date,max_date
FROM c
JOIN e
on c.store_id=e.store_id;

-- 28 Store tier categorization based on total revenue --

with a as
(select store_id,store_name,sum(revenue) as total_revenue
from business_project
group by store_id,store_name),
Gold_Silver_Table as
(select *,
case
when total_revenue > (select avg(total_revenue) from a) then "Gold"
else "Silver"
end as first_step
from a),
Gold_Table as
(select*
from Gold_Silver_Table
where first_step="Gold"),
Platinum_Gold_Table as
(select*,
case
when total_revenue>(select avg(total_revenue) from Gold_Table) then "Platinum"
else "Gold"
end as second_step
from Gold_Table),
Silver_Table as
(select*
from Gold_Silver_Table
where first_step="Silver"),
Silver_Bronze_Table as
(select*,
case
when total_revenue >( select avg(total_revenue) from Silver_Table)then "Silver"
else "Bronze"
end as Third_Step
from Silver_Table),
b as
(select* from Platinum_Gold_Table
union
select* from Silver_Bronze_Table)
select second_step,count(second_step)
from b
group by second_step;

-- 29 Finding the nth highest sale amount(N should be dynamic )--

create procedure dd(d int)
select*
from(with a as
(select customer_id,sum(total_gross_sale ) as sts
from business_project
group by customer_id)
select*,dense_rank()over(order by sts desc) as d_rank
from a) as hi
where d_rank =d;

call dd(12);







