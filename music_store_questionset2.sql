/*Q1: write the query to return emails, first name, last name & genre of
all rock music listeners. renurn your list ordered alphabetically by email 
starting A */

--Ans: 
select DISTINCT email, 
				first_name, 
				last_name
				 
from customer
join invoice on customer.customer_id = invoice.customer_id
join invoice_line on invoice.invoice_id = invoice_line.invoice_id
Where track_id IN(
		select track_id from track
		join genre on track.genre_id = genre.genre_id
		where genre.name like 'Rock'
)
order by email desc

						--OR -----------------------

select DISTINCT email, 
				first_name, 
				last_name
				 
from customer
join invoice on customer.customer_id = invoice.customer_id
join invoice_line on invoice.invoice_id = invoice_line.invoice_id
join track on invoice_line.track_id = track.track_id
join genre on track.genre_id = genre.genre_id
 where genre.name = 'Rock'
 order by email ;


/*
Q2: lets invite the artist who have written the most rock music in our dataset.
write a query that returns the artist name & total track count of the top 10 
rock band?
*/
--Ans:
select artist.name artist_name, count(track.name) total_rock_track
from artist
join album on artist.artist_id = album.artist_id
join track on album.album_id = track.album_id
join genre on track.genre_id = genre.genre_id
where genre.name = 'Rock'
group by artist_name
order by total_rock_track desc
limit 10 ;

/*
Q3: return all song names that ahve longer than the average song length. 
return the name and milliseconds for each song. order by the song length
with the longest song listed first.
*/
--Ans:

select name, milliseconds 
 from track
 where milliseconds > 
 (select AVG(milliseconds) avg_track_len
  from track)
 order by milliseconds desc;

						--OR ------------------

(select AVG(milliseconds) avg_track_len
  from track) 
  --393599.212103910933
  
select name, milliseconds 
 from track
 where milliseconds > 393599.212103910933
 
 order by milliseconds desc;






