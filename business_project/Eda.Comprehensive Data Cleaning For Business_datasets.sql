create table customers
select*
from business_project.customers;
create table inventory
select*
from business_project.inventory;
create table products
select*
from business_project.products;
create table promotions
select*
from business_project.promotions;
create table sales
select*
from business_project.sales;
create table stores
select*
from business_project.stores;

-- 1 Customer Table Data Deduplication Analysis -- 

with a as
(select*,row_number()over(partition by customer_id,name,age,gender,city,loyalty_points) as row_n
from customers)
select*
from a
where row_n > 1;

-- 2 Inventory Table Data Deduplication Analysis --

with a as
(select*,row_number()over(partition by store_id,product_id,stock_quantity,restock_date) as row_n
from inventory)
select*
from a
where row_n > 1;

-- 3 Product Table Data Deduplication Analysis --

with a as
(select*,row_number()over(partition by product_id,name,category,cost_price,selling_price) as row_n
from products)
select*
from a
where row_n > 1 ;

-- 4 Promotions Table Data Deduplication Analysis --

with a as
(select*,row_number()over(partition by promo_id,product_id,start_date,end_date,discount_percentage) as row_n
from promotions)
select*
from a
where row_n > 1 ;

-- 5 Sales Table Data Deduplication Analysis --

with a as
(select*,row_number()over(partition by sale_id,store_id,customer_id,product_id,date,quantity,discount) as row_n
from sales)
select*
from a
where row_n > 1;

-- Stores Table Data Deduplication Analysis --

with a as
(select*,row_number()over(partition by store_id,name,location,manager,open_date) as row_n
from stores)
select*
from a
where row_n > 1 ;

