/*
Q1: find how much spent by each customer on artists? write a query to return 
customer name, artists name , and total spent.*/
--Ans
/*
select customer.customer_id, customer.first_name, customer.last_name, 
artist.name artist_name, 
sum(invoice.total) total_spent
from customer
join invoice on customer.customer_id = invoice.customer_id
join invoice_line on invoice.invoice_id = invoice.invoice_id
join track on invoice_line.track_id = track.track_id
join album on track.album_id = album.album_id
join artist on album.artist_id = artist.artist_id
group by 1,2,3,4
order by total_spent desc;
*/

WITH best_selling_artist AS(
select 
	artist.artist_id artist_id, artist.name artist_name,
	sum(invoice_line.unit_price*invoice_line.quantity) total_sales
from invoice_line
join track on invoice_line.track_id =track.track_id
join album on track.album_id = album.album_id	
join artist on album.artist_id = artist.artist_id
	group by 1 
	order by 3 desc
	limit 1
)
select customer.customer_id, customer.first_name, customer.last_name, 
best_selling_artist.artist_name artist_name, 
sum(invoice_line.unit_price * invoice_line.quantity) total_spent
from customer
join invoice on customer.customer_id = invoice.customer_id
join invoice_line on invoice.invoice_id = invoice_line.invoice_id
join track on invoice_line.track_id = track.track_id
join album on track.album_id = album.album_id
join best_selling_artist on album.artist_id = best_selling_artist.artist_id
group by 1,2,3,4
order by total_spent desc
limit 1;

    --------OR my own query
select customer.customer_id, customer.first_name, customer.last_name, 
artist.name artist_name,
sum(invoice_line.unit_price * invoice_line.quantity) total_spent
from customer
join invoice on customer.customer_id = invoice.customer_id
join invoice_line on invoice.invoice_id = invoice_line.invoice_id
join track on invoice_line.track_id = track.track_id
join album on track.album_id = album.album_id
join artist on album.artist_id = artist.artist_id
group by 1,2,3,4
order by total_spent desc
limit 1;


 
/*
Q2: we want to find most popular music genre for each country. we determine
most popular genre as the genre with highest amount of purchases. write query that 
return each country along with the top genre. for the countries where maximum 
number of purchases is shared return all genres.*/
--Ans
with cte AS(
select invoice.billing_country, count(invoice.invoice_id) total_purchases , g.name genre,
ROW_NUMBER() OVER(PARTITION BY invoice.billing_country ORDER BY count(invoice.invoice_id) DESC) AS rn
 from invoice 
 join invoice_line il on invoice.invoice_id = il.invoice_id
 join track t on il.track_id = t.track_id
 join genre g on t.genre_id = g.genre_id
group by 1,3 
order by 1 ASC, 2 DESC
 )
 select *from cte where rn <= 1
  
  --------------OR 
  ---Using "RECURSIVE"
 with RECURSIVE 
 countrywise_sales AS (
select invoice.billing_country billing_country, count(invoice.invoice_id) sales_per_genre, g.name genre
  from invoice 
 join invoice_line il on invoice.invoice_id = il.invoice_id
 join track t on il.track_id = t.track_id
 join genre g on t.genre_id = g.genre_id
group by 1,3 
order by 1 ASC
 ),
  max_genre_sales AS(
  select max(sales_per_genre) max_sales_per_genre, billing_country
	  from countrywise_sales
	  group by 2
	  order by 2
  )
  select *
  from countrywise_sales
  join max_genre_sales on countrywise_sales.billing_country = max_genre_sales.billing_country
  where max_genre_sales.max_sales_per_genre=countrywise_sales.sales_per_genre
  
  
  
/*
Q3: write query that determines the customer that has spent the most on music for
each country. write a query that returns the country along with top customer and 
how much they spent? for countries where top amount spent is shared, provide all 
customers who spent this amount. */
--Ans

with RECURSIVE 
customer_spent AS(
	select customer.customer_id, customer.first_name, customer.last_name,
	customer.country country, sum(invoice.total) total_spent
	from customer 
	join invoice on customer.customer_id = invoice.customer_id
	group by 1,4
	order by 4
),
top_in_country AS(
	select max(total_spent) max_spent_on_music, country
	from customer_spent
	group by 2
	order by 2
)
	select customer_id,customer_spent.country, first_name,last_name,  max_spent_on_music
	from top_in_country
	join customer_spent on top_in_country.country = customer_spent.country
	where top_in_country.max_spent_on_music= customer_spent.total_spent
	order by 
