-- 1 Finding  the second highest selling price --

with a as
(select customer_id,sum(total_gross_sale) as total_sale
from business_project
group by customer_id)
select*
from(select*,row_number()over(order by total_sale desc) as row_num
from a) as order_total_sale 
where row_num = 2;

-- 2 finding the product that sold the most  -- 

select product_name,sum(quantity) as total_quantity
from business_project
group by product_name
order by total_quantity desc
limit 1;




-- 3 Finding the second highest profit without using LIMIT or TOP --

with a as 
(select customer_id,sum(profit) as total_profit
from business_project
group by customer_id)
select*
from(select*,row_number()over(order by total_profit desc) as row_num
from a) as hi
where row_num = 2;


--  4 Finding categories where every product has generated profit greater than 1000 --

select category,sum(profit) as total_profit
from business_project
group by category
having total_profit > 1000;

-- 5 Finding the products whose total sales are above the average sales of their category --

select category,sum(total_gross_sale) as sts
from business_project
group by category
having sts > (with total_revenue as
(select category,sum(total_gross_sale) as sts
from business_project
group by category)
select avg(sts) avg_total_sale
from total_revenue);

 
 -- 6 Display "Profit", "Loss", or "Break-even" for every transaction -- 

select*,
case
when selling_price>cost_price then "Profit"
when selling_price<cost_price then "Loss"
else "Break_even"
end as profit_loss_break_even
from business_project;
