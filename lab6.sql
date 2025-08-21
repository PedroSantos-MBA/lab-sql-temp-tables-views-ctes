use sakila;

-- ------------------------ --

#	Step 1: Create a View
#
#	First, create a view that summarizes rental information for each customer. 
#	The view should include: 
#		customer's ID, name, email address, and total number of rentals (rental_count).

create view rental_info as (
	select c.customer_id,
		   concat(c.first_name,' ',c.last_name) as name,
		   c.email,
		   count(r.rental_id) as rental_count
	from customer c
	left join rental r
		on c.customer_id = r.customer_id
	group by customer_id);
    
select * from rental_info;


#	Step 2: Create a Temporary Table
#
#	Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). 
#	The Temporary Table should use: 
#		rental summary view created in Step 1 to join with the payment table and calculate the total amount paid by each customer.


create temporary table customer_paid
	select ri.*, 
		   sum(p.amount) as total_paid
	from rental_info ri
	left join payment p
	on ri.customer_id = p.customer_id
	group by customer_id;
    
    
#	Step 3: Create a CTE and the Customer Summary Report
#
#	Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. 
#	The CTE should include:
#		customer's name, email address, rental count, and total amount paid.

#	Next, using the CTE, create the query to generate the final customer summary report, which should include: 
#		customer name, email, rental_count, total_paid and average_payment_per_rental, this last column is a derived column from total_paid and rental_count.


with cte_customer_sum as (
	select cp.*
	from customer_paid cp
	left join rental_info ri
	on cp.customer_id = ri.customer_id)
    
select *,
	   (total_paid / rental_count) as avg_payment_rental
from cte_customer_sum;

