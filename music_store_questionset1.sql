/*Q1: Who is the senior most employee on the based on job title ?
Ans: Madan Mohan
*/
SELECT * FROM employee
order by levels DESC
limit 1

--------------

/*Q2: Which contries have most invoices ?
Ans: USA - 131, Canada - 76
*/
select count(invoice_id) no_of_invoices,billing_country
from invoice
group by billing_country
order by no_of_invoices DESC

-----------------------------------------------
/*
Q3: What are top three values of total invoices ?
Ans: Run query
*/
select total
from invoice 
order by total desc
limit 3
 
----------------------------------------------------

/*Q4: Which city has best cusomers? we would like throw a music festival in city
we made most money. write a query that returns one city that has highest sum
of invoice totals.returns both the city names & sum of invoice totals.
*/
--Ans: Prague

select sum(total) sum_of_total, billing_city 
from invoice 
group by billing_city
order by sum_of_total desc

--------------------------------------

/*
Q5: Who is the best customer? the customer who has spent the most money will be 
declared the best customer. write a query that returns the person who has spent 
the most money.*/
--Ans: 

 select customer.customer_id,
   		customer.first_name,
		customer.last_name,
		sum(invoice.total) total
from customer
Join invoice ON customer.customer_id = invoice.customer_id
group by customer.customer_id
order by total desc		
limit 1

				--OR--

 select customer.customer_id,
   		customer.first_name,
		customer.last_name,
		sum(invoice.total) total
from invoice
Join customer ON customer.customer_id = invoice.customer_id
group by customer.customer_id
order by total desc		
limit 1

-----------------------------------------------


