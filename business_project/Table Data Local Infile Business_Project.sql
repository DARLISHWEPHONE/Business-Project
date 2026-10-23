-- first create data base and import a lot of Data using local Infile for faster import --

drop database if exists `business_project`;
CREATE DATABASE business_project;
use business_project;

Create Table customers
(customer_id int,	
`name` text,	
age	int,
gender text,
city text,	
loyalty_points int);

Create Table inventory
(store_id int,
product_id	int,
stock_quantity int,
restock_date text);

Create Table products
(product_id	int,
`name` text,	
category text,	
cost_price	decimal(20,2),
selling_price decimal(20,2));

Create Table promotions
(promo_id int,	
product_id int,
start_date text,
end_date text,
discount_percentage int);

-- after use that Data Import Wizard --

Create Table sales
(sale_id int,	
store_id int,
customer_id	int,
product_id int,	
`date` text,
quantity int,	
discount int);

Create Table stores
(store_id int,	
`name` text,	
location text,	
manager	text,
open_date text);

-- all csv files must be in the drive C --

SET GLOBAL LOCAL_INFILE=ON;

LOAD DATA LOCAL INFILE 'C:/customers.csv' INTO TABLE customers
FIELDS terminated by ','
enclosed by'"'
lines terminated by '\n'
Ignore 1 lines;

LOAD DATA LOCAL INFILE 'C:/inventory.csv' INTO TABLE inventory
FIELDS terminated by ','
enclosed by'"'
lines terminated by '\n'
Ignore 1 lines;

LOAD DATA LOCAL INFILE 'C:/products.csv' INTO TABLE products
FIELDS terminated by ','
enclosed by'"'
lines terminated by '\n'
Ignore 1 lines;

LOAD DATA LOCAL INFILE 'C:/promotions.csv' INTO TABLE promotions
FIELDS terminated by ','
enclosed by'"'
lines terminated by '\n'
Ignore 1 lines;

LOAD DATA LOCAL INFILE 'C:/sales.csv' INTO TABLE sales
FIELDS terminated by ','
enclosed by'"'
lines terminated by '\n'
Ignore 1 lines;

LOAD DATA LOCAL INFILE 'C:/stores.csv' INTO TABLE stores
FIELDS terminated by ','
enclosed by'"'
lines terminated by '\n'
Ignore 1 lines;



