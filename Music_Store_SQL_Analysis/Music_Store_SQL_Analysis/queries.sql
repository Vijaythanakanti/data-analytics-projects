
-- 1. Who is the senior most employee based on job title? 

select first_name,last_name,title
from employee
where levels="L6"
order by hire_date desc;

-- 2. Which countries have the most Invoices?
select * from invoice;
select billing_country, count(invoice_id) as invoice_Count
from invoice
group by billing_country
order by invoice_Count desc;

-- 3. What are the top 3 values of total invoice?
select total from invoice
order by total desc
limit 3;

-- 4. Which city has the best customers? - We would like to throw a promotional Music Festival in the city we made the most money. 
-- Write a query that returns one city that has the highest sum of invoice totals. Return both the city name & sum of all invoice totals

select billing_city,sum(total) total_rev
from invoice
group by billing_city 
order by total_rev desc limit 1;

-- 5. Who is the best customer? - The customer who has spent the most money will be declared the best customer. 
-- Write a query that returns the person who has spent the most money
select c.customer_id,c.first_name,c.last_name,sum(i.total)total_spent from customer c
join invoice i on c.customer_id=i.customer_id
group by c.customer_id,c.first_name,c.last_name
order by total_spent desc
limit 1;

-- 6. Write a query to return the email, first name, last name, & Genre of all Rock Music listeners.
--  Return your list ordered alphabetically by email starting with A
select * from genre;
select c.email,c.first_name,c.last_name,g.name from customer c
join invoice i on c.customer_id=i.customer_id
join invoice_line il on i.invoice_id=il.invoice_id
join track t on il.track_id=t.track_id
join genre g on t.genre_id=g.genre_id
where g.name="Rock"
order by c.email asc;

-- 7. Let's invite the artists who have written the most rock music in our dataset.
--  Write a query that returns the Artist name and total track count of the top 10 rock bands 
select * from track;
select a.name artist_name,count(t.track_id)total_track_count from artist a 
join album al on a.artist_id=al.artist_id
join track t on al.album_id=t.album_id
join genre g on t.genre_id=g.genre_id
where g.name="Rock"
group by a.name
order by total_track_count desc
limit 10;


-- 8. Return all the track names that have a song length longer than the average song length.
-- Return the Name and Milliseconds for each track. Order by the song length, with the longest songs listed first
select name,milliseconds from track
where milliseconds >(select avg(milliseconds)from track)
order by milliseconds desc; 

-- 9. Find how much amount is spent by each customer on artists? Write a query to return customer name, artist name and total spent 
select c.first_name,c.last_name,a.name as artist_name,sum(il.unit_price * il.quantity) total_spent from customer c
join invoice i on c.customer_id=i.customer_id
join invoice_line il on i.invoice_id=il.invoice_id
join track t on il.track_id=t.track_id
join album al on t.album_id=al.album_id
join artist a on al.artist_id=a.artist_id
group by c.first_name,c.last_name,a.name
order by total_spent desc;

-- 10. We want to find out the most popular music Genre for each country. 
-- We determine the most popular genre as the genre with the highest amount of purchases. 
-- Write a query that returns each country along with the top Genre. 
-- For countries where the maximum number of purchases is shared, return all Genres
select country,genre from(
select c.country,g.name genre,
count(*) purchase_count,
rank()over(partition by c.country order by count(*)desc)rnk
from customer c
join invoice i on c.customer_id=i.customer_id
join invoice_line il on i.invoice_id=il.invoice_id
join track t on il.track_id=t.track_id
join genre g on t.genre_id=g.genre_id
group by c.country,g.name) x 
where rnk=1;


-- 11 Write a query that determines the customer that has spent the most on music for each country. 
-- Write a query that returns the country along with the top customer and how much they spent.
--  For countries where the top amount spent is shared, provide all customers who spent this amount

SELECT country, first_name, last_name, total_spent
FROM (SELECT c.country,c.customer_id,c.first_name,c.last_name,
SUM(il.unit_price * il.quantity) AS total_spent,
RANK()OVER(PARTITION BY c.country ORDER BY SUM(il.unit_price * il.quantity) DESC)rnk
FROM customer c 
JOIN invoice i ON c.customer_id = i.customer_id
JOIN invoice_line il ON i.invoice_id = il.invoice_id
GROUP BY c.country,c.customer_id,c.first_name,c.last_name) x
WHERE rnk = 1;
